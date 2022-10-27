function dataMain = al_HamburgConditions(taskParam)
%AL_HAMBURGCONDITIONS This function runs the changepoint condition of the cannon
%   task tailored to the "Hamburg" version
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataMain: Task-data object
%
%  Todo: Write a unit test and include this in integration tests

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
    al_HamburgInstructions(taskParam)
end

% ------------
% 2. Main task
% ------------

% Note that days and cBal are not yet implemented.
% Will probably be done after first pilot

% Extract number of trials
trial = taskParam.gParam.trials;

% Get data
taskData = al_generateOutcomesMain(taskParam, haz, concentration, 'main');

% Run task
dataMain = al_confettiLoop(taskParam, 'main', taskData, trial);

end