function [timeVector, motorCurrent, motorSpeed, vibrationSignal] = simulate_conveyor_signals(operatingCondition, samplingFrequency, durationSeconds)

if nargin < 2 || isempty(samplingFrequency)
    samplingFrequency = 1000;
end

if nargin < 3 || isempty(durationSeconds)
    durationSeconds = 2.0;
end

totalSamples = round(samplingFrequency * durationSeconds);
timeVector = linspace(0, durationSeconds, totalSamples);

lineFrequency = 50;
nominalMotorRpm = 1500;
nominalCurrentRms = 5.0;
nominalVibrationAmplitude = 0.25;

electricalAngularVelocity = 2 * pi * lineFrequency;
rotationalFrequency = nominalMotorRpm / 60;

randomNoiseCurrent = 0.15 * randn(1, totalSamples);
randomNoiseSpeed = 4.0 * randn(1, totalSamples);
randomNoiseVibration = 0.04 * randn(1, totalSamples);

switch lower(operatingCondition)
    case 'healthy'
        currentAmplitude = nominalCurrentRms * sqrt(2);
        motorCurrent = currentAmplitude * sin(electricalAngularVelocity * timeVector) + randomNoiseCurrent;
        
        motorSpeed = nominalMotorRpm + 8.0 * sin(2 * pi * 2.0 * timeVector) + randomNoiseSpeed;
        
        vibrationSignal = nominalVibrationAmplitude * sin(2 * pi * rotationalFrequency * timeVector) + ...
                          0.08 * sin(2 * pi * 2.0 * rotationalFrequency * timeVector) + ...
                          randomNoiseVibration;

    case 'belt_jam'
        jamEventTime = 0.35 * durationSeconds;
        isJamActive = timeVector >= jamEventTime;
        
        currentSurgeProfile = ones(1, totalSamples);
        jamTimeSpan = timeVector(isJamActive) - jamEventTime;
        currentSurgeProfile(isJamActive) = 1.0 + 3.2 * (1 - exp(-jamTimeSpan / 0.15));
        
        currentAmplitude = nominalCurrentRms * sqrt(2) * currentSurgeProfile;
        motorCurrent = currentAmplitude .* sin(electricalAngularVelocity * timeVector) + 0.35 * randn(1, totalSamples);
        
        motorSpeed = nominalMotorRpm * ones(1, totalSamples) + randomNoiseSpeed;
        motorSpeed(isJamActive) = nominalMotorRpm * exp(-jamTimeSpan / 0.08) + 12.0 * randn(1, sum(isJamActive));
        motorSpeed(motorSpeed < 0) = 0;
        
        jamShockVibration = zeros(1, totalSamples);
        jamShockVibration(isJamActive) = 3.2 * sin(2 * pi * 9.0 * jamTimeSpan) .* exp(-jamTimeSpan / 0.30);
        
        vibrationSignal = nominalVibrationAmplitude * sin(2 * pi * rotationalFrequency * timeVector) + ...
                          jamShockVibration + 0.25 * randn(1, totalSamples);

    case 'motor_overload'
        overloadedCurrentRms = 10.8;
        currentAmplitude = overloadedCurrentRms * sqrt(2);
        motorCurrent = currentAmplitude * sin(electricalAngularVelocity * timeVector) + ...
                       0.85 * sin(3.0 * electricalAngularVelocity * timeVector) + ...
                       0.25 * randn(1, totalSamples);
        
        motorSpeed = 1270 + 15.0 * sin(2 * pi * 3.0 * timeVector) + 1.8 * randomNoiseSpeed;
        
        overloadedRotationalFrequency = 1270 / 60;
        vibrationSignal = 1.15 * sin(2 * pi * overloadedRotationalFrequency * timeVector) + ...
                          0.75 * sin(2 * pi * 2.0 * overloadedRotationalFrequency * timeVector) + ...
                          0.45 * sin(2 * pi * 3.0 * overloadedRotationalFrequency * timeVector) + ...
                          0.20 * randn(1, totalSamples);

    otherwise
        error('Invalid operating condition specified.');
end

end
