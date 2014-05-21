function PredictionSpot(taskParam)
%This function draws the prediction spot.

xPredS = (taskParam.circle.rotationRad * cos(taskParam.circle.rotAngle));
yPredS = (taskParam.circle.rotationRad * sin(taskParam.circle.rotAngle));
PredSpot = OffsetRect(taskParam.circle.predCentSpotRect, xPredS, yPredS); 
Screen('FillOval', taskParam.gParam.window, [0 0 255], PredSpot); 
end

