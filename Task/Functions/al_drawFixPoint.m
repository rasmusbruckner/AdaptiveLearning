function al_drawFixPoint(taskParam, color, baseline)
%AL_DRAWFIXPOINT This function shows the fixation point in the center of
%the screen
%
%   Input
%       taskParam: Task-parameter-object instance
%       color: Optional argument
%       baseline: Optional argument to use smaller fixation point
%
%   Output
%       None

% Check if particular color is requested
if ~exist('color', 'var') || isempty(color)
    color = taskParam.colors.fixDot;
end

% Check if smaller dot should be used
if ~exist('baseline', 'var') || isempty(baseline)
    baseline = false;
end

if baseline == false
    
    % Compute outcome spot coordinates
    fixPoint = OffsetRect(taskParam.circle.fixSpotCentRect, 0, 0);

else

    % Compute outcome spot coordinates
    fixPoint = OffsetRect(taskParam.circle.fixSpotBaselineCentRect, 0, 0);
end

% Draw point
Screen('FillOval', taskParam.display.window.onScreen, color, fixPoint);

end