function taskData = al_generateOutcomes(taskParam, haz, concentration, condition)
%AL_GENERATEOUTCOMES   This function generates the outcomes for the different tasks
%
%   TODO: The organization of this function can be improved. At some point,
%   it should be reorganized in order to have similar way to generate outcomes
%   for all task versions.
%
%   Input
%       taskParam: structure containing task parameters
%       haz: hazard rate parameter
%       concentration: concentration parameter
%       condition: task condition
%
%   Output
%       taskData: structure containing generated outcomes


% Select task- and block-specific number of trials
% ------------------------------------------------

if isequal(condition, 'main') || isequal(condition, 'oddball') || isequal(condition, 'reversal') || isequal(condition, 'chinese')
    
    % Take specified number of trials from AdaptiveLearning script
    trials = taskParam.gParam.trials;
elseif isequal(condition, 'mainPractice') || isequal(condition, 'practiceNoOddball') || isequal(condition, 'oddballPractice')...
        || isequal(condition, 'followOutcomePractice') || isequal(condition, 'followCannonPractice') || isequal(condition, 'reversalPractice')...
        || isequal(condition, 'reversalPracticeNoise') || isequal(condition, 'reversalPracticeNoiseInv2') || isequal(condition, 'chinesePractice_1')...
        || isequal(condition, 'chinesePractice_2')
    
    % Take specified number of practice trials from AdaptiveLearning script
    trials = taskParam.gParam.practTrials;
    
    % Take condition-specific number of trials from AdaptiveLearning script
elseif isequal(condition, 'shield')
    trials = taskParam.gParam.shieldTrials;
elseif isequal(condition, 'followCannon') || isequal(condition, 'followOutcome') || isequal(condition, 'ARC_controlSpeed') || isequal(condition, 'ARC_controlAccuracy')
    trials = taskParam.gParam.controlTrials;
elseif isequal(condition, 'ARC_controlPractice')
    trials = taskParam.gParam.controlTrials/4;
elseif isequal(condition, 'reversalPracticeNoiseInv')
    trials = 4;
elseif isequal(condition, 'reversalPracticeNoiseInv3')
    trials = taskParam.gParam.practTrials * 2;
elseif isequal(condition, 'chinesePractice_4') || isequal(condition, 'chinesePractice_3')
    trials = taskParam.gParam.chinesePractTrials;
end

% XX
%contextTypes = 0;

% Initialize variables
% --------------------

fieldNames = taskParam.fieldNames; % structure that contains the names of the variables
ID = cell(trials, 1); % participant ID
age = zeros(trials, 1); % participant age
sex = cell(trials, 1); % participant sex
rew = nan(trials, 1); % current reward
actRew = nan(trials, 1); % actual reward?? improve description
Date = cell(trials, 1); % date
cond = cell(trials, 1); % current condition
outcome = nan(trials, 1); % current outcome
distMean = nan(trials, 1); % current mean of the distribution
reversal = zeros(trials, 1); % reversal trial in "reversal" condition
TAC = nan(trials, 1); % trials after change point
oddBall = zeros(trials, 1); % oddball trial in "oddball" condition
catchTrial = zeros(trials, 1); % catch trials
triggers = zeros(trials, 7); % triggers
pred = zeros(trials, 1); % current prediction
predErr = nan(trials, 1); % current prediction error
memErr = zeros(trials, 1); % current memory error
UP = zeros(trials, 1); % current update
hit = zeros(trials, 1); % current hit
cBal = nan(trials, 1); % current counterbalancing condition
perf = zeros(trials, 1); % current performance
accPerf = zeros(trials, 1); % accumulated performance
timestampOnset = nan(trials, 1); % timestamp trial onset
timestampPrediction = nan(trials, 1); % timestamp prediction
timestampOffset = nan(trials, 1); % timestamp trial offset
initiationRT = nan(trials, 1); % initiation reaction time
RT = nan(trials, 1); % reaction time
initialTendency = nan(trials, 1); % initial prediction tendency (when mouse is used for prediction)
block = nan(trials, 1); % current block
actJitter = nan(trials, 1); % current jitter
allASS = zeros(trials, 1); % all angular shield size
currentContext = nan(trials, 1); % current context
hiddenContext = nan(trials, 1); % hiddent context
latentState = nan(trials, 1); % latent state
TAC_Context = nan(trials, 1); % trials since last context change
TAC_State = nan(trials, 1); % trials since last state change
savedTickmark = nan(trials, 1); % saved tickmark for reversal condition
savedTickmarkPrevious = nan(trials, 1); % previously saved tickmark
sContext = nan; % "safe" for context changes
sState = nan; % "safe" for state changes
mu = 15; % mean of shield
minASS = 10; % minimum angular shield size
maxASS = 180; % maximium angular shiled size
nPlanets = taskParam.gParam.nPlanets; % number of contexts
cp = zeros(trials, nPlanets); % current change point
nEnemies = taskParam.gParam.nEnemies; % number of states
planetHaz = taskParam.gParam.planetHaz; % context hazard rate
enemyHaz = taskParam.gParam.enemyHaz; % state hazard rate
safePlanet = taskParam.gParam.safePlanet; % "safe" for context
safeEnemy = taskParam.gParam.safeEnemy; % "safe" for state
critical_trial = nan;

% Safe for all other conditions except chinese condition
if isequal(condition,'shield') || isequal(condition,'ARC_controlSpeed') || isequal(condition,'ARC_controlAccuracy') || isequal(condition,'ARC_controlPractice')
    s = taskParam.gParam.safe(2);
else
    s = taskParam.gParam.safe(1);
end

% Generate outcomes for CP condition
% ----------------------------------

if isequal(condition, 'main') || isequal(condition, 'followOutcome') || isequal(condition, 'mainPractice') || isequal(condition, 'followCannon') ||...
        isequal(condition, 'shield') || isequal(condition, 'ARC_controlSpeed') || isequal(condition, 'ARC_controlAccuracy') || isequal(condition, 'ARC_controlPractice') ||...
        isequal(condition, 'followOutcomePractice') || isequal(condition, 'followCannonPractice')
    
    for i = 1:trials
        
        % Is it actually necessary to indiate context in this condition?
        % Maybe simply set to nan
        currentContext(i) = 1;
        
        block(i) = al_indicateBlock(i, taskParam.gParam.blockIndices);
        
        % Generate change points
        if (rand < haz && s == 0) || i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) || i == taskParam.gParam.blockIndices(3) || i == taskParam.gParam.blockIndices(4)
            
            % Indicate current change point
            cp(i) = 1;
            
            % Draw mean of current distribution
            mean = round(rand(1).*359);
            
            % Take into account that in some conditions change points can only occur after a few trials
            if isequal(condition,'shield') || isequal(condition, 'ARC_controlSpeed') || isequal(condition, 'ARC_controlAccuracy') || isequal(condition, 'ARC_controlPractice')
                s = taskParam.gParam.safe(2);
            else
                s = taskParam.gParam.safe(1);
            end
            
            % Reset trials after change point
            TAC(i) = 0;
        else
            
            % Increase trials after change point
            TAC(i) = TAC(i-1) + 1;
            
            % Update "safe criterion"
            s = max([s-1, 0]);
        end
        
        % Draw outcome
        outcome(i) = al_sampleOutcome(mean, concentration);
        
        % Save actual mean
        distMean(i) = mean;
        
        % Indicate that this condition does not contain any oddballs
        oddBall(i) = nan;
        
        % Generate catch trials
        if taskParam.gParam.useCatchTrials
            if isequal('condition', 'onlinePractice')
                if rand <= .2 && cp(i) == 0
                    catchTrial(i:i+2) = 1;
                else
                    catchTrial(i:i+2) = 0;
                end
            else
                catchTrial(i) = al_generateCatchTrial(cp(i));
            end
        end
        
        % Generate angular shield size
        allASS(i) = al_getShieldSize(minASS, maxASS, mu);
        
        % Set latent state to 0, as it is not used in change point task or shield practice
        latentState(i) = 0;
    end
    
    % Generate outcomes for Oddball condition
    % ---------------------------------------
    
elseif isequal(condition, 'oddball') || isequal(condition, 'practiceNoOddball') || isequal(condition, 'practiceOddball')
    
    oddBall = false(trials,1);
    
    % Extract drift of cannon
    if isequal(condition, 'shield')
        driftConc = taskParam.gParam.driftConc(2);
    else
        driftConc = taskParam.gParam.driftConc(1);
    end
    
    % Initialize safe
    s = 0;
    mu = 10;
    
    for i = 1:trials
        
        % Indicate current task block
        block(i) = al_indicateBlock(i, taskParam.gParam.blockIndices);
        
        % Generate drift for oddball condition
        if i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1 || i == taskParam.gParam.blockIndices(4) + 1
            muRad_offset = unifrnd(-pi, pi);
        else
            muRad_offset = deg2rad(distMean(i-1)-180) + circ_vmrnd(0, driftConc, 1);
        end
        muRad_offset = circ_dist(muRad_offset, 0);
        distMean(i) = rad2deg(muRad_offset) + 180;
        
        % Extract probability for oddball trials
        if isequal(condition, 'practiceNoOddball') || isequal(condition, 'shield')
            oddballProb = taskParam.gParam.oddballProb(2);
        elseif isequal(condition, 'practiceOddball') || isequal(condition, 'practice') || isequal(condition, 'main') || isequal(condition, 'oddball')
            oddballProb = taskParam.gParam.oddballProb(1);
        end
        
        % Generate oddballs and non-oddballs
        if rand < oddballProb && s == 0
            outcome(i) = round(rand.*359);
            oddBall(i) = true;
            TAC(i) = 0;
            s = taskParam.gParam.safe(1);
        else
            if i == 1
                TAC(i) = nan;
            else
                TAC(i) = TAC(i-1)+1;
            end
            
            % Sample outcome
            outcome(i) = al_sampleOutcome(distMean(i), concentration);
            
            % Update "safe"
            s = max([s - 1, 0]);
        end
        
        % Generate angular shield size
        allASS(i) = al_getShieldSize(minASS, maxASS, mu);
        allASS(i) = allASS(i)*2;
        
        % Indicate that we're not dealing with change points in this condition
        cp(i) = nan;
    end
    
    % Generate outcomes for reversal condition
    % ----------------------------------------
    
elseif isequal(condition, 'reversal') || isequal(condition, 'reversalPractice') || isequal(condition, 'reversalPracticeNoise')...
        || isequal(condition, 'reversalPracticeNoiseInv2') || isequal(condition, 'reversalPracticeNoiseInv3')
    
    for i = 1:trials
        
        % Indicate current task block
        block(i) = al_indicateBlock(i, taskParam.gParam.blockIndices);
        
        % Generate change points
        if (rand < haz && s == 0) || i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1 || i == taskParam.gParam.blockIndices(4) + 1
            cp(i) = 1;
            if (rand < taskParam.gParam.reversalProb(1) && sum(cp(block == block(i))) > 2) || (rand < taskParam.gParam.reversalProb(2) ...
                    && sum(cp(block == block(i))) > 2 && isequal(condition, 'reversalPractice')) || (rand < taskParam.gParam.reversalProb(2) ...
                    && sum(cp(block == block(i))) > 2 && isequal(condition, 'reversalPracticeNoise')) || (rand < taskParam.gParam.reversalProb(2) ...
                    && sum(cp(block == block(i))) > 2 && isequal(condition, 'reversalPracticeNoiseInv2'))
                reversal(i) = true;
                allMeans = distMean(cp==true);
                mean = allMeans(end-2);
            else
                mean = round(rand(1).*359);
                reversal(i) = false;
            end
            s = taskParam.gParam.safe(1);
            TAC(i) = 0;
        else
            TAC(i) = TAC(i-1)+1;
            s = max([s-1, 0]);
        end
        
        % Save actual mean
        distMean(i) = mean;
        
        % Generate current outcome
        outcome(i) = al_sampleOutcome(mean, concentration);
        
        % Indicate that we're not dealing with oddballs in this condition
        oddBall(i) = nan;
        
        % Generate catch trials
        catchTrial(i) = al_generateCatchTrial(cp(i));
        
        allASS(i) = al_getShieldSize(minASS, maxASS, mu);
    end
    
    % Generate outcomes for practice blocks of Chinese condition
    % ----------------------------------------------------------
    
elseif isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_4') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3') ||...
        (isequal(condition, 'chinese') && isequal(taskParam.gParam.useTrialConstraints, 'NoContraints'))
    
    for i = 1:trials
        
        % Indicate current task block
        block(i) = al_indicateBlock(i, taskParam.gParam.blockIndices);
        
        % For each block, determine means of outcome generating distributions
        if i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) || i == taskParam.gParam.blockIndices(3) || i == taskParam.gParam.blockIndices(4)
            %stateSpace = randi(360,3,3);
            stateSpace = randi(360,3,6);
        end
        
        % Determine latent state
        if (rand < enemyHaz && sState == 0) || i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1 || i == taskParam.gParam.blockIndices(4) + 1
            latentState(i) = randi(nEnemies);
            sState = safeEnemy;
            TAC_State(i) = 0;
        else
            TAC_State(i) = TAC_State(i-1) + 1;
            sState = max([sState-1, 0]);
            latentState(i) = latentState(i-1);
        end
        
        % Determine current context
        if (rand < planetHaz && sContext == 0) || i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1 || i == taskParam.gParam.blockIndices(4) + 1
            currentContext(i) = randi(nPlanets);
            sContext = safePlanet;
            TAC_Context(i) = 0;
        else
            TAC_Context(i) = TAC_Context(i-1) + 1;
            sContext = max([sContext-1, 0]);
            currentContext(i) = currentContext(i-1);
        end
        
        % Save actual mean
        distMean(i) = stateSpace(latentState(i), currentContext(i));
        
        % Sample outcomes
        outcome(i) = al_sampleOutcome(distMean(i), concentration);
        
        % Indicate that we're not dealing with oddballs in this condition
        oddBall(i) = nan;
        
        % Generate catch trials
        catchTrial(i) = al_generateCatchTrial(cp(i));
        
        % Generate angular shield size
        allASS(i) = al_getShieldSize(minASS, maxASS, mu);
        
    end
    
elseif isequal(condition, 'chinese') && isequal(taskParam.gParam.useTrialConstraints, 'Montreal')
    % Generation of outcomes for cannon state extension task
    
    if nEnemies ~= 2
        warning('Contraints not tested for current nEnemies!')
    end
    
    % Initialze variables
    if taskParam.gParam.useSameMapping == true
        nb = 1;
    else
        nb = taskParam.gParam.nb;% 8; % number of blocks
    end
    %crit_dist = 45; % critical distance between means. Controls the overlap between states to avoid very similar enemies.
    n_changes = (trials/nb)*haz; % number of changes
    safe = s;
    % block = repelem(1:nb, trials/nb); % block indizes
    %ass_mu = mu;  % this is currently ambiguous
    
    % Sample Means for enemy x planet x block
    % ---------------------------------------
    currDistMeans = randi(359, nEnemies, nPlanets, nb);
    
    while 1
        x = abs(al_diff(currDistMeans(1, :, :), currDistMeans(2, :, :)));
        if any(any(x < critDist))
            currDistMeans = randi(359, nEnemies, nPlanets, nb);
        else
            break
        end
    end
    
    %     % Sample planets. Here we have the same frequency for each planet
    %     % ---------------------------------------------------------------
    %     planet_vec = [ones(1, trials/2), repmat(2, 1, trials/2)];
    %     planet_vec = planet_vec(randperm(length(planet_vec)));
    
    % Initialize here!
    all_changes = [];
    all_mu = [];
    all_enemies = [];
    all_planets = [];
    block = [];
    
    % Sample number and timing of changes. Here we keep the number of enemy
    % changes constant
    
    % Cycle over blocks
    % -----------------
    for b = 1:nb
        
        % Sample planets. Here we have the same frequency for each planet
        % ---------------------------------------------------------------
        
        % This is how we did it for Montreal
        % planet_vec = [ones(1, trials/nb/2), repmat(2, 1, trials/nb/2)];
        % This is the new version. Not yet properly tested!
        planet_vec = repmat(1:nPlanets,1,trials/nb/nPlanets);
        planet_vec = planet_vec(randperm(length(planet_vec)));
        
        % Randomly determine first enemy
        enemy_vec = nan(trials/nb, 1);
        enemy_vec(1) = binornd(1, 0.5) + 1;
        
        % Initialiize vector for current mu
        current_mu = nan(trials/nb, 1)';
        current_block = repmat(b, trials/nb, 1);
        
        while true
            
            % Determine "change points" where enemy changes
            change_vec = [ones(1, n_changes), zeros(1, (trials/nb) - n_changes-safe * 2)];
            change_vec = change_vec(randperm(length(change_vec)));
            idx_change = find(change_vec);
            x = diff(idx_change);
            if ~ismember(x, 1:safe)
                % Make sure that first 3 and last 3 trials are no change points
                change_final = [zeros(safe, 1)', change_vec, zeros(safe, 1)'];
                idx_planet_change = find(diff(planet_vec))+1;
                idx_enemy_change = find(change_final);
                %criticalOK = zeros(1,numel(idx_enemy_change)-1);
                
                current_mu(1) = currDistMeans(enemy_vec(1), planet_vec(1),b);
                
                % Cycle through change vector and determine current enemy and conditional on this the current mean
                for i = 2:length(change_final)
                    if change_final(i) == 1
                        enemy_vec(i) = 3 - enemy_vec(i-1);
                    else
                        enemy_vec(i) = enemy_vec(i-1);
                    end
                    
                    current_mu(i) = currDistMeans(enemy_vec(i), planet_vec(i), b);
                end
                combo_vec = [enemy_vec, planet_vec'];
                [combo, first_visit] = unique(combo_vec, 'rows');
                
                criticalOK = zeros(1,numel(idx_enemy_change));
                critical_trial = nan(numel(idx_enemy_change));
                for i = 1:numel(idx_enemy_change)-1
                    fvoi = combo_vec(idx_enemy_change(i),:);
                    fvoi_index = first_visit(ismember(combo, fvoi, 'rows'));
                    criticalOK(i) = any(idx_planet_change > idx_enemy_change(i) & ...
                        idx_planet_change < idx_enemy_change(i+1) & ...
                        idx_enemy_change(i) ~= fvoi_index);
                    critical_trial(i) = idx_planet_change(find(idx_planet_change>idx_enemy_change(i) ,1));
                end
                criticalOK(end) = any(idx_planet_change > idx_enemy_change(end));
                critical_trial(end) = idx_planet_change(find(idx_planet_change>idx_enemy_change(i) ,1));
                if all(criticalOK(2:end))
                    break
                end
            end
        end
        
        %         % Generate enemy vector and determine current mu
        %         % Randomly generate the fist "active" enemy
        %         current_mu(1) = mu(enemy_vec(1), planet_vec(1),b);
        %
        %         % Cycle through change vector and determine current enemy and conditional on this the current mean
        %         for i = 2:length(change_final)
        %             if change_final(i) == 1
        %                 enemy_vec(i) = 3 - enemy_vec(i-1);
        %             else
        %                 enemy_vec(i) = enemy_vec(i-1);
        %             end
        %             current_mu(i) = mu(enemy_vec(i), planet_vec(i), b);
        %         end
        
        % TODO: Initialize!
        all_changes = horzcat(all_changes, change_vec);
        distMean = horzcat(all_mu, current_mu);
        latentState = horzcat(all_enemies, enemy_vec);
        currentContext = horzcat(all_planets, planet_vec);
        block = horzcat(block, current_block);
    end
    
    % Sample actual outcomes
    % ----------------------
    
    % Cycle over trials
    for i = 1:trials
        
        outcome(i) = round(180 + rad2deg(circ_vmrnd(deg2rad(all_mu(i) - 180), concentration, 1)));
        
        % Generate angular shield size
        allASS(i) = al_getShieldSize(minASS, maxASS, mu);
        
    end
    
    % Adjust in the future to match names!
    % latentState = all_enemies;
    % currentContext = all_planets;
    % distMean = all_mu;
    catchTrial = zeros(length(distMean), 1);
    oddBall = nan(length(distMean), 1);
    
elseif isequal(condition, 'chinese') && isequal(taskParam.gParam.useTrialConstraints, 'aging')
    
    if nEnemies ~= 3
         warning('Contraints not tested for current nEnemies!')
    end

    % Initialize variables
    %all_mu = [];
    latentState = [];
    currentContext = [];
    critDist = taskParam.gParam.critDist;
    
    % Sample Means for enemy x planet
    % -------------------------------
    
    currDistMeans = randi(359, nEnemies, nPlanets);
    while 1
        x1 = abs(al_diff(currDistMeans(1, :, :), currDistMeans(2, :, :)));
        x2 = abs(al_diff(currDistMeans(1, :, :), currDistMeans(3, :, :)));
        x3 = abs(al_diff(currDistMeans(2, :, :), currDistMeans(3, :, :)));
        if any(any(x1 < critDist)) || any(any(x2 < critDist)) || any(any(x3 < critDist))
            currDistMeans = randi(359, nEnemies, nPlanets);
        else
            break
        end
    end
    
    % Determine enemy
    enemies = linspace(1,nEnemies, nEnemies); 
    enemies = enemies(randperm(size(enemies ,2)));
    
    % Determine number of repetitions for current enemy
    rep = Shuffle([4, 5, 6]);
    
    % Cycle over enemies
    for e = 1:length(enemies)
        
        % Cycle over repetitions
        for r = 1:rep(e)
            
            % Determine all planets for entire block
            planet_vec = randperm(size(1:nPlanets, 2));
            currentContext = horzcat(currentContext, planet_vec);
            
            % Determine all enemies for entire block
            enemy_vec = repmat(enemies(e), 1, length(planet_vec));
            latentState = horzcat(latentState, enemy_vec);
        end
    end
    
    % Cycle over trials
    for i = 1:length(latentState)
        
        % Determine current mean
        distMean(i) = currDistMeans(latentState(i), currentContext(i));
       
        % Sample outcome
        outcome(i) = round(180 + rad2deg(circ_vmrnd(deg2rad(distMean(i) - 180), concentration, 1)));
        
        % Generate angular shield size
        allASS(i) = al_getShieldSize(minASS, maxASS, mu);
        
    end
    
    % Set catch trials and oddballs to zero
    block = ones(length(latentState), 1);
    catchTrial = zeros(length(distMean), 1);
    oddBall = nan(length(distMean), 1);
    
end

% Generate shield types
if isequal(taskParam.gParam.taskType, 'ARC') || isequal(taskParam.gParam.taskType, 'chinese')
    
    % Here all shields have the same color
    shieldType = ones(trials,1);
else
    
    %warning('ShieldType nicht spezifiziert')
    shieldType = Shuffle([zeros((trials/2),1); ones((trials/2),1)]);
end

%% Save data
% Todo: Eventually, this should become an object
taskData = struct(fieldNames.actJitter, actJitter, fieldNames.block,...
    block, fieldNames.initiationRTs, initiationRT, ...
    fieldNames.timestampOnset, timestampOnset, 'haz', haz,...
    'concentration', concentration, fieldNames.timestampPrediction, timestampPrediction,...
    fieldNames.timestampOffset, timestampOffset, fieldNames.oddBall,...
    oddBall, fieldNames.allASS, allASS, fieldNames.ID, {ID},...
    fieldNames.age, {age}, fieldNames.rew, {rew}, fieldNames.actRew,...
    actRew, fieldNames.sex, {sex}, fieldNames.cond, {cond},...
    fieldNames.trial, i, fieldNames.outcome, outcome, ...
    fieldNames.distMean, distMean, fieldNames.cp, cp, fieldNames.cBal,...
    {cBal}, fieldNames.TAC, TAC, fieldNames.shieldType, shieldType,...
    fieldNames.catchTrial, catchTrial, fieldNames.triggers, triggers,...
    fieldNames.pred, pred, fieldNames.predErr, predErr,...
    fieldNames.memErr, memErr, fieldNames.UP, UP, fieldNames.hit, hit,...
    fieldNames.perf, perf, fieldNames.accPerf, accPerf, fieldNames.date,...
    {Date},'reversal', reversal, 'initialTendency', initialTendency,...
    'RT', RT, 'currentContext', currentContext, 'hiddenContext', hiddenContext,...
    'latentState', latentState, 'savedTickmark', savedTickmark,...
    'savedTickmarkPrevious', savedTickmarkPrevious, 'critical_trial', critical_trial);
end