function [predictedCondition, shutdownFlag, diagnosticSummary] = classify_fault_mode(currentFeatures, speedFeatures, vibrationFeatures)

currentOverloadRmsThreshold = 7.5;
currentJamRmsThreshold = 12.0;
speedJamThreshold = 600.0;
vibrationOverloadRmsThreshold = 0.70;

isBeltJamDetected = (speedFeatures.Mean < speedJamThreshold) && (currentFeatures.RMS >= currentJamRmsThreshold);
isMotorOverloadDetected = (currentFeatures.RMS >= currentOverloadRmsThreshold) || (vibrationFeatures.RMS >= vibrationOverloadRmsThreshold);

if isBeltJamDetected
    predictedCondition = 'belt_jam';
    shutdownFlag = true;
elseif isMotorOverloadDetected
    predictedCondition = 'motor_overload';
    shutdownFlag = true;
else
    predictedCondition = 'healthy';
    shutdownFlag = false;
end

diagnosticSummary.Condition = predictedCondition;
diagnosticSummary.ShutdownTriggered = shutdownFlag;
diagnosticSummary.MotorCurrentRMS = currentFeatures.RMS;
diagnosticSummary.MotorCurrentPeak = currentFeatures.Peak;
diagnosticSummary.MotorSpeedMean = speedFeatures.Mean;
diagnosticSummary.VibrationRMS = vibrationFeatures.RMS;
diagnosticSummary.VibrationDominantFrequency = vibrationFeatures.DominantFrequency;

end
