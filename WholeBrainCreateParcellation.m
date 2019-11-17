function [ParcellationNew, MappingNew] = WholeBrainCreateParcellation(Parcellation, Mapping, Mapped, Symmetry, Symmetric, Tissues, Tissue, Regions, Region)
ParcellationNew = zeros(size(Parcellation));
TissuesKept = ismember(Tissues,Tissue);
RegionsKept = ismember(Regions,Region);
Kept = TissuesKept & RegionsKept;

for i = 1:numel(Tissues)
    if(Kept(i))
        ParcellationNew(Parcellation == Mapping(i)) = Mapping(i);
    end
end

if(Symmetric)
    Active = true(numel(Symmetry),1);
    for i = 1:numel(Tissues)
        if(Kept(i))
            if(Symmetry(i) > 0)
                if(Active(i))
                    %Find symmetric region
                    Region_sym = find(Mapping == Symmetry(i));
                    Active(Region_sym) = false;
                    Active(i) = false;
                    ParcellationNew(Parcellation == Mapping(i)) = Symmetry(i);
                end
            end
        end
    end
end

MappingNew = unique(ParcellationNew(:));
if(Mapped)
    ParcellationOld = ParcellationNew;
    ParcellationNew = zeros(size(Parcellation));
    for i = 1:numel(MappingNew)
        ParcellationNew(ParcellationOld == MappingNew(i)) = i-1;
    end
end

end