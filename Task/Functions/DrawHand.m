function DrawHand(taskParam, distMean)
%This function draws the hand. 

screensize = get(0, 'MonitorPositions');
screensize = (screensize(3:4));
zero = screensize / 2;

einheit = 2*pi/360;

xHand = taskParam.rotationRad * cos(distMean*einheit);            %(outcome(i));
yHand = taskParam.rotationRad * sin(distMean*einheit);
meanSpot = OffsetRect(taskParam.centSpotRectMean, xHand, yHand); 
Screen('FillOval', taskParam.window, [0 0 127], meanSpot); 
Screen('DrawLine', taskParam.window, [0 0 0], zero(1), zero(2), meanSpot(1)+1, meanSpot(2)+1, 2); %xHand, yHand  720, 450, 720 , 250

end

