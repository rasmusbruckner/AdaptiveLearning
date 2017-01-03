function predictionSpot(taskParam)
%PREDICTIONSPOT   Prints the prediction spot

xPredS = ((taskParam.circle.rotationRad-5)...
    * sin(taskParam.circle.rotAngle ));
yPredS = ((taskParam.circle.rotationRad-5)...
    * (-cos(taskParam.circle.rotAngle)));
PredSpot = OffsetRect(taskParam.circle.predCentSpotRect, xPredS, yPredS);
Screen('FillOval', taskParam.gParam.window.onScreen, [255 165 0], PredSpot);
end

