function al_showHelicopter(taskParam, distMean)
%AL_SHOWHELICOPTER This function displays the helicopter image
%
%   Input
%       taskParam: Task-parameter-object instance
%       distMean: Current mean of the distribution
%
%   Output
%       ~


% Compute helicopter coordinates
xPredS = ((taskParam.circle.heliImageRad) * sin(distMean*taskParam.circle.unit));
yPredS = ((taskParam.circle.heliImageRad) * (-cos(distMean*taskParam.circle.unit)));
helicopterPosition = OffsetRect(taskParam.display.heliImageRect, xPredS, yPredS);

% Display helicopter
Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.heliTxt,[], helicopterPosition, 0);


