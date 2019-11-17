function ProcessedResults = WholeBrainProcessResults(Network, Results, EBM, Parameters)
ProcessedResults = Results;
ProcessedResults.NumNodes = Network.NumNodes;
ProcessedResults.Parameters = Parameters;

%%
%Get atrophy sequence
[ProcessedResults.AbnormalityTimings, ProcessedResults.AbnormalityTimingsOrdered, ProcessedResults.SortIndices, ProcessedResults.AbnormalityOrderedNames, ProcessedResults.AbnormalitySequence, ProcessedResults.AbnormalitySequenceTrimmed ] = WholeBrainDeriveAbnormalitySequence(Network, EBM, ProcessedResults);

%Compare atrophy sequences
[ProcessedResults.OptimizeMetric, ProcessedResults.OptimizeMetric2, ProcessedResults.DistanceSequence, ProcessedResults.KendalDistanceSequence, ProcessedResults.DistanceMatrix, ProcessedResults.MAEs, ProcessedResults.RMSEs, ProcessedResults.MAEsk, ProcessedResults.RMSEsk, ProcessedResults.MAEm, ProcessedResults.RMSEm, ProcessedResults.KendallTau] = WholeBrainCalculateSequencesErrors(ProcessedResults.AbnormalitySequence, EBM.GroundTruthSequence, EBM.GroundTruthMatrix);
[ProcessedResults.OptimizeMetricTrimmed, ProcessedResults.OptimizeMetric2Trimmed, ProcessedResults.DistanceSequenceTrimmed, ProcessedResults.KendalDistanceSequenceTrimmed, ProcessedResults.DistanceMatrixTrimmed, ProcessedResults.MAEsTrimmed, ProcessedResults.RMSEsTrimmed, ProcessedResults.MAEskTrimmed, ProcessedResults.RMSEskTrimmed, ProcessedResults.MAEmTrimmed, ProcessedResults.RMSEmTrimmed, ProcessedResults.KendallTauTrimmed] = WholeBrainCalculateSequencesErrors(ProcessedResults.AbnormalitySequenceTrimmed, EBM.GroundTruthSequence, EBM.GroundTruthMatrix);

ProcessedResults.TTNB = max(ProcessedResults.AbnormalityTimings);
ProcessedResults.ASY  = max(std(Results.Atrophy));

%Determine Seeds
ProcessedResults.Seeds = Parameters.Seedlocation;
ProcessedResults.SeedsSize = Parameters.Seed(ProcessedResults.Seeds);
for i = 1:numel(ProcessedResults.Seeds)
    ProcessedResults.SeedsNames{i,1} = Network.Names{ProcessedResults.Seeds(i)};
    ProcessedResults.SeedsMapped(i,1) = Network.Mapping(ProcessedResults.Seeds(i));
end

end