function [screenIndex] = ScreenIndex(taskParam, screenIndex)
%SCREENINDEX   Tests whether the participant pressed a button to go 
%forward

[ keyIsDown, ~, keyCode ] = KbCheck;
    if keyIsDown
        if keyCode(taskParam.keys.enter)
            screenIndex = screenIndex + 1;
        elseif keyCode(taskParam.keys.delete)
            screenIndex = screenIndex - 1;  
        end
    end
end

