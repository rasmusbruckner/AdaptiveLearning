function al_drawCannon(taskParam, distMean)
%AL_DRAWCANNON This function prints the cannon image
%
%   Input
%       taskParam: Task-parameter-object instance
%       distMean: Current mean of the distribution
%
%   Output
%       ~


% Draw cannon image
Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.cannonTxt,[], taskParam.display.dstRect, distMean);

end


