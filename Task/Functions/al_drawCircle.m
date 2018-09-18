function al_drawCircle(taskParam)
% AL_DRAWCIRCLE   Draws the circle in the cannon task
%
%   Input
%        taskParam: structure containing task parameters
%   Output
%        ~


% Extract rotation radius
rotRad = taskParam.circle.rotationRad;

% Extract center
zero = taskParam.gParam.zero;

% Generate circle
Screen(taskParam.gParam.window.onScreen,'FrameOval',[224 224 224], [zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], [], 10, []);

