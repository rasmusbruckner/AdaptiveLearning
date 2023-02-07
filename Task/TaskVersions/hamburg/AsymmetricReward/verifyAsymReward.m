% This script plots the reward function of the asymmetric reward version
% of the confetti-cannon task

% Avearge number of particles
nParticles = 40;

% Current outcome
outcome = linspace(-60,60,101);

% Current aim of the cannon
distMean = 0;

% Concentration parameter
concentration = 12;

% Sign of the reward function
sign = 1;

% Initialize variables
nGreenParticles = nan(length(outcome), 1);
cannonDev = nan(length(outcome), 1);
z = nan(length(outcome), 1);

% Cycle over outcomes 
for i = 1:100
    cannonDev(i) = outcome(i) - distMean;
    nGreenParticles(i) = al_getParticleColor(nParticles, cannonDev(i), concentration, sign);
end

% Plot reward function
figure
plot(cannonDev, nGreenParticles)
yline(nParticles)
xline(0)
xlabel('Difference between outcome and cannon mean')
ylabel('Number of green particles')
cannonDev(51)
nGreenParticles(51)