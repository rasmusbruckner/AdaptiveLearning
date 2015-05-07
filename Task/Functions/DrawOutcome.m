function DrawOutcome(taskParam, outcome)
% This function draws the position of the outcome (the black bar).

% rotRad = taskParam.circle.rotationRad + 10;
% OutcSpot = outcome -(taskParam.circle.outcSize/2);
% zero = taskParam.gParam.zero;
% Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],OutcSpot, taskParam.circle.outcSize, 30, [], []) %605 335 835 565
%         


%keyboard

xPredS = ((taskParam.circle.rotationRad-5) * sin(outcome*taskParam.circle.unit));
yPredS = ((taskParam.circle.rotationRad-5) * (-cos(outcome*taskParam.circle.unit)));

OutcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS, yPredS);
Screen('FillOval', taskParam.gParam.window, [0 0 0], OutcSpot);
end


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

%end

