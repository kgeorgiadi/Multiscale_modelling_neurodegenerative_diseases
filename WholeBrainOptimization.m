function AllOutputs = WholeBrainOptimization(Input, AllParams, Network, EBM)
global NumOptimisationIterations
if(AllParams.ChosenOptimization == 2 || AllParams.ChosenOptimization == 3)
    Input = Input';
end
AllInputs = Input;

for iteratorinputs = 1:size(AllInputs,2)
    Input = AllInputs(:,iteratorinputs);
    
    if(AllParams.ExponentiateOptimizationInput == 1)
        ExpFactor1=17.1180956509583; %This was determined so that the function below will give equal
        %number of samples for each of the regions 0 <-> 1e-6, 1e-6 <-> 1e-5, ..., 1e-1 <-> 1
        ExpFactor2=10.2103403719762; %This was determined so that the function below will give equal
        %number of samples for each of the regions 1e-4 <-> 1e-3, ..., 1e-1 <-> 1
        Input(1) = exp(1+(ExpFactor1-1)*(Input(1)))/exp(ExpFactor1);
        Input(2) = exp(1+(ExpFactor1-1)*(Input(2)))/exp(ExpFactor1);
        Input(17) = exp(1+(ExpFactor1-1)*(Input(17)))/exp(ExpFactor1);
        Input(19) = exp(1+(ExpFactor1-1)*(Input(19)))/exp(ExpFactor1);
        Input(20) = exp(1+(ExpFactor1-1)*(Input(20)))/exp(ExpFactor1);
        Input(21) = exp(1+(ExpFactor1-1)*(Input(21)))/exp(ExpFactor1);
        Input(22) = exp(1+(ExpFactor2-1)*(Input(22)))/exp(ExpFactor2);
    end
    
    if(any(AllParams.InputABound*Input > AllParams.InputBBound))
        AcceptableParameters = false;
    else
        AcceptableParameters = true;
    end
    
    if(AcceptableParameters)
        Input            = Input.*AllParams.InputScaling;
        disp(Input);
        AllParams        = WholeBrainOptimizationPassParameters(Input, AllParams);
        Parameters       = WholeBrainParameters(Network, AllParams);
        Results          = WholeBrainRunSimulation(Network, Parameters, EBM);
        ProcessedResults = WholeBrainProcessResults(Network, Results, EBM, Parameters);
        
        if(Parameters.Metric == 1)
            Output = ProcessedResults.OptimizeMetricTrimmed;
        elseif(Parameters.Metric == 2)
            Output = ProcessedResults.OptimizeMetric2Trimmed;
        elseif(Parameters.Metric == 3)
            Output = ProcessedResults.OptimizeMetric;
        elseif(Parameters.Metric == 4)
            Output = ProcessedResults.OptimizeMetric2;
        elseif(Parameters.Metric == 5)
            Output = ProcessedResults.MAEsk;
        elseif(Parameters.Metric == 6)
            Output = ProcessedResults.RMSEsk;
        end
        
        LL = ProcessedResults.OptimizeMetricTrimmed;
        KT = ProcessedResults.KendallTau;
        NumOptimisationIterations = NumOptimisationIterations + 1;
        
        dlmwrite('OptimisationIterations.csv',[NumOptimisationIterations LL KT ProcessedResults.TTNB Input'],'delimiter',',','-append', 'precision', '%.20f');
        
        disp(Input);
        disp(Output);
        disp(ProcessedResults.TTNB);
        
        load('GPS.mat', 'OptimalValues', 'OptimalParameterSets', 'OptimalSequence', 'OptimalSequenceTrimmed');
        if(Output < OptimalValues(AllParams.ModelIndex))
            ProcessedResults = WholeBrainPlotResultsSingleSimulation(Network, ProcessedResults, EBM, AllParams, false);
            fprintf('%f\n', Output);
            OptimalValues(AllParams.ModelIndex) = Output;
            OptimalParameterSets{AllParams.ModelIndex} = Input;
            OptimalSequence{AllParams.ModelIndex} = ProcessedResults.AbnormalitySequence;
            OptimalSequenceTrimmed{AllParams.ModelIndex} = ProcessedResults.AbnormalitySequenceTrimmed;
            save('GPS.mat', 'OptimalValues', 'OptimalParameterSets', 'OptimalSequence', 'OptimalSequenceTrimmed');
        end
    else
        Output = 10^10;
        for i = 1:numel(AllParams.InputBBound)
            numvarsbounded = sum(AllParams.InputABound(i,:) ~= 0);
            parsum = AllParams.InputABound(i,:)*Input;
            if(parsum > AllParams.InputBBound(i))
                Output = Output + 10^(10+5*(parsum/numvarsbounded));
            end
        end
    end
    if(isnan(Output) || isinf(Output) || Output < 0 || iscomplex(Output))
        Input
        AcceptableParameters
    end
    AllOutputs(iteratorinputs,1) = Output;
end

end