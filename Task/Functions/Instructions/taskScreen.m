function [screenIndex] = taskScreen(taskParam, texture, screenIndex)
%TASKSCREEN   Indicates the current task
%
%   Input
%       taskParam: structure containing task parameters
%       texture: texture of image that is shown on the screen
%       screenIndex: indicates current sceen of instruction phase
%   Output
%       screenIndex: updated screenIndex 

while 1
    
    if isequal(taskParam.gParam.taskType, 'chinese')
        imageRect = [0 0 1440 900];
        dstRectTemp = CenterRect(imageRect, [0 0 1440 900]);
    else
        dstRectTemp = taskParam.textures.dstRect;
    end
    
    Screen('DrawTexture', taskParam.gParam.window.onScreen, texture,[], dstRectTemp)
    
    if ~isequal(taskParam.gParam.taskType, 'chinese')
        Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');
        Screen('TextSize', taskParam.gParam.window.onScreen, 30);
        DrawFormattedText(taskParam.gParam.window.onScreen, txt, 'center', 100, [0 0 0], sentenceLength);
    end
    
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
    [~, ~, keyCode] = KbCheck;
    if find(keyCode) == taskParam.keys.enter
        screenIndex = screenIndex + 1;
        break
    end
    
end
WaitSecs(0.1);
end