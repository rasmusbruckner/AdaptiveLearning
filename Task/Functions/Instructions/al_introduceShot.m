function [taskData, taskParam] = al_introduceShot(taskParam, taskData, trial, txt)
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


% Show cannon and instructions
initRT_Timestamp = 0;


% Todo update using trialflow mouse vs. keyboard
if strcmp(taskParam.gParam.taskType, 'Sleep')

    [taskData, taskParam] = al_keyboardLoop(taskParam, taskData, trial, initRT_Timestamp, txt);

elseif strcmp(taskParam.gParam.taskType, 'Hamburg')
    
    % Participant indicates prediction
    press = 0;
    condition = 'main';
    [~, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, press, txt);

end

% Show cannonball
background = true; % show background image TODO: use trialflow
absTrialStartTime = GetSecs; % timestamp start of trial for timing
al_cannonball(taskParam, taskData, background, trial, absTrialStartTime)


% If cannonball and shield are presented together AND misses are animated
% show "explosion"
if isequal(taskParam.trialflow.shotAndShield, 'simultaneously')

    if (abs(al_diff(taskData.outcome(trial), taskData.pred(trial))) >=taskData.allASS(trial)/2) 
        taskData.hit(trial) = 0; % in this case, it was a miss
    else
        taskData.hit(trial) = 1; % in this case, it was a hit
    end

    % Animate miss
    tUpdated = GetSecs + 0.001; % timestamp for animation timing
    al_cannonMiss(taskParam, taskData, trial, background, tUpdated)

end

WaitSecs(0.1);

end