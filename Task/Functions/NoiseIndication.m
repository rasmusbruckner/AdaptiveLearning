function NoiseIndication(taskParam, txtNoise, txtPressEnter)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


while 1
    
    DrawFormattedText(taskParam.gParam.window, txtNoise, 'center','center');
    DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('Flip', taskParam.gParam.window);
    
    [ keyIsDown, ~, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode) == taskParam.keys.enter
            break
        end
    end
end

end

