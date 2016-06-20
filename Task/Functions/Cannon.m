function Cannon(taskParam, distMean)
%CANNON   Prints the cannon image
 
Screen('DrawTexture', taskParam.gParam.window.onScreen,...
    taskParam.textures.cannonTxt,[], taskParam.textures.dstRect,...
    distMean, [], 0, [0 0 0], [], []);  

end

