function [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, startTimestamp, txt, breakKey)
%AL_MOUSELOOP This function manages the interaction between participants and the task via the computer mouse
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       condition: Current task condition
%       trial: Current trial
%       startTimestamp: Onset of prediction phase for computing RTs
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

% Extract screen coordinates
screensize = taskParam.display.screensize;

while 1

    % If no text as input, assume we're in the main task and just present
    % background if required
    if ~exist('txt', 'var') || isempty(txt)

        % Present background picture
        if isequal(taskParam.trialflow.background, 'picture')
            Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.textures.backgroundTxt,[], [], []);
        end

        % Otherwise present text and background together
    else
        al_lineAndBack(taskParam)
        DrawFormattedText(taskParam.display.window.onScreen,txt, taskParam.display.screensize(3)*0.1, taskParam.display.screensize(4)*0.05, [255 255 255], taskParam.strings.sentenceLength, [], [], taskParam.strings.vSpacing);
    end

    % If break key equals enter button, ask subject to press enter to continue
    if breakKey == taskParam.keys.enter
        DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter ,'center', taskParam.display.screensize(4)*0.9);
    end

    % Record mouse movements
    if ~taskParam.unitTest.run

        % Get current mouse coordinates
        [x,y,buttons] = GetMouse(taskParam.display.window.onScreen);

        %% This is a temporary implementation for the joystick which might be updated in the future
        if taskParam.gParam.uke

            % Raw joystick values -- the multiplication changes the
            % sensitivity of the joystick
            xRaw = axis(taskParam.gParam.joy,1)*0.5;
            yRaw = axis(taskParam.gParam.joy,2)*0.5;

            %% todo: proper parameters for min/max
            % Normalize current x and y values
            x = al_minMaxNormalization(xRaw, -0.3741, 0.6909);
            y = al_minMaxNormalization(yRaw, -0.8286, 0.6052);

            % Normalize biased center values
            xBiasCenterPix = al_minMaxNormalization(0, -0.3741, 0.6909) * screensize(3);
            yBiasCenterPix = al_minMaxNormalization(0, -0.8286, 0.6052) * screensize(4);

            % Normalize actual center values
            xCenterPix = al_minMaxNormalization(0.1584, -0.3741, 0.6909) * screensize(3);
            yCenterPix = al_minMaxNormalization(-0.1117, -0.8286, 0.6052) * screensize(4);

            % Correct current x and y
            x = x * screensize(3) + xCenterPix - xBiasCenterPix;
            y = y * screensize(4) + yCenterPix - yBiasCenterPix;

            % Same as for mouse input for psychtoolbox
            x = x-(screensize(3)/2);
            y = (y-(screensize(4)/2))*-1;

            % Check buttons
            buttons(2) = button(taskParam.gParam.joy, 1); % top
            buttons(1) = button(taskParam.gParam.joy, 3); % front

        else
            % Compute mouse x and y position given screen coordinates
            x = x-(screensize(3)/2);
            y = (y-(screensize(4)/2))*-1;
        end

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
        degree = taskParam.unitTest.pred(trial); % taskData.pred(trial);
    end

    % Translate degrees to rotation angle
    taskParam.circle.rotAngle = deg2rad(degree);

    % Show circle on screen
    al_drawCircle(taskParam)

    if strcmp(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(trial)
        if strcmp(taskParam.trialflow.cannonType, 'helicopter')
            % In helicopter version, show heli and heli aim
            al_showHelicopter(taskParam, taskData.distMean(trial))
            al_tickMark(taskParam, taskData.distMean(trial), 'aim');
        else
            % In regular versions, show cannon and cannon aim
            al_drawCannon(taskParam, taskData.distMean(trial))
            al_aim(taskParam, taskData.distMean(trial))
        end

    else
        % Optionally, show confetti cloud
        if isequal(taskParam.trialflow.confetti, 'show confetti cloud')
            Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
            al_drawFixPoint(taskParam)
        elseif isequal(condition, 'cannonPract1') == false ||  isequal(condition, 'cannonPract2') == false
            % Otherwise just fixation cross
            al_drawFixPoint(taskParam)
        end
    end

    % Show prediction spot
    if ~taskParam.unitTest.run

        % Check if prediction spot exceeds circle
        hyp = sqrt(x^2 + y^2);

        % If so, ensure that prediction spot sticks to circle
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
    if (hyp >= taskParam.circle.tendencyThreshold && isnan(taskData.initialTendency(trial))) || taskParam.unitTest.run

        % Initial degrees and initiation RT
        taskData.initialTendency(trial) = degree; %deg2rad(degree);
        taskData.initiationRTs(trial,:) = GetSecs() - startTimestamp;

        % Movement-onset trigger
        taskData.triggers(trial,2) = al_sendTrigger(taskParam, taskData, condition, trial, 'responseOnset');

    end

    % Optional instructions for cannon practice
    if isequal(condition, 'cannonPract1') || isequal(condition, 'cannonPract2')

        % Introduce cannon
        if taskParam.gParam.customInstructions
            cannonText = taskParam.instructionText.showCannonText;
            addCannonTxt = taskParam.instructionText.addCannonText;

        else
            cannonText = 'Bitte geben Sie an, wo Sie die Kanone vermuten.';
            addCannonTxt = ['\n\nDie grauen Striche zeigen die letzten Konfetti-Wolken.\n'...
                'Mit der Maus können Sie angeben, wo Sie die Kanone vermuten.'];
        end

        % Instruction text
        if isequal(condition, 'cannonPract1')
            cannonText = strcat(cannonText, addCannonTxt);
        end
        DrawFormattedText(taskParam.display.window.onScreen,cannonText, 'center', taskParam.display.screensize(4)*0.05, [255 255 255], taskParam.strings.sentenceLength, [], [], taskParam.strings.vSpacing);

        % Show subject's cannon estimate
        if isnan(taskData.initialTendency(trial)) == false
            alpha = 0.4;
            al_drawCannon(taskParam, degree, alpha, [100 100 100])
            al_aim(taskParam, degree)
        end
    end

    % Optionally, present tick marks
    if isequal(taskParam.trialflow.currentTickmarks, 'show') && trial > 1 && (taskData.block(trial) == taskData.block(trial-1))
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outc');
        al_tickMark(taskParam, taskData.pred(trial-1), 'pred');
    elseif isequal(taskParam.trialflow.currentTickmarks, 'workingMemory') && trial > 1 && (taskData.block(trial) == taskData.block(trial-1))
        al_showTickMarkSeries(taskData, taskParam, trial)
    elseif isequal(taskParam.trialflow.currentTickmarks, 'cannonPractice')
        al_showTickMarkSeries(taskData, taskParam, trial)
        al_tickMark(taskParam, taskData.pred(trial-1), 'pred');
    end

    % Flip screen and present changes
    t = GetSecs();
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    Screen('Flip', taskParam.display.window.onScreen, t + 0.001);

    % For unit test, we simulate RT = 0.5 in total (other half above)
    if taskParam.unitTest.run
        WaitSecs(0.25);
        hyp = taskParam.circle.rotationRad;
    end

    % For instructions, determine when to break out of the loop
    if breakKey == taskParam.keys.enter
        [keyIsDown, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
        if keyIsDown && keyCode(breakKey)
            break
        elseif taskParam.unitTest.run
            WaitSecs(1);
            break
        end
    elseif buttons(1) == 1 && hyp >= taskParam.circle.rotationRad-taskParam.circle.predSpotCircleTolerance % ensure that prediction is only possible when spot on circle

        taskData.pred(trial) = rad2deg(taskParam.circle.rotAngle);
        taskData.RT(trial) = GetSecs() - startTimestamp;

        % If initiation RT has not been stored (if button press occurs between check above and here [unlikely, but possible])
        if isnan(taskData.initiationRTs(trial))
            taskData.initialTendency(trial) = degree; %deg2rad(degree); %degree * taskParam.circle.unit;
            taskData.initiationRTs(trial) = taskData.RT(trial);
        end

        % Response trigger
        taskData.triggers(trial,3) = al_sendTrigger(taskParam, taskData, condition, trial, 'responseLogged');

        % Break out of loop
        break
    end

    % Check for escape key
    taskParam.keys.checkQuitTask(taskParam, taskData);

end
end