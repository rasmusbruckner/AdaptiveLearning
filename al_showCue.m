function al_showCue(taskParam, latentState)


distMean = 0;

% Compute rocket coordinates
xPredS = ((taskParam.circle.chineseCannonRad) * sin(distMean*taskParam.circle.unit));
yPredS = ((taskParam.circle.chineseCannonRad) * (-cos(distMean*taskParam.circle.unit)));
cannonPosition = OffsetRect(taskParam.textures.dstRect, xPredS, yPredS);

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