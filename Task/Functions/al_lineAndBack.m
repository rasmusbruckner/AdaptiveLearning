function al_lineAndBack(taskParam)
%AL_LINEANDBACK This function draws the background for intructions in the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None


% Extract background color
if isequal(taskParam.trialflow.background, 'picture')
    col = taskParam.colors.black;
else
    col = taskParam.colors.background;
end

% Display background
Screen('FillRect', taskParam.display.window.onScreen, col);

% Present background texture, if desired
if isequal(taskParam.trialflow.background, 'picture')
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.backgroundTxt,[], taskParam.display.backgroundCoords, []);
end

% Extract background color of lower and upper screen
if isequal(taskParam.trialflow.background, 'picture')
    col = taskParam.colors.black;
else
    col = taskParam.colors.darkBlue;
end

% Display background
Screen('FillRect', taskParam.display.window.onScreen, col, [0, 0, taskParam.display.screensize(3), (taskParam.display.screensize(4)*1/4)]);% -3
Screen('FillRect', taskParam.display.window.onScreen, col, [0, taskParam.display.screensize(4)*3/4, taskParam.display.screensize(3), taskParam.display.screensize(4)]);

% Display lines to separate different background colors
if ~isequal(taskParam.trialflow.background, 'picture')
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*1/4, taskParam.display.screensize(3), taskParam.display.screensize(4)*1/4, 5);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*3/4, taskParam.display.screensize(3), taskParam.display.screensize(4)*3/4, 5);
end

