function PredictionSpot(taskParam)
%This function draws the prediction spot and works with sine and cosine
%in order to print it on a circle. 

%xPredS = (taskParam.circle.rotationRad * cos(taskParam.circle.rotAngle));
%yPredS = (taskParam.circle.rotationRad * sin(taskParam.circle.rotAngle));

xPredS = (taskParam.circle.rotationRad * sin(taskParam.circle.rotAngle));
yPredS = (taskParam.circle.rotationRad * (-cos(taskParam.circle.rotAngle)));

PredSpot = OffsetRect(taskParam.circle.predCentSpotRect, xPredS, yPredS); 
Screen('FillOval', taskParam.gParam.window, [0 0 255], PredSpot); 
end

