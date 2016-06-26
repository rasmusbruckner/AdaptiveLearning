function DrawOutcome(taskParam, outcome)
%DRAWOUTCOME Prints the outcome spot

xPredS = ((taskParam.circle.rotationRad-5)...
    * sin(outcome*taskParam.circle.unit));
yPredS = ((taskParam.circle.rotationRad-5)...
    * (-cos(outcome*taskParam.circle.unit)));

OutcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS, yPredS);
Screen('FillOval', taskParam.gParam.window.onScreen, [0 0 0], OutcSpot);
end


