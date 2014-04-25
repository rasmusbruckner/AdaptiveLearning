function DrawSilverBoat(taskParam)
%This function draws the silver boat. 


imageRect = [0 0 100 100];
dstRect = CenterRect(imageRect, taskParam.windowRect);
[ShipGold map alpha]  = imread('ShipSilver.png');
ShipGold(:,:,4) = alpha(:,:);
Screen('BlendFunction', taskParam.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
ShipGoldTxt = Screen('MakeTexture', taskParam.window, ShipGold);
Screen('DrawTexture', taskParam.window, ShipGoldTxt,[], dstRect);  %Boat


end

