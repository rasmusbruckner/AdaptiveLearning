function DrawCircle(taskParam)
% DRAWCIRCLE Draws the circle in the cannon task

rotRad = taskParam.circle.rotationRad;
%rotRad = taskParam.circle.tendencyThreshold;

zero = taskParam.gParam.zero;
Screen(taskParam.gParam.window.onScreen,'FrameOval',[224 224 224],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],[],10,[]); %zero(1) - 105, zero(2) - 105, zero(1) + 105, zero(2) + 105
end

