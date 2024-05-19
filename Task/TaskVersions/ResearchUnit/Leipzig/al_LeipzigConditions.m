function [dataLowNoise, dataHighNoise] = al_LeipzigConditions(taskParam)
%AL_LEIPZIGCONDITIONS This function runs the changepoint condition of the cannon
%   task tailored to the "Leipzig" version
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataLowNoise: Task-data object low-noise condition
%       dataHighNoise: Task-data object high-noise condition
%
%  Todo: Write a unit test and add high/low noise to integration test

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

if runIntro && ~taskParam.unitTest.run
    al_LeipzigInstructions(taskParam)
end

% ------------
% 3. Main task
% ------------

% Note that days and cBal are not yet implemented.
% Will probably be done after first pilot

% Extract number of trials
trial = taskParam.gParam.trials;

% Low noise first...
% ------------------

% Get data
if ~taskParam.unitTest.run

    % TaskData-object instance
    taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

else
    load('integrationTest_Hamburg.mat','taskData')
end

% Run task
al_indicateHelicopterNoise(taskParam, 'lowNoise')
dataLowNoise = al_LeipzigLoop(taskParam, 'main', taskData, trial);

% ... high noise second
% ---------------------

% Get data
if ~taskParam.unitTest.run

    % TaskData-object instance
    taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(2), taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

else
    load('integrationTest_Hamburg.mat','taskData')
end

% Run task
al_indicateHelicopterNoise(taskParam, 'highNoise')
dataHighNoise = al_LeipzigLoop(taskParam, 'main', taskData, trial);

end