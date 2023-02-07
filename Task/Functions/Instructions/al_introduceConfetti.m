function [taskData, taskParam] = al_introduceConfetti(taskParam, taskData, trial, txt)
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

% Todo update using trialflow mouse vs. keyboard
if strcmp(taskParam.gParam.taskType, 'Sleep')

    [taskData, taskParam] = al_keyboardLoop(taskParam, taskData, trial, initRT_Timestamp, txt);

elseif strcmp(taskParam.gParam.taskType, 'Hamburg') || strcmp(taskParam.gParam.taskType, 'asymReward') || strcmp(taskParam.gParam.taskType, 'Leipzig')
    
    % Participant indicates prediction
    press = 0;
    condition = 'main';
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, press, txt);

end

% Confetti animation    
background = true; % todo: include this in trialflow

% Extract current time and determine when screen should be flipped
% for accurate timing
timestamp = GetSecs;
al_confetti(taskParam, taskData, trial, background, timestamp);

WaitSecs(0.1);

end