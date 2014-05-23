function taskParam = ControlLoopInstrTxt(taskParam, txt, button, hand)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


distMean = 238;
while 1
    
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1, [0 0 0]);
    
    DrawCircle(taskParam.gParam.window)
    DrawCross(taskParam.gParam.window)
    if hand == true
    DrawHand(taskParam, distMean)
    end
    PredictionSpot(taskParam)
    if button == taskParam.keys.enter
        txtPressEnter='Weiter mit Enter';
        DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    end
    Screen('Flip', taskParam.gParam.window);
    
    
    
    
    [ keyIsDown, ~, keyCode ] = KbCheck;
    
    if keyIsDown
        if keyCode(taskParam.keys.rightKey)
            if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle + 1*taskParam.circle.unit; %0.02
            else
                taskParam.circle.rotAngle = 0;
            end
        elseif keyCode(taskParam.keys.leftKey)
            if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle - 1*taskParam.circle.unit;
            else
                taskParam.circle.rotAngle = 360*taskParam.circle.unit;
            end
        elseif keyCode(button) %keyCode(taskParam.space)
            break;
        end
    end
end

 KbReleaseWait()