function [BOLDPopulationSignals, BOLDSignals] = WholeBrainExtractBOLDSignals(ImageNumbers, fmri_path, Mapping, Symmetry, UseSmoothedImage, Demean, Normalize, ComputeBOLD, WhichDisease)

controliter = 0;
for Control_i = ImageNumbers
    controliter = controliter + 1;
    TextNumber = num2str(Control_i);
    for j = numel(TextNumber)+1:3
        TextNumber = ['0' TextNumber];
    end
    
    fmrifile  = [fmri_path '01-' TextNumber '-01-01-MR01/' '4_rsfmri_in_epi.nii.gz'];
    sfmrifile = [fmri_path '01-' TextNumber '-01-01-MR01/' 's4_rsfmri_in_epi.nii'];
    
    parfile   = [fmri_path '01-' TextNumber '-01-01-MR01/' '4_parcellation_in_epi_FTD.nii.gz'];
    savefile  = [fmri_path '01-' TextNumber '-01-01-MR01/' 'BOLDSubjectSignals_FTD.mat'];
    if(~exist(savefile, 'file') == 2)
        ComputeBOLD = true;
    end
    
    if(ComputeBOLD)
        BOLDFile = load_untouch_nii(fmrifile);
        if(UseSmoothedImage)
            BOLDFile = load_untouch_nii(sfmrifile);
        end
        ParcellationFile = load_untouch_nii(parfile);
        BOLDImage = double(BOLDFile.img);
        ParcellationImage = double(ParcellationFile.img);
        Region_i = 1;
        for i = Mapping'
            [a,b,c] = ind2sub(size(ParcellationImage), find(ParcellationImage == i));
            clear BOLDRegionSignals;
            for j = 1:numel(a)
                temp2 = BOLDImage(a(j),b(j),c(j),:);
                VoxelSignal = temp2(:)';
                BOLDRegionSignals(j,:) = VoxelSignal;
            end
            if(Symmetry(Region_i) > 0)
                [a,b,c] = ind2sub(size(ParcellationImage), find(ParcellationImage == Symmetry(Region_i)));
                for j = 1:numel(a)
                    temp2 = BOLDImage(a(j),b(j),c(j),:);
                    VoxelSignal = temp2(:)';
                    BOLDRegionSignals(end+1,:) = VoxelSignal;
                end
            end
            Pcaoutput = pca(BOLDRegionSignals);
            BOLDSubjectSignals(Region_i,:) = Pcaoutput(:,1)';
            if(Demean)
                BOLDSubjectSignals(Region_i,:) = BOLDSubjectSignals(Region_i,:) - mean(BOLDSubjectSignals(Region_i,:));
            end
            if(Normalize)
                BOLDSubjectSignals(Region_i,:) = BOLDSubjectSignals(Region_i,:)/std(BOLDSubjectSignals(Region_i,:));
            end
            Region_i = Region_i + 1;
        end
        save(savefile, 'BOLDSubjectSignals');
    end
    
    load(savefile, 'BOLDSubjectSignals');
    BOLDSignals(:,:,controliter) = BOLDSubjectSignals;
end
BOLDPopulationSignals = mean(BOLDSignals,3);

end