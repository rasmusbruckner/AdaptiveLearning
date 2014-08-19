function Shield(taskParam, allASS, pred, color)
% This function draws the position of the outcome (the black bar).

if color == 1
    shieldColor = [0 0 255];
elseif color == 0
    shieldColor = [0 255 0];
end

rotRad = taskParam.circle.rotationRad + 10;
%OutcSpot = (allASS/2);
OutcSpot = pred - (allASS/2);
zero = taskParam.gParam.zero;
Screen('FrameArc',taskParam.gParam.window, shieldColor, [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],OutcSpot, allASS, 30, [], []) %605 335 835 565
                                                    %zero(1) - 115, zero(2) - 115, zero(1) + 115, zero(2) + 115
% yNeedle = (taskParam.circle.rotationRad+15) * (-cos(outcome*taskParam.circle.unit));  
% xNeedle = (taskParam.circle.rotationRad+15) * sin(outcome*taskParam.circle.unit);
% yNeedle2 = (taskParam.circle.rotationRad-25) * (-cos(outcome*taskParam.circle.unit));      
% xNeedle2 = (taskParam.circle.rotationRad-25) * sin(outcome*taskParam.circle.unit);
% 
% meanSpot = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle, yNeedle);
% meanSpot2 = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle2, yNeedle2);
% %Screen('DrawLine', taskParam.gParam.window, [0 0 0], meanSpot2(1), meanSpot2(2), meanSpot(1), meanSpot(2), 4);
% 

end

