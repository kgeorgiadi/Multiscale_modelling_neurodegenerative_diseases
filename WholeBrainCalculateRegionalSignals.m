function [NTC, ARS, AIS, IS] = WholeBrainCalculateRegionalSignals(data, atlas, TR)
%AIS IS OUTPUT OF INTEREST

%% SELECT PROCESS STEPS;
METHOD_TEMP = 'B' ;% S:spikes, B:blocks, W:Wiener % Type of Temporal Regularization
METHOD_SPAT = 'STRSPR'; % Tik:tikhonov OR 'StrSpr:Structured Sparsity' OR 'NO': no spatial regularization % Type of Temporal Regularization
DETRENDING = 'dct'; % or 'dct' data will be detrended for low frequency oscialltions (DCT).
% NOTE: normalization is voxel by voxel z-normalization

% select shape of HRF
param.HRF ='bold'; %%% or bold/spmhrf
param.TR = TR; % enter repetition time
param.DCT_TS = 250; % enter dct cut off period (only for DETRENDING='dct')
param.LambdaTempCoef = 1/0.8095; % OR 1/0.6745; estimates higher noise % mad coefficient for temporal regularization
param.COST_SAVE = 1; % save the costs % (optional) for test data

%% READ DATA
RealignParam = [];
param.File_EXT = 'mat'; % nii

%%% Take only non-zeros values both in the atlas and in the data...
%%% REMEMBER: Atlas is gray matter only, but the data is GM+WM+CSF
param.Dimension = size(data);
param.IND = find(atlas.*sum(data,4));
[param.VoxelIdx(:,1),param.VoxelIdx(:,2),param.VoxelIdx(:,3)] = ind2sub(param.Dimension(1:3),param.IND);
param.NbrVoxels = length(param.VoxelIdx(:,1));
TC = zeros(param.NbrVoxels,param.Dimension(4));
for i = 1:length(param.VoxelIdx(:,1))
    TC(i,:) = data(param.VoxelIdx(i,1),param.VoxelIdx(i,2),param.VoxelIdx(i,3),:); % timecourses
end


%% Detrend
%fprintf('Detrending the data... \n');
TCN = zeros(param.Dimension(4),param.NbrVoxels); % normalize by dividing to std (var=1).
tic;
if strcmpi(DETRENDING,'DCT')
    param.METHOD_DETREND = 'DCT and normalize';
    %fpirntf('Detrending method: DCT \n\n');
    for i=1:param.NbrVoxels
        %         [TCN(:,i), coef_tc(:,i)] = sol_dct(TC(i,:)',param.TR,param.DCT_TS,RealignParam); % subtract mean liner detrend + DCT
        [TCN(:,i), ~] = sol_dct(TC(i,:)',param.TR,param.DCT_TS,RealignParam); % subtract mean liner detrend + DCT
        TCN(:,i) = TCN(:,i)./std(TCN(:,i));
    end
elseif strcmpi(DETRENDING,'normalize')
    param.METHOD_DETREND = 'normalize';
    %fprintf('No Detrending: only normalize \n\n')
    if(strcmp(param.File_EXT,'mat'))
        for i=1:param.NbrVoxels
            TCN(:,i) = (TC(i,:))'./std(TC(i,:));
        end
    else
        for i=1:param.NbrVoxels
            TCN(:,i) = (TC(i,:)-mean(TC(i,:)))'./std(TC(i,:));
        end
    end
else
    error('Unknown detrending method...');
end
time_detrend = toc;
%fprintf('It took %f seconds to detrend (method %s)  %d voxel timecouses \n\n', time_detrend, DETRENDING,param.NbrVoxels);

%% Regularization
switch lower(METHOD_TEMP)
    case 's'
        param.METHOD_TEMP='SPIKE';
        [param.f_Analyze,param.f_Recons,param.MaxEig] = hrf_filters(param.TR,'spike',param.HRF);
        param.NitTemp = 200;
        %fprintf('Temporal Regularization for SPIKES\n');
    case 'b'
        param.METHOD_TEMP = 'BLOCK';
        [param.f_Analyze,param.f_Recons,param.MaxEig] = hrf_filters(param.TR,'block',param.HRF);
        param.NitTemp = 500;
        %fprintf('Temporal Regularization for BLOCKS\n');
    case 'poss'
        %disp('NOT YET IMPLEMENTED!');
    case 'w'
        param.METHOD_TEMP='WIENER';
        [param.f_Analyze,param.f_Recons,param.MaxEig] = hrf_filters(param.TR,'block',param.HRF);
        param.NitTemp = 1;
        %fprintf('Temporal Regularization: WIENER FILTER for BLOCKS\n');
    otherwise
        %disp('Unknown method.');
end


switch lower(METHOD_SPAT)
    case 'no'
        param.METHOD_SPAT = 'no';
        %fprintf('NO Spatial Constraint\n');
    case 'tik'
        param.METHOD_SPAT = 'TIK';
        %fprintf('Spatial Regularization: Tikhonov 2nd order\n');
        param.Nit=5;
        param.NitSpat=100;
        param.LambdaSpat=1;
        param.stepsize=0.01;
        param.weights = [0.5 0.5]; % weights for Gen Back-Forward
        param.dimTik=3; % Tikhonov in 3d (or 2d).
    case 'strspr'
        param.METHOD_SPAT = 'STRSPR';
        %fprintf('Spatial Regularization: Sptructured Sparsity l_{2-1}-norm\n');
        % Number of outer iterations
        param.Nit=10;
        param.NitSpat=100;
        % Here Adjust the weight(LambdaSpat) of spatial regularization...
        param.LambdaSpat=5;
        % We assign equal weights for both solutions
        param.weights = [0.5 0.5]; % equal weights for Gen Back-Forward
        param.OrderSpat = 2; % use 2nd order derivative... for now
        param.dimStrSpr=3; %only 3 for now...
    otherwise
        %disp('Unknown method!');
end

%% parameters set, START REGULARIZATION
tic;
[TC_OUT,param] = MySpatial(TCN,atlas,param);
time2 = toc;
%disp(' ');
%disp(['IT TOOK ', num2str(time2), ' SECONDS FOR SPATIO_TEMPORAL REGULARIZATION OF ', num2str(param.NbrVoxels), ' TIMECOURSES']);
%disp(' ');
param.time=time2;

%% PostProcessing
% Generate the activity-inducing signal and innovation signal (if blocks)
% for spikes activity-inducing signal = innovation signal
TC_D_OUT = zeros(param.Dimension(4),param.NbrVoxels); % ACTIVITY-INDUCING SIGNAL
if strcmpi(param.METHOD_TEMP,'block') || strcmpi(param.METHOD_TEMP,'wiener')
    TC_D2_OUT = zeros(param.Dimension(4),param.NbrVoxels); % innovation signal
    %    TC_D_OUT2 = zeros(param.Dimension(4),param.NbrVoxels);
end
for i=1:param.NbrVoxels
    TC_D_OUT(:,i) = filter_boundary(param.f_Recons.num,param.f_Recons.den,TC_OUT(:,i),'normal');
    if strcmpi(param.METHOD_TEMP,'block') || strcmpi(param.METHOD_TEMP,'wiener')
        TC_D2_OUT(:,i) = [0;diff((TC_D_OUT(:,i)))];
        %        TC_D_OUT2(:,i) = cumsum([zeros(5,1); TC_D2_OUT(6:end,i)]);  %Neglect the first 5 volumes?? sometimes shifts the response...
    end
end


%% WRITE VOLUME

NTC =  zeros(param.Dimension); % NORMALIZED TIME COURSES
ARS = zeros(param.Dimension); % ACTIVITY-RELATED SIGNALS
AIS = zeros(param.Dimension); % ACTIVITY-INDUCED SIGNALS

for i = 1:length(param.VoxelIdx(:,1))
    NTC(param.VoxelIdx(i,1),param.VoxelIdx(i,2),param.VoxelIdx(i,3),:) = TCN(:,i);
    ARS(param.VoxelIdx(i,1),param.VoxelIdx(i,2),param.VoxelIdx(i,3),:)  = TC_OUT(:,i);
    AIS(param.VoxelIdx(i,1),param.VoxelIdx(i,2),param.VoxelIdx(i,3),:) = TC_D_OUT(:,i);
end


if strcmpi(param.METHOD_TEMP,'block')
    IS = zeros(param.Dimension); %INNOVATION SIGNALS
    %innvoation signal
    for i = 1:length(param.VoxelIdx(:,1))
        IS(param.VoxelIdx(i,1),param.VoxelIdx(i,2),param.VoxelIdx(i,3),:) = TC_D2_OUT(:,i);
    end
    
end

end