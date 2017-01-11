function al_conditionIndication(taskParam, txtNoise, txtPressEnter)
%CONDITIONINDICATION displays the current task condition

DrawFormattedText(taskParam.gParam.window, txtNoise, 'center','center',...
    [255 255 255]);
DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',...
    taskParam.gParam.screensize(4)*0.9);
Screen('DrawingFinished', taskParam.gParam.window);
t = GetSecs;
Screen('Flip', taskParam.gParam.window, t + 0.1);
if ~taskParam.unitTest
    while 1
        
        [ keyIsDown, ~, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode) == taskParam.keys.enter;
                break
            end
        end
    end
else
    WaitSecs(1);
end


end

