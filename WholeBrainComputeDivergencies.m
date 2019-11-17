function WholeBrainComputeDivergencies(variablenum, Positive, Network, ProcessedResults, AllParams, EBM)
save_path = AllParams.save_path;
NumDivergencies = 7;
Tolerance = 1e-8;
OptimalAllParams = AllParams;
OptimalProcessedResults = ProcessedResults;
OptimalAbnormalitySequence = OptimalProcessedResults.AbnormalitySequence;
NumEvents = numel(OptimalAbnormalitySequence);
Startingvalue = OptimalAllParams.MyInput(variablenum);

[FinalValues, FinalValuesChangesOccurred, FinalValuesProcessedResults] = WholeBrainDivergencies(Startingvalue, variablenum, Positive, NumDivergencies, Tolerance, NumEvents, OptimalAllParams, Network, EBM, OptimalAbnormalitySequence);

text = ['Divergencies' AllParams.DiseaseName num2str(variablenum)];
if(Positive)
    text = [text 'P'];
else
    text = [text 'N'];
end
save([save_path text '.mat'], 'FinalValues', 'FinalValuesChangesOccurred', 'FinalValuesProcessedResults');
end