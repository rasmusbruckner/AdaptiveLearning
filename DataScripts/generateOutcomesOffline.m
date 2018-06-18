% Generation of outcomes for cannon-state extension task
%
% Here we generate outcomes offline to control 
%   1) Number of critical trials
%   2) Distance between critical trials 
%
% We generate 8 block with 50 trials each
% 
% Variables are defined as
%
%
%


close all

% Initialze variables
nt = 400; % number of trials
nb = 8; % number of trials
n_enemies = 2; % number of enemies
n_planets = 2; % number of planets
n_states = n_enemies*n_planets; % number of states
haz = 0.1;
n_changes = (nt/nb)*haz;
max_deg = 360; % maximum outcome
safe = 3; % minimum number of trials before enemy change
block = repelem(1:8,nt/nb); % block indizes

% Sample Means for enemy x planet x block
mu = randi(max_deg,n_enemies, n_planets,nb);

% Sample planets. Here we have the same frequency for each planet
planet_vec = [ones(1, nt/2), repmat(2,1,nt/2)]; %binornd(1,0.5,400,1)+ 1;
planet_vec = planet_vec(randperm(length(planet_vec)));

% Sample number and timing of changes. Here we keep the number of enemy
% changes constant
while true 
    change_vec = [ones(1,n_changes), zeros(1,(nt/nb)-n_changes)];
    change_vec = change_vec(randperm(length(change_vec)));
    
    x = diff(find(change_vec));
    if ~ismember(x, 1:safe)
        break
    end
end
current_mu = nan(nt,1);
enemy_vec = binornd(1,0.5) + 1; %nan;

for i = 2:length(change_vec)
    
    if change_vec(i) == 1 
        enemy_vec(i) = 3 - enemy_vec(i-1);
    else
        enemy_vec(i) = enemy_vec(i-1);

    end
    current_mu(i) = mu(planet_vec(i), enemy_vec(i)); 
    
end

outcome = normrnd(current_mu, 25);

figure
subplot(3,1,1)
plot(planet_vec(1:50), 'o')
subplot(3,1,2)
plot(enemy_vec, 'o')
subplot(3,1,3)
hold on
plot(current_mu)
plot(outcome, '.')

% critical trial

% current mean

% current outcome


    