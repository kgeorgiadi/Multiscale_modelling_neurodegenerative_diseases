function ExtracellularDiffusionMatrix = WholeBrainCalculateExtracellularDiffusionMatrix(Speed, RegionsAlive, RegionsEuclideanDistances, RegionsRadii)
if(Speed <= 0)
    Speed = 0;
end
NumNodes = numel(RegionsRadii);

%Calculate the integral from j to i
RegionsRadii = RegionsRadii*ones(1,NumNodes);
MinDistance = RegionsEuclideanDistances - RegionsRadii;
MaxDistance = RegionsEuclideanDistances + RegionsRadii;
ExtracellularDiffusionMatrix = abs(normcdf(MaxDistance,0,Speed) -  normcdf(MinDistance,0,Speed));



for j = 1:size(ExtracellularDiffusionMatrix,2)
    for i = 1:size(ExtracellularDiffusionMatrix,1)
        %However if the node is dead, there should be 0 integral
        if(RegionsAlive(i) == false || RegionsAlive(j) == false)
            if(i~=j)
                ExtracellularDiffusionMatrix(i,j) = 0;
            end
        end
        
    end
    
    %Now we have calculated an entire column integrals. We should normalize
    %it to one
    CurrentSum = sum(sort(ExtracellularDiffusionMatrix(:,j))); %We sort it first for numerical stability - this allows the addition of many small numbers to be taken into account
    if(CurrentSum > 0)
        ExtracellularDiffusionMatrix(:,j) = ExtracellularDiffusionMatrix(:,j)/CurrentSum;
    else
        ExtracellularDiffusionMatrix(j,j) = 1;
    end
end

end