function TickMark(taskParam, outcome)
% This function draws the last position of the outcome (the black tick mark).

rotRad = taskParam.circle.rotationRad + 10;
OutcSpot = outcome - 1;
zero = taskParam.gParam.zero;
Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],OutcSpot, 2, 30, [], []) %605 335 835 565 taskParam.circle.outcSize


end

