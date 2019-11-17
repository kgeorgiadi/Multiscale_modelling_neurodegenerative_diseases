function Coordinates = WholeBrainGetRegionCoordinates(Mapping, ImageNumbers, parcellation_path, WhichDisease)

AllCoordinates = zeros(numel(Mapping),3,numel(ImageNumbers));
control_iter = 0;
for Control_i = ImageNumbers
    control_iter = control_iter + 1;
    TextNumber = num2str(Control_i);
    for j = numel(TextNumber)+1:3
        TextNumber = ['0' TextNumber];
    end   
    
    NiiFile = load_untouch_nii([parcellation_path '01-' TextNumber '-01-01-MR01/' '01-' TextNumber '-01-01-MR01_gif_par_FTD.nii.gz']);
    Image = double(NiiFile.img);
    Region_i = 1;
    for i = Mapping'
        [a,b,c] = ind2sub(size(Image), find(Image == i));
        a = a*NiiFile.hdr.dime.pixdim(2) - NiiFile.hdr.dime.pixdim(2)/2;
        b = b*NiiFile.hdr.dime.pixdim(3) - NiiFile.hdr.dime.pixdim(3)/2;
        c = c*NiiFile.hdr.dime.pixdim(4) - NiiFile.hdr.dime.pixdim(4)/2;
        VoxelsCoordinates = [a b c];
        AllCoordinates(Region_i,:,control_iter) = mean(VoxelsCoordinates);
        Region_i = Region_i + 1;
    end
end
Coordinates = mean(AllCoordinates,3);

end