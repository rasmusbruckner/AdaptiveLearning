function RewardTxt = Reward(taskParam, color)
%This function draws the boat.

imageRect = [0 0 100 100];
dstRect = CenterRect(imageRect, taskParam.gParam.windowRect);
if isequal(color,'gold')
[Ship, ~, alpha]  = imread('goldkugel.png');
elseif isequal(color, 'silver') 
[Ship, ~, alpha]  = imread('graukugel.png');
end
Ship(:,:,4) = alpha(:,:);
Screen('BlendFunction', taskParam.gParam.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
RewardTxt = Screen('MakeTexture', taskParam.gParam.window, Ship);
Screen('DrawTexture', taskParam.gParam.window, RewardTxt,[], dstRect, [], [], []);  %Boat
end

