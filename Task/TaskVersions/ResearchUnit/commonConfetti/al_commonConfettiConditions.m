function [dataLowNoise, dataHighNoise] = al_commonConfettiConditions(taskParam)
%AL_COMMONCONFETTICONDITIONS This function runs the changepoint condition of the cannon
%   task tailored to the common task shared across projects
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataLowNoise: Task-data object low-noise condition
%       dataHighNoise: Task-data object high-noise condition
%
%  Todo: Write a unit test and integration high/low noise in integration test

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
    al_commonConfettiInstructions(taskParam)
end

Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);

% ------------
% 3. Main task
% ------------

% Note that days and cBal are not yet implemented.
% Will probably be done after first pilot

% Extract number of trials
trial = taskParam.gParam.trials;

% Todo: ensure that outcome generation is done only once for each
% condition.. just order is adjusted. this will be especially 
% relevant to longer cBal cases such as Dresden or M/EEG


if cBal == 1


    % Low noise first...
    % ------------------

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial);

        % Generate outcomes using cannon-data function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

        % Generate outcomes using confetti-data function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    al_indicateNoise(taskParam, 'lowNoise')
    dataLowNoise = al_confettiLoop(taskParam, 'main', taskData, trial);

    % ... high noise second
    % ---------------------

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(2), taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
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
        load('integrationTest_Hamburg.mat','taskData')
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
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    al_indicateNoise(taskParam, 'lowNoise')
    dataHighNoise = al_confettiLoop(taskParam, 'main', taskData, trial);


end
end