function MessageFromNEURON = WholeBrainMATLABGetNEURONInput(NEURONdata, Network, Parameters)

MessageFromNEURON = cell(size(NEURONdata));
for r = 1:Network.NumNodes

    numneurons = NEURONdata{r}.numneurons;
    numdead = sum(NEURONdata{r}.QDmg >= 1)/3;
    numaliveinputs = sum(NEURONdata{r}.InputNeuronSections & NEURONdata{r}.QDmg < 1);
    numdeadinputs  = sum(NEURONdata{r}.InputNeuronSections & NEURONdata{r}.QDmg >= 1);

    OutputNeuronSectionsAlive  = NEURONdata{r}.OutputNeuronSections & NEURONdata{r}.QDmg < 1;
    
    totalquantitynormal     = sum(NEURONdata{r}.Qn);
    totalquantitypathogenic = sum(NEURONdata{r}.Qm);
    
    currentatrophy = numdead/numneurons;
    currentavgconcentrationnormal     = (totalquantitynormal     / numneurons)/(NEURONdata{r}.DendritesVolume+NEURONdata{r}.SomaVolume+NEURONdata{r}.AxonVolume);
    currentavgconcentrationpathogenic = (totalquantitypathogenic / numneurons)/(NEURONdata{r}.DendritesVolume+NEURONdata{r}.SomaVolume+NEURONdata{r}.AxonVolume);
    currentproportioninputsalive = numaliveinputs / (numaliveinputs+numdeadinputs);
    if(Parameters.ExtracellularDiffusionSpeed == 0)
        Parameters.ExtracellularDiffusionFraction = 0;
    end
    currentquantitynormalextracellular     = Parameters.ExtracellularDiffusionFraction * totalquantitynormal;
    currentquantitypathogenicextracellular = Parameters.ExtracellularDiffusionFraction * totalquantitypathogenic;
    
    QnOutputSectionsAlive = NEURONdata{r}.Qn(OutputNeuronSectionsAlive);
    QmOutputSectionsAlive = NEURONdata{r}.Qm(OutputNeuronSectionsAlive);
    currentquantitynormaloutput     = sum(QnOutputSectionsAlive);
    currentquantitypathogenicoutput = sum(QmOutputSectionsAlive);
    CurrentFrequenciesSections = [zeros(2*NEURONdata{r}.numneurons,1);NEURONdata{r}.CurrentFrequency];
    CurrentFrequenciesOutputSectionsAlive = CurrentFrequenciesSections(OutputNeuronSectionsAlive);
    
    SumQnAlive = currentquantitynormaloutput;
    SumQmAlive = currentquantitypathogenicoutput;
    SumQnFreqAlive = sum(CurrentFrequenciesOutputSectionsAlive.*QnOutputSectionsAlive);
    SumQmFreqAlive = sum(CurrentFrequenciesOutputSectionsAlive.*QmOutputSectionsAlive);
    
    currentquantitynormaloutputWeightFMRI             = Parameters.NetworkDiffusionWeightFractionFMRI         * SumQnAlive;
    currentquantitynormaloutputWeightFreqFMRI         = Parameters.SynapticTransferWeightFractionFMRI         * SumQnFreqAlive;
    currentquantitynormaloutputWeightDTI              = Parameters.NetworkDiffusionWeightFractionDTI          * SumQnAlive;
    currentquantitynormaloutputWeightFreqDTI          = Parameters.SynapticTransferWeightFractionDTI          * SumQnFreqAlive;
    currentquantitynormaloutputWeightDCM              = Parameters.NetworkDiffusionWeightFractionDCM          * SumQnAlive;
    currentquantitynormaloutputWeightFreqDCM          = Parameters.SynapticTransferWeightFractionDCM          * SumQnFreqAlive;
    currentquantitynormaloutputWeightDistanceFMRI     = Parameters.NetworkDiffusionWeightDistanceFractionFMRI * SumQnAlive;
    currentquantitynormaloutputWeightDistanceFreqFMRI = Parameters.SynapticTransferWeightDistanceFractionFMRI * SumQnFreqAlive;
    currentquantitynormaloutputWeightDistanceDTI      = Parameters.NetworkDiffusionWeightDistanceFractionDTI  * SumQnAlive;
    currentquantitynormaloutputWeightDistanceFreqDTI  = Parameters.SynapticTransferWeightDistanceFractionDTI  * SumQnFreqAlive;
    currentquantitynormaloutputWeightDistanceDCM      = Parameters.NetworkDiffusionWeightDistanceFractionDCM  * SumQnAlive;
    currentquantitynormaloutputWeightDistanceFreqDCM  = Parameters.SynapticTransferWeightDistanceFractionDCM  * SumQnFreqAlive;
    
    currentquantitypathogenicoutputWeightFMRI             = Parameters.NetworkDiffusionWeightFractionFMRI         * SumQmAlive;
    currentquantitypathogenicoutputWeightFreqFMRI         = Parameters.SynapticTransferWeightFractionFMRI         * SumQmFreqAlive;
    currentquantitypathogenicoutputWeightDTI              = Parameters.NetworkDiffusionWeightFractionDTI          * SumQmAlive;
    currentquantitypathogenicoutputWeightFreqDTI          = Parameters.SynapticTransferWeightFractionDTI          * SumQmFreqAlive;
    currentquantitypathogenicoutputWeightDCM              = Parameters.NetworkDiffusionWeightFractionDCM          * SumQmAlive;
    currentquantitypathogenicoutputWeightFreqDCM          = Parameters.SynapticTransferWeightFractionDCM          * SumQmFreqAlive;
    currentquantitypathogenicoutputWeightDistanceFMRI     = Parameters.NetworkDiffusionWeightDistanceFractionFMRI * SumQmAlive;
    currentquantitypathogenicoutputWeightDistanceFreqFMRI = Parameters.SynapticTransferWeightDistanceFractionFMRI * SumQmFreqAlive;
    currentquantitypathogenicoutputWeightDistanceDTI      = Parameters.NetworkDiffusionWeightDistanceFractionDTI  * SumQmAlive;
    currentquantitypathogenicoutputWeightDistanceFreqDTI  = Parameters.SynapticTransferWeightDistanceFractionDTI  * SumQmFreqAlive;
    currentquantitypathogenicoutputWeightDistanceDCM      = Parameters.NetworkDiffusionWeightDistanceFractionDCM  * SumQmAlive;
    currentquantitypathogenicoutputWeightDistanceFreqDCM  = Parameters.SynapticTransferWeightDistanceFractionDCM  * SumQmFreqAlive;
   
    MessageFromNEURON{r}(1) = currentatrophy;
    MessageFromNEURON{r}(2) = currentavgconcentrationnormal;
    MessageFromNEURON{r}(3) = currentavgconcentrationpathogenic;
    MessageFromNEURON{r}(4) = currentproportioninputsalive;
    MessageFromNEURON{r}(5) = currentquantitynormalextracellular;
    MessageFromNEURON{r}(6) = currentquantitypathogenicextracellular;
    MessageFromNEURON{r}(7) = currentquantitynormaloutput;
    MessageFromNEURON{r}(8) = currentquantitypathogenicoutput;
    
    MessageFromNEURON{r}(9)  = currentquantitynormaloutputWeightFMRI;
    MessageFromNEURON{r}(10) = currentquantitynormaloutputWeightDTI;
    MessageFromNEURON{r}(11) = currentquantitynormaloutputWeightDCM;
    MessageFromNEURON{r}(12) = currentquantitynormaloutputWeightDistanceFMRI;
    MessageFromNEURON{r}(13) = currentquantitynormaloutputWeightDistanceDTI;
    MessageFromNEURON{r}(14) = currentquantitynormaloutputWeightDistanceDCM;
    
    MessageFromNEURON{r}(15) = currentquantitypathogenicoutputWeightFMRI;
    MessageFromNEURON{r}(16) = currentquantitypathogenicoutputWeightDTI;
    MessageFromNEURON{r}(17) = currentquantitypathogenicoutputWeightDCM;
    MessageFromNEURON{r}(18) = currentquantitypathogenicoutputWeightDistanceFMRI;
    MessageFromNEURON{r}(19) = currentquantitypathogenicoutputWeightDistanceDTI;
    MessageFromNEURON{r}(20) = currentquantitypathogenicoutputWeightDistanceDCM;
    
    MessageFromNEURON{r}(21) = currentquantitynormaloutputWeightFreqFMRI;
    MessageFromNEURON{r}(22) = currentquantitynormaloutputWeightFreqDTI;
    MessageFromNEURON{r}(23) = currentquantitynormaloutputWeightFreqDCM;
    MessageFromNEURON{r}(24) = currentquantitynormaloutputWeightDistanceFreqFMRI;
    MessageFromNEURON{r}(25) = currentquantitynormaloutputWeightDistanceFreqDTI;
    MessageFromNEURON{r}(26) = currentquantitynormaloutputWeightDistanceFreqDCM;
    
    MessageFromNEURON{r}(27) = currentquantitypathogenicoutputWeightFreqFMRI;
    MessageFromNEURON{r}(28) = currentquantitypathogenicoutputWeightFreqDTI;
    MessageFromNEURON{r}(29) = currentquantitypathogenicoutputWeightFreqDCM;
    MessageFromNEURON{r}(30) = currentquantitypathogenicoutputWeightDistanceFreqFMRI;
    MessageFromNEURON{r}(31) = currentquantitypathogenicoutputWeightDistanceFreqDTI;
    MessageFromNEURON{r}(32) = currentquantitypathogenicoutputWeightDistanceFreqDCM;
    
end
end




