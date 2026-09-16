clear;
clc;
close all;

samplingFrequency = 1000;
durationSeconds = 2.0;
resultsDirectory = 'results';

if ~exist(resultsDirectory, 'dir')
    mkdir(resultsDirectory);
end

[tH, curH, spdH, vibH] = simulate_conveyor_signals('healthy', samplingFrequency, durationSeconds);
healthyData.timeVector = tH;
healthyData.motorCurrent = curH;
healthyData.motorSpeed = spdH;
healthyData.vibrationSignal = vibH;

[tJ, curJ, spdJ, vibJ] = simulate_conveyor_signals('belt_jam', samplingFrequency, durationSeconds);
jamData.timeVector = tJ;
jamData.motorCurrent = curJ;
jamData.motorSpeed = spdJ;
jamData.vibrationSignal = vibJ;

[tO, curO, spdO, vibO] = simulate_conveyor_signals('motor_overload', samplingFrequency, durationSeconds);
overloadData.timeVector = tO;
overloadData.motorCurrent = curO;
overloadData.motorSpeed = spdO;
overloadData.vibrationSignal = vibO;

healthyFeatures.Current = extract_signal_features(healthyData.motorCurrent, samplingFrequency);
healthyFeatures.Speed = extract_signal_features(healthyData.motorSpeed, samplingFrequency);
healthyFeatures.Vibration = extract_signal_features(healthyData.vibrationSignal, samplingFrequency);

jamFeatures.Current = extract_signal_features(jamData.motorCurrent, samplingFrequency);
jamFeatures.Speed = extract_signal_features(jamData.motorSpeed, samplingFrequency);
jamFeatures.Vibration = extract_signal_features(jamData.vibrationSignal, samplingFrequency);

overloadFeatures.Current = extract_signal_features(overloadData.motorCurrent, samplingFrequency);
overloadFeatures.Speed = extract_signal_features(overloadData.motorSpeed, samplingFrequency);
overloadFeatures.Vibration = extract_signal_features(overloadData.vibrationSignal, samplingFrequency);

[predH, shutH, diagH] = classify_fault_mode(healthyFeatures.Current, healthyFeatures.Speed, healthyFeatures.Vibration);
[predJ, shutJ, diagJ] = classify_fault_mode(jamFeatures.Current, jamFeatures.Speed, jamFeatures.Vibration);
[predO, shutO, diagO] = classify_fault_mode(overloadFeatures.Current, overloadFeatures.Speed, overloadFeatures.Vibration);

disp('========================================================================');
disp('   PREDICTIVE MAINTENANCE & FAULT DETECTION - INDUSTRIAL CONVEYOR       ');
disp('========================================================================');
disp('Representative Single-Run Diagnostic Summary:');
fprintf('  Healthy Run       -> Classified: %-15s | Shutdown Triggered: %s\n', predH, mat2str(shutH));
fprintf('  Belt-Jam Run      -> Classified: %-15s | Shutdown Triggered: %s\n', predJ, mat2str(shutJ));
fprintf('  Motor-Overload Run-> Classified: %-15s | Shutdown Triggered: %s\n\n', predO, mat2str(shutO));

featureTable = table(...
    {'Healthy'; 'Belt Jam'; 'Motor Overload'}, ...
    [healthyFeatures.Current.RMS; jamFeatures.Current.RMS; overloadFeatures.Current.RMS], ...
    [healthyFeatures.Current.Peak; jamFeatures.Current.Peak; overloadFeatures.Current.Peak], ...
    [healthyFeatures.Speed.Mean; jamFeatures.Speed.Mean; overloadFeatures.Speed.Mean], ...
    [healthyFeatures.Vibration.RMS; jamFeatures.Vibration.RMS; overloadFeatures.Vibration.RMS], ...
    [healthyFeatures.Vibration.DominantFrequency; jamFeatures.Vibration.DominantFrequency; overloadFeatures.Vibration.DominantFrequency], ...
    [shutH; shutJ; shutO], ...
    'VariableNames', {'Condition', 'Current_RMS_A', 'Current_Peak_A', 'Speed_Mean_RPM', 'Vib_RMS_g', 'Vib_DomFreq_Hz', 'Shutdown_Flag'});

disp(featureTable);

trialsPerCondition = 100;
disp(['Running Monte Carlo Multi-Trial Validation (', num2str(trialsPerCondition * 3), ' total trials)...']);
[confusionMatrix, classNames, accuracyPercentage, performanceSummary] = evaluate_system_performance(trialsPerCondition);

fprintf('\nOverall System Classification Accuracy: %.2f%%\n', accuracyPercentage);
disp('Confusion Matrix (Rows: True, Columns: Predicted):');
disp(array2table(confusionMatrix, 'RowNames', classNames, 'VariableNames', {'Healthy_Pred', 'BeltJam_Pred', 'Overload_Pred'}));

rawSignalsPlotPath = fullfile(resultsDirectory, 'raw_signals.png');
plot_raw_signals(healthyData, jamData, overloadData, rawSignalsPlotPath);

featureComparisonPlotPath = fullfile(resultsDirectory, 'feature_comparison.png');
plot_feature_comparison(healthyFeatures, jamFeatures, overloadFeatures, featureComparisonPlotPath);

confusionMatrixPlotPath = fullfile(resultsDirectory, 'confusion_matrix.png');
plot_confusion_matrix(confusionMatrix, classNames, accuracyPercentage, confusionMatrixPlotPath);

disp('Plots successfully saved to results directory:');
fprintf('  - %s\n', rawSignalsPlotPath);
fprintf('  - %s\n', featureComparisonPlotPath);
fprintf('  - %s\n', confusionMatrixPlotPath);
disp('========================================================================');
