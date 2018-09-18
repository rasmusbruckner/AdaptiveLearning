function al_drawContext(taskParam, currentContext)
% DRAWCONTEXT   Indicates the current context in the cannon task
%
%   Input
%       taskParam: structure containing task parameters
%       currentContext: planet color


% Extract rotation radius
rotRad = taskParam.circle.rotationRad;

if currentContext == 1
    
    % Blue for first planet 
    color = [116,121,255]; 
    
elseif currentContext == 2
    
    % Green for second planet
    color = [106,162,70];
    
elseif currentContext == 3
    
    % Red for third planet
    color = [255 0 0]; 
    
end

% Extract center
zero = taskParam.gParam.zero;

% Generate current context
Screen('FillOval', taskParam.gParam.window.onScreen,color,[zero(1) - rotRad+10, zero(2) - rotRad+10, zero(1) + rotRad-10, zero(2) + rotRad-10],[]);

end

