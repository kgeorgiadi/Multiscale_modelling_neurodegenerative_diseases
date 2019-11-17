function Regions = WholeBrainProcessData1(Names, Mapping, Active, PopulationAverageVolumes, Coordinates, PopulationBOLDSignals, BOLDSignals, PopulationSynapticSignals, SynapticSignals, DTIs, EffectiveConnectivityPEB, EffectiveConnectivityBMA, MeanEffectiveConnectivity, DTIsSmall, DTIsLarge, EffectiveConnectivityBMAn, EffectiveConnectivityBMAs, EffectiveConnectivityBMAl)
Names = Names(Active);
Mapping = Mapping(Active);
PopulationAverageVolumes = PopulationAverageVolumes(Active);
Coordinates = Coordinates(Active,:);
PopulationBOLDSignals = PopulationBOLDSignals(Active,:);
BOLDSignals = BOLDSignals(Active,:,:);
PopulationSynapticSignals = PopulationSynapticSignals(Active,:);
SynapticSignals = SynapticSignals(Active,:,:);

T = 2.2;% Sampling period       
Fs = 1/T;            % Sampling frequency
L = size(SynapticSignals,2);             % Length of signal
t = (0:L-1)*T;        % Time vector

for i = 1:size(SynapticSignals,1)
    for k = 1:size(SynapticSignals,3)
        temp = fft(SynapticSignals(i,:,k));
        SynapticFourier(i,:,k) = temp;
        P2 = abs(temp/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = Fs*(0:(L/2))/L;
        SynapticSpectrum(i,:,k) = P1;
    end
end
PopulationSynapticSpectrum = mean(SynapticSpectrum,3);
for i = 1:size(PopulationSynapticSpectrum,1)
    PopulationSynapticFrequency(i,1) = sum(f.*PopulationSynapticSpectrum(i,:))/sum(PopulationSynapticSpectrum(i,:));
end

for Region_i = 1:numel(Names)
    Names{Region_i} = Names{Region_i}(7:end);
end

DTImean = zeros(size(DTIs{1}));
for i = 1:numel(DTIs)
    DTImean = DTImean + DTIs{i};
    DTIs{i} = DTIs{i}(Active,Active);
end
DTImean = DTImean/numel(DTIs);
DTImean = DTImean(Active,Active);
DTImean = DTImean/sum(DTImean(:));

DTImeanSmall = zeros(size(DTIsSmall{1}));
for i = 1:numel(DTIsSmall)
    DTImeanSmall = DTImeanSmall + DTIsSmall{i};
    DTIsSmall{i} = DTIsSmall{i}(Active,Active);
end
DTImeanSmall = DTImeanSmall/numel(DTIsSmall);
DTImeanSmall = DTImeanSmall(Active,Active);
DTImeanSmall = DTImeanSmall/sum(DTImeanSmall(:));

DTImeanLarge = zeros(size(DTIsLarge{1}));
for i = 1:numel(DTIsLarge)
    DTImeanLarge = DTImeanLarge + DTIsLarge{i};
    DTIsLarge{i} = DTIsLarge{i}(Active,Active);
end
DTImeanLarge = DTImeanLarge/numel(DTIsLarge);
DTImeanLarge = DTImeanLarge(Active,Active);
DTImeanLarge = DTImeanLarge/sum(DTImeanLarge(:));

%from mm to metres
Coordinates = Coordinates / 10^3;
PopulationAverageVolumes = PopulationAverageVolumes / 10^9;

RBOLDCorrelationMatrix = corr(PopulationBOLDSignals');
ZBOLDCorrelationMatrix = .5*log((1+RBOLDCorrelationMatrix)./(1-RBOLDCorrelationMatrix));
RSynapticCorrelationMatrix = corr(PopulationSynapticSignals');
ZSynapticCorrelationMatrix = .5*log((1+RSynapticCorrelationMatrix)./(1-RSynapticCorrelationMatrix));

Regions.RBOLDCorrelationMatrix = RBOLDCorrelationMatrix;
Regions.ZBOLDCorrelationMatrix = ZBOLDCorrelationMatrix;
Regions.RSynapticCorrelationMatrix = RSynapticCorrelationMatrix;
Regions.ZSynapticCorrelationMatrix = ZSynapticCorrelationMatrix;
Regions.DTI = DTImean;
Regions.DTIsmall = DTImeanSmall;
Regions.DTIlarge = DTImeanLarge;
Regions.EffectiveConnectivity = EffectiveConnectivityBMA;
Regions.EffectiveConnectivityN = EffectiveConnectivityBMAn;
Regions.EffectiveConnectivityS = EffectiveConnectivityBMAs;
Regions.EffectiveConnectivityL = EffectiveConnectivityBMAl;
Regions.Names = Names;
Regions.Mapping = Mapping;
Regions.Volumes = PopulationAverageVolumes;
Regions.Coordinates = Coordinates;
Regions.BOLDSignals = PopulationBOLDSignals;
Regions.SynapticSignals = PopulationSynapticSignals;
Regions.Frequencies = PopulationSynapticFrequency;
Regions.MaximumFrequency = max(Regions.Frequencies);
Regions.NumNodes = numel(Regions.Volumes);
Regions.Radius = ((3*Regions.Volumes) / (4 * pi)).^(1/3);
Regions.EuclideanDistances = allDist(Regions.Coordinates',Regions.Coordinates');
end