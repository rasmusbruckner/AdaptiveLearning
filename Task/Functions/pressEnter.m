function pressEnter(taskParam)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==taskParam.enter% don't know why it does not understand return or enter?
        break
    end
end

end

