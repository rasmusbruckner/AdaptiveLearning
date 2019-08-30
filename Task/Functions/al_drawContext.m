function al_drawContext(taskParam, currentContext)
%AL_DRAWCONTEXT   This function indicates the current context in the cannon task
%
%   Input
%       taskParam: structure containing task parameters
%       currentContext: planet color
%
%   Output
%       
%       ~
 

% Extract rotation radius
rotRad = taskParam.circle.rotationRad;

if currentContext == 1
    
    % Blue for first planet
    color = [116, 121, 255];
    
elseif currentContext == 2
    
    % Green for second planet
    color = [106, 162, 70];
    
elseif currentContext == 3
    
    % Red for third planet
    color = [255 0 0];
    
elseif currentContext == 4
    
    % XX for fourth planet
    color = [0 255 0];
    
elseif currentContext == 5
    
    % XX for foifth planet
    color = [0 0 0];
    
elseif currentContext == 6
    
    % XX for sixth planet
    color = [0 0 255];
    
end

% Change saturation for cued condition
if taskParam.gParam.showCue == true
    color = changeSaturation(color, 0.1);
end

% Extract center
zero = taskParam.gParam.zero;

% Generate current context
Screen('FillOval', taskParam.gParam.window.onScreen,color,[zero(1) - rotRad+10, zero(2) - rotRad+10, zero(1) + rotRad-10, zero(2) + rotRad-10],[]);


function color = changeSaturation(color, change)
%CHANGESATURATION   This function changes the saturation of the colors 
% Obtained from 
% https://de.mathworks.com/matlabcentral/fileexchange/42551-change-the-saturation-of-a-color-by-ratio-from-0-to-1-0

    Pr = 0.299;
    Pg = 0.587;
    Pb = 0.114;
    P = sqrt(color(1) * color(1) * Pr+color(2) * color(2) * Pg+color(3) * color(3) * Pb);
    color(1) = P + (color(1) - P) * change;
    color(2) = P + (color(2) - P) * change;
    color(3) = P + (color(3) - P) * change;
end

end

