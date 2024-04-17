function dotSize = al_confettiSize(nParticles)
%AL_CONFETTISIZE This function samples the confetti size
%
%   Input
%       nParticles: Number of confetti particles
%
%   Output
%       dotSize: Sampled particle size

dotSize = (1+rand(1, nParticles))*3;

end