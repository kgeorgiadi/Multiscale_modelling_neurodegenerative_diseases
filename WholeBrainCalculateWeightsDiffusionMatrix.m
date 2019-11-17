function WeightsDiffusionMatrix = WholeBrainCalculateWeightsDiffusionMatrix(AdjacencyMatrix, EuclideanDistances, Speed, PropInputsAlive)
if(Speed <= 0)
    Speed = 0;
end

WeightsMatrix = abs(AdjacencyMatrix);
for i = 1:size(WeightsMatrix,1)
    WeightsMatrix(i,i) = 0;
end
WeightsSpreadMatrixDivider = max(sum(WeightsMatrix));

%Normalize weights
WeightsMatrix = WeightsMatrix/WeightsSpreadMatrixDivider;

%Remove dead connections
PropInputsAlive = PropInputsAlive*ones(1,size(AdjacencyMatrix,1));
WeightsMatrix = WeightsMatrix.*PropInputsAlive;

%should NOT normalize cause the integral directly gives proportion of
%neurons that end up making the whole trip
DiffusionMatrix = 2*normcdf(-EuclideanDistances/2, 0, Speed);

WeightsDiffusionMatrix = WeightsMatrix .* DiffusionMatrix;
end



