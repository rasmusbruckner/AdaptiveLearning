function NoiseIndication(taskParam, txtNoise, txtPressEnter)
% This function tells the participant whether he is in a high or low
% volatility environment.

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

