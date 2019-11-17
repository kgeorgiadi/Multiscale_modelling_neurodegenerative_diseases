function Results = WholeBrainRunSimulation(Network, Parameters, EBM)
rngstate = rng;
rng(1);
%Allocate memory
Results.Atrophy                 = zeros(Network.NumNodes, Parameters.NumTimesteps);
Results.ConcentrationNormal     = zeros(Network.NumNodes, Parameters.NumTimesteps);
Results.ConcentrationPathogenic = zeros(Network.NumNodes, Parameters.NumTimesteps);
Results.Volumes                 = zeros(Network.NumNodes, Parameters.NumTimesteps);
Results.NormalSpreadExtracellular  = 0;
Results.NormalSpreadWeightFMRI     = 0;
Results.NormalSpreadWeightDTI      = 0;
Results.NormalSpreadWeightDCM      = 0;
Results.NormalSpreadWeightDistanceFMRI     = 0;
Results.NormalSpreadWeightDistanceDTI      = 0;
Results.NormalSpreadWeightDistanceDCM      = 0;
Results.NormalSpreadWeightFreqFMRI     = 0;
Results.NormalSpreadWeightFreqDTI      = 0;
Results.NormalSpreadWeightFreqDCM      = 0;
Results.NormalSpreadWeightDistanceFreqFMRI     = 0;
Results.NormalSpreadWeightDistanceFreqDTI      = 0;
Results.NormalSpreadWeightDistanceFreqDCM      = 0;
Results.PathogenicSpreadExtracellular  = 0;
Results.PathogenicSpreadWeightFMRI     = 0;
Results.PathogenicSpreadWeightDTI      = 0;
Results.PathogenicSpreadWeightDCM      = 0;
Results.PathogenicSpreadWeightDistanceFMRI     = 0;
Results.PathogenicSpreadWeightDistanceDTI      = 0;
Results.PathogenicSpreadWeightDistanceDCM      = 0;
Results.PathogenicSpreadWeightFreqFMRI     = 0;
Results.PathogenicSpreadWeightFreqDTI      = 0;
Results.PathogenicSpreadWeightFreqDCM      = 0;
Results.PathogenicSpreadWeightDistanceFreqFMRI     = 0;
Results.PathogenicSpreadWeightDistanceFreqDTI      = 0;
Results.PathogenicSpreadWeightDistanceFreqDCM      = 0;


%Initialize
Timestep                                    = 1;
Results.Volumes(:,Timestep)                 = Network.Volumes;
Results.ConcentrationNormal(:,Timestep)     = Parameters.InitialConcentrationNormalAll      * ones(Network.NumNodes,1);
Results.ConcentrationPathogenic(:,Timestep) = Parameters.InitialConcentrationPathogenicAll  * ones(Network.NumNodes,1) + Parameters.Seed;

Parameters.ColumnsPerRegion = ceil(15*Network.Volumes/max(Network.Volumes));

NEURONdata = WholeBrainInitialiseNEURONdata(Parameters, Network, Results);

%Data from NEURON
CurrentQuantity.NormalAtOutputs                    = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicAtOutputs                = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalExtracellular                = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicExtracellular            = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightFMRI             = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightDTI              = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightDCM              = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightDistanceFMRI     = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightDistanceDTI      = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightDistanceDCM      = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightFMRI         = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightDTI          = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightDCM          = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightDistanceFMRI = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightDistanceDTI  = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightDistanceDCM  = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightFreqFMRI             = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightFreqDTI              = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightFreqDCM              = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightDistanceFreqFMRI     = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightDistanceFreqDTI      = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.NormalOutputWeightDistanceFreqDCM      = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightFreqFMRI         = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightFreqDTI          = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightFreqDCM          = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightDistanceFreqFMRI = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightDistanceFreqDTI  = zeros(size(Parameters.ColumnsPerRegion));
CurrentQuantity.PathogenicOutputWeightDistanceFreqDCM  = zeros(size(Parameters.ColumnsPerRegion));
PropInputsAlive                                   = zeros(size(Parameters.ColumnsPerRegion));

if(Parameters.Verbose == false)
    dispstat('Running simulation ...', 'keepprev', 'timestamp');NumSecondsPassed = 0;
end

for Timestep = 2:Parameters.NumTimesteps
    %MATLAB to NEURON
    NEURONdata = WholeBrainNEURONGetMATLABInput(NEURONdata, Network);
    %NEURON processing 
    NEURONdata = WholeBrainNEURONProcessing(NEURONdata, Network);
    %NEURON to MATLAB
    MessageFromNEURON = WholeBrainMATLABGetNEURONInput(NEURONdata, Network, Parameters);
%     for r = 1:numel(NEURONdata)
%         fields = fieldnames(NEURONdata{r});
%         for i = 1:numel(fields)
%             if(any(isnan(NEURONdata{r}.(fields{i}))))
%                 r
%                 fields(i)
%                 temp = 0;
%             end
%         end
%     end
%     
    %%
    %Transform NEURON messages to MATLAB form
    for r = 1:numel(Parameters.ColumnsPerRegion)
        Results.Atrophy(r,Timestep)                 = MessageFromNEURON{r}(1);
        Results.ConcentrationNormal(r,Timestep)     = MessageFromNEURON{r}(2);
        Results.ConcentrationPathogenic(r,Timestep) = MessageFromNEURON{r}(3);
        PropInputsAlive(r)                          = MessageFromNEURON{r}(4);
        CurrentQuantity.NormalExtracellular(r)       = MessageFromNEURON{r}(5);
        CurrentQuantity.PathogenicExtracellular(r)   = MessageFromNEURON{r}(6);
        CurrentQuantity.NormalAtOutputs(r)           = MessageFromNEURON{r}(7);
        CurrentQuantity.PathogenicAtOutputs(r)       = MessageFromNEURON{r}(8);
        CurrentQuantity.NormalOutputWeightFMRI(r)             = MessageFromNEURON{r}(9);
        CurrentQuantity.NormalOutputWeightDTI(r)              = MessageFromNEURON{r}(10);
        CurrentQuantity.NormalOutputWeightDCM(r)              = MessageFromNEURON{r}(11);
        CurrentQuantity.NormalOutputWeightDistanceFMRI(r)     = MessageFromNEURON{r}(12);
        CurrentQuantity.NormalOutputWeightDistanceDTI(r)      = MessageFromNEURON{r}(13);
        CurrentQuantity.NormalOutputWeightDistanceDCM(r)      = MessageFromNEURON{r}(14);
        CurrentQuantity.PathogenicOutputWeightFMRI(r)         = MessageFromNEURON{r}(15);
        CurrentQuantity.PathogenicOutputWeightDTI(r)          = MessageFromNEURON{r}(16);
        CurrentQuantity.PathogenicOutputWeightDCM(r)          = MessageFromNEURON{r}(17);
        CurrentQuantity.PathogenicOutputWeightDistanceFMRI(r) = MessageFromNEURON{r}(18);
        CurrentQuantity.PathogenicOutputWeightDistanceDTI(r)  = MessageFromNEURON{r}(19);
        CurrentQuantity.PathogenicOutputWeightDistanceDCM(r)  = MessageFromNEURON{r}(20);
        CurrentQuantity.NormalOutputWeightFreqFMRI(r)             = MessageFromNEURON{r}(21);
        CurrentQuantity.NormalOutputWeightFreqDTI(r)              = MessageFromNEURON{r}(22);
        CurrentQuantity.NormalOutputWeightFreqDCM(r)              = MessageFromNEURON{r}(23);
        CurrentQuantity.NormalOutputWeightDistanceFreqFMRI(r)     = MessageFromNEURON{r}(24);
        CurrentQuantity.NormalOutputWeightDistanceFreqDTI(r)      = MessageFromNEURON{r}(25);
        CurrentQuantity.NormalOutputWeightDistanceFreqDCM(r)      = MessageFromNEURON{r}(26);
        CurrentQuantity.PathogenicOutputWeightFreqFMRI(r)         = MessageFromNEURON{r}(27);
        CurrentQuantity.PathogenicOutputWeightFreqDTI(r)          = MessageFromNEURON{r}(28);
        CurrentQuantity.PathogenicOutputWeightFreqDCM(r)          = MessageFromNEURON{r}(29);
        CurrentQuantity.PathogenicOutputWeightDistanceFreqFMRI(r) = MessageFromNEURON{r}(30);
        CurrentQuantity.PathogenicOutputWeightDistanceFreqDTI(r)  = MessageFromNEURON{r}(31);
        CurrentQuantity.PathogenicOutputWeightDistanceFreqDCM(r)  = MessageFromNEURON{r}(32);
    end
    %% 
    
    %Atrophy and volume change - changes also concentrations
    Results.Volumes(:,Timestep) = Network.Volumes .* (1-Results.Atrophy(:,Timestep));
    Network.Radius = ((3*Results.Volumes(:,Timestep)) / (4 * pi)).^(1/3);
    Network.Alive = (Results.Atrophy(:,Timestep) < 1);
    Network.NumAlive = sum(Network.Alive);
    Network.Abnormal = Results.Volumes(:,Timestep) < EBM.ThresholdsVolumes;
    Network.NumAbnormal = sum(Network.Abnormal);
    if(Parameters.Verbose == false)
        NumSecondsPassed = DisplayCurrentPercentage(Network.NumAbnormal, Network.NumNodes, NumSecondsPassed, ['Running simulation ...']);
    end
    if(Network.NumAbnormal == numel(Network.Abnormal))
        break; %break if all regions have become abnormal
    end
    if(Network.NumAlive == 0)
        break; %break if whole network has atrophied
    end
    if(Timestep == Parameters.NumTimesteps)
        Results.Atrophy(:,Timestep) = 1;
        Results.Volume(:,Timestep) = 0;
    end
    
    %Create Spread matrices
    Network.ExtracellularDiffusionMatrix = WholeBrainCalculateExtracellularDiffusionMatrix(Parameters.ExtracellularDiffusionSpeed, Network.Alive, Network.EuclideanDistances, Network.Radius);
    
    Network.WeightsSpreadMatrixFMRI    = WholeBrainCalculateWeightsSpreadMatrix(Network.RSynapticCorrelationMatrix, PropInputsAlive);
    Network.WeightsSpreadMatrixDTI     = WholeBrainCalculateWeightsSpreadMatrix(Network.DTI, PropInputsAlive);
    Network.WeightsSpreadMatrixDCM     = WholeBrainCalculateWeightsSpreadMatrix(Network.EffectiveConnectivity, PropInputsAlive);
    
    Network.WeightsDiffusionMatrixFMRI = WholeBrainCalculateWeightsDiffusionMatrix(Network.RSynapticCorrelationMatrix, Network.EuclideanDistances, Parameters.NetworkDiffusionSpeed, PropInputsAlive);
    Network.WeightsDiffusionMatrixDTI  = WholeBrainCalculateWeightsDiffusionMatrix(Network.DTI, Network.EuclideanDistances, Parameters.NetworkDiffusionSpeed, PropInputsAlive);
    Network.WeightsDiffusionMatrixDCM  = WholeBrainCalculateWeightsDiffusionMatrix(Network.EffectiveConnectivity, Network.EuclideanDistances, Parameters.NetworkDiffusionSpeed, PropInputsAlive);
    
    %save original matrices
    if(Timestep == 2)
        Results.ExtracellularDiffusionMatrix = Network.ExtracellularDiffusionMatrix;
        
        Results.WeightsSpreadMatrixFMRI   = Network.WeightsSpreadMatrixFMRI;
        Results.WeightsSpreadMatrixDTI    = Network.WeightsSpreadMatrixDTI;
        Results.WeightsSpreadMatrixDCM    = Network.WeightsSpreadMatrixDCM;
        
        Results.WeightsDiffusionMatrixFMRI   = Network.WeightsDiffusionMatrixFMRI;
        Results.WeightsDiffusionMatrixDTI    = Network.WeightsDiffusionMatrixDTI;
        Results.WeightsDiffusionMatrixDCM    = Network.WeightsDiffusionMatrixDCM;
    end
    
    %Calculate required inputs for NEURON
    QuantityAddToColumnInputsNormal          = zeros(size(Parameters.ColumnsPerRegion));
    QuantityAddToColumnInputsMisfolded       = zeros(size(Parameters.ColumnsPerRegion));
    QuantityRemoveFromColumnOutputsNormal    = zeros(size(Parameters.ColumnsPerRegion));
    QuantityRemoveFromColumnOutputsMisfolded = zeros(size(Parameters.ColumnsPerRegion));
    QuantityRemoveFromColumnOutputsNormalFreq    = zeros(size(Parameters.ColumnsPerRegion));
    QuantityRemoveFromColumnOutputsMisfoldedFreq = zeros(size(Parameters.ColumnsPerRegion));
    
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsSpreadMatrixFMRI * CurrentQuantity.NormalOutputWeightFMRI;
    temp = Network.WeightsSpreadMatrixFMRI; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightFMRI = Results.NormalSpreadWeightFMRI + sum(temp * CurrentQuantity.NormalOutputWeightFMRI);
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsSpreadMatrixDTI  * CurrentQuantity.NormalOutputWeightDTI;
    temp = Network.WeightsSpreadMatrixDTI; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightDTI = Results.NormalSpreadWeightDTI + sum(temp * CurrentQuantity.NormalOutputWeightDTI);
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsSpreadMatrixDCM  * CurrentQuantity.NormalOutputWeightDCM;
    temp = Network.WeightsSpreadMatrixDCM; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightDCM = Results.NormalSpreadWeightDCM + sum(temp * CurrentQuantity.NormalOutputWeightDCM);
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsDiffusionMatrixFMRI * CurrentQuantity.NormalOutputWeightDistanceFMRI;
    temp = Network.WeightsDiffusionMatrixFMRI; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightDistanceFMRI = Results.NormalSpreadWeightDistanceFMRI + sum(temp * CurrentQuantity.NormalOutputWeightDistanceFMRI);
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsDiffusionMatrixDTI  * CurrentQuantity.NormalOutputWeightDistanceDTI;
    temp = Network.WeightsDiffusionMatrixDTI; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightDistanceDTI = Results.NormalSpreadWeightDistanceDTI + sum(temp * CurrentQuantity.NormalOutputWeightDistanceDTI);
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsDiffusionMatrixDCM  * CurrentQuantity.NormalOutputWeightDistanceDCM;
    temp = Network.WeightsDiffusionMatrixDCM; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightDistanceDCM = Results.NormalSpreadWeightDistanceDCM + sum(temp * CurrentQuantity.NormalOutputWeightDistanceDCM);
    
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsSpreadMatrixFMRI * CurrentQuantity.PathogenicOutputWeightFMRI;
    temp = Network.WeightsSpreadMatrixFMRI; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightFMRI = Results.PathogenicSpreadWeightFMRI + sum(temp * CurrentQuantity.PathogenicOutputWeightFMRI);
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsSpreadMatrixDTI  * CurrentQuantity.PathogenicOutputWeightDTI;
    temp = Network.WeightsSpreadMatrixDTI; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightDTI = Results.PathogenicSpreadWeightDTI + sum(temp * CurrentQuantity.PathogenicOutputWeightDTI);
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsSpreadMatrixDCM  * CurrentQuantity.PathogenicOutputWeightDCM;
    temp = Network.WeightsSpreadMatrixDCM; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightDCM = Results.PathogenicSpreadWeightDCM + sum(temp * CurrentQuantity.PathogenicOutputWeightDCM);
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsDiffusionMatrixFMRI * CurrentQuantity.PathogenicOutputWeightDistanceFMRI;
    temp = Network.WeightsDiffusionMatrixFMRI; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightDistanceFMRI = Results.PathogenicSpreadWeightDistanceFMRI + sum(temp * CurrentQuantity.PathogenicOutputWeightDistanceFMRI);
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsDiffusionMatrixDTI  * CurrentQuantity.PathogenicOutputWeightDistanceDTI;
    temp = Network.WeightsDiffusionMatrixDTI; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightDistanceDTI = Results.PathogenicSpreadWeightDistanceDTI + sum(temp * CurrentQuantity.PathogenicOutputWeightDistanceDTI);
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsDiffusionMatrixDCM  * CurrentQuantity.PathogenicOutputWeightDistanceDCM;
    temp = Network.WeightsDiffusionMatrixDCM; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightDistanceDCM = Results.PathogenicSpreadWeightDistanceDCM + sum(temp * CurrentQuantity.PathogenicOutputWeightDistanceDCM);
    
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsSpreadMatrixFMRI * CurrentQuantity.NormalOutputWeightFreqFMRI;
    temp = Network.WeightsSpreadMatrixFMRI; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightFreqFMRI = Results.NormalSpreadWeightFreqFMRI + sum(temp * CurrentQuantity.NormalOutputWeightFreqFMRI);
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsSpreadMatrixDTI  * CurrentQuantity.NormalOutputWeightFreqDTI;
    temp = Network.WeightsSpreadMatrixDTI; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightFreqDTI = Results.NormalSpreadWeightFreqDTI + sum(temp * CurrentQuantity.NormalOutputWeightFreqDTI);
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsSpreadMatrixDCM  * CurrentQuantity.NormalOutputWeightFreqDCM;
    temp = Network.WeightsSpreadMatrixDCM; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightFreqDCM = Results.NormalSpreadWeightFreqDCM + sum(temp * CurrentQuantity.NormalOutputWeightFreqDCM);
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsDiffusionMatrixFMRI * CurrentQuantity.NormalOutputWeightDistanceFreqFMRI;
    temp = Network.WeightsDiffusionMatrixFMRI; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightDistanceFreqFMRI = Results.NormalSpreadWeightDistanceFreqFMRI + sum(temp * CurrentQuantity.NormalOutputWeightDistanceFreqFMRI);
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsDiffusionMatrixDTI  * CurrentQuantity.NormalOutputWeightDistanceFreqDTI;
    temp = Network.WeightsDiffusionMatrixDTI; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightDistanceFreqDTI = Results.NormalSpreadWeightDistanceFreqDTI + sum(temp * CurrentQuantity.NormalOutputWeightDistanceFreqDTI);
    QuantityAddToColumnInputsNormal  = QuantityAddToColumnInputsNormal + Network.WeightsDiffusionMatrixDCM  * CurrentQuantity.NormalOutputWeightDistanceFreqDCM;
    temp = Network.WeightsDiffusionMatrixDCM; temp = temp - diag(diag(temp)); Results.NormalSpreadWeightDistanceFreqDCM = Results.NormalSpreadWeightDistanceFreqDCM + sum(temp * CurrentQuantity.NormalOutputWeightDistanceFreqDCM);
    
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsSpreadMatrixFMRI * CurrentQuantity.PathogenicOutputWeightFreqFMRI;
    temp = Network.WeightsSpreadMatrixFMRI; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightFreqFMRI = Results.PathogenicSpreadWeightFreqFMRI + sum(temp * CurrentQuantity.PathogenicOutputWeightFreqFMRI);
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsSpreadMatrixDTI  * CurrentQuantity.PathogenicOutputWeightFreqDTI;
    temp = Network.WeightsSpreadMatrixDTI; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightFreqDTI = Results.PathogenicSpreadWeightFreqDTI + sum(temp * CurrentQuantity.PathogenicOutputWeightFreqDTI);
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsSpreadMatrixDCM  * CurrentQuantity.PathogenicOutputWeightFreqDCM;
    temp = Network.WeightsSpreadMatrixDCM; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightFreqDCM = Results.PathogenicSpreadWeightFreqDCM + sum(temp * CurrentQuantity.PathogenicOutputWeightFreqDCM);
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsDiffusionMatrixFMRI * CurrentQuantity.PathogenicOutputWeightDistanceFreqFMRI;
    temp = Network.WeightsDiffusionMatrixFMRI; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightDistanceFreqFMRI = Results.PathogenicSpreadWeightDistanceFreqFMRI + sum(temp * CurrentQuantity.PathogenicOutputWeightDistanceFreqFMRI);
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsDiffusionMatrixDTI  * CurrentQuantity.PathogenicOutputWeightDistanceFreqDTI;
    temp = Network.WeightsDiffusionMatrixDTI; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightDistanceFreqDTI = Results.PathogenicSpreadWeightDistanceFreqDTI + sum(temp * CurrentQuantity.PathogenicOutputWeightDistanceFreqDTI);
    QuantityAddToColumnInputsMisfolded  = QuantityAddToColumnInputsMisfolded + Network.WeightsDiffusionMatrixDCM  * CurrentQuantity.PathogenicOutputWeightDistanceFreqDCM;
    temp = Network.WeightsDiffusionMatrixDCM; temp = temp - diag(diag(temp)); Results.PathogenicSpreadWeightDistanceFreqDCM = Results.PathogenicSpreadWeightDistanceFreqDCM + sum(temp * CurrentQuantity.PathogenicOutputWeightDistanceFreqDCM);
        
    QuantityRemoveFromColumnOutputsNormal = QuantityRemoveFromColumnOutputsNormal + ((sum(Network.WeightsSpreadMatrixFMRI)') .* CurrentQuantity.NormalOutputWeightFMRI);
    QuantityRemoveFromColumnOutputsNormal = QuantityRemoveFromColumnOutputsNormal + ((sum(Network.WeightsSpreadMatrixDTI)')  .* CurrentQuantity.NormalOutputWeightDTI);
    QuantityRemoveFromColumnOutputsNormal = QuantityRemoveFromColumnOutputsNormal + ((sum(Network.WeightsSpreadMatrixDCM)')  .* CurrentQuantity.NormalOutputWeightDCM);
    QuantityRemoveFromColumnOutputsNormal = QuantityRemoveFromColumnOutputsNormal + ((sum(Network.WeightsDiffusionMatrixFMRI)') .* CurrentQuantity.NormalOutputWeightDistanceFMRI);
    QuantityRemoveFromColumnOutputsNormal = QuantityRemoveFromColumnOutputsNormal + ((sum(Network.WeightsDiffusionMatrixDTI)')  .* CurrentQuantity.NormalOutputWeightDistanceDTI);
    QuantityRemoveFromColumnOutputsNormal = QuantityRemoveFromColumnOutputsNormal + ((sum(Network.WeightsDiffusionMatrixDCM)')  .* CurrentQuantity.NormalOutputWeightDistanceDCM);
    QuantityRemoveFromColumnOutputsMisfolded = QuantityRemoveFromColumnOutputsMisfolded + ((sum(Network.WeightsSpreadMatrixFMRI)') .* CurrentQuantity.PathogenicOutputWeightFMRI);
    QuantityRemoveFromColumnOutputsMisfolded = QuantityRemoveFromColumnOutputsMisfolded + ((sum(Network.WeightsSpreadMatrixDTI)')  .* CurrentQuantity.PathogenicOutputWeightDTI);
    QuantityRemoveFromColumnOutputsMisfolded = QuantityRemoveFromColumnOutputsMisfolded + ((sum(Network.WeightsSpreadMatrixDCM)')  .* CurrentQuantity.PathogenicOutputWeightDCM);
    QuantityRemoveFromColumnOutputsMisfolded = QuantityRemoveFromColumnOutputsMisfolded + ((sum(Network.WeightsDiffusionMatrixFMRI)') .* CurrentQuantity.PathogenicOutputWeightDistanceFMRI);
    QuantityRemoveFromColumnOutputsMisfolded = QuantityRemoveFromColumnOutputsMisfolded + ((sum(Network.WeightsDiffusionMatrixDTI)')  .* CurrentQuantity.PathogenicOutputWeightDistanceDTI);
    QuantityRemoveFromColumnOutputsMisfolded = QuantityRemoveFromColumnOutputsMisfolded + ((sum(Network.WeightsDiffusionMatrixDCM)')  .* CurrentQuantity.PathogenicOutputWeightDistanceDCM);
    
    QuantityRemoveFromColumnOutputsNormalFreq = QuantityRemoveFromColumnOutputsNormalFreq + ((sum(Network.WeightsSpreadMatrixFMRI)') .* CurrentQuantity.NormalOutputWeightFreqFMRI);
    QuantityRemoveFromColumnOutputsNormalFreq = QuantityRemoveFromColumnOutputsNormalFreq + ((sum(Network.WeightsSpreadMatrixDTI)')  .* CurrentQuantity.NormalOutputWeightFreqDTI);
    QuantityRemoveFromColumnOutputsNormalFreq = QuantityRemoveFromColumnOutputsNormalFreq + ((sum(Network.WeightsSpreadMatrixDCM)')  .* CurrentQuantity.NormalOutputWeightFreqDCM);
    QuantityRemoveFromColumnOutputsNormalFreq = QuantityRemoveFromColumnOutputsNormalFreq + ((sum(Network.WeightsDiffusionMatrixFMRI)') .* CurrentQuantity.NormalOutputWeightDistanceFreqFMRI);
    QuantityRemoveFromColumnOutputsNormalFreq = QuantityRemoveFromColumnOutputsNormalFreq + ((sum(Network.WeightsDiffusionMatrixDTI)')  .* CurrentQuantity.NormalOutputWeightDistanceFreqDTI);
    QuantityRemoveFromColumnOutputsNormalFreq = QuantityRemoveFromColumnOutputsNormalFreq + ((sum(Network.WeightsDiffusionMatrixDCM)')  .* CurrentQuantity.NormalOutputWeightDistanceFreqDCM);
    QuantityRemoveFromColumnOutputsMisfoldedFreq = QuantityRemoveFromColumnOutputsMisfoldedFreq + ((sum(Network.WeightsSpreadMatrixFMRI)') .* CurrentQuantity.PathogenicOutputWeightFreqFMRI);
    QuantityRemoveFromColumnOutputsMisfoldedFreq = QuantityRemoveFromColumnOutputsMisfoldedFreq + ((sum(Network.WeightsSpreadMatrixDTI)')  .* CurrentQuantity.PathogenicOutputWeightFreqDTI);
    QuantityRemoveFromColumnOutputsMisfoldedFreq = QuantityRemoveFromColumnOutputsMisfoldedFreq + ((sum(Network.WeightsSpreadMatrixDCM)')  .* CurrentQuantity.PathogenicOutputWeightFreqDCM);
    QuantityRemoveFromColumnOutputsMisfoldedFreq = QuantityRemoveFromColumnOutputsMisfoldedFreq + ((sum(Network.WeightsDiffusionMatrixFMRI)') .* CurrentQuantity.PathogenicOutputWeightDistanceFreqFMRI);
    QuantityRemoveFromColumnOutputsMisfoldedFreq = QuantityRemoveFromColumnOutputsMisfoldedFreq + ((sum(Network.WeightsDiffusionMatrixDTI)')  .* CurrentQuantity.PathogenicOutputWeightDistanceFreqDTI);
    QuantityRemoveFromColumnOutputsMisfoldedFreq = QuantityRemoveFromColumnOutputsMisfoldedFreq + ((sum(Network.WeightsDiffusionMatrixDCM)')  .* CurrentQuantity.PathogenicOutputWeightDistanceFreqDCM);
    
    
    QuantityExtracellularEnteringNormal = Network.ExtracellularDiffusionMatrix * CurrentQuantity.NormalExtracellular;
    temp = Network.ExtracellularDiffusionMatrix; temp = temp - diag(diag(temp)); Results.NormalSpreadExtracellular = Results.NormalSpreadExtracellular + sum(temp * CurrentQuantity.NormalExtracellular);
    QuantityExtracellularLeavingNormal  = (sum(Network.ExtracellularDiffusionMatrix)') .* CurrentQuantity.NormalExtracellular;
    
    QuantityExtracellularEnteringMisfolded = Network.ExtracellularDiffusionMatrix * CurrentQuantity.PathogenicExtracellular;
    temp = Network.ExtracellularDiffusionMatrix; temp = temp - diag(diag(temp)); Results.PathogenicSpreadExtracellular = Results.PathogenicSpreadExtracellular + sum(temp * CurrentQuantity.PathogenicExtracellular);
    QuantityExtracellularLeavingMisfolded  = (sum(Network.ExtracellularDiffusionMatrix)') .* CurrentQuantity.PathogenicExtracellular;
    
    %%
    %Transform MATLAB messages to NEURON form
    for r = 1:numel(Parameters.ColumnsPerRegion)
        NEURONdata{r}.QuantityInputNormal = QuantityAddToColumnInputsNormal(r);
        NEURONdata{r}.QuantityOutputNormal = QuantityRemoveFromColumnOutputsNormal(r);
        NEURONdata{r}.QuantityOutputNormalFreq = QuantityRemoveFromColumnOutputsNormalFreq(r);
        NEURONdata{r}.QuantityExtracellularLeavingNormal = QuantityExtracellularLeavingNormal(r);
        NEURONdata{r}.QuantityExtracellularEnteringNormal = QuantityExtracellularEnteringNormal(r);
        NEURONdata{r}.QuantityInputMisfolded = QuantityAddToColumnInputsMisfolded(r);
        NEURONdata{r}.QuantityOutputMisfolded = QuantityRemoveFromColumnOutputsMisfolded(r);
        NEURONdata{r}.QuantityOutputMisfoldedFreq = QuantityRemoveFromColumnOutputsMisfoldedFreq(r);
        NEURONdata{r}.QuantityExtracellularLeavingMisfolded = QuantityExtracellularLeavingMisfolded(r);
        NEURONdata{r}.QuantityExtracellularEnteringMisfolded = QuantityExtracellularEnteringMisfolded(r);
    end
    
end

Results.Atrophy = Results.Atrophy(:,1:Timestep);
Results.ConcentrationNormal = Results.ConcentrationNormal(:,1:Timestep);
Results.ConcentrationPathogenic = Results.ConcentrationPathogenic(:,1:Timestep);
Results.Volumes = Results.Volumes(:,1:Timestep);
if(Parameters.Verbose == false)
    dispstat(['Ran simulation. Time Elapsed: ' num2str()], 'timestamp');
end

rng(rngstate);
end