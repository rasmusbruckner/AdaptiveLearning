function al_computeExperimentLength(expectedRT, timingParam, nTrials, nBlocks, experiment)
%AL_COMPUTEEXPERIMENTLENGTH This function computes the approximate length of
% an experiment with the cannon task
%
%   Input
%       expectedRT: Expected reaction time
%       timingParam: Timing-paramter-object instance
%       nTrials: Number of trials per block
%       nBlocks: Total number of blocks
%       experiment: Type of experiment
%
%   Output
%       None

% Compute trial length
if isequal(experiment, 'MagdeburgFMRI')

    trialLength = expectedRT + timingParam.fixCrossLength + timingParam.jitterOutcome/2 + timingParam.cannonBallAnimation + timingParam.cannonMissAnimation + timingParam.fixCrossLength + timingParam.jitterITI/2;

elseif isequal(experiment, 'commonConfetti')

    trialLength = expectedRT + timingParam.fixedITI/2 + timingParam.baselineFixLength + timingParam.fixCrossOutcome + ...
        timingParam.jitterFixCrossOutcome/2 + timingParam.outcomeLength + timingParam.jitterOutcome/2 + ...
        timingParam.fixCrossShield + timingParam.jitterFixCrossShield/2 + timingParam.shieldLength + timingParam.jitterShield/2;

end

% Display trial length
t = seconds(trialLength);
t.Format = 'hh:mm:ss.SSS';
fprintf('\nExpected trial length: %s', evalc('disp(t)'))

% Compute block length
blockLength = nTrials * trialLength;

% Display block length
t = seconds(blockLength);
t.Format = 'hh:mm:ss.SSS';
fprintf('Expected block length: %s', evalc('disp(t)'))

% Compute experiment length
experimentLength = blockLength * nBlocks;

% Display experiment length
t = seconds(experimentLength);
t.Format = 'hh:mm:ss.SSS';
fprintf('Expected total length: %s', evalc('disp(t)'))

end