function [Active, ChosenNodes] = WholeBrainChooseNodesEBM(EBMorAllnodes, DiseaseChosenNodes, Mapping, Active)
DiseaseChosenNodes = DiseaseChosenNodes(:);
if(EBMorAllnodes == 1)
    ChosenNodes = DiseaseChosenNodes;
elseif(EBMorAllnodes == 2)
    ChosenNodes = Mapping(Active)';
end

for kostasiter = 1:numel(Mapping)
    if(~any(ChosenNodes == Mapping(kostasiter)))
        Active(kostasiter) = false;
    end
end
end