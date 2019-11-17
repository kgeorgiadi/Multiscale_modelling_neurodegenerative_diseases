function [VariableValueChanges, VariableValueChangesProcessedResults, VariableValueChangesOccured] = WholeBrainConvergenceAnalysis(Network, ProcessedResults, AllParams, EBM, save_path)
numvariables = numel(AllParams.MyInput);
for variablenum = 1:numvariables
    for positive = 0:1:1
        if(positive == 1)
            Positive = true;
        else
            Positive = false;
        end
        text = ['Divergencies' AllParams.DiseaseName num2str(variablenum)];
        if(Positive)
            text = [text 'P'];
        else
            text = [text 'N'];
        end
        FinalValuesProcessedResults = cell(7,1);
        FinalValuesChangesOccurred = true(7,1);
        if(strcmp(AllParams.DiseaseName, 'C9orf72'))
            if(variablenum == 1 && Positive)
                FinalValues = [0.0060; 0.0060; 0.0060; 0.0060; 0.0060; 0.0059; 0.0058];
            elseif(variablenum == 5 && Positive)
                FinalValues = [0;0;0;0;0;0;0];
            elseif(variablenum == 7 && Positive)
                FinalValues = [0;0;0;0;0;0;0];
            elseif(variablenum == 8 && ~Positive)
                FinalValues = [0;0;0;0;0;0;0];
            elseif(variablenum == 11 && ~Positive)
                FinalValues = [0;0;0;0;0;0;0];
            elseif(variablenum == 16 && ~Positive)
                FinalValues = [0.0199; 0.0199; 0.0197; 0.0196; 0.0179; 0.0179; 0.0178];
            elseif(variablenum == 17 && Positive)
                FinalValues = [0.0112; 0.0112; 0.0114; 0.0114; 0.0123; 0.0123; 0.0124];
            elseif(variablenum == 18 && ~Positive)
                FinalValues = [773.1066; 773.1006; 761.9834; 761.9834; 754.9328; 749.1132; 749.1132];
            else
                load([save_path text '.mat'], 'FinalValues', 'FinalValuesChangesOccurred', 'FinalValuesProcessedResults');
            end
        else
            load([save_path text '.mat'], 'FinalValues', 'FinalValuesChangesOccurred', 'FinalValuesProcessedResults');
        end
        NumDivergencies = numel(FinalValues);
        if(variablenum == 1 && positive == 0)
            VariableValueChanges = zeros(2*NumDivergencies+1,numvariables);
            VariableValueChanges(NumDivergencies+1,:) = AllParams.MyInput;
            VariableValueChanges(NumDivergencies+2:end,:) = 1;
            VariableValueChangesProcessedResults = cell(2*NumDivergencies+1,numvariables);
            VariableValueChangesOccured = false(2*NumDivergencies+1,numvariables);
            VariableValueChangesOccured(NumDivergencies+1,:) = true;
        end
        if(Positive)
            VariableValueChanges(NumDivergencies+2:end,variablenum) = FinalValues;
            VariableValueChangesOccured(NumDivergencies+2:end,variablenum) = FinalValuesChangesOccurred;
            for i = 1:numel(FinalValuesProcessedResults)
                VariableValueChangesProcessedResults{NumDivergencies+1+i,variablenum} = FinalValuesProcessedResults{i};
            end
        else
            VariableValueChanges(1:NumDivergencies,variablenum) = flipud(FinalValues);
            VariableValueChangesOccured(1:NumDivergencies,variablenum) = flipud(FinalValuesChangesOccurred);
            for i = 1:numel(FinalValuesProcessedResults)
                VariableValueChangesProcessedResults{i,variablenum} = FinalValuesProcessedResults{numel(FinalValuesProcessedResults)-i+1};
            end
        end
    end
end
for variablenum = 1:numvariables
    VariableValueChangesProcessedResults{NumDivergencies+1,variablenum} = ProcessedResults;
end
% for i = 1:size(VariableValueChanges,1)
%     VariableValueChanges(i,:) = VariableValueChanges(i,:).*AllParams.InputScaling;
% end
%save([save_path 'Divergencies' AllParams.DiseaseName '.mat'], 'VariableValueChanges', 'VariableValueChangesProcessedResults', 'VariableValueChangesOccured');

fprintf('\nDivergence Occured:\n');
fprintf([repmat('%f\t', 1, size(VariableValueChangesOccured, 2)) '\n'], VariableValueChangesOccured')
fprintf('\n');
fprintf('\nDivergence Values:\n');
fprintf([repmat('%f\t', 1, size(VariableValueChanges, 2)) '\n'], VariableValueChanges')
fprintf('\n');

AllFieldNames = fieldnames(ProcessedResults);
for fieldnameidx = 1:numel(AllFieldNames)
    MatrixToWrite = zeros(size(VariableValueChanges));
    fieldname = AllFieldNames{fieldnameidx};
    result1 = contains(fieldname,'sexsex');
    result2 = strcmp(fieldname,'OptimizeMetric');
    result3 = contains(fieldname,'TTNB');
    result4 = contains(fieldname,'ASY');
    if(result1 || result2 || result3 || result4)
        for divergence = 1:size(VariableValueChanges,1)
            for variablenum = 1:numvariables
                if(isfield(VariableValueChangesProcessedResults{divergence, variablenum},fieldname))
                    MatrixToWrite(divergence,variablenum) = VariableValueChangesProcessedResults{divergence, variablenum}.(fieldname);
                end
            end
        end
        fprintf('\n%s:\n', fieldname);
        fprintf([repmat('%f\t', 1, size(MatrixToWrite, 2)) '\n'], MatrixToWrite')
        fprintf('\n');
    end
end



end