function EBM = WholeBrainGenerateGroundTruth(Regions, DiseaseName, DiseaseGroundTruthSequence)

NumNodes = numel(Regions.Volumes);
load(['EBM_' DiseaseName '.mat']);
EBM.GroundTruthMatrix = ConfusionMatrix;
EBM.GroundTruthSequence = DiseaseGroundTruthSequence;
for i = 1:size(EBM.GroundTruthSequence,1)
    if(any(EBM.GroundTruthSequence(i,1) == Regions.Mapping))
        EBM.GroundTruthSequence(i,2) = 0;
    else
        EBM.GroundTruthSequence(i,1) = 0;
    end
end
EBM.GroundTruthSequence = max(EBM.GroundTruthSequence,[],2);
EBM.GroundTruthThresholds = VolumeLossRequiredToAbnormality(MaximumLikelihoodOrdering) / 10^9;
EBM.ThresholdsVolumes = zeros(NumNodes,1);
for i = 1:numel(EBM.GroundTruthSequence)
    temp = find(Regions.Mapping == EBM.GroundTruthSequence(i));
    EBM.ThresholdsVolumes(temp) = Regions.Volumes(temp) - EBM.GroundTruthThresholds(i);
    EBM.Names{i,1} = Regions.Names{temp};
end
% a = EBM.ThresholdsVolumes(EBM.ThresholdsVolumes>0);
% b = EBM.ThresholdsVolumesStart(EBM.ThresholdsVolumes>0);
% c = a./b;
% x=b;
% y=c;
% p = polyfit(x,y,2);
% ThresholdPercentagesfit = polyval(p,Regions.Volumes);
% % yfit = polyval(p,x);
% % yresid = y - yfit;
% % SSresid = sum(yresid.^2);
% % SStotal = (length(y)-1) * var(y);
% % rsq = 1 - SSresid/SStotal;
% % figure;
% % scatter(x, y);
% % hold on;
% % plot(x, yfit, 'r');
% % hold off;
% % title(['R^2=' num2str(rsq)])
% 
% %Any regions for which there is no predefined threshold for abnormality,
% %the threshold is set based on above regression
% for i = 1:numel(EBM.ThresholdsVolumes)
%     if(EBM.ThresholdsVolumes(i) == 0)
%         EBM.ThresholdsVolumes(i) = Regions.Volumes(i)*ThresholdPercentagesfit(i);
%     end
% end

for i = 1:numel(Regions.Names)
    brainregion = Regions.Names{i};
    for j = 1:numel(EBM.Names)
        if(strcmp(brainregion, EBM.Names{j}))
            EBM.SortIndices(i,1) = j;
        end
    end
end

end

