function [taskData, taskParam] = al_introduceSpot(taskParam, taskData, trial, txt)
%INTRODUCESPOT   This function introduces the orange spot to participants
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


% Present background, cross, and circle
al_lineAndBack(taskParam)
al_drawCross(taskParam)
al_drawCircle(taskParam)

% Todo: add trialflow
if isequal(taskParam.gParam.taskType, 'chinese')
    currentContext = 1;
    al_drawContext(taskParam, currentContext)
end

% Tell PTB that everything has been drawn and flip screen
tUpdated = GetSecs;
Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
Screen('Flip', taskParam.display.window.onScreen, tUpdated + 0.1, 1);
WaitSecs(0.5);

% Show cannon and instructions
initRT_Timestamp = GetSecs(); % reference value to compute initiation RT
[taskData, taskParam] = al_keyboardLoop(taskParam, taskData, trial, initRT_Timestamp, txt);

% Prediction error
taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));

% Show cannonball
background = true; % show background image TODO: maybe via trialflow
absTrialStartTime = GetSecs; % timestamp start of trial for timing
al_cannonball(taskParam, taskData, background, trial, absTrialStartTime)

% If cannonball and shield are presented together AND misses are animated
% show "explosion"
if isequal(taskParam.trialflow.shotAndShield, 'simultaneously') && (abs(taskData.predErr(trial)) >=9)  % todo. parameterize

    % Animate miss
    taskData.hit(trial) = 0; % in this case, it was a miss
    tUpdated = GetSecs + 0.001; % timestamp for animation timing
    al_cannonMiss(taskParam, taskData, trial, background, tUpdated)

end
end
