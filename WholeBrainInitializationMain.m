function AllParams = WholeBrainInitializationMain()
%% Setup stuff 1
AllParams.start_path = pwd;addpath(genpath(AllParams.start_path));addpath(genpath('/SAN/medic/nexopathy/MATLAB/'));addpath(genpath('/SAN/medic/nexopathy/kool/MATLAB/'));
dispstat('','init');dlmwrite('Finished.dat',0,' ');dlmwrite('Started.dat',0,' ');
AllParams.ParameterSet = dlmread('ParameterSet.dat');AllParams.ParameterInd = dlmread('ParameterInd.dat');AllParams.ParameterSizes = dlmread('ParameterSizes.dat');
AllParams.ModelIndex = mysub2ind(AllParams.ParameterSizes, AllParams.ParameterInd);

AllParams.GuessStartingOptimals = false;
AllParams.OptimizationOrManualSearch = 0; %0 - Generalized Pattern Search optimization, 1 Single Simulation
if(AllParams.OptimizationOrManualSearch == 0)
    AllParams.QuickSimulationEnd = true;
else
    AllParams.QuickSimulationEnd = false;
end
AllParams.OverwriteOptimals = false;
if(exist('GPS.mat', 'file') == 2)
    load('GPS.mat', 'OptimalValues');
    if(isequal(size(OptimalValues),AllParams.ParameterSizes))
        AllParams.OverwriteOptimals = false;
    else
        AllParams.OverwriteOptimals = true;
    end
end

AllParams.ImageNumbers = [6 7 11 13 15 16 20 23 24 26];
AllParams.NiftyregProcessing = false;
AllParams.PerformSmoothing = false;
AllParams.GenerateCSFandWMparcellations = false;
AllParams.BOLDUseSmoothedImage = true;
AllParams.BOLDDemean = true;
AllParams.BOLDNormalize = true;
AllParams.ComputeBOLD = false;
AllParams.SynapticUseSmoothedImage = true;
AllParams.ComputeSynapticSignals = false;
AllParams.DTISmallConnectionsEmphasized = true;
AllParams.DoDCMpreprocessing = false;
AllParams.TractographyPrior = true;
AllParams.TractographyPriorValues = [4 12 1];
% aprior = 4;
% bprior = 12;
% Soprior = 1;
% if(sum(DTInorm(:))> 1e-10)
%     pC.A = Soprior./(1+Soprior*exp(aprior-bprior*DTInorm));
% end
AllParams.TractographyPriorSmall = true;
AllParams.ComputeDCM = false;
AllParams.SkipDCM = false;
AllParams.EBMorAllnodes   = 1;   % 1 - 27 nodes EBM, 2 - 57 nodes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Paramaters to load from file
%Model Parameters
AllParams.WhichDisease    = 1;   % 1 - Alzheimer's, 2 - C9orf72, 3 - GRN, 4 - MAPT
AllParams.ProteinType     = 1;   % 1 2 3 4
AllParams.Metric          = 1;   % 1 2 3 4
AllParams.ProteinLocation = 1;   % 1 - Hippocampus, 2 - Parahippocampal gyrus, 3 - Entorhinal cortex

AllParams.FMRIspread      = 1; % 0 - no, 1 yes
AllParams.DTIspread       = 1; % 0 - no, 1 small emphasized, 2 - large emphasized
AllParams.DCMspread       = 1; % 0 - no, 1 - fmri, 2 - fmri + small, 3 - fmri + large
AllParams.NEURONEffect    = 1; % 1 - damage lowers firing frequencies. 2 - damage increases firing frequencies
AllParams.ChosenOptimization = 1;
AllParams.ExponentiateOptimizationInput = 1;

%
AllParams.WhichDisease       = AllParams.ParameterSet(1); % 1 - Alzheimer's, 2 - C9orf72, 3 - GRN, 4 - MAPT
AllParams.ProteinType        = AllParams.ParameterSet(2); % 1 2 3 4
AllParams.Metric             = AllParams.ParameterSet(3); % 1 2 3 4
AllParams.ProteinLocation    = AllParams.ParameterSet(4); % 1 - Hippocampus, 2 - Parahippocampal gyrus, 3 - Entorhinal cortex

AllParams.FMRIspread         = AllParams.ParameterSet(5); % 0 - no, 1 yes
AllParams.DTIspread          = AllParams.ParameterSet(6); % 0 - no, 1 small, 2 - large
AllParams.DCMspread          = AllParams.ParameterSet(7); % 0 - no, 1 - fmri, 2 - fmri + small, 3 - fmri + large
AllParams.NEURONEffect       = AllParams.ParameterSet(8); % 1 - damage lowers firing frequencies. 2 - damage increases firing frequencies
AllParams.ChosenOptimization = AllParams.ParameterSet(9); %1 - General Search, 2 - Cuckoo, 3 - ParticleSwarm, 4 - SurrogateOpt, 5- Simulated Annealing 
AllParams.ExponentiateOptimizationInput = AllParams.ParameterSet(10); %1 - yes, 0 - no

% Optimisation parameters. These will be their starting values during
% optimisation
AllParams.Seedsize                                   = 0.01;
AllParams.ExtracellularDiffusionFraction             = 0.01;
AllParams.ExtracellularDiffusionSpeed                = 0.01;
AllParams.NetworkDiffusionWeightFractionFMRI         = 0.01;
AllParams.NetworkDiffusionWeightFractionDTI          = 0.01;
AllParams.NetworkDiffusionWeightFractionDCM          = 0.01;
AllParams.NetworkDiffusionWeightDistanceFractionFMRI = 0.01;
AllParams.NetworkDiffusionWeightDistanceFractionDTI  = 0.01;
AllParams.NetworkDiffusionWeightDistanceFractionDCM  = 0.01;
AllParams.SynapticTransferWeightFractionFMRI         = 0.01;
AllParams.SynapticTransferWeightFractionDTI          = 0.01;
AllParams.SynapticTransferWeightFractionDCM          = 0.01;
AllParams.SynapticTransferWeightDistanceFractionFMRI = 0.01;
AllParams.SynapticTransferWeightDistanceFractionDTI  = 0.01;
AllParams.SynapticTransferWeightDistanceFractionDCM  = 0.01;
AllParams.NetworkDiffusionSpeed                      = 0.01;
AllParams.NEURONMisfold                              = 0.05;
AllParams.NEURONDiffusionSpeed                       = 0.1;
AllParams.NEURONDiffusion                            = 0.1;
AllParams.NEURONTransport                            = 0.01;
AllParams.NEURONSynaptic                             = 0.1;
AllParams.NEURONDamage                               = 0.01;

%Other parameters 
AllParams.Verbose                               = true;
AllParams.NumTimesteps                          = 1000000;
AllParams.InitialConcentrationNormalAll         = 0.01;
AllParams.InitialConcentrationPathogenicAll     = 0.00;

if(AllParams.WhichDisease == 1)
    AllParams.Seedsize                                   = 0.01;
    AllParams.ExtracellularDiffusionFraction             = 0.01;
    AllParams.ExtracellularDiffusionSpeed                = 0.01;
    AllParams.NetworkDiffusionWeightFractionFMRI         = 0.01;
    AllParams.NetworkDiffusionWeightFractionDTI          = 0.01;
    AllParams.NetworkDiffusionWeightFractionDCM          = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionFMRI = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionDTI  = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionDCM  = 0.01;
    AllParams.SynapticTransferWeightFractionFMRI         = 0.01;
    AllParams.SynapticTransferWeightFractionDTI          = 0.01;
    AllParams.SynapticTransferWeightFractionDCM          = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionFMRI = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionDTI  = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionDCM  = 0.01;
    AllParams.NetworkDiffusionSpeed                      = 0.01;
    AllParams.NEURONMisfold                              = 0.05;
    AllParams.NEURONDiffusionSpeed                       = 0.1;
    AllParams.NEURONDiffusion                            = 0.1;
    AllParams.NEURONTransport                            = 0.01;
    AllParams.NEURONSynaptic                             = 0.1;
    AllParams.NEURONDamage                               = 0.01;

    
    AllParams.DiseaseName = 'AD';
    AllParams.DiseaseEpicentres = cell(1,1);
    AllParams.DiseaseEpicentres{1} = 'Anterior Cingulate';
    AllParams.DiseaseEpicentres{2} = 'Hippocampus';
    AllParams.DiseaseEpicentres{3} = 'Amygdala';
    
    
%     {'16.  Anterior Cing '   }
%     {'Hippocampus'           }
%     {'Amygdala'              }
%     {'7.  Medial Temp '      }
%     {'8.  Lateral Temp  '    }
%     {'19.  Ant Insula  '     }
%     {'20.  Post Insula '     }
%     {'12.  Lateral Parietal '}
%     {'18.  Posterior Cing '  }
%     {'14.  Medial occ '      }
%     {'15.  Lateral Occ '     }
%     {'11.  Medial Parietal ' }
%     {'1  Orbitofrontal '     }
%     {'2.  DLPFC '            }
%     {'Thalamus Proper'       }
%     {'5.  Opercular '        }
%     {'3.  VMPFC '            }
%     {'17.  Middle Cing '     }
%     {'Accumbens Area'        }
%     {'10.  Supra Temp '      }
%     {'Putamen'               }
%     {'13.  Sensory '         }
%     {'6.  FRP '              }
%     {'Caudate'               }
%     {'4.  Motor '            }
%     {'Pallidum'              }
%     {'9.  Temporal Pole '    }
    
    AllParams.DiseaseNumRegions = 27;
    AllParams.DiseaseGroundTruthSequence = [131 132; ...
        48 49; ...
        32 33; ...
        113 114; ...
        115 116; ...
        137 138; ...
        139 140; ...
        123 124; ...
        135 136; ...
        127 128; ...
        129 130; ...
        121 122; ...
        101 102; ...
        103 104; ...
        60 61; ...
        109 110; ...
        105 106; ...
        133 134; ...
        24 31; ...
        119 120; ...
        58 59; ...
        125 126; ...
        111 112; ...
        37 38; ...
        107 108; ...
        56 57; ...
        117 118];
    
%     AllParams.DiseaseGroundTruthSequence = [171 172;...
%         48 49; ...
%         32 33; ...
%         117 118; ...
%         133 134; ...
%         155 156; ...
%         201 202; ...
%         123 124; ...
%         181 182; ...
%         60 61; ...
%         161 162; ...
%         129 130; ...
%         24 31; ...
%         167 168; ...
%         173 174; ...
%         103 104; ...
%         145 146; ...
%         107 108; ...
%         119 120; ...
%         153 154; ...
%         169 170; ...
%         195 196; ...
%         191 192; ...
%         143 144; ...
%         199 200; ...
%         185 186; ...
%         203 204];
    
    
elseif(AllParams.WhichDisease == 2)
    AllParams.Seedsize                                   = 0.01;
    AllParams.ExtracellularDiffusionFraction             = 0.01;
    AllParams.ExtracellularDiffusionSpeed                = 0.01;
    AllParams.NetworkDiffusionWeightFractionFMRI         = 0.01;
    AllParams.NetworkDiffusionWeightFractionDTI          = 0.01;
    AllParams.NetworkDiffusionWeightFractionDCM          = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionFMRI = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionDTI  = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionDCM  = 0.01;
    AllParams.SynapticTransferWeightFractionFMRI         = 0.01;
    AllParams.SynapticTransferWeightFractionDTI          = 0.01;
    AllParams.SynapticTransferWeightFractionDCM          = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionFMRI = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionDTI  = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionDCM  = 0.01;
    AllParams.NetworkDiffusionSpeed                      = 0.01;
    AllParams.NEURONMisfold                              = 0.05;
    AllParams.NEURONDiffusionSpeed                       = 0.1;
    AllParams.NEURONDiffusion                            = 0.1;
    AllParams.NEURONTransport                            = 0.01;
    AllParams.NEURONSynaptic                             = 0.1;
    AllParams.NEURONDamage                               = 0.01;
    
    
    AllParams.DiseaseName = 'C9orf72';
    AllParams.DiseaseEpicentres = cell(1,1);
    AllParams.DiseaseEpicentres{1} = 'Supratemporal';
    AllParams.DiseaseEpicentres{2} = 'Thalamus Proper';
    AllParams.DiseaseEpicentres{3} = 'Putamen';

%     {'10.  Supra Temp '      }
%     {'Thalamus Proper'       }
%     {'Putamen'               }
%     {'Pallidum'              }
%     {'19.  Ant Insula  '     }
%     {'20.  Post Insula '     }
%     {'2.  DLPFC '            }
%     {'4.  Motor '            }
%     {'5.  Opercular '        }
%     {'3.  VMPFC '            }
%     {'1  Orbitofrontal '     }
%     {'16.  Anterior Cing '   }
%     {'8.  Lateral Temp  '    }
%     {'12.  Lateral Parietal '}
%     {'Hippocampus'           }
%     {'Amygdala'              }
%     {'11.  Medial Parietal ' }
%     {'18.  Posterior Cing '  }
%     {'Caudate'               }
%     {'13.  Sensory '         }
%     {'7.  Medial Temp '      }
%     {'9.  Temporal Pole '    }
%     {'14.  Medial occ '      }
%     {'17.  Middle Cing '     }
%     {'15.  Lateral Occ '     }
%     {'6.  FRP '              }
%     {'Accumbens Area'        }
    
    
    AllParams.DiseaseNumRegions = 27;
    AllParams.DiseaseGroundTruthSequence = [119 120; ...
        60 61; ...
        58 59; ...
        56 57; ...
        137 138; ...
        139 140; ...
        103 104; ...
        107 108; ...
        109 110; ...
        105 106; ...
        101 102; ...
        131 132; ...
        115 116; ...
        123 124; ...
        48 49; ...
        32 33; ...
        121 122; ...
        135 136; ...
        37 38; ...
        125 126; ...
        113 114; ...
        117 118; ...
        127 128; ...
        133 134; ...
        129 130; ...
        111 112; ...
        24 31];
    
elseif(AllParams.WhichDisease == 3)
    AllParams.Seedsize                                   = 0.01;
    AllParams.ExtracellularDiffusionFraction             = 0.01;
    AllParams.ExtracellularDiffusionSpeed                = 0.01;
    AllParams.NetworkDiffusionWeightFractionFMRI         = 0.01;
    AllParams.NetworkDiffusionWeightFractionDTI          = 0.01;
    AllParams.NetworkDiffusionWeightFractionDCM          = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionFMRI = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionDTI  = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionDCM  = 0.01;
    AllParams.SynapticTransferWeightFractionFMRI         = 0.01;
    AllParams.SynapticTransferWeightFractionDTI          = 0.01;
    AllParams.SynapticTransferWeightFractionDCM          = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionFMRI = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionDTI  = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionDCM  = 0.01;
    AllParams.NetworkDiffusionSpeed                      = 0.01;
    AllParams.NEURONMisfold                              = 0.05;
    AllParams.NEURONDiffusionSpeed                       = 0.1;
    AllParams.NEURONDiffusion                            = 0.1;
    AllParams.NEURONTransport                            = 0.01;
    AllParams.NEURONSynaptic                             = 0.1;
    AllParams.NEURONDamage                               = 0.01;
    
    
    AllParams.DiseaseName = 'GRN';
    AllParams.DiseaseEpicentres = cell(1,1);
    AllParams.DiseaseEpicentres{1} = 'Middle Cingulate';
    AllParams.DiseaseEpicentres{2} = 'Lateral Parietal';
    AllParams.DiseaseEpicentres{3} = 'Medial Parietal';
    
%     {'17.  Middle Cing '     }
%     {'12.  Lateral Parietal '}
%     {'11.  Medial Parietal ' }
%     {'16.  Anterior Cing '   }
%     {'Pallidum'              }
%     {'Putamen'               }
%     {'4.  Motor '            }
%     {'2.  DLPFC '            }
%     {'5.  Opercular '        }
%     {'19.  Ant Insula  '     }
%     {'20.  Post Insula '     }
%     {'3.  VMPFC '            }
%     {'Caudate'               }
%     {'1  Orbitofrontal '     }
%     {'8.  Lateral Temp  '    }
%     {'10.  Supra Temp '      }
%     {'Hippocampus'           }
%     {'18.  Posterior Cing '  }
%     {'9.  Temporal Pole '    }
%     {'7.  Medial Temp '      }
%     {'Amygdala'              }
%     {'Thalamus Proper'       }
%     {'13.  Sensory '         }
%     {'Accumbens Area'        }
%     {'15.  Lateral Occ '     }
%     {'6.  FRP '              }
%     {'14.  Medial occ '      }
    
    AllParams.DiseaseNumRegions = 27;
    AllParams.DiseaseGroundTruthSequence = [133 134; ...
        123 124; ...
        121 122; ...
        131 132; ...
        56 57; ...
        58 59; ...
        107 108; ...
        103 104; ...
        109 110; ...
        137 138; ...
        139 140; ...
        105 106; ...
        37 38; ...
        101 102; ...
        115 116; ...
        119 120; ...
        48 49; ...
        135 136; ...
        117 118; ...
        113 114; ...
        32 33; ...
        60 61; ...
        125 126; ...
        24 31; ...
        129 130; ...
        111 112; ...
        127 128];
    
elseif(AllParams.WhichDisease == 4)
    AllParams.Seedsize                                   = 0.01;
    AllParams.ExtracellularDiffusionFraction             = 0.01;
    AllParams.ExtracellularDiffusionSpeed                = 0.01;
    AllParams.NetworkDiffusionWeightFractionFMRI         = 0.01;
    AllParams.NetworkDiffusionWeightFractionDTI          = 0.01;
    AllParams.NetworkDiffusionWeightFractionDCM          = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionFMRI = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionDTI  = 0.01;
    AllParams.NetworkDiffusionWeightDistanceFractionDCM  = 0.01;
    AllParams.SynapticTransferWeightFractionFMRI         = 0.01;
    AllParams.SynapticTransferWeightFractionDTI          = 0.01;
    AllParams.SynapticTransferWeightFractionDCM          = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionFMRI = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionDTI  = 0.01;
    AllParams.SynapticTransferWeightDistanceFractionDCM  = 0.01;
    AllParams.NetworkDiffusionSpeed                      = 0.01;
    AllParams.NEURONMisfold                              = 0.05;
    AllParams.NEURONDiffusionSpeed                       = 0.1;
    AllParams.NEURONDiffusion                            = 0.1;
    AllParams.NEURONTransport                            = 0.01;
    AllParams.NEURONSynaptic                             = 0.1;
    AllParams.NEURONDamage                               = 0.01;
    
    
    AllParams.DiseaseName = 'MAPT';
    AllParams.DiseaseEpicentres = cell(1,1);
    AllParams.DiseaseEpicentres{1} = 'Accumbens Area';
    AllParams.DiseaseEpicentres{2} = 'Supratemporal';
    AllParams.DiseaseEpicentres{3} = 'Temporal Pole';
    
%     {'Accumbens Area'        }
%     {'10.  Supra Temp '      }
%     {'9.  Temporal Pole '    }
%     {'7.  Medial Temp '      }
%     {'Amygdala'              }
%     {'Hippocampus'           }
%     {'20.  Post Insula '     }
%     {'19.  Ant Insula  '     }
%     {'Putamen'               }
%     {'Pallidum'              }  
%     {'8.  Lateral Temp  '    }
%     {'3.  VMPFC '            }
%     {'1  Orbitofrontal '     }
%     {'16.  Anterior Cing '   }
%     {'5.  Opercular '        }
%     {'2.  DLPFC '            }
%     {'12.  Lateral Parietal '}
%     {'Caudate'               }
%     {'6.  FRP '              }
%     {'15.  Lateral Occ '     }
%     {'13.  Sensory '         }
%     {'14.  Medial occ '      }
%     {'11.  Medial Parietal ' }
%     {'4.  Motor '            }
%     {'17.  Middle Cing '     }
%     {'18.  Posterior Cing '  }
%     {'Thalamus Proper'       }
    
    AllParams.DiseaseNumRegions = 27;
    AllParams.DiseaseGroundTruthSequence = [24 31; ...
        119 120; ...
        117 118; ...
        113 114; ...
        32 33; ...
        48 49; ...
        139 140; ...
        137 138; ...
        58 59; ...
        56 57; ...
        115 116; ...
        105 106; ...
        101 102; ...
        131 132; ...
        109 110; ...
        103 104; ...
        123 124; ...
        37 38; ...
        111 112; ...
        129 130; ...
        125 126; ...
        127 128; ...
        121 122; ...
        107 108; ...
        133 134; ...
        135 136; ...
        60 61];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if(AllParams.FMRIspread == 0)
    AllParams.noFMRI = true;
end

if(AllParams.DTIspread == 0)
    AllParams.noDTI = true;
elseif(AllParams.DTIspread == 1)
    AllParams.DTISmallConnectionsEmphasized = true;
elseif(AllParams.DTIspread == 2)
    AllParams.DTISmallConnectionsEmphasized = false;
end

AllParams.SkipDCM = false;
if(AllParams.DCMspread == 0)
    AllParams.SkipDCM = true;
    AllParams.noDCM = true;
elseif(AllParams.DCMspread == 1)
    AllParams.TractographyPrior = false;
elseif(AllParams.DCMspread == 2)
    AllParams.TractographyPrior = true;
    AllParams.TractographyPriorSmall = true;
elseif(AllParams.DCMspread == 3)
    AllParams.TractographyPrior = true;
    AllParams.TractographyPriorSmall = false;
end



%% Process stuff 2
if(AllParams.start_path(2) == 'S')
    AllParams.MACorCluster = 2; %0 - MAC, 1 - PC,  2 - Cluster. This determines where to save/load from.
elseif(AllParams.start_path(1) == 'C' || AllParams.start_path(1) == 'D')
    AllParams.MACorCluster = 1; %0 - MAC, 1 - PC,  2 - Cluster. This determines where to save/load from.
else
    AllParams.MACorCluster = 0; %0 - MAC, 1 - PC,  2 - Cluster. This determines where to save/load from.
end   


if(AllParams.MACorCluster == 0)
    AllParams.save_path = '/Users/kgeorgiadi/Documents/PhD/Results/LastPaper/';
    AllParams.NIFTYREG_INSTALL = '../../../GeneralCode/NiftyReg_Install';
    AllParams.dti_path = '/Users/kgeorgiadi/Documents/PhD/Data/FMRIDWIDATA/dti_output/';
    AllParams.fmri_path = '/Users/kgeorgiadi/Documents/PhD/Data/FMRIDWIDATA/fmri_output/';
    AllParams.parcellation_path = '/Users/kgeorgiadi/Documents/PhD/Data/FMRIDWIDATA/gif_output/';
elseif(AllParams.MACorCluster == 1)
    AllParams.save_path = 'D:\Data\PhD\Results\LastPaper\';
    AllParams.NIFTYREG_INSTALL = '..\..\..\GeneralCode\NiftyReg_Install';
    AllParams.dti_path = 'D:\Data\PhD\FMRIDWIDATA\dti_output\';
    AllParams.fmri_path = 'D:\Data\PhD\FMRIDWIDATA\fmri_output\';
    AllParams.parcellation_path = 'D:\Data\PhD\FMRIDWIDATA\gif_output\';
elseif(AllParams.MACorCluster == 2)
    AllParams.save_path = '/SAN/medic/nexopathy/kool/Results/';
    AllParams.NIFTYREG_INSTALL = '/share/apps/cmic/niftyreg_v1.5.43';
    AllParams.dti_path = '/SAN/medic/nexopathy/BrainScale/YOAD_dwi_rs/dti_output/';
    AllParams.fmri_path = '/SAN/medic/nexopathy/BrainScale/YOAD_dwi_rs/fmri_output/';
    AllParams.parcellation_path = '/SAN/medic/nexopathy/BrainScale/YOAD_dwi_rs/gif_output/';
end

if(exist(AllParams.save_path,'dir') == 0)
    mkdir(AllParams.save_path);
end


setenv('PATH', [getenv('PATH') ':' AllParams.NIFTYREG_INSTALL '/bin']);
setenv('LD_LIBRARY_PATH', [getenv('LD_LIBRARY_PATH') ':' AllParams.NIFTYREG_INSTALL '/lib']);
setenv('DYLD_LIBRARY_PATH', [getenv('DYLD_LIBRARY_PATH') ':' AllParams.NIFTYREG_INSTALL '/lib']);
setenv('LD_LIBRARY_PATH', [getenv('LD_LIBRARY_PATH') ':' AllParams.NIFTYREG_INSTALL '/dylib']);
setenv('DYLD_LIBRARY_PATH', [getenv('DYLD_LIBRARY_PATH') ':' AllParams.NIFTYREG_INSTALL '/dylib']);

%Register parcellation to other image spaces
if(AllParams.NiftyregProcessing)
    LargeToSmallMapping = cell(40,1);
    LargeToSmallMapping{1} = [105 147 137 179];
    LargeToSmallMapping{2} = [106 148 138 180];
    LargeToSmallMapping{3} = [191 143 163 165 205];
    LargeToSmallMapping{4} = [192 144 164 166 206];
    LargeToSmallMapping{5} = [125 141 187 153];
    LargeToSmallMapping{6} = [126 142 188 154];
    LargeToSmallMapping{7} = [183 151 193];
    LargeToSmallMapping{8} = [184 152 194];
    LargeToSmallMapping{9} = [119 113];
    LargeToSmallMapping{10} = [120 114];
    LargeToSmallMapping{11} = [121];
    LargeToSmallMapping{12} = [122];
    LargeToSmallMapping{13} = [117 123 171];
    LargeToSmallMapping{14} = [118 124 172];
    LargeToSmallMapping{15} = [133 155 201];
    LargeToSmallMapping{16} = [134 156 202];
    LargeToSmallMapping{17} = [203];
    LargeToSmallMapping{18} = [204];
    LargeToSmallMapping{19} = [181 185 207];
    LargeToSmallMapping{20} = [182 186 208];
    LargeToSmallMapping{21} = [169];
    LargeToSmallMapping{22} = [170];
    LargeToSmallMapping{23} = [175 195 199 107];
    LargeToSmallMapping{24} = [176 196 200 108];
    LargeToSmallMapping{25} = [177 149];
    LargeToSmallMapping{26} = [178 150];
    LargeToSmallMapping{27} = [115 109 135 161];
    LargeToSmallMapping{28} = [116 110 136 162];
    LargeToSmallMapping{29} = [197 129 145 157];
    LargeToSmallMapping{30} = [198 130 146 158];
    LargeToSmallMapping{31} = [101];
    LargeToSmallMapping{32} = [102];
    LargeToSmallMapping{33} = [139];
    LargeToSmallMapping{34} = [140];
    LargeToSmallMapping{35} = [167];
    LargeToSmallMapping{36} = [168];
    LargeToSmallMapping{37} = [103];
    LargeToSmallMapping{38} = [104];
    LargeToSmallMapping{39} = [173];
    LargeToSmallMapping{40} = [174];
   
    for i = AllParams.ImageNumbers
        TextNumber = num2str(i);
        for j = numel(TextNumber)+1:3
            TextNumber = ['0' TextNumber];
        end
        
        dtifile          = [AllParams.dti_path          '01-' TextNumber '-01-01-MR01/' 'DICOM_ep2d_diff_FREE69_p2FAD_2.5mm_i_20131010163642_14_merged_tensor_res.nii.gz'];
        dtitot1file      = [AllParams.dti_path          '01-' TextNumber '-01-01-MR01/' 'DICOM_ep2d_diff_FREE69_p2FAD_2.5mm_i_20131010163642_14_merged_b0_to_t1.txt'];
        fmrifile         = [AllParams.fmri_path         '01-' TextNumber '-01-01-MR01/' '4_rsfmri_in_epi.nii.gz'];
        t1tofmrifile     = [AllParams.fmri_path         '01-' TextNumber '-01-01-MR01/' '4_trans_ref_epi_flo_struct.txt'];
        parcellationfile = [AllParams.parcellation_path '01-' TextNumber '-01-01-MR01/' '01-' TextNumber '-01-01-MR01_gif_par.nii.gz'];
          
        resultfile       = [AllParams.fmri_path         '01-' TextNumber '-01-01-MR01/' '4_parcellation_in_epi.nii.gz'];
        %Uncomment to register parcellation to the fmri space
        %[~, cmdout] = system(['reg_resample -ref ' fmrifile ' -flo ' parcellationfile ' -res ' resultfile ' -trans ' t1tofmrifile ' -inter 0']);
        
        resultfile       = [AllParams.parcellation_path '01-' TextNumber '-01-01-MR01/' '01-' TextNumber '-01-01-MR01_gif_par_normalized.nii.gz'];
        %Uncomment to transform parcellation to 1x1x1mm space
        %[~, cmdout] = system(['reg_tools -in ' parcellationfile ' -out ' resultfile ' -chgres 1 1 1']);
        
        
        NiiFile = load_untouch_nii(parcellationfile);
        for j = 1:numel(LargeToSmallMapping)
            for k = 1:numel(LargeToSmallMapping{j})
                value = LargeToSmallMapping{j}(k);
                NiiFile.img(NiiFile.img == value) = 300+j;
            end
        end
        for j = 1:numel(LargeToSmallMapping)
            NiiFile.img(NiiFile.img == 300+j) = 100+j;
        end
        save_untouch_nii(NiiFile, [AllParams.parcellation_path '01-' TextNumber '-01-01-MR01/' '01-' TextNumber '-01-01-MR01_gif_par_FTD.nii.gz']);
        
        parfilefmri      = [AllParams.fmri_path '01-' TextNumber '-01-01-MR01/' '4_parcellation_in_epi.nii.gz'];
        NiiFile = load_untouch_nii(parfilefmri);
        for j = 1:numel(LargeToSmallMapping)
            for k = 1:numel(LargeToSmallMapping{j})
                value = LargeToSmallMapping{j}(k);
                NiiFile.img(NiiFile.img == value) = 300+j;
            end
        end
        for j = 1:numel(LargeToSmallMapping)
            NiiFile.img(NiiFile.img == 300+j) = 100+j;
        end
        save_untouch_nii(NiiFile, [AllParams.fmri_path '01-' TextNumber '-01-01-MR01/' '4_parcellation_in_epi_FTD.nii.gz']);
    end
end

if(AllParams.OverwriteOptimals)
    OptimalValues          = inf(AllParams.ParameterSizes);
    OptimalParameterSets   = cell(AllParams.ParameterSizes);
    OptimalSequence        = cell(AllParams.ParameterSizes);
    OptimalSequenceTrimmed = cell(AllParams.ParameterSizes);
    save('GPS.mat', 'OptimalValues', 'OptimalParameterSets', 'OptimalSequence', 'OptimalSequenceTrimmed');
end


end
