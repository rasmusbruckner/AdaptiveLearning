function LineAndBack(window)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Screen('DrawLine', window, [0 0 0], 0, 300, 1440, 300, [5]);
Screen('DrawLine', window, [0 0 0], 0, 600, 1440, 600, [5]);
Screen('FillRect', window, [224, 255, 255], [0, 0, 1440, 297]);

end

