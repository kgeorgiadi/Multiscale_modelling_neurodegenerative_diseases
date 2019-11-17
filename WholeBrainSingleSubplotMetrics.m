function [RsqTiming, RsqOrder, RsqEBM] = WholeBrainSingleSubplotMetrics(filename, Vector, text, TimingX, OrderX, EBMX, FontSizeAll, width, height, savefigs)

figure('visible','off','Units','centimeters', 'Position',[0 0 width height],'PaperUnits','centimeters','PaperSize',[width height],'PaperPositionMode','auto','InvertHardcopy', 'on','Renderer','painters');
RsqTiming = WholeBrainSubplotMetrics(TimingX, Vector, [1 1 1], FontSizeAll, 'Timesteps', text);
if(savefigs)
    export_fig([filename 'Timings'], '-pdf', '-painters', '-a1', '-q101');
end

figure('visible','off','Units','centimeters', 'Position',[0 0 width height],'PaperUnits','centimeters','PaperSize',[width height],'PaperPositionMode','auto','InvertHardcopy', 'on','Renderer','painters');
RsqOrder = WholeBrainSubplotMetrics(OrderX, Vector, [1 1 1], FontSizeAll, 'Atrophy Order', text);
if(savefigs)
    export_fig([filename 'Order'], '-pdf', '-painters', '-a1', '-q101');
end

figure('visible','off','Units','centimeters', 'Position',[0 0 width height],'PaperUnits','centimeters','PaperSize',[width height],'PaperPositionMode','auto','InvertHardcopy', 'on','Renderer','painters');
RsqEBM = WholeBrainSubplotMetrics(EBMX, Vector, [1 1 1], FontSizeAll, 'Ground Truth Order', text);
if(savefigs)
    export_fig([filename 'EBM'], '-pdf', '-painters', '-a1', '-q101');
end

close all;
end