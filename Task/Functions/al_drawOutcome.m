function al_drawOutcome(taskParam, outcome)
%AL_DRAWOUTCOME   This function prints the outcome spot
%
%   Input
%       taskParam: structure containing task parameters
%       outcome: current outcome
%
%   Output
%       ~


% Compute outcome spot coordinates
xPredS = ((taskParam.circle.rotationRad-5) * sin(outcome*taskParam.circle.unit));
yPredS = ((taskParam.circle.rotationRad-5) * (-cos(outcome*taskParam.circle.unit)));
OutcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS, yPredS);

% Generate outcome spot
if isequal(taskParam.gParam.taskType, 'chinese')
    Screen('FillOval', taskParam.display.window.onScreen, [165 42 42], OutcSpot);
else
    Screen('FillOval', taskParam.display.window.onScreen, [0 0 0], OutcSpot);
end
end


