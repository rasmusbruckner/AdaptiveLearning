function nGreenParticles = al_getParticleColor(nParticles, cannonDev, concentration, sign)
% AL_GETPARTICLECOLOR This function determines the colors (red vs. green) of confetti particles
% in the asymRewardVersion of the confetti-cannon task.
%
%   The ratio between red and green depends on the difference between
%   outcome and cannon aim, the concentration parameter, and the sign
%   of the function, which can change on a changepoint.
%   
%   The exact settings may be updated in the future.We currently use a
%   Gaussian CDF.
%
%   Input
%       nParticles: Number of particles
%       cannonDev: Difference cannon aim and outcome
%       concentration: Concentration parameter
%       sign: Sign of the reward function
%
%   Output
%       nGreenParticles: Number of green particles
%

% Concentration expressed as variance (approximation)
GaussStd = rad2deg((1/concentration)^.5);

% Proportion of green particles
p = normcdf(sign*cannonDev,0,GaussStd);

% Translate into number of green particles
nGreenParticles = round(p * nParticles);

end