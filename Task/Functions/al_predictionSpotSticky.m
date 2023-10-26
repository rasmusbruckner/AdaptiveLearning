function al_predictionSpotSticky(taskParam, xPredS, yPredS)
%AL_PREDICTIONSPOTSTICKY This function implements the sticky prediction
% spot (on the circle line)
%
%   Input
%       taskParam: Task-parameter-object instance
%       xPredS: X-coordinate for sticky prediction spot
%       yPredS: Y-coordinate for sticky prediction spot
%
%   Output
%       None


% Compute coordinate of sticky prediction spot
predSpot = OffsetRect(taskParam.circle.predCentSpotRect, xPredS, yPredS);

% Show sticky prediction spot
Screen('FillOval', taskParam.display.window.onScreen, taskParam.colors.blue, predSpot);

end