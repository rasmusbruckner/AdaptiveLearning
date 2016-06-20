function Aim(taskParam, parameter)

xPredS = ((taskParam.circle.rotationRad-5) * sin(parameter*taskParam.circle.unit));
yPredS = ((taskParam.circle.rotationRad-5) * (-cos(parameter*taskParam.circle.unit)));
OutcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS, yPredS);
x = (OutcSpot(3)/2) + (OutcSpot(1)/2);
y = (OutcSpot(4)/2) + (OutcSpot(2)/2);
Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], taskParam.gParam.zero(1), taskParam.gParam.zero(2), x, y, 2);

end

