function taskData = GenerateOutcomes(taskParam, vola, sig, condition)
% This funtion generates the outcomes of the task.
%   The outcomes that are centerend around the mean of a normal
%   distribution (distMean) with standard deviation = sigma.
%   All other variables are preallocated.
%
%   This function uses code from Matt Nassar (Brown University). Thanks Matt!

if isequal(condition, 'main') || isequal(condition, 'oddball')
    trials = taskParam.gParam.trials;
elseif isequal(condition, 'mainPractice') || isequal(condition, 'oddballPractice_NoOddball') || isequal(condition, 'oddballPractice') || isequal(condition, 'followOutcomePractice') || isequal(condition, 'followCannonPractice')
    trials = taskParam.gParam.practTrials;
elseif isequal(condition, 'shield')
    trials = taskParam.gParam.shieldTrials;
elseif isequal(condition, 'followCannon') || isequal(condition, 'followOutcome')
    trials = taskParam.gParam.controlTrials;
end

% Preallocate variables.
fieldNames = taskParam.fieldNames;
ID = cell(trials, 1); % ID.
age = zeros(trials, 1); % Age.
sex = cell(trials, 1); % Sex.
rew = nan(trials, 1); % Reward.
actRew = nan(trials,1); % Actual reward.
Date = cell(trials, 1); % Date.
cond = cell(trials, 1); % Condition.
outcome=nan(trials, 1); % Outcome.
distMean=nan(trials, 1); % Distribution mean.
cp=zeros(trials, 1); % Change point.
TAC=nan(trials, 1); % Trials after change-point.
oddBall = zeros(trials, 1);
catchTrial = zeros(trials, 1); % Catch trial.
predT = zeros(trials, 1); % Trigger: prediction.
outT = zeros(trials, 1); % Trigger: outcome.
triggers = zeros(trials, 7); % Trigger: boat.
pred = zeros(trials, 1); % Prediction of participant.
predErr = nan(trials, 1); % Prediction error.
predErrNorm = zeros(trials, 1);% Regular prediction error.
predErrPlus = zeros(trials, 1); %Prediction error plus 360 degrees.
predErrMin = zeros(trials, 1); % Prediction error minus 360 degrees.
memErr = zeros(trials, 1);% Memory error.
memErrNorm = zeros(trials, 1);% Regular memory error.
memErrPlus = zeros(trials, 1); % Memory error plus 360 degrees.
memErrMin = zeros(trials, 1); % Memory error minus 360 degrees.
UP = zeros(trials, 1); % Update of participant.
UPNorm = zeros(trials, 1);% Regular prediction error.
UPPlus = zeros(trials, 1); %Prediction error plus 360 degrees.
UPMin = zeros(trials, 1); % Prediction error minus 360 degrees.
hit = zeros(trials, 1); % Hit.
cBal = nan(trials, 1); % Counterbalancing.
if isequal(condition,'shield')
    s=taskParam.gParam.safe(2);
else
    s=taskParam.gParam.safe(1);
end
%s=taskParam.gParam.safe; % how many guaranteed trials before change-point.
perf = zeros(trials, 1); % Performance.
accPerf = zeros(trials, 1); % Accumulated performance.
timestampOnset = nan(trials,1);
timestampPrediction = nan(trials,1);
timestampOffset = nan(trials, 1);
initiationRT = nan(trials,1);
block = nan(trials,1);
actJitter = nan(trials,1);
%% generateOutcomes (by Matt Nassar)

%rng('shuffle')
a = clock;
rand('twister', a(6).*10000);

% Angular shield size:
UorExp=0;
mu=15; % for CP = 15
minASS = 10;
maxASS=180;
allASS = zeros(trials,1);

if isequal(condition, 'main') || isequal(condition, 'followOutcome') || isequal(condition, 'mainPractice') || isequal(condition, 'followCannon') || isequal(condition, 'shield') || isequal(condition, 'followOutcomePractice') || isequal(condition, 'followCannonPractice')
    
    for i=1:trials
    % blocknumber
    if i >= taskParam.gParam.blockIndices(1) && i <= taskParam.gParam.blockIndices(2)
        block(i) = 1;
    elseif i >= taskParam.gParam.blockIndices(2) && i <= taskParam.gParam.blockIndices(3)
        block(i) = 2;
    elseif i >= taskParam.gParam.blockIndices(3) && i <= taskParam.gParam.blockIndices(4)
        block(i) = 3;
    elseif i >= taskParam.gParam.blockIndices(4)
        block(i) = 4;
    end
    
    if (rand < vola && s==0) || i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1 || i == taskParam.gParam.blockIndices(4) + 1 %% new mean for every block!
        mean=round(rand(1).*359); % Outcome expressed in degrees.
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
    %outcome(i) = 90
    
    outcome(i)=round(180+rad2deg(circ_vmrnd(deg2rad(mean-180), sig, 1)));
    %outcome(i)=round(normrnd(mean, sig));
    distMean(i)=mean;
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
    
    
elseif isequal(condition, 'oddball') || isequal(condition, 'practiceNoOddball') || isequal(condition, 'practiceOddball')
    
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
        if i >= taskParam.gParam.blockIndices(1) && i <= taskParam.gParam.blockIndices(2)
            block(i) = 1;
        elseif i >= taskParam.gParam.blockIndices(2) && i <= taskParam.gParam.blockIndices(3)
            block(i) = 2;
        elseif i >= taskParam.gParam.blockIndices(3) && i <= taskParam.gParam.blockIndices(4)
            block(i) = 3;
        elseif i >= taskParam.gParam.blockIndices(4)
            block(i) = 4;
        end
        
        if i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1 || i == taskParam.gParam.blockIndices(4) + 1 %% new mean for every block
            muRad_offset=unifrnd(-pi, pi);
        else
            muRad_offset= deg2rad(distMean(i-1)-180)+circ_vmrnd(0, driftConc, 1);
        end
        muRad_offset=circ_dist(muRad_offset, 0);
        distMean(i)=rad2deg(muRad_offset)+180;
        
        if isequal(condition, 'practiceNoOddball') || isequal(condition, 'shield')
            oddballProb = taskParam.gParam.oddballProb(2);
        elseif isequal(condition, 'practiceOddball') || isequal(condition, 'practice') || isequal(condition, 'main') || isequal(condition, 'oddball')
            oddballProb = taskParam.gParam.oddballProb(1);
        end
        
        if rand<oddballProb && s==0
            outcome(i)=round(rand.*359);
            oddBall(i)=true;
            TAC(i)=0; %TAC(i)=1;
            s=taskParam.gParam.safe(1);
        else
            if i==1
                TAC(i)=nan;
            else
                TAC(i)=TAC(i-1)+1;
            end
            outcome(i)= round(rad2deg(circ_vmrnd(deg2rad(distMean(i)-180), sig, 1))+180); %taskParam.gParam.driftConc
            s=max([s-1, 0]);
        end
        cp(i) = nan;
        
        
        ASS=nan;
        
        while ~isfinite(ASS)|| ASS<minASS || ASS>maxASS
            ASS=exprnd(mu);
        end
        allASS(i)=ASS.*2;
    end
    
end


% Boat type
if trials > 1
    boatType = Shuffle([zeros((trials/2),1); ones((trials/2),1)]);
else boatType = 1;
end
%% Save data
taskData = struct(fieldNames.actJitter, actJitter, fieldNames.block, block, fieldNames.initiationRTs, initiationRT, fieldNames.timestampOnset, timestampOnset, fieldNames.timestampPrediction, timestampPrediction, fieldNames.timestampOffset, timestampOffset, fieldNames.oddBall, oddBall, fieldNames.allASS, allASS, fieldNames.ID, {ID}, fieldNames.age, {age}, fieldNames.rew, {rew}, fieldNames.actRew, actRew, fieldNames.sex, {sex}, fieldNames.cond, {cond}, fieldNames.trial, i,...
    fieldNames.outcome, outcome, fieldNames.distMean, distMean, fieldNames.cp, cp, fieldNames.cBal, {cBal},...
    fieldNames.TAC, TAC, fieldNames.boatType, boatType, fieldNames.catchTrial, catchTrial, fieldNames.predT, predT,...
    fieldNames.outT, outT, fieldNames.triggers, triggers, fieldNames.pred, pred, fieldNames.predErr, predErr, fieldNames.predErrNorm, predErrNorm, fieldNames.predErrPlus, predErrPlus,...
    fieldNames.predErrMin, predErrMin, fieldNames.memErr, memErr, fieldNames.memErrNorm, memErrNorm,...
    fieldNames.memErrPlus, memErrPlus, fieldNames.memErrMin, memErrMin, fieldNames.UP, UP,...
    fieldNames.UPNorm, UPNorm, fieldNames.UPPlus, UPPlus, fieldNames.UPMin, UPMin, fieldNames.hit, hit,...
    fieldNames.perf, perf, fieldNames.accPerf, accPerf, fieldNames.Date, {Date});
end