function plotFigure = plot_feature_comparison(healthyFeatures, jamFeatures, overloadFeatures, outputFilePath)

if nargin < 4 || isempty(outputFilePath)
    outputFilePath = fullfile('results', 'feature_comparison.png');
end

[outputDir, ~, ~] = fileparts(outputFilePath);
if ~isempty(outputDir) && ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

plotFigure = figure('Color', [1 1 1], 'Position', [100, 100, 1150, 780], 'Visible', 'off');

conditions = {'Healthy', 'Belt Jam', 'Motor Overload'};
orderedCategories = categorical(conditions, conditions);
conditionColors = [0.10, 0.60, 0.25; 0.85, 0.15, 0.15; 0.90, 0.50, 0.05];

currentRmsValues = [healthyFeatures.Current.RMS, jamFeatures.Current.RMS, overloadFeatures.Current.RMS];
currentPeakValues = [healthyFeatures.Current.Peak, jamFeatures.Current.Peak, overloadFeatures.Current.Peak];

speedMeanValues = [healthyFeatures.Speed.Mean, jamFeatures.Speed.Mean, overloadFeatures.Speed.Mean];

vibrationRmsValues = [healthyFeatures.Vibration.RMS, jamFeatures.Vibration.RMS, overloadFeatures.Vibration.RMS];
vibrationPeakValues = [healthyFeatures.Vibration.Peak, jamFeatures.Vibration.Peak, overloadFeatures.Vibration.Peak];

vibrationDomFreqValues = [healthyFeatures.Vibration.DominantFrequency, jamFeatures.Vibration.DominantFrequency, overloadFeatures.Vibration.DominantFrequency];

ax1 = subplot(2, 2, 1);
b1 = bar(orderedCategories, [currentRmsValues; currentPeakValues]', 'grouped');
b1(1).FaceColor = [0.20, 0.45, 0.80];
b1(2).FaceColor = [0.85, 0.35, 0.20];
title('Motor Current Metrics', 'FontSize', 12, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
ylabel('Current (A)', 'Color', [0.2 0.2 0.2]);
legend({'RMS Current', 'Peak Current'}, 'Location', 'northwest');
grid on;
set(ax1, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax2 = subplot(2, 2, 2);
b2 = bar(orderedCategories, speedMeanValues);
b2.FaceColor = 'flat';
b2.CData = conditionColors;
title('Mean Motor Speed', 'FontSize', 12, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
ylabel('Speed (RPM)', 'Color', [0.2 0.2 0.2]);
ylim([0, 1750]);
grid on;
set(ax2, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax3 = subplot(2, 2, 3);
b3 = bar(orderedCategories, [vibrationRmsValues; vibrationPeakValues]', 'grouped');
b3(1).FaceColor = [0.15, 0.65, 0.65];
b3(2).FaceColor = [0.90, 0.45, 0.10];
title('Vibration Amplitude Metrics', 'FontSize', 12, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
ylabel('Acceleration (g)', 'Color', [0.2 0.2 0.2]);
legend({'RMS Vibration', 'Peak Vibration'}, 'Location', 'northwest');
grid on;
set(ax3, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax4 = subplot(2, 2, 4);
b4 = bar(orderedCategories, vibrationDomFreqValues);
b4.FaceColor = 'flat';
b4.CData = [0.10, 0.60, 0.25; 0.85, 0.15, 0.15; 0.90, 0.50, 0.05];
title('Vibration Dominant Frequency (FFT)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
ylabel('Frequency (Hz)', 'Color', [0.2 0.2 0.2]);
ylim([0, 35]);
grid on;
set(ax4, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

sgtitle('Extracted Time & Frequency Feature Comparison Across Operating Conditions', 'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.05 0.05 0.05]);

exportgraphics(plotFigure, outputFilePath, 'Resolution', 300);
close(plotFigure);

end
