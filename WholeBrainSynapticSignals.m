function [PopulationSynapticSignals, SynapticSignals] = WholeBrainSynapticSignals(Mapping, Symmetry, Tissues, Names, ImageNumbers, fmri_path, UseSmoothedImage, Compute, WhichDisease)

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
    savefile  = [fmri_path '01-' TextNumber '-01-01-MR01/' 'SynapticSubjectSignals_FTD.mat'];
    
    if(~(exist(savefile, 'file') == 2))
        Compute = true;
    end
    
    if(Compute)
        BOLDFile = load_untouch_nii(fmrifile);
        TR = BOLDFile.hdr.dime.pixdim(5);
        if(UseSmoothedImage)
            BOLDFile = load_untouch_nii(sfmrifile);
        end
        ParcellationFile = load_untouch_nii(parfile);
        BOLDImage = double(BOLDFile.img);
        ParcellationImage = double(ParcellationFile.img);
        
        %Choose which tissue types will remain - all other will become 0
        Mapped = true;
        Symmetric = false;
        Tissue = [2 4];
        Regions = Mapping;
        Region = Mapping;
        %Find the necessary atlas/parcellation
        [ParcellationNew, MappingNew] = WholeBrainCreateParcellation(ParcellationImage, Mapping, Mapped, Symmetry, Symmetric, Tissues, Tissue, Regions, Region);
        
        %noise free BOLD time course, activity related signal, Activity
        %inducing signal, innovation signal per voxel
        [NTC, ARS, AIS, IS] = WholeBrainCalculateRegionalSignals(BOLDImage, ParcellationNew, TR);
        
        %Summarize info from per voxel to per region
        Region_i = 1;
        for i = Mapping'
            [a,b,c] = ind2sub(size(ParcellationImage), find(ParcellationImage == i));
            RegionSignals = [];
            for j = 1:numel(a)
                temp2 = AIS(a(j),b(j),c(j),:);
                VoxelSignal = temp2(:)';
                RegionSignals(j,:) = VoxelSignal;
            end
            if(Symmetry(Region_i) > 0)
                [a,b,c] = ind2sub(size(ParcellationImage), find(ParcellationImage == Symmetry(Region_i)));
                for j = 1:numel(a)
                    temp2 = AIS(a(j),b(j),c(j),:);
                    VoxelSignal = temp2(:)';
                    RegionSignals(size(RegionSignals,1)+1,:) = VoxelSignal;
                end
            end
            % COMMENT THIS OUT IN CASE I WANT NEGATIVE ACTIVATIONS AS WELL????
            %RegionSignals(RegionSignals < 0) = 0;
            %RegionSignals = abs(RegionSignals);
            RegionSignal = sum(RegionSignals);
            SynapticSubjectSignals(Region_i,:) = RegionSignal/size(RegionSignals,1);
            Region_i = Region_i + 1;
        end
        save(savefile, 'SynapticSubjectSignals');
    end
    
    load(savefile, 'SynapticSubjectSignals');
    SynapticSignals(:,:,controliter) = SynapticSubjectSignals;
end

PopulationSynapticSignals = mean(SynapticSignals,3);


% close all
% figure;
% a=32;
% b=23;
% c=30;
% subplot(1,4,4);plot(reshape(NTC(a,b,c,:),[140 1]))
% subplot(1,4,3);plot(reshape(ARS(a,b,c,:),[140 1]))
% subplot(1,4,2);plot(reshape(AIS(a,b,c,:),[140 1]))
% subplot(1,4,1);plot(reshape(IS(a,b,c,:),[140 1]))

end

