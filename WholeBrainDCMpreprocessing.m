function WholeBrainDCMpreprocessing(fmri_path, ImageNumbers, Mapping, Symmetry, Tissues, Active, Names, DoDCMpreprocessing, WhichDisease)
if(DoDCMpreprocessing)
    spm('Defaults','fMRI');
    spm_jobman('initcfg');
    spm_get_defaults('cmdline',true);
    
    controliter = 0;
    for Control_i = ImageNumbers
        controliter = controliter + 1;
        TextNumber = num2str(Control_i);
        for j = numel(TextNumber)+1:3
            TextNumber = ['0' TextNumber];
        end
        fmrifile    = [fmri_path '01-' TextNumber '-01-01-MR01/' '4_rsfmri_in_epi.nii.gz'];
        sfmrifile   = [fmri_path '01-' TextNumber '-01-01-MR01/' 's4_rsfmri_in_epi.nii'];
        csffile     = [fmri_path '01-' TextNumber '-01-01-MR01/' '4_CSF_in_epi.nii'];
        wmfile      = [fmri_path '01-' TextNumber '-01-01-MR01/' '4_WM_in_epi.nii'];
        DCMfmrifile = [fmri_path '01-' TextNumber '-01-01-MR01/' 'restingstatefmri/' 'merge_epi_struct_file/' 'svol0000_in_temp_merged.nii'];
        
        BOLDFile = load_untouch_nii(fmrifile);
        RT = BOLDFile.hdr.dime.pixdim(5);
        
        ImageFile = load_untouch_nii(DCMfmrifile);
        ImageImage = uint16(ImageFile.img);
        NewImageFile = ImageFile;
        NewImageFile.img = ImageImage;
        
        NewImageFile.hdr.dime.datatype = 4;
        NewImageFile.hdr.dime.bitpix = 16;
        NewImageFile.hdr.dime.xyzt_units = 10;
        NewImageFile.hdr.dime.glmax = 1;
        NewImageFile.hdr.dime.cal_max = 0;
        NewImageFile.hdr.dime.pixdim(5) = RT;
        
        save_untouch_nii(NewImageFile, [fmri_path '01-' TextNumber '-01-01-MR01/' 'restingstatefmri/' 'merge_epi_struct_file/' 'msvol0000_in_temp_merged.nii']);
        [~, cmdout] = system(['nifti_tool -infiles ' [fmri_path '01-' TextNumber '-01-01-MR01/' 'restingstatefmri/' 'merge_epi_struct_file/' 'msvol0000_in_temp_merged.nii'] ' -overwrite -rm_ext 0']);
        f = spm_select('ExtFPList', [fmri_path '01-' TextNumber '-01-01-MR01/' 'restingstatefmri/' 'merge_epi_struct_file/'], ['msvol0000_in_temp_merged.nii']);
        
        glmdir = fullfile([fmri_path '01-' TextNumber '-01-01-MR01/'],'glm');
        if ~exist(glmdir,'file'), mkdir(glmdir); end
        if exist([glmdir '/SPM.mat'] ,'file')
            delete([glmdir '/SPM.mat']);
        end
        
        clear matlabbatch
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % INITIAL GLM FOR EXTRACTING WM / CSF REGRESSORS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SPM specification
        matlabbatch{1}.spm.stats.fmri_spec.dir          = cellstr(glmdir);
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT    = RT;
        matlabbatch{1}.spm.stats.fmri_spec.sess.scans   = cellstr(f);
        
        % SPM estimation
        matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr(fullfile(glmdir,'SPM.mat'));
        
        % ROI extraction
        matlabbatch{3}.spm.util.voi.spmmat  = cellstr(fullfile(glmdir,'SPM.mat'));
        matlabbatch{3}.spm.util.voi.adjust  = NaN;
        matlabbatch{3}.spm.util.voi.session = 1;
        matlabbatch{3}.spm.util.voi.name    = 'CSF';
        matlabbatch{3}.spm.util.voi.roi{1}.mask.image        = cellstr(fullfile(csffile));
        matlabbatch{3}.spm.util.voi.roi{2}.mask.image        = cellstr(fullfile([fmri_path '01-' TextNumber '-01-01-MR01/' 'glm/' 'mask.nii']));
        matlabbatch{3}.spm.util.voi.expression = 'i1 & i2';
        
        matlabbatch{4} = matlabbatch{3};
        matlabbatch{4}.spm.util.voi.name = 'WM';
        matlabbatch{4}.spm.util.voi.roi{1}.mask.image        = cellstr(fullfile(wmfile));
        
        spm_jobman('run',matlabbatch);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SECOND GLM INCLUDING WM / CSF REGRESSORS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        glmcorrdir = fullfile([fmri_path '01-' TextNumber '-01-01-MR01/'],'glm_corrected');
        if ~exist(glmcorrdir,'file'), mkdir(glmcorrdir); end
        if exist([glmcorrdir '/SPM.mat'] ,'file')
            delete([glmcorrdir '/SPM.mat']);
        end
        
        clear matlabbatch;
        
        HeadMotionFile = [fmri_path '01-' TextNumber '-01-01-MR01/' 'restingstatefmri/' 'fmri_motion_correction/' 'motion_correction/'  '4.1D'];
        
        % SPM specification
        matlabbatch{1}.spm.stats.fmri_spec.dir          = cellstr(glmcorrdir);
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT    = RT;
        matlabbatch{1}.spm.stats.fmri_spec.sess.scans   = cellstr(f);
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {
            fullfile(HeadMotionFile),... %6 Head motion parameters from the re-alignment
            fullfile(glmdir,'VOI_CSF_1.mat'),...
            fullfile(glmdir,'VOI_WM_1.mat'),...
            }';
        
        % SPM estimation
        matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr(fullfile(glmcorrdir,'SPM.mat'));
        
        % ROI extraction
        parfile   = [fmri_path '01-' TextNumber '-01-01-MR01/' '4_parcellation_in_epi_FTD.nii.gz'];
        ParcellationFile = load_untouch_nii(parfile);
        ParcellationImage = double(ParcellationFile.img);
        
        spmbatchiter = 3;
        for kostasiter = 1:numel(Mapping)
            Mapped = true;
            Symmetric = true;
            Tissue = 1:10;
            Regions = Mapping;
            Region = Mapping(kostasiter);
            [SegMask, MappingNew] = WholeBrainCreateParcellation(ParcellationImage, Mapping, Mapped, Symmetry, Symmetric, Tissues, Tissue, Regions, Region);
            SegFile = ParcellationFile;
            SegFile.img = SegMask;
            SegFile.hdr.dime.xyzt_units = 10;
            SegFile.hdr.dime.glmax = 1;
            SegFile.hdr.dime.datatype = 2;
            SegFile.hdr.dime.bitpix = 8;
            name = Names{kostasiter};
            if(numel(name) > 6)
                if(strcmp(name(1:6), 'Right '))
                    name = name(7:end);
                elseif(strcmp(name(1:5), 'Left '))
                    name = name(6:end);
                end
            end
            name = strrep(name,' ', '_');
            save_untouch_nii(SegFile, [fmri_path '01-' TextNumber '-01-01-MR01/' '4_' name '_in_epi.nii']);
            if(Active(kostasiter))
                matlabbatch{spmbatchiter}.spm.util.voi.spmmat  = cellstr(fullfile(glmcorrdir,'SPM.mat'));
                matlabbatch{spmbatchiter}.spm.util.voi.adjust  = NaN;
                matlabbatch{spmbatchiter}.spm.util.voi.session = 1;
                matlabbatch{spmbatchiter}.spm.util.voi.name    = name;
                matlabbatch{spmbatchiter}.spm.util.voi.roi{1}.mask.image    = cellstr(fullfile([fmri_path '01-' TextNumber '-01-01-MR01/' '4_' name '_in_epi.nii']));
                matlabbatch{spmbatchiter}.spm.util.voi.roi{2}.mask.image    = cellstr(fullfile([fmri_path '01-' TextNumber '-01-01-MR01/' 'glm/' 'mask.nii']));
                matlabbatch{spmbatchiter}.spm.util.voi.expression = 'i1 & i2';
                spmbatchiter = spmbatchiter + 1;
            end
        end
        
        spm_jobman('run',matlabbatch);
    end
end
end
