function PredictionSpot(taskParam)
% This function draws the prediction spot and works with sine and cosine.
% 
% yNeedle = (taskParam.circle.rotationRad+12) * (-cos(taskParam.circle.rotAngle));  
% xNeedle = (taskParam.circle.rotationRad+12) * sin(taskParam.circle.rotAngle);
% yNeedle2 = (taskParam.circle.rotationRad-22) * (-cos(taskParam.circle.rotAngle));      
% xNeedle2 = (taskParam.circle.rotationRad-22) * sin(taskParam.circle.rotAngle);

% meanSpot = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle, yNeedle);
% meanSpot2 = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle2, yNeedle2);
% Screen('DrawLine', taskParam.gParam.window, [51 51 255], meanSpot2(1), meanSpot2(2), meanSpot(1), meanSpot(2), 6);

% PredSpot = outcome -(taskParam.circle.outcSize/2);
% zero = taskParam.gParam.zero;
% Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - 115, zero(2) - 115, zero(1) + 115, zero(2) + 115], taskParam.circle.rotAngle -5 , 10 , 30, [], []) %605 335 835 565
% Screen('DrawArc',taskParam.gParam.window,[0 0 0],[zero(1) - 115, zero(2) - 115, zero(1) + 115, zero(2) + 115],taskParam.circle.rotAngle,10)
% Screen('FillRect', taskParam.gParam.window, [0 0 0], [600, zero(2) - 30, 605, zero(2) + 5]);
% 
% yNeedle = (taskParam.circle.rotationRad+22) * (-cos(outcome*taskParam.circle.unit));  
% xNeedle = (taskParam.circle.rotationRad+22) * sin(outcome*taskParam.circle.unit);
% yNeedle2 = (taskParam.circle.rotationRad-14) * (-cos(outcome*taskParam.circle.unit));      
% xNeedle2 = (taskParam.circle.rotationRad-14) * sin(outcome*taskParam.circle.unit);
% 
% meanSpot = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle, yNeedle);
% meanSpot2 = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle2, yNeedle2);
% Screen('DrawLine', taskParam.gParam.window, [51 51 255], meanSpot2(1), meanSpot2(2), meanSpot(1), meanSpot(2), 4);


%keyboard

%xPredS = ((taskParam.circle.rotationRad-5) * sin(taskParam.circle.rotAngle));
%yPredS = ((taskParam.circle.rotationRad-5) * (-cos(taskParam.circle.rotAngle)));
xPredS = ((taskParam.circle.rotationRad-5) * sin(taskParam.circle.rotAngle ));
yPredS = ((taskParam.circle.rotationRad-5) * (-cos(taskParam.circle.rotAngle)));

PredSpot = OffsetRect(taskParam.circle.predCentSpotRect, xPredS, yPredS);
Screen('FillOval', taskParam.gParam.window.onScreen, [255 165 0], PredSpot); %51 51 255


end

