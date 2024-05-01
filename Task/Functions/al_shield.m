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


% Shield color
if color == 1
    shieldColor = taskParam.colors.winColor;
elseif color == 0
    shieldColor = taskParam.colors.neutralColor;
end

% Size
OutcSpot = pred - (allASS/2);
zero = taskParam.display.zero;

% Generate shield
if isequal(taskParam.trialflow.shieldAppearance, 'full')
    rotRad = taskParam.circle.rotationRad + taskParam.circle.shieldOffset;
    Screen('FrameArc', taskParam.display.window.onScreen, shieldColor, [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], OutcSpot, allASS, taskParam.circle.shieldWidth, [], [])
elseif isequal(taskParam.trialflow.shieldAppearance, 'reduced')
    rotRad = taskParam.circle.rotationRad - 25;
    Screen('FrameArc', taskParam.display.window.onScreen, shieldColor, [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], OutcSpot, allASS, 4, [], [])
    rotRad = taskParam.circle.rotationRad + 22;
    Screen('FrameArc', taskParam.display.window.onScreen, shieldColor, [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], OutcSpot, allASS, 4, [], [])
    al_tickMark(taskParam, pred-allASS/2, 'shield');
    al_tickMark(taskParam, pred+allASS/2, 'shield');
elseif isequal(taskParam.trialflow.shieldAppearance, 'lines')
    al_tickMark(taskParam, pred-allASS/2, 'shield');
    al_tickMark(taskParam, pred+allASS/2, 'shield');
else
    error('ShieldAppearance not defined')
end

