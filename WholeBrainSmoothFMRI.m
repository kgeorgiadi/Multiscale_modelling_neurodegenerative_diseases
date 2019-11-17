function WholeBrainSmoothFMRI(fmri_path, ImageNumbers, PerformSmoothing)
if(PerformSmoothing)
    for Control_i = ImageNumbers
        TextNumber = num2str(Control_i);
        for j = numel(TextNumber)+1:3
            TextNumber = ['0' TextNumber];
        end
        
        spm('defaults','fmri');
        spm_get_defaults('cmdline',true);
        spm_jobman('initcfg');
        
        gunzip([fmri_path '01-' TextNumber '-01-01-MR01/' '4_rsfmri_in_epi.nii.gz']);
        f = spm_select('ExtFPList', [fmri_path '01-' TextNumber '-01-01-MR01'], ['^4_rsfmri_in_epi.*']);
        clear matlabbatch
        matlabbatch{1}.spm.spatial.smooth.data = cellstr(spm_file(f));
        matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
        spm_jobman('run',matlabbatch);
        
        spm('defaults','fmri');
        spm_get_defaults('cmdline',true);
        spm_jobman('initcfg');
        
        gunzip([fmri_path '01-' TextNumber '-01-01-MR01/' 'restingstatefmri/' 'merge_epi_struct_file/' 'vol0000_in_temp_merged.nii.gz']);
        f = spm_select('ExtFPList', [fmri_path '01-' TextNumber '-01-01-MR01/' 'restingstatefmri/' 'merge_epi_struct_file/'], ['^vol0000_in_temp_merged.*']);
        clear matlabbatch
        matlabbatch{1}.spm.spatial.smooth.data = cellstr(spm_file(f));
        matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
        spm_jobman('run',matlabbatch);
    end
end
end