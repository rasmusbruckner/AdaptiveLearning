function DrawBronzeBoat(taskParam)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


imageRect = [0 0 100 100];
dstRect = CenterRect(imageRect, taskParam.gParam.windowRect);
[ShipGold, ~, alpha]  = imread('ShipBronze.png');
ShipGold(:,:,4) = alpha(:,:);
Screen('BlendFunction', taskParam.gParam.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
ShipGoldTxt = Screen('MakeTexture', taskParam.gParam.window, ShipGold);
Screen('DrawTexture', taskParam.gParam.window, ShipGoldTxt,[], dstRect);

end

