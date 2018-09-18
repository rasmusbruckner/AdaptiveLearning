function al_drawCannon(taskParam, distMean, latentState, ~)
%AL_DRAWCANNON   Prints the cannon image
%
%   Input
%       taskParam: structure containing task parameters
%       distMean: current mean of the distribution
%       latentState: current enemy
%       ~ to be deleted!
%   Output
%       ~


if ~isequal(taskParam.gParam.taskType, 'chinese')
    
    % In all, except chinese condition draw cannon symbol
    % ---------------------------------------------------
    Screen('DrawTexture', taskParam.gParam.window.onScreen, taskParam.textures.cannonTxt,[], taskParam.textures.dstRect, distMean, [], 0, [0 0 0], [], []);
else
    % In chinese condition, print rocket instaed of cannon
    % ----------------------------------------------------

    % Check if symbol (eg star, lighting) should appear on rocket
    if nargin == 3
        taskParam.symbol = true;
    end
    
    % Compute rocket coordinates
    xPredS = ((taskParam.circle.chineseCannonRad) * sin(distMean*taskParam.circle.unit));
    yPredS = ((taskParam.circle.chineseCannonRad) * (-cos(distMean*taskParam.circle.unit)));
    cannonPosition = OffsetRect(taskParam.textures.dstRect, xPredS, yPredS);
    
    % Compute aim of rocket
    distMeanSpace = distMean + 180;
    
    % Draw rocket symbol 
    if taskParam.symbol == false
        Screen('DrawTexture', taskParam.gParam.window.onScreen, taskParam.textures.rocketTxt,[], cannonPosition, distMeanSpace, [], 0, [0 0 0], [], []);
    else
        if latentState == 0
            Screen('DrawTexture', taskParam.gParam.window.onScreen, taskParam.textures.rocketTxt,[], cannonPosition, distMeanSpace, [], 0, [0 0 0], [], []);
        elseif latentState == 1
            Screen('DrawTexture', taskParam.gParam.window.onScreen, taskParam.textures.rocketTxt_lightning,[], cannonPosition, distMeanSpace, [], 0, [0 0 0], [], []);
        elseif latentState == 2
            Screen('DrawTexture', taskParam.gParam.window.onScreen, taskParam.textures.rocketTxt_star,[], cannonPosition, distMeanSpace, [], 0, [0 0 0], [], []);
        elseif latentState == 3
            Screen('DrawTexture', taskParam.gParam.window.onScreen, taskParam.textures.rocketTxt_swirl,[], cannonPosition, distMeanSpace, [], 0, [0 0 0], [], []);
        end
    end
    
    
end


