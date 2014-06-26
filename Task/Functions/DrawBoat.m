function ShipTxt = DrawBoat(taskParam, color)
%This function draws the boat.

imageRect = [0 0 100 100];
dstRect = CenterRect(imageRect, taskParam.gParam.windowRect);
[Ship, ~, alpha]  = imread('Ship.png');
Ship(:,:,4) = alpha(:,:);
Screen('BlendFunction', taskParam.gParam.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
ShipTxt = Screen('MakeTexture', taskParam.gParam.window, Ship);
Screen('DrawTexture', taskParam.gParam.window, ShipTxt,[], dstRect, [], [], [], color);  %Boat
end

