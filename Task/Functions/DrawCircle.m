function DrawCircle(taskParam)
% This function draws the circle.

zero = taskParam.gParam.zero;
Screen(taskParam.gParam.window,'FrameOval',[128 128 128],[zero(1) - 105, zero(2) - 105, zero(1) + 105, zero(2) + 105],[],10,[]); %615 345 825 555
end

