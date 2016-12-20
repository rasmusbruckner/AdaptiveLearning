function DrawContext(taskParam, currentContext)
% DRAWCONTEXT Indicates the current context in the cannon task

rotRad = taskParam.circle.rotationRad;
%rotRad = taskParam.circle.tendencyThreshold;

if currentContext == 1

%     color = [  0  113.5547  177.3047]; % blue
    color = [116,121,255]; % blue / changed by Lennart for Pilot
    
elseif currentContext == 2
    
%     color = [0  157.3828  114.5508]; % green
    color = [106,162,70]; % green / changed by Lennart for Pilot
    
elseif currentContext == 3
    
    color = [255 0 0]; % red
    
end

zero = taskParam.gParam.zero;
Screen('FillOval', taskParam.gParam.window.onScreen,color,[zero(1) - rotRad+10, zero(2) - rotRad+10, zero(1) + rotRad-10, zero(2) + rotRad-10],[]); %zero(1) - 105, zero(2) - 105, zero(1) + 105, zero(2) + 105
end

