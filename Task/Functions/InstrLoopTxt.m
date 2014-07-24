function [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt, cannon, button, distMean)
% This function instructs participants for the control condition.
% The idea is that participants remember the last outcome and indicate
% this by aiming at this point. This requires a learning rate = 1. We are
% therefore able to dissociate sensory processes and more cognitive
% processes, that is, learning and belief updating.


%distMean = 0;
%Priority(9);
fw = 0; 
bw = 0;
pred = 0;
predErr = 0;
rawPredErr = 0;
outcome = distMean;
Data = struct(taskParam.fieldNames.predErr, predErr, taskParam.fieldNames.rawPredErr, rawPredErr, taskParam.fieldNames.pred, pred, taskParam.fieldNames.outcome, outcome)

while 1
   
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
   
    if isequal(taskParam.gParam.computer, 'Dresden')
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05, [255 255 255]);
    else
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 85);
    
    end
    
    if cannon == true
        Cannon(taskParam, distMean)
    end
    DrawCircle(taskParam)
    DrawCross(taskParam)
    PredictionSpot(taskParam)
    if isequal(button, 'arrow')
        txtPressEnter='Zurück mit Löschen - Weiter mit Enter';
        DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    end
    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.001);
    
    
    [ keyIsDown, ~, keyCode ] = KbCheck;
        
        if keyIsDown
            if keyCode(taskParam.keys.rightKey)
                if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                    taskParam.circle.rotAngle = taskParam.circle.rotAngle + 0.75*taskParam.circle.unit; %0.02
                else
                    taskParam.circle.rotAngle = 0;
                end
            elseif keyCode(taskParam.keys.rightSlowKey)
                if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                    taskParam.circle.rotAngle = taskParam.circle.rotAngle + 0.1*taskParam.circle.unit; %0.02
                else
                    taskParam.circle.rotAngle = 0;
                end    
            elseif keyCode(taskParam.keys.leftKey)
                if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                    taskParam.circle.rotAngle = taskParam.circle.rotAngle - 0.75*taskParam.circle.unit;
                else
                    taskParam.circle.rotAngle = 360*taskParam.circle.unit;
                end
            elseif keyCode(taskParam.keys.leftSlowKey)
                if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                    taskParam.circle.rotAngle = taskParam.circle.rotAngle - 0.1*taskParam.circle.unit;
                else
                    taskParam.circle.rotAngle = 360*taskParam.circle.unit;
                end    
        elseif (isequal(button, 'arrow') && keyCode(taskParam.keys.enter)) || (isequal(button, 'space') && keyCode(taskParam.keys.space))
            fw = 1;
            Data.pred = (taskParam.circle.rotAngle / taskParam.circle.unit);
            break;
        elseif (isequal(button, 'arrow') && keyCode(taskParam.keys.delete)) || (isequal(button, 'space') && keyCode(taskParam.keys.delete))
            bw = 1;
            break
            end
        end
%Priority(9);

end

[Data.predErr, ~, ~, ~, Data.rawPredErr] = Diff(distMean, Data.pred);



%%%%%%%%%


%%%%%%%%%

%KbReleaseWait()
end