function [taskData, taskParam] = al_keyboardLoop(taskParam, taskData, trial, startTimestamp, txt, breakKey, disableResponseThreshold)
%AL_KEYBOARDLOOP This function implementens the participants' interaction
% with the cannon task via the keyboard
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       trial: Current trial number
%       startTimestamp: Onset of prediction phase for computing initRT
%       text: Presented text
%       breakKey: Key code to lock prediction
%       disableResponseThreshold: Optionally activate response time
%                                 limit (if additionally specified in trialflow)
%
%   Ouptut
%       taskData: Task-parameter-object instance
%       taskParam: Task-data-object instance


% Manage optional breakKey input: if not provided, use SPACE as default
if ~exist('breakKey', 'var') || isempty(breakKey)
    breakKey = taskParam.keys.space;
end

% Check for optional response-threshold input:
% By default, threshold not active, independent of trialflow
% That way, instructions are without time limit
if ~exist('disableResponseThreshold', 'var') || isempty(disableResponseThreshold)
    disableResponseThreshold = true;
end

% -------------------------------------------------------------
% 1. If push condition, sample push from von Mises distribution
% -------------------------------------------------------------

if trial == 1 || strcmp(taskParam.trialflow.push, 'practiceNoPush')
    taskData.z(trial) = rad2deg(taskParam.circle.rotAngle);
    taskData.y(trial) = 0;
elseif trial > 1 && strcmp(taskParam.trialflow.push, 'push')
    if ~taskParam.unitTest.run
        taskData.z(trial) = taskData.sampleOutcome(taskData.pred(trial-1), taskParam.gParam.pushConcentration);
    else
        if rem(trial, 2) == 0
            taskData.z(trial) = taskData.pred(trial-1) + 10;
        else
            taskData.z(trial) = taskData.pred(trial-1) - 10;
        end
    end
    taskData.y(trial) = al_diff(taskData.z(trial), taskData.pred(trial-1));
    taskParam.circle.rotAngle = deg2rad(taskData.z(trial));
else
    taskData.z(trial) = taskData.pred(trial-1);
    taskData.y(trial) = 0;
end

% -------------------------------------------------------
% 2. Update prediction spot until prediction is confirmed
% -------------------------------------------------------

% Keyboard settings for MD scanner
if taskParam.gParam.scanner
    RestrictKeysForKbCheck([taskParam.keys.rightKey, taskParam.keys.leftRelease, ...
        taskParam.keys.rightRelease, taskParam.keys.leftKey, taskParam.keys.space, taskParam.keys.esc]);
    KbQueueCreate
    KbQueueStart
end

% Initialize key codes with zeros
keyCode = zeros(1, 256);

while 1

    % If no text as input, assume we're in the main task and just present
    % background if required
    if ~exist('txt', 'var') || isempty(txt)

        % Present background picture, if required
        if isequal(taskParam.trialflow.background, 'picture')
            Screen('FillRect', taskParam.display.window.onScreen, [0 0 0]); % black background
            Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.backgroundTxt, [], taskParam.display.backgroundCoords, []); % texture
        end

        % Otherwise present text and background together
    else
        al_lineAndBack(taskParam)
        sentenceLength = taskParam.strings.sentenceLength;
        DrawFormattedText(taskParam.display.window.onScreen,txt, taskParam.display.screensize(3)*0.1, taskParam.display.screensize(4)*0.05, [255 255 255], sentenceLength);
    end

    % If break key equals enter button, ask subject to press enter to continue
    if breakKey == taskParam.keys.enter
        DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter ,'center', taskParam.display.screensize(4)*0.9);
    end

    % Present circle and prediction spot
    al_drawCircle(taskParam)
    al_predictionSpot(taskParam)

    % If requested, show cannon and cannon aim, otherwise fixation cross
    if (taskData.catchTrial(trial) == 1) || isequal(taskParam.trialflow.cannon, 'show cannon')
        al_drawCannon(taskParam, taskData.distMean(trial))
        al_aim(taskParam, taskData.distMean(trial))
    else
        al_drawCross(taskParam)
    end

    % Optionally, present tick marks
    if isequal(taskParam.trialflow.currentTickmarks, 'show') && trial > 1 && (taskData.block(trial) == taskData.block(trial-1))

        al_tickMark(taskParam, taskData.outcome(trial-1), 'outc');
        al_tickMark(taskParam, taskData.pred(trial-1), 'pred');
    end

    % Tell PTB that all elements have been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    t = GetSecs;
    Screen('Flip', taskParam.display.window.onScreen, t + 0.001);

    % Update location of prediction spot depending on participant input
    [breakLoop, taskParam, taskData, keyCode] = al_controlPredSpotKeyboard(taskParam, taskData, trial, startTimestamp, breakKey, keyCode, disableResponseThreshold);

    % Break out of while condition if prediction has been confirmed
    if breakLoop == true
        break
    end

    % Check for escape key 
    taskParam.keys.checkQuitTask();

end

% Relax restrictions for scanner after prediction
if taskParam.gParam.scanner

    KbQueueStop
    RestrictKeysForKbCheck([]);

end

end

