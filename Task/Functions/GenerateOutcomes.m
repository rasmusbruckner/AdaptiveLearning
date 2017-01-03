function taskData = generateOutcomes(taskParam, haz, concentration, condition)
%GENERATEOUTCOMES    generates the outcomes for the different tasks

% -------------------------------------------------------------------------
% Select number of trials
% -------------------------------------------------------------------------

if isequal(condition, 'main') || isequal(condition, 'oddball') ||...
        isequal(condition, 'reversal') || isequal(condition, 'chinese')
    try
    trials = taskParam.gParam.trials;
    catch
        keyboard  
    end
elseif isequal(condition, 'mainPractice')... 
    || isequal(condition, 'practiceNoOddball')...
    || isequal(condition, 'oddballPractice')... 
    || isequal(condition, 'followOutcomePractice')...
    || isequal(condition, 'followCannonPractice')...
    || isequal(condition, 'reversalPractice')...
    || isequal(condition, 'reversalPracticeNoise')...
    || isequal(condition, 'reversalPracticeNoiseInv2')...
    || isequal(condition, 'chinesePractice')...
    || isequal(condition, 'chinesePracticeNoise') 
        
    trials = taskParam.gParam.practTrials;
elseif isequal(condition, 'shield')
    trials = taskParam.gParam.shieldTrials;
elseif isequal(condition, 'followCannon') ||...
        isequal(condition, 'followOutcome')
    trials = taskParam.gParam.controlTrials;
elseif isequal(condition, 'reversalPracticeNoiseInv')
    trials = 4;
elseif isequal(condition, 'reversalPracticeNoiseInv3')
    trials = taskParam.gParam.practTrials * 2;
elseif isequal(condition, 'chineseLastPractice')...
        || isequal(condition, 'chinesePracticeStateSpace')
    trials = taskParam.gParam.chinesePractTrials;
end
contextTypes = 0;

% -------------------------------------------------------------------------
% Preallocate variables
% -------------------------------------------------------------------------

%fieldnames          = taskParam.fieldNames;
ID                      = cell(trials, 1);
age                     = zeros(trials, 1);
sex                     = cell(trials, 1);
rew                     = nan(trials, 1);
actRew                  = nan(trials,1);
Date                    = cell(trials, 1);
cond                    = cell(trials, 1);
outcome                 = nan(trials, 1);
distMean                = nan(trials, 1);
warning('check this')
%cp                      = zeros(trials, 1);
reversal                = zeros(trials,1);
TAC                     = nan(trials,1);
oddBall                 = zeros(trials,1);
catchTrial              = zeros(trials,1);
triggers                = zeros(trials,7);
pred                    = zeros(trials,1);
predErr                 = nan(trials,1);
memErr                  = zeros(trials,1);
UP                      = zeros(trials,1);
hit                     = zeros(trials,1);
cBal                    = nan(trials,1);
perf                    = zeros(trials,1); 
accPerf                 = zeros(trials,1); 
timestampOnset          = nan(trials,1);
timestampPrediction     = nan(trials,1);
timestampOffset         = nan(trials,1);
initiationRT            = nan(trials,1);
RT                      = nan(trials,1);
initialTendency         = nan(trials,1);
block                   = nan(trials,1);
actJitter               = nan(trials,1);
allASS                  = zeros(trials,1);
currentContext          = nan(trials,1);
hiddenContext           = nan(trials,1);
latentState             = nan(trials,1);
TAC_Context             = nan(trials,1);
TAC_State               = nan(trials,1);
sContext                = nan;
sState                  = nan;
if isequal(condition,'shield')
    s                   = taskParam.gParam.safe(2);
else
    s                   = taskParam.gParam.safe(1);
end
mu                      = 15;
minASS                  = 10;
maxASS                  = 180;
nContexts               = taskParam.gParam.nContexts;
cp                      = zeros(trials, nContexts);
nStates                 = taskParam.gParam.nStates;
contextHaz              = taskParam.gParam.contextHaz;
stateHaz                = taskParam.gParam.stateHaz;
safeContext             = taskParam.gParam.safeContext;
safeState               = taskParam.gParam.safeState;
% -------------------------------------------------------------------------
% Generate outcomes for CP condition
% -------------------------------------------------------------------------

if isequal(condition, 'main') ||...
        isequal(condition, 'followOutcome') ||...
        isequal(condition, 'mainPractice') ||...
        isequal(condition, 'followCannon') ||...
        isequal(condition, 'shield') ||...
        isequal(condition, 'followOutcomePractice') ||...
        isequal(condition, 'followCannonPractice')
    
    for i = 1:trials
        currentContext(i) = 1;
        if i >= taskParam.gParam.blockIndices(1)...
                && i <= taskParam.gParam.blockIndices(2)
            block(i) = 1;
        elseif i >= taskParam.gParam.blockIndices(2)...
                && i <= taskParam.gParam.blockIndices(3)
            block(i) = 2;
        elseif i >= taskParam.gParam.blockIndices(3)...
                && i <= taskParam.gParam.blockIndices(4)
            block(i) = 3;
        elseif i >= taskParam.gParam.blockIndices(4)
            block(i) = 4;
        end
        
        if (rand < haz && s==0)...
                || i == taskParam.gParam.blockIndices(1)...
                || i == taskParam.gParam.blockIndices(2) + 1 ...
                || i == taskParam.gParam.blockIndices(3) + 1 ...
                || i == taskParam.gParam.blockIndices(4) + 1 
            mean=round(rand(1).*359); 
            cp(i)=1;
            if isequal(condition,'shield')
                s=taskParam.gParam.safe(2);
            else
                s=taskParam.gParam.safe(1);
            end
            
            TAC(i)=0; %TAC(i)=1;
        else
            TAC(i)=TAC(i-1)+1;
            s=max([s-1, 0]);
        end
        
        outcome(i) =...
            round(180+rad2deg(circ_vmrnd(deg2rad(mean-180),...
            concentration, 1)));
        distMean(i) = mean;
        oddBall(i) = nan;
        
        %CatchTrial
        
        if rand <= .10 && cp(i) == 0;
            catchTrial(i) = 1;
        else
            catchTrial(i) = 0;
        end
        ASS=nan;
        
        while ~isfinite(ASS)|| ASS<minASS || ASS>maxASS
            ASS=exprnd(mu);
        end
        allASS(i)=ASS;
    end
        latentState(i) = 0;
    
% -------------------------------------------------------------------------
% Generate outcomes for Oddball condition
% -------------------------------------------------------------------------
        
elseif isequal(condition, 'oddball')...
        || isequal(condition, 'practiceNoOddball')...
        || isequal(condition, 'practiceOddball')

    distMean=nan(trials,1);
    oddBall=false(trials,1);
    outcome=nan(trials,1);
    if isequal(condition, 'shield')
        driftConc = taskParam.gParam.driftConc(2);
    else
        driftConc = taskParam.gParam.driftConc(1);
    end
    
    s = 0;
    mu=10; % for ODDBALL = 10
    
    for i=1:trials
        
        % blocknumber
        if i >= taskParam.gParam.blockIndices(1)...
                && i <= taskParam.gParam.blockIndices(2)
            block(i) = 1;
        elseif i >= taskParam.gParam.blockIndices(2)...
                && i <= taskParam.gParam.blockIndices(3)
            block(i) = 2;
        elseif i >= taskParam.gParam.blockIndices(3)...
                && i <= taskParam.gParam.blockIndices(4)
            block(i) = 3;
        elseif i >= taskParam.gParam.blockIndices(4)
            block(i) = 4;
        end
        
        if i == taskParam.gParam.blockIndices(1) ...
                || i == taskParam.gParam.blockIndices(2) + 1 ...
                || i == taskParam.gParam.blockIndices(3) + 1 ...
                || i == taskParam.gParam.blockIndices(4) + 1 
            muRad_offset=unifrnd(-pi, pi);
        else
            muRad_offset= deg2rad(distMean(i-1)-180)+...
                circ_vmrnd(0, driftConc, 1);
        end
        muRad_offset=circ_dist(muRad_offset, 0);
        distMean(i)=rad2deg(muRad_offset)+180;
        
        if isequal(condition, 'practiceNoOddball') ...
                || isequal(condition, 'shield')
            oddballProb = taskParam.gParam.oddballProb(2);
        elseif isequal(condition, 'practiceOddball')...
                || isequal(condition, 'practice') ...
                || isequal(condition, 'main') ...
                || isequal(condition, 'oddball')
            oddballProb = taskParam.gParam.oddballProb(1);
        end
        
        if rand<oddballProb && s==0
            outcome(i)=round(rand.*359);
            oddBall(i)=true;
            TAC(i)=0;
            s=taskParam.gParam.safe(1);
        else
            if i==1
                TAC(i)=nan;
            else
                TAC(i)=TAC(i-1)+1;
            end
            outcome(i) =...
                round(rad2deg(circ_vmrnd(deg2rad(distMean(i)-180),...
                concentration, 1))+180); 
            s=max([s-1, 0]);
        end
        cp(i) = nan;
        
        
        ASS=nan;
        
        while ~isfinite(ASS)|| ASS<minASS || ASS>maxASS
            ASS=exprnd(mu);
        end
        allASS(i)=ASS.*2;
    end
    
    
% -------------------------------------------------------------------------
% Generate outcomes for reversal condition
% -------------------------------------------------------------------------
    
elseif isequal(condition, 'reversal')...
        || isequal(condition, 'reversalPractice')...
        || isequal(condition, 'reversalPracticeNoise')...
        || isequal(condition, 'reversalPracticeNoiseInv2')...
        || isequal(condition, 'reversalPracticeNoiseInv3')
    
    for i = 1:trials
        if i >= taskParam.gParam.blockIndices(1) ...
                && i <= taskParam.gParam.blockIndices(2)
            block(i) = 1;
        elseif i >= taskParam.gParam.blockIndices(2) ...
                && i <= taskParam.gParam.blockIndices(3)
            block(i) = 2;
        elseif i >= taskParam.gParam.blockIndices(3)...
                && i <= taskParam.gParam.blockIndices(4)
            block(i) = 3;
        elseif i >= taskParam.gParam.blockIndices(4)
            block(i) = 4;
        end
        currentBlock = block(i);
        if (rand < haz && s == 0)...
                || i == taskParam.gParam.blockIndices(1)...
                || i == taskParam.gParam.blockIndices(2) + 1 ...
                || i == taskParam.gParam.blockIndices(3) + 1 ...
                || i == taskParam.gParam.blockIndices(4) + 1
            cp(i) = 1;
            if (rand < taskParam.gParam.reversalProb(1) ...
                    && sum(cp(block == currentBlock)) > 2) ...
                    || (rand < taskParam.gParam.reversalProb(2) ...
                    && sum(cp(block == currentBlock)) > 2 ...
                    && isequal(condition, 'reversalPractice')) ...
                    || (rand < taskParam.gParam.reversalProb(2) ...
                    && sum(cp(block == currentBlock)) > 2....
                    && isequal(condition, 'reversalPracticeNoise')) ...
                    || (rand < taskParam.gParam.reversalProb(2) ...
                    && sum(cp(block == currentBlock)) > 2 ...
                    && isequal(condition, 'reversalPracticeNoiseInv2'))
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
      
        distMean(i) = mean;

        outcome(i) = round(180+rad2deg(circ_vmrnd(deg2rad(mean-180),...
            concentration, 1)));
        oddBall(i) = nan;
        
        if rand <= .10 && cp(i) == 0;
            catchTrial(i) = 1;
        else
            catchTrial(i) = 0;
        end
        ASS = nan;
        
        while ~isfinite(ASS)|| ASS < minASS || ASS > maxASS
            ASS = exprnd(mu);
        end
        
        allASS(i) = ASS;
    end
    
% -------------------------------------------------------------------------
% Generate outcomes for Chinese condition
% -------------------------------------------------------------------------
    
elseif isequal(condition, 'chinese') ||...
       isequal(condition, 'chinesePractice') ||...
       isequal(condition, 'chineseLastPractice') ||...
       isequal(condition, 'chinesePracticeNoise') ||...
       isequal(condition, 'chinesePracticeStateSpace')
       warning('checken')
%        nContexts = taskParam.gParam.nContexts;% 1;
%         nStates = taskParam.gParam.nStates;%3;
%         contextHaz = taskParam.gParam.contextHaz;%0.5;%1/nContexts;
%         stateHaz = taskParam.gParam.stateHaz;% 0.5;
%         safeContext =  taskParam.gParam.safeContext;% 0;
%         safeState = taskParam.gParam.safeState;%;0;
%         sContext = nan;
%         sState = nan;
%         cp = zeros(trials, nContexts);
    
    for i = 1:trials
        
        if i >= taskParam.gParam.blockIndices(1)...
                && i < taskParam.gParam.blockIndices(2)
            block(i) = 1;
        elseif i >= taskParam.gParam.blockIndices(2)...
                && i < taskParam.gParam.blockIndices(3)
            block(i) = 2;
        elseif i >= taskParam.gParam.blockIndices(3)...
                && i < taskParam.gParam.blockIndices(4)
            block(i) = 3;
        elseif i >= taskParam.gParam.blockIndices(4)
            block(i) = 4;
        end
        
        if i == taskParam.gParam.blockIndices(1)...
                || i == taskParam.gParam.blockIndices(2)...
                || i == taskParam.gParam.blockIndices(3)...
                || i == taskParam.gParam.blockIndices(4)
           
            stateSpace = randi(360,3,3);
            
        end
        
        % determine latent state
        if (rand < stateHaz && sState == 0)...
                || i == taskParam.gParam.blockIndices(1)...
                || i == taskParam.gParam.blockIndices(2) + 1 ...
                || i == taskParam.gParam.blockIndices(3) + 1 ...
                || i == taskParam.gParam.blockIndices(4) + 1 

            latentState(i) = randi(nContexts); 
            %stateCp(i) = 1;
            sState = safeState;
            TAC_State(i) = 0; 
        else
            TAC_State(i) = TAC_State(i-1) + 1;
            sState = max([sState-1, 0]);
            latentState(i) = latentState(i-1);
        end
        
        % determine current context 
        if (rand < contextHaz && sContext == 0)...
                || i == taskParam.gParam.blockIndices(1)...
                || i == taskParam.gParam.blockIndices(2) + 1 ...
                || i == taskParam.gParam.blockIndices(3) + 1 ...
                || i == taskParam.gParam.blockIndices(4) + 1 
           
            currentContext(i) = randi(nStates); 
            
            %contextCp(i) = 1;
            sContext = safeContext;
            TAC_Context(i) = 0; 
        else
            TAC_Context(i) = TAC_Context(i-1) + 1;
            sContext = max([sContext-1, 0]);
            currentContext(i) = currentContext(i-1);
        end
        
        outcome(i) =...
            round(180+rad2deg(circ_vmrnd(deg2rad(...
            stateSpace(latentState(i), currentContext(i))-180),...
            concentration, 1)));

        distMean(i) = stateSpace(latentState(i), currentContext(i));
        
        oddBall(i) = nan;
        
        if rand <= .10 && cp(i) == 0;
            catchTrial(i) = 1;
        else
            catchTrial(i) = 0;
        end
        ASS=nan;
        
        while ~isfinite(ASS)|| ASS<minASS || ASS>maxASS
            ASS = exprnd(mu);
        end
        allASS(i) = ASS;
    end
    
end

warning('does this work with other versions?')
shieldType = ones(trials,1); %always reward

%% Save data
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
    'RT', RT, 'currentContext', currentContext,...
    'hiddenContext', hiddenContext, 'contextTypes', contextTypes,...
    'latentState', latentState);
end