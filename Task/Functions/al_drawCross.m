function al_drawCross(taskParam)
%AL_DRAWCROSS   Draws the fixation cross
% 
%   Input
%       taskParam: structure containing task parameters
%   Output
%       ~ 


% Extract center
zero = taskParam.gParam.zero;

% Generate fixation cross
Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], zero(1) - 9, zero(2), zero(1) + 9 , zero(2), 3);
Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], zero(1), zero(2) - 9, zero(1) , zero(2) + 9, 3);

end

