function ConnectionWeightsNEURON = WholeBrainConnectionWeightsNEURON(data)
for i = 1
E2 = 18;
E2B = 19;
I2 = 20;
I2L = 23;
E4 = 15;
I4 = 16;
I4L = 17;
E5B = 11;
E5R = 12;
I5 = 13;
I5L = 14;
E6 = 7;
I6 = 8;
I6L = 10;

data.numconnections = zeros(23,23,2);
data.numconnections(E6,E6,1) = 2;
data.numconnections(E6,I6,1) = 11;
data.numconnections(E6,I6,2) = 4;
data.numconnections(E6,I6L,1) = 7;
data.numconnections(E6,E5B,1) = 1;
data.numconnections(E6,E5R,1) = 1;

data.numconnections(I6,E6,1) = 27;
data.numconnections(I6,I6,1) = 16;
data.numconnections(I6,I6L,1) = 5;

data.numconnections(I6L,E6,1) = 21;
data.numconnections(I6L,I6,1) = 14;
data.numconnections(I6L,I6L,1) = 2;
data.numconnections(I6L,E5B,1) = 5;
data.numconnections(I6L,E5R,1) = 17;
data.numconnections(I6L,I5,1) = 14;
data.numconnections(I6L,E2,1) = 50;
data.numconnections(I6L,I2,1) = 14;

data.numconnections(E5B,E6,1) = 5;
data.numconnections(E5B,E5B,1) = 2;
data.numconnections(E5B,E5B,2) = 5;
data.numconnections(E5B,E5R,1) = 2;
data.numconnections(E5B,E5R,2) = 17;
data.numconnections(E5B,I5,1) = 11;
data.numconnections(E5B,I5,2) = 4;
data.numconnections(E5B,I5L,1) = 7;
data.numconnections(E5B,I5L,2) = 2;
data.numconnections(E5B,E4,1) = 1;
data.numconnections(E5B,E2,1) = 3;
data.numconnections(E5B,E2,2) = 36;
data.numconnections(E5B,I2L,1) = 2;

data.numconnections(E5R,E6,1) = 2;
data.numconnections(E5R,E5B,1) = 2;
data.numconnections(E5R,E5B,2) = 5;
data.numconnections(E5R,E5R,1) = 13;
data.numconnections(E5R,E5R,2) = 10;
data.numconnections(E5R,I5,1) = 11;
data.numconnections(E5R,I5,2) = 4;
data.numconnections(E5R,I5L,1) = 7;
data.numconnections(E5R,E4,1) = 1;
data.numconnections(E5R,E2,1) = 4;

data.numconnections(I5,E5B,1) = 8;
data.numconnections(I5,E5R,1) = 29;
data.numconnections(I5,I5,1) = 16;
data.numconnections(I5,I5L,1) = 5;

data.numconnections(I5L,E6,1) = 15;
data.numconnections(I5L,I6,1) = 14;
data.numconnections(I5L,E5B,1) = 6;
data.numconnections(I5L,E5R,1) = 23;
data.numconnections(I5L,I5,1) = 14;
data.numconnections(I5L,I5L,1) = 2;
data.numconnections(I5L,E2,1) = 50;
data.numconnections(I5L,I2,1) = 14;

data.numconnections(E4,E6,1) = 2;
data.numconnections(E4,E5B,1) = 3;
data.numconnections(E4,E5R,1) = 8;
data.numconnections(E4,E4,1) = 8;
data.numconnections(E4,I4,1) = 9;
data.numconnections(E4,I4,2) = 3;
data.numconnections(E4,I4L,1) = 8;
data.numconnections(E4,E2,1) = 21;

data.numconnections(I4,E4,1) = 14;
data.numconnections(I4,I4,1) = 13;
data.numconnections(I4,I4L,1) = 5;

data.numconnections(I4L,E4,1) = 11;
data.numconnections(I4L,I4,1) = 11;
data.numconnections(I4L,I4L,1) = 2;

data.numconnections(E2,E5B,1) = 1;
data.numconnections(E2,E5R,1) = 4;
data.numconnections(E2,E4,1) = 1;
data.numconnections(E2,E2,1) = 27;
data.numconnections(E2,E2,2) = 20;
data.numconnections(E2,E2B,1) = 2;
data.numconnections(E2,I2,1) = 11;
data.numconnections(E2,I2,2) = 4;
data.numconnections(E2,I2L,1) = 7;

data.numconnections(E2B,E5B,1) = 1;
data.numconnections(E2B,E5R,1) = 4;
data.numconnections(E2B,E4,1) = 1;
data.numconnections(E2B,E2,1) = 27;
data.numconnections(E2B,E2B,1) = 2;
data.numconnections(E2B,I2,1) = 11;
data.numconnections(E2B,I2L,1) = 7;

data.numconnections(I2,E2,1) = 63;
data.numconnections(I2,E2B,1) = 4;
data.numconnections(I2,I2,1) = 16;
data.numconnections(I2,I2L,1) = 5;

data.numconnections(I2L,E6,1) = 15;
data.numconnections(I2L,I6,1) = 14;
data.numconnections(I2L,E5B,1) = 9;
data.numconnections(I2L,E5R,1) = 23;
data.numconnections(I2L,I5,1) = 14;
data.numconnections(I2L,E2,1) = 50;
data.numconnections(I2L,E2B,1) = 3;
data.numconnections(I2L,I2,1) = 14;
data.numconnections(I2L,I2L,1) = 2;

data.weightsconnections = zeros(23,23,2);
data.weightsconnections(E6,E6,1) = 0.265;
data.weightsconnections(E6,I6,1) = 0.23;
data.weightsconnections(E6,I6,2) = 1.5;
data.weightsconnections(E6,I6L,1) = 0.115;
data.weightsconnections(E6,E5B,1) = 0.265;
data.weightsconnections(E6,E5R,1) = 0.04;

data.weightsconnections(I6,E6,1) = 1.5;
data.weightsconnections(I6,I6,1) = 0.75;
data.weightsconnections(I6,I6L,1) = 0.75;

data.weightsconnections(I6L,E6,1) = 0.415;
data.weightsconnections(I6L,I6,1) = 0.375;
data.weightsconnections(I6L,I6L,1) = 0.75;
data.weightsconnections(I6L,E5B,1) = 0.415;
data.weightsconnections(I6L,E5R,1) = 0.415;
data.weightsconnections(I6L,I5,1) = 0.2075;
data.weightsconnections(I6L,E2,1) = 0.415;
data.weightsconnections(I6L,I2,1) = 0.2075;

data.weightsconnections(E5B,E6,1) = 0.245;
data.weightsconnections(E5B,E5B,1) = 0.355;
data.weightsconnections(E5B,E5B,2) = 0.235;
data.weightsconnections(E5B,E5R,1) = 0.12;
data.weightsconnections(E5B,E5R,2) = 0.235;
data.weightsconnections(E5B,I5,1) = 0.23;
data.weightsconnections(E5B,I5,2) = 1.5;
data.weightsconnections(E5B,I5L,1) = 0.115;
data.weightsconnections(E5B,I5L,2) = 0.75;
data.weightsconnections(E5B,E4,1) = 0.085;
data.weightsconnections(E5B,E2,1) = 0.13;
data.weightsconnections(E5B,E2,2) = 0.235;
data.weightsconnections(E5B,I2L,1) = 0.75;

data.weightsconnections(E5R,E6,1) = 0.14;
data.weightsconnections(E5R,E5B,1) = 0.44;
data.weightsconnections(E5R,E5B,2) = 0.235;
data.weightsconnections(E5R,E5R,1) = 0.33;
data.weightsconnections(E5R,E5R,2) = 0.235;
data.weightsconnections(E5R,I5,1) = 0.23;
data.weightsconnections(E5R,I5,2) = 1.5;
data.weightsconnections(E5R,I5L,1) = 0.115;
data.weightsconnections(E5R,E4,1) = 0.24;
data.weightsconnections(E5R,E2,1) = 0.335;

data.weightsconnections(I5,E5B,1) = 1.5;
data.weightsconnections(I5,E5R,1) = 1.5;
data.weightsconnections(I5,I5,1) = 0.75;
data.weightsconnections(I5,I5L,1) = 0.75;

data.weightsconnections(I5L,E6,1) = 0.415;
data.weightsconnections(I5L,I6,1) = 0.2075;
data.weightsconnections(I5L,E5B,1) = 0.415;
data.weightsconnections(I5L,E5R,1) = 0.415;
data.weightsconnections(I5L,I5,1) = 0.375;
data.weightsconnections(I5L,I5L,1) = 0.75;
data.weightsconnections(I5L,E2,1) = 0.415;
data.weightsconnections(I5L,I2,1) = 0.2075;

data.weightsconnections(E4,E6,1) = 1.135;
data.weightsconnections(E4,E5B,1) = 0.505;
data.weightsconnections(E4,E5R,1) = 0.27;
data.weightsconnections(E4,E4,1) = 0.475;
data.weightsconnections(E4,I4,1) = 0.23;
data.weightsconnections(E4,I4,2) = 1.5;
data.weightsconnections(E4,I4L,1) = 0.115;
data.weightsconnections(E4,E2,1) = 0.29;

data.weightsconnections(I4,E4,1) = 1.5;
data.weightsconnections(I4,I4,1) = 0.75;
data.weightsconnections(I4,I4L,1) = 0.75;

data.weightsconnections(I4L,E4,1) = 0.415;
data.weightsconnections(I4L,I4,1) = 0.375;
data.weightsconnections(I4L,I4L,1) = 0.75;

data.weightsconnections(E2,E5B,1) = 0.18;
data.weightsconnections(E2,E5R,1) = 0.465;
data.weightsconnections(E2,E4,1) = 0.18;
data.weightsconnections(E2,E2,1) = 0.39;
data.weightsconnections(E2,E2,2) = 0.235;
data.weightsconnections(E2,E2B,1) = 0.39;
data.weightsconnections(E2,I2,1) = 0.23;
data.weightsconnections(E2,I2,2) = 1.5;
data.weightsconnections(E2,I2L,1) = 0.115;

data.weightsconnections(E2B,E5B,1) = 0.18;
data.weightsconnections(E2B,E5R,1) = 0.465;
data.weightsconnections(E2B,E4,1) = 0.18;
data.weightsconnections(E2B,E2,1) = 0.39;
data.weightsconnections(E2B,E2B,1) = 0.39;
data.weightsconnections(E2B,I2,1) = 0.23;
data.weightsconnections(E2B,I2L,1) = 0.115;

data.weightsconnections(I2,E2,1) = 1.5;
data.weightsconnections(I2,E2B,1) = 1.5;
data.weightsconnections(I2,I2,1) = 0.75;
data.weightsconnections(I2,I2L,1) = 0.75;

data.weightsconnections(I2L,E6,1) = 0.415;
data.weightsconnections(I2L,I6,1) = 0.2075;
data.weightsconnections(I2L,E5B,1) = 0.415;
data.weightsconnections(I2L,E5R,1) = 0.415;
data.weightsconnections(I2L,I5,1) = 0.2075;
data.weightsconnections(I2L,E2,1) = 0.415;
data.weightsconnections(I2L,E2B,1) = 0.415;
data.weightsconnections(I2L,I2,1) = 0.375;
data.weightsconnections(I2L,I2L,1) = 0.75;

data.weightsconnections([E6 E5B E5R E4 E2 E2B],:,:) = data.weightsconnections([E6 E5B E5R E4 E2 E2B],:,:) * 1.1;

data.synlocsoma = false(23,1);
data.synlocsoma([I6 I6L I5 I4 I4L I2]) = true;
end

rows = [];
columns = [];
values = [];

for neuron = 1:data.numneurons
    thiscol = data.col(neuron);
    thistype = data.type(neuron);
    
    for typeend = 1:size(data.numconnections,2)
        for coldiff = 1:size(data.numconnections,3)
            if(data.numconnections(thistype,typeend,coldiff) > 0)
                thisweight = data.weightsconnections(thistype,typeend,coldiff);
                tosoma = data.synlocsoma(thistype);
                %find which neurons I connect from thistype,thiscol to
                %typeend of different/same columns
                chosenids = [];
                if(coldiff == 1)
                    colwanted = data.col == thiscol;
                    typewanted = data.type == typeend;
                    wanted = colwanted & typewanted;
                    chosenids = [chosenids; randsample(find(wanted),data.numconnections(thistype,typeend,coldiff))];
                elseif(coldiff == 2)
                    if(thiscol+1 <= data.numcols)
                        colwanted = data.col == thiscol+1;
                        typewanted = data.type == typeend;
                        wanted = colwanted & typewanted;
                        chosenids = [chosenids; randsample(find(wanted),data.numconnections(thistype,typeend,coldiff))];
                    end
                    if(thiscol-1 >= 1)
                        colwanted = data.col == thiscol-1;
                        typewanted = data.type == typeend;
                        wanted = colwanted & typewanted;
                        chosenids = [chosenids; randsample(find(wanted),data.numconnections(thistype,typeend,coldiff))];
                    end
                end
                                
                %Now I have chosenids I want to connect to, add them to the
                %matrix, with weight thisweight and decide whether its to a
                %soma or a dendrite
                
                %convert from neuron to dend/soma/axon format
                if(tosoma)
                    chosenids = chosenids + data.numneurons;
                end
                source = neuron + 2*data.numneurons;
                
                sources = ones(numel(chosenids),1)*source;
                weights = ones(numel(chosenids),1)*thisweight;
                
                rows    = [rows;    chosenids];
                columns = [columns; sources];
                values  = [values;  weights];
                
            end
        end
    end
    
    
end

ConnectionWeightsNEURON = sparse(rows, columns, values, data.numneurons*3, data.numneurons*3);

end