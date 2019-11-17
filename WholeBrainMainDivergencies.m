clear; close all; clc;
rng('shuffle');
%%%%%%%%%%%%%%%%%%%%
%first need to create AD.dat, C9orf72.dat GRN.dat, MAPT.dat where its basically the modelling and the normal optimal parameters
%make sure the AllParams.InputScaling is taken into account
%also might need to update AllParams.DiseaseGroundTruthSequence for each
%disease
%%%%%%%%%%%%%%%%%%%%
temp = dlmread('ParameterSet.dat');
filetoload = temp(1);
variabletodiverge = temp(2);
positive = temp(3);

filetoload = 1;
variabletodiverge = 1;
positive = 1;

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

Input            = AllParams.MyInput;
AllParams        = WholeBrainOptimizationPassParameters(Input, AllParams);
Parameters       = WholeBrainParameters(Network, AllParams);
Results          = WholeBrainRunSimulation(Network, Parameters, EBM);
ProcessedResults = WholeBrainProcessResults(Network, Results, EBM, Parameters);
%ProcessedResults = WholeBrainPlotResultsSingleSimulation(Network, ProcessedResults, EBM,  AllParams, true);

if(positive == 1)
    Positive = true;
elseif(positive == 2)
    Positive = false;
end

WholeBrainComputeDivergencies(variabletodiverge, Positive, Network, ProcessedResults, AllParams, EBM);

dlmwrite('Finished.dat',1,' ');







