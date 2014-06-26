function LineAndBack(window, screensize)
% This function draws the backgound during the instructions.

Screen('DrawLine', window, [0 0 0], 0, screensize(4)*1/3, screensize(3), screensize(4)*1/3, 5);
Screen('DrawLine', window, [0 0 0], 0, screensize(4)*2/3, screensize(3), screensize(4)*2/3, 5);
Screen('FillRect', window, [224, 255, 255], [0, 0, screensize(3), (screensize(4)*1/3)-3]);
end

