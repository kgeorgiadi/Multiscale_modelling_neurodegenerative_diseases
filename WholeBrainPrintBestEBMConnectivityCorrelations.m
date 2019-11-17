function WholeBrainPrintBestEBMConnectivityCorrelations(NetworkMetricsCorrelations, ThresholdAt)
AllVals = [];
AllNames = cell(0);
fieldsNetworkMetricsCorrelations = fieldnames(NetworkMetricsCorrelations);
DiseaseName = NetworkMetricsCorrelations.DiseaseName;
for fieldnum = 3:numel(fieldsNetworkMetricsCorrelations)-2
    fieldname = fieldsNetworkMetricsCorrelations{fieldnum};
    temp = NetworkMetricsCorrelations.(fieldname);
    for seednum = 1:numel(temp)
        seedname = NetworkMetricsCorrelations.SeedName{seednum};
        if(~isempty(seedname))
            temp2 = temp{seednum};
            fieldstemp2 = fieldnames(temp2);
            for field2num = 1:numel(fieldstemp2)
                field2name = fieldstemp2{field2num};
                valasc = temp2.(field2name).OptimizeMetricAsc;
                AllVals = [AllVals; valasc];
                AllNames{numel(AllNames)+1} = [DiseaseName ' ' fieldname ' ' seedname ' ' field2name ' asc'];
                valdesc = temp2.(field2name).OptimizeMetricDesc;
                AllVals = [AllVals; valdesc];
                AllNames{numel(AllNames)+1} = [DiseaseName ' ' fieldname ' ' seedname ' ' field2name ' desc'];
            end
        end
    end
end
for fieldnum = numel(fieldsNetworkMetricsCorrelations)-1:numel(fieldsNetworkMetricsCorrelations)
    fieldname = fieldsNetworkMetricsCorrelations{fieldnum};
    temp = NetworkMetricsCorrelations.(fieldname);
    for seednum = 1:numel(temp)
        seedname = NetworkMetricsCorrelations.SeedName{seednum};
        if(~isempty(seedname))
            temp2 = temp{seednum};
            field2name = 'normal';
            valasc = temp2.OptimizeMetricAsc;
            AllVals = [AllVals; valasc];
            AllNames{numel(AllNames)+1} = [DiseaseName ' ' fieldname ' ' seedname ' ' field2name ' asc'];
            valdesc = temp2.OptimizeMetricDesc;
            AllVals = [AllVals; valdesc];
            AllNames{numel(AllNames)+1} = [DiseaseName ' ' fieldname ' ' seedname ' ' field2name ' desc'];
        end
    end
end
AllValsSorted = sort(AllVals);
ThresholdVal = AllValsSorted(ThresholdAt);
for i = 1:numel(AllVals)
    if(AllVals(i) <= ThresholdVal+1)
        fprintf('%.0f %s\n', AllVals(i), AllNames{i});
    end
end

end