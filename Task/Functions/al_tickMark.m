function al_tickMark(taskParam, parameter, type)
%AL_TICKMARK   This function draws the tickmark in the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%       parameters: Location paramter that should be presented
%       type: Tick mark type
%
%   Output
%       ~


% Depending on tickmark type choose color and length of tickmark
if isequal(type, 'pred')
    col = [255 165 0];
    tickLength = 40;
    tickNormalization = 15;
elseif isequal(type,'outc')
    col = [0 0 0];
    tickLength = 30;
    tickNormalization = 10;
elseif isequal(type,'saved') || isequal(type,'update')
    col = [255 0 0];
    tickLength = 30;
    tickNormalization = 10;
end

% Compute location of tickmark
rotRad = taskParam.circle.rotationRad + tickNormalization;
OutcSpot = parameter - taskParam.circle.tickWidth/2; %- 1;

% Extract center
zero = taskParam.display.zero;

% Print tickmark
Screen('FrameArc', taskParam.display.window.onScreen, col, [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], OutcSpot, taskParam.circle.tickWidth, tickLength, [], [])

end

