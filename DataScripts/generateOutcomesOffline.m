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
% nt:           Number of trials
% nb:           Number of blocks
% n_enemies:    Number of enemies
% n_planets:    Number of plantes
% n_states:     Number of states
% haz:          Hazard rate
% n_changes:    Number of changes
% max_deg:      Maximum outcome
% safe:         minimum number of trials before enemy change
% block:        Current block for all trials
% mu:           Means for enemy x planet x block
% planet_vec:   Current planet for all trials
% change_vec:   Timing of changes
% enemy_vec:    Current enemy for all trials
% current_mu:   Current mu for all trials
% outcome:      Current outcome for all trials

% TODO: RENAME
function a = generateOutcomesOffline()

% Initialze variables
nt = 400; % number of trials
nb = 8; % number of blocks
n_enemies = 2; % number of enemies
n_planets = 2; % number of planets
n_states = n_enemies*n_planets; % number of states
haz = 0.1; % hazard rate
n_changes = (nt/nb)*haz; % number of changes
max_deg = 360; % maximum outcome
safe = 3; % minimum number of trials before enemy change
block = repelem(1:8,nt/nb); % block indizes
concentration = 10;
minASS = 10;
maxASS = 180;
ass_mu = 15;
crit_dist = 45; % Critical distance between means. Controls the overlap between states to avoid very similar enemies.

% Sample Means for enemy x planet x block
% ---------------------------------------
mu = randi(max_deg,n_enemies, n_planets,nb);

while 1
    x = abs(al_diff(mu(1,:,:), mu(2,:,:)));
    if any(any(x<crit_dist))
        mu = randi(max_deg,n_enemies, n_planets,nb);
    else
        break
    end
end

% Sample planets. Here we have the same frequency for each planet
% ---------------------------------------------------------------
planet_vec = [ones(1, nt/2), repmat(2,1,nt/2)];
planet_vec = planet_vec(randperm(length(planet_vec)));

% Iniitialiize vector for current mu
current_mu = nan(nt/nb,1)';

% Initialize here!
all_changes = [];
all_mu = [];
all_enemies = [];

% Sample number and timing of changes. Here we keep the number of enemy
% changes constant

% Cycle over blocks
% -----------------
for b = 1:nb
    while true
        % Determine "change points" where enemy changes
        change_vec = [ones(1,n_changes), zeros(1,(nt/nb)-n_changes-safe*2)];
        change_vec = change_vec(randperm(length(change_vec)));
        
        x = diff(find(change_vec));
        if ~ismember(x, 1:safe)
            break
        end 
    end
    
    % Make sure that first 3 and last 3 trials are no change points
    change_final = [zeros(safe, 1)', change_vec, zeros(safe, 1)'];
    
    % Generate enemy vector and determine current mu
    % Randomly generate the fist "active" enemy
    enemy_vec = binornd(1, 0.5) + 1;
    current_mu(1) = mu(enemy_vec(1), planet_vec(1));
    
    % Cycle through change vector and determine current enemy and conditional on this the current mean
    for i = 2:length(change_final)
        
        if change_final(i) == 1
            enemy_vec(i) = 3 - enemy_vec(i-1);
        else
            enemy_vec(i) = enemy_vec(i-1);
            
        end
        current_mu(i) = mu(enemy_vec(i), planet_vec(i), b);
        
    end
    
    % TODO: Initialize!
    all_changes = horzcat(all_changes, change_vec);
    all_mu = horzcat(all_mu, current_mu);
    all_enemies = horzcat(all_enemies, enemy_vec);
    
end

% Sample actual outcomes
% ----------------------

% Cycle over trials
for i = 1:nt
    
    % TODO: INITIALIZE!
    outcome(i) = round(180 + rad2deg(circ_vmrnd(deg2rad(all_mu(i) - 180), concentration, 1)));
    
    ASS=nan;
    while ~isfinite(ASS) || ASS<minASS || ASS>maxASS
        ASS = exprnd(ass_mu);
    end
    
    % TODO: INITIALIZE! and rename!
    allASS(i) = ASS;
end

a = struct('block', block, 'all_changes', all_changes, 'all_mu', all_mu, 'enemy_vec', all_enemies, 'haz', haz, 'max_deg', max_deg, 'mu', mu,...
    'n_changes', n_changes, 'n_enemies', n_enemies, 'n_planets', n_planets, 'n_states', n_states, 'nb', nb, 'nt', nt, 'outcome', outcome,...
    'planet_vec', planet_vec, 'allASS', allASS, 'i', i);


