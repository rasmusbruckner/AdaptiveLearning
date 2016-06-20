function Aim(taskParam, parameter)
%AIM   Prints the aim (as a needle) of the cannon

xPredS = ((taskParam.circle.rotationRad-5) *...
    sin(parameter*taskParam.circle.unit));
yPredS = ((taskParam.circle.rotationRad-5) *...
    (-cos(parameter*taskParam.circle.unit)));
outcomeCenter = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS,...
    yPredS);
x = (outcomeCenter(3)/2) + (outcomeCenter(1)/2);
y = (outcomeCenter(4)/2) + (outcomeCenter(2)/2);
Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0],...
    taskParam.gParam.zero(1), taskParam.gParam.zero(2), x, y, 2);

end

