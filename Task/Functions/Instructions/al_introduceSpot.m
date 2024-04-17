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

if ~strcmp(taskParam.gParam.taskType, 'Leipzig')
    al_drawCross(taskParam)
end

al_drawCircle(taskParam)

% Tell PTB that everything has been drawn and flip screen
tUpdated = GetSecs;
Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
Screen('Flip', taskParam.display.window.onScreen, tUpdated + 0.1, 1);
WaitSecs(0.5);

% Reference value to compute initiation RT
initRT_Timestamp = GetSecs();

if strcmp(taskParam.trialflow.input, 'keyboard')

    % Show cannon and instructions
    [taskData, taskParam] = al_keyboardLoop(taskParam, taskData, trial, initRT_Timestamp, txt);

    % Prediction error
    taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));

    % Difference prediction and last outcome
    taskData.diffLastOutcPred(trial) = al_diff(taskData.pred(trial), taskData.outcome(trial-1));

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

elseif strcmp(taskParam.trialflow.input, 'mouse') && strcmp(taskParam.trialflow.cannonType, "confetti")

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
    varargout{2} = taskParam; % todo: necessary?
    varargout{3} = xyExp;
    varargout{4} = dotSize;

elseif strcmp(taskParam.gParam.taskType, 'Leipzig') && strcmp(taskParam.trialflow.cannonType, "helicopter")

    % Reset mouse to screen center
    SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen) % 720, 450,

    % Participant indicates prediction
    condition = 'main';
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, txt);

    % Prediction error
    taskData.predErr(trial) = al_diff(taskData.outcome(trial), taskData.pred(trial));

    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs;
    background = true; % todo: include this in trialflow
    [~, xyExp] = al_supplies(taskParam, taskData, trial, background, timestamp);

    % Function output
    varargout{1} = taskData;
    varargout{2} = taskParam;
    varargout{3} = xyExp;
    
end
end
