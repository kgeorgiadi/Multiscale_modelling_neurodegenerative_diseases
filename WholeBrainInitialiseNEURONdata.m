function NEURONdata = WholeBrainInitialiseNEURONdata(Parameters, Network, Results)
E2  = 18;
E2B = 19;
I2  = 20;
I2L = 23;
E4  = 15;
I4  = 16;
I4L = 17;
E5B = 11;
E5R = 12;
I5  = 13;
I5L = 14;
E6  = 7;
I6  = 8;
I6L = 10;
load('Frequencies.mat');

for r = 1:Network.NumNodes  
    NEURONdata{r}.InsolubleProtein                  = Parameters.NEURONInsolubility;
    NEURONdata{r}.ProductionRateNormal              = 0.0002;
    NEURONdata{r}.ProductionRateMisfolded           = 0.00002;
    NEURONdata{r}.MisfoldFactor                     = Parameters.NEURONMisfold;
    NEURONdata{r}.ClearanceRateNormal               = 0.0002;
    NEURONdata{r}.ClearanceRateMisfolded            = 0.00002;
    NEURONdata{r}.ClearanceNormalLevel              = 0.01;
    NEURONdata{r}.ClearanceMisfoldedLevel           = 0.01;

    NEURONdata{r}.PassiveDiffusionFraction          = Parameters.NEURONDiffusion;
    NEURONdata{r}.PassiveDiffusionSpeed             = Parameters.NEURONDiffusionSpeed;
    NEURONdata{r}.PassiveDiffusionIntraneuronWeight = 20;
    NEURONdata{r}.ActiveTransportFraction           = Parameters.NEURONTransport;
    NEURONdata{r}.ActiveTransportRetrogradeWeight   = 11.61;
    NEURONdata{r}.ActiveTransportStoppedWeight      = 73;
    NEURONdata{r}.ActiveTransportAnterogradeWeight  = 15.39;
    NEURONdata{r}.SynapticTransferFraction          = Parameters.NEURONSynaptic;

    NEURONdata{r}.ProteinEffectType                 = Parameters.NEURONEffect;
    NEURONdata{r}.VoltEffect                        = 9;
    if(NEURONdata{r}.ProteinEffectType == 2)
        NEURONdata{r}.VoltEffect = -NEURONdata{r}.VoltEffect;
    end
    NEURONdata{r}.DamageFactor                      = Parameters.NEURONDamage;
    NEURONdata{r}.DamageThresholdExists             = Parameters.NEURONDamageThresholdExists;
    
    NEURONdata{r}.numcols                           = Parameters.ColumnsPerRegion(r);
    
    NEURONdata{r}.DendritesDiameter = 2;
    NEURONdata{r}.DendritesLength   = 500;
    NEURONdata{r}.SomaDiameter      = 30;
    NEURONdata{r}.SomaLength        = 30;
    NEURONdata{r}.AxonDiameter      = 1;
    NEURONdata{r}.AxonLength        = 200;
    NEURONdata{r}.DendritesBaseArea = pi * (NEURONdata{r}.DendritesDiameter/2)^2;
    NEURONdata{r}.SomaBaseArea      = pi * (NEURONdata{r}.SomaDiameter/2)^2;
    NEURONdata{r}.AxonBaseArea      = pi * (NEURONdata{r}.AxonDiameter/2)^2;
    NEURONdata{r}.DendritesVolume   = NEURONdata{r}.DendritesLength * NEURONdata{r}.DendritesDiameter * NEURONdata{r}.DendritesDiameter * pi / 4;
    NEURONdata{r}.SomaVolume        = NEURONdata{r}.SomaLength      * NEURONdata{r}.SomaDiameter      * NEURONdata{r}.SomaDiameter      * pi / 4;
    NEURONdata{r}.AxonVolume        = NEURONdata{r}.AxonLength      * NEURONdata{r}.AxonDiameter      * NEURONdata{r}.AxonDiameter      * pi / 4;

    NEURONdata{r}.cpercol(E2)  = 142;
    NEURONdata{r}.cpercol(E2B) = 8;
    NEURONdata{r}.cpercol(E4)  = 30;
    NEURONdata{r}.cpercol(E5B) = 17;
    NEURONdata{r}.cpercol(E5R) = 65;
    NEURONdata{r}.cpercol(E6)  = 60;
    NEURONdata{r}.cpercol(I2L) = 13;
    NEURONdata{r}.cpercol(I2)  = 25;
    NEURONdata{r}.cpercol(I4L) = 14; 
    NEURONdata{r}.cpercol(I4)  = 20;
    NEURONdata{r}.cpercol(I5L) = 13;
    NEURONdata{r}.cpercol(I5)  = 25;
    NEURONdata{r}.cpercol(I6L) = 13;
    NEURONdata{r}.cpercol(I6)  = 25;
    
    NEURONdata{r}.numneurons = NEURONdata{r}.numcols*470;
    
    NEURONdata{r}.Cnd               = ones(NEURONdata{r}.numneurons,1) * Results.ConcentrationNormal(r,1);
    NEURONdata{r}.Cmd               = ones(NEURONdata{r}.numneurons,1) * Results.ConcentrationPathogenic(r,1);
    NEURONdata{r}.Cns               = ones(NEURONdata{r}.numneurons,1) * Results.ConcentrationNormal(r,1);
    NEURONdata{r}.Cms               = ones(NEURONdata{r}.numneurons,1) * Results.ConcentrationPathogenic(r,1);
    NEURONdata{r}.Cna               = ones(NEURONdata{r}.numneurons,1) * Results.ConcentrationNormal(r,1);
    NEURONdata{r}.Cma               = ones(NEURONdata{r}.numneurons,1) * Results.ConcentrationPathogenic(r,1);
    NEURONdata{r}.Dmg               = ones(NEURONdata{r}.numneurons,1) * Results.Atrophy(r,1);
    NEURONdata{r}.col               = ones(NEURONdata{r}.numneurons,1);
    NEURONdata{r}.type              = ones(NEURONdata{r}.numneurons,1);
    
    for i = 1:NEURONdata{r}.numcols
        offset = 470*(i-1);
        NEURONdata{r}.col(offset + 1:offset + 470) = i;
        for type = 1:numel(NEURONdata{r}.cpercol)
            cpercol = NEURONdata{r}.cpercol(type);
            NEURONdata{r}.type(offset + 1:offset+cpercol) = type;
            offset = offset + cpercol;
        end
    end

    NEURONdata{r}.Qn                   = [NEURONdata{r}.Cnd*NEURONdata{r}.DendritesVolume; NEURONdata{r}.Cns*NEURONdata{r}.SomaVolume; NEURONdata{r}.Cna*NEURONdata{r}.AxonVolume];
    NEURONdata{r}.Qm                   = [NEURONdata{r}.Cmd*NEURONdata{r}.DendritesVolume; NEURONdata{r}.Cms*NEURONdata{r}.SomaVolume; NEURONdata{r}.Cma*NEURONdata{r}.AxonVolume];
    NEURONdata{r}.QDmg                 = [NEURONdata{r}.Dmg; NEURONdata{r}.Dmg; NEURONdata{r}.Dmg];
    NEURONdata{r}.dsa                  = [1*ones(NEURONdata{r}.numneurons,1); 2*ones(NEURONdata{r}.numneurons,1); 3*ones(NEURONdata{r}.numneurons,1)];
    NEURONdata{r}.Qcol                 = [NEURONdata{r}.col; NEURONdata{r}.col; NEURONdata{r}.col];
    NEURONdata{r}.Qtype                = [NEURONdata{r}.type; NEURONdata{r}.type; NEURONdata{r}.type];
    NEURONdata{r}.QLength              = [NEURONdata{r}.DendritesLength*ones(NEURONdata{r}.numneurons,1);NEURONdata{r}.SomaLength*ones(NEURONdata{r}.numneurons,1);NEURONdata{r}.AxonLength*ones(NEURONdata{r}.numneurons,1)];
    NEURONdata{r}.QDiameter            = [NEURONdata{r}.DendritesDiameter*ones(NEURONdata{r}.numneurons,1);NEURONdata{r}.SomaDiameter*ones(NEURONdata{r}.numneurons,1);NEURONdata{r}.AxonDiameter*ones(NEURONdata{r}.numneurons,1)];
    NEURONdata{r}.QBaseArea            = [NEURONdata{r}.DendritesBaseArea*ones(NEURONdata{r}.numneurons,1);NEURONdata{r}.SomaBaseArea*ones(NEURONdata{r}.numneurons,1);NEURONdata{r}.AxonBaseArea*ones(NEURONdata{r}.numneurons,1)];
    NEURONdata{r}.QVolume              = [NEURONdata{r}.DendritesVolume*ones(NEURONdata{r}.numneurons,1);NEURONdata{r}.SomaVolume*ones(NEURONdata{r}.numneurons,1);NEURONdata{r}.AxonVolume*ones(NEURONdata{r}.numneurons,1)];
    NEURONdata{r}.QVolumeSq            = NEURONdata{r}.QVolume.^2;
    NEURONdata{r}.QVolumePercentage    = NEURONdata{r}.QVolume/sum(NEURONdata{r}.DendritesVolume+NEURONdata{r}.SomaVolume+NEURONdata{r}.AxonVolume);
    NEURONdata{r}.QDendrites           = NEURONdata{r}.dsa == 1;
    NEURONdata{r}.QSoma                = NEURONdata{r}.dsa == 2;
    NEURONdata{r}.QAxon                = NEURONdata{r}.dsa == 3;
%     NEURONdata{r}.InputNeuronSections  = NEURONdata{r}.dsa == 1 & NEURONdata{r}.Qcol == 1 & ismember(NEURONdata{r}.Qtype, [E4]);
%     NEURONdata{r}.OutputNeuronSections = NEURONdata{r}.dsa == 3 & NEURONdata{r}.Qcol == NEURONdata{r}.numcols & ismember(NEURONdata{r}.Qtype, [E2 E2B]);
    NEURONdata{r}.InputNeuronSections  = NEURONdata{r}.dsa == 1 & ismember(NEURONdata{r}.Qtype, [E2 E2B]);
    NEURONdata{r}.OutputNeuronSections = NEURONdata{r}.dsa == 3 & ismember(NEURONdata{r}.Qtype, [E2 E2B]);
    
    
    %Inputs from MATLAB
    NEURONdata{r}.QuantityInputNormal = 0;
    NEURONdata{r}.QuantityOutputNormal = 0;
    NEURONdata{r}.QuantityOutputNormalFreq = 0;
    NEURONdata{r}.QuantityExtracellularLeavingNormal = 0;
    NEURONdata{r}.QuantityExtracellularEnteringNormal = 0;
    NEURONdata{r}.QuantityInputMisfolded = 0;
    NEURONdata{r}.QuantityOutputMisfolded = 0;
    NEURONdata{r}.QuantityOutputMisfoldedFreq = 0;
    NEURONdata{r}.QuantityExtracellularLeavingMisfolded = 0;
    NEURONdata{r}.QuantityExtracellularEnteringMisfolded = 0;
    
    %Get spread matrices
    NEURONdata{r}.ConnectionWeights = WholeBrainConnectionWeightsNEURON(NEURONdata{r});
    NEURONdata{r}.DiffusionMatrix = WholeBrainCalculateNEURONDiffusionMatrix(NEURONdata{r});
    NEURONdata{r}.InitialDiffusionMatrix = NEURONdata{r}.DiffusionMatrix;
    NEURONdata{r}.ActiveTransportMatrix = WholeBrainCalculateNEURONActiveTransportMatrix(NEURONdata{r});
    NEURONdata{r}.InitialActiveTransportMatrix = NEURONdata{r}.ActiveTransportMatrix;
    NEURONdata{r}.SynapticTransferMatrix = WholeBrainCalculateNEURONSynapticTransferMatrix(NEURONdata{r});
    NEURONdata{r}.InitialSynapticTransferMatrix = NEURONdata{r}.SynapticTransferMatrix;
    
    %Frequency stuff
    FrequencySideCols   = TypeFrequenciesSideColumns(NEURONdata{r}.type,:);
    FrequencyMiddleCols = TypeFrequenciesMiddleColumns(NEURONdata{r}.type,:);
    middlecols = NEURONdata{r}.col > 1 & NEURONdata{r}.col < NEURONdata{r}.numcols;
    sidecols = ~middlecols;
    NEURONdata{r}.Frequencies = FrequencySideCols;
    NEURONdata{r}.Frequencies(middlecols) = FrequencyMiddleCols(middlecols);
    NEURONdata{r}.CurrentVoltEffect = zeros(NEURONdata{r}.numneurons,1);
    NEURONdata{r}.CurrentEffectValChosen = round(NEURONdata{r}.CurrentVoltEffect/0.25)+40;
    NEURONdata{r}.CurrentFrequency  = NEURONdata{r}.Frequencies(:,40);
end

end



