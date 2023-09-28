function al_drawCircle(taskParam)
% AL_DRAWCIRCLE This function draws the circle for the cannon task
%
%   Input
%        taskParam: Task-parameter-object instance
%
%   Output
%        ~


% Extract rotation radius
rotRad = taskParam.circle.rotationRad;

% Extract center
zero = taskParam.display.zero;

% Generate circle
Screen(taskParam.display.window.onScreen, 'FrameOval', [224 224 224], [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], [], 10, []);

