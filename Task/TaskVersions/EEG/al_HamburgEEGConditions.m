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

% -----------------------------------------------------
% 0. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% Not yet included but relevant in future
cBal = taskParam.subject.cBal;
testDay = taskParam.subject.testDay;

% --------------------------------
% 1. Show instructions, if desired
% --------------------------------

if runIntro && ~unitTest
    al_HamburgEEGInstructions(taskParam)
end

% ------------
% 2. Main task
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

if cBal == 1

    % 1) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 2) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 3) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 4) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

elseif cBal == 2

        % 1) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 2) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 3) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);
    
    % 4) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);
    
elseif cBal == 3

    
    % 1) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 2) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 3) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 4) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

elseif cBal == 4

    % 1) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 2) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 3) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 4) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

elseif cBal == 5

    % 1) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 2) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 3) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 4) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

elseif cBal == 6

    % 1) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 2) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 3) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 4) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

elseif cBal == 7

    % 1) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 2) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 3) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 4) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

elseif cBal == 8

    % 1) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 2) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 3) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryPunishment = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % 4) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);


end
end