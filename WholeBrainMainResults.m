% Experiments:
% 1) Find different parameters for different diseases - AD + FTD from Alex - make conclusions, - summarise optimal parameter result
% 2) Explanation of different parameters based on literature
% 3) Identify epicentres of diseases
% 4) Figures of confusion matrix
% 5) Correlations of R/Z BOLD/Synaptic, S/L DTI, N/S/L DCM, euclidean, volume with EBM ORDER
% 6) Correlations of SSG, GDS, structural,functional, effective, euclidean connectivity, etc. with atrophy/atrophy order

% 7) Convergence matrix - after finding optimal parameters, alter one
% parameter at a time and see how it affects convergence - start slow and
% keep altering till there is a single difference in the order, then 2
% differences, then 3, etc
% 8) After finding optimal parameters, alter one parameter at a time and
% see how it affects the cost function fit value, GDS R^2, SSG R^2, ASY,
% TTNB, etc.
% 9) drug therapies, and simulate their effect - find timepoint at which AD is diagnosed and determine the result of candidate therapies


%Initialization
clear; close all; clc;
rng('shuffle');

AllProcessedResults = cell(4,1);
for filetoload = 1:4
    if(filetoload == 1)
        ParameterSetFilename = 'AD.mat';
    elseif(filetoload == 2)
        ParameterSetFilename = 'C9orf72.mat';
    elseif(filetoload == 3)
        ParameterSetFilename = 'GRN.mat';
    elseif(filetoload == 4)
        ParameterSetFilename = 'MAPT.mat';
    end
    AllParams = WholeBrainInitializationResults(ParameterSetFilename);
    
    %Load imaging data
    [Network, EBM] = WholeBrainLoadImages(AllParams);
    %Order based on network metrics - correlation with EBM order
    %NetworkMetricsCorrelations = WholeBrainCorrelateNetworkMetricsEBM(Network, EBM, AllParams, true);
    %WholeBrainPrintBestEBMConnectivityCorrelations(NetworkMetricsCorrelations, 10);

    Input            = AllParams.MyInput;
    AllParams        = WholeBrainOptimizationPassParameters(Input, AllParams);
    Parameters       = WholeBrainParameters(Network, AllParams);
%     Parameters.NEURONDamageThresholdExists = false;
%     
%     MyInput = [Parameters.Seedsize
%     Parameters.ExtracellularDiffusionFraction
%     Parameters.ExtracellularDiffusionSpeed
%     Parameters.NetworkDiffusionWeightFractionFMRI
%     Parameters.NetworkDiffusionWeightFractionDTI
%     Parameters.NetworkDiffusionWeightFractionDCM
%     Parameters.NetworkDiffusionWeightDistanceFractionFMRI
%     Parameters.NetworkDiffusionWeightDistanceFractionDTI
%     Parameters.NetworkDiffusionWeightDistanceFractionDCM
%     Parameters.SynapticTransferWeightFractionFMRI
%     Parameters.SynapticTransferWeightFractionDTI
%     Parameters.SynapticTransferWeightFractionDCM
%     Parameters.SynapticTransferWeightDistanceFractionFMRI
%     Parameters.SynapticTransferWeightDistanceFractionDTI
%     Parameters.SynapticTransferWeightDistanceFractionDCM
%     Parameters.NetworkDiffusionSpeed
%     Parameters.NEURONMisfold
%     Parameters.NEURONDiffusionSpeed / 1000
%     Parameters.NEURONDiffusion
%     Parameters.NEURONTransport
%     Parameters.NEURONSynaptic
%     Parameters.NEURONDamage];
%     
%     LBound = zeros(size(MyInput));
%     UBound = ones(size(MyInput));
%     
%     
%     options = optimoptions('patternsearch', ...
%         'MeshTolerance', 1e-6, ...
%         'MeshExpansionFactor', 1e2, ...
%         'FunctionTolerance', 1e-15, ...
%         'InitialMeshSize', 0.5, ...
%         'UseCompletePoll', true, ...
%         'UseParallel', false, ...
%         'MaxTime', 60*60*24*100, ...
%         'Display', 'iter');
%     FitnessFunction = @(Input) WholeBrainRefining(Input, Parameters, Network, EBM);
%     [OptimalParameters, OptimalValue, exitflag, info] = patternsearch(FitnessFunction, MyInput, [], [], [], [], LBound, UBound, [], options);
    
    Results          = WholeBrainRunSimulation(Network, Parameters, EBM);
    ProcessedResults = WholeBrainProcessResults(Network, Results, EBM, Parameters);
    ProcessedResults = WholeBrainPlotResultsSingleSimulation(Network, ProcessedResults, EBM, AllParams, true);
    
    %AllProcessedResults{filetoload} = ProcessedResults;
    %[VariableValueChanges, VariableValueChangesProcessedResults, VariableValueChangesOccured] = WholeBrainConvergenceAnalysis(Network, ProcessedResults, AllParams, EBM, AllParams.save_path);
end
%CombinedScalePrintStuffAllTogether(AllProcessedResults);








