function rsq = WholeBrainRSQ(x, y)

p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;
if(sum(y == 0) == numel(y))
    rsq = 0;
end
end
