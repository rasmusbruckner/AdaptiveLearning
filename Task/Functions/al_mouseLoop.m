function [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, press, txt, breakKey)
%AL_MOUSELOOP   This function manages the interaction between participants and the task via the computer mouse 
%
%   Input
%       taskParam: structure containing task paramters
%       taskData: structure containing task data
%       condition: noise condition type
%       i: trial index
%       initRT_Timestamp: initiation reaction time
%       press: indext if mouse button has been pressed
%
%   Output
%       taskData: structure containing task data
%       taskParam: structure containing task paramters


% Todo: needs to be properly cleaned and commented. Also integrate
% trialflow. Get rid of al_instrLoopTxt when this is finished.
% well.

if ~exist('breakKey', 'var') ||  isempty(breakKey)
    breakKey = nan;  
end

[~, ~] = RectCenter(taskParam.display.windowRect);

while 1

    % If no text as input, assume we're in the main task and just present
    % background if required
    if ~exist('txt', 'var') ||  isempty(txt)

        % Present background picture, if required
        if isequal(taskParam.trialflow.background, 'picture')
            Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.textures.backgroundTxt,[], [], []);
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

    [x,y,buttons] = GetMouse(taskParam.display.window.onScreen);
    
    % todo: this can be updated so that mouse cursor and dot are perfectly
    % overlapping (in task mouse cursor is hidden, so not relevant to subject)
    x = x-720;
    y = (y-450)*-1;
    
    currentDegree = mod(atan2(y,x) .* -180./-pi, -360 )*-1 + 90;
    if currentDegree > 360
        degree = currentDegree - 360;
    else
        degree = currentDegree;
    end
    taskParam.circle.rotAngle = degree * taskParam.circle.unit;
    
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese') && ~isequal(condition,'shield') && ~isequal(condition, 'chinesePractice_1') && ~isequal(condition, 'chinesePractice_2') && ~isequal(condition, 'chinesePractice_3')
        al_drawContext(taskParam,taskData.currentContext(trial))
        al_drawCross(taskParam)
        
        if taskParam.gParam.showCue 
            if trial == 1 || taskParam.gParam.cueAllTrials == true
                al_showCue(taskParam, taskData.latentState(trial))
            elseif taskParam.gParam.cueAllTrials == false && trial > 1 && taskData.latentState(trial) ~= taskData.latentState(trial-1)
                al_showCue(taskParam, taskData.latentState(trial))
            end
        end
    elseif isequal(condition,'shield') || isequal(condition, 'mainPractice_1') || isequal(condition, 'mainPractice_2') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
        
        if isequal(taskParam.gParam.taskType, 'chinese')
            al_drawContext(taskParam,taskData.currentContext(trial))
            al_drawCross(taskParam)
        end
        al_drawCannon(taskParam, taskData.distMean(trial), taskData.latentState(trial))
        al_aim(taskParam, taskData.distMean(trial))
    elseif strcmp(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(trial)
       al_drawCannon(taskParam, taskData.distMean(trial))
       al_aim(taskParam, taskData.distMean(trial))
    else

        if isequal(taskParam.trialflow.confetti, 'show confetti cloud')
            [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
            %Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, center, 1); 
            Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1); 
            al_drawCross(taskParam)
        else
            al_drawCross(taskParam)
        end
    end
 
%     if isequal(taskParam.trialflow.confetti, 'show confetti cloud')
%         [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
%         %Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, center, 1); 
%         Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1); 
% 
%         al_drawCross(taskParam)
% 
%     end
    

    % todo: check if still in use
    if (taskData.catchTrial(trial) == 1 && isequal(condition, 'onlinePractice'))
        al_drawCannon(taskParam, taskData.distMean(trial), taskData.latentState(trial))
        al_aim(taskParam, taskData.distMean(trial))
        txt = 'As you can now directly see the cannon, you should move your orange spot exactly to aim of the cannon!';
        sentenceLength = taskParam.gParam.sentenceLength;
        DrawFormattedText(taskParam.gParam.window.onScreen, txt, 'center', 50, [255 255 255], sentenceLength);
        
    elseif (taskData.catchTrial(trial) == 1 && isequal(taskParam.gParam.taskType, 'ARC'))
        
        al_drawCannon(taskParam, taskData.distMean(trial), taskData.latentState(trial))
        al_aim(taskParam, taskData.distMean(trial))
        
    end
    
    hyp = sqrt(x^2 + y^2);
    if hyp <= taskParam.circle.rotationRad-2 %150 % todo: parameterize using circle size
        al_predictionSpotReversal(taskParam, x ,y*-1)
    else
        al_predictionSpot(taskParam)
    end
    
    if hyp >= taskParam.circle.tendencyThreshold && isnan(taskData.initialTendency(trial))
        taskData.initialTendency(trial) = degree;  % todo: save in radians for consistency
        taskData.initiationRTs(trial,:) = GetSecs() - initRT_Timestamp;
    end
    
    if ~isequal(taskParam.gParam.taskType, 'chinese') || ~isequal(taskParam.gParam.taskType, 'ARC')
        if  (buttons(2) == 1 && trial ~= taskParam.gParam.blockIndices(1) && trial ~= taskParam.gParam.blockIndices(2) + 1 && trial ~= taskParam.gParam.blockIndices(3) + 1 && trial ~= taskParam.gParam.blockIndices(4) + 1)
            
            taskData.savedTickmark(trial) = ((taskParam.circle.rotAngle)/taskParam.circle.unit);
            WaitSecs(0.2);
            press = 1;
            
        %elseif i > 1 && press == 0
            % Todo: re-implement when working on reversal version again
            %taskData.savedTickmarkPrevious(i) = taskData.savedTickmarkPrevious(i - 1);
            %taskData.savedTickmark(i) = taskData.savedTickmark(i - 1);
        %elseif i == 1
            % Todo: re-implement when working on reversal version again
            % taskData.savedTickmarkPrevious(i) = 0;
        end
        
        if press == 1
            
            taskData.savedTickmarkPrevious(trial) = taskData.savedTickmark(trial-1);
        end
    end
    
    % Optionally, present tick marks
    if isequal(taskParam.trialflow.currentTickmarks, 'show') && trial > 1 && (taskData.block(trial) == taskData.block(trial-1))

        al_tickMark(taskParam, taskData.outcome(trial-1), 'outc')
        al_tickMark(taskParam, taskData.pred(trial-1), 'pred')

        % Todo: Test this new version with trialflow object instance for
        % reversal task
        if isequal(taskParam.trialflow.savedTickmark, 'show')
            al_tickMark(taskParam, taskParam.savedTickmark(trial-1), 'saved')
        end
    end

    t = GetSecs();
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    
    Screen('Flip', taskParam.display.window.onScreen, t + 0.001);
    
    if breakKey == taskParam.keys.enter
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && keyCode(breakKey)
            break
        end
    elseif ((~isequal(condition,'ARC_controlSpeed') && buttons(1) == 1) || (isequal(condition,'ARC_controlSpeed') && hyp >= 150)) || ((~isequal(condition,'ARC_controlAccuracy') && buttons(1) == 1)...
            || (isequal(condition,'ARC_controlAccuracy') && hyp >= 150)) || ((~isequal(condition,'ARC_controlPractice') && buttons(1) == 1) || (isequal(condition,'ARC_controlPractice') && hyp >= 150))
        taskData.pred(trial) = ((taskParam.circle.rotAngle) / taskParam.circle.unit);
        taskData.RT(trial) = GetSecs() - initRT_Timestamp;
        break
    elseif isequal(condition, 'chinese') && isequal(taskParam.gParam.useTrialConstraints, 'aging') && (GetSecs() - initRT_Timestamp>3)
        
        taskData.pred(trial) = nan;
        taskData.RT(trial) = nan;
        break
    end
    
end
end