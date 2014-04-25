function PredictionSpot(taskParam)
%This function draws the prediction spot.

xPredS = (taskParam.rotationRad * cos(taskParam.rotAngle));
yPredS = (taskParam.rotationRad * sin(taskParam.rotAngle));
PredSpot = OffsetRect(taskParam.predCentSpotRect, xPredS, yPredS); 
Screen('FillOval', taskParam.window, [0 0 255], PredSpot); 
end

