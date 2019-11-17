function AllParams = WholeBrainOptimizationPassParameters(Input, AllParams)
%if input is negative, then keep the default parameter set at
%WholeBrainInitialization
%Also scale parameters by the appropriate amount

if(Input(1) >= 0)AllParams.Seedsize                                   = Input(1);end

if(Input(2) >= 0)AllParams.ExtracellularDiffusionFraction             = Input(2);end
if(Input(3) >= 0)AllParams.ExtracellularDiffusionSpeed                = Input(3);end

if(Input(4) >= 0)AllParams.NetworkDiffusionWeightFractionFMRI         = Input(4);end
if(Input(5) >= 0)AllParams.NetworkDiffusionWeightFractionDTI          = Input(5);end
if(Input(6) >= 0)AllParams.NetworkDiffusionWeightFractionDCM          = Input(6);end
if(Input(7) >= 0)AllParams.NetworkDiffusionWeightDistanceFractionFMRI = Input(7);end
if(Input(8) >= 0)AllParams.NetworkDiffusionWeightDistanceFractionDTI  = Input(8);end
if(Input(9) >= 0)AllParams.NetworkDiffusionWeightDistanceFractionDCM  = Input(9);end
if(Input(10) >= 0)AllParams.SynapticTransferWeightFractionFMRI         = Input(10);end
if(Input(11) >= 0)AllParams.SynapticTransferWeightFractionDTI          = Input(11);end
if(Input(12) >= 0)AllParams.SynapticTransferWeightFractionDCM          = Input(12);end
if(Input(13) >= 0)AllParams.SynapticTransferWeightDistanceFractionFMRI = Input(13);end
if(Input(14) >= 0)AllParams.SynapticTransferWeightDistanceFractionDTI  = Input(14);end
if(Input(15) >= 0)AllParams.SynapticTransferWeightDistanceFractionDCM  = Input(15);end

if(Input(16) >= 0)AllParams.NetworkDiffusionSpeed                      = Input(16);end

if(Input(17) >= 0)AllParams.NEURONMisfold                              = Input(17);end
if(Input(18) >= 0)AllParams.NEURONDiffusionSpeed                       = Input(18);end
if(Input(19) >= 0)AllParams.NEURONDiffusion                            = Input(19);end
if(Input(20) >= 0)AllParams.NEURONTransport                            = Input(20);end
if(Input(21) >= 0)AllParams.NEURONSynaptic                             = Input(21);end
if(Input(22) >= 0)AllParams.NEURONDamage                               = Input(22);end


end