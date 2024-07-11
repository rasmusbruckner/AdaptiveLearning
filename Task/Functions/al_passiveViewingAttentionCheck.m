function taskData = al_passiveViewingAttentionCheck(taskParam, taskData, currTrial)
%AL_PASSIVEVIEWINGATTENTIONCHECK This function runs the attention check
% for the passive viewing pupillometry task
%
%   Participants are required to press space when the fixation spot appears
%   as a black square in the fixation phase
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       currTrial: Current trial
%
%   Output
%       taskData: Task-data-object instance


% Initialize timer to control duration of this trial phase
timer = GetSecs();

% Sample when target is presented
randSample = rand;

% Initialize integer tracking key press (space)
spacePressed = false;

% Update display constantly
% -------------------------

while 1

    % Show confetti cloud
    Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);

    % Determine if target is shown or not
    if randSample < 0.3
        fixPoint = OffsetRect(taskParam.circle.fixSpotCentRect, 0, 0);
        Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.black, fixPoint) % [,color] [,rect]
        taskData.targetPresent(currTrial) = true;
    else
        al_drawFixPoint(taskParam)
        taskData.targetPresent(currTrial) = false;
    end

    % Draw circle
    al_drawCircle(taskParam)

    % Flip screen and present changes
    t = GetSecs();
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    Screen('Flip', taskParam.display.window.onScreen, t + 0.001);

    % Check for response of participant
    [ ~, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
    if keyCode(taskParam.keys.space) && spacePressed == false
        spacePressed = true;

        % Todo: we need time stamp for prediction

    elseif keyCode(taskParam.keys.esc)
        ListenChar();
        ShowCursor;
        Screen('CloseAll');
        error('User pressed Escape to finish task')
    end

    % Determine when to break out of while condition
    if GetSecs() - timer >= taskParam.timingParam.baselineFixLength
        if spacePressed && taskData.targetPresent(currTrial)
            taskData.targetCorr(currTrial) = 1;
        elseif spacePressed == false && taskData.targetPresent(currTrial) == false
            taskData.targetCorr(currTrial) = 1;
        else
            taskData.targetCorr(currTrial) = 0;
        end

        taskData.spacePressed(currTrial) = spacePressed;
        break
    end
end
end