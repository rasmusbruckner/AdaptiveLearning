function [dataMonetaryReward, dataMonetaryPunishment, dataSocialReward, dataSocialPunishment] = al_HamburgEEGConditions(taskParam)
%AL_HAMBURGEEGCONDITIONS This function runs the monetary and social
% conditions of the EEG confetti-cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataMonetaryReward: Task-data object monetary-reward condition
%       dataMonetaryPunishment: Task-data object monetary-punishment condition
%       dataSocialReward: Task-data object social-reward condition
%       dataSocialPunishment: Task-data object social-punishment condition
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
    al_HamburgEEGInstructions(taskParam)
end

% ------------
% 3. Main task
% ------------

% Extract number of trials
trial = taskParam.gParam.trials;

% Counterbalancing
% ----------------

% cBal = 1: ABCD
% 1) Monetary reward
% 2) Monetary punishment
% 3) Social reward
% 4) Social punishment

% cBal = 2: ABDC
% 1) Monetary reward
% 2) Monetary punishment
% 3) Social punishment
% 4) Social reward
%
% cBal = 3: BACD
% 1) Monetary punishment
% 2) Monetary reward
% 3) Social reward
% 4) Social punishment 
%
% cBal = 4: BADC
% 1) Monetary punishment
% 2) Monetary reward
% 3) Social punishment
% 4) Social reward

% cBal = 5: CDAB
% 1) Social reward
% 2) Social punishment
% 3) Monetary reward
% 4) Monetary punishment

% cBal = 6: CDBA
% 1) Social reward
% 2) Social punishment
% 3) Monetary punishment
% 4) Monetary reward

% cBal = 7: DCAB
% 1) Social punishment 
% 2) Social reward
% 3) Monetary reward
% 4) Monetary punishment
%
% cBal = 8: DCBA
% 1) Social punishment
% 2) Social reward
% 3) Monetary punishment
% 4) Monetary reward

% Generate data for each condition
% --------------------------------

% 1) Monetary reward

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataMonetaryReward = taskData.al_confettiData(taskParam);

% 2) Monetary punishment

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataMonetaryPunishment = taskData.al_confettiData(taskParam);

% 3) Social reward

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataSocialReward = taskData.al_confettiData(taskParam);

% 4) Social punishment

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataSocialPunishment = taskData.al_confettiData(taskParam);

if cBal == 1

    % 1) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryReward, trial);

    % 2) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryPunishment, trial);

    % 3) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskDataSocialReward, trial);

    % 4) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataSocialPunishment, trial);

elseif cBal == 2

    % 1) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryReward, trial);

    % 2) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryPunishment, trial);

    % 3) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataSocialPunishment, trial);
    
    % 4) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskDataSocialReward, trial);
    
elseif cBal == 3

    
    % 1) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryPunishment, trial);

    % 2) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryReward, trial);

    % 3) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskDataSocialReward, trial);

    % 4) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataSocialPunishment, trial);

elseif cBal == 4

    % 1) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryPunishment, trial);

    % 2) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryReward, trial);

    % 3) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataSocialPunishment, trial);

    % 4) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskDataSocialReward, trial);

elseif cBal == 5

    % 1) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskDataSocialReward, trial);

    % 2) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataSocialPunishment, trial);

    % 3) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryReward, trial);

    % 4) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryPunishment, trial);

elseif cBal == 6

    % 1) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskDataSocialReward, trial);

    % 2) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataSocialPunishment, trial);

    % 3) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryPunishment, trial);

    % 4) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryReward, trial);

elseif cBal == 7

    % 1) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataSocialPunishment, trial);

    % 2) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";
   
    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskDataSocialReward, trial);

    % 3) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryReward, trial);

    % 4) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryPunishment, trial);

elseif cBal == 8

    % 1) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataSocialPunishment, trial);

    % 2) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskDataSocialReward, trial);

    % 3) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryPunishment, trial);

    % 4) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryReward , trial);

end
end