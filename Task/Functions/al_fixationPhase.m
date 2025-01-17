function al_fixationPhase(taskParam, color)
%AL_FIXATIONPHASE This function implements the fixation phase
%
%   Input
%       taskParam: task-parameter-objects instance
%       color: optional color of fixation dot
%
%   Output
%       None

% Check if reduced shield is requested
if ~exist('color', 'var') || isempty(color)
    color = taskParam.colors.fixDot;
end

Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
al_drawFixPoint(taskParam, color)

% Draw circle and confetti cloud
al_drawCircle(taskParam)

% Tell PTB that everything has been drawn and flip screen
Screen('DrawingFinished', taskParam.display.window.onScreen);

end
