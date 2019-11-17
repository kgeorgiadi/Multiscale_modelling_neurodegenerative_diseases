close all; clear variables; clc;
%scp -r kgeorgia@comic100.cs.ucl.ac.uk:/SAN/medic/nexopathy/kool/Disease* /Users/kgeorgiadi/Documents/PhD/Results/LastPaper/
save_path = '/Users/kgeorgiadi/Documents/PhD/Results/LastPaper/';
rng('shuffle');
%% Combine all GPS.mat files into a single one
ParameterSet{1}       = [ 1 2 3 4];
ParameterSet{2}       = [ 1 ];
ParameterSet{3}       = [ 1  ];
ParameterSet{4}       = [ 1 2 ];
ParameterSet{5}       = [ 1 ];
ParameterSet{6}       = [ 1 2 ];
ParameterSet{7}       = [ 1 2 3 ];
ParameterSet{8}       = [ 1 2 ];
ParameterSet{9}       = [ 1 ];
ParameterSet{10}      = [ 1 ];

ParameterSetNames{1}  = 'Disease';
ParameterSetNames{2}  = 'Protein';
ParameterSetNames{3}  = 'Metric';
ParameterSetNames{4}  = 'Seed';
ParameterSetNames{5}  = 'FMRI';
ParameterSetNames{6}  = 'DTI';
ParameterSetNames{7}  = 'DCM';
ParameterSetNames{8}  = 'Effect';
ParameterSetNames{9}  = 'Algorithm';
ParameterSetNames{10} = 'Exp';


for i = 1:numel(ParameterSet)
    VariableNumValues(i,1) = numel(ParameterSet{i});
end
TotalSimulations = prod(VariableNumValues);
[~, Save_Directories, ~, ~, ~, ~, ~] = GetInputFolders(ParameterSet, ParameterSetNames, save_path, save_path);
Load_Directories = Save_Directories;
NumDirectories = size(Load_Directories,2);
CurrentVariableNumValues = ones(size(VariableNumValues));
CurrentVariableNumValues(1) = 0;

OptimalValues2          = inf(NumDirectories,1); 
OptimalSequence2        = cell(NumDirectories,1);
OptimalSequenceTrimmed2 = OptimalSequence2;
OptimalParameterSets2   = OptimalSequence2;

for DirectoryIndex = 1:NumDirectories
    CurrentDirectory = Load_Directories{DirectoryIndex};
	k = 1;
    CurrentVariableNumValues(k) = CurrentVariableNumValues(k) + 1;
    while(1)
        if(CurrentVariableNumValues(k) > VariableNumValues(k))
            CurrentVariableNumValues(k) = 1;
            k = k + 1;
            CurrentVariableNumValues(k) = CurrentVariableNumValues(k) + 1;
        else
            break;
        end
    end
    
    if(exist([CurrentDirectory 'GPS.mat']))
        load([CurrentDirectory 'GPS.mat']);
        OptimalSequence2{DirectoryIndex} = OptimalSequence{DirectoryIndex};
        OptimalSequenceTrimmed2{DirectoryIndex} = OptimalSequenceTrimmed{DirectoryIndex};
        OptimalParameterSets2{DirectoryIndex} = OptimalParameterSets{DirectoryIndex};
        OptimalValues2(DirectoryIndex) = OptimalValues(DirectoryIndex);
    end
end

OptimalSequence = reshape(OptimalSequence2, VariableNumValues');
OptimalSequenceTrimmed = reshape(OptimalSequenceTrimmed2, VariableNumValues');
OptimalParameterSets = reshape(OptimalParameterSets2, VariableNumValues');
OptimalValues = reshape(OptimalValues2, VariableNumValues');
save('/Users/kgeorgiadi/Dropbox/PhD/code_koolOld/MATLAB/GPS.mat', 'OptimalSequence', 'OptimalParameterSets', 'OptimalSequenceTrimmed', 'OptimalValues', 'OptimalSequence2', 'OptimalParameterSets2', 'OptimalSequenceTrimmed2', 'OptimalValues2');


%% Now we can play around with the single GPS file, lets find the best models and save them as .dat files for
% creating results and then check to make sure we have a good picture

load('/Users/kgeorgiadi/Dropbox/PhD/code_koolOld/MATLAB/GPS.mat');
for disease = ParameterSet{1}
    for protein = ParameterSet{2}
        for metric = ParameterSet{3}
            bestvalue = inf;
            bestmodel = [disease protein metric 0 0 0 0 0 0 0 zeros(1,numel(OptimalParameterSets2{1}))];
            bestsequence = [];
            
            for seed = ParameterSet{4}
                for fmri = ParameterSet{5}
                    for dti = ParameterSet{6}
                        for dcm = ParameterSet{7}
                            for effect = ParameterSet{8}
                                for algorithm = ParameterSet{9}
                                    for exponentiate = ParameterSet{10}
                                        curval = OptimalValues(disease,protein,metric,seed,fmri,dti,dcm,effect,algorithm, exponentiate);
                                        if(curval < bestvalue)
                                            bestvalue = curval;
                                            bestmodel = [disease protein metric seed fmri dti dcm effect algorithm exponentiate OptimalParameterSets{disease,protein,metric,seed,fmri,dti,dcm,effect,algorithm}'];
                                            bestsequence = OptimalSequence{disease,protein,metric,seed,fmri,dti,dcm,effect,algorithm};
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            bestvalue
            bestmodel
            bestsequence
            bestvalues(disease) = bestvalue;
            if(disease == 1)
                save(['/Users/kgeorgiadi/Dropbox/PhD/code_koolOld/MATLAB/AD.mat'], 'bestmodel');
            elseif(disease == 2)
                save(['/Users/kgeorgiadi/Dropbox/PhD/code_koolOld/MATLAB/C9orf72.mat'], 'bestmodel');
            elseif(disease == 3)
                save(['/Users/kgeorgiadi/Dropbox/PhD/code_koolOld/MATLAB/GRN.mat'], 'bestmodel');
            elseif(disease == 4)
                save(['/Users/kgeorgiadi/Dropbox/PhD/code_koolOld/MATLAB/MAPT.mat'], 'bestmodel');
            end
        end
    end
end
bestvalues'
    
% check these matrices out to see wassup
% for i = 1:numel(OptimalSequence2)
%     if(~isempty(OptimalSequence2{i}))
%         OptimalSequenceMatrix(i,:) = OptimalSequence2{i}';
%         OptimalParameterSetsMatrix(i,:) = OptimalParameterSets2{i};
%     end
% end
% 
% bestcases = find(OptimalValues(:));
% bestcasesvals = OptimalValues(bestcases);
% [bestcasesvals,sortedindices] = sort(bestcasesvals);
% bestcases = bestcases(sortedindices);
% [v1, v2, v3, v4, v5, v6, v7, v8, v9, v10]=ind2sub(size(OptimalValues), bestcases);
% shownomorethan = 1;
% for dis = 1:4
% showedsofar = 0;
% for i = 1:numel(v1)
%     if(v1(i) == dis) % RESTRICT WHAT WE SHOW - for example v1(i) == 1 forces us to look at only AD cases
%         CurrentValue = OptimalValues(v1(i),v2(i),v3(i),v4(i),v5(i),v6(i),v7(i),v8(i),v9(i),v10(i));
%         CurrentSequence = OptimalSequence{v1(i),v2(i),v3(i),v4(i),v5(i),v6(i),v7(i),v8(i),v9(i),v10(i)};
%         CurrentParameterSets = OptimalParameterSets{v1(i),v2(i),v3(i),v4(i),v5(i),v6(i),v7(i),v8(i),v9(i),v10(i)};
%         [CurrentValue v1(i),v2(i),v3(i),v4(i),v5(i),v6(i),v7(i),v8(i),v9(i),v10(i) CurrentParameterSets']
%         showedsofar = showedsofar + 1;
%         if(showedsofar >= shownomorethan)
%             break;
%         end
%     end
% end
% end
% % 
% 
% 
















