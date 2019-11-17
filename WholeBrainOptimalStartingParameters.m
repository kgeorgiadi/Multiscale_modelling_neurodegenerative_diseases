function AllParams = WholeBrainOptimalStartingParameters(Network, EBM, AllParams)
%Parameters to optimise over. If negative, the parameter will not be
%optimised. If negative the corresponding element of the simulation will
%not run.
%Parameters are optimised over the 0-1 range. Parameters can be scaled
%after they have been passed to the optimisation
AllParams.MyInput = [AllParams.Seedsize; ...
    AllParams.ExtracellularDiffusionFraction; ...
    AllParams.ExtracellularDiffusionSpeed; ...
    AllParams.NetworkDiffusionWeightFractionFMRI; ...
    AllParams.NetworkDiffusionWeightFractionDTI; ...
    AllParams.NetworkDiffusionWeightFractionDCM; ...
    AllParams.NetworkDiffusionWeightDistanceFractionFMRI; ...
    AllParams.NetworkDiffusionWeightDistanceFractionDTI; ...
    AllParams.NetworkDiffusionWeightDistanceFractionDCM; ...
    AllParams.SynapticTransferWeightFractionFMRI; ...
    AllParams.SynapticTransferWeightFractionDTI; ...
    AllParams.SynapticTransferWeightFractionDCM; ...
    AllParams.SynapticTransferWeightDistanceFractionFMRI; ...
    AllParams.SynapticTransferWeightDistanceFractionDTI; ...
    AllParams.SynapticTransferWeightDistanceFractionDCM; ...
    AllParams.NetworkDiffusionSpeed; ...
    
    AllParams.NEURONMisfold; ...
    AllParams.NEURONDiffusionSpeed; ...
    AllParams.NEURONDiffusion; ...
    AllParams.NEURONTransport; ...
    AllParams.NEURONSynaptic; ...
    AllParams.NEURONDamage];

AllParams.InputScaling = [0.1; ...
    1; ...
    1; ...
    
    1; ...
    1; ...
    1; ...
    1; ...
    1; ...
    1; ...
    1; ...
    1; ...
    1; ...
    1; ...
    1; ...
    1; ...
    
    1; ...
    
    1; ...
    1000; ...
    1; ...
    1; ...
    1; ...
    0.1];

AllParams.InputABound = [];
AllParams.InputBBound = [];
AllParams.InputABound = [0 1 0 1 1    1 1 1 1 1   1 1 1 1 1    0 0 0 0 0   0 0 ; ...
    0 0 0 0 0    0 0 0 0 0   0 0 0 0 0    0 0 0 1 1   1 0];
AllParams.InputBBound = [1; ...
    1];

AllParams.InputUBound = ones(size(AllParams.MyInput));
AllParams.InputLBound = zeros(size(AllParams.MyInput));

if(AllParams.GuessStartingOptimals)
    for i = 1:size(Network.ZBOLDCorrelationMatrix,1)
        Network.ZBOLDCorrelationMatrix(i,i) = 3;
        Network.ZSynapticCorrelationMatrix(i,i) = 3;
    end
    Parameters.NetworkDiffusionAlgorithmThreshold = 1;
    Parameters.NetworkDiffusionFraction = 1;
    PropInputsAlive = ones(size(Network.Volumes));
    startstep = 0.00000000001;
    multiplier = 1.05;
    endingstep = 1;
    iternum = 0;
    speedvals = [];
    while(true)
        Speed = startstep*multiplier^iternum;
        if(Speed > endingstep)
            Speed = endingstep;
        end
        iternum = iternum+1;
        speedvals(1,iternum) = Speed;
        
        %Create Spread matrices
        Network.ED = CalculateExtracellularDiffusionMatrix(Network.NumNodes, Network.EuclideanDistances, Network.Radius, true(size(Network.Volumes)), Speed);
        
        Network.DifBOLDR   = CalculateNetworkDiffusionMatrix(Network.NumNodes, Network.Radius, Network.Volumes, true(size(Network.Volumes)), Network.RBOLDCorrelationMatrix, Parameters, Speed);
        Network.DifBOLDZ   = CalculateNetworkDiffusionMatrix(Network.NumNodes, Network.Radius, Network.Volumes, true(size(Network.Volumes)), Network.ZBOLDCorrelationMatrix, Parameters, Speed);
        Network.DifSynapticR   = CalculateNetworkDiffusionMatrix(Network.NumNodes, Network.Radius, Network.Volumes, true(size(Network.Volumes)), Network.RSynapticCorrelationMatrix, Parameters, Speed);
        Network.DifSynapticZ   = CalculateNetworkDiffusionMatrix(Network.NumNodes, Network.Radius, Network.Volumes, true(size(Network.Volumes)), Network.ZSynapticCorrelationMatrix, Parameters, Speed);
        Network.DifDTIsmall   = CalculateNetworkDiffusionMatrix(Network.NumNodes, Network.Radius, Network.Volumes, true(size(Network.Volumes)), Network.DTIsmall, Parameters, Speed);
        Network.DifDTIlarge   = CalculateNetworkDiffusionMatrix(Network.NumNodes, Network.Radius, Network.Volumes, true(size(Network.Volumes)), Network.DTIlarge, Parameters, Speed);
        Network.DifEffectiveConnectivityN   = CalculateNetworkDiffusionMatrix(Network.NumNodes, Network.Radius, Network.Volumes, true(size(Network.Volumes)), Network.EffectiveConnectivityN, Parameters, Speed);
        Network.DifEffectiveConnectivityS   = CalculateNetworkDiffusionMatrix(Network.NumNodes, Network.Radius, Network.Volumes, true(size(Network.Volumes)), Network.EffectiveConnectivityS, Parameters, Speed);
        Network.DifEffectiveConnectivityL   = CalculateNetworkDiffusionMatrix(Network.NumNodes, Network.Radius, Network.Volumes, true(size(Network.Volumes)), Network.EffectiveConnectivityL, Parameters, Speed);
        
        Network.STBOLDR   = CalculateSynapticTransferMatrix(Network.NumNodes, true(size(Network.Volumes)), Network.Volumes, Network.RBOLDCorrelationMatrix, Network.Frequencies, Network.MaximumFrequency, Speed, Speed);
        Network.STBOLDZ   = CalculateSynapticTransferMatrix(Network.NumNodes, true(size(Network.Volumes)), Network.Volumes, Network.ZBOLDCorrelationMatrix, Network.Frequencies, Network.MaximumFrequency, Speed, Speed);
        Network.STSynapticR   = CalculateSynapticTransferMatrix(Network.NumNodes, true(size(Network.Volumes)), Network.Volumes, Network.RSynapticCorrelationMatrix, Network.Frequencies, Network.MaximumFrequency, Speed, Speed);
        Network.STSynapticZ   = CalculateSynapticTransferMatrix(Network.NumNodes, true(size(Network.Volumes)), Network.Volumes, Network.ZSynapticCorrelationMatrix, Network.Frequencies, Network.MaximumFrequency, Speed, Speed);
        Network.STDTIsmall   = CalculateSynapticTransferMatrix(Network.NumNodes, true(size(Network.Volumes)), Network.Volumes, Network.DTIsmall, Network.Frequencies, Network.MaximumFrequency, Speed, Speed);
        Network.STDTIlarge   = CalculateSynapticTransferMatrix(Network.NumNodes, true(size(Network.Volumes)), Network.Volumes, Network.DTIlarge, Network.Frequencies, Network.MaximumFrequency, Speed, Speed);
        Network.STEffectiveConnectivityN   = CalculateSynapticTransferMatrix(Network.NumNodes, true(size(Network.Volumes)), Network.Volumes, Network.EffectiveConnectivityN, Network.Frequencies, Network.MaximumFrequency, Speed, Speed);
        Network.STEffectiveConnectivityS   = CalculateSynapticTransferMatrix(Network.NumNodes, true(size(Network.Volumes)), Network.Volumes, Network.EffectiveConnectivityS, Network.Frequencies, Network.MaximumFrequency, Speed, Speed);
        Network.STEffectiveConnectivityL   = CalculateSynapticTransferMatrix(Network.NumNodes, true(size(Network.Volumes)), Network.Volumes, Network.EffectiveConnectivityL, Network.Frequencies, Network.MaximumFrequency, Speed, Speed);
        
        % Modifications for upscaling
        Network.DifBOLDR = WholeBrainUpscalingSpreadModification(Network.DifBOLDR, PropInputsAlive);
        Network.DifBOLDZ = WholeBrainUpscalingSpreadModification(Network.DifBOLDZ, PropInputsAlive);
        Network.DifSynapticR = WholeBrainUpscalingSpreadModification(Network.DifSynapticR, PropInputsAlive);
        Network.DifSynapticZ = WholeBrainUpscalingSpreadModification(Network.DifSynapticZ, PropInputsAlive);
        Network.DifDTIsmall = WholeBrainUpscalingSpreadModification(Network.DifDTIsmall, PropInputsAlive);
        Network.DifDTIlarge = WholeBrainUpscalingSpreadModification(Network.DifDTIlarge, PropInputsAlive);
        Network.DifEffectiveConnectivityN = WholeBrainUpscalingSpreadModification(Network.DifEffectiveConnectivityN, PropInputsAlive);
        Network.DifEffectiveConnectivityS = WholeBrainUpscalingSpreadModification(Network.DifEffectiveConnectivityS, PropInputsAlive);
        Network.DifEffectiveConnectivityL = WholeBrainUpscalingSpreadModification(Network.DifEffectiveConnectivityL, PropInputsAlive);
        
        Network.STBOLDR = WholeBrainUpscalingSpreadModification(Network.STBOLDR, PropInputsAlive);
        Network.STBOLDZ = WholeBrainUpscalingSpreadModification(Network.STBOLDZ, PropInputsAlive);
        Network.STSynapticR = WholeBrainUpscalingSpreadModification(Network.STSynapticR, PropInputsAlive);
        Network.STSynapticZ = WholeBrainUpscalingSpreadModification(Network.STSynapticZ, PropInputsAlive);
        Network.STDTIsmall = WholeBrainUpscalingSpreadModification(Network.STDTIsmall, PropInputsAlive);
        Network.STDTIlarge = WholeBrainUpscalingSpreadModification(Network.STDTIlarge, PropInputsAlive);
        Network.STEffectiveConnectivityN = WholeBrainUpscalingSpreadModification(Network.STEffectiveConnectivityN, PropInputsAlive);
        Network.STEffectiveConnectivityS = WholeBrainUpscalingSpreadModification(Network.STEffectiveConnectivityS, PropInputsAlive);
        Network.STEffectiveConnectivityL = WholeBrainUpscalingSpreadModification(Network.STEffectiveConnectivityL, PropInputsAlive);
        
        ProcessedResults.SSGED = sum(Network.ED')'   - sum(Network.ED)';
        
        ProcessedResults.SSGDifBOLDR = sum(Network.DifBOLDR')'   - sum(Network.DifBOLDR)';
        ProcessedResults.SSGDifBOLDZ = sum(Network.DifBOLDZ')'   - sum(Network.DifBOLDZ)';
        ProcessedResults.SSGDifSynapticR = sum(Network.DifSynapticR')'   - sum(Network.DifSynapticR)';
        ProcessedResults.SSGDifSynapticZ = sum(Network.DifSynapticZ')'   - sum(Network.DifSynapticZ)';
        ProcessedResults.SSGDifDTIsmall = sum(Network.DifDTIsmall')'   - sum(Network.DifDTIsmall)';
        ProcessedResults.SSGDifDTIlarge = sum(Network.DifDTIlarge')'   - sum(Network.DifDTIlarge)';
        ProcessedResults.SSGDifEffectiveConnectivityN = sum(Network.DifEffectiveConnectivityN')'   - sum(Network.DifEffectiveConnectivityN)';
        ProcessedResults.SSGDifEffectiveConnectivityS = sum(Network.DifEffectiveConnectivityS')'   - sum(Network.DifEffectiveConnectivityS)';
        ProcessedResults.SSGDifEffectiveConnectivityL = sum(Network.DifEffectiveConnectivityL')'   - sum(Network.DifEffectiveConnectivityL)';
        
        ProcessedResults.SSGSTBOLDR = sum(Network.STBOLDR')'   - sum(Network.STBOLDR)';
        ProcessedResults.SSGSTBOLDZ = sum(Network.STBOLDZ')'   - sum(Network.STBOLDZ)';
        ProcessedResults.SSGSTSynapticR = sum(Network.STSynapticR')'   - sum(Network.STSynapticR)';
        ProcessedResults.SSGSTSynapticZ = sum(Network.STSynapticZ')'   - sum(Network.STSynapticZ)';
        ProcessedResults.SSGSTDTIsmall = sum(Network.STDTIsmall')'   - sum(Network.STDTIsmall)';
        ProcessedResults.SSGSTDTIlarge = sum(Network.STDTIlarge')'   - sum(Network.STDTIlarge)';
        ProcessedResults.SSGSTEffectiveConnectivityN = sum(Network.STEffectiveConnectivityN')'   - sum(Network.STEffectiveConnectivityN)';
        ProcessedResults.SSGSTEffectiveConnectivityS = sum(Network.STEffectiveConnectivityS')'   - sum(Network.STEffectiveConnectivityS)';
        ProcessedResults.SSGSTEffectiveConnectivityL = sum(Network.STEffectiveConnectivityL')'   - sum(Network.STEffectiveConnectivityL)';
        
        Results(iternum, 1) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGED);
        
        Results(iternum, 2) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGDifBOLDR);
        Results(iternum, 3) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGDifBOLDZ);
        Results(iternum, 4) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGDifSynapticR);
        Results(iternum, 5) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGDifSynapticZ);
        Results(iternum, 6) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGDifDTIsmall);
        Results(iternum, 7) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGDifDTIlarge);
        Results(iternum, 8) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGDifEffectiveConnectivityN);
        Results(iternum, 9) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGDifEffectiveConnectivityS);
        Results(iternum, 10) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGDifEffectiveConnectivityL);
        
        Results(iternum, 11) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGSTBOLDR);
        Results(iternum, 12) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGSTBOLDZ);
        Results(iternum, 13) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGSTSynapticR);
        Results(iternum, 14) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGSTSynapticZ);
        Results(iternum, 15) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGSTDTIsmall);
        Results(iternum, 16) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGSTDTIlarge);
        Results(iternum, 17) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGSTEffectiveConnectivityN);
        Results(iternum, 18) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGSTEffectiveConnectivityS);
        Results(iternum, 19) = WholeBrainRSQ(EBM.SortIndices, ProcessedResults.SSGSTEffectiveConnectivityL);
        if(Speed == 1)
            break;
        end
    end
    [maxvals, maxind] = max(Results);
    % figure;plot(speedvals,Results(:,1)); legend;
    % figure;plot(speedvals,Results(:,2:5)); legend;
    % figure;plot(speedvals,Results(:,6:7)); legend;
    % figure;plot(speedvals,Results(:,8:10)); legend;
    % figure;plot(speedvals,Results(:,11:14)); legend;
    % figure;plot(speedvals,Results(:,15:16)); legend;
    % figure;plot(speedvals,Results(:,17:19)); legend;
    % figure;plot(speedvals,Results); legend;
    
    
    
    if(AllParams.WhichDisease == 1)
        AllParams.MyInput(2) = 0.03266; % ED min   0.00004 4e-5
        AllParams.MyInput(3) = 0.001;       % FMRI min 0.0007
        if(AllParams.DTIspread < 4)
            AllParams.MyInput(4) = 0.00246; % DTI min 0.0007
        else
            AllParams.MyInput(4) = 0.002848;
        end
        if(AllParams.DCMspread < 4)
            AllParams.MyInput(5) = 0.001; %DCM min 0.0007
        elseif(AllParams.DCMspread < 7)
            AllParams.MyInput(5) = 0.001;
        else
            AllParams.MyInput(5) = 0.001;
        end
        AllParams.MyInput(6) = 0;
        AllParams.MyInput(7) = 0;
        AllParams.MyInput(8) = 0;
    else
        dummy = 0;
    end
end


ABoundUpper = eye(numel(AllParams.MyInput));
ABoundLower = -eye(numel(AllParams.MyInput));
BBoundUpper = ones(numel(AllParams.MyInput),1);
BBoundLower = zeros(numel(AllParams.MyInput),1);

%if any input value is negative, i.e. deactivate it, don't optimise over
%it.
for i = 1:numel(AllParams.MyInput)
    if(AllParams.MyInput(i) < 0)
        BBoundUpper(i) = AllParams.MyInput(i);
        BBoundLower(i) = AllParams.MyInput(i);
    end
end

AllParams.InputABound = [AllParams.InputABound; ABoundUpper; ABoundLower];
AllParams.InputBBound = [AllParams.InputBBound; BBoundUpper; BBoundLower];

end