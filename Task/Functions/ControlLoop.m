function taskParam = ControlLoop(taskParam, txt, button)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

screensize = get(0,'MonitorPositions');

distMean = 238;
while 1
    
    LineAndBack(taskParam.window)
    DrawFormattedText(taskParam.window,txt,screensize(3)*0.15,screensize(4)*0.1, [0 0 0]);
    
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    DrawHand(taskParam, distMean)
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    if keyIsDown
        if keyCode(taskParam.rightKey)
            if taskParam.rotAngle < 360*taskParam.unit
                taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
            else
                taskParam.rotAngle = 0;
            end
        elseif keyCode(taskParam.leftKey)
            if taskParam.rotAngle > 0*taskParam.unit
                taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
            else
                taskParam.rotAngle = 360*taskParam.unit;
            end
        elseif keyCode(button) %keyCode(taskParam.space)
            break;
        end
    end
end

 KbReleaseWait()