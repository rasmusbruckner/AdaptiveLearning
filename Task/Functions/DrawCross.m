function DrawCross(taskParam)
%DRAWCROSS   Draws the fixation cross

zero = taskParam.gParam.zero;
Screen('DrawLine', taskParam.gParam.window.onScreen,...
    [0 0 0], zero(1) - 9, zero(2), zero(1) + 9 , zero(2), 3);
Screen('DrawLine', taskParam.gParam.window.onScreen,...
    [0 0 0], zero(1), zero(2) - 9, zero(1) , zero(2) + 9, 3);
end

