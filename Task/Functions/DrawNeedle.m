function DrawNeedle(taskParam, distMean)
%This function draws the needle.

% zero = taskParam.gParam.zero;
% yNeedle = taskParam.circle.rotationRad * (-cos(distMean*taskParam.circle.unit));            %(outcome(i));
% xNeedle = taskParam.circle.rotationRad * sin(distMean*taskParam.circle.unit);
% meanSpot = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle, yNeedle);
% Screen('FillOval', taskParam.gParam.window, [0 0 127], meanSpot);
% Screen('DrawLine', taskParam.gParam.window, [0 0 0], zero(1), zero(2), meanSpot(1)+1, meanSpot(2)+1, 7); %xNeedle, yNeedle  720, 450, 720 , 250

zero = taskParam.gParam.zero;
yNeedle = taskParam.circle.rotationRad * (-cos(distMean*taskParam.circle.unit));            %(outcome(i));
xNeedle = taskParam.circle.rotationRad * sin(distMean*taskParam.circle.unit);
meanSpot = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle, yNeedle);
Screen('FillOval', taskParam.gParam.window, [0 0 127], meanSpot);
Screen('DrawLine', taskParam.gParam.window, [0 0 0], zero(1), zero(2), meanSpot(1)+1, meanSpot(2)+1, 7); %xNeedle, yNeedle  720, 450, 720 , 250





end

