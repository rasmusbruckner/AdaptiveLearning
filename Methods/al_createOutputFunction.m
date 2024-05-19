function getNextOutput = al_createOutputFunction(specificOutputs)
%AL_CREATEOUTPUTFUNCTION This function is a utility function to get
% different random numbers when mocking out sampleRand function for testing
%
% It is sub-optimal that callCount spans nested functions, but didn't
% manage differently. When I tried with object-oriented approach, it was
% not compatible with Invoke methods.
% 
% But this way, only spanning functions here, not in test case.

callCount = 0; % indicates how many times func was called (critical part)
getNextOutput = @() nextOutput();

    function output = nextOutput(varargin)
        callCount = callCount + 1; % increase counter
        if callCount <= length(specificOutputs)
            output = specificOutputs(callCount);
        else
            output = []; % default or error value if calls exceed specified outputs
        end
    end
end