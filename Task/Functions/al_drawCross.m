function al_drawCross(taskParam)
%AL_DRAWCROSS This function draws the fixation cross
% 
%   Input
%       taskParam: structure containing task parameters
%
%   Output
%       ~


% Extract center
zero = taskParam.display.zero;

% Generate fixation cross
% note: this is what we used previously. parameterize the size of the cross
%Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], zero(1) - 9, zero(2), zero(1) + 9 , zero(2), 3);
%Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], zero(1), zero(2) - 9, zero(1) , zero(2) + 9, 3);

Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], zero(1) - 20, zero(2), zero(1) + 20 , zero(2), 6);
Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], zero(1), zero(2) - 20, zero(1) , zero(2) + 20, 6);

end

