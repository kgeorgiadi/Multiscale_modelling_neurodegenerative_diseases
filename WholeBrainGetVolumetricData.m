function [Names, Mapping, PopulationAverageVolumes, Symmetry, Tissues, Active] = WholeBrainGetVolumetricData(parcellation_path, ImageNumbers, WhichDisease)

i = 0;
for Control_i = ImageNumbers
    i = i + 1;
    TextNumber = num2str(Control_i);
    for j = numel(TextNumber)+1:3
        TextNumber = ['0' TextNumber];
    end
    
    [TIV, GMTVol, WMTVol, CSFTVol, DGMTVol, BSTVol, BASTVol, NvCSFTVol, Names, Mapping, Volume, Active, Symmetry, Tissues] = WholeBrainLoadVolumeData([parcellation_path '01-' TextNumber '-01-01-MR01/' '01-' TextNumber '-01-01-MR01_gif_volumes.csv']);
    %if(WhichDisease > 1)
        Names = Names(1:35);
        Mapping = Mapping(1:35);
        Volume = Volume(1:35);
        Active = Active(1:35);
        Symmetry = Symmetry(1:35);
        Tissues = Tissues(1:35);
        Names{36} = 'Right Orbitofrontal';
        Names{37} = 'Left Orbitofrontal';
        Names{38} = 'Right Dorsolateral Prefrontal';
        Names{39} = 'Left Dorsolateral Prefrontal';
        Names{40} = 'Right Ventromedial Prefrontal';
        Names{41} = 'Left Ventromedial Prefrontal';
        Names{42} = 'Right Motor';
        Names{43} = 'Left Motor';
        Names{44} = 'Right Frontal Opercular';
        Names{45} = 'Left Frontal Opercular';
        Names{46} = 'Right Frontal Pole';
        Names{47} = 'Left Frontal Pole';
        Names{48} = 'Right Medial Temporal';
        Names{49} = 'Left Medial Temporal';
        Names{50} = 'Right Lateral Temporal';
        Names{51} = 'Left Lateral Temporal';
        Names{52} = 'Right Temporal Pole';
        Names{53} = 'Left Temporal Pole';
        Names{54} = 'Right Supratemporal';
        Names{55} = 'Left Supratemporal';
        Names{56} = 'Right Medial Parietal';
        Names{57} = 'Left Medial Parietal';
        Names{58} = 'Right Lateral Parietal';
        Names{59} = 'Left Lateral Parietal';
        Names{60} = 'Right Sensory';
        Names{61} = 'Left Sensory';
        Names{62} = 'Right Medial Occipital';
        Names{63} = 'Left Medial Occipital';
        Names{64} = 'Right Lateral Occipital';
        Names{65} = 'Left Lateral Occipital';
        Names{66} = 'Right Anterior Cingulate';
        Names{67} = 'Left Anterior Cingulate';
        Names{68} = 'Right Middle Cingulate';
        Names{69} = 'Left Middle Cingulate';
        Names{70} = 'Right Posterior Cingulate';
        Names{71} = 'Left Posterior Cingulate';
        Names{72} = 'Right Anterior Insula';
        Names{73} = 'Left Anterior Insula';
        Names{74} = 'Right Posterior Insula';
        Names{75} = 'Left Posterior Insula';
        Tissues(36:75) = 2;
        Active(36:75) = 1;
        NiiFile = load_untouch_nii([parcellation_path '01-' TextNumber '-01-01-MR01/' '01-' TextNumber '-01-01-MR01_gif_par_FTD.nii.gz']);
        dummy = 0;
        for j = 36:75
            dummy = dummy + 1;
            Mapping(j) = 100 + dummy;
            Volume(j) = sum(NiiFile.img(:) == Mapping(j)) * prod(NiiFile.hdr.dime.pixdim(2:4));
            if(mod(dummy,2) == 1)
                Symmetry(j) = 100 + dummy + 1;
            else
                Symmetry(j) = 100 + dummy - 1;
            end
        end
    %end
    TIVAll(:,i) = TIV;
    VolumesAll(:,i) = Volume / TIVAll(i);
end
PopulationAverageVolumes = mean(VolumesAll,2)*mean(TIVAll);

end

