function NEURONdata = WholeBrainNEURONProcessing(NEURONdata, Network)

for r = 1:Network.NumNodes
    QnDiff = zeros(size(NEURONdata{r}.Qn));
    QmDiff = zeros(size(NEURONdata{r}.Qm));
    
    Alive = NEURONdata{r}.QDmg < 1;
    SomasAlive = NEURONdata{r}.QSoma & Alive;
    
    %Production - only at alive somas
    QnDiff(SomasAlive) = NEURONdata{r}.ProductionRateNormal*NEURONdata{r}.SomaVolume;
    if(NEURONdata{r}.InsolubleProtein == 0)
        QmDiff(SomasAlive) = NEURONdata{r}.ProductionRateMisfolded*NEURONdata{r}.SomaVolume;
    end
    
    %Clearance - only at alive sections
    QnDiff(Alive) = QnDiff(Alive) - log(1+(exp(1)-1)*(NEURONdata{r}.Qn(Alive)./NEURONdata{r}.QVolume(Alive))/NEURONdata{r}.ClearanceNormalLevel).*(NEURONdata{r}.ClearanceRateNormal*NEURONdata{r}.QVolume(Alive));
    if(NEURONdata{r}.InsolubleProtein == 0)
        QmDiff(Alive) = QmDiff(Alive) - log(1+(exp(1)-1)*(NEURONdata{r}.Qm(Alive)./NEURONdata{r}.QVolume(Alive))/NEURONdata{r}.ClearanceMisfoldedLevel).*(NEURONdata{r}.ClearanceRateMisfolded*NEURONdata{r}.QVolume(Alive));
    end
    
    %Misfolding - everywhere
    converted = (NEURONdata{r}.MisfoldFactor .* NEURONdata{r}.Qn .* NEURONdata{r}.Qm) ./ NEURONdata{r}.QVolume;

    %Diffusion - can diffuse out of any section, but only into alive
    %sections, change the matrix to reflect that
    DifN = NEURONdata{r}.PassiveDiffusionFraction*NEURONdata{r}.Qn;
    DifM = NEURONdata{r}.PassiveDiffusionFraction*NEURONdata{r}.Qm;
    %Active transport - any section
    ActN = NEURONdata{r}.ActiveTransportFraction*NEURONdata{r}.Qn;
    ActM = NEURONdata{r}.ActiveTransportFraction*NEURONdata{r}.Qm;
    %Synaptic transfer - only from alive neurons to alive neurons, change
    %matrix to reflect that
    SynN = NEURONdata{r}.SynapticTransferFraction.*[zeros(2*NEURONdata{r}.numneurons,1);NEURONdata{r}.CurrentFrequency].*NEURONdata{r}.Qn;
    SynM = NEURONdata{r}.SynapticTransferFraction.*[zeros(2*NEURONdata{r}.numneurons,1);NEURONdata{r}.CurrentFrequency].*NEURONdata{r}.Qm;
    QnDiff = QnDiff - converted - DifN - ActN - SynN + NEURONdata{r}.DiffusionMatrix*DifN + NEURONdata{r}.ActiveTransportMatrix*ActN + NEURONdata{r}.SynapticTransferMatrix*SynN;
    QmDiff = QmDiff + converted - DifM - ActM - SynM + NEURONdata{r}.DiffusionMatrix*DifM + NEURONdata{r}.ActiveTransportMatrix*ActM + NEURONdata{r}.SynapticTransferMatrix*SynM;

    %Update quantities
    NEURONdata{r}.Qn = NEURONdata{r}.Qn + QnDiff;
    NEURONdata{r}.Qm = NEURONdata{r}.Qm + QmDiff;
    
    %normalise quantities
    NEURONdata{r}.Qn(NEURONdata{r}.Qn < 0) = 0;
    NEURONdata{r}.Qm(NEURONdata{r}.Qm < 0) = 0;
    quantitysum = NEURONdata{r}.Qn + NEURONdata{r}.Qm;
    overlimit = quantitysum > NEURONdata{r}.QVolume;
    NEURONdata{r}.Qn(overlimit) = NEURONdata{r}.Qn(overlimit)./quantitysum(overlimit);
    NEURONdata{r}.Qm(overlimit) = NEURONdata{r}.Qm(overlimit)./quantitysum(overlimit);
    
    %Effect, update frequencies
    NEURONdata{r}.CurrentVoltEffect = NEURONdata{r}.VoltEffect*NEURONdata{r}.Dmg;
    NEURONdata{r}.CurrentEffectValChosen = round(NEURONdata{r}.CurrentVoltEffect/0.25)+40;
    NEURONdata{r}.CurrentEffectValChosenIndices = sub2ind(size(NEURONdata{r}.Frequencies), (1:size(NEURONdata{r}.Frequencies,1))', NEURONdata{r}.CurrentEffectValChosen);
    NEURONdata{r}.CurrentFrequency  = NEURONdata{r}.Frequencies(NEURONdata{r}.CurrentEffectValChosenIndices);
    
    %Damage
    Concentrationsall = (NEURONdata{r}.Qn+NEURONdata{r}.Qm)./NEURONdata{r}.QVolume;
    MeanConcentrationsNeurons = (Concentrationsall(1:NEURONdata{r}.numneurons)+Concentrationsall(NEURONdata{r}.numneurons+1:2*NEURONdata{r}.numneurons)+Concentrationsall(2*NEURONdata{r}.numneurons+1:end))/3;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(NEURONdata{r}.DamageThresholdExists)
        DmgDiff = NEURONdata{r}.DamageFactor*(exp(10*(MeanConcentrationsNeurons - 0.011))-1);
    else
        DmgDiff = NEURONdata{r}.DamageFactor*(exp(10*(MeanConcentrationsNeurons - 0.000))-1);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    DmgDiff(DmgDiff < 0) = 0;
    DmgNew = NEURONdata{r}.Dmg + DmgDiff;
    DmgNew(DmgNew > 1) = 1;
    NewDeaths = DmgNew == 1 & NEURONdata{r}.Dmg < 1;
    AnyNewDeaths = sum(NewDeaths) > 0;
    QNewDeaths = [NewDeaths; NewDeaths; NewDeaths];
    NEURONdata{r}.Dmg = DmgNew;
    NEURONdata{r}.QDmg = [NEURONdata{r}.Dmg; NEURONdata{r}.Dmg; NEURONdata{r}.Dmg];
    
    %Update Spread Matrices
    if(AnyNewDeaths)
        %DIFFUSION MATRIX
        %find which columns will need renormalisation
        [~, renormalisationcols] = find(NEURONdata{r}.DiffusionMatrix(QNewDeaths,:));
        renormalisationcols = renormalisationcols([true;diff(renormalisationcols(:))>0]); %this keeps only unique elements
        
        %zero elements which should be zeroed
        NEURONdata{r}.DiffusionMatrix(QNewDeaths,:) = 0;
        
        %renormalise matrix
        totals = sum(NEURONdata{r}.DiffusionMatrix(:,renormalisationcols));
        positivetotals = totals > 0;
        zerototals = ~positivetotals;
        positivetotalsvalues = totals(positivetotals);
        positivetotalscols = renormalisationcols(positivetotals);
        zerototalscols     = renormalisationcols(zerototals);
        NEURONdata{r}.DiffusionMatrix(:,positivetotalscols) = NEURONdata{r}.DiffusionMatrix(:,positivetotalscols)./positivetotalsvalues;
        indicestoone = sub2ind(size(NEURONdata{r}.DiffusionMatrix),zerototalscols,zerototalscols);
        NEURONdata{r}.DiffusionMatrix(indicestoone) = 1;
        
        % SYNAPTIC TRANSFER MATRIX
        %find which columns will need renormalisation
        [~, renormalisationcols] = find(NEURONdata{r}.SynapticTransferMatrix(QNewDeaths,:));
        renormalisationcols = renormalisationcols([true;diff(renormalisationcols(:))>0]); %this keeps only unique elements for sorted vectors
        
        %zero elements which should be zeroed
        NEURONdata{r}.SynapticTransferMatrix(QNewDeaths,:) = 0;
        NEURONdata{r}.SynapticTransferMatrix(:,QNewDeaths) = 0;
        
        %renormalise matrix
        totals = sum(NEURONdata{r}.SynapticTransferMatrix(:,renormalisationcols));
        positivetotals = totals > 0;
        zerototals = ~positivetotals;
        positivetotalsvalues = totals(positivetotals);
        positivetotalscols = renormalisationcols(positivetotals);
        zerototalscols     = renormalisationcols(zerototals);
        NEURONdata{r}.SynapticTransferMatrix(:,positivetotalscols) = NEURONdata{r}.SynapticTransferMatrix(:,positivetotalscols)./positivetotalsvalues;
        indicestoone = sub2ind(size(NEURONdata{r}.SynapticTransferMatrix),zerototalscols,zerototalscols);
        NEURONdata{r}.SynapticTransferMatrix(indicestoone) = 1;
    end
    
end


end