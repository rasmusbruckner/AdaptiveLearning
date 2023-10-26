function [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, txt, breakKey)
%AL_MOUSELOOP This function manages the interaction between participants and the task via the computer mouse
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       condition: Current task condition
%       trial: Current trial
%       initRT_Timestamp: Tnitiation reaction time
%       txt: Instructions text
%       breakKey: Key to break out of the loop
%
%   Output
%       taskData: Task-parameter-object instance
%       taskParam: Task-data-object instance


% Key to get out of the loop
if ~exist('breakKey', 'var') ||  isempty(breakKey)
    breakKey = nan;
end

while 1

    % If no text as input, assume we're in the main task and just present
    % background if required
    if ~exist('txt', 'var') ||  isempty(txt)

        % Present background picture
        if isequal(taskParam.trialflow.background, 'picture')
            Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.textures.backgroundTxt,[], [], []);
        end

        % Otherwise present text and background together
    else
        al_lineAndBack(taskParam)
        DrawFormattedText(taskParam.display.window.onScreen,txt, taskParam.display.screensize(3)*0.1, taskParam.display.screensize(4)*0.05, [255 255 255], taskParam.strings.sentenceLength);
    end

    % If break key equals enter button, ask subject to press enter to continue
    if breakKey == taskParam.keys.enter
        DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter ,'center', taskParam.display.screensize(4)*0.9);
    end

    % Record mouse movements
    if ~taskParam.unitTest

        % Get current mouse coordinates
        [x,y,buttons] = GetMouse(taskParam.display.window.onScreen);

        % Extract screen coordinates
        screensize = taskParam.display.screensize;

        % Compute mouse x and y position given screen coordinates
        x = x-(screensize(3)/2);
        y = (y-(screensize(4)/2))*-1;

        % Translate x and y coordinates to degrees
        currentDegree = mod(atan2(y,x) .* -180./-pi, -360 )*-1 + 90;
        if currentDegree > 360
            degree = currentDegree - 360;
        else
            degree = currentDegree;
        end

        % For unit test: simulate keyIsDown, keyCode, and record prediction
    else
        buttons(1) = 1;
        buttons(2) = 0;
        degree = taskData.pred(trial);
    end

    % Translate degrees to rotation angle
    taskParam.circle.rotAngle = degree * taskParam.circle.unit;

    % Show circle on screen
    al_drawCircle(taskParam)

    if strcmp(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(trial)
        if strcmp(taskParam.trialflow.cannonType, 'helicopter')
            % In helicopter version, show heli and heli aim
            al_showHelicopter(taskParam, taskData.distMean(trial))
            al_tickMark(taskParam, taskData.distMean(trial), 'aim')
        else
            % In regular versions, show cannon and cannon aim
            al_drawCannon(taskParam, taskData.distMean(trial))
            al_aim(taskParam, taskData.distMean(trial))
        end

    else
        % Optionally, show confetti cloud
        if isequal(taskParam.trialflow.confetti, 'show confetti cloud')
            [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud(); % load pre-generated particles
            Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
            al_drawCross(taskParam)
        else
            % Otherwise just fixation cross
            al_drawCross(taskParam)
        end
    end

    % Todo: potentially move up when working on ARC again
    if (taskData.catchTrial(trial) == 1 && isequal(taskParam.gParam.taskType, 'ARC'))
        al_drawCannon(taskParam, taskData.distMean(trial), taskData.latentState(trial))
        al_aim(taskParam, taskData.distMean(trial))
    end

    % Show prediction spot
    if ~taskParam.unitTest

        % Check if prediction spot exceeds circle
        hyp = sqrt(x^2 + y^2);

        % If so, ensure that prediction spot sticks to cicle
        if hyp <= taskParam.circle.rotationRad-2
            al_predictionSpotSticky(taskParam, x ,y*-1)
            % Otherwise move freely within circle
        else
            al_predictionSpot(taskParam)
        end
    else
        % For unit test, simulate prediction spot
        al_predictionSpot(taskParam)
        WaitSecs(0.25);
        hyp = nan;
    end

    % Store initial tendency and initiation RT:
    % Only entering the condition when no initial tendency has been
    % recorded (first movement) or unit testing
    if (hyp >= taskParam.circle.tendencyThreshold && isnan(taskData.initialTendency(trial))) || taskParam.unitTest
        taskData.initialTendency(trial) = degree * taskParam.circle.unit;
        taskData.initiationRTs(trial,:) = GetSecs() - initRT_Timestamp;
    end

    % Optionally, present tick marks
    if isequal(taskParam.trialflow.currentTickmarks, 'show') && trial > 1 && (taskData.block(trial) == taskData.block(trial-1))
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outc')
        al_tickMark(taskParam, taskData.pred(trial-1), 'pred')
    end

    % Flip screen and present changes
    t = GetSecs();
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    Screen('Flip', taskParam.display.window.onScreen, t + 0.001);

    % For unit test, we simulate RT = 0.5 in total (other half above)
    if taskParam.unitTest
        WaitSecs(0.25);
    end

    % For instructions, determine when to break out of the loop
    if breakKey == taskParam.keys.enter
        [keyIsDown, ~, keyCode] = KbCheck( taskParam.keys.kbDev );
        if keyIsDown && keyCode(breakKey)
            break
        end
        % Todo: Trialflow
    elseif ((~isequal(condition,'ARC_controlSpeed') && buttons(1) == 1) || (isequal(condition,'ARC_controlSpeed') && hyp >= 150)) || ((~isequal(condition,'ARC_controlAccuracy') && buttons(1) == 1)...
            || (isequal(condition,'ARC_controlAccuracy') && hyp >= 150)) || ((~isequal(condition,'ARC_controlPractice') && buttons(1) == 1) || (isequal(condition,'ARC_controlPractice') && hyp >= 150))
        taskData.pred(trial) = ((taskParam.circle.rotAngle) / taskParam.circle.unit);
        taskData.RT(trial) = GetSecs() - initRT_Timestamp;
        break
    end

end
end