function [EffectiveConnectivityPEB, EffectiveConnectivityBMA, DCMAll, MeanEffectiveConnectivity] = WholeBrainDCM(ImageNumbers, Mapping, Active, Names, fmri_path, ChosenNodes, DTIs, TractographyPrior, TractographyPriorValues, DTITractographyPriorSmall, EBMorAllnodes, DiseaseName, DiseaseNumRegions, Compute, Skip)
if(Skip)
    if(EBMorAllnodes == 1)
        n = DiseaseNumRegions;
    elseif(EBMorAllnodes == 2)
        n = 57;
    end
    EffectiveConnectivityPEB = eye(n);
    EffectiveConnectivityBMA = eye(n);
    MeanEffectiveConnectivity = eye(n);
    DCMAll = 1;
    return;
end
%? in the leading diagonal of the A matrix ? now specify log scaling parameters. This
%means that these (and only these) parameters encode a self-connections of ?1/2 * exp(A); where A
%has a prior mean of 0 and ?1/2 * exp(0) = ?1/2
spm('defaults','fmri');
spm_get_defaults('cmdline',true);
spm_jobman('initcfg');

controliter = 0;
for Control_i = ImageNumbers
    controliter = controliter + 1;
    TextNumber = num2str(Control_i);
    for j = numel(TextNumber)+1:3
        TextNumber = ['0' TextNumber];
    end
    
    filename = 'DCM';
    if(TractographyPrior)
        filename = [filename 'DTI'];
        if(DTITractographyPriorSmall)
            filename = [filename 's'];
        else
            filename = [filename 'l'];
        end
    end
    if(EBMorAllnodes == 1)
        filename = [filename num2str(DiseaseNumRegions)];
    elseif(EBMorAllnodes == 2)
        filename = [filename '57'];
    end
    filename = [filename DiseaseName];
    
    filenameAll = filename;
    filename = [filename  'subject.mat'];
    
    fmrifile  = [fmri_path '01-' TextNumber '-01-01-MR01/' '4_rsfmri_in_epi.nii.gz'];
    savefile  = [fmri_path '01-' TextNumber '-01-01-MR01/' filename];
    savefileAll = [fmri_path filenameAll 'all.mat'];
    
    if(~(exist(savefile, 'file') == 2))
        Compute = true;
    end
    
    if(Compute)
        BOLDFile = load_untouch_nii(fmrifile);
        RT = BOLDFile.hdr.dime.pixdim(5);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SPECIFY & ESTIMATE DCM
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        clear DCM;
        glmcorrdir = fullfile([fmri_path '01-' TextNumber '-01-01-MR01/'],'glm_corrected');
        
        % ROIs
        cd(glmcorrdir)
        spmbatchiter = 1;
        loadednames = cell(1,1);
        DTInodes = [];
        for kostasiter = 1:numel(Mapping)
            name = Names{kostasiter};
            if(numel(name) > 6)
                if(strcmp(name(1:6), 'Right '))
                    name = name(7:end);
                elseif(strcmp(name(1:5), 'Left '))
                    name = name(6:end);
                end
            end
            name = strrep(name,' ', '_');
            if(Active(kostasiter))
                if(any(ChosenNodes == Mapping(kostasiter)))
                    load(['VOI_' name '_1.mat']);
                    if(any(strcmp(name, loadednames)))
                        continue;
                    else
                        DCM.xY(spmbatchiter) = xY;
                        DTInodes(end+1) = kostasiter;
                        spmbatchiter = spmbatchiter + 1;
                    end
                    loadednames{spmbatchiter} = name;
                end
            end
        end
        
        DTI = DTIs{controliter};
        DTI = DTI(DTInodes,DTInodes);
        DTInorm = DTI/sum(DTI(:));
        if(TractographyPrior == false)
            DTInorm = 0;
        end
        
        % Metadata
        v = length(DCM.xY(1).u); % number of time points
        n = length(DCM.xY);      % number of regions
        
        DCM.v = v;
        DCM.n = n;
        
        % Timeseries
        DCM.Y.dt  = RT;
        DCM.Y.X0  = DCM.xY(1).X0;
        DCM.Y.Q   = spm_Ce(ones(1,n)*v);
        for i = 1:DCM.n
            DCM.Y.y(:,i)  = DCM.xY(i).u;
            DCM.Y.name{i} = DCM.xY(i).name;
        end
        
        % Task inputs
        DCM.U.u    = zeros(v,1);
        DCM.U.name = {'null'};
        
        % Connectivity
        DCM.a  = ones(n,n);
        DCM.b  = zeros(n,n,0);
        DCM.c  = zeros(n,0);
        DCM.d  = zeros(n,n,0);
        
        % Timing
        DCM.TE     = 0.04;
        DCM.delays = repmat(RT,DCM.n,1);
        
        % Options
        DCM.options.nonlinear  = 0;
        DCM.options.two_state  = 0;
        DCM.options.stochastic = 0;
        DCM.options.analysis   = 'CSD';
        DCM.options.induced    = 1;
        
        str = sprintf('DCM_DMN');
        DCM.name = str;
        save(fullfile(glmcorrdir,str),'DCM');
        DCM = WholeBrainspm_dcm_fmri_csd(fullfile(glmcorrdir,str), DTInorm, TractographyPriorValues);
        save(savefile, 'DCM');
    end
    
    load(savefile, 'DCM');
    DCMAll{controliter,1} = DCM;
    MeanEffectiveConnectivity(:,:,controliter) = DCM.Ep.A;
end

% figure;
% for Control_i = 1:size(MeanEffectiveConnectivity,3)
%     subplot(4,4,Control_i);imagesc(MeanEffectiveConnectivity(:,:,Control_i)); colorbar; colormap jet; caxis([min(MeanEffectiveConnectivity(:)) max(MeanEffectiveConnectivity(:))]);
% end

M.X     = ones(numel(ImageNumbers),1);
M.alpha = 1;
M.beta  = 16;
M.hE    = 0;
M.hC    = 1/16;
M.Q     = 'single';
field = {'A'};

if(~(exist(savefileAll, 'file') == 2))
    Compute = true;
end

if(Compute)
    n = size(DCMAll{1}.Ep.A,1);
    [PEB, DCMAllOutput] = spm_dcm_peb(DCMAll,M,field);
    EffectiveConnectivityPEB = reshape(full(PEB.Ep),[n,n]);
    BMA = spm_dcm_peb_bmc(PEB);
    EffectiveConnectivityBMA = reshape(full(BMA.Ep),[n,n]);
    save(savefileAll, 'EffectiveConnectivityPEB', 'EffectiveConnectivityBMA', 'DCMAll', 'MeanEffectiveConnectivity');
end
load(savefileAll, 'EffectiveConnectivityPEB', 'EffectiveConnectivityBMA', 'DCMAll', 'MeanEffectiveConnectivity');
close all;

% figure;
% subplot(1,2,1);imagesc(EffectiveConnectivityPEB);colorbar; 
% subplot(1,2,2);imagesc(EffectiveConnectivityBMA);colorbar; 

% BOLDPopulationSignals = BOLDPopulationSignals(Active,:);
% BOLDAllSignals = BOLDAllSignals(Active,:,:);
% controliter = 0;
% for Control_i = ImageNumbers
%     controliter = controliter + 1;
%     TextNumber = num2str(Control_i);
%     for j = numel(TextNumber)+1:3
%         TextNumber = ['0' TextNumber];
%     end
%     fmrifile  = [data_path 'fmri_output/' '01-' TextNumber '-01-01-MR01/' '4_rsfmri_in_epi.nii.gz'];
%     BOLDFile = load_untouch_nii(fmrifile);
%     DCM.Y.y = BOLDAllSignals(ChosenNodes,:,controliter)';
%     DCM.n = size(DCM.Y.y,2);
%     DCM.v = size(DCM.Y.y,1);
%     DCM.Y.dt = BOLDFile.hdr.dime.pixdim(5);
%     DCM.U.u = zeros(DCM.v,1);
%     DCM.U.name = 'null';
%     DCM.d = zeros(DCM.n,DCM.n,0);
%     DCM.c = zeros(DCM.n,1);
%     DCM.b = zeros(DCM.n, DCM.n);
%     DCM.a = ones(DCM.n, DCM.n);
%     
%     %Num gigabytes required 8*43^2*NUMSIGNALS^4/(1024^3)
%     DCMsp = spm_dcm_fmri_csd(DCM);
%     DCMAll{controliter,1} = DCMsp;
%     temp = diag(full(DCMsp.Cp));
%     temp = reshape(temp(1:DCM.n^2),DCM.n,DCM.n);
%     MeanEffectiveConnectivity(:,:,controliter) = DCMsp.Ep.A;
%     StdEffectiveConnectivity(:,:,controliter) = sqrt(temp);
%     toc
% end

% Xs = (-1:0.001:1);
% for i = 1:DCM.n
%     for j = 1:DCM.n
%         for Control_i = 1:numel(ImageNumbers)
%             Y{i,j}(Control_i,:) = normpdf(Xs,MeanEffectiveConnectivity(i,j,Control_i),StdEffectiveConnectivity(i,j,Control_i))/ImageNumbers;
%         end
%     end
% end

% figure;
% alliterator = 0;
% for i = 1:DCM.n
%     for j = 1:DCM.n
%         alliterator = alliterator + 1;
%         hold on;subplot(DCM.n, DCM.n, alliterator); plot(Xs,sum(Y{i,j})); hold off;
%     end
% end 



% figure;
% for Control_i = 1:NumControls
%     subplot(3,3,Control_i);imagesc(StdEffectiveConnectivity(:,:,Control_i)); colorbar; colormap jet; caxis([min(StdEffectiveConnectivity(:)) max(StdEffectiveConnectivity(:))]);
% end

%% Mean effective connectivity over subjects
% M.X     = ones(numel(ImageNumbers),1);
% M.alpha = 1;
% M.beta  = 16;
% M.hE    = 0;
% M.hC    = 1/16;
% M.Q     = 'single';
% field = {'A'};
% 
% [PEB, DCMAllOutput] = spm_dcm_peb(DCMAll,M,field);
% EffectiveConnectivityPEB = reshape(full(PEB.Ep),[numel(ChosenNodes),numel(ChosenNodes)]);
% EffectiveConnectivity = mean(MeanEffectiveConnectivity,3); 

% figure;
% subplot(1,2,1);imagesc(EffectiveConnectivity);colorbar; 
% subplot(1,2,2);imagesc(EffectiveConnectivityPEB);colorbar; 


end