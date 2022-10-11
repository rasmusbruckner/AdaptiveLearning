function al_predictionSpotReversal(taskParam, xPredS, yPredS)
%AL_PREDICTIONSPOTREVERSAL   This function prints the prediction spot for the reversal task
%
%   Input
%       taskParam: structure containing task parameters
%       xPredS: x-coordinate for reversal prediction spot
%       yPredS: y-coordinate for reversal prediction spot
%
%   Output
%       ~


% Compute coordinate of reversal prediction spot
predSpot = OffsetRect(taskParam.circle.predCentSpotRect, xPredS, yPredS);

% Print reversal prediction spot
Screen('FillOval', taskParam.display.window.onScreen, [255 165 0], predSpot); %51 51 255

end