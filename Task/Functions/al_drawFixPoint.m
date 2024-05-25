function al_drawFixPoint(taskParam, color)
%AL_DRAWFIXPOINT This function shows the fixation point in the center of
%the screen
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None

% Check if reduced shield is requested
if ~exist('color', 'var') || isempty(color)
    color = taskParam.colors.fixDot;
end

% Compute outcome spot coordinates
fixPoint = OffsetRect(taskParam.circle.fixSpotCentRect, 0, 0);

% Draw point
Screen('FillOval', taskParam.display.window.onScreen, color, fixPoint);

end