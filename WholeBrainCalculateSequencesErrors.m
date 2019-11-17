function [OptimizeMetric, OptimizeMetric2, DistanceSequence, KendalDistanceSequence, DistanceMatrix, MAEs, RMSEs, MAEsk, RMSEsk, MAEm, RMSEm, KendallTau] = WholeBrainCalculateSequencesErrors(Sequence, GroundTruthSequence, GroundTruthMatrix)
DistanceSequence       = zeros(numel(GroundTruthSequence),1);
KendalDistanceSequence = zeros(numel(GroundTruthSequence),1);
DistanceMatrix         = zeros(numel(GroundTruthSequence),1);

temp = GroundTruthMatrix(:);
temp = temp(temp > 0);
temp = min(temp);
%min prob is 1e-5, min logprob is -11.5129
LogMatrix = GroundTruthMatrix;
LogMatrix = log(LogMatrix); 
LogMatrix = [LogMatrix -inf(size(LogMatrix,1),numel(Sequence)-size(LogMatrix,1))];
UpdateMatrix = zeros(size(LogMatrix));
%find what values to replace -inf with
for i = 1:size(LogMatrix,1)
    for j = 1:size(LogMatrix,2)
        if(isinf(LogMatrix(i,j)))
            noninfs = find(~isinf(LogMatrix(i,:)));
            Distance = min(abs(j-noninfs));
            %Distance = abs(j-i);
            UpdateMatrix(i,j) = (size(LogMatrix,1)+1-i) * log(temp/(1000^Distance));
            %log(1e-323) is threshold, constant can be up to 100000
        end
    end
end
%replace -inf with values
for i = 1:size(LogMatrix,1)
    for j = 1:size(LogMatrix,2)
        if(isinf(LogMatrix(i,j)))
            LogMatrix(i,j) = UpdateMatrix(i,j);
        end
    end
end

OptimizeMetric = 0;
OptimizeMetric2 = 0;
for i = 1:numel(GroundTruthSequence)
    currentregion = GroundTruthSequence(i);
    simulationresult = find(Sequence == currentregion);
    DistanceSequence(i) = simulationresult - i;
    
    probabilities = GroundTruthMatrix(i,:);
    for j = 1:numel(probabilities)
        DistanceMatrix(i) = DistanceMatrix(i) + probabilities(j) * abs (j-simulationresult);
    end
    
    OptimizeMetric  = OptimizeMetric  +   abs(LogMatrix(i,simulationresult));
    OptimizeMetric2 = OptimizeMetric2 +   abs(LogMatrix(i,simulationresult))^2;
end

KendallTau  = WholeBrainKendallTau(GroundTruthSequence,Sequence);

for i = 1:numel(GroundTruthSequence)
    currentregion = GroundTruthSequence(i);
    simulationresult = find(Sequence == currentregion);
    KendalDistanceSequence(i) = simulationresult - i;
    Sequence = [Sequence(1:i-1); currentregion; Sequence(i:simulationresult-1); Sequence(simulationresult+1:end)];
end

MAEs = mean(abs(DistanceSequence));
RMSEs = sqrt(mean(DistanceSequence.^2));

MAEsk = mean(abs(KendalDistanceSequence));
RMSEsk = sqrt(mean(KendalDistanceSequence.^2));

MAEm = mean(abs(DistanceMatrix));
RMSEm = sqrt(mean(DistanceMatrix.^2));

end