function TickMark(taskParam, parameter, type)
% This function draws the last position of the outcome (the black tick mark).
if isequal(type, 'pred')
col = [255 165 0];
elseif isequal(type,'outc')
col = [0 0 0];
end
rotRad = taskParam.circle.rotationRad + 10;
OutcSpot = parameter - 1;
zero = taskParam.gParam.zero;
Screen('FrameArc',taskParam.gParam.window, col,[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],OutcSpot, 2, 30, [], []) %605 335 835 565 taskParam.circle.outcSize


end

