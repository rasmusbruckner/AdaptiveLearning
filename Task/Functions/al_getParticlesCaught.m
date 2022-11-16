function [whichParticlesCaught, nParticlesCaught] = al_getParticlesCaught(dotPredDist, shieldSize)
% AL_GETPARTICLESCAUGHT This function computes which and how many confetti
% particles are caught
%
%   Input
%       dotPredDist: Distances between particles and shield mean
%       shieldSize: Shield size
%
%   Output
%       whichParticlesCaught: Vector indicating particles caught
%       nParticlesCaught: Number of particles caught

% Vector indicating particles caught
whichParticlesCaught = abs(dotPredDist) <= shieldSize/2;

% Number of particles caught
nParticlesCaught = sum(whichParticlesCaught);

end