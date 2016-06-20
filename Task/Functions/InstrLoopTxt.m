function [taskParam, fw, bw, Data, savedTickmark] = InstrLoopTxt(taskParam, txt, cannon, button, distMean, tickInstruction, Data)
% This function instructs participants for the control condition.
% The idea is that participants remember the last outcome and indicate
% this by aiming at this point. This requires a learning rate = 1. We are
% therefore able to dissociate sensory processes and more cognitive
% processes, that is, learning and belief updating.

%%
% Idee: predError als input. Dann am Anfang zeigen, wobei in normaler
% practice = 0 und in controlpractice = irgendwas
if exist('Data', 'var')
    
    i=1;
    fw = 0;
    bw = 0;
    
else
    
    %distMean = 0;
    %Priority(9);
    i = 1;
    fw = 0;
    bw = 0;
    pred = 0;
    predErr = 0;
    memErr = 0;
    rawPredErr = 0;
    outcome = distMean;
    tickMark = false;
    %Data = struct(taskParam.fieldNames.predErr, predErr, taskParam.fieldNames.rawPredErr, rawPredErr, taskParam.fieldNames.pred, pred, taskParam.fieldNames.outcome, outcome, 'tickMark', tickMark, 'memErr', memErr, 'distMean', distMean);
    Data = struct(taskParam.fieldNames.predErr, predErr, taskParam.fieldNames.pred, pred, taskParam.fieldNames.outcome, outcome, 'tickMark', tickMark, 'memErr', memErr, 'distMean', distMean);
    
end

% if nargin == 6
%     tickMark = true;
% else
%     tickMark = false;
% end
savedTickmarPrevious(1) = nan;
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

if ~isequal(taskParam.gParam.taskType, 'reversal')
    while 1
        
        LineAndBack(taskParam)
        sentenceLength = taskParam.gParam.sentenceLength;
        % if isequal(taskParam.gParam.computer, 'D_Pilot')
        DrawFormattedText(taskParam.gParam.window.onScreen,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], sentenceLength);
        % else
        %DrawFormattedText(taskParam.gParam.window.onScreen,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 85);
        
        %end
        
        if cannon == true
            
            Cannon(taskParam, distMean)
        end
        %     if i > 1 && taskParam.gParam.PE_Bar == true
        %         DrawPE_Bar(taskParam, Data, i-1)
        %     elseif i == 1 && taskParam.gParam.PE_Bar == true
        %         DrawPE_Bar(taskParam, Data, i-1)
        %     end
        DrawCircle(taskParam)
        PredictionSpot(taskParam)
        %if taskParam.gParam.PE_Bar == true
        %DrawPE_Bar(taskParam, Data, i)
        %elseif i == 1 && taskParam.gParam.PE_Bar == true
        %   DrawPE_Bar(taskParam, Data, i-1)
        %end
        
        if Data.tickMark == true
            
            TickMark(taskParam, Data.outcome(end), 'outc')
            TickMark(taskParam, Data.pred(end), 'pred')
        end
        DrawCross(taskParam)
        
        Aim(taskParam, Data.distMean)
        
        if isequal(button, 'arrow')
            txtPressEnter='Zurück mit Löschen - Weiter mit Enter';
            DrawFormattedText(taskParam.gParam.window.onScreen,taskParam.strings.txtPressEnter ,'center',taskParam.gParam.screensize(4)*0.9);
        end
        Screen('DrawingFinished', taskParam.gParam.window.onScreen);
        t = GetSecs;
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
        
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
else
    
    SetMouse(720, 450, taskParam.gParam.window.onScreen)
    
    while 1
        [x,y,buttons,focus,valuators,valinfo] = GetMouse(taskParam.gParam.window.onScreen);
        
        
        x = x-720;
        y = (y-450)*-1 ;
        
        currentDegree = mod( atan2(y,x) .* -180./-pi, -360 )*-1 + 90;
        if currentDegree > 360 %&& currentDegree < 90
            degree = currentDegree - 360;
        else
            degree = currentDegree;
        end
        
        taskParam.circle.rotAngle = degree * taskParam.circle.unit;%rad2deg(angle);
        
         LineAndBack(taskParam)
        sentenceLength = taskParam.gParam.sentenceLength;
        % if isequal(taskParam.gParam.computer, 'D_Pilot')
        DrawFormattedText(taskParam.gParam.window.onScreen,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], sentenceLength);
        % else
        %DrawFormattedText(taskParam.gParam.window.onScreen,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 85);
        
        %end
        
        if cannon == true
            
            Cannon(taskParam, distMean)
        end
        %     if i > 1 && taskParam.gParam.PE_Bar == true
        %         DrawPE_Bar(taskParam, Data, i-1)
        %     elseif i == 1 && taskParam.gParam.PE_Bar == true
        %         DrawPE_Bar(taskParam, Data, i-1)
    
        
        DrawCircle(taskParam)
        DrawCross(taskParam)
        if isnan(tickInstruction.savedTickmark)
            Aim(taskParam, Data.distMean)
        end

        if isequal(button, 'arrow')
            DrawFormattedText(taskParam.gParam.window.onScreen,taskParam.strings.txtPressEnter ,'center',taskParam.gParam.screensize(4)*0.9);
        end
        hyp = sqrt(x^2 + y^2);
        
        if hyp <= 150
            PredictionSpotReversal(taskParam, x ,y*-1)
        else
            PredictionSpot(taskParam)
        end
        
        %keyboard
        if buttons(2) == 1 %&& i ~= taskParam.gParam.blockIndices(1) && i ~= taskParam.gParam.blockIndices(2) + 1 && i ~= taskParam.gParam.blockIndices(3) + 1 && i ~= taskParam.gParam.blockIndices(4) + 1
            
            savedTickmark(i) = ((taskParam.circle.rotAngle) / taskParam.circle.unit);
            Data.tickCannonDev = Diff(distMean, savedTickmark);

            WaitSecs(0.2);
            press = 1;
            %keyboard
%         elseif press == 0%i > 1 && press == 0
%             %keyboard
%             savedTickmarkPrevious(i) = savedTickmarkPrevious(i - 1);
%             savedTickmark(i) = savedTickmark(i - 1);
%         elseif i == 1
%             savedTickmarPrevious(i) = 0;
%             %savedTickmark(i) = 0;
        end
        
%         if press == 1
%             savedTickmarkPrevious(i) = savedTickmark(i-1);
%         end
        % press
        %savedTickmarkPrevious
        %savedTickmark
        %savedTickmark
        %if i ~= taskParam.gParam.blockIndices(1) && i ~= taskParam.gParam.blockIndices(2) + 1 && i ~= taskParam.gParam.blockIndices(3) + 1 && i ~= taskParam.gParam.blockIndices(4) + 1
            %keyboard
            
           % TickMark(taskParam, taskData.outcome(i-1), 'outc');
           % TickMark(taskParam, taskData.pred(i-1), 'pred');
            if press == 1
                TickMark(taskParam, tickInstruction.previousOutcome, 'outc');
                TickMark(taskParam, tickInstruction.previousPrediction, 'pred');
                TickMark(taskParam, savedTickmark(i), 'saved');
                TickMark(taskParam, previousTickmark, 'saved');

            end
            %TickMark(taskParam, savedTickmark(i), 'saved');
            %keyboard
            
        %end
        Screen('DrawingFinished', taskParam.gParam.window.onScreen);
        t = GetSecs;
        
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);% taskData.actJitter(i)); %% Inter trial jitter.
        
       [ keyIsDown, ~, keyCode ] = KbCheck;
        
        %if buttons(2) == 1
        %   savedTickmark = ((taskParam.circle.rotAngle) / taskParam.circle.unit);
        if (keyIsDown && (isequal(button, 'arrow') && keyCode(taskParam.keys.enter))) || (isequal(button, 'space') &&  buttons(1) == 1)
            %if (isequal(button, 'arrow') && keyCode(taskParam.keys.enter)) || (isequal(button, 'space') &&  buttons(1) == 1)
            fw = 1;    
            Data.pred = (taskParam.circle.rotAngle / taskParam.circle.unit);
            break;
            %end
        end
%         if buttons(1) == 1
%             fw = 1;
%             taskData.pred(i) = ((taskParam.circle.rotAngle) / taskParam.circle.unit);
%             taskData.pred(i);
%             
%             time = GetSecs;
%             %                     Screen('DrawingFinished', taskParam.gParam.window.onScreen);
%             %                     t = GetSecs;
%             %
%             %                     Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);% taskData.actJitter(i)); %% Inter trial jitter.
%             
%             %keyboard
%             break
%            
%         end
        
        
        %                 Screen('DrawingFinished', taskParam.gParam.window.onScreen);
        %                 t = GetSecs;
        %
        %                 Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);% taskData.actJitter(i)); %% Inter trial jitter.
        %
        
        %keyboard
    end
    
end

%[Data.predErr, ~, ~, ~, Data.rawPredErr] = Diff(distMean, Data.pred);
Data.predErr = Diff(distMean, Data.pred);
Data.memErr = Diff(Data.outcome, Data.pred);


%%%%%%%%%


%%%%%%%%%

%KbReleaseWait()
end