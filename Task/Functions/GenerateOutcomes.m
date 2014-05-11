function taskData = GenerateOutcomes(taskParam, sigmas, condition)
% This funtion generates the outcomes of the task.
%   The outcomes that are centerend around the mean of a normal
%   distribution (distMean) with standard deviation = sigma.
%   All other variables are preallocated.

if isequal(condition, 'main')
    trials = taskParam.trials;
elseif isequal(condition, 'practice')
    trials = taskParam.practTrials;
elseif isequal(condition, 'control')
    trials = taskParam.contTrials;
end

% Preallocate variables.
fieldNames = taskParam.fieldNames;
ID = cell(trials, 1); % ID.
age = zeros(trials, 1); % Age.
sex = cell(trials, 1); % Sex.
date = cell(trials, 1);
%sigma = zeros(trials, 1); % Sigma.
%fTrial = 'trial'; %trial = zeros(trials, 1); % Trial.
outcome=nan(trials, 1); % Outcome.       
distMean=nan(trials, 1); % Distribution mean.      
cp=zeros(trials, 1); % Change point.           
TAC=nan(trials, 1); % Trials after change-point.
boatType = zeros(trials, 1); % Boat type.
catchTrial = zeros(trials, 1); % Catch trial.
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
UPMin = zeros(trials, 1);
hit = zeros(trials, 1); % Hit.
cBal = cell(trials, 1); % Counterbalancing.
s=taskParam.safe; % how many guaranteed trials before change-point.
perf = zeros(trials, 1); % Performance.
accPerf = zeros(trials, 1); % Accumulated performance. 

%% generateOutcomes

for i = 1:trials
    if (rand<taskParam.hazardRate && s==0) || i == 1;
        mean=round(rand(1).*360); % Outcome expressed in degrees.
        cp(i)=1;
        s=taskParam.safe;
        TAC(i)=0; %TAC(i)=1;
    else
        TAC(i)=TAC(i-1)+1; %TAC(i)=TAC(i-1)+1;
        s=max([s-1, 0]);
    end
    %while ~isfinite(outcome(i))|outcome(i)>2*pi|outcome(i)<0;
        outcome(i)=round(normrnd(mean, sigmas)); 
    %end
    distMean(i)=mean;
    
    % BoatType
    r = rand(1);
    if r <= 0.33 
        boatType(i) = 1;
    elseif r > 0.33 && r <= 0.66
        boatType(i) = 2;
    elseif r > 0.66
        boatType(i) = 3;
    end
    
    %CatchTrial
    if rand(1) <= 0.05
        catchTrial(i) = 1;
    else
        catchTrial(i) = 0;
    end
end

taskData = struct(fieldNames.ID, {ID}, fieldNames.age, {age},fieldNames.sex, {sex}, fieldNames.trial, i,...
    fieldNames.outcome, outcome, fieldNames.distMean, distMean, fieldNames.cp, cp, fieldNames.cBal, {cBal},...
    fieldNames.TAC, TAC, fieldNames.boatType, boatType, fieldNames.catchTrial, catchTrial, fieldNames.pred,...
    pred, fieldNames.predErr, predErr, fieldNames.predErrNorm, predErrNorm, fieldNames.predErrPlus, predErrPlus,...
    fieldNames.predErrMin, predErrMin, fieldNames.memErr, memErr, fieldNames.memErrNorm, memErrNorm,...
    fieldNames.memErrPlus, memErrPlus, fieldNames.memErrMin, memErrMin, fieldNames.UP, UP,...
    fieldNames.UPNorm, UPNorm, fieldNames.UPPlus, UPPlus, fieldNames.UPMin, UPMin, fieldNames.hit, hit,...
    fieldNames.perf, perf, fieldNames.accPerf, accPerf, fieldNames.date, {date});
end