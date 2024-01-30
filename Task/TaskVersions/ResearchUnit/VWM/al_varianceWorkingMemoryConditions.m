function [dataStandardTickmarks, dataAddTickmarks, dataStandardCannonVar, dataDriftingCannonVar, dataDriftingCannonVarWM] = al_varianceWorkingMemoryConditions(taskParam)
%AL_VARIANCEWORKINGMEMORYONDITIONS This function runs the changepoint condition of the cannon
%   task tailored to the "Hamburg" version
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataStandardTickmarks: Task-data object standard tick mark
%       dataAddTickmarks: Task-data object multiple tick marks
%       dataStandardCannonVar Task-data object change point + variance
%       dataDriftingCannonVar: Task-data object drift + variance
%       dataDriftingCannonVarWM: Task-data object drift + variance + multiple tick marks
%
%  Todo: Write a unit test and integrate high/low noise in integration test

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
cBal = taskParam.subject.cBal;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

if runIntro && ~unitTest
    al_VWMInstructions(taskParam)
end

% Gray background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);

% -------------------------------------
% 3. Standard task and tick-mark version
% -------------------------------------

% Extract number of trials
trial = taskParam.gParam.trials;

% Standard change-point task first
taskParam.trialflow.distMean = "fixed";
taskParam.trialflow.variability = "stable";

if cBal == 1

    % 1. Standard cannon
    % -----------------

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial);

        % Generate outcomes using cannonData function
            taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    taskParam.trialflow.currentTickmarks = "show";

    al_indicateCannonType(taskParam)
    dataStandardTickmarks = al_confettiLoop(taskParam, 'main', taskData, trial);

    % 2. Working memory version
    % ------------------------

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    taskParam.trialflow.currentTickmarks = "workingMemory";
    al_indicateCannonType(taskParam)
    dataAddTickmarks = al_confettiLoop(taskParam, 'main', taskData, trial);

else

    % 1 Working memory version
    % ------------------------

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    taskParam.trialflow.currentTickmarks = "workingMemory";
    al_indicateCannonType(taskParam)
    dataAddTickmarks = al_confettiLoop(taskParam, 'main', taskData, trial);

    % 2 Standard cannon
    % -----------------

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    taskParam.trialflow.currentTickmarks = "show";

    al_indicateCannonType(taskParam)
    dataStandardTickmarks = al_confettiLoop(taskParam, 'main', taskData, trial);

end

% --------------------------------------------------------------
% 4. Confetti-cannon task with mean and variability changepoints
% --------------------------------------------------------------

taskParam.trialflow.currentTickmarks = "show";
taskParam.trialflow.variability = "changepoint";
taskParam.trialflow.currentTickmarks = "show";
taskParam.trialflow.distMean = "fixed";

% Get data
if ~unitTest

    % TaskData-object instance
    taskData = al_taskDataMain(trial);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(2:3), taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

else
    load('integrationTest_Hamburg.mat','taskData')
end

% Run task
al_indicateCannonType(taskParam)
dataStandardCannonVar = al_confettiLoop(taskParam, 'main', taskData, trial);

% ----------------------------------
% 5. Confetti-cannon task with drift 
% ----------------------------------

if cBal == 1

    % 1. One tick mark, variability change points, and mean change points 
    % -------------------------------------------------------------------

    taskParam.trialflow.distMean = "drift";
    taskParam.trialflow.variability = "changepoint";
    taskParam.trialflow.currentTickmarks = "show";

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(2:3), taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    al_indicateCannonType(taskParam)
    dataDriftingCannonVar = al_confettiLoop(taskParam, 'main', taskData, trial);

    % 2. Multiple tick marks, no variability change points, and mean change points
    % ----------------------------------------------------------------------------

    taskParam.trialflow.distMean = "drift";
    taskParam.trialflow.variability = "stable";
    taskParam.trialflow.currentTickmarks = "workingMemory";

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    al_indicateCannonType(taskParam)
    dataDriftingCannonVarWM = al_confettiLoop(taskParam, 'main', taskData, trial);

else

    % 1. Multiple tick marks, no variability change points, and mean change points
    % ----------------------------------------------------------------------------

    taskParam.trialflow.distMean = "drift";
    taskParam.trialflow.variability = "stable";
    taskParam.trialflow.currentTickmarks = "workingMemory";

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    al_indicateCannonType(taskParam)
    dataDriftingCannonVarWM = al_confettiLoop(taskParam, 'main', taskData, trial);

    % 2. One tick mark, variability change points, and mean change points 
    % -------------------------------------------------------------------

    taskParam.trialflow.distMean = "drift";
    taskParam.trialflow.variability = "changepoint";
    taskParam.trialflow.currentTickmarks = "show";

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(2:3), taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    al_indicateCannonType(taskParam)
    dataDriftingCannonVar = al_confettiLoop(taskParam, 'main', taskData, trial);

end
end