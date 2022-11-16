function al_asymRewardInstructions(taskParam)
%AL_ASYMREWARDINSTRUCTIONS This function runs the instructions for the
% asymmetric-reward version of the confetti-cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       ~

% Extract test day and cBal variables
testDay = taskParam.subject.testDay;
cBal = taskParam.subject.cBal;

% Adjust trialflow
taskParam.trialflow.cannon = 'show cannon'; % cannon will be displayed
taskParam.trialflow.currentTickmarks = 'hide'; % tick marks initially not shown
taskParam.trialflow.push = 'practiceNoPush'; % turn off push manipulation

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% 1. Present welcome message
% --------------------------

al_indicateCondition(taskParam, 'Herzlich Willkommen Zur Konfetti-Kanonen-Aufgabe!\n\nDetaillierte Instruktionen folgen.')

% Reset background to gray
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);

end