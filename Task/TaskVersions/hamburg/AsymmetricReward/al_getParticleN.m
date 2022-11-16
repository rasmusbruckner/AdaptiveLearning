function [nParticles, outcomeDeviation] = al_getParticleN(nMaxParticles, outcome, distMean, concentration, sign)
% AL_GETPARTICLEN This function determines the number of confetti particles
% in the asymRewardVersion of the confetti-cannon task.
%
%   The number of particles depends on the maximum number of particles,
%   the concentration parameter, the difference between outcome and
%   cannon aim, and the sign of the function, which can change
%   on a changepoint. The exact settings may be updated in the future. 
%
%   Input
%       nMaxParticles: Maximum number of particles
%       outcome: Current outcome
%       distMean: Current aim of the cannon
%       concentration: Concentration parameter
%       sign: Sign of the reward function
%
%   Output
%       nParticles: Computed number of particles
%       outcomeDeviation: Difference between outcome and cannon mean
%

% Concentration expressed as variance (approximation)
GaussStd = rad2deg((1/concentration)^.5);

% Difference between outcome and cannon mean
outcomeDeviation = outcome - distMean;

% Determine ceiling deviation between outcome and cannon (where max or min
% N of particles will be shown)
ceilingDeviation = 2*GaussStd;

% Fraction of max N particles added to "intercept" (half of max N particles)
slope = sign * (outcomeDeviation/ceilingDeviation);

% Compute number of particles
rewardFunction = nMaxParticles/2 + slope * (nMaxParticles/2);
if rewardFunction <= 1
    rewardFunction = 1;
elseif rewardFunction > nMaxParticles
    rewardFunction = nMaxParticles;
end
nParticles = round(rewardFunction);

end