function al_showDoctor(taskParam, distMean)
%AL_SHOWDOCTOR This function displays the image of the doctor in the Leipzig version
%
%   Input
%       taskParam: structure containing task parameters
%       distMean: current mean of the distribution
%       latentState: current enemy
%       ~ to be deleted
%
%   Output
%       ~


% Compute doctor coordinates
xPredS = ((taskParam.circle.shieldImageRad) * sin(distMean*taskParam.circle.unit));
yPredS = ((taskParam.circle.shieldImageRad) * (-cos(distMean*taskParam.circle.unit)));
cannonPosition = OffsetRect(taskParam.display.doctorRect, xPredS, yPredS);

% Display doctor
Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.doctorTxt,[], cannonPosition, 0);



