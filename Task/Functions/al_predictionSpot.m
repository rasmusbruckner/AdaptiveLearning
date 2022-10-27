function al_predictionSpot(taskParam)
%AL_PREDICTIONSPOT This function prints the prediction spot
%
%   Input
%       taskParam: structure containing task parameters
%
%   Output
%       ~


% Compute coordinates of prediction spot
xPredS = ((taskParam.circle.rotationRad-5) * sin(taskParam.circle.rotAngle));
yPredS = ((taskParam.circle.rotationRad-5) * (-cos(taskParam.circle.rotAngle)));
PredSpot = OffsetRect(taskParam.circle.predCentSpotRect, xPredS, yPredS);

% Print prediction spot
Screen('FillOval', taskParam.display.window.onScreen, taskParam.colors.blue, PredSpot);  % [255 165 0]

end