function DrawOutcome(taskParam, outcome)
% This function draws the position of the outcome (the black bar).

OutcSpot = outcome - (taskParam.circle.outcSize/2);
zero = taskParam.gParam.zero;
Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - 115, zero(2) - 115, zero(1) + 115, zero(2) + 115],OutcSpot, taskParam.circle.outcSize, 30, [], []) %605 335 835 565
end

