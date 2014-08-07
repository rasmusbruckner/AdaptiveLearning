function DrawNeedle(taskParam, distMean)
%This function draws the needle.

% zero = taskParam.gParam.zero;
% yNeedle = taskParam.circle.rotationRad * (-cos(distMean*taskParam.circle.unit));            %(outcome(i));
% xNeedle = taskParam.circle.rotationRad * sin(distMean*taskParam.circle.unit);
% meanSpot = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle, yNeedle);
% Screen('FillOval', taskParam.gParam.window, [0 0 127], meanSpot);
% Screen('DrawLine', taskParam.gParam.window, [0 0 0], zero(1), zero(2), meanSpot(1)+1, meanSpot(2)+1, 7); %xNeedle, yNeedle  720, 450, 720 , 250

% zero = taskParam.gParam.zero;
% yNeedle = taskParam.circle.rotationRad * (-cos(distMean*taskParam.circle.unit));            %(outcome(i));
% xNeedle = taskParam.circle.rotationRad * sin(distMean*taskParam.circle.unit);
% meanSpot = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle, yNeedle);
% Screen('FillOval', taskParam.gParam.window, [0 0 127], meanSpot);
% Screen('DrawLine', taskParam.gParam.window, [0 0 0], zero(1), zero(2), meanSpot(1)+1, meanSpot(2)+1, 7); %xNeedle, yNeedle  720, 450, 720 , 250
% 


% imageRect = [0 0 120 120];
% dstRect = CenterRect(imageRect, taskParam.gParam.windowRect);
% [cannonPic, ~, alpha]  = imread('cannon.png');
% cannonPic(:,:,4) = alpha(:,:);
% Screen('BlendFunction', taskParam.gParam.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% cannonTxt = Screen('MakeTexture', taskParam.gParam.window, cannonPic);
Screen('DrawTexture', taskParam.gParam.window, taskParam.cannonTxt,[], taskParam.dstRect, distMean, [], [0], [0 0 0], [], []);  %Boat
%Screen('Close', CannonTxt);
end

