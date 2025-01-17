function al_drawCannon(taskParam, distMean, alpha, color)
%AL_DRAWCANNON This function prints the cannon image
%
%   Input
%       taskParam: Task-parameter-object instance
%       distMean: Current mean of the distribution
%       alpha: Visibility value (optional)
%       color: Color of cannon (optional)
%
%   Output
%       ~

% Optional visibility value
if ~exist('alpha', 'var') ||  isempty(alpha)
    alpha = 1;
end

% Optional color value
if ~exist('color', 'var') ||  isempty(color)
    color = [];
end

% Draw cannon image
Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.cannonTxt,[], taskParam.display.dstRect, distMean, [], alpha, color);

end


