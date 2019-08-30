function al_showCue(taskParam, latentState)
%AL_SHOWCUE   This function presents the cue that indicates which enemy is
%currently shooting in the "chinese", i.e., planets task
%
%   Input
%       taskParam: structure containing task paramters
%       latentState: current enemy that will be indicated
%   
%   Output
%       ~



distMean = 0;

if ~isequal(taskParam.gParam.useTrialConstraints, 'aging')
    % Compute rocket coordinates
    xPredS = ((taskParam.circle.chineseCannonRad) * sin(distMean*taskParam.circle.unit));
    yPredS = ((taskParam.circle.chineseCannonRad) * (-cos(distMean*taskParam.circle.unit)));
    cannonPosition = OffsetRect(taskParam.textures.dstRect, xPredS, yPredS);
else
    cannonPosition = taskParam.textures.dstRect;
end

% Select picture that is presented
if latentState == 0
    Screen('DrawTexture', taskParam.gParam.window.onScreen, taskParam.textures.rocketTxt,[], cannonPosition, distMean, [], 0, [0 0 0], [], []);
elseif latentState == 1
    Screen('DrawTexture', taskParam.gParam.window.onScreen, taskParam.textures.rocketTxt_lightning,[], cannonPosition, distMean, [], 0, [0 0 0], [], []);
elseif latentState == 2
    Screen('DrawTexture', taskParam.gParam.window.onScreen, taskParam.textures.rocketTxt_star,[], cannonPosition, distMean, [], 0, [0 0 0], [], []);
elseif latentState == 3
    Screen('DrawTexture', taskParam.gParam.window.onScreen, taskParam.textures.rocketTxt_swirl,[], cannonPosition, distMean, [], 0, [0 0 0], [], []);
end


end