function al_drawCross(taskParam, size, width)
%AL_DRAWCROSS This function draws the fixation cross
% 
%   Input
%       taskParam: Task-parameter-object instance
%       size: Optional line length
%       width: Optional line width
%
%   Output
%       ~


% Size
if ~exist('size', 'var') || isempty(size)
    size = 20;
end

% Width
if ~exist('width', 'var') || isempty(width)
    width = 6;
end

% Extract center
zero = taskParam.display.zero;

Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], zero(1) - size, zero(2), zero(1) + size , zero(2), width);
Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], zero(1), zero(2) - size, zero(1) , zero(2) + size, width);

end

