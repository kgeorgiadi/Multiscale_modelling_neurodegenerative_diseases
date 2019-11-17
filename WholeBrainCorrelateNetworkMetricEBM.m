function Feature = WholeBrainCorrelateNetworkMetricEBM(AtrophyTimings, Network, EBM, filename, savepdf)
%%
%Ascending order sequence of network metric
[~,SortIndices] = sort(AtrophyTimings);
for i = 1:Network.NumNodes
    AtrophyOrderNames{i,1} = Network.Names{SortIndices(i)};
    AtrophyOrderIndices(i,1) = Network.Mapping(SortIndices(i));
end

%Keep only grey matter regions included in EBM
AtrophyOrderIndicesTrimmed = AtrophyOrderIndices;
for i = numel(AtrophyOrderIndicesTrimmed):-1:1
    if(sum(AtrophyOrderIndicesTrimmed(i) == EBM.GroundTruthSequence) == 0)
        AtrophyOrderIndicesTrimmed = AtrophyOrderIndicesTrimmed(AtrophyOrderIndicesTrimmed ~= AtrophyOrderIndicesTrimmed(i));
    end
end

%Compare atrophy sequences
[Feature.OptimizeMetricAsc, Feature.OptimizeMetric2Asc, Feature.DistanceSequenceAsc, Feature.KendalDistanceSequenceAsc, Feature.DistanceMatrixAsc, Feature.MAEsAsc, Feature.RMSEsAsc, Feature.MAEskAsc, Feature.RMSEskAsc, Feature.MAEmAsc, Feature.RMSEmAsc] = WholeBrainCalculateSequencesErrors(AtrophyOrderIndices, EBM.GroundTruthSequence, EBM.GroundTruthMatrix);
[Feature.OptimizeMetricTrimmedAsc, Feature.OptimizeMetric2TrimmedAsc, Feature.DistanceSequenceTrimmedAsc, Feature.KendalDistanceSequenceTrimmedAsc, Feature.DistanceMatrixTrimmedAsc, Feature.MAEsTrimmedAsc, Feature.RMSEsTrimmedAsc, Feature.MAEskTrimmedAsc, Feature.RMSEskTrimmedAsc, Feature.MAEmTrimmedAsc, Feature.RMSEmTrimmedAsc] = WholeBrainCalculateSequencesErrors(AtrophyOrderIndicesTrimmed, EBM.GroundTruthSequence, EBM.GroundTruthMatrix);
WholeBrainPlotSequenceOnConfusionMatrix(EBM, AtrophyOrderIndices, [filename 'Asc'], savepdf);
%WholeBrainPlotSequenceOnConfusionMatrix(EBM, AtrophyOrderIndicesTrimmed, [filename 'AscTrimmed']);

%%
%Descending order sequence of network metric
[~,SortIndices] = sort(AtrophyTimings,'descend');
for i = 1:Network.NumNodes
    AtrophyOrderNames{i,1} = Network.Names{SortIndices(i)};
    AtrophyOrderIndices(i,1) = Network.Mapping(SortIndices(i));
end

%Keep only grey matter regions included in EBM
AtrophyOrderIndicesTrimmed = AtrophyOrderIndices;
for i = numel(AtrophyOrderIndicesTrimmed):-1:1
    if(sum(AtrophyOrderIndicesTrimmed(i) == EBM.GroundTruthSequence) == 0)
        AtrophyOrderIndicesTrimmed = AtrophyOrderIndicesTrimmed(AtrophyOrderIndicesTrimmed ~= AtrophyOrderIndicesTrimmed(i));
    end
end

%Compare atrophy sequences
[Feature.OptimizeMetricDesc, Feature.OptimizeMetric2Desc, Feature.DistanceSequenceDesc, Feature.KendalDistanceSequenceDesc, Feature.DistanceMatrixDesc, Feature.MAEsDesc, Feature.RMSEsDesc, Feature.MAEskDesc, Feature.RMSEskDesc, Feature.MAEmDesc, Feature.RMSEmDesc] = WholeBrainCalculateSequencesErrors(AtrophyOrderIndices, EBM.GroundTruthSequence, EBM.GroundTruthMatrix);
[Feature.OptimizeMetricTrimmedDesc, Feature.OptimizeMetric2TrimmedDesc, Feature.DistanceSequenceTrimmedDesc, Feature.KendalDistanceSequenceTrimmedDesc, Feature.DistanceMatrixTrimmedDesc, Feature.MAEsTrimmedDesc, Feature.RMSEsTrimmedDesc, Feature.MAEskTrimmedDesc, Feature.RMSEskTrimmedDesc, Feature.MAEmTrimmedDesc, Feature.RMSEmTrimmedDesc] = WholeBrainCalculateSequencesErrors(AtrophyOrderIndicesTrimmed, EBM.GroundTruthSequence, EBM.GroundTruthMatrix);
WholeBrainPlotSequenceOnConfusionMatrix(EBM, AtrophyOrderIndices, [filename 'Desc'], savepdf);
%WholeBrainPlotSequenceOnConfusionMatrix(EBM, AtrophyOrderIndicesTrimmed, [filename 'DescTrimmed']);

end