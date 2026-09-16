function [confusionMatrix, classNames, accuracyPercentage, performanceSummary] = evaluate_system_performance(trialsPerCondition)

if nargin < 1 || isempty(trialsPerCondition)
    trialsPerCondition = 100;
end

classNames = {'Healthy', 'Belt Jam', 'Motor Overload'};
conditionKeys = {'healthy', 'belt_jam', 'motor_overload'};
numClasses = length(conditionKeys);

confusionMatrix = zeros(numClasses, numClasses);
samplingFrequency = 1000;
durationSeconds = 2.0;

totalCorrectPredictions = 0;
totalEvaluations = trialsPerCondition * numClasses;

for trueIndex = 1:numClasses
    currentCondition = conditionKeys{trueIndex};
    
    for trial = 1:trialsPerCondition
        [~, currentSig, speedSig, vibSig] = simulate_conveyor_signals(currentCondition, samplingFrequency, durationSeconds);
        
        currentFeat = extract_signal_features(currentSig, samplingFrequency);
        speedFeat = extract_signal_features(speedSig, samplingFrequency);
        vibFeat = extract_signal_features(vibSig, samplingFrequency);
        
        [predictedCondition, shutdownFlag, ~] = classify_fault_mode(currentFeat, speedFeat, vibFeat);
        
        predictedIndex = find(strcmp(conditionKeys, predictedCondition));
        
        confusionMatrix(trueIndex, predictedIndex) = confusionMatrix(trueIndex, predictedIndex) + 1;
        
        if trueIndex == predictedIndex
            totalCorrectPredictions = totalCorrectPredictions + 1;
        end
    end
end

accuracyPercentage = (totalCorrectPredictions / totalEvaluations) * 100.0;

performanceSummary.TotalTrials = totalEvaluations;
performanceSummary.TrialsPerCondition = trialsPerCondition;
performanceSummary.CorrectPredictions = totalCorrectPredictions;
performanceSummary.Accuracy = accuracyPercentage;
performanceSummary.ConfusionMatrix = confusionMatrix;
performanceSummary.ClassNames = classNames;

end
