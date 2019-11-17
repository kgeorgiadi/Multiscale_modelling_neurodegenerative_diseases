function [PopulationAverageVolumes, Active] = WholeBrainRemoveLeftSide(Symmetry, Names, Mapping, Active, PopulationAverageVolumes)
for Region_i = 1:numel(Symmetry)
    if(Active(Region_i))
        if(Symmetry(Region_i) > 0)
            if(strcmp(Names{Region_i}(1:5), 'Right'))
                %Find symmetric region
                Region_sym = find(Mapping == Symmetry(Region_i));
                Active(Region_sym) = false;
                volumeavg = mean(PopulationAverageVolumes([Region_i Region_sym]));
                PopulationAverageVolumes(Region_i) = volumeavg;
                PopulationAverageVolumes(Region_sym) = volumeavg;
            end
        end
    end
end
end