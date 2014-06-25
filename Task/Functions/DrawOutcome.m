function DrawOutcome(taskParam, outcome)
% This function draws the position of the outcome (the black bar).


OutcSpot = outcome - (taskParam.circle.outcSize/2);
zero = taskParam.gParam.zero;
Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - 115, zero(2) - 115, zero(1) + 115, zero(2) + 115],OutcSpot, taskParam.circle.outcSize, 30, [], []) %605 335 835 565

yNeedle = (taskParam.circle.rotationRad+22) * (-cos(outcome*taskParam.circle.unit));  
xNeedle = (taskParam.circle.rotationRad+22) * sin(outcome*taskParam.circle.unit);
yNeedle2 = (taskParam.circle.rotationRad-14) * (-cos(outcome*taskParam.circle.unit));      
xNeedle2 = (taskParam.circle.rotationRad-14) * sin(outcome*taskParam.circle.unit);

meanSpot = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle, yNeedle);
meanSpot2 = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle2, yNeedle2);
Screen('DrawLine', taskParam.gParam.window, [0 0 255], meanSpot2(1), meanSpot2(2), meanSpot(1), meanSpot(2), 4); %xNeedle, yNeedle  720, 450, 720 , 250


end

