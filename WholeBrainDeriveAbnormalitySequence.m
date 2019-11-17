function [AbnormalityTimings, AbnormalityTimingsOrdered, SortIndices, AbnormalityOrderedNames, AbnormalitySequence, AbnormalitySequenceTrimmed ] = WholeBrainDeriveAbnormalitySequence(Network, EBM, ProcessedResults)

AbnormalityTimings = ProcessedResults.Parameters.NumTimesteps*ones(size(ProcessedResults.Volumes,1),1);
for i = 1:size(ProcessedResults.Volumes,1)
    temp = find(ProcessedResults.Volumes(i,:) < EBM.ThresholdsVolumes(i));
    if(numel(temp)>0)
        AbnormalityTimings(i,1) = temp(1);
    end
end

[AbnormalityTimingsOrdered,SortIndices] = sort(AbnormalityTimings);
for i = 1:Network.NumNodes
    AbnormalityOrderedNames{i,1} = Network.Names{SortIndices(i)};
    AbnormalitySequence(i,1) = Network.Mapping(SortIndices(i));
end

%Keep only grey matter regions included in EBM
AbnormalitySequenceTrimmed = AbnormalitySequence;
for i = numel(AbnormalitySequenceTrimmed):-1:1
    if(sum(AbnormalitySequenceTrimmed(i) == EBM.GroundTruthSequence) == 0)
        AbnormalitySequenceTrimmed = AbnormalitySequenceTrimmed(AbnormalitySequenceTrimmed ~= AbnormalitySequenceTrimmed(i));
    end
end

end
