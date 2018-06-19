function al_drawOutcome(taskParam, outcome)
%DRAWOUTCOME Prints the outcome spot

xPredS = ((taskParam.circle.rotationRad-5) * sin(outcome*taskParam.circle.unit));
yPredS = ((taskParam.circle.rotationRad-5) * (-cos(outcome*taskParam.circle.unit)));
OutcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS, yPredS);

if isequal(taskParam.gParam.taskType, 'chinese')
    Screen('FillOval', taskParam.gParam.window.onScreen, [165 42 42], OutcSpot);
else
    Screen('FillOval', taskParam.gParam.window.onScreen, [0 0 0], OutcSpot);
end
end


