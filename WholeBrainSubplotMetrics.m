function rsq = WholeBrainSubplotMetrics(x, y, subplotindices, FontSizeAll, xlabeltext, ylabeltext)

p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;
if(sum(y == 0) == numel(y))
    rsq = 0;
end
subplot(subplotindices(1),subplotindices(2),subplotindices(3));
scatter(x, y, 100, '.');
set(gca,'FontSize',FontSizeAll)
hold on;
plot(x, yfit, 'r');
hold off;
title(['R^2=' num2str(rsq)],'FontSize',FontSizeAll)
xlabel(xlabeltext,'FontSize',FontSizeAll)
ylabel(ylabeltext,'FontSize',FontSizeAll)

end
