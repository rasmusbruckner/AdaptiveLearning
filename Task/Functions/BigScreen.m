function BigScreen(taskParam, txtPressEnter, header, txt)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

while 1
    Screen('DrawLine', taskParam.window, [0 0 0], 0, 150, 1440, 150, [5]);
    Screen('DrawLine', taskParam.window, [0 0 0], 0, 800, 1440, 800, [5]);
    Screen('FillRect', taskParam.window, [224, 255, 255], [0, 150, 1440, 795]);
    
    
    Screen('TextSize', taskParam.window, 50);
    DrawFormattedText(taskParam.window, header, 'center', 100);
    Screen('TextSize', taskParam.window, 30);
    DrawFormattedText(taskParam.window, txt, 200, 200);
    
    DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==taskParam.enter% don't know why it does not understand return or enter?
        break
    end
end

KbReleaseWait()


end

