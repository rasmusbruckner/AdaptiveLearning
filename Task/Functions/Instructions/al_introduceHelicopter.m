function [taskData, taskParam] = al_introduceHelicopter(taskParam, taskData, trial, txt)
%AL_INTRODUCESHOT This function introduces the shot of the cannon
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       trial: Current trial number
%       txt: Presented text
%
%   Output
%       taskData: Task-data-object instance
%       taskParam: Task-parameter-object instance

% Set time stamp
initRT_Timestamp = 0;

% Participant indicates prediction
press = 0;
condition = 'main';
[taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, press, txt);

% Confetti animation
background = true; % todo: include this in trialflow

% Extract current time and determine when screen should be flipped
% for accurate timing
timestamp = GetSecs;
al_supplies(taskParam, taskData, trial, background, timestamp);

WaitSecs(0.1);
end