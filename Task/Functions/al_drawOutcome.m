function al_drawOutcome(taskParam, outcome)
%AL_DRAWOUTCOME This function shows the outcome spot
%
%   Input
%       taskParam: Task-parameter-object instance
%       outcome: Current outcome
%
%   Output
%       ~


% Compute outcome spot coordinates
xPredS = ((taskParam.circle.rotationRad-5) * sin(outcome*taskParam.circle.unit));
yPredS = ((taskParam.circle.rotationRad-5) * (-cos(outcome*taskParam.circle.unit)));
OutcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS, yPredS);

% Generate outcome spot
Screen('FillOval', taskParam.display.window.onScreen, [0 0 0], OutcSpot);

end