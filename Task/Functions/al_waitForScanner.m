function al_waitForScanner(taskParam, txt)
%AL_WAITFORSCANNER This function presents the message that scanning session
% is about to start
%
%   Input
%       taskParam: Task-parameter-object instance
%       txt: Presented text
%
%   Output
%       None

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, 50);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% Present text and background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background); % [66 66 66]
DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', 100, [255 255 255]);
Screen('DrawingFinished', taskParam.display.window.onScreen);
t = GetSecs;
Screen('Flip', taskParam.display.window.onScreen, t + 0.1);     

end