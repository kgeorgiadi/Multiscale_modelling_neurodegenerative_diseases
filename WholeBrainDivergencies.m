function [FinalValues, FinalValuesChangesOccurred, FinalValuesProcessedResults] = WholeBrainDivergencies(Startingvalue, variablenum, Positive, NumDivergencies, Tolerance, NumEvents, OptimalAllParams, Network, EBM, OptimalAbnormalitySequence)
FinalValues = zeros(NumDivergencies,1);
FinalValuesChangesOccurred = false(NumDivergencies,1);
FinalValuesProcessedResults = cell(NumDivergencies,1);

for divergencenum = 1:NumDivergencies
    if(divergencenum == 1)
        Value = Startingvalue;
    else
        Value = FinalValues(divergencenum-1);
    end
    Convergence_Threshold = 1-1e3*eps - (divergencenum-1)/NumEvents;
    
    
    ChangeInValue = 0;
    firstiter = true;
    CrossedOnce = false;
    PreviouslyDivergence = false;
    while(true)
        fprintf('.');
        Value            = Value + ChangeInValue;
        AllParams        = OptimalAllParams;
        AllParams.MyInput(variablenum) = Value;
        Input            = AllParams.MyInput;
        AllParams        = WholeBrainOptimizationPassParameters(Input, AllParams);
        Parameters       = WholeBrainParameters(Network, AllParams);
        Results          = WholeBrainRunSimulation(Network, Parameters, EBM);
        ProcessedResults = WholeBrainProcessResults(Network, Results, EBM, Parameters);
        
        TestAbnormalitySequence = ProcessedResults.AbnormalitySequence;
        Convergence             = WholeBrainComputeConvergence(OptimalAbnormalitySequence, TestAbnormalitySequence, Convergence_Threshold);
        if(Convergence > 1/NumEvents)
            DivergenceOccured = true;
            FinalValuesChangesOccurred(divergencenum) = true;
        else
            DivergenceOccured = false;
        end
        Crossed = DivergenceOccured ~= PreviouslyDivergence;
        PreviouslyDivergence = DivergenceOccured;
        
        if(firstiter)
            if(DivergenceOccured)
                break;
            else
                if(Positive)
                    ChangeInValue = 1e-7;
                else
                    ChangeInValue = -1e-7;
                end
                firstiter = false;
            end
        else
            if(Crossed)
                ChangeInValue = -ChangeInValue/2;
                CrossedOnce = true;
            else
                if(CrossedOnce)
                    ChangeInValue = 1*ChangeInValue;
                else
                    ChangeInValue = 2*ChangeInValue;
                end
            end
        end
        
        if(Value + ChangeInValue > AllParams.InputScaling(variablenum))
            ChangeInValue = AllParams.InputScaling(variablenum)-Value;
        end
        if(Value + ChangeInValue < 0)
            ChangeInValue = -Value;
        end
        if(FinalValuesChangesOccurred(divergencenum))
            if(DivergenceOccured && abs(ChangeInValue) < Tolerance)
                break;
            end
        else
            if(abs(ChangeInValue) < Tolerance)
                break;
            end
        end
        
    end
    FinalValues(divergencenum) = Value
    %ProcessedResults = WholeBrainPlotResultsSingleSimulation(Network, ProcessedResults, EBM, AllParams, false);
    FinalValuesProcessedResults{divergencenum} = ProcessedResults;
end



end


