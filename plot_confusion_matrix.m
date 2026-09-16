function plotFigure = plot_confusion_matrix(confusionMatrix, classNames, accuracyPercentage, outputFilePath)

if nargin < 4 || isempty(outputFilePath)
    outputFilePath = fullfile('results', 'confusion_matrix.png');
end

[outputDir, ~, ~] = fileparts(outputFilePath);
if ~isempty(outputDir) && ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

plotFigure = figure('Color', [1 1 1], 'Position', [150, 150, 850, 700], 'Visible', 'off');

numClasses = length(classNames);
rowSums = sum(confusionMatrix, 2);
rowSums(rowSums == 0) = 1;
normalizedMatrix = confusionMatrix ./ rowSums;

customMap = [
    0.95, 0.97, 1.00;
    0.80, 0.88, 0.97;
    0.60, 0.77, 0.93;
    0.40, 0.65, 0.88;
    0.20, 0.50, 0.80;
    0.08, 0.38, 0.68;
    0.02, 0.25, 0.50
];

imagesc(confusionMatrix);
colormap(customMap);
c = colorbar;
c.Color = [0.2 0.2 0.2];
c.Label.String = 'Trial Count';
c.Label.FontSize = 11;
c.Label.FontWeight = 'bold';

ax = gca;
ax.XTick = 1:numClasses;
ax.XTickLabel = classNames;
ax.YTick = 1:numClasses;
ax.YTickLabel = classNames;
ax.FontSize = 11;
ax.FontWeight = 'bold';
ax.XColor = [0.1 0.1 0.1];
ax.YColor = [0.1 0.1 0.1];

xlabel('Predicted Condition', 'FontSize', 12, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
ylabel('True Condition', 'FontSize', 12, 'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);
title(sprintf('Fault Detection Confusion Matrix (Overall Accuracy: %.2f%%)', accuracyPercentage), ...
      'FontSize', 13, 'FontWeight', 'bold', 'Color', [0.05 0.05 0.05]);

maxCount = max(confusionMatrix(:));
for i = 1:numClasses
    for j = 1:numClasses
        countValue = confusionMatrix(i, j);
        percentValue = normalizedMatrix(i, j) * 100;
        
        if countValue > (maxCount * 0.5)
            textColor = [1 1 1];
        else
            textColor = [0.05 0.05 0.05];
        end
        
        cellString = sprintf('%d\n(%.1f%%)', countValue, percentValue);
        text(j, i, cellString, 'HorizontalAlignment', 'center', ...
             'VerticalAlignment', 'middle', 'FontSize', 12, 'FontWeight', 'bold', 'Color', textColor);
    end
end

axis square;

exportgraphics(plotFigure, outputFilePath, 'Resolution', 300);
close(plotFigure);

end
