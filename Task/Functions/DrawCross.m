function DrawCross(window)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

screensize =  get(0,'MonitorPositions');
screensize = (screensize(3:4));
zero = screensize / 2;



Screen('DrawLine', window, [0 0 0], zero(1) - 10, zero(2), zero(1)+10 , zero(2), [3]); %710, 450, 730 , 450
Screen('DrawLine', window, [0 0 0], zero(1), zero(2) - 10, zero(1) , zero(2) + 10, [3]);%720, 440, 720 , 460

end

