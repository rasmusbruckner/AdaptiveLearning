function DrawContext(taskParam, currentContext)
% DRAWCONTEXT Indicates the current context in the cannon task

rotRad = taskParam.circle.rotationRad;
%rotRad = taskParam.circle.tendencyThreshold;

if currentContext == 1

    color = [0 0 255]; % blue
    
elseif currentContext == 2
    
    color = [255 0 0]; % red
    
elseif currentContext == 3
    
    color = [0 255 0]; % green
    
end

zero = taskParam.gParam.zero;
Screen('FillOval', taskParam.gParam.window.onScreen,color,[zero(1) - rotRad+10, zero(2) - rotRad+10, zero(1) + rotRad-10, zero(2) + rotRad-10],[]); %zero(1) - 105, zero(2) - 105, zero(1) + 105, zero(2) + 105
end

