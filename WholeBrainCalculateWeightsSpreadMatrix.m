function WeightsSpreadMatrix = WholeBrainCalculateWeightsSpreadMatrix(AdjacencyMatrix, PropInputsAlive)
WeightsSpreadMatrix = abs(AdjacencyMatrix);
for i = 1:size(WeightsSpreadMatrix,1)
    WeightsSpreadMatrix(i,i) = 0;
end
WeightsSpreadMatrixDivider = max(sum(WeightsSpreadMatrix));

%Normalize weights
WeightsSpreadMatrix = WeightsSpreadMatrix/WeightsSpreadMatrixDivider;

%Remove dead connections
PropInputsAlive = PropInputsAlive*ones(1,size(AdjacencyMatrix,1));
WeightsSpreadMatrix = WeightsSpreadMatrix.*PropInputsAlive;

end
