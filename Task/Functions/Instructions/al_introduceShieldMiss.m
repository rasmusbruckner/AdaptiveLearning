function [taskData, taskParam] = al_introduceShieldMiss(taskParam, taskData, trial, txt)
%AL_INTRODUCESHIELDMISS This function introduces cannonball misses while showing shield to participant
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       trial: Current trial number
%       txt: Presented text
%
%   Output
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance

% Present background, cross, and circle
al_lineAndBack(taskParam)

% todo: update with trialflow
if isequal(taskParam.gParam.taskType, 'chinese')
    currentContext = 1;
    al_drawContext(taskParam, currentContext)
    al_drawCross(taskParam);
end
al_drawCross(taskParam)
al_drawCircle(taskParam)

% Tell PTB that everything has been drawn and flip screen
tUpdated = GetSecs;
Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
Screen('Flip', taskParam.display.window.onScreen, tUpdated + 0.1, 1);

% Short delay
WaitSecs(0.5);

% Show cannon and instructions
initRT_Timestamp = GetSecs(); % reference value to compute initiation RT
[taskData, taskParam] = al_keyboardLoop(taskParam, taskData, trial, initRT_Timestamp, txt);

% Prediction error
taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));

% Show cannonball
background = true;
absTrialStartTime = GetSecs;
al_cannonball(taskParam, taskData, background, trial, absTrialStartTime)

end