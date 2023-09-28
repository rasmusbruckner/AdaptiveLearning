function al_aim(taskParam, aim)
%AL_AIM This function draws the aim (using a thin line) of the cannon
%
%   Input
%       taskParam: Task-parameter-object instance       
%       aim: Aim of the cannon 
%
%   Output
%        ~

% Aim inside circle
if isequal(taskParam.trialflow.cannonPosition, 'inside')
     
    % Compute x and y coordinates of end of line
    xAim = ((taskParam.circle.rotationRad-5) * sin(aim*taskParam.circle.unit));
    yAim = ((taskParam.circle.rotationRad-5) *  (-cos(aim*taskParam.circle.unit)));
    aimStart = OffsetRect(taskParam.circle.outcCentSpotRect, xAim, yAim);
    x = (aimStart(3)/2) + (aimStart(1)/2);
    y = (aimStart(4)/2) + (aimStart(2)/2);

    % Compute center of circle
    lineStart = taskParam.circle.rotationRad* 0.05; 
    xCentS = (lineStart * sin(aim*taskParam.circle.unit));
    yCentS = (lineStart *  (-cos(aim*taskParam.circle.unit)));
    aimEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xCentS, yCentS);
    xCent = (aimEnd(3)/2) + (aimEnd(1)/2);
    yCent = (aimEnd(4)/2) + (aimEnd(2)/2);
    
    % Draw line
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], xCent, yCent, x, y, 2);

% Aim outside of circle
else
    
    % Compute coordinates of beginning of line
    xBegin = ((taskParam.circle.chineseCannonRad - 55) * sin(aim*taskParam.circle.unit));
    yBegin = ((taskParam.circle.chineseCannonRad - 55) * (-cos(aim*taskParam.circle.unit)));
    aimBegin = OffsetRect(taskParam.circle.outcCentSpotRect, xBegin, yBegin);
    
    % Compute x and y coordinates of end of line
    xAim = ((taskParam.circle.rotationRad-5) * sin(aim*taskParam.circle.unit));
    yAim = ((taskParam.circle.rotationRad-5) * (-cos(aim*taskParam.circle.unit)));
    aimEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xAim, yAim);
    x = (aimEnd(3)/2) + (aimEnd(1)/2);
    y = (aimEnd(4)/2) + (aimEnd(2)/2);
    
    % Draw line
    Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], mean([aimBegin(1) aimBegin(3)]), mean([aimBegin(2) aimBegin(4)]), x, y, 3);
    
end
end

