function SynapticTransferMatrix = WholeBrainCalculateNEURONSynapticTransferMatrix(data)
SynapticTransferMatrix = data.ConnectionWeights;

%Now need to normalise
for j = 1:size(SynapticTransferMatrix,2)
    total = sum(SynapticTransferMatrix(:,j));
    if(total > 0)
        SynapticTransferMatrix(:,j) = SynapticTransferMatrix(:,j)/total;
    else
        SynapticTransferMatrix(:,j) = 0;
        SynapticTransferMatrix(j,j) = 1;
    end
end

end