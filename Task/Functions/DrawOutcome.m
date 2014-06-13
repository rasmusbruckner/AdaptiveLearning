function DrawOutcome(taskParam, outcome)
% This function calculates the position of the outcome (the black bar).
    %
    % For Matlab point 0 is located on the right side of the center of
    % the circle. For participiants this point "feels" like 90 degrees. 
    % In order to prevent a bias towards the right side, the inital prediction
    % spot of the participant is not located at point 0 but actually 
    % at 270 degrees, that is, at the point which "feels" like 0 (see
    % "BattleShips" line 142). The outcome bar has a size of 26 degrees.
    % In order to center this bar, we end up with 90 - 26/2 = 77


OutcSpot = outcome - (taskParam.circle.outcSize/2);
screensize = get(0,'MonitorPositions'); 
screensize = (screensize(3:4));
zero = screensize / 2;
Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - 115, zero(2) - 115, zero(1) + 115, zero(2) + 115],OutcSpot, taskParam.circle.outcSize, 30, [], []) %605 335 835 565
end

