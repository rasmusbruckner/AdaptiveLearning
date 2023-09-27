function al_tickMark(taskParam, parameter, type)
%AL_TICKMARK This function draws the tickmark in the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%       parameters: Location in which tick mark should be presented
%       type: Tick-mark type
%
%   Output
%       ~


% Depending on tick-mark type, choose properties of tickmark
if isequal(type, 'pred')
    col = taskParam.colors.blue;
    tickLength = 40;
    tickNormalization = 15;
    tickWidth = taskParam.circle.tickWidth;
elseif isequal(type,'outc')
    col = [0 0 0];
    tickLength = 30;
    tickNormalization = 10;
    tickWidth = taskParam.circle.tickWidth;
elseif isequal(type,'aim')
    col = taskParam.colors.red;
    tickLength = 40;
    tickNormalization = 15;
    tickWidth = 3;
elseif isequal(type,'saved') || isequal(type,'update')
    col = [255 0 0];
    tickLength = 30;
    tickNormalization = 10;
    tickWidth = taskParam.circle.tickWidth;
end

% Compute location of tickmark
rotRad = taskParam.circle.rotationRad + tickNormalization;
tickPosition = parameter - tickWidth/2;

% Extract center
zero = taskParam.display.zero;

% Display tickmark
Screen('FrameArc', taskParam.display.window.onScreen, col, [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], tickPosition, tickWidth, tickLength, [], [])

end

