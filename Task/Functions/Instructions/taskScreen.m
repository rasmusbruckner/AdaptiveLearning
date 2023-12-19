function [screenIndex] = taskScreen(taskParam, screenIndex, txt)
%TASKSCREEN   This function indicates the current task
%
%   Input
%       taskParam: structure containing task parameters
%       texture: texture of image that is shown on the screen
%       screenIndex: indicates current sceen of instruction phase
%
%   Output
%       screenIndex: updated screenIndex 


while 1
    
%     if isequal(taskParam.gParam.taskType, 'chinese')
%         imageRect = [0 0 1440 900];
%         dstRectTemp = CenterRect(imageRect, [0 0 1440 900]);
%     else
%         dstRectTemp = taskParam.textures.dstRect;
%     end
%     
    %Screen('DrawTexture', taskParam.gParam.window.onScreen, texture,[], dstRectTemp)
    
    if ~isequal(taskParam.gParam.taskType, 'chinese')
        Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
        Screen('TextSize', taskParam.display.window.onScreen, 30);
        DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', 100, [0 0 0], taskParam.strings.sentenceLength);
    end
    
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    t = GetSecs;
    Screen('Flip', taskParam.display.window.onScreen, t + 0.1);
    [~, ~, keyCode] = KbCheck( taskParam.keys.kbDev );
    if find(keyCode) == taskParam.keys.enter
        screenIndex = screenIndex + 1;
        break
    end
    
end
WaitSecs(0.1);
end