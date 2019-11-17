function Convergence = WholeBrainComputeConvergence(EventSequenceA, EventSequenceB, Convergence_Threshold)
NumEvents = numel(EventSequenceA);
ConvergenceVector = zeros(NumEvents,1);

A1 = false(max([EventSequenceA;EventSequenceB]),1);
A2 = false(max([EventSequenceA;EventSequenceB]),1);
NumCommonEvents = 0;
for EventTime = 1:NumEvents
    A1(EventSequenceA(EventTime)) = true;
    NumCommonEvents = NumCommonEvents + A2(EventSequenceA(EventTime));
    A2(EventSequenceB(EventTime)) = true;
    NumCommonEvents = NumCommonEvents + A1(EventSequenceB(EventTime));
    ConvergenceVector(EventTime,1) = NumCommonEvents/EventTime;
end
%Min is best
Convergence = 1/NumEvents;
for EventTime = NumEvents:-1:1
    if(ConvergenceVector(EventTime) < Convergence_Threshold)
        Convergence = (EventTime+1)/NumEvents;
        break;
    end
end

end