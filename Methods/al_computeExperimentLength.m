function al_computeExperimentLength(expectedRT, timingParam, nTrials, nBlocks)
%AL_COMPUTEEXPERIMENTLENGTH This function computes the approximate length of
%an experiment with the cannon task
%
%   Input
%       expectedRT: Expected reaction time
%       timingParam: Timing-paramter-object instance
%       nTrials: Number of trials per block
%       nBlocks: Total number of blocks
%
%   Output
%       None

% Compute trial length
% Currently, this is only used for MagdeburgFMRI (but will be adjusted in near future)
trialLength = expectedRT + timingParam.fixCrossLength + timingParam.jitterOutcome/2 + timingParam.cannonBallAnimation + timingParam.cannonMissAnimation + timingParam.fixCrossLength + timingParam.jitterITI/2;

% Compute block length
blockLength = nTrials * trialLength;

% Display block length
t = seconds(blockLength);
t.Format = 'hh:mm:ss.SSS';
fprintf('\nExpected block length: %s', evalc('disp(t)'))

% Compute experiment length
experimentLength = blockLength * nBlocks;

% Display experiment length
t = seconds(experimentLength);
t.Format = 'hh:mm:ss.SSS';
fprintf('Expected total length: %s', evalc('disp(t)'))

end