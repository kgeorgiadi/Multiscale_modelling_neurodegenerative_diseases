function [LoadDirectories, SaveDirectories, NumVariables, VariablesSize, VariablesNames, VariablesActive, NumSimulations] = GetInputFolders(ParameterSet, ParameterSetNames, save_path, load_path)
NumVariables = numel(ParameterSet);
VariablesSize = zeros(NumVariables,1);
VariablesNames = ParameterSetNames;
for i = 1:NumVariables
    VariablesSize(i) = numel(ParameterSet{i});
end
NumSimulations = prod(VariablesSize);
VariablesActive = cell(NumVariables,1);
for i = 1:numel(VariablesActive)
    VariablesActive{i} = false(VariablesSize(i),NumSimulations);
end

LoadDirectories = cell(0,0);
SaveDirectories = cell(0,0);
CurrentSimulation = ones(1,NumVariables);
for Simulation = 1:NumSimulations
	DIRECTORYload = load_path;
	DIRECTORYsave = save_path;
	for j=1:NumVariables
		DIRECTORYload = strcat(DIRECTORYload, VariablesNames{j}, num2str(CurrentSimulation(j)),'/');
		DIRECTORYsave = strcat(DIRECTORYsave, VariablesNames{j}, num2str(CurrentSimulation(j)),'/');
        VariablesActive{j}(CurrentSimulation(j),Simulation) = true;
	end
	LoadDirectories{size(LoadDirectories,2)+1} = DIRECTORYload;
	SaveDirectories{size(SaveDirectories,2)+1} = DIRECTORYsave;
	
    
    
    if(Simulation < NumSimulations)
        k = 1;
        CurrentSimulation(k) = CurrentSimulation(k) + 1;
        while(1)
            if(CurrentSimulation(k) > VariablesSize(k))
                CurrentSimulation(k) = 1;
                k = k + 1;
                CurrentSimulation(k) = CurrentSimulation(k) + 1;
            else
                break;
            end
        end
    end
end
end
