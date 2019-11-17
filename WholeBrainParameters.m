function Parameters = WholeBrainParameters(Network, AllParams)
Parameters = AllParams;

%PARAMETERS
Parameters.Seed         = zeros(numel(Network.Volumes),1);  
Parameters.Seedlocation = find(strcmp(Network.Names,Parameters.DiseaseEpicentres{Parameters.ProteinLocation}));

if(Parameters.ProteinType == 1)
    Parameters.NEURONInsolubility = 1;
    Parameters.Seed(Parameters.Seedlocation) = Parameters.Seedsize;
    Parameters.InitialConcentrationPathogenicAll = 0;
    
elseif(Parameters.ProteinType == 2)
    Parameters.NEURONInsolubility = 0;
    Parameters.Seed(Parameters.Seedlocation) = Parameters.Seedsize;
    Parameters.InitialConcentrationPathogenicAll     = 0;
    
elseif(Parameters.ProteinType == 3)
    Parameters.NEURONInsolubility = 1;
    Parameters.InitialConcentrationPathogenicAll     = 0.01;
    
elseif(Parameters.ProteinType == 4)
    Parameters.NEURONInsolubility = 0;
    Parameters.InitialConcentrationPathogenicAll     = 0.01;
end
Parameters.NEURONDamageThresholdExists = true;
end