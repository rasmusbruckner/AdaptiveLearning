function al_aim(taskParam, parameter)
%AL_AIM This function draws the aim (as a needle) of the cannon
%
%   Input
%       taskParam: structure containing task parameters       
%       parameter: Aim of the cannon 
%
%   Output
%        ~


if ~isequal(taskParam.gParam.taskType, 'chinese')
    
    % In all conditions, except "chinese" needle goes from the center of the screen to the circle
    % -------------------------------------------------------------------------------------------
    
    % Compute x and y coordinates of end of needle
    xPredS = ((taskParam.circle.rotationRad-5) * sin(parameter*taskParam.circle.unit));
    yPredS = ((taskParam.circle.rotationRad-5) *  (-cos(parameter*taskParam.circle.unit)));
    outcomeCenter = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS, yPredS);
    x = (outcomeCenter(3)/2) + (outcomeCenter(1)/2);
    y = (outcomeCenter(4)/2) + (outcomeCenter(2)/2);

    lineStart = taskParam.circle.rotationRad* 0.05; 
    xCentS = (lineStart * sin(parameter*taskParam.circle.unit));
    yCentS = (lineStart *  (-cos(parameter*taskParam.circle.unit)));
    outcomeCenter = OffsetRect(taskParam.circle.outcCentSpotRect, xCentS, yCentS);
    xCent = (outcomeCenter(3)/2) + (outcomeCenter(1)/2);
    yCent = (outcomeCenter(4)/2) + (outcomeCenter(2)/2);
    
    % 27.10.22 -- updated this to make sure line starts "within"
    % the barrel. Make sure that it works for the other versions too
    % Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], taskParam.display.zero(1), taskParam.display.zero(2), x, y, 2);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], xCent, yCent, x, y, 2);

else
    
    % In "chinese" condition, cannon and needle start outside of the circle
    % ---------------------------------------------------------------------
    
    % Compute coordinates of beginning of needle
    xBegin = ((taskParam.circle.chineseCannonRad - 55) * sin(parameter*taskParam.circle.unit));
    yBegin = ((taskParam.circle.chineseCannonRad - 55) * (-cos(parameter*taskParam.circle.unit)));
    AimBegin = OffsetRect(taskParam.circle.outcCentSpotRect, xBegin, yBegin);
    
    % Compute x and y coordinates of end of needle
    xPredS = ((taskParam.circle.rotationRad-5) * sin(parameter*taskParam.circle.unit));
    yPredS = ((taskParam.circle.rotationRad-5) * (-cos(parameter*taskParam.circle.unit)));
    outcomeCenter = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS, yPredS);
    x = (outcomeCenter(3)/2) + (outcomeCenter(1)/2);
    y = (outcomeCenter(4)/2) + (outcomeCenter(2)/2);
    
    % Draw needle
    Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], mean([AimBegin(1) AimBegin(3)]), mean([AimBegin(2) AimBegin(4)]), x, y, 3);
    
end
end

