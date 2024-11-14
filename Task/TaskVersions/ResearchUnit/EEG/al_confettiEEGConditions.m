function [dataMonetary, dataSocial] = al_confettiEEGConditions(taskParam)
%AL_CONFETTIEEGCONDITIONS This function runs the monetary and social
% conditions of the EEG confetti-cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataMonetary: Task-data object monetary condition
%       dataSocial: Task-data object social-reward condition
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
    al_confettiEEGInstructions(taskParam)
end

% Ensure data is saved on pressing escape
taskParam.trialflow.saveData = 'true';

% ------------
% 3. Main task
% ------------

% Extract number of trials
trial = taskParam.gParam.trials;

% Generate data for each condition
% --------------------------------

% 1) Monetary

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataMonetary = taskData.al_confettiData(taskParam);

% 2) Social

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataSocial = taskData.al_confettiData(taskParam);

if cBal == 1

    % 1) Monetary
    % -----------

    if taskParam.subject.startsWithBlock == 1
        taskParam.trialflow.reward = "monetary";
        file_name_suffix = '_b1';

        % Run task
        al_indicateSocial(taskParam)
        dataMonetary = al_confettiEEGLoop(taskParam, 'main', taskDataMonetary, trial, file_name_suffix);
    else
        dataMonetary.accPerf = 0;
    end

    % 2) Social
    % ---------

    if taskParam.subject.startsWithBlock == 1 || taskParam.subject.startsWithBlock == 2
        taskParam.trialflow.reward = "social";
        file_name_suffix = '_b2';

        % Run task
        al_indicateSocial(taskParam)
        dataSocial = al_confettiEEGLoop(taskParam, 'main', taskDataSocial, trial, file_name_suffix);
    else
        dataSocial.accPerf = 0;
    end

elseif cBal == 2

    % 1) Social
    % ---------

    if taskParam.subject.startsWithBlock == 1
        taskParam.trialflow.reward = "social";
        file_name_suffix = '_b1';

        % Run task
        al_indicateSocial(taskParam)
        dataSocial = al_confettiEEGLoop(taskParam, 'main', taskDataSocial, trial, file_name_suffix);
    
    else 
        dataSocial.accPerf = 0;
    end

    % 2) Monetary
    % -----------

    if taskParam.subject.startsWithBlock == 1 || taskParam.subject.startsWithBlock == 2
        taskParam.trialflow.reward = "monetary";
        file_name_suffix = '_b2';

        % Run task
        al_indicateSocial(taskParam)
        dataMonetary = al_confettiEEGLoop(taskParam, 'main', taskDataMonetary, trial, file_name_suffix);
    else
        dataMonetary.accPerf = 0;
    end
else

    error('cBal value undefined')

end
end