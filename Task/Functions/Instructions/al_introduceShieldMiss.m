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

% Todo update using trialflow mouse vs. keyboard
if strcmp(taskParam.gParam.taskType, 'Sleep')

    [taskData, taskParam] = al_keyboardLoop(taskParam, taskData, trial, initRT_Timestamp, txt);
    
    % Prediction error
    taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));
    
    % Show cannonball
    background = true;
    absTrialStartTime = GetSecs;
    al_cannonball(taskParam, taskData, background, trial, absTrialStartTime)

    varargout{1} = taskData;
    varargout{2} = taskParam;

elseif strcmp(taskParam.gParam.taskType, 'Hamburg')
    
    % Reset mouse to screen center
    SetMouse(720, 450, taskParam.display.window.onScreen)

    % Participant indicates prediction
    press = 0;
    condition = 'main';
    % i = 1;
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, press, txt);

    % Prediction error
    taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));
    
    % Confetti animation    
    background = true; % todo: include this in trialflow
    
    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs;
    fadeOutEffect = false;
    [xyExp, dotCol, dotSize] = al_confetti(taskParam, taskData, trial, background, timestamp, fadeOutEffect);
    
    varargout{1} = taskData;
    varargout{2} = taskParam;
    varargout{3} = xyExp;
    varargout{4} = dotCol;
    varargout{5} = dotSize;

end
end