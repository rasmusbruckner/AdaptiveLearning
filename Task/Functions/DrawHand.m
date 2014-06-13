function DrawHand(taskParam, distMean)
%This function draws the hand. 

screensize = get(0, 'MonitorPositions');
screensize = (screensize(3:4));
zero = screensize / 2;

einheit = 2*pi/360;

yHand = taskParam.circle.rotationRad * (-cos(distMean*einheit));            %(outcome(i));
xHand = taskParam.circle.rotationRad * sin(distMean*einheit);
meanSpot = OffsetRect(taskParam.circle.centSpotRectMean, xHand, yHand); 
Screen('FillOval', taskParam.gParam.window, [0 0 127], meanSpot); 
Screen('DrawLine', taskParam.gParam.window, [0 0 0], zero(1), zero(2), meanSpot(1)+1, meanSpot(2)+1, 2); %xHand, yHand  720, 450, 720 , 250

end

