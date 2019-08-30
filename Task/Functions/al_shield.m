function al_shield(taskParam, allASS, pred, color)
%AL_SHIELD   This function draws the shield in the cannon task
%
%   Input
%       taskParam: structure containing task parameters
%       allASS: all angular shield size
%       pred: current prediction
%       color: color of printed shield
%
%   Output 
%       ~ 


if isequal(taskParam.gParam.taskType, 'dresden')
    
    % For Dresden version use gold and silver
    % --------------------------------------
    if color == 1
        shieldColor = taskParam.colors.gold;
    elseif color == 0
        shieldColor = taskParam.colors.silver;
    end
elseif isequal(taskParam.gParam.taskType, 'chinese')

    % For Chinese version use black
    % -----------------------------
    shieldColor = taskParam.colors.black;
else

    % For all other versions, use blue and green
    % ------------------------------------------
    if color == 1
        shieldColor = taskParam.colors.blue;
    elseif color == 0
        shieldColor = taskParam.colors.green;
    end
end

rotRad = taskParam.circle.rotationRad + 10;
OutcSpot = pred - (allASS/2);
zero = taskParam.gParam.zero;
Screen('FrameArc', taskParam.gParam.window.onScreen, shieldColor, [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], OutcSpot, allASS, 30, [], [])

end

