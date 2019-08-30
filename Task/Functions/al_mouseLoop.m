function [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp, press)
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


while 1
    
    [x,y,buttons] = GetMouse(taskParam.gParam.window.onScreen);
    
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
        al_drawContext(taskParam,taskData.currentContext(i))
        al_drawCross(taskParam)
        
        if taskParam.gParam.showCue 
            if i == 1 || taskParam.gParam.cueAllTrials == true
                al_showCue(taskParam, taskData.latentState(i))
            elseif taskParam.gParam.cueAllTrials == false && i > 1 && taskData.latentState(i) ~= taskData.latentState(i-1)
                al_showCue(taskParam, taskData.latentState(i))
            end
        end
    elseif isequal(condition,'shield') || isequal(condition, 'mainPractice_1') || isequal(condition, 'mainPractice_2') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
        
        if isequal(taskParam.gParam.taskType, 'chinese')
            al_drawContext(taskParam,taskData.currentContext(i))
            al_drawCross(taskParam)
        end
        al_drawCannon(taskParam, taskData.distMean(i), taskData.latentState(i))
        al_aim(taskParam, taskData.distMean(i))
    else
        al_drawCross(taskParam)
    end
    
    if (taskData.catchTrial(i) == 1 && isequal(condition, 'onlinePractice'))
        al_drawCannon(taskParam, taskData.distMean(i), taskData.latentState(i))
        al_aim(taskParam, taskData.distMean(i))
        txt = 'As you can now directly see the cannon, you should move your orange spot exactly to aim of the cannon!';
        sentenceLength = taskParam.gParam.sentenceLength;
        DrawFormattedText(taskParam.gParam.window.onScreen, txt, 'center', 50, [255 255 255], sentenceLength);
        
    elseif (taskData.catchTrial(i) == 1 && isequal(taskParam.gParam.taskType, 'ARC'))
        
        al_drawCannon(taskParam, taskData.distMean(i), taskData.latentState(i))
        al_aim(taskParam, taskData.distMean(i))
        
    end
    
    hyp = sqrt(x^2 + y^2);
    if hyp <= 150
        al_predictionSpotReversal(taskParam, x ,y*-1)
    else
        al_predictionSpot(taskParam)
    end
    
    if hyp >= taskParam.circle.tendencyThreshold && isnan(taskData.initialTendency(i))
        taskData.initialTendency(i) = degree;
        taskData.initiationRTs(i,:) = GetSecs() - initRT_Timestamp;
    end
    
    if ~isequal(taskParam.gParam.taskType, 'chinese') || ~isequal(taskParam.gParam.taskType, 'ARC')
        if  (buttons(2) == 1 && i ~= taskParam.gParam.blockIndices(1) && i ~= taskParam.gParam.blockIndices(2) + 1 && i ~= taskParam.gParam.blockIndices(3) + 1 && i ~= taskParam.gParam.blockIndices(4) + 1)
            
            taskData.savedTickmark(i) = ((taskParam.circle.rotAngle)/taskParam.circle.unit);
            WaitSecs(0.2);
            press = 1;
            
        elseif i > 1 && press == 0
            taskData.savedTickmarkPrevious(i) = taskData.savedTickmarkPrevious(i - 1);
            taskData.savedTickmark(i) = taskData.savedTickmark(i - 1);
        elseif i == 1
            taskData.savedTickmarkPrevious(i) = 0;
        end
        
        if press == 1
            
            taskData.savedTickmarkPrevious(i) = taskData.savedTickmark(i-1);
        end
    end
    
    % Manage tickmarks
    if taskParam.gParam.showTickmark == true %&& ~isequal(condition,'shield') %&& ~isequal(condition,'mainPractice_1') && ~isequal(condition,'mainPractice_2')
        if i ~= taskParam.gParam.blockIndices(1)&& i ~= taskParam.gParam.blockIndices(2) && i ~= taskParam.gParam.blockIndices(3) && i ~= taskParam.gParam.blockIndices(4)    %+1
            if ~isequal(taskParam.gParam.taskType, 'chinese')
                
                
                al_tickMark(taskParam, taskData.outcome(i-1), 'outc');
                al_tickMark(taskParam, taskData.pred(i-1), 'pred');
            end
            
            if ~isequal(taskParam.gParam.taskType, 'chinese')
                if press == 1
                    al_tickMark(taskParam, taskData.savedTickmarkPrevious(i), 'update');
                end
                al_tickMark(taskParam, taskData.savedTickmark(i), 'saved');
            end
            
        end
    end
    
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    t = GetSecs;
    
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
    
    if ((~isequal(condition,'ARC_controlSpeed') && buttons(1) == 1) || (isequal(condition,'ARC_controlSpeed') && hyp >= 150)) || ((~isequal(condition,'ARC_controlAccuracy') && buttons(1) == 1)...
            || (isequal(condition,'ARC_controlAccuracy') && hyp >= 150)) || ((~isequal(condition,'ARC_controlPractice') && buttons(1) == 1) || (isequal(condition,'ARC_controlPractice') && hyp >= 150))
        taskData.pred(i) = ((taskParam.circle.rotAngle) / taskParam.circle.unit);
        taskData.pred(i);
        
        taskData.RT(i) = GetSecs() - initRT_Timestamp;
        break
        
    end
    
end
end