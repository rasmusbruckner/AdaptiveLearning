function al_lineAndBack(taskParam)
%AL_LINEANDBACK   This function draws the background for intructions in the cannon task
%
%   Input
%       taskParam: structure containing task parameters
%
%   Output
%       ~


if ~isequal(taskParam.gParam.taskType, 'chinese')
    if isequal(taskParam.colors.background, 'black')
        col = taskParam.colors.black;
    else
        col = taskParam.colors.gray;
    end
    Screen('FillRect', taskParam.display.window.onScreen, col);
    
    % Present background texture
    if isequal(taskParam.trialflow.background, 'picture')
        Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.backgroundTxt,[], taskParam.display.backgroundCoords, []);
    end
    if isequal(taskParam.colors.background, 'black')
        col = taskParam.colors.black;
    else
        col = taskParam.colors.darkBlue;
   end
    Screen('FillRect', taskParam.display.window.onScreen, col, [0, 0, taskParam.display.screensize(3), (taskParam.display.screensize(4)*1/4)]);% -3
    Screen('FillRect', taskParam.display.window.onScreen, col, [0, taskParam.display.screensize(4)*3/4, taskParam.display.screensize(3), taskParam.display.screensize(4)]);   
    
    if ~isequal(taskParam.trialflow.background, 'picture')
        Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*1/4, taskParam.display.screensize(3), taskParam.display.screensize(4)*1/4, 5);
        Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*3/4, taskParam.display.screensize(3), taskParam.display.screensize(4)*3/4, 5);
    end
else
    Screen('FillRect', taskParam.display.window.onScreen, [66 66 66]);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*1/4, taskParam.display.screensize(3), taskParam.display.screensize(4)*1/4, 5);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*6/7, taskParam.display.screensize(3), taskParam.display.screensize(4)*6/7, 5);
    Screen('FillRect', taskParam.display.window.onScreen, [0 25 51], [0, 0, taskParam.display.screensize(3), (taskParam.display.screensize(4)*1/4)-3]);
    Screen('FillRect', taskParam.display.window.onScreen, [0 25 51], [0, taskParam.display.screensize(4)*6/7, taskParam.display.screensize(3), taskParam.display.screensize(4)]);
end


