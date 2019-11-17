function DiffusionMatrix = WholeBrainCalculateNEURONDiffusionMatrix(data)
[rows, cols, vals] = find(data.ConnectionWeights);

%add self neuron connection weights
%data.PassiveDiffusionIntraneuronWeight
for neuron = 1:data.numneurons
    extrarows = [neuron+0*data.numneurons;neuron+0*data.numneurons;neuron+1*data.numneurons;neuron+1*data.numneurons;neuron+1*data.numneurons;neuron+2*data.numneurons;neuron+2*data.numneurons];
    extracols = [neuron+0*data.numneurons;neuron+1*data.numneurons;neuron+0*data.numneurons;neuron+1*data.numneurons;neuron+2*data.numneurons;neuron+1*data.numneurons;neuron+2*data.numneurons];
    extravals = data.PassiveDiffusionIntraneuronWeight*ones(size(extracols));

    rows = [rows; extrarows];
    cols = [cols; extracols];
    vals = [vals; extravals];
end

vals2 = vals;
onlyonce = true;
Dendritesonenormcdf = normcdf(-500/2,0,data.PassiveDiffusionSpeed);
Somaonenormcdf = normcdf(-30/2,0,data.PassiveDiffusionSpeed);
Axononenormcdf = normcdf(-200/2,0,data.PassiveDiffusionSpeed);
onenormcdf = [Dendritesonenormcdf; Somaonenormcdf; Axononenormcdf];
data.onenormcdf = onenormcdf(data.dsa);
for element = 1:numel(rows)
    weight = vals(element);
    from = cols(element);
    to = rows(element);
    BaseAreaStart = data.QBaseArea(from);
    BaseAreaEnd = data.QBaseArea(to);
    
    if(from == to)
        vals2(element) = weight*(1-2*data.onenormcdf(from));
    else
        vals2(element) = weight*(min([BaseAreaStart BaseAreaEnd])/BaseAreaStart)*data.onenormcdf(from);
    end
    
    if(vals2(element) <= 0 && onlyonce)
        %fprintf('Diffusion speed is too low!\n');
        onlyonce = false;
    end
end
DiffusionMatrix = sparse(rows, cols, vals2, data.numneurons*3, data.numneurons*3);

%Now need to normalise
for j = 1:size(DiffusionMatrix,2)
    total = sum(DiffusionMatrix(:,j));
    if(total > 0)
        DiffusionMatrix(:,j) = DiffusionMatrix(:,j)/total;
    else
        DiffusionMatrix(:,j) = 0;
        DiffusionMatrix(j,j) = 1;
    end
end

end