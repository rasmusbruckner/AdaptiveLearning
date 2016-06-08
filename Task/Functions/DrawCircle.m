function DrawCircle(taskParam)
% This function draws the circle.

rotRad = taskParam.circle.rotationRad;

zero = taskParam.gParam.zero;
Screen(taskParam.gParam.window.onScreen,'FrameOval',[224 224 224],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],[],10,[]); %zero(1) - 105, zero(2) - 105, zero(1) + 105, zero(2) + 105
end

