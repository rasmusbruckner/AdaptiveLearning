function Cannonball(taskParam, outcome)
% This function animates the cannonball shot. 
%   Detailed explanation goes here
    % ------------------------
    % set dot field parameters
    % ------------------------

xStart = taskParam.gParam.zero(1);
yStart = taskParam.gParam.zero(2);
OutcSpotStart = OffsetRect(taskParam.circle.outcCentSpotRect, xStart, yStart);

xEnd = ((taskParam.circle.rotationRad-5) * sin(outcome*taskParam.circle.unit));
yEnd = ((taskParam.circle.rotationRad-5) * (-cos(outcome*taskParam.circle.unit)));
OutcSpotEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xEnd, yEnd);

OutcSpotDiff = OutcSpotEnd - OutcSpotStart


for i = 1:taskParam.nFrames

    xAct = ((taskParam.circle.rotationRad-5) * sin(outcome*taskParam.circle.unit));
    yAct = ((taskParam.circle.rotationRad-5) * (-cos(outcome*taskParam.circle.unit)));
    OutcSpotAct = OffsetRect(taskParam.circle.outcCentSpotRect, xAct, yAct);
    
    DrawCircle(taskParam)
    Screen('FillOval', taskParam.gParam.window, [0 0 0], OutcSpotAct);
    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.01);  

end

