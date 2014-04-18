function RewardHigh(window)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

reward = '10 Cent'    
Screen('TextSize', window, 40);
DrawFormattedText(window, reward, 'center', 'center', [0 255 0]); 
Screen('TextSize', window, 24);

end

