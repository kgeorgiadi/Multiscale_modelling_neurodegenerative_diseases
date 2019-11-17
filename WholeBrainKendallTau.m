function k = WholeBrainKendallTau(a,b)
N = numel(a);
c = (1:N)';
nbad = 0;
for i = 1:N
    for j = i+1:N
        p1 = c(b(i) == a);
        p2 = c(b(j) == a);
        if(p2 < p1)
            nbad = nbad + 1;
        end
    end
end
k = nbad/(N*(N-1)/2);

end