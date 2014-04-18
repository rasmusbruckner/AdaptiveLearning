function DrawGoldBoat(taskParam)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


imageRect = [0 0 100 100];
dstRect = CenterRect(imageRect, taskParam.windowRect);
[ShipGold map alpha]  = imread('ShipGold.png');
ShipGold(:,:,4) = alpha(:,:);
Screen('BlendFunction', taskParam.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
ShipGoldTxt = Screen('MakeTexture', taskParam.window, ShipGold);
Screen('DrawTexture', taskParam.window, ShipGoldTxt,[], dstRect);

end

