function WholeBrainGenerateCSFandWMparcellations(ImageNumbers, fmri_path, GenerateCSFandWMparcellations)
CSFnumbers = [1 5 12 16 43 44 47 50 51 52 53];
WMnumbers = [41 42 45 46 62 63];
if(GenerateCSFandWMparcellations)
    for Control_i = ImageNumbers
        TextNumber = num2str(Control_i);
        for j = numel(TextNumber)+1:3
            TextNumber = ['0' TextNumber];
        end
        parfile   = [fmri_path '01-' TextNumber '-01-01-MR01/' '4_parcellation_in_epi.nii.gz'];
        
        ParcellationFile = load_untouch_nii(parfile);
        CSFmask = uint8(ismember(ParcellationFile.img, CSFnumbers));
        WMmask = uint8(ismember(ParcellationFile.img, WMnumbers));
        CSFFile = ParcellationFile;
        CSFFile.img = CSFmask;
        WMFile = ParcellationFile;
        WMFile.img = WMmask;
        
        CSFFile.hdr.dime.xyzt_units = 10;
        CSFFile.hdr.dime.glmax = 1;
        CSFFile.hdr.dime.datatype = 2;
        CSFFile.hdr.dime.bitpix = 8;
        CSFFile.hdr.dime.cal_max = 0;
        CSFFile.hdr.dime.pixdim(5) = 0;
        
        WMFile.hdr.dime.xyzt_units = 10;
        WMFile.hdr.dime.glmax = 1;
        WMFile.hdr.dime.datatype = 2;
        WMFile.hdr.dime.bitpix = 8;
        WMFile.hdr.dime.cal_max = 0;
        WMFile.hdr.dime.pixdim(5) = 0;
        
        save_untouch_nii(CSFFile, [fmri_path '01-' TextNumber '-01-01-MR01/' '4_CSF_in_epi.nii']);
        save_untouch_nii(WMFile, [fmri_path '01-' TextNumber '-01-01-MR01/' '4_WM_in_epi.nii']);
        
        [~, cmdout] = system(['nifti_tool -infiles ' [fmri_path '01-' TextNumber '-01-01-MR01/' '4_CSF_in_epi.nii'] ' -overwrite -rm_ext 0']);
        [~, cmdout] = system(['nifti_tool -infiles ' [fmri_path '01-' TextNumber '-01-01-MR01/' '4_WM_in_epi.nii' ] ' -overwrite -rm_ext 0']);
    end
end
end