function Output = WholeBrainRefining(Input, Parameters, Network, EBM)

Parameters.Seedsize                                   = Input(1);
Parameters.ExtracellularDiffusionFraction             = Input(2);
Parameters.ExtracellularDiffusionSpeed                = Input(3);
Parameters.NetworkDiffusionWeightFractionFMRI         = Input(4);
Parameters.NetworkDiffusionWeightFractionDTI          = Input(5);
Parameters.NetworkDiffusionWeightFractionDCM          = Input(6);
Parameters.NetworkDiffusionWeightDistanceFractionFMRI = Input(7);
Parameters.NetworkDiffusionWeightDistanceFractionDTI  = Input(8);
Parameters.NetworkDiffusionWeightDistanceFractionDCM  = Input(9);
Parameters.SynapticTransferWeightFractionFMRI         = Input(10);
Parameters.SynapticTransferWeightFractionDTI          = Input(11);
Parameters.SynapticTransferWeightFractionDCM          = Input(12);
Parameters.SynapticTransferWeightDistanceFractionFMRI = Input(13);
Parameters.SynapticTransferWeightDistanceFractionDTI  = Input(14);
Parameters.SynapticTransferWeightDistanceFractionDCM  = Input(15);
Parameters.NetworkDiffusionSpeed                      = Input(16);
Parameters.NEURONMisfold                              = Input(17);
Parameters.NEURONDiffusionSpeed                       = Input(18) * 1000;
Parameters.NEURONDiffusion                            = Input(19);
Parameters.NEURONTransport                            = Input(20);
Parameters.NEURONSynaptic                             = Input(21);
Parameters.NEURONDamage                               = Input(22);

Parameters.Seed(Parameters.Seedlocation) = Parameters.Seedsize;
Results          = WholeBrainRunSimulation(Network, Parameters, EBM);
ProcessedResults = WholeBrainProcessResults(Network, Results, EBM, Parameters);

Output = ProcessedResults.OptimizeMetric;

disp(Input);
disp(Output);
disp(ProcessedResults.TTNB);

end