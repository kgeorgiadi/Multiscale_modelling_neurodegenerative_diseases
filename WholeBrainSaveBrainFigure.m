function WholeBrainSaveBrainFigure(values, filename)
% values must be 27 elements, between 0 to 1 in intensity
% 0 should be good, 1 should be bad
% so it should be atrophy or concentration, not volume
% must be set to 0 to be ignored
%
%filename must be one of: .png .tif .jpg .bmp .eps
%
GIFtoAAL = cell(27,1);
GIFtoAAL{1} = [];
GIFtoAAL{2} = [41 42];
GIFtoAAL{3} = [71 72];
GIFtoAAL{4} = [37 38];
GIFtoAAL{5} = [75 76];
GIFtoAAL{6} = [73 74];
GIFtoAAL{7} = [77 78];
GIFtoAAL{8} = [5 6 9 10 25 26];
GIFtoAAL{9} = [3 4 7 8 11 12 13 14 15 16];
GIFtoAAL{10} = [21 22 23 24 27 28];
GIFtoAAL{11} = [1 2 19 20];
GIFtoAAL{12} = [17 18];
GIFtoAAL{13} = [];
GIFtoAAL{14} = [39 40 55 56];
GIFtoAAL{15} = [81 82 85 86 89 90];
GIFtoAAL{16} = [83 84 87 88];
GIFtoAAL{17} = [79 80];
GIFtoAAL{18} = [67 68];
GIFtoAAL{19} = [59 60 61 62 63 64 65 66];
GIFtoAAL{20} = [57 58 69 70];
GIFtoAAL{21} = [43 44 45 46 47 48];
GIFtoAAL{22} = [49 50 51 52 53 54];
GIFtoAAL{23} = [31 32];
GIFtoAAL{24} = [33 34];
GIFtoAAL{25} = [35 36];
GIFtoAAL{26} = [29 30];
GIFtoAAL{27} = [];

StartingNii = load_untouch_nii('aal90.nii');
StartingImage = StartingNii.img;
EndingImage = uint8(zeros(size(StartingImage)));
for i = 1:numel(GIFtoAAL)
    for j = 1:numel(GIFtoAAL{i})
        regGIF = i;
        regAAL = GIFtoAAL{i}(j);
        valGIF = values(i);
        EndingImage(StartingImage == regAAL) = uint8(255*valGIF);
    end
end
EndingNii = StartingNii;
EndingNii.img = EndingImage;
save_untouch_nii(EndingNii, 'test.nii');
surface = 'BrainMesh_ICBM152_tal.nv';
optionfile = 'BrainNetOptions.mat';
BrainFig = BrainNet_MapCfg(surface,'test.nii',optionfile);
set(BrainFig, 'PaperPositionMode', 'manual');
set(BrainFig, 'PaperUnits', 'inch');
width = 2000;
height = 1500;
dpi = 300;
set(BrainFig,'Paperposition',[1 1 width/dpi height/dpi]);
ext = filename(strfind(filename,'.'):end);
switch ext
    case '.png'
        print(BrainFig,filename,'-dpng',['-r',num2str(dpi)])
    case '.tif'
        print(BrainFig,filename,'-dtiff',['-r',num2str(dpi)])
    case '.jpg'
        print(BrainFig,filename,'-djpeg',['-r',num2str(dpi)])
    case '.bmp'
        print(BrainFig,filename,'-dbmp',['-r',num2str(dpi)])
    case '.eps'
        print(BrainFig,filename,'-depsc',['-r',num2str(dpi)])
end
close gcf;
end