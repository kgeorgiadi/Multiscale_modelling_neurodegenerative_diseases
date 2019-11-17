function WholeBrainPlotSequenceOnConfusionMatrix(EBM, Sequence, filename, savepdf)

Temp = [1-EBM.GroundTruthMatrix ones(size(EBM.GroundTruthMatrix,1),numel(Sequence) - size(EBM.GroundTruthMatrix,2))];

close all;
FontSizeAll=18;
width = size(Temp,2)-6;
height = size(Temp,1)-8;
figure('visible','on','Units','centimeters',...
    'PaperUnits','centimeters', ...
	'PaperSize',[width height], ...
	'PaperPositionMode','manual', ...
	'InvertHardcopy', 'on', ...
    'Position',[0 0 width height],...
    'Renderer','painters');
imagesc(Temp);
set(gca,'FontSize',FontSizeAll)
set(gca,'visible','on');
set(gca,'YTick',1:size(Temp,1));
set(gca,'YTickLabel',EBM.Names);
%set(gca,'XTick',1:size(Temp,2));
xlabel('Event Position','FontSize',FontSizeAll)
set(gcf, 'Color', 'w');
colormap gray;
hold on;
for i = 1:numel(EBM.GroundTruthSequence)
    EBMtoMine = find(EBM.GroundTruthSequence(i) == Sequence);
    if(numel(EBMtoMine) > 0)
        plot(EBMtoMine,i,'rx','MarkerSize',14, 'LineWidth', 4)
        EBMtoMineAll(i,1) = EBMtoMine;
    end
end
hold off;
if(savepdf)
	export_fig(filename, '-pdf', '-painters', '-a1', '-q101')
    savefig(filename);
end
close all;

Temp2 = Temp;
Names2 = EBM.Names;
for i = 1:numel(EBMtoMineAll)
    Temp2(EBMtoMineAll(i),:) = Temp(i,:);
    Names2{EBMtoMineAll(i)} = EBM.Names{i};
end
close all;
FontSizeAll=18;
width = size(Temp2,2)+10;
height = size(Temp2,1);
figure('visible','off','Units','centimeters',...
    'PaperUnits','centimeters', ...
	'PaperSize',[width height], ...
	'PaperPositionMode','manual', ...
	'InvertHardcopy', 'on', ...
    'Position',[0 0 width height],...
    'Renderer','painters');
imagesc(Temp2);
set(gca,'FontSize',FontSizeAll)
set(gca,'visible','on');
set(gca,'YTick',1:size(Temp2,1));
set(gca,'YTickLabel',Names2);
set(gca,'XTick',1:size(Temp2,2));
xlabel('Event Position','FontSize',FontSizeAll)
set(gcf, 'Color', 'w');
colormap gray;
hold on;
for i = 1:size(Temp2,1)
    plot(i,i,'rx','MarkerSize',20, 'LineWidth', 4)
end
% plot(1:size(Temp2,1), 1:size(Temp2,1), 'r-');
hold off;
if(savepdf)
	export_fig([filename 'Mine'], '-pdf', '-painters', '-a1', '-q101')
end
close all;
    
end