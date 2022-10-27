function [dataNoPush, dataPush] = al_sleepConditions(taskParam)
%AL_SLEEPCONDITIONS This function runs the changepoint condition of the cannon
%   task tailored to the sleep version
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataNoPush: Task-data-object noPush condition
%       dataPush: Task-data-object push condition
%
%  Todo: Write a unit test and include this in integration tests

% -----------------------------------------------------
% 0. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
testDay = taskParam.subject.testDay;
cBal = taskParam.subject.cBal;

% --------------------------------
% 1. Show instructions, if desired
% --------------------------------

if runIntro && ~unitTest
    al_sleepInstructions(taskParam)
end

% ------------
% 2. Main task
% ------------

% Extract number of trials
trial = taskParam.gParam.trials;

% cBal and day combinations for order of conditions
% -------------------------------------------------

% cbal = 1:     cbal = 2:           cbal = 3:           cbal = 4:
%   day 1: np, p        day 1: np, p       day 1: p, np       day 1: p, np
%   day 2: np, p        day 2: p, np       day 2: p, np       day 2: np, p
%
% (day 1 & cbal 1), (day 1 & cbal 2), (day 2 % cbal 1), (day 2 & cbal 4)
% (day 2 & cbal 2), (day 1 % cbal 3), (day 2 & cbal 3), (day 1 & cbal 4)

% Implement conditions according to above-described schema
if (cBal == 1 && testDay == 1) ||...
        (cBal == 1 && testDay == 2) ||...
        (cBal == 2 && testDay == 1) ||...
        (cBal == 4 && testDay == 2)

    % No-push first...
    % ----------------

    % Get data
    if ~unitTest
        taskData = al_generateOutcomesMain(taskParam, haz, concentration, 'main');
    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    taskParam.trialflow.push = 'noPush';
    al_indicateNoise(taskParam)
    dataNoPush = al_sleepLoop(taskParam, 'main', taskData, trial);

    % ... push second
    % ---------------

    % Get data
    if ~unitTest
        taskData = al_generateOutcomesMain(taskParam, haz, concentration, 'main');
    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    taskParam.trialflow.push = 'push';
    al_indicateNoise(taskParam)
    dataPush = al_sleepLoop(taskParam, 'main', taskData, trial);

elseif (cBal == 2 && testDay == 2) ||...
        (cBal == 3 && testDay == 1) ||...
        (cBal == 3 && testDay == 2) ||...
        (cBal == 4 && testDay == 1)

    % Push first...
    % -------------

    % Get data
    if ~unitTest
        taskData = al_generateOutcomesMain(taskParam, haz, concentration, 'main');
    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    taskParam.trialflow.push = 'push';
    al_indicateNoise(taskParam)
    dataPush = al_sleepLoop(taskParam, 'main', taskData, trial);

    % ... no-push second
    % ------------------

    % Get data
    if ~unitTest
        taskData = al_generateOutcomesMain(taskParam, haz, concentration, 'main');
    else
        load('integrationTest_sleep.mat','taskData')
    end

    % Run task
    taskParam.trialflow.push = 'noPush';
    al_indicateNoise(taskParam)
    dataNoPush = al_sleepLoop(taskParam, 'main', taskData, trial);

end
end
