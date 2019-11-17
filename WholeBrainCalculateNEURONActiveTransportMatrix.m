function ActiveTransportMatrix = WholeBrainCalculateNEURONActiveTransportMatrix(data)
rows = zeros(7*data.numneurons,1);
cols = zeros(7*data.numneurons,1);
vals = zeros(7*data.numneurons,1);

data.ActiveTransportRetrogradeWeight   = 0.1161;
data.ActiveTransportStoppedWeight      = 0.73;
data.ActiveTransportAnterogradeWeight  = 0.1539;

dtod = data.ActiveTransportStoppedWeight/(data.ActiveTransportStoppedWeight+data.ActiveTransportAnterogradeWeight);
dtos = data.ActiveTransportAnterogradeWeight/(data.ActiveTransportStoppedWeight+data.ActiveTransportAnterogradeWeight);
stod = data.ActiveTransportRetrogradeWeight;
stos = data.ActiveTransportStoppedWeight;
stoa = data.ActiveTransportAnterogradeWeight;
atos = data.ActiveTransportRetrogradeWeight/(data.ActiveTransportStoppedWeight+data.ActiveTransportRetrogradeWeight);
atoa = data.ActiveTransportStoppedWeight/(data.ActiveTransportStoppedWeight+data.ActiveTransportRetrogradeWeight);


for neuron = 1:data.numneurons
    rows(7*(neuron-1)+1) = neuron;
    cols(7*(neuron-1)+1) = neuron;
    vals(7*(neuron-1)+1) = dtod;
    rows(7*(neuron-1)+2) = neuron+data.numneurons;
    cols(7*(neuron-1)+2) = neuron;
    vals(7*(neuron-1)+2) = dtos;
    
    rows(7*(neuron-1)+3) = neuron;
    cols(7*(neuron-1)+3) = neuron+data.numneurons;
    vals(7*(neuron-1)+3) = stod;
    rows(7*(neuron-1)+4) = neuron+data.numneurons;
    cols(7*(neuron-1)+4) = neuron+data.numneurons;
    vals(7*(neuron-1)+4) = stos;
    rows(7*(neuron-1)+5) = neuron+2*data.numneurons;
    cols(7*(neuron-1)+5) = neuron+data.numneurons;
    vals(7*(neuron-1)+5) = stoa;
    
    rows(7*(neuron-1)+6) = neuron+data.numneurons;
    cols(7*(neuron-1)+6) = neuron+2*data.numneurons;
    vals(7*(neuron-1)+6) = atos;
    rows(7*(neuron-1)+7) = neuron+2*data.numneurons;
    cols(7*(neuron-1)+7) = neuron+2*data.numneurons;
    vals(7*(neuron-1)+7) = atoa;

end

ActiveTransportMatrix = sparse(rows, cols, vals, data.numneurons*3, data.numneurons*3);
end