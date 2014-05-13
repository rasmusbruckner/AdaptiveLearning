function BigScreen(taskParam, txtPressEnter, header, txt)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

while 1
    Screen('DrawLine', taskParam.window, [0 0 0], 0, taskParam.screensize(4)*0.16, taskParam.screensize(3), taskParam.screensize(4)*0.16, [5]);
    Screen('DrawLine', taskParam.window, [0 0 0], 0, taskParam.screensize(4)*0.8, taskParam.screensize(3), taskParam.screensize(4)*0.8, [5]);
    Screen('FillRect', taskParam.window, [224, 255, 255], [0, (taskParam.screensize(4)*0.16)+3, taskParam.screensize(3), (taskParam.screensize(4)*0.8)-2]);
    
    
    Screen('TextSize', taskParam.window, 50);
    DrawFormattedText(taskParam.window, header, 'center', taskParam.screensize(4)*0.1);
    Screen('TextSize', taskParam.window, 30);
    DrawFormattedText(taskParam.window, txt, taskParam.screensize(4)*0.2, taskParam.screensize(4)*0.2);
    
    DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==taskParam.enter% don't know why it does not understand return or enter?
        break
    end
end

KbReleaseWait()


end

