function al_predictionSpot(taskParam)
%AL_PREDICTIONSPOT This function displays the prediction spot
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None

% Compute coordinates of prediction spot
centerParam = -taskParam.circle.circleWidth/2;
xPredS = ((taskParam.circle.rotationRad+centerParam) * sin(taskParam.circle.rotAngle));
yPredS = ((taskParam.circle.rotationRad+centerParam) * (-cos(taskParam.circle.rotAngle)));
predSpot = OffsetRect(taskParam.circle.predCentSpotRect, xPredS, yPredS);

% Display prediction spot
Screen('FillOval', taskParam.display.window.onScreen, taskParam.colors.blue, predSpot);

end