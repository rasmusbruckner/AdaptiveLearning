function BigScreen(taskParam, txtPressEnter, header, txt)
% This function draws background during the intro.

while 1
    Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0, taskParam.gParam.screensize(4)*0.16, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.16, 5);
    Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0, taskParam.gParam.screensize(4)*0.8, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.8, 5);
    Screen('FillRect', taskParam.gParam.window, [0, 25, 51], [0, (taskParam.gParam.screensize(4)*0.16)+3, taskParam.gParam.screensize(3), (taskParam.gParam.screensize(4)*0.8)-2]);
    
    
    Screen('TextSize', taskParam.gParam.window, 50);
    if isequal(taskParam.gParam.computer, 'Dresden')
        DrawFormattedText(taskParam.gParam.window, header, 'center', 50);
    else
        DrawFormattedText(taskParam.gParam.window, header, 'center', taskParam.gParam.screensize(4)*0.1);
    end
        Screen('TextSize', taskParam.gParam.window, 30);
   if isequal(taskParam.gParam.computer, 'Dresden')
      DrawFormattedText(taskParam.gParam.window, txt, 50, taskParam.gParam.screensize(4)*0.2);
   else
      DrawFormattedText(taskParam.gParam.window, txt, taskParam.gParam.screensize(4)*0.2, taskParam.gParam.screensize(4)*0.2);
   end
    
    DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('DrawingFinished', taskParam.gParam.window);
    time = GetSecs;
    Screen('Flip', taskParam.gParam.window, time + 0.1);
    
    [ ~, ~, keyCode ] = KbCheck;
    if find(keyCode)==taskParam.keys.enter% don't know why it does not understand return or enter?
        break
    end
end

KbReleaseWait()


end

