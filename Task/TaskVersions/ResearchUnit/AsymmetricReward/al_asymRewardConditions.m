function [dataStandard, dataAsymmetricReward] = al_asymRewardConditions(taskParam)
%AL_ASYMREWARDCONDITIONS This function runs the changepoint condition of the cannon
%   task tailored to the asymmetric-reward version by Jan Gläscher
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataLowNoise: Task-data object low-noise condition
%       dataHighNoise: Task-data object high-noise condition
%
%  Todo: Write a unit test and integratio high/low noise in integration test

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% Not yet included but relevant in future
cBal = taskParam.subject.cBal;
testDay = taskParam.subject.testDay;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

if runIntro && ~taskParam.unitTest.run
    al_asymRewardInstructions(taskParam)
end

% ------------
% 3. Main task
% ------------

% Note that days and cBal are not yet implemented.
% Will probably be done after first pilot

% Extract number of trials
trial = taskParam.gParam.trials;

if cBal == 1


    % Standard task first...
    % ----------------------
    
    taskParam.trialflow.reward = 'standard';
    taskParam.gParam.saveName = 'standard';

    % Get data
    if ~taskParam.unitTest.run

        % TaskData-object instance
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam, haz, concentration, taskParam.gParam.safe);

    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    al_indicateReward(taskParam)
    dataStandard = al_confettiLoop(taskParam, 'main', taskData, trial);

    % ... asymmetric-reward task second
    % ---------------------------------

    taskParam.trialflow.reward = 'asymmetric';
    taskParam.gParam.saveName = 'asymmetric';


    % Get data
    if ~taskParam.unitTest.run

        % TaskData-object instance
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam, haz, concentration, taskParam.gParam.safe);

    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    al_indicateReward(taskParam)
    dataAsymmetricReward = al_confettiLoop(taskParam, 'main', taskData, trial);

else

    % Asymmetric-reward task first...
    % -------------------------------

    taskParam.trialflow.reward = 'asymmetric';
    taskParam.gParam.saveName = 'asymmetric';

    % Get data
    if ~taskParam.unitTest.run

        % TaskData-object instance
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam, haz, concentration, taskParam.gParam.safe);

    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    al_indicateReward(taskParam)
    dataAsymmetricReward = al_confettiLoop(taskParam, 'main', taskData, trial);

    % ... standard task second
    % ------------------------

    taskParam.trialflow.reward = 'standard';
    taskParam.gParam.saveName = 'standard';

    
    % Get data
    if ~taskParam.unitTest.run

        % TaskData-object instance
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam, haz, concentration, taskParam.gParam.safe);

    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    al_indicateReward(taskParam)
    dataStandard = al_confettiLoop(taskParam, 'main', taskData, trial);

end
end