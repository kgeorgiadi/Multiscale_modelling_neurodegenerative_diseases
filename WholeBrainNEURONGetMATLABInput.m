function NEURONdata = WholeBrainNEURONGetMATLABInput(NEURONdata, Network)

for r = 1:Network.NumNodes  
    
    NEURONdata{r}.ExtracellularSectionsAlive = NEURONdata{r}.QDmg < 1;
    NEURONdata{r}.InputNeuronSectionsAlive   = NEURONdata{r}.InputNeuronSections & NEURONdata{r}.ExtracellularSectionsAlive;
    NEURONdata{r}.OutputNeuronSectionsAlive  = NEURONdata{r}.OutputNeuronSections & NEURONdata{r}.ExtracellularSectionsAlive;
    
    QnOutputSectionsAlive = NEURONdata{r}.Qn(NEURONdata{r}.OutputNeuronSectionsAlive);
    QmOutputSectionsAlive = NEURONdata{r}.Qm(NEURONdata{r}.OutputNeuronSectionsAlive);
    
    NEURONdata{r}.OutputNeuronSectionsAliveQuantityNormal    = sum(QnOutputSectionsAlive);
    NEURONdata{r}.OutputNeuronSectionsAliveQuantityMisfolded = sum(QmOutputSectionsAlive);
    NEURONdata{r}.ExtracellularQuantityNormal                = sum(NEURONdata{r}.Qn);
    NEURONdata{r}.ExtracellularQuantityMisfolded             = sum(NEURONdata{r}.Qm);
    
    NumInputNeuronsAlive         = sum(NEURONdata{r}.InputNeuronSectionsAlive);
    NumExtracellularNeuronsAlive = sum(NEURONdata{r}.ExtracellularSectionsAlive)/3;
    
    CurrentFrequenciesSections = [zeros(2*NEURONdata{r}.numneurons,1);NEURONdata{r}.CurrentFrequency];
    CurrentFrequenciesOutputSectionsAlive = CurrentFrequenciesSections(NEURONdata{r}.OutputNeuronSectionsAlive);
    
    SumQnAlive = NEURONdata{r}.OutputNeuronSectionsAliveQuantityNormal;
    SumQmAlive = NEURONdata{r}.OutputNeuronSectionsAliveQuantityMisfolded;
    SumQnFreqAlive = sum(CurrentFrequenciesOutputSectionsAlive.*QnOutputSectionsAlive);
    SumQmFreqAlive = sum(CurrentFrequenciesOutputSectionsAlive.*QmOutputSectionsAlive);
    
    QnOutputSectionsAliveZeroed = NEURONdata{r}.Qn;
    QnOutputSectionsAliveZeroed(~NEURONdata{r}.OutputNeuronSectionsAlive) = 0;
    QmOutputSectionsAliveZeroed = NEURONdata{r}.Qm;
    QmOutputSectionsAliveZeroed(~NEURONdata{r}.OutputNeuronSectionsAlive) = 0;
    QnOutputSectionsAliveFreqZeroed = QnOutputSectionsAliveZeroed .* CurrentFrequenciesSections;
    QmOutputSectionsAliveFreqZeroed = QmOutputSectionsAliveZeroed .* CurrentFrequenciesSections;
    
    QnChange = zeros(size(NEURONdata{r}.Qn));
    QmChange = zeros(size(NEURONdata{r}.Qm));
    
    %Remove extracellular leaving protein
    fractionleavingN = 0;
    fractionleavingM = 0;
    if(NEURONdata{r}.ExtracellularQuantityNormal > 0)
        fractionleavingN = NEURONdata{r}.QuantityExtracellularLeavingNormal/NEURONdata{r}.ExtracellularQuantityNormal;
    end
    if(NEURONdata{r}.ExtracellularQuantityMisfolded > 0)
        fractionleavingM = NEURONdata{r}.QuantityExtracellularLeavingMisfolded/NEURONdata{r}.ExtracellularQuantityMisfolded;
    end
    QnChange = QnChange - fractionleavingN*NEURONdata{r}.Qn;
    QmChange = QmChange - fractionleavingM*NEURONdata{r}.Qm;
    
    %Remove axonal output protein
    QnLeaving = NEURONdata{r}.QuantityOutputNormal;
    QnLeavingFreq = NEURONdata{r}.QuantityOutputNormalFreq;
    QmLeaving = NEURONdata{r}.QuantityOutputMisfolded;
    QmLeavingFreq = NEURONdata{r}.QuantityOutputMisfoldedFreq;
    if(SumQnAlive > 0)
        QnLeavingFraction = QnLeaving/SumQnAlive;
        QnChange = QnChange - QnLeavingFraction*QnOutputSectionsAliveZeroed;
    end
    if(SumQnFreqAlive > 0)
        QnLeavingFreqFraction = QnLeavingFreq/SumQnFreqAlive;
        QnChange = QnChange - QnLeavingFreqFraction*QnOutputSectionsAliveFreqZeroed;
    end
    if(SumQmAlive > 0)
        QmLeavingFraction = QmLeaving/SumQmAlive;
        QmChange = QmChange - QmLeavingFraction*QmOutputSectionsAliveZeroed;
    end
    if(SumQmFreqAlive > 0)
        QmLeavingFreqFraction = QmLeavingFreq/SumQmFreqAlive;
        QmChange = QmChange - QmLeavingFreqFraction*QmOutputSectionsAliveFreqZeroed;
    end
    
    NEURONdata{r}.Qn = NEURONdata{r}.Qn + QnChange;
    NEURONdata{r}.Qm = NEURONdata{r}.Qm + QmChange;
    
    %Introduce dendrite input protein
    NEURONdata{r}.Qn(NEURONdata{r}.InputNeuronSectionsAlive) = NEURONdata{r}.Qn(NEURONdata{r}.InputNeuronSectionsAlive) + NEURONdata{r}.QuantityInputNormal/NumInputNeuronsAlive;
    NEURONdata{r}.Qm(NEURONdata{r}.InputNeuronSectionsAlive) = NEURONdata{r}.Qm(NEURONdata{r}.InputNeuronSectionsAlive) + NEURONdata{r}.QuantityInputMisfolded/NumInputNeuronsAlive;
    
    %Introduce extracellular incoming protein
    NEURONdata{r}.Qn(NEURONdata{r}.ExtracellularSectionsAlive) = NEURONdata{r}.Qn(NEURONdata{r}.ExtracellularSectionsAlive) + NEURONdata{r}.QVolumePercentage(NEURONdata{r}.ExtracellularSectionsAlive).*(NEURONdata{r}.QuantityExtracellularEnteringNormal/NumExtracellularNeuronsAlive);
    NEURONdata{r}.Qm(NEURONdata{r}.ExtracellularSectionsAlive) = NEURONdata{r}.Qm(NEURONdata{r}.ExtracellularSectionsAlive) + NEURONdata{r}.QVolumePercentage(NEURONdata{r}.ExtracellularSectionsAlive).*(NEURONdata{r}.QuantityExtracellularEnteringMisfolded/NumExtracellularNeuronsAlive);
    
    %normalise quantities
    NEURONdata{r}.Qn(NEURONdata{r}.Qn < 0) = 0;
    NEURONdata{r}.Qm(NEURONdata{r}.Qm < 0) = 0;
    quantitysum = NEURONdata{r}.Qn + NEURONdata{r}.Qm;
    overlimit = quantitysum > NEURONdata{r}.QVolume;
    NEURONdata{r}.Qn(overlimit) = NEURONdata{r}.Qn(overlimit)./quantitysum(overlimit);
    NEURONdata{r}.Qm(overlimit) = NEURONdata{r}.Qm(overlimit)./quantitysum(overlimit);
end

end










