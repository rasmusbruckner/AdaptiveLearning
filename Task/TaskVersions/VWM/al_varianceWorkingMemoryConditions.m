function [dataStandardTickmarks, dataAddTickmarks, dataStandardCannonVar, dataDriftingCannonVar] = al_varianceWorkingMemoryConditions(taskParam)
%AL_VARIANCEWORKINGMEMORYONDITIONS This function runs the changepoint condition of the cannon
%   task tailored to the "Hamburg" version
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
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% Not yet included but relevant in future
cBal = taskParam.subject.cBal;
testDay = taskParam.subject.testDay;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

if runIntro && ~unitTest
    al_VWMInstructions(taskParam)
end

Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);


% ------------
% 3. Main task
% ------------

% Note that days and cBal are not yet implemented.
% Will probably be done after first pilot

% ---------------------------------------
% 3.1 Standard task and tick-mark version
% ---------------------------------------

% Todo: save all data and select savename

% Extract number of trials
trial = taskParam.gParam.trials;

if cBal == 1

    % 1) Standard cannon
    % ------------------

    % Get data
    if ~unitTest

        taskParam.trialflow.distMean = "fixed";

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
    
    al_indicateTickMark(taskParam)
    dataStandardTickmarks = al_confettiLoop(taskParam, 'main', taskData, trial);

    % 2) Working memory version 
    % -------------------------

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
    al_indicateTickMark(taskParam)
    dataAddTickmarks = al_confettiLoop(taskParam, 'main', taskData, trial);

else

    % 1) Working memory version 
    % -------------------------

    % Get data
    if ~unitTest
        taskData = al_generateOutcomesMain(taskParam, haz, concentration(1), 'main');
    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    taskParam.trialflow.currentTickmarks = "workingMemory";
    al_indicateTickMark(taskParam)
    dataAddTickmarks = al_confettiLoop(taskParam, 'main', taskData, trial);

    % 2) Standard cannon
    % ------------------


    % Get data
    if ~unitTest
        taskData = al_generateOutcomesMain(taskParam, haz, concentration(1), 'main');
    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    taskParam.trialflow.currentTickmarks = "show";
    al_indicateTickMark(taskParam)
    dataStandardTickmarks = al_confettiLoop(taskParam, 'main', taskData, trial);

end

% ---------------------------------------------------------------
% 3.2 Confetti-cannon task with mean and variability changepoints
% ---------------------------------------------------------------

taskParam.trialflow.currentTickmarks = "show";
taskParam.trialflow.variability = "changepoint";

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
taskParam.trialflow.currentTickmarks = "show";
al_indicateCannonType(taskParam)
dataStandardCannonVar = al_confettiLoop(taskParam, 'main', taskData, trial);

% ---------------------------------------------------------------------------------------
% 2.3 Confetti-cannon task with mean drift (no changepoints) and variability changepoints
% ---------------------------------------------------------------------------------------

taskParam.trialflow.distMean = "drift";
taskParam.trialflow.variability = "changepoint";

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
taskParam.trialflow.currentTickmarks = "show";
al_indicateCannonType(taskParam)
dataDriftingCannonVar = al_confettiLoop(taskParam, 'main', taskData, trial);


end