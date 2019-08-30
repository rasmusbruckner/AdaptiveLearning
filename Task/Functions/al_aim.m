function al_aim(taskParam, parameter)
%AL_AIM   This function prints the aim (as a needle) of the cannon
%
%   Input
%       taskParam: structure containing task parameters       
%       parameter: ? 
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
    
    % Draw needle
    Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], taskParam.gParam.zero(1), taskParam.gParam.zero(2), x, y, 2);
    
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

