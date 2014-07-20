function [taskParam, screenIndex] = ControlLoopInstrTxt(taskParam, txt, forward, backward, needle, screenIndex)
% This function instructs participants for the control condition.
% The idea is that participants remember the last outcome and indicate
% this by aiming at this point. This requires a learning rate = 1. We are
% therefore able to dissociate sensory processes and more cognitive
% processes, that is, learning and belief updating.

distMean = 238;
%Priority(9);
while 1
   
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
   
    if isequal(taskParam.gParam.computer, 'Dresden')
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05, [255 255 255]);
    else
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1, [255 255 255]);
    
    end
    
    if needle == true
        DrawNeedle(taskParam, distMean)
    end
    DrawCircle(taskParam)
    DrawCross(taskParam)
    PredictionSpot(taskParam)
%     if button == taskParam.keys.enter
%         txtPressEnter='Weiter mit Enter';
%         DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
%     end
    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.001);
    
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
        elseif keyCode(forward)
            screenIndex = screenIndex + 1;
            break;
        elseif keyCode(backward)
            screenIndex = screenIndex - 1;
            break;    
        end
        
    end
end
%Priority(9);
KbReleaseWait()
end
