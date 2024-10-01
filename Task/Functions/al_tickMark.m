function [tickLength, col] = al_tickMark(taskParam, parameter, type)
%AL_TICKMARK This function displays the tickmarks in the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%       parameter: Location in which tick mark should be presented
%       type: Tick-mark type
%
%   Output
%       tickLength: Length of tick mark to compute backgound RGB
%       col: Color to compute background RGB
%
% Todo: integrate in circle

% Depending on tick-mark type, choose properties of tickmark
if isequal(type, 'pred')
    col = taskParam.colors.blue;
    tickLength = taskParam.circle.tickLengthPred;
    tickWidth = taskParam.circle.tickWidth;
elseif isequal(type,'outc')
    col = [0 0 0];
    tickLength = taskParam.circle.tickLengthOutc;
    tickWidth = taskParam.circle.tickWidth;
elseif isequal(type,'aim') 
    % this is for heli (Leipzig) and not yet working with degrees visual angle
    col = taskParam.colors.red; 
    tickLength = 40;
    tickWidth = 3;
elseif isequal(type,'shield')
    col = taskParam.colors.purple;
    tickLength = taskParam.circle.tickLengthShield;
    tickWidth = taskParam.circle.tickWidth;
elseif isequal(type, 'outcomeSeries')
    col = [95 95 95];
    tickLength = taskParam.circle.tickLengthOutc;
    tickWidth = taskParam.circle.tickWidth;
end

% Compute location of tickmark
tickCentering = - taskParam.circle.circleWidth/2 + tickLength/2;
rotRad = taskParam.circle.rotationRad + tickCentering;
tickPosition = parameter - tickWidth/2;

% Extract center
zero = taskParam.display.zero;

% Display tickmark
Screen('FrameArc', taskParam.display.window.onScreen, col, [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], tickPosition, tickWidth, tickLength, [], [])

end

