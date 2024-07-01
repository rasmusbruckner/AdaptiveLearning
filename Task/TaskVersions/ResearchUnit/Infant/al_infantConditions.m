function [dataInfantBlock1, dataInfantBlock2] = al_infantConditions(taskParam)
%AL_INFANTCONDITIONS This function runs the duck-pond conditions
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataInfantBlock1: Task-data object block 1
%       dataInfantBlock2: Task-data object block 2


% Screen background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% Extract concentration
concentration = taskParam.gParam.concentration;

% Update trial flow
taskParam.trialflow.shot = 'static';
taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.trialflow.exp = 'exp';

% ------------
% Main task
% ------------

% Total number of trials: practice (habituation) + exp (test trials)
trial = taskParam.gParam.practTrials + taskParam.gParam.trials;

% Todo: test-trial order currently depends on cBal only;
% we will additionally make it dependent on order here (block 1 vs. 2)

% Run task block 1
taskParam.trialflow.exp = 'block1';
dataInfantBlock1 = al_infantLoop(taskParam, 'main', concentration, trial);

% Run task block 2
al_bigScreen(taskParam, ' ', 'Zweiter Durchgang', true, true);
taskParam.trialflow.exp = 'block2';
dataInfantBlock2 = al_infantLoop(taskParam, 'main', concentration, trial);

end