function [dataLowNoise, dataHighNoise] = al_asymRewardConditions(taskParam)
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
    al_asymRewardInstructions(taskParam)
end

% ------------
% 2. Main task
% ------------

% Note that days and cBal are not yet implemented.
% Will probably be done after first pilot

% Extract number of trials
trial = taskParam.gParam.trials;

if cBal == 1


    % Low noise first...
    % ------------------

    % Get data
    if ~unitTest
        taskData = al_generateOutcomesMain(taskParam, haz, concentration(1), 'main');
    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    al_indicateNoise(taskParam, 'lowNoise')
    dataLowNoise = al_confettiLoop(taskParam, 'main', taskData, trial);

    % ... high noise second
    % ---------------------


    % Get data
    if ~unitTest
        taskData = al_generateOutcomesMain(taskParam, haz, concentration(2), 'main');
    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    al_indicateNoise(taskParam, 'highNoise')
    dataHighNoise = al_confettiLoop(taskParam, 'main', taskData, trial);

else

    % High noise first...
    % -------------------

    % Get data
    if ~unitTest
        taskData = al_generateOutcomesMain(taskParam, haz, concentration(2), 'main');
    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    al_indicateNoise(taskParam, 'highNoise')
    dataLowNoise = al_confettiLoop(taskParam, 'main', taskData, trial);

    % ... low noise second
    % --------------------


    % Get data
    if ~unitTest
        taskData = al_generateOutcomesMain(taskParam, haz, concentration(1), 'main');
    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    al_indicateNoise(taskParam, 'lowNoise')
    dataHighNoise = al_confettiLoop(taskParam, 'main', taskData, trial);


end
end