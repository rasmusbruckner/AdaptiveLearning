function [dataMonetary, dataSocial] = al_confettiEEGConditions(taskParam)
%AL_CONFETTIEEGCONDITIONS This function runs the monetary and social
% conditions of the EEG confetti-cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataMonetary: Task-data object monetary condition
%       dataSocial: Task-data object social-reward condition
%
%  Todo: Write a unit test and integration test

% Screen background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% Shield style
taskParam.trialflow.shieldAppearance = 'lines';

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% Not yet included but relevant in future
cBal = taskParam.subject.cBal;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

if runIntro && ~taskParam.unitTest.run
    al_confettiEEGInstructions(taskParam)
end

% ------------
% 3. Main task
% ------------

% Extract number of trials
trial = taskParam.gParam.trials;

% Generate data for each condition
% --------------------------------

% 1) Monetary

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataMonetary = taskData.al_confettiData(taskParam);

% 2) Social

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataSocial = taskData.al_confettiData(taskParam);

if cBal == 1

    % 1) Monetary
    % -----------

    taskParam.trialflow.reward = "monetary";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetary = al_confettiEEGLoop(taskParam, 'main', taskDataMonetary, trial);

    % 2) Social
    % ---------

    taskParam.trialflow.reward = "social";

    % Run task
    al_indicateSocial(taskParam)
    dataSocial = al_confettiEEGLoop(taskParam, 'main', taskDataSocial, trial);

elseif cBal == 2

    % 1) Social
    % ---------

    taskParam.trialflow.reward = "social";

    % Run task
    al_indicateSocial(taskParam)
    dataSocial = al_confettiEEGLoop(taskParam, 'main', taskDataSocial, trial);

    % 2) Monetary
    % -----------

    taskParam.trialflow.reward = "monetary";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetary = al_confettiEEGLoop(taskParam, 'main', taskDataMonetary, trial);

else

    error('cBal value undefined')

end
end