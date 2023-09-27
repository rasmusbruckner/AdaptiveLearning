function al_predictionSpot(taskParam)
%AL_PREDICTIONSPOT This function displays the prediction spot
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       ~


% Compute coordinates of prediction spot
xPredS = ((taskParam.circle.rotationRad-5) * sin(taskParam.circle.rotAngle));
yPredS = ((taskParam.circle.rotationRad-5) * (-cos(taskParam.circle.rotAngle)));
predSpot = OffsetRect(taskParam.circle.predCentSpotRect, xPredS, yPredS);

% Display prediction spot
Screen('FillOval', taskParam.display.window.onScreen, taskParam.colors.blue, predSpot);

end