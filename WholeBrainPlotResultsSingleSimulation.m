function ProcessedResults = WholeBrainPlotResultsSingleSimulation(Network, ProcessedResults, EBM, AllParams, savefigs)
save_path = AllParams.save_path;
if(exist(save_path,'dir') == 0)
    mkdir(save_path);
end
filenameaddon = ProcessedResults.Parameters.DiseaseName;

fprintf('Optimal Parameters for %s:\n', ProcessedResults.Parameters.DiseaseName);
fprintf('Num Regions: %d Epicentre: %s Quantity: %f\n', ProcessedResults.NumNodes, ProcessedResults.Parameters.DiseaseEpicentres{ProcessedResults.Parameters.ProteinLocation}, ProcessedResults.Parameters.Seedsize);
fprintf('Extracellular Diffusion: %f Speed %f\n', ProcessedResults.Parameters.ExtracellularDiffusionFraction, ProcessedResults.Parameters.ExtracellularDiffusionSpeed);
fprintf('Model WeightFraction WeightDistanceFraction SynapticFraction SynapticDistanceFraction\n');
fprintf('FMRI: %d %f %f %f %f\n', ProcessedResults.Parameters.FMRIspread, ProcessedResults.Parameters.NetworkDiffusionWeightFractionFMRI, ProcessedResults.Parameters.NetworkDiffusionWeightDistanceFractionFMRI, ProcessedResults.Parameters.SynapticTransferWeightFractionFMRI, ProcessedResults.Parameters.SynapticTransferWeightDistanceFractionFMRI);
fprintf('DTI:  %d %f %f %f %f\n', ProcessedResults.Parameters.DTIspread, ProcessedResults.Parameters.NetworkDiffusionWeightFractionDTI, ProcessedResults.Parameters.NetworkDiffusionWeightDistanceFractionDTI, ProcessedResults.Parameters.SynapticTransferWeightFractionDTI, ProcessedResults.Parameters.SynapticTransferWeightDistanceFractionDTI);
fprintf('DCM:  %d %f %f %f %f\n', ProcessedResults.Parameters.DCMspread, ProcessedResults.Parameters.NetworkDiffusionWeightFractionDCM, ProcessedResults.Parameters.NetworkDiffusionWeightDistanceFractionDCM, ProcessedResults.Parameters.SynapticTransferWeightFractionDCM, ProcessedResults.Parameters.SynapticTransferWeightDistanceFractionDCM);
fprintf('Network Diffusion Speed: %f\n', ProcessedResults.Parameters.NetworkDiffusionSpeed);
fprintf('Misfolding Rate: %f Damage Rate: %f Synaptic Effect: %d\n', ProcessedResults.Parameters.NEURONMisfold,  ProcessedResults.Parameters.NEURONDamage,  ProcessedResults.Parameters.NEURONEffect);
fprintf('Diffusion Rate and Speed: %f %f Transport Rate: %f Synaptic Transfer: %f\n', ProcessedResults.Parameters.NEURONDiffusion, ProcessedResults.Parameters.NEURONDiffusionSpeed,  ProcessedResults.Parameters.NEURONTransport,  ProcessedResults.Parameters.NEURONSynaptic);
fprintf('Optimisation values: %f %f\n', ProcessedResults.OptimizeMetric, ProcessedResults.OptimizeMetric2);
fprintf('ASY: %f TTNB: %f\n', ProcessedResults.ASY, ProcessedResults.TTNB);
fprintf('\n\n');

TotalNormal = ProcessedResults.NormalSpreadExtracellular + ProcessedResults.NormalSpreadWeightFMRI +ProcessedResults.NormalSpreadWeightDTI + ProcessedResults.NormalSpreadWeightDCM + ...
    ProcessedResults.NormalSpreadWeightDistanceFMRI + ProcessedResults.NormalSpreadWeightDistanceDTI + ProcessedResults.NormalSpreadWeightDistanceDCM + ...
    ProcessedResults.NormalSpreadWeightFreqFMRI + ProcessedResults.NormalSpreadWeightFreqDTI + ProcessedResults.NormalSpreadWeightFreqDCM + ...
    ProcessedResults.NormalSpreadWeightDistanceFreqFMRI + ProcessedResults.NormalSpreadWeightDistanceFreqDTI + ProcessedResults.NormalSpreadWeightDistanceFreqDCM;
TotalPathogenic = ProcessedResults.PathogenicSpreadExtracellular + ProcessedResults.PathogenicSpreadWeightFMRI +ProcessedResults.PathogenicSpreadWeightDTI + ProcessedResults.PathogenicSpreadWeightDCM + ...
    ProcessedResults.PathogenicSpreadWeightDistanceFMRI + ProcessedResults.PathogenicSpreadWeightDistanceDTI + ProcessedResults.PathogenicSpreadWeightDistanceDCM + ...
    ProcessedResults.PathogenicSpreadWeightFreqFMRI + ProcessedResults.PathogenicSpreadWeightFreqDTI + ProcessedResults.PathogenicSpreadWeightFreqDCM + ...
    ProcessedResults.PathogenicSpreadWeightDistanceFreqFMRI + ProcessedResults.PathogenicSpreadWeightDistanceFreqDTI + ProcessedResults.PathogenicSpreadWeightDistanceFreqDCM;
TotalProtein = TotalNormal + TotalPathogenic;

ProcessedResults.TotalNormal = TotalNormal;
ProcessedResults.TotalPathogenic = TotalPathogenic;
ProcessedResults.TotalProtein = TotalProtein;

ProcessedResults.TotalSpreadExtracellular = ProcessedResults.NormalSpreadExtracellular + ProcessedResults.PathogenicSpreadExtracellular;
ProcessedResults.TotalSpreadWeightFMRI = ProcessedResults.NormalSpreadWeightFMRI + ProcessedResults.PathogenicSpreadWeightFMRI;
ProcessedResults.TotalSpreadWeightDTI = ProcessedResults.NormalSpreadWeightDTI  + ProcessedResults.PathogenicSpreadWeightDTI;
ProcessedResults.TotalSpreadWeightDCM = ProcessedResults.NormalSpreadWeightDCM + ProcessedResults.PathogenicSpreadWeightDCM;
ProcessedResults.TotalSpreadWeightDistanceFMRI = ProcessedResults.NormalSpreadWeightDistanceFMRI + ProcessedResults.PathogenicSpreadWeightDistanceFMRI;
ProcessedResults.TotalSpreadWeightDistanceDTI = ProcessedResults.NormalSpreadWeightDistanceDTI + ProcessedResults.PathogenicSpreadWeightDistanceDTI;
ProcessedResults.TotalSpreadWeightDistanceDCM = ProcessedResults.NormalSpreadWeightDistanceDCM + ProcessedResults.PathogenicSpreadWeightDistanceDCM;
ProcessedResults.TotalSpreadWeightFreqFMRI = ProcessedResults.NormalSpreadWeightFreqFMRI + ProcessedResults.PathogenicSpreadWeightFreqFMRI;
ProcessedResults.TotalSpreadWeightFreqDTI = ProcessedResults.NormalSpreadWeightFreqDTI + ProcessedResults.PathogenicSpreadWeightFreqDTI;
ProcessedResults.TotalSpreadWeightFreqDCM = ProcessedResults.NormalSpreadWeightFreqDCM + ProcessedResults.PathogenicSpreadWeightFreqDCM;
ProcessedResults.TotalSpreadWeightDistanceFreqFMRI = ProcessedResults.NormalSpreadWeightDistanceFreqFMRI + ProcessedResults.PathogenicSpreadWeightDistanceFreqFMRI;
ProcessedResults.TotalSpreadWeightDistanceFreqDTI = ProcessedResults.NormalSpreadWeightDistanceFreqDTI + ProcessedResults.PathogenicSpreadWeightDistanceFreqDTI;
ProcessedResults.TotalSpreadWeightDistanceFreqDCM = ProcessedResults.NormalSpreadWeightDistanceFreqDCM + ProcessedResults.PathogenicSpreadWeightDistanceFreqDCM;

fprintf('Non-pathogenic protein quantity spread with different mechanisms\n');
fprintf('Extracellular diffusion: %f  %f\n', ProcessedResults.NormalSpreadExtracellular, ProcessedResults.NormalSpreadExtracellular/ProcessedResults.TotalNormal);
fprintf('Weight FMRI:             %f  %f\n', ProcessedResults.NormalSpreadWeightFMRI, ProcessedResults.NormalSpreadWeightFMRI/ProcessedResults.TotalNormal);
fprintf('Weight DTI:              %f  %f\n', ProcessedResults.NormalSpreadWeightDTI, ProcessedResults.NormalSpreadWeightDTI/ProcessedResults.TotalNormal);
fprintf('Weight DCM:              %f  %f\n', ProcessedResults.NormalSpreadWeightDCM, ProcessedResults.NormalSpreadWeightDCM/ProcessedResults.TotalNormal);
fprintf('Weight Distance FMRI:    %f  %f\n', ProcessedResults.NormalSpreadWeightDistanceFMRI, ProcessedResults.NormalSpreadWeightDistanceFMRI/ProcessedResults.TotalNormal);
fprintf('Weight Distance DTI:     %f  %f\n', ProcessedResults.NormalSpreadWeightDistanceDTI, ProcessedResults.NormalSpreadWeightDistanceDTI/ProcessedResults.TotalNormal);
fprintf('Weight Distance DCM:     %f  %f\n', ProcessedResults.NormalSpreadWeightDistanceDCM, ProcessedResults.NormalSpreadWeightDistanceDCM/ProcessedResults.TotalNormal);
fprintf('Frequency FMRI:          %f  %f\n', ProcessedResults.NormalSpreadWeightFreqFMRI, ProcessedResults.NormalSpreadWeightFreqFMRI/ProcessedResults.TotalNormal);
fprintf('Frequency DTI:           %f  %f\n', ProcessedResults.NormalSpreadWeightFreqDTI, ProcessedResults.NormalSpreadWeightFreqDTI/ProcessedResults.TotalNormal);
fprintf('Frequency DCM:           %f  %f\n', ProcessedResults.NormalSpreadWeightFreqDCM, ProcessedResults.NormalSpreadWeightFreqDCM/ProcessedResults.TotalNormal);
fprintf('Frequency Distance FMRI: %f  %f\n', ProcessedResults.NormalSpreadWeightDistanceFreqFMRI, ProcessedResults.NormalSpreadWeightDistanceFreqFMRI/ProcessedResults.TotalNormal);
fprintf('Frequency Distance DTI:  %f  %f\n', ProcessedResults.NormalSpreadWeightDistanceFreqDTI, ProcessedResults.NormalSpreadWeightDistanceFreqDTI/ProcessedResults.TotalNormal);
fprintf('Frequency Distance DCM:  %f  %f\n', ProcessedResults.NormalSpreadWeightDistanceFreqDCM, ProcessedResults.NormalSpreadWeightDistanceFreqDCM/ProcessedResults.TotalNormal);

fprintf('Pathogenic protein quantity spread with different mechanisms\n');
fprintf('Extracellular diffusion: %f  %f\n', ProcessedResults.PathogenicSpreadExtracellular, ProcessedResults.PathogenicSpreadExtracellular/ProcessedResults.TotalPathogenic);
fprintf('Weight FMRI:             %f  %f\n', ProcessedResults.PathogenicSpreadWeightFMRI, ProcessedResults.PathogenicSpreadWeightFMRI/ProcessedResults.TotalPathogenic);
fprintf('Weight DTI:              %f  %f\n', ProcessedResults.PathogenicSpreadWeightDTI, ProcessedResults.PathogenicSpreadWeightDTI/ProcessedResults.TotalPathogenic);
fprintf('Weight DCM:              %f  %f\n', ProcessedResults.PathogenicSpreadWeightDCM, ProcessedResults.PathogenicSpreadWeightDCM/ProcessedResults.TotalPathogenic);
fprintf('Weight Distance FMRI:    %f  %f\n', ProcessedResults.PathogenicSpreadWeightDistanceFMRI, ProcessedResults.PathogenicSpreadWeightDistanceFMRI/ProcessedResults.TotalPathogenic);
fprintf('Weight Distance DTI:     %f  %f\n', ProcessedResults.PathogenicSpreadWeightDistanceDTI, ProcessedResults.PathogenicSpreadWeightDistanceDTI/ProcessedResults.TotalPathogenic);
fprintf('Weight Distance DCM:     %f  %f\n', ProcessedResults.PathogenicSpreadWeightDistanceDCM, ProcessedResults.PathogenicSpreadWeightDistanceDCM/ProcessedResults.TotalPathogenic);
fprintf('Frequency FMRI:          %f  %f\n', ProcessedResults.PathogenicSpreadWeightFreqFMRI, ProcessedResults.PathogenicSpreadWeightFreqFMRI/ProcessedResults.TotalPathogenic);
fprintf('Frequency DTI:           %f  %f\n', ProcessedResults.PathogenicSpreadWeightFreqDTI, ProcessedResults.PathogenicSpreadWeightFreqDTI/ProcessedResults.TotalPathogenic);
fprintf('Frequency DCM:           %f  %f\n', ProcessedResults.PathogenicSpreadWeightFreqDCM, ProcessedResults.PathogenicSpreadWeightFreqDCM/ProcessedResults.TotalPathogenic);
fprintf('Frequency Distance FMRI: %f  %f\n', ProcessedResults.PathogenicSpreadWeightDistanceFreqFMRI, ProcessedResults.PathogenicSpreadWeightDistanceFreqFMRI/ProcessedResults.TotalPathogenic);
fprintf('Frequency Distance DTI:  %f  %f\n', ProcessedResults.PathogenicSpreadWeightDistanceFreqDTI, ProcessedResults.PathogenicSpreadWeightDistanceFreqDTI/ProcessedResults.TotalPathogenic);
fprintf('Frequency Distance DCM:  %f  %f\n', ProcessedResults.PathogenicSpreadWeightDistanceFreqDCM, ProcessedResults.PathogenicSpreadWeightDistanceFreqDCM/ProcessedResults.TotalPathogenic);

fprintf('Overall protein quantity spread with different mechanisms\n');
fprintf('Extracellular diffusion: %f  %f\n', ProcessedResults.TotalSpreadExtracellular, ProcessedResults.TotalSpreadExtracellular/ProcessedResults.TotalProtein);
fprintf('Weight FMRI:             %f  %f\n', ProcessedResults.TotalSpreadWeightFMRI, ProcessedResults.TotalSpreadWeightFMRI/ProcessedResults.TotalProtein);
fprintf('Weight DTI:              %f  %f\n', ProcessedResults.TotalSpreadWeightDTI, ProcessedResults.TotalSpreadWeightDTI/ProcessedResults.TotalProtein);
fprintf('Weight DCM:              %f  %f\n', ProcessedResults.TotalSpreadWeightDCM, ProcessedResults.TotalSpreadWeightDCM/ProcessedResults.TotalProtein);
fprintf('Weight Distance FMRI:    %f  %f\n', ProcessedResults.TotalSpreadWeightDistanceFMRI, ProcessedResults.TotalSpreadWeightDistanceFMRI/ProcessedResults.TotalProtein);
fprintf('Weight Distance DTI:     %f  %f\n', ProcessedResults.TotalSpreadWeightDistanceDTI, ProcessedResults.TotalSpreadWeightDistanceDTI/ProcessedResults.TotalProtein);
fprintf('Weight Distance DCM:     %f  %f\n', ProcessedResults.TotalSpreadWeightDistanceDCM, ProcessedResults.TotalSpreadWeightDistanceDCM/ProcessedResults.TotalProtein);
fprintf('Frequency FMRI:          %f  %f\n', ProcessedResults.TotalSpreadWeightFreqFMRI, ProcessedResults.TotalSpreadWeightFreqFMRI/ProcessedResults.TotalProtein);
fprintf('Frequency DTI:           %f  %f\n', ProcessedResults.TotalSpreadWeightFreqDTI, ProcessedResults.TotalSpreadWeightFreqDTI/ProcessedResults.TotalProtein);
fprintf('Frequency DCM:           %f  %f\n', ProcessedResults.TotalSpreadWeightFreqDCM, ProcessedResults.TotalSpreadWeightFreqDCM/ProcessedResults.TotalProtein);
fprintf('Frequency Distance FMRI: %f  %f\n', ProcessedResults.TotalSpreadWeightDistanceFreqFMRI, ProcessedResults.TotalSpreadWeightDistanceFreqFMRI/ProcessedResults.TotalProtein);
fprintf('Frequency Distance DTI:  %f  %f\n', ProcessedResults.TotalSpreadWeightDistanceFreqDTI, ProcessedResults.TotalSpreadWeightDistanceFreqDTI/ProcessedResults.TotalProtein);
fprintf('Frequency Distance DCM:  %f  %f\n', ProcessedResults.TotalSpreadWeightDistanceFreqDCM, ProcessedResults.TotalSpreadWeightDistanceFreqDCM/ProcessedResults.TotalProtein);

fprintf('\nAbnormality timings:\n');
for i = 1:numel(Network.Names)
    fprintf('%d %s\n',ProcessedResults.AbnormalityTimings(i), Network.Names{i});
end

filename = [save_path 'ConfusionMatrix' filenameaddon];
WholeBrainPlotSequenceOnConfusionMatrix(EBM, ProcessedResults.AbnormalitySequence, filename, savefigs);
% filename = [save_path 'ConfusionMatrixTrimmed' filenameaddon];
% WholeBrainPlotSequenceOnConfusionMatrix(EBM, ProcessedResults.AbnormalitySequenceTrimmed, filename, save);
return

%% Derive metrics to seed
for i = 1:size(Network.ZBOLDCorrelationMatrix)
    Network.ZBOLDCorrelationMatrix(i,i) = 3;
    Network.ZSynapticCorrelationMatrix(i,i) = 3;
end

for i = 1:numel(ProcessedResults.SortIndices)
    SimulationSortIndices(ProcessedResults.SortIndices(i),1) = i;
end

[ProcessedResults.RBOLDNormal, ProcessedResults.RBOLDAbs, ProcessedResults.RBOLDMin, ProcessedResults.RBOLDAbsMin, ProcessedResults.RBOLDAbsRevMin] = WholeBrainAbsMinRevMatrix(Network, Network.RBOLDCorrelationMatrix, ProcessedResults.Seeds);
[ProcessedResults.ZBOLDNormal, ProcessedResults.ZBOLDAbs, ProcessedResults.ZBOLDMin, ProcessedResults.ZBOLDAbsMin, ProcessedResults.ZBOLDAbsRevMin] = WholeBrainAbsMinRevMatrix(Network, Network.ZBOLDCorrelationMatrix, ProcessedResults.Seeds);
[ProcessedResults.RSynapticNormal, ProcessedResults.RSynapticAbs, ProcessedResults.RSynapticMin, ProcessedResults.RSynapticAbsMin, ProcessedResults.RSynapticAbsRevMin] = WholeBrainAbsMinRevMatrix(Network, Network.RSynapticCorrelationMatrix, ProcessedResults.Seeds);
[ProcessedResults.ZSynapticNormal, ProcessedResults.ZSynapticAbs, ProcessedResults.ZSynapticMin, ProcessedResults.ZSynapticAbsMin, ProcessedResults.ZSynapticAbsRevMin] = WholeBrainAbsMinRevMatrix(Network, Network.ZSynapticCorrelationMatrix, ProcessedResults.Seeds);

[ProcessedResults.DTIsmallNormal, ProcessedResults.DTIsmallAbs, ProcessedResults.DTIsmallMin, ProcessedResults.DTIsmallAbsMin, ProcessedResults.DTIsmallAbsRevMin] = WholeBrainAbsMinRevMatrix(Network, Network.DTIsmall, ProcessedResults.Seeds);
[ProcessedResults.DTIlargeNormal, ProcessedResults.DTIlargeAbs, ProcessedResults.DTIlargeMin, ProcessedResults.DTIlargeAbsMin, ProcessedResults.DTIlargeAbsRevMin] = WholeBrainAbsMinRevMatrix(Network, Network.DTIlarge, ProcessedResults.Seeds);

[ProcessedResults.EffectiveConnectivityNNormal, ProcessedResults.EffectiveConnectivityNAbs, ProcessedResults.EffectiveConnectivityNMin, ProcessedResults.EffectiveConnectivityNAbsMin, ProcessedResults.EffectiveConnectivityNAbsRevMin] = WholeBrainAbsMinRevMatrix(Network, Network.EffectiveConnectivityN, ProcessedResults.Seeds);
[ProcessedResults.EffectiveConnectivitySNormal, ProcessedResults.EffectiveConnectivitySAbs, ProcessedResults.EffectiveConnectivitySMin, ProcessedResults.EffectiveConnectivitySAbsMin, ProcessedResults.EffectiveConnectivitySAbsRevMin] = WholeBrainAbsMinRevMatrix(Network, Network.EffectiveConnectivityS, ProcessedResults.Seeds);
[ProcessedResults.EffectiveConnectivityLNormal, ProcessedResults.EffectiveConnectivityLAbs, ProcessedResults.EffectiveConnectivityLMin, ProcessedResults.EffectiveConnectivityLAbsMin, ProcessedResults.EffectiveConnectivityLAbsRevMin] = WholeBrainAbsMinRevMatrix(Network, Network.EffectiveConnectivityL, ProcessedResults.Seeds);

ProcessedResults.EuclideanNormal = Network.EuclideanDistances(ProcessedResults.Seeds,:)';
ProcessedResults.VolumesNormal   = ProcessedResults.Volumes(:,1);

ProcessedResults.SSGED            = sum(ProcessedResults.ExtracellularDiffusionMatrix')' - sum(ProcessedResults.ExtracellularDiffusionMatrix)';
ProcessedResults.SSGWeightsFMRI   = sum(ProcessedResults.WeightsSpreadMatrixFMRI')'      - sum(ProcessedResults.WeightsSpreadMatrixFMRI)';
ProcessedResults.SSGWeightsDTI    = sum(ProcessedResults.WeightsSpreadMatrixDTI')'       - sum(ProcessedResults.WeightsSpreadMatrixDTI)';
ProcessedResults.SSGWeightsDCM    = sum(ProcessedResults.WeightsSpreadMatrixDCM')'       - sum(ProcessedResults.WeightsSpreadMatrixDCM)';
ProcessedResults.SSGDiffusionFMRI = sum(ProcessedResults.WeightsDiffusionMatrixFMRI')'   - sum(ProcessedResults.WeightsDiffusionMatrixFMRI)';
ProcessedResults.SSGDiffusionDTI  = sum(ProcessedResults.WeightsDiffusionMatrixDTI')'    - sum(ProcessedResults.WeightsDiffusionMatrixDTI)';
ProcessedResults.SSGDiffusionDCM  = sum(ProcessedResults.WeightsDiffusionMatrixDCM')'    - sum(ProcessedResults.WeightsDiffusionMatrixDCM)';

%%
FontSizeAll = 12;width = 10;height = 10;
[ProcessedResults.RBOLDNormalRsqTimings,    ProcessedResults.RBOLDNormalRsqOrder,    ProcessedResults.RBOLDNormalRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'RBOLDNormal'],    ProcessedResults.RBOLDNormal,    'r-Correlation BOLD from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.RBOLDAbsRsqTimings,       ProcessedResults.RBOLDAbsRsqOrder,       ProcessedResults.RBOLDAbsRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'RBOLDAbs'],       ProcessedResults.RBOLDAbs,       'Absolute r-Correlation BOLD from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.RBOLDMinRsqTimings,       ProcessedResults.RBOLDMinRsqOrder,       ProcessedResults.RBOLDMinRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'RBOLDMin'],       ProcessedResults.RBOLDMin,       'Minimum path distance r-Correlation BOLD from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.RBOLDAbsMinRsqTimings,    ProcessedResults.RBOLDAbsMinRsqOrder,    ProcessedResults.RBOLDAbsMinRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'RBOLDAbsMin'],    ProcessedResults.RBOLDAbsMin,    'Minimum path distance absolute r-Correlation BOLD from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.RBOLDAbsRevMinRsqTimings, ProcessedResults.RBOLDAbsRevMinRsqOrder, ProcessedResults.RBOLDAbsRevMinRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'RBOLDAbsRevMin'], ProcessedResults.RBOLDAbsRevMin, 'Minimum path distance absolute reversed r-Correlation BOLD from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.ZBOLDNormalRsqTimings,    ProcessedResults.ZBOLDNormalRsqOrder,    ProcessedResults.ZBOLDNormalRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'ZBOLDNormal'],    ProcessedResults.ZBOLDNormal,    'Z-values BOLD from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.ZBOLDAbsRsqTimings,       ProcessedResults.ZBOLDAbsRsqOrder,       ProcessedResults.ZBOLDAbsRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'ZBOLDAbs'],       ProcessedResults.ZBOLDAbs,       'Absolute Z-values BOLD from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.ZBOLDMinRsqTimings,       ProcessedResults.ZBOLDMinRsqOrder,       ProcessedResults.ZBOLDMinRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'ZBOLDMin'],       ProcessedResults.ZBOLDMin,       'Minimum path distance Z-values BOLD from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.ZBOLDAbsMinRsqTimings,    ProcessedResults.ZBOLDAbsMinRsqOrder,    ProcessedResults.ZBOLDAbsMinRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'ZBOLDAbsMin'],    ProcessedResults.ZBOLDAbsMin,    'Minimum path distance absolute Z-values BOLD from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.ZBOLDAbsRevMinRsqTimings, ProcessedResults.ZBOLDAbsRevMinRsqOrder, ProcessedResults.ZBOLDAbsRevMinRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'ZBOLDAbsRevMin'], ProcessedResults.ZBOLDAbsRevMin, 'Minimum path distance absolute reversed Z-values BOLD from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);

[ProcessedResults.RSynapticNormalRsqTimings,    ProcessedResults.RSynapticNormalRsqOrder,    ProcessedResults.RSynapticNormalRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'RSynapticNormal'],    ProcessedResults.RSynapticNormal,    'r-Correlation Synaptic Signals from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.RSynapticAbsRsqTimings,       ProcessedResults.RSynapticAbsRsqOrder,       ProcessedResults.RSynapticAbsRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'RSynapticAbs'],       ProcessedResults.RSynapticAbs,       'Absolute r-Correlation Synaptic Signals from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.RSynapticMinRsqTimings,       ProcessedResults.RSynapticMinRsqOrder,       ProcessedResults.RSynapticMinRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'RSynapticMin'],       ProcessedResults.RSynapticMin,       'Minimum path distance r-Correlation Synaptic Signals from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.RSynapticAbsMinRsqTimings,    ProcessedResults.RSynapticAbsMinRsqOrder,    ProcessedResults.RSynapticAbsMinRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'RSynapticAbsMin'],    ProcessedResults.RSynapticAbsMin,    'Minimum path distance absolute r-Correlation Synaptic Signals from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.RSynapticAbsRevMinRsqTimings, ProcessedResults.RSynapticAbsRevMinRsqOrder, ProcessedResults.RSynapticAbsRevMinRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'RSynapticAbsRevMin'], ProcessedResults.RSynapticAbsRevMin, 'Minimum path distance absolute reversed r-Correlation Synaptic Signals from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.ZSynapticNormalRsqTimings,    ProcessedResults.ZSynapticNormalRsqOrder,    ProcessedResults.ZSynapticNormalRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'ZSynapticNormal'],    ProcessedResults.ZSynapticNormal,    'Z-values Synaptic Signals from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.ZSynapticAbsRsqTimings,       ProcessedResults.ZSynapticAbsRsqOrder,       ProcessedResults.ZSynapticAbsRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'ZSynapticAbs'],       ProcessedResults.ZSynapticAbs,       'Absolute Z-values Synaptic Signals from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.ZSynapticMinRsqTimings,       ProcessedResults.ZSynapticMinRsqOrder,       ProcessedResults.ZSynapticMinRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'ZSynapticMin'],       ProcessedResults.ZSynapticMin,       'Minimum path distance Z-values Synaptic Signals from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.ZSynapticAbsMinRsqTimings,    ProcessedResults.ZSynapticAbsMinRsqOrder,    ProcessedResults.ZSynapticAbsMinRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'ZSynapticAbsMin'],    ProcessedResults.ZSynapticAbsMin,    'Minimum path distance absolute Z-values Synaptic Signals from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.ZSynapticAbsRevMinRsqTimings, ProcessedResults.ZSynapticAbsRevMinRsqOrder, ProcessedResults.ZSynapticAbsRevMinRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'ZSynapticAbsRevMin'], ProcessedResults.ZSynapticAbsRevMin, 'Minimum path distance absolute reversed Z-values Synaptic Signals from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);

[ProcessedResults.DTIsmallNormalRsqTimings,    ProcessedResults.DTIsmallNormalRsqOrder,    ProcessedResults.DTIsmallNormalRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'DTIsmallNormal'],    ProcessedResults.DTIsmallNormal,    'DTI small tracts emphasized from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.DTIsmallAbsRsqTimings,       ProcessedResults.DTIsmallAbsRsqOrder,       ProcessedResults.DTIsmallAbsRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'DTIsmallAbs'],       ProcessedResults.DTIsmallAbs,       'Absolute DTI small tracts emphasized from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.DTIsmallMinRsqTimings,       ProcessedResults.DTIsmallMinRsqOrder,       ProcessedResults.DTIsmallMinRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'DTIsmallMin'],       ProcessedResults.DTIsmallMin,       'Minimum path distance DTI small tracts emphasized from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.DTIsmallAbsMinRsqTimings,    ProcessedResults.DTIsmallAbsMinRsqOrder,    ProcessedResults.DTIsmallAbsMinRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'DTIsmallAbsMin'],    ProcessedResults.DTIsmallAbsMin,    'Minimum path distance absolute DTI small tracts emphasized from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.DTIsmallAbsRevMinRsqTimings, ProcessedResults.DTIsmallAbsRevMinRsqOrder, ProcessedResults.DTIsmallAbsRevMinRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'DTIsmallAbsRevMin'], ProcessedResults.DTIsmallAbsRevMin, 'Minimum path distance absolute reversed DTI small tracts emphasized from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.DTIlargeNormalRsqTimings,    ProcessedResults.DTIlargeNormalRsqOrder,    ProcessedResults.DTIlargeNormalRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'DTIlargeNormal'],    ProcessedResults.DTIlargeNormal,    'DTI large tracts emphasized from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.DTIlargeAbsRsqTimings,       ProcessedResults.DTIlargeAbsRsqOrder,       ProcessedResults.DTIlargeAbsRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'DTIlargeAbs'],       ProcessedResults.DTIlargeAbs,       'Absolute DTI large tracts emphasized from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.DTIlargeMinRsqTimings,       ProcessedResults.DTIlargeMinRsqOrder,       ProcessedResults.DTIlargeMinRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'DTIlargeMin'],       ProcessedResults.DTIlargeMin,       'Minimum path distance DTI large tracts emphasized from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.DTIlargeAbsMinRsqTimings,    ProcessedResults.DTIlargeAbsMinRsqOrder,    ProcessedResults.DTIlargeAbsMinRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'DTIlargeAbsMin'],    ProcessedResults.DTIlargeAbsMin,    'Minimum path distance absolute DTI large tracts emphasized from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.DTIlargeAbsRevMinRsqTimings, ProcessedResults.DTIlargeAbsRevMinRsqOrder, ProcessedResults.DTIlargeAbsRevMinRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'DTIlargeAbsRevMin'], ProcessedResults.DTIlargeAbsRevMin, 'Minimum path distance absolute reversed DTI large tracts emphasized from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);

[ProcessedResults.EffectiveConnectivityNNormalRsqTimings,    ProcessedResults.EffectiveConnectivityNNormalRsqOrder,    ProcessedResults.EffectiveConnectivityNNormalRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivityNNormal'],    ProcessedResults.EffectiveConnectivityNNormal,    'Effective Connectivity FMRI from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivityNAbsRsqTimings,       ProcessedResults.EffectiveConnectivityNAbsRsqOrder,       ProcessedResults.EffectiveConnectivityNAbsRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivityNAbs'],       ProcessedResults.EffectiveConnectivityNAbs,       'Absolute Effective Connectivity FMRI from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivityNMinRsqTimings,       ProcessedResults.EffectiveConnectivityNMinRsqOrder,       ProcessedResults.EffectiveConnectivityNMinRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivityNMin'],       ProcessedResults.EffectiveConnectivityNMin,       'Minimum path distance Effective Connectivity FMRI from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivityNAbsMinRsqTimings,    ProcessedResults.EffectiveConnectivityNAbsMinRsqOrder,    ProcessedResults.EffectiveConnectivityNAbsMinRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivityNAbsMin'],    ProcessedResults.EffectiveConnectivityNAbsMin,    'Minimum path distance absolute Effective Connectivity FMRI from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivityNAbsRevMinRsqTimings, ProcessedResults.EffectiveConnectivityNAbsRevMinRsqOrder, ProcessedResults.EffectiveConnectivityNAbsRevMinRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivityNAbsRevMin'], ProcessedResults.EffectiveConnectivityNAbsRevMin, 'Minimum path distance absolute reversed Effective Connectivity FMRI from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivitySNormalRsqTimings,    ProcessedResults.EffectiveConnectivitySNormalRsqOrder,    ProcessedResults.EffectiveConnectivitySNormalRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivitySNormal'],    ProcessedResults.EffectiveConnectivitySNormal,    'Effective Connectivity DTI small from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivitySAbsRsqTimings,       ProcessedResults.EffectiveConnectivitySAbsRsqOrder,       ProcessedResults.EffectiveConnectivitySAbsRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivitySAbs'],       ProcessedResults.EffectiveConnectivitySAbs,       'Absolute Effective Connectivity DTI small from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivitySMinRsqTimings,       ProcessedResults.EffectiveConnectivitySMinRsqOrder,       ProcessedResults.EffectiveConnectivitySMinRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivitySMin'],       ProcessedResults.EffectiveConnectivitySMin,       'Minimum path distance Effective Connectivity DTI small from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivitySAbsMinRsqTimings,    ProcessedResults.EffectiveConnectivitySAbsMinRsqOrder,    ProcessedResults.EffectiveConnectivitySAbsMinRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivitySAbsMin'],    ProcessedResults.EffectiveConnectivitySAbsMin,    'Minimum path distance absolute Effective Connectivity DTI small from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivitySAbsRevMinRsqTimings, ProcessedResults.EffectiveConnectivitySAbsRevMinRsqOrder, ProcessedResults.EffectiveConnectivitySAbsRevMinRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivitySAbsRevMin'], ProcessedResults.EffectiveConnectivitySAbsRevMin, 'Minimum path distance absolute reversed Effective Connectivity DTI small from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivityLNormalRsqTimings,    ProcessedResults.EffectiveConnectivityLNormalRsqOrder,    ProcessedResults.EffectiveConnectivityLNormalRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivityLNormal'],    ProcessedResults.EffectiveConnectivityLNormal,    'Effective Connectivity DTI large from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivityLAbsRsqTimings,       ProcessedResults.EffectiveConnectivityLAbsRsqOrder,       ProcessedResults.EffectiveConnectivityLAbsRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivityLAbs'],       ProcessedResults.EffectiveConnectivityLAbs,       'Absolute Effective Connectivity DTI large from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivityLMinRsqTimings,       ProcessedResults.EffectiveConnectivityLMinRsqOrder,       ProcessedResults.EffectiveConnectivityLMinRsqEBM]       = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivityLMin'],       ProcessedResults.EffectiveConnectivityLMin,       'Minimum path distance Effective Connectivity DTI large from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivityLAbsMinRsqTimings,    ProcessedResults.EffectiveConnectivityLAbsMinRsqOrder,    ProcessedResults.EffectiveConnectivityLAbsMinRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivityLAbsMin'],    ProcessedResults.EffectiveConnectivityLAbsMin,    'Minimum path distance absolute Effective Connectivity DTI large from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.EffectiveConnectivityLAbsRevMinRsqTimings, ProcessedResults.EffectiveConnectivityLAbsRevMinRsqOrder, ProcessedResults.EffectiveConnectivityLAbsRevMinRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'EffectiveConnectivityLAbsRevMin'], ProcessedResults.EffectiveConnectivityLAbsRevMin, 'Minimum path distance absolute reversed Effective Connectivity DTI large from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);

[ProcessedResults.EuclideanRsqTimings,  ProcessedResults.EuclideanRsqOrder,  ProcessedResults.EuclideanRsqEBM]  = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'Euclidean'],  ProcessedResults.EuclideanNormal, 'Euclidean distances from seed',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.VolumesRsqTimings,    ProcessedResults.VolumesRsqOrder,    ProcessedResults.VolumesRsqEBM]    = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'Volumes'],    ProcessedResults.VolumesNormal,             'Brain regional volume',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);

[ProcessedResults.SSGEDRsqTimings,      ProcessedResults.SSGEDRsqOrder,      ProcessedResults.SSGEDRsqEBM]      = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'SSGED'],      ProcessedResults.SSGED,      'Extracellular Diffusion flow difference',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.SSGWeightsFMRIRsqTimings, ProcessedResults.SSGWeightsFMRIRsqOrder, ProcessedResults.SSGWeightsFMRIRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'SSGWeightsFMRI'], ProcessedResults.SSGWeightsFMRI, 'FMRI Weights flow difference',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.SSGWeightsDTIRsqTimings,  ProcessedResults.SSGWeightsDTIRsqOrder,  ProcessedResults.SSGWeightsDTIRsqEBM]  = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'SSGWeightsDTI'],  ProcessedResults.SSGWeightsDTI,  'DTI Weights flow difference',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.SSGWeightsDCMRsqTimings,  ProcessedResults.SSGWeightsDCMRsqOrder,  ProcessedResults.SSGWeightsDCMRsqEBM]  = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'SSGWeightsDCM'],  ProcessedResults.SSGWeightsDCM,  'DCM Weights flow difference',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.SSGDiffusionFMRIRsqTimings, ProcessedResults.SSGDiffusionFMRIRsqOrder, ProcessedResults.SSGDiffusionFMRIRsqEBM] = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'SSGDiffusionFMRI'], ProcessedResults.SSGDiffusionFMRI, 'FMRI Weights Diffusion flow difference',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.SSGDiffusionDTIRsqTimings,  ProcessedResults.SSGDiffusionDTIRsqOrder,  ProcessedResults.SSGDiffusionDTIRsqEBM]  = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'SSGDiffusionDTI'],  ProcessedResults.SSGDiffusionDTI,  'DTI Weights Diffusion flow difference',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);
[ProcessedResults.SSGDiffusionDCMRsqTimings,  ProcessedResults.SSGDiffusionDCMRsqOrder,  ProcessedResults.SSGDiffusionDCMRsqEBM]  = WholeBrainSingleSubplotMetrics([save_path filenameaddon 'SSGDiffusionDCM'],  ProcessedResults.SSGDiffusionDCM,  'DCM Weights Diffusion flow difference',      ProcessedResults.AbnormalityTimings, SimulationSortIndices, EBM.SortIndices, FontSizeAll, width, height, savefigs);

AtrophyThreshold = 1-(EBM.ThresholdsVolumes./Network.Volumes);
WholeBrainSaveBrainFigure(ProcessedResults.AbnormalityTimings/max(ProcessedResults.AbnormalityTimings), [save_path filenameaddon 'FancyOrder' '.jpg']);
for i = 1:numel(Network.Names)
    timestep = ProcessedResults.AbnormalityTimingsOrdered(i);
    CurrentAtrophy = ProcessedResults.Atrophy(:,timestep);
    % Make sure those which show no substantial atrophy yet do not appear
    for j = 1:numel(CurrentAtrophy)
        if(CurrentAtrophy(j) < AtrophyThreshold(j))
            CurrentAtrophy(j) = 0;
        end
    end
    WholeBrainSaveBrainFigure(CurrentAtrophy, [save_path filenameaddon 'Fancy' num2str(i) '_' num2str(timestep) '.jpg']);
end

close all;
if(savefigs)
    save([save_path 'ProcessedResults' filenameaddon '.mat'], 'ProcessedResults', '-v7.3');
end
end