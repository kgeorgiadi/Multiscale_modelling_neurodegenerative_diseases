function NetworkCorrelation = WholeBrainCorrelateNetworkMetricsEBM(Network, EBM, AllParams, savepdf)
save_path = AllParams.save_path;
Network.DTIsmall = Network.DTIsmall/sum(Network.DTIsmall(:));
Network.DTIlarge = Network.DTIlarge/sum(Network.DTIlarge(:));
for seednum = 1:numel(AllParams.DiseaseEpicentres)
    SeedName = AllParams.DiseaseEpicentres{seednum};
    Seed = find(strcmp(Network.Names,SeedName));
    
    NetworkCorrelation.DiseaseName     = AllParams.DiseaseName;
    NetworkCorrelation.SeedName{Seed}  = SeedName;
    NetworkCorrelation.BOLDR{Seed}     = WholeBrainCorrelateNetworkMetricsEBMMatrix(Network.RBOLDCorrelationMatrix,     Seed, Network, EBM, [save_path AllParams.DiseaseName SeedName 'BOLDR'], savepdf);
    NetworkCorrelation.BOLDZ{Seed}     = WholeBrainCorrelateNetworkMetricsEBMMatrix(Network.ZBOLDCorrelationMatrix,     Seed, Network, EBM, [save_path AllParams.DiseaseName SeedName 'BOLDZ'], savepdf);
    
    NetworkCorrelation.SynapticR{Seed} = WholeBrainCorrelateNetworkMetricsEBMMatrix(Network.RSynapticCorrelationMatrix, Seed, Network, EBM, [save_path AllParams.DiseaseName SeedName 'SynapticR'], savepdf);
    NetworkCorrelation.SynapticZ{Seed} = WholeBrainCorrelateNetworkMetricsEBMMatrix(Network.ZSynapticCorrelationMatrix, Seed, Network, EBM, [save_path AllParams.DiseaseName SeedName 'SynapticZ'], savepdf);
    
    NetworkCorrelation.DTIsmall{Seed} = WholeBrainCorrelateNetworkMetricsEBMMatrix(Network.DTIsmall, Seed, Network, EBM, [save_path AllParams.DiseaseName SeedName 'DTIs'], savepdf);
    NetworkCorrelation.DTIlarge{Seed} = WholeBrainCorrelateNetworkMetricsEBMMatrix(Network.DTIlarge, Seed, Network, EBM, [save_path AllParams.DiseaseName SeedName 'DTIl'], savepdf);
    
    NetworkCorrelation.EffectiveConnectivityN{Seed} = WholeBrainCorrelateNetworkMetricsEBMMatrix(Network.EffectiveConnectivityN, Seed, Network, EBM, [save_path AllParams.DiseaseName SeedName 'EffectiveN'], savepdf);
    NetworkCorrelation.EffectiveConnectivityS{Seed} = WholeBrainCorrelateNetworkMetricsEBMMatrix(Network.EffectiveConnectivityS, Seed, Network, EBM, [save_path AllParams.DiseaseName SeedName 'EffectiveS'], savepdf);
    NetworkCorrelation.EffectiveConnectivityL{Seed} = WholeBrainCorrelateNetworkMetricsEBMMatrix(Network.EffectiveConnectivityL, Seed, Network, EBM, [save_path AllParams.DiseaseName SeedName 'EffectiveL'], savepdf);
    
    EuclideanDistancesToSeeds = Network.EuclideanDistances(Seed,:)';
    NetworkCorrelation.Euclidean{Seed} = WholeBrainCorrelateNetworkMetricEBM(EuclideanDistancesToSeeds, Network, EBM, [save_path AllParams.DiseaseName SeedName 'Euclidean'], savepdf);
    NetworkCorrelation.Volumes{Seed}   = WholeBrainCorrelateNetworkMetricEBM(Network.Volumes, Network, EBM, [save_path AllParams.DiseaseName SeedName 'Volumes'], savepdf);
end
if(savepdf)
    save([save_path 'NetworkCorrelation' AllParams.DiseaseName '.mat'], 'NetworkCorrelation', '-v7.3');
end
end