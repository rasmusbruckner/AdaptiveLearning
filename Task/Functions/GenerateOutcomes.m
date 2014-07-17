function taskData = GenerateOutcomes(taskParam, vola, sig, condition)
% This funtion generates the outcomes of the task.
%   The outcomes that are centerend around the mean of a normal
%   distribution (distMean) with standard deviation = sigma.
%   All other variables are preallocated.
% 
%   This function uses code from Matt Nassar (Brown University). Thanks Matt!

if isequal(condition, 'main')
    trials = taskParam.gParam.trials;
elseif isequal(condition, 'practice')
    trials = taskParam.gParam.practTrials;
elseif isequal(condition, 'control')
    trials = taskParam.gParam.contTrials;
end

% Preallocate variables.
fieldNames = taskParam.fieldNames;
ID = cell(trials, 1); % ID.
age = zeros(trials, 1); % Age.
sex = cell(trials, 1); % Sex.
rew = cell(trials, 1); % Reward.
actRew = zeros(trials,1); % Actual reward.
Date = cell(trials, 1); % Date.
cond = cell(trials, 1); % Condition.
outcome=nan(trials, 1); % Outcome.
distMean=nan(trials, 1); % Distribution mean.
cp=zeros(trials, 1); % Change point.
TAC=nan(trials, 1); % Trials after change-point.
boatType = zeros(trials, 1); % Boat type.
catchTrial = zeros(trials, 1); % Catch trial.
predT = zeros(trials, 1); % Trigger: prediction.
outT = zeros(trials, 1); % Trigger: outcome.
boatT = zeros(trials, 1); % Trigger: boat.
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
cBal = cell(trials, 1); % Counterbalancing.
s=taskParam.gParam.safe; % how many guaranteed trials before change-point.
perf = zeros(trials, 1); % Performance.
accPerf = zeros(trials, 1); % Accumulated performance.

%% generateOutcomes (by Matt Nassar)

%rand('RNG', sum(clock));

for i = 1:trials
    if (rand < vola && s==0) || i == 1;
        mean=round(rand(1).*359); % Outcome expressed in degrees.
        cp(i)=1;
        s=taskParam.gParam.safe;
        TAC(i)=0; %TAC(i)=1;
    else
        TAC(i)=TAC(i-1)+1;
        s=max([s-1, 0]);
    end
    %outcome(i) = 90
    outcome(i)=round(normrnd(mean, sig));
    distMean(i)=mean;
    
    % BoatType
    r = rand(1);
    if r <= 0.5
        boatType(i) = 1;
    else
        boatType(i) = 2;
    end
    
    %CatchTrial
    if rand(1) <= 1
        catchTrial(i) = 0;
    else
        catchTrial(i) = 0;
    end
end

%% Save data.
taskData = struct(fieldNames.ID, {ID}, fieldNames.age, {age}, fieldNames.rew, {rew}, fieldNames.actRew, actRew, fieldNames.sex, {sex}, fieldNames.cond, {cond}, fieldNames.trial, i,...
    fieldNames.outcome, outcome, fieldNames.distMean, distMean, fieldNames.cp, cp, fieldNames.cBal, {cBal},...
    fieldNames.TAC, TAC, fieldNames.boatType, boatType, fieldNames.catchTrial, catchTrial, fieldNames.predT, predT,...
    fieldNames.outT, outT, fieldNames.boatT, boatT, fieldNames.pred, pred, fieldNames.predErr, predErr, fieldNames.predErrNorm, predErrNorm, fieldNames.predErrPlus, predErrPlus,...
    fieldNames.predErrMin, predErrMin, fieldNames.memErr, memErr, fieldNames.memErrNorm, memErrNorm,...
    fieldNames.memErrPlus, memErrPlus, fieldNames.memErrMin, memErrMin, fieldNames.UP, UP,...
    fieldNames.UPNorm, UPNorm, fieldNames.UPPlus, UPPlus, fieldNames.UPMin, UPMin, fieldNames.hit, hit,...
    fieldNames.perf, perf, fieldNames.accPerf, accPerf, fieldNames.Date, {Date});
end