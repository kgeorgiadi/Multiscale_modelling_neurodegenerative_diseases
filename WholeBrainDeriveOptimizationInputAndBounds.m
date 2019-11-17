function [MyInput, LowerBoundInput, UpperBoundInput] = WholeBrainDeriveOptimizationInputAndBounds(MyInput)

LowerBoundInput = zeros(1,numel(MyInput));
UpperBoundInput = ones(1,numel(MyInput));

%if any input value is negative, i.e. deactivate it, don't optimise over
%it.
for i = 1:numel(MyInput)
    if(MyInput(i) < 0)
        LowerBoundInput(i) = MyInput(i);
        UpperBoundInput(i) = MyInput(i);
    end
end

end