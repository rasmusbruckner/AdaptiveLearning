function [screenIndex] = al_screenIndex(taskParam, screenIndex)
%AL_SCREENINDEX   This function tests if the participant pressed a button to go forward
%
%   Input
%       taskParam: structure containing task parameters
%       screenIndex: indicates the number of instructions screen
%
%   Output
%       screenIndex: updated number of instructions screen


% Check for keypress and update screen index
[ keyIsDown, ~, keyCode ] = KbCheck;
if keyIsDown
    if keyCode(taskParam.keys.enter)
        screenIndex = screenIndex + 1;
    elseif keyCode(taskParam.keys.delete)
        screenIndex = screenIndex - 1;
    end
end

end

