% GenerateDataOnly

updateManualVariables = true;
condition = 'reversal';

if ~updateManualVariables
    close all
    clear all



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
vola = [.25 1 0]; 
oddballProb = [.25 0];
reversalProb = [.5 .5];
concentration = [10 12 99999999];  
driftConc = [30 99999999]; 
safe = [3 0];
rewMag = 0.2;
jitter = 0.2;
practiceTrialCriterion = 10;
test = false; 
debug = false;
taskType = 'reversal';

gParam = struct('trials', trials, 'safe', safe, 'blockIndices', blockIndices, 'driftConc', driftConc, 'oddballProb', oddballProb, 'reversalProb', reversalProb, 'taskType', taskType);
fieldNames = struct('actJitter', 'actJitter', 'block', 'block', 'initiationRTs', 'initiationRTs', 'timestampOnset', 'timestampOnset',...
    'timestampPrediction', 'timestampPrediction', 'timestampOffset', 'timestampOffset', 'oddBall', 'oddBall', 'allASS', 'allASS', 'ID', 'ID',...
    'age', 'age', 'rew', 'rew', 'actRew', 'actRew', 'sex', 'sex', 'cond', 'cond', 'trial', 'trial', 'outcome', 'outcome', 'distMean', 'distMean',...
    'cp', 'cp', 'cBal', 'cBal', 'TAC', 'TAC', 'shieldType', 'shieldType', 'catchTrial', 'catchTrial', 'predT', 'predT', 'outT', 'outT', 'triggers', 'triggers',...
    'pred', 'pred', 'predErr', 'predErr', 'predErrNorm', 'predErrNorm', 'predErrPlus', 'predErrPlus', 'predErrMin', 'predErrMin', 'memErr', 'memErr',...
    'memErrNorm', 'memErrNorm', 'memErrPlus', 'memErrPlus', 'memErrMin', 'memErrMin', 'UP', 'UP','UPNorm', 'UPNorm','UPPlus', 'UPPlus',...
    'UPMin', 'UPMin', 'hit', 'hit', 'perf', 'perf', 'accPerf', 'accPerf', 'date', 'date', 'driftConc', 'driftConc', 'reversalProb', 'reversalProb', 'taskType', 'taskType');
taskParam = struct('fieldNames', fieldNames, 'gParam', gParam);
condition = 'reversal';
taskData = GenerateOutcomes(taskParam, vola(1), concentration(1), condition);

end
% manually add behavior
taskData.pred = [0;190;160;164;50;360;126;140;135;106;212;302;300;165;22;220;160;170;144;140];;
if isequal(condition,'reversal');
    taskData.savedTickmark = [0;100;0;50;2;50;360;50;0;0;0;0;0;0;0;50;50;50;50;50];

end
hold on 
plot(taskData.outcome, '.')
plot(taskData.distMean, '--')

