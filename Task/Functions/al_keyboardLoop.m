function [] = al_keyboardLoop()
% Add comments!



while 1  
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        drawContext(taskParam, taskData.currentContext(i))
        al_drawCross(taskParam) 
    end
    al_drawCross(taskParam)
    al_predictionSpot(taskParam)

    if i ~= taskParam.gParam.blockIndices(1) && i ~= taskParam.gParam.blockIndices(2) + 1 && i ~= taskParam.gParam.blockIndices(3) + 1 && i ~= taskParam.gParam.blockIndices(4) + 1 && ~isequal(taskParam.gParam.taskType, 'chinese')

        al_tickMark(taskParam, taskData.outcome(i-1), 'outc')
        al_tickMark(taskParam, taskData.pred(i-1), 'pred')
        if isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'reversalPractice')
            al_tickMark(taskParam, taskParam.savedTickmark(i-1), 'saved')
        end 
    end

    if (taskData.catchTrial(i) == 1 && isequal(taskParam.gParam.taskType, 'dresden')) || isequal(condition,'followCannon') || isequal(condition,'followCannonPractice')...
            || isequal(condition,'shield') || isequal(condition, 'mainPractice_1') || isequal(condition, 'mainPractice_2') || isequal(condition, 'chinesePractice_1')...
            || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')

        Cannon(taskParam, taskData.distMean(i))
        al_aim(taskParam, taskData.distMean(i))
    elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'reversalPractice')  
        taskData.catchTrial(i) = 0;
    end

    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001); 
    taskData.timestampOnset(i,:) = GetSecs - ref;

    % Get initiation RT
    [ keyIsDown, ~, keyCode ] = KbCheck;

    % initationRTs is nan before first button press: save time
    % of button press. thereafter variable is not nan anymore
    % and not resaved.
    if keyIsDown && isnan(taskData.initiationRTs(i,:))

        if keyCode(taskParam.keys.rightKey) || keyCode(taskParam.keys.leftKey) || keyCode(taskParam.keys.rightSlowKey) || keyCode(taskParam.keys.leftSlowKey) || keyCode(taskParam.keys.space)
            taskData.initiationRTs(i,:) = GetSecs() - initRT_Timestamp;
        end

    elseif keyIsDown

        if keyCode(taskParam.keys.rightKey)
            if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle + 0.75*taskParam.circle.unit;
            else
                taskParam.circle.rotAngle = 0;
            end
        elseif keyCode(taskParam.keys.rightSlowKey)

            if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle + 0.1*taskParam.circle.unit;
            else
                taskParam.circle.rotAngle = 0;
            end
        elseif keyCode(taskParam.keys.leftKey)

            if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle - 0.75*taskParam.circle.unit;
            else
                taskParam.circle.rotAngle = 360*taskParam.circle.unit;
            end

        elseif keyCode(taskParam.keys.leftSlowKey)

            if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle - 0.1*taskParam.circle.unit;
            else
                taskParam.circle.rotAngle = 360*taskParam.circle.unit;
            end
        elseif keyCode(taskParam.keys.space)
            taskData.pred(i) = (taskParam.circle.rotAngle / taskParam.circle.unit);

            time = GetSecs;

            break

        end
    end

end
