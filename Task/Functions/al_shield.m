function al_shield(taskParam, allASS, pred, color)
%AL_SHIELD This function draws the shield in the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%       allASS: All angular shield size
%       pred: Current prediction
%       color: Color of displayed shield
%
%   Output
%       None

if color == 1
    shieldColor = taskParam.colors.winColor;
elseif color == 0
    shieldColor = taskParam.colors.neutralColor;
end


rotRad = taskParam.circle.rotationRad + taskParam.circle.shieldOffset; %10;
OutcSpot = pred - (allASS/2);
zero = taskParam.display.zero;
Screen('FrameArc', taskParam.display.window.onScreen, shieldColor, [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], OutcSpot, allASS, taskParam.circle.shieldWidth, [], [])

end

