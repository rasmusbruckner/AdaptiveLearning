function varargout = al_introduceShieldMiss(taskParam, taskData, trial, txt)
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

al_drawCircle(taskParam)
if ~strcmp(taskParam.gParam.taskType, 'Leipzig')
    al_drawCross(taskParam)
end

% Tell PTB that everything has been drawn and flip screen
tUpdated = GetSecs;
Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
Screen('Flip', taskParam.display.window.onScreen, tUpdated + 0.1, 1);

% Short delay
WaitSecs(0.5);

% Show cannon and instructions
initRT_Timestamp = GetSecs(); % reference value to compute initiation RT

% Todo update using trialflow mouse vs. keyboard
% and explosion only optionally
if strcmp(taskParam.gParam.taskType, 'sleep') || strcmp(taskParam.gParam.taskType, 'dresden') || strcmp(taskParam.gParam.taskType, 'MagdeburgFMRI')

    [taskData, taskParam] = al_keyboardLoop(taskParam, taskData, trial, initRT_Timestamp, txt);
    
    % Prediction error
    taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));
    
    % Difference prediction and last outcome
    taskData.diffLastOutcPred(trial) = al_diff(taskData.pred(trial), taskData.outcome(trial-1));

    % Show cannonball
    background = true;
    absTrialStartTime = GetSecs;
    al_cannonball(taskParam, taskData, background, trial, absTrialStartTime)

    varargout{1} = taskData;
    varargout{2} = taskParam;

elseif strcmp(taskParam.gParam.taskType, 'Hamburg') || strcmp(taskParam.gParam.taskType, 'HamburgEEG')
% Todo: share more code between Hamburg and Leipzig here. Major difference
% is task loop
    
    % Reset mouse to screen center
    SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen) % 720, 450,

    % Participant indicates prediction
    condition = 'main';
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, txt);

    % Prediction error
    taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));
    
    % Confetti animation    
    background = true; % todo: include this in trialflow
    
    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs;
    fadeOutEffect = false;
    [taskData, xyExp, dotSize] = al_confetti(taskParam, taskData, trial, background, timestamp, fadeOutEffect);

    varargout{1} = taskData;
    varargout{2} = taskParam;
    varargout{3} = xyExp;
    varargout{4} = dotSize;


elseif strcmp(taskParam.gParam.taskType, 'Leipzig')
    
    % Reset mouse to screen center
    SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen) % 720, 450,

    % Participant indicates prediction
    condition = 'main';
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, txt);

    % Prediction error
    taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));
    
    % Confetti animation    
    background = true; % todo: include this in trialflow
    
    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs;
    [~, xyExp] = al_supplies(taskParam, taskData, trial, background, timestamp);
    
    varargout{1} = taskData;
    varargout{2} = taskParam;
    varargout{3} = xyExp;

end
end