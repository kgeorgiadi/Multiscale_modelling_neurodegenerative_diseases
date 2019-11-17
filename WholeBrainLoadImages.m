function [Network, EBM] = WholeBrainLoadImages(AllParams)
%% If fMRI have not been smoothed with 6mm FWHM Gaussian kernel, set 3rd parameter to true
WholeBrainSmoothFMRI(AllParams.fmri_path, AllParams.ImageNumbers, AllParams.PerformSmoothing);

%% Extract CSF and White matter masks for DCM confound regression
WholeBrainGenerateCSFandWMparcellations(AllParams.ImageNumbers, AllParams.fmri_path, AllParams.GenerateCSFandWMparcellations);

%% Extract Brain Region Volumes
%(Inactive white matter, CSF and cerebellum)
[Names, Mapping, PopulationAverageVolumes, Symmetry, Tissues, Active] = WholeBrainGetVolumetricData(AllParams.parcellation_path, AllParams.ImageNumbers, AllParams.WhichDisease);

%% Extract Brain Region Coordinates
Coordinates = WholeBrainGetRegionCoordinates(Mapping, AllParams.ImageNumbers, AllParams.parcellation_path, AllParams.WhichDisease);

%% Extract BOLD Signals
[PopulationBOLDSignals, BOLDSignals] = WholeBrainExtractBOLDSignals(AllParams.ImageNumbers, AllParams.fmri_path, Mapping, Symmetry, AllParams.BOLDUseSmoothedImage, AllParams.BOLDDemean, AllParams.BOLDNormalize, AllParams.ComputeBOLD, AllParams.WhichDisease);

%% Extract Synaptic Signals
[PopulationSynapticSignals, SynapticSignals] = WholeBrainSynapticSignals(Mapping, Symmetry, Tissues, Names, AllParams.ImageNumbers, AllParams.fmri_path, AllParams.SynapticUseSmoothedImage, AllParams.ComputeSynapticSignals, AllParams.WhichDisease);

%% Get DTI for each subject
DTIsSmall = WholeBrainDTIprocessing(AllParams.dti_path, AllParams.ImageNumbers, Mapping, Symmetry, true, AllParams.WhichDisease);
DTIsLarge = WholeBrainDTIprocessing(AllParams.dti_path, AllParams.ImageNumbers, Mapping, Symmetry, false, AllParams.WhichDisease);
if(AllParams.DTISmallConnectionsEmphasized)
    DTIs = DTIsSmall;
else
    DTIs = DTIsLarge;
end
if(AllParams.TractographyPriorSmall)
    DTIsDCM = DTIsSmall;
else
    DTIsDCM = DTIsLarge;
end


%% Make Symmetric Brain - remove left side
[PopulationAverageVolumes, Active] = WholeBrainRemoveLeftSide(Symmetry, Names, Mapping, Active, PopulationAverageVolumes);

%% Choose nodes to keep based on EBM
[Active, ChosenNodes] = WholeBrainChooseNodesEBM(AllParams.EBMorAllnodes, AllParams.DiseaseGroundTruthSequence, Mapping, Active);

%% Derive effective connectivity
WholeBrainDCMpreprocessing(AllParams.fmri_path, AllParams.ImageNumbers, Mapping, Symmetry, Tissues, Active, Names, AllParams.DoDCMpreprocessing, AllParams.WhichDisease);
[EffectiveConnectivityPEB, EffectiveConnectivityBMA, DCMAll, MeanEffectiveConnectivity] = WholeBrainDCM(AllParams.ImageNumbers, Mapping, Active, Names, AllParams.fmri_path, ChosenNodes, DTIsDCM, AllParams.TractographyPrior, AllParams.TractographyPriorValues, AllParams.TractographyPriorSmall, AllParams.EBMorAllnodes, AllParams.DiseaseName, AllParams.DiseaseNumRegions, AllParams.ComputeDCM, AllParams.SkipDCM);
[EffectiveConnectivityPEBn, EffectiveConnectivityBMAn, DCMAlln, MeanEffectiveConnectivityn] = WholeBrainDCM(AllParams.ImageNumbers, Mapping, Active, Names, AllParams.fmri_path, ChosenNodes, DTIsDCM,   false, AllParams.TractographyPriorValues, false, AllParams.EBMorAllnodes, AllParams.DiseaseName, AllParams.DiseaseNumRegions, AllParams.ComputeDCM, AllParams.SkipDCM);
[EffectiveConnectivityPEBs, EffectiveConnectivityBMAs, DCMAlls, MeanEffectiveConnectivitys] = WholeBrainDCM(AllParams.ImageNumbers, Mapping, Active, Names, AllParams.fmri_path, ChosenNodes, DTIsSmall, true,  AllParams.TractographyPriorValues, true,  AllParams.EBMorAllnodes, AllParams.DiseaseName, AllParams.DiseaseNumRegions, AllParams.ComputeDCM, AllParams.SkipDCM);
[EffectiveConnectivityPEBl, EffectiveConnectivityBMAl, DCMAlll, MeanEffectiveConnectivityl] = WholeBrainDCM(AllParams.ImageNumbers, Mapping, Active, Names, AllParams.fmri_path, ChosenNodes, DTIsLarge, true,  AllParams.TractographyPriorValues, false, AllParams.EBMorAllnodes, AllParams.DiseaseName, AllParams.DiseaseNumRegions, AllParams.ComputeDCM, AllParams.SkipDCM);

%% Processing of extracted data
Network = WholeBrainProcessData1(Names, Mapping, Active, PopulationAverageVolumes, Coordinates, PopulationBOLDSignals, BOLDSignals, PopulationSynapticSignals, SynapticSignals, DTIs, EffectiveConnectivityPEB, EffectiveConnectivityBMA, MeanEffectiveConnectivity, DTIsSmall, DTIsLarge, EffectiveConnectivityBMAn, EffectiveConnectivityBMAs, EffectiveConnectivityBMAl);

%% Derive Ground Truth
EBM = WholeBrainGenerateGroundTruth(Network, AllParams.DiseaseName, AllParams.DiseaseGroundTruthSequence);
cd(AllParams.start_path);
end