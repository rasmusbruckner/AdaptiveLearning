% GenerateDataOnly

updateManualVariables = false;


if ~updateManualVariables
    close all
    clear all
condition = 'main';
runIntro = true;
askSubjInfo = true;
oddball = false;
allThreeConditions = true;
sendTrigger = false;
randomize = true;
shieldTrials = 1; % 6
practTrials = 20; % 20
trials = 20; % 240
controlTrials = 1; % 120 
blockIndices = [1 60 120 180]; 
haz = [.125 1 0]; 
oddballProb = [.25 0];
reversalProb = [0.5 1];
concentration = [12 8 99999999];  %10
driftConc = [30 99999999]; 
safe = [3 0];
rewMag = 0.2;
jitter = 0.2;
practiceTrialCriterion = 10;
test = false; 
debug = false;
taskType = 'ARC';
nContexts = 1;
nStates = 1;
contextHaz = nan;
stateHaz = nan;
safeContext = nan;
safeState = nan;

gParam = struct('trials', trials, 'safe', safe, 'blockIndices', blockIndices, 'driftConc', driftConc, 'oddballProb', oddballProb, 'reversalProb', reversalProb, 'taskType', taskType, 'nContexts', nContexts, 'nStates', nStates, 'contextHaz', contextHaz, 'stateHaz', stateHaz, 'safeContext', safeContext, 'safeState', safeState);
fieldNames = struct('actJitter', 'actJitter', 'block', 'block', 'initiationRTs', 'initiationRTs', 'timestampOnset', 'timestampOnset',...
    'timestampPrediction', 'timestampPrediction', 'timestampOffset', 'timestampOffset', 'oddBall', 'oddBall', 'allASS', 'allASS', 'ID', 'ID',...
    'age', 'age', 'rew', 'rew', 'actRew', 'actRew', 'sex', 'sex', 'cond', 'cond', 'trial', 'trial', 'outcome', 'outcome', 'distMean', 'distMean',...
    'cp', 'cp', 'cBal', 'cBal', 'TAC', 'TAC', 'shieldType', 'shieldType', 'catchTrial', 'catchTrial', 'predT', 'predT', 'outT', 'outT', 'triggers', 'triggers',...
    'pred', 'pred', 'predErr', 'predErr', 'predErrNorm', 'predErrNorm', 'predErrPlus', 'predErrPlus', 'predErrMin', 'predErrMin', 'memErr', 'memErr',...
    'memErrNorm', 'memErrNorm', 'memErrPlus', 'memErrPlus', 'memErrMin', 'memErrMin', 'UP', 'UP','UPNorm', 'UPNorm','UPPlus', 'UPPlus',...
    'UPMin', 'UPMin', 'hit', 'hit', 'perf', 'perf', 'accPerf', 'accPerf', 'date', 'date', 'driftConc', 'driftConc', 'reversalProb', 'reversalProb', 'taskType', 'taskType');
taskParam = struct('fieldNames', fieldNames, 'gParam', gParam);

taskData = al_generateOutcomes(taskParam, haz(1), concentration(1), condition);

end
% manually add behavior
%taskData.pred = [81;112;109;102;114;90;109;131;93;102;200;200;200;200;200;200;200;200;200;200;]
if isequal(condition,'reversal');
    taskData.savedTickmark = [0;100;0;50;2;50;360;50;0;0;0;0;0;0;0;50;50;50;50;50];

end
hold on 
plot(taskData.outcome, '.')
plot(taskData.distMean, '--')
%plot(taskData.pred, 'r')

