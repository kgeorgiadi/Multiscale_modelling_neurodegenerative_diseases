function DTIs = WholeBrainDTIprocessing(dti_path, ImageNumbers, Mapping, Symmetry, SmallConnectionsEmphasized, WhichDisease)

controliter = 0;
for Control_i = ImageNumbers
    controliter = controliter + 1;
    TextNumber = num2str(Control_i);
    for j = numel(TextNumber)+1:3
        TextNumber = ['0' TextNumber];
    end
    
    if(SmallConnectionsEmphasized)
        dtifile  = [dti_path '01-' TextNumber '-01-01-MR01/' '01-' TextNumber '_connectome_5M.csv'];
    else
        dtifile  = [dti_path '01-' TextNumber '-01-01-MR01/' '01-' TextNumber '_connectome_10M.csv'];
    end
    DTI = WholeBrainLoadDTIData(dtifile);
    DTI = DTI + DTI';
    for i = 1:size(DTI,1)
        DTI(i,i) = DTI(i,i)/2;
    end
    
    mappingfile = [dti_path 'mapping.txt'];
    DTImapping = load(mappingfile);
    
    %Reorder matrix
    [DTIMapping, SortingIndices] = sort(DTImapping);
    DTI = DTI(SortingIndices, SortingIndices);
    
    
    LargeToSmallMapping = cell(1,1);
    LargeToSmallMapping{36} = [105 147 137 179];
    LargeToSmallMapping{37} = [106 148 138 180];
    LargeToSmallMapping{38} = [191 143 163 165 205];
    LargeToSmallMapping{39} = [192 144 164 166 206];
    LargeToSmallMapping{40} = [125 141 187 153];
    LargeToSmallMapping{41} = [126 142 188 154];
    LargeToSmallMapping{42} = [183 151 193];
    LargeToSmallMapping{43} = [184 152 194];
    LargeToSmallMapping{44} = [119 113];
    LargeToSmallMapping{45} = [120 114];
    LargeToSmallMapping{46} = [121];
    LargeToSmallMapping{47} = [122];
    LargeToSmallMapping{48} = [117 123 171];
    LargeToSmallMapping{49} = [118 124 172];
    LargeToSmallMapping{50} = [133 155 201];
    LargeToSmallMapping{51} = [134 156 202];
    LargeToSmallMapping{52} = [203];
    LargeToSmallMapping{53} = [204];
    LargeToSmallMapping{54} = [181 185 207];
    LargeToSmallMapping{55} = [182 186 208];
    LargeToSmallMapping{56} = [169];
    LargeToSmallMapping{57} = [170];
    LargeToSmallMapping{58} = [175 195 199 107];
    LargeToSmallMapping{59} = [176 196 200 108];
    LargeToSmallMapping{60} = [177 149];
    LargeToSmallMapping{61} = [178 150];
    LargeToSmallMapping{62} = [115 109 135 161];
    LargeToSmallMapping{63} = [116 110 136 162];
    LargeToSmallMapping{64} = [197 129 145 157];
    LargeToSmallMapping{65} = [198 130 146 158];
    LargeToSmallMapping{66} = [101];
    LargeToSmallMapping{67} = [102];
    LargeToSmallMapping{68} = [139];
    LargeToSmallMapping{69} = [140];
    LargeToSmallMapping{70} = [167];
    LargeToSmallMapping{71} = [168];
    LargeToSmallMapping{72} = [103];
    LargeToSmallMapping{73} = [104];
    LargeToSmallMapping{74} = [173];
    LargeToSmallMapping{75} = [174];
    for i = 1:35
        LargeToSmallMapping{i} = Mapping(i);
    end
    
    DTItemp = zeros(208);
    for i = 1:size(DTI,1)
        for j = 1:size(DTI,2)
            from = DTIMapping(i);
            to = DTIMapping(j);
            if(to >= from)
                DTItemp(from,to) = DTI(i,j);
            end
        end
    end
    
    DTIfinal = zeros(numel(LargeToSmallMapping));
    for i = 1:size(DTIfinal,1)
        for j = i:size(DTIfinal,2)
            from = LargeToSmallMapping{i};
            to = LargeToSmallMapping{j};
            total = 0;
            for ii = 1:numel(from)
                if(i == j)
                    for jj = ii:numel(to)
                        index1 = from(ii);
                        index2 = to(jj);
                        if(index1 < index2)
                            total = total + DTItemp(index1,index2);
                        else
                            total = total + DTItemp(index2,index1);
                        end
                    end
                else
                    for jj = 1:numel(to)
                        index1 = from(ii);
                        index2 = to(jj);
                        if(index1 < index2)
                            total = total + DTItemp(index1,index2);
                        else
                            total = total + DTItemp(index2,index1);
                        end
                    end
                end
            end
            DTIfinal(i,j) = total;
            DTIfinal(j,i) = total;
        end
    end
    DTI = DTIfinal;
    
    
    %Make it symmetric
    DTItemp = DTI;
    for i = 1:size(DTI,1)
        for j = 1:size(DTI,2)
            regi = Mapping(i);
            regj = Mapping(j);
            regiindex = i;
            regjindex = j;
            symi = Symmetry(i);
            symj = Symmetry(j);
            if(symi > 0)
                symiindex = find(Mapping == symi);
            end
            if(symj > 0)
                symjindex = find(Mapping == symj);
            end
            
            if(i == j)
                if(symi > 0)
                    DTI(i,j) = (DTItemp(i,j) + DTItemp(symiindex,symjindex))/2;
                else
                    DTI(i,j) = DTItemp(i,j);
                end
            else
                if(symi == regj)
                    DTI(i,j) = DTItemp(i,j);
                else
                    if(symi > 0 && symj > 0)
                        DTI(i,j) = (DTItemp(i,j) + DTItemp(symiindex,symjindex))/2;
                    elseif(symi > 0 && symj == 0)
                        DTI(i,j) = (DTItemp(i,j) + DTItemp(symiindex,j))/2;
                    elseif(symi == 0 && symj > 0)
                        DTI(i,j) = (DTItemp(i,j) + DTItemp(i,symjindex))/2;
                    elseif(symi == 0 && symj == 0)
                        DTI(i,j) = DTItemp(i,j);
                    end
                end
            end
        end
    end
    DTIs{controliter} = DTI;
end
end







