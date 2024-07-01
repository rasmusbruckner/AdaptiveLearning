function al_showDuck(taskParam, distMean, center, angle)
%AL_SHOWDUCK This function displays the duck image in the infant version
%
%   Input
%       taskParam: Task-parameter-object instance
%       distMean: Current mean of the distribution
%       center: If true, duck presented in center of the screen
%       angle: Angle of picture to animate movement
%
%   Output
%       None


% Compute duck coordinates
if center == false
    longCentering = taskParam.circle.circleWidth/2;
    xPredS = ((taskParam.circle.rotationRad-longCentering) * sin(distMean*taskParam.circle.unit));
    yPredS = ((taskParam.circle.rotationRad-longCentering) * (-cos(distMean*taskParam.circle.unit)));
    duckPosition = OffsetRect(taskParam.display.duckImageRect, xPredS, yPredS);
else
    duckPosition = OffsetRect(taskParam.display.duckImageRect, 0, 0);
end

% Display duck
Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.duckTxt,[], duckPosition, angle); 


