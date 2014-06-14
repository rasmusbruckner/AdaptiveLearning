function DrawCross(taskParam)
% This function draws the fixation cross.

zero = taskParam.gParam.zero;
Screen('DrawLine', taskParam.gParam.window, [0 0 0], zero(1) - 10, zero(2), zero(1)+10 , zero(2), 3); %710, 450, 730 , 450
Screen('DrawLine', taskParam.gParam.window, [0 0 0], zero(1), zero(2) - 10, zero(1) , zero(2) + 10, 3);%720, 440, 720 , 460
end

