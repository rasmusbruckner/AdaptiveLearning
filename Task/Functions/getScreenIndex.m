function [screenIndex] = getScreenIndex(taskParam, screenIndex)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[ keyIsDown, ~, keyCode ] = KbCheck;
    if keyIsDown
        if keyCode(taskParam.keys.enter)
            screenIndex = screenIndex + 1;
            %break
        elseif keyCode(taskParam.keys.delete)
            screenIndex = screenIndex - 1;
            %break
        end
    end

end

