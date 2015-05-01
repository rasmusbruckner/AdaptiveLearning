% GenerateDataOnly


runIntro = true; % Run the intro with practice trials?
askSubjInfo = true; % Do you want some basic demographic subject variables?
oddball = false; % Run oddball or uncertainty version
sendTrigger = false; % Do you want to send triggers?
randomize = true; % Chooses cBal and reward condition automatically
shieldTrials =1; % Trials during the introduction (per condition). Für Pilot: 10
practTrials = 1; % Number of practice trials per condition. Für Pilot: 20
trials = 20;% Number of trials per (sigma-)condition. Für Pilot: 120 // EEG: 240
blockIndices = [1 60 120 180]; % When should new block begin?
vola = [.25 1 0]; % Volatility of the environment.
oddballProb = [.25 0]; % Oddball probability. .15
sigma = [10 12 99999999];  % [10 12 99999999] SD's of distribution.
driftConc = [30 99999999]; % Concentration of the drift. 10
safe = [3 0]; % How many guaranteed trials without change-points.
rewMag = 0.2; % Reward magnitude.
jitter = 0.2; % Set jitter.
test = false; % Test triggering timing accuracy (see PTB output CW).
debug = false; % Debug mode.

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
practData = GenerateOutcomes(taskParam, vola(1), sigma(1), condition);

hold on 
plot(practData.outcome, '.')
plot(practData.distMean, '--')

