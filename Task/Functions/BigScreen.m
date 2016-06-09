function [fw, bw] = BigScreen(taskParam, txtPressEnter, header, txt, feedback)
% This function draws background during the intro.
fw = 0;
bw = 0;

while 1
       
    Screen('FillRect', taskParam.gParam.window.onScreen, [66 66 66]);
    Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], 0, taskParam.gParam.screensize(4)*0.16, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.16, 5);
    Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], 0, taskParam.gParam.screensize(4)*0.8, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.8, 5);
    Screen('FillRect', taskParam.gParam.window.onScreen, [0, 25, 51], [0, (taskParam.gParam.screensize(4)*0.16)+3, taskParam.gParam.screensize(3), (taskParam.gParam.screensize(4)*0.8)-2]);
    
    
    Screen('TextSize', taskParam.gParam.window.onScreen, 30);
    if isequal(taskParam.gParam.computer, 'Dresden')
        DrawFormattedText(taskParam.gParam.window.onScreen, header, 'center', 50, [255 255 255]);
    else
        DrawFormattedText(taskParam.gParam.window.onScreen, header, 'center', taskParam.gParam.screensize(4)*0.1, [255 255 255]);
    end
   
    if isequal(taskParam.gParam.computer, 'Dresden')
        Screen('TextSize', taskParam.gParam.window.onScreen, 19);
    else
        Screen('TextSize', taskParam.gParam.window.onScreen, 30);
    end
        
        
   sentenceLength = taskParam.gParam.sentenceLength; % Dresde Pilot 100   

   if feedback == true
      DrawFormattedText(taskParam.gParam.window.onScreen, txt, 'center', 'center', [255 255 255], sentenceLength, [], [], 1);
   %elseif feedback == false && (isequal(taskParam.gParam.computer, 'D_Pilot') || isequal(taskParam.gParam.computer, 'Macbook'))
   else
   DrawFormattedText(taskParam.gParam.window.onScreen, txt, taskParam.gParam.screensize(4)*0.2, taskParam.gParam.screensize(4)*0.2, [255 255 255], sentenceLength, [], [], 1);
   end
    
    DrawFormattedText(taskParam.gParam.window.onScreen,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    time = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, time + 0.1);
    
    [ ~, ~, keyCode ] = KbCheck;
    if keyCode(taskParam.keys.enter) && ~taskParam.unitTest% don't know why it does not understand return or enter?
        fw = 1;
        break
    elseif keyCode(taskParam.keys.delete) && ~taskParam.unitTest     
        bw = 1;
        break
    elseif taskParam.unitTest  
        WaitSecs(1);
        break
    end
end

KbReleaseWait();


end

