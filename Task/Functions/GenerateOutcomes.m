function taskData = GenerateOutcomes(taskParam, sigma, condition)
%This funtion generates the outcomes of the task.
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

% if ~exist('isIntro', 'var') || ~exist('control', 'var') %Check session type (main vs. practice)
%          trials = taskParam.trials;
% elseif exist('isIntro', 'var')
%      trials = taskParam.practTrials;
% elseif exist('control', 'var')
%      trials = taskParam.contTrials;
% end

% Preallocate variables.
fID = 'ID'; ID = cell(trials, 1); % ID.
fAge = 'age'; age = zeros(trials, 1); % Age.
fSex = 'sex'; sex = cell(trials, 1); % Sex.
fDate = 'date'; date = cell(trials, 1);
fTrial = 'trial'; %trial = zeros(trials, 1); % Trial.
fOutcome = 'outcome'; outcome=nan(trials, 1); % Outcome.       
fDistMean = 'distMean'; distMean=nan(trials, 1); % Distribution mean.      
fCp = 'cp'; cp=zeros(trials, 1); % Change point.           
fTAC = 'TAC'; TAC=nan(trials, 1); % Trials after change-point.
fBoatType = 'boatType'; boatType = zeros(trials, 1); % Boat type.
fCatchTrial = 'catchTrial'; catchTrial = zeros(trials, 1); % Catch trial.
fPred = 'pred';pred = zeros(trials, 1); % Prediction of participant.
fPredErr = 'predErr'; predErr = nan(trials, 1); % Prediction error.
fPredErrNorm = 'predErrNorm'; predErrNorm = zeros(trials, 1);% Regular prediction error.
fPredErrPlus = 'predErrPlus'; predErrPlus = zeros(trials, 1); %Prediction error plus 360 degrees.
fPredErrMin = 'predErrMin'; predErrMin = zeros(trials, 1); % Prediction error minus 360 degrees.
fHit = 'hit'; hit = zeros(trials, 1);
fCBal = 'cBal'; cBal = cell(trials, 1);
s=taskParam.safe; % how many guaranteed trials before change-point.
fPerf = 'perf'; perf = zeros(trials, 1); % Performance.
fAccPerf = 'accPerf'; accPerf = zeros(trials, 1); % Accumulated performance. 



%%%%%%


%%%%%%
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
        outcome(i)=round(normrnd(mean, sigma));
       
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

taskData = struct(fID, {ID}, fAge, age,fSex, {sex}, fTrial, i, fOutcome,...
    outcome, fDistMean, distMean, fCp, cp, fCBal, {cBal}, fTAC, TAC, fBoatType, boatType,...
    fCatchTrial, catchTrial, fPred, pred, fPredErr, predErr, fPredErrNorm,...
    predErrNorm, fPredErrPlus, predErrPlus, fPredErrMin, predErrMin,...
    fHit, hit, fPerf, perf, fAccPerf, accPerf, fDate, {date});
end