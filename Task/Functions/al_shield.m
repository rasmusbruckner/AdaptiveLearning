function al_shield(taskParam, allASS, pred, color)
%SHIELD   Draws the shield in the cannon task


%if taskParam.gParam.oddball == false
if isequal(taskParam.gParam.taskType, 'dresden')
    if color == 1
        shieldColor = taskParam.colors.gold;
    elseif color == 0
        shieldColor = taskParam.colors.silver;
    end
    
elseif isequal(taskParam.gParam.taskType, 'chinese')
    shieldColor = taskParam.colors.black;
else
    if color == 1
        shieldColor = taskParam.colors.blue;
    elseif color == 0
        shieldColor = taskParam.colors.green;
    end
end

rotRad = taskParam.circle.rotationRad + 10;
OutcSpot = pred - (allASS/2);
zero = taskParam.gParam.zero;
Screen('FrameArc',taskParam.gParam.window.onScreen, shieldColor, [zero(1)...
    - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],...
    OutcSpot, allASS, 30, [], [])

end

