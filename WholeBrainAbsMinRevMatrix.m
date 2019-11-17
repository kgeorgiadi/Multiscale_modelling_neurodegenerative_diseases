function [valuesToSeeds, valuesToSeedsAbs, valuesToSeedsMin, valuesToSeedsAbsMin, valuesToSeedsAbsRevMin ] = WholeBrainAbsMinRevMatrix(Network, Matrix, Seed)
DijkstraAll       = zeros(Network.NumNodes);
DijkstraAllAbs    = zeros(Network.NumNodes);
DijkstraAllAbsRev = zeros(Network.NumNodes);

for i = 1:Network.NumNodes
    DistanceVector         = DijkstraCell(AdjacencyToCell(Matrix), i);
    DijkstraAll(i,:)       = DistanceVector';
    DistanceVector         = DijkstraCell(AdjacencyToCell(abs(Matrix)), i);
    DijkstraAllAbs(i,:)    = DistanceVector';
    DistanceVector         = DijkstraCell(AdjacencyToCell(max(abs(Matrix(:)))-abs(Matrix)), i);
    DijkstraAllAbsRev(i,:) = DistanceVector';
end

valuesToSeeds          = Matrix(Seed,:)';
valuesToSeedsAbs       = abs(Matrix(Seed,:))';
valuesToSeedsMin       = DijkstraAll(Seed,:)';
valuesToSeedsAbsMin    = DijkstraAllAbs(Seed,:)';
valuesToSeedsAbsRevMin = DijkstraAllAbsRev(Seed,:)';
end