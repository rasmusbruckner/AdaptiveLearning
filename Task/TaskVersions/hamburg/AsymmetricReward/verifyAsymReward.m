% This script plots the reward function of the asymmetric reward version
% of the confetti-cannon task

% Maximum number of particles
nMaxParticles = 80;

% Current outcome
outcome = linspace(-60,60,101);

% Current aim of the cannon
distMean = 0;

% Concentration parameter
concentration = 16;

% Sign of the reward function
sign = -1;

% Initialize variables
nParticles = nan(length(outcome), 1);
cannonDev = nan(length(outcome), 1);
z = nan(length(outcome), 1);

% Cycle over outcomes 
for i = 1:100
    [nParticles(i), cannonDev(i)] = al_getParticleN(nMaxParticles, outcome(i), distMean, concentration, sign);
end

% Plot reward function
figure
plot(cannonDev, nParticles)
yline(nMaxParticles/2)
xline(0)
xlabel('Difference between outcome and cannon mean')
ylabel('Number of confetti particles')
cannonDev(51)
nParticles(51)