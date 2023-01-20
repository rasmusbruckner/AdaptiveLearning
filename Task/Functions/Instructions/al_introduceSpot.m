% function [taskData, taskParam, xyExp] = al_introduceSpot(taskParam, taskData, trial, txt)
function varargout = al_introduceSpot(taskParam, taskData, trial, txt)
%AL_INTRODUCESPOT This function introduces the orange spot to participants
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

% Reference value to compute initiation RT
initRT_Timestamp = GetSecs(); 

% Todo update using trialflow mouse vs. keyboard
if strcmp(taskParam.gParam.taskType, 'Sleep')

    % Show cannon and instructions
    [taskData, taskParam] = al_keyboardLoop(taskParam, taskData, trial, initRT_Timestamp, txt);

    % Prediction error
    taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));
    
    % Show cannonball
    background = true; % show background image TODO: maybe via trialflow
    absTrialStartTime = GetSecs; % timestamp start of trial for timing
    al_cannonball(taskParam, taskData, background, trial, absTrialStartTime)

    % If cannonball and shield are presented together AND misses are animated
    % show "explosion"
    if isequal(taskParam.trialflow.shotAndShield, 'simultaneously') && (abs(taskData.predErr(trial)) >=9)  % todo: parameterize
    
        % Animate miss
        taskData.hit(trial) = 0; % in this case, it was a miss
        tUpdated = GetSecs + 0.001; % timestamp for animation timing
        al_cannonMiss(taskParam, taskData, trial, background, tUpdated)
    end

    varargout{1} = taskData;
    varargout{2} = taskParam;

elseif strcmp(taskParam.gParam.taskType, 'Hamburg') || isequal(taskParam.gParam.taskType, 'asymReward')
    
    % Reset mouse to screen center
    SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen) % 720, 450,

    % Participant indicates prediction
    press = 0;
    condition = 'main';
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, press, txt);

    % Prediction error
    taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));
    
    % Confetti animation    
    background = true; % todo: include this in trialflow
    
    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs;
    fadeOutEffect = false;
    [~, xyExp, dotCol, dotSize] = al_confetti(taskParam, taskData, trial, background, timestamp, fadeOutEffect);
    
    varargout{1} = taskData;
    varargout{2} = taskParam;
    varargout{3} = xyExp;
    varargout{4} = dotCol;
    varargout{5} = dotSize;

end
end
