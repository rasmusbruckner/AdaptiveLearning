function [dataMonetaryReward, dataSocialReward] = al_HamburgEEGConditions(taskParam)
%AL_HAMBURGEEGCONDITIONS This function runs the changepoint condition of
%the EEG confetti-cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataMonetaryReward: Task-data object monetary-reward condition
%       dataSocialReward: Task-data object social-reward condition
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

% Note that days and cBal are not yet implemented.
% Will probably be done after first pilot

% Extract number of trials
trial = taskParam.gParam.trials;

if cBal == 1


    % Monetary reward first...
    % ------------------------

    taskParam.trialflow.reward = "monetary";


    % Get data
    % if ~unitTest
    taskData = al_generateOutcomesMain(taskParam, haz, concentration, 'main');
    % else
    %     load('integrationTest_Hamburg.mat','taskData')
    % end

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % ... social reward second
    % ------------------------

    taskParam.trialflow.reward = "social";


    % Get data
    % if ~unitTest
    taskData = al_generateOutcomesMain(taskParam, haz, concentration, 'main');
    % else
    %     load('integrationTest_Hamburg.mat','taskData')
    % end

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

else

    % Social reward first...
    % ----------------------

    taskParam.trialflow.reward = "social";

    % Get data
    % if ~unitTest
    taskData = al_generateOutcomesMain(taskParam, haz, concentration, 'main');
    % else
    %     load('integrationTest_Hamburg.mat','taskData')
    % end

    % Run task
    al_indicateSocial(taskParam)
    dataMonetaryReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);

    % ... monetary reward second
    % --------------------------

    taskParam.trialflow.reward = "monetary";


    % Get data
    % if ~unitTest
    taskData = al_generateOutcomesMain(taskParam, haz, concentration, 'main');
    % else
    %     load('integrationTest_Hamburg.mat','taskData')
    % end

    % Run task
    al_indicateSocial(taskParam)
    dataSocialReward = al_confettiEEGLoop(taskParam, 'main', taskData, trial);


end
end