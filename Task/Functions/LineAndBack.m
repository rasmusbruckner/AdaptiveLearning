function LineAndBack(window, screensize)
% This function draws the backgound during the instructions.

%In Dresden 1/3.5!

%Screen('DrawLine', window, [0 0 0], 0, screensize(4)*1/4, screensize(3), screensize(4)*1/4, 5);
Screen('DrawLine', window, [0 0 0], 0, screensize(4)*1/3.5, screensize(3), screensize(4)*1/3.5, 5);

Screen('DrawLine', window, [0 0 0], 0, screensize(4)*3/4, screensize(3), screensize(4)*3/4, 5);
Screen('FillRect', window, [0 25 51], [0, 0, screensize(3), (screensize(4)*1/4)-3]);
Screen('FillRect', window, [0 25 51], [0, screensize(4)*3/4, screensize(3), screensize(4)]);
end


