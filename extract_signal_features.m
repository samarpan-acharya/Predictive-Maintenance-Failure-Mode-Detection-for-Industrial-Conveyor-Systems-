function featureStruct = extract_signal_features(signalData, samplingFrequency)

if nargin < 2 || isempty(samplingFrequency)
    samplingFrequency = 1000;
end

rmsValue = sqrt(mean(signalData .^ 2));
peakAmplitudeValue = max(abs(signalData));

signalLength = length(signalData);
centeredSignal = signalData - mean(signalData);
fourierTransform = fft(centeredSignal);

twoSidedSpectrum = abs(fourierTransform / signalLength);
singleSidedSpectrum = twoSidedSpectrum(1:floor(signalLength / 2) + 1);
singleSidedSpectrum(2:end-1) = 2.0 * singleSidedSpectrum(2:end-1);

frequencySpectrumAxis = (0:floor(signalLength / 2)) * (samplingFrequency / signalLength);

[~, peakFrequencyIndex] = max(singleSidedSpectrum);
dominantFrequencyHz = frequencySpectrumAxis(peakFrequencyIndex);

featureStruct.RMS = rmsValue;
featureStruct.Peak = peakAmplitudeValue;
featureStruct.DominantFrequency = dominantFrequencyHz;
featureStruct.Mean = mean(signalData);

end
