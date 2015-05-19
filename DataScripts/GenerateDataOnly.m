% GenerateDataOnly


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
sigma = [10 12 99999999];  
driftConc = [30 99999999]; 
safe = [3 0];
rewMag = 0.2;
jitter = 0.2;
practiceTrialCriterion = 10;
test = false; 
debug = false;

gParam = struct('trials', trials, 'safe', safe, 'blockIndices', blockIndices, 'driftConc', driftConc, 'oddballProb', oddballProb);
fieldNames = struct('actJitter', 'actJitter', 'block', 'block', 'initiationRTs', 'initiationRTs', 'timestampOnset', 'timestampOnset',...
    'timestampPrediction', 'timestampPrediction', 'timestampOffset', 'timestampOffset', 'oddBall', 'oddBall', 'allASS', 'allASS', 'ID', 'ID',...
    'age', 'age', 'rew', 'rew', 'actRew', 'actRew', 'sex', 'sex', 'cond', 'cond', 'trial', 'trial', 'outcome', 'outcome', 'distMean', 'distMean',...
    'cp', 'cp', 'cBal', 'cBal', 'TAC', 'TAC', 'boatType', 'boatType', 'catchTrial', 'catchTrial', 'predT', 'predT', 'outT', 'outT', 'triggers', 'triggers',...
    'pred', 'pred', 'predErr', 'predErr', 'predErrNorm', 'predErrNorm', 'predErrPlus', 'predErrPlus', 'predErrMin', 'predErrMin', 'memErr', 'memErr',...
    'memErrNorm', 'memErrNorm', 'memErrPlus', 'memErrPlus', 'memErrMin', 'memErrMin', 'UP', 'UP','UPNorm', 'UPNorm','UPPlus', 'UPPlus',...
    'UPMin', 'UPMin', 'hit', 'hit', 'perf', 'perf', 'accPerf', 'accPerf', 'Date', 'Date', 'driftConc', 'driftConc');
taskParam = struct('fieldNames', fieldNames, 'gParam', gParam);
condition = 'main';
taskData = GenerateOutcomes(taskParam, vola(1), sigma(1), condition);

hold on 
plot(practData.outcome, '.')
plot(practData.distMean, '--')

