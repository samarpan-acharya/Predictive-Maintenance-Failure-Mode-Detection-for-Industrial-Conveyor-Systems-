function plotFigure = plot_raw_signals(healthyData, jamData, overloadData, outputFilePath)

if nargin < 4 || isempty(outputFilePath)
    outputFilePath = fullfile('results', 'raw_signals.png');
end

[outputDir, ~, ~] = fileparts(outputFilePath);
if ~isempty(outputDir) && ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

plotFigure = figure('Color', [1 1 1], 'Position', [80, 80, 1280, 860], 'Visible', 'off');

tH = healthyData.timeVector;
tJ = jamData.timeVector;
tO = overloadData.timeVector;

colorHealthy = [0.10, 0.60, 0.25];
colorJam = [0.85, 0.15, 0.15];
colorOverload = [0.90, 0.50, 0.05];

ax1 = subplot(3, 3, 1);
plot(tH, healthyData.motorCurrent, 'Color', colorHealthy, 'LineWidth', 1.1);
title('Healthy: Motor Current', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
xlabel('Time (s)', 'Color', [0.2 0.2 0.2]); ylabel('Current (A)', 'Color', [0.2 0.2 0.2]);
grid on; ylim([-20, 25]);
set(ax1, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax2 = subplot(3, 3, 2);
plot(tH, healthyData.motorSpeed, 'Color', colorHealthy, 'LineWidth', 1.1);
title('Healthy: Motor Speed', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
xlabel('Time (s)', 'Color', [0.2 0.2 0.2]); ylabel('Speed (RPM)', 'Color', [0.2 0.2 0.2]);
grid on; ylim([0, 1700]);
set(ax2, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax3 = subplot(3, 3, 3);
plot(tH, healthyData.vibrationSignal, 'Color', colorHealthy, 'LineWidth', 1.1);
title('Healthy: Vibration', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
xlabel('Time (s)', 'Color', [0.2 0.2 0.2]); ylabel('Acceleration (g)', 'Color', [0.2 0.2 0.2]);
grid on; ylim([-4, 4]);
set(ax3, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax4 = subplot(3, 3, 4);
plot(tJ, jamData.motorCurrent, 'Color', colorJam, 'LineWidth', 1.1);
title('Belt Jam: Motor Current', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
xlabel('Time (s)', 'Color', [0.2 0.2 0.2]); ylabel('Current (A)', 'Color', [0.2 0.2 0.2]);
grid on; ylim([-25, 25]);
set(ax4, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax5 = subplot(3, 3, 5);
plot(tJ, jamData.motorSpeed, 'Color', colorJam, 'LineWidth', 1.1);
title('Belt Jam: Motor Speed', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
xlabel('Time (s)', 'Color', [0.2 0.2 0.2]); ylabel('Speed (RPM)', 'Color', [0.2 0.2 0.2]);
grid on; ylim([0, 1700]);
set(ax5, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax6 = subplot(3, 3, 6);
plot(tJ, jamData.vibrationSignal, 'Color', colorJam, 'LineWidth', 1.1);
title('Belt Jam: Vibration', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
xlabel('Time (s)', 'Color', [0.2 0.2 0.2]); ylabel('Acceleration (g)', 'Color', [0.2 0.2 0.2]);
grid on; ylim([-4, 4]);
set(ax6, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax7 = subplot(3, 3, 7);
plot(tO, overloadData.motorCurrent, 'Color', colorOverload, 'LineWidth', 1.1);
title('Motor Overload: Current', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
xlabel('Time (s)', 'Color', [0.2 0.2 0.2]); ylabel('Current (A)', 'Color', [0.2 0.2 0.2]);
grid on; ylim([-25, 25]);
set(ax7, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax8 = subplot(3, 3, 8);
plot(tO, overloadData.motorSpeed, 'Color', colorOverload, 'LineWidth', 1.1);
title('Motor Overload: Speed', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
xlabel('Time (s)', 'Color', [0.2 0.2 0.2]); ylabel('Speed (RPM)', 'Color', [0.2 0.2 0.2]);
grid on; ylim([0, 1700]);
set(ax8, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

ax9 = subplot(3, 3, 9);
plot(tO, overloadData.vibrationSignal, 'Color', colorOverload, 'LineWidth', 1.1);
title('Motor Overload: Vibration', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
xlabel('Time (s)', 'Color', [0.2 0.2 0.2]); ylabel('Acceleration (g)', 'Color', [0.2 0.2 0.2]);
grid on; ylim([-4, 4]);
set(ax9, 'Color', 'w', 'XColor', [0.2 0.2 0.2], 'YColor', [0.2 0.2 0.2]);

annotationTitle = sgtitle('Conveyor Belt System: Raw Sensor Signals Across Operating Conditions', 'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.05 0.05 0.05]);

exportgraphics(plotFigure, outputFilePath, 'Resolution', 300);
close(plotFigure);

end
