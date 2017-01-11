function al_predictionSpotReversal(taskParam, xPredS,yPredS)


taskParam.circle.predCentSpotRect;
PredSpot = OffsetRect(taskParam.circle.predCentSpotRect, xPredS, yPredS);
Screen('FillOval', taskParam.gParam.window.onScreen, [255 165 0], PredSpot); %51 51 255


end