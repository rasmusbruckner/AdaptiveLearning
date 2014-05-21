function DrawSilverBoat(taskParam)
%This function draws the silver boat. 


imageRect = [0 0 100 100];
dstRect = CenterRect(imageRect, taskParam.gParam.windowRect);
[ShipGold, ~, alpha]  = imread('ShipSilver.png');
ShipGold(:,:,4) = alpha(:,:);
Screen('BlendFunction', taskParam.gParam.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
ShipGoldTxt = Screen('MakeTexture', taskParam.gParam.window, ShipGold);
Screen('DrawTexture', taskParam.gParam.window, ShipGoldTxt,[], dstRect);  %Boat


end

