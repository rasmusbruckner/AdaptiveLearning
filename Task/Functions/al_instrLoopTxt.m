function [taskParam, fw, Data, savedTickmark] = al_instrLoopTxt(taskParam, txt, cannon, button, distMean, tickInstruction, Data)
%INSTRLOOPTXT   Participant is able to perform parts of the task while seeing instructions on the screen
%
%
% Add more comments!


if exist('Data', 'var')
    i = 1;
    fw = 0;
else
    i = 1;
    fw = 0;
    pred = 0;
    predErr = 0;
    memErr = 0;
    outcome = distMean;
    tickMark = false;
    Data = struct(taskParam.fieldNames.predErr, predErr,...
        taskParam.fieldNames.pred, pred, taskParam.fieldNames.outcome,...
        outcome, 'tickMark', tickMark, 'memErr', memErr, 'distMean',...
        distMean);
end

savedTickmark(1) = nan;
previousTickmark = nan;
Data.tickCannonDev = nan;

if ~isnan(tickInstruction.savedTickmark)
    previousTickmark = tickInstruction.savedTickmark;
    press = 1;
else
    savedTickmark(1) = nan;
    press = 0;
end

if ~isequal(taskParam.gParam.taskType, 'reversal') &&...
        ~isequal(taskParam.gParam.taskType, 'chinese') &&...
        ~isequal(taskParam.gParam.taskType, 'ARC')
   
    while 1    
        al_lineAndBack(taskParam)
        sentenceLength = taskParam.gParam.sentenceLength;
        DrawFormattedText(taskParam.gParam.window.onScreen,txt,...
            taskParam.gParam.screensize(3)*0.1,...
            taskParam.gParam.screensize(4)*0.05, [255 255 255],...
            sentenceLength);
        if cannon == true   
            al_drawCannon(taskParam, distMean);
        end
        
        al_drawCircle(taskParam)
        al_predictionSpot(taskParam)

        if Data.tickMark == true
            
            TickMark(taskParam, Data.outcome(end), 'outc')
            TickMark(taskParam, Data.pred(end), 'pred')
        end
        al_drawCross(taskParam)
        
        al_aim(taskParam, Data.distMean)
        
        if isequal(button, 'arrow')
            txtPressEnter='Zurück mit Löschen - Weiter mit Enter';
            DrawFormattedText(taskParam.gParam.window.onScreen,...
                taskParam.strings.txtPressEnter ,'center',...
                taskParam.gParam.screensize(4)*0.9);
        end
        
        Screen('DrawingFinished', taskParam.gParam.window.onScreen);
        t = GetSecs;
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
        
        [ keyIsDown, ~, keyCode ] = KbCheck;
        if keyIsDown
            if keyCode(taskParam.keys.rightKey)
                if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                    taskParam.circle.rotAngle =...
                        taskParam.circle.rotAngle +...
                        0.75*taskParam.circle.unit; 
                else
                    taskParam.circle.rotAngle = 0;
                end
            elseif keyCode(taskParam.keys.rightSlowKey)
                if taskParam.circle.rotAngle...
                        < 360*taskParam.circle.unit
                    taskParam.circle.rotAngle =...
                        taskParam.circle.rotAngle +...
                        0.1*taskParam.circle.unit; 
                else
                    taskParam.circle.rotAngle = 0;
                end
            elseif keyCode(taskParam.keys.leftKey)
                if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                    taskParam.circle.rotAngle =...
                        taskParam.circle.rotAngle -...
                        0.75*taskParam.circle.unit;
                else
                    taskParam.circle.rotAngle = 360*taskParam.circle.unit;
                end
            elseif keyCode(taskParam.keys.leftSlowKey)
                if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                    taskParam.circle.rotAngle =...
                        taskParam.circle.rotAngle -...
                        0.1*taskParam.circle.unit;
                else
                    taskParam.circle.rotAngle = 360*taskParam.circle.unit;
                end
            elseif (isequal(button, 'arrow')...
                    && keyCode(taskParam.keys.enter))...
                    || (isequal(button, 'space')...
                    && keyCode(taskParam.keys.space))
                fw = 1;
                Data.pred = (taskParam.circle.rotAngle...
                    / taskParam.circle.unit);
                break;
                
            elseif (isequal(button, 'arrow')...
                    && keyCode(taskParam.keys.delete))...
                    || (isequal(button, 'space')...
                    && keyCode(taskParam.keys.delete))
                bw = 1;
                break
            end
        end
        
    end
else
    
    SetMouse(720, 450, taskParam.gParam.window.onScreen)
    
    while 1
        [x,y,buttons,focus,valuators,valinfo] = GetMouse(taskParam.gParam.window.onScreen);
        
        x = x-720;
        y = (y-450)*-1 ;
        
        currentDegree = mod( atan2(y,x) .* -180./-pi, -360 )*-1 + 90;
        if currentDegree > 360 
            degree = currentDegree - 360;
        else
            degree = currentDegree;
        end
        
        taskParam.circle.rotAngle = degree * taskParam.circle.unit;
        
        al_lineAndBack(taskParam)
        sentenceLength = taskParam.gParam.sentenceLength;
        DrawFormattedText(taskParam.gParam.window.onScreen,txt, taskParam.gParam.screensize(3)*0.1, taskParam.gParam.screensize(4)*0.05, [255 255 255], sentenceLength);

        if isequal(taskParam.gParam.taskType, 'chinese')
            currentContext = 1;
            al_drawContext(taskParam, currentContext)
        end
        
        al_drawCircle(taskParam)
        al_drawCross(taskParam)
        if isnan(tickInstruction.savedTickmark)
            al_aim(taskParam, Data.distMean)
        end
        
        if cannon == true
            al_drawCannon(taskParam, distMean, 0)
        end
        
        if isequal(button, 'arrow')
            DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter ,'center', taskParam.gParam.screensize(4)*0.9);
        end
        hyp = sqrt(x^2 + y^2);
        
        if hyp <= 150
            al_predictionSpotReversal(taskParam, x ,y*-1)
        else
            al_predictionSpot(taskParam)
        end
        
        if buttons(2) == 1 
            
            savedTickmark(i) = ((taskParam.circle.rotAngle) / taskParam.circle.unit);
            Data.tickCannonDev = al_diff(distMean, savedTickmark);
            
            WaitSecs(0.2);
            press = 1;
            
        end
        
        if press == 1
            TickMark(taskParam, tickInstruction.previousOutcome, 'outc');
            TickMark(taskParam, tickInstruction.previousPrediction, 'pred');
            TickMark(taskParam, savedTickmark(i), 'saved');
            TickMark(taskParam, previousTickmark, 'saved');  
        end
        
        Screen('DrawingFinished', taskParam.gParam.window.onScreen);
        t = GetSecs;
        
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
        
        [ keyIsDown, ~, keyCode ] = KbCheck;
        
        if (keyIsDown && (isequal(button, 'arrow') && keyCode(taskParam.keys.enter))) || (isequal(button, 'space') &&  buttons(1) == 1)
            fw = 1;
            Data.pred = (taskParam.circle.rotAngle / taskParam.circle.unit);
            break;
            
        end
        
    end
    
end

Data.predErr = al_diff(distMean, Data.pred);
Data.memErr = al_diff(Data.outcome, Data.pred);

end