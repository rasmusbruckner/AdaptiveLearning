function [dataStandardTickmarks, dataAddTickmarks, dataStandardCannonVar, dataDriftingCannonVar] = al_varianceWorkingMemoryConditions(taskParam)
%AL_HAMBURGCONDITIONS This function runs the changepoint condition of the cannon
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
    al_VWMInstructions(taskParam)
end

Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);


% ------------
% 2. Main task
% ------------

% Note that days and cBal are not yet implemented.
% Will probably be done after first pilot

% ---------------------------------------
% 2.1 Standard task and tick-mark version
% ---------------------------------------

% Todo: save all data and select savename

% Extract number of trials
trial = taskParam.gParam.trials;

if cBal == 1


    % Standard cannon first...
    % ------------------------

    % Get data
    if ~unitTest


        % achtung nur test
        taskParam.trialflow.distMean = "drift";


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

    % ... high noise second
    % ---------------------

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

    % High noise first...
    % -------------------

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

    % ... low noise second
    % --------------------


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
% 2.2 Confetti-cannon task with mean and variability changepoints
% ---------------------------------------------------------------

taskParam.trialflow.currentTickmarks = "show";
%trialflow.distMean = "fixed"; %"drift";
taskParam.trialflow.variability = "changepoint";


% 11. Instructions experimental blocks
% ------------------------------------

header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Instruktionen mit Noise'];
% betonen, dass es cp und noise gibt aber keine hinweise


feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);


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


header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Instruktionen mit Drift und Noise'];
% betonen, dass es drift und noise gibt aber keine hinweise

feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);



%trialflow.currentTickmarks = "workingMemory";
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
dataDriftingCannonVar  = al_confettiLoop(taskParam, 'main', taskData, trial);


end