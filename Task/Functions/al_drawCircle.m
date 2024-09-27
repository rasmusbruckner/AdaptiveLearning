function al_drawCircle(taskParam)
% AL_DRAWCIRCLE This function draws the circle for the cannon task
%
%   Input
%        taskParam: Task-parameter-object instance
%
%   Output
%        None
%
% Todo: integrate in circle class

% Extract rotation radius
rotRad = taskParam.circle.rotationRad;
circleWidth = taskParam.circle.circleWidth;

% Extract center
zero = taskParam.display.zero;

% Generate circle
Screen(taskParam.display.window.onScreen, 'FrameOval', taskParam.colors.circleCol, [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], [], circleWidth, []);

% Manually darawing two lines to check circle properties to compute number
% of pixels for isoluminant background
% rotRad = 140;
% Screen(taskParam.display.window.onScreen, 'FrameOval', [0 0 0], [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], [], 1, []);
% 
% rotRad = 130;
% Screen(taskParam.display.window.onScreen, 'FrameOval', [0 0 0], [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], [], 1, []);


