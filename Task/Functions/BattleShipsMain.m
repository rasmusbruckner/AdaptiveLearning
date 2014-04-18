function [taskData, Data] = BattleShipsMain(taskParam, sigma, Subject)

KbReleaseWait()

% Set port to 0.
%lptwrite(taskParam.port,0); 

%% generateOutcomes
condition = 'main';
taskData = GenerateOutcomes(taskParam, sigma, condition);

%% Run trials.
for i=1:taskParam.trials
    
    % Trigger: start task.
%     lptwrite(taskParam.port, taskParam.startTrigger);
%     WaitSecs(1/taskParam.sampleRate);
%     lptwrite(taskParam.port,0) % Port wieder auf null stellen
    
    
    if i == 2
        
        while 1
            
            
            txtBreak = 'Pause';       
            txtPressEnter = 'Weiter mit Enter';
            txtFeedback = sprintf('In diesem Block hast du %.2f von 5 Euro gewonnen.', taskData.accPerf(i-1));
            Screen('TextSize', taskParam.window, 50);
             
            DrawFormattedText(taskParam.window, txtBreak, 'center', 300);
            
            Screen('TextSize', taskParam.window, 30);
            DrawFormattedText(taskParam.window, txtFeedback, 'center', 'center');
            DrawFormattedText(taskParam.window, txtPressEnter, 'center', 800);

            
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if find(keyCode) == 40 % don't know why it does not understand return or enter?
                break
            end
        end
    end
    
    while 1
        
        if taskData.catchTrial(i) == 1
        DrawHand(taskParam, taskData.distMean(i))
        end
        
        % Start trial - subject predicts boat. 
        DrawCircle(taskParam.window)
        DrawCross(taskParam.window)
        PredictionSpot(taskParam)
        
        % Trigger: trial onset.
%         lptwrite(taskParam.port, taskParam.trialOnsetTrigger);
%         WaitSecs(1/taskParam.sampleRate);
%         lptwrite(taskParam.port,0) % Port wieder auf null stellen
        
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
            elseif keyCode(taskParam.space)
                taskData.pred(i) = taskParam.rotAngle/taskParam.unit;
                
                % Trigger: prediction.
%                 lptwrite(taskParam.taskParam.port, taskParam.predictionTrigger);
%                 WaitSecs(1/taskParam.sampleRate);
%                 lptwrite(taskParam.port,0) % Port wieder auf null stellen
                
                break
            end
        end
    end
    
% Calculate prediction error:
%   We have to calculate different prediction errors because the normal 
%   prediction error is calculated from the beginning of the line       
%   (degrees on the circle) to the end of the line (360 degrees).    
%   However, on a circle a prediction error cannot be bigger than 180 degrees.  
%   Therefore we also add and subtract 360 degrees to the normal prediction 
%   error and choose the 'right' one which is bigger than zero and smaller than 180 degrees.     
    
    taskData.predErrNorm(i) = sqrt((taskData.outcome(i) - taskData.pred(i))^2);
    taskData.predErrPlus(i) = sqrt((taskData.outcome(i) - taskData.pred(i)+360)^2);
    taskData.predErrMin(i) =  sqrt((taskData.outcome(i) - taskData.pred(i)-360)^2);
    if taskData.predErrNorm(i) >= 0 && taskData.predErrNorm(i) <= 180
        taskData.predErr(i) = taskData.predErrNorm(i);
    elseif taskData.predErrPlus(i) >= 0 && taskData.predErrPlus(i) <= 180
        taskData.predErr(i) = taskData.predErrPlus(i);
    else
        taskData.predErr(i) = taskData.predErrMin(i);
    end
    
    if taskData.predErr(i) <= 13
        taskData.hit(i) = 1;
    end
    
    % Show baseline 1.
    DrawCross(taskParam.window)
    DrawCircle(taskParam.window)
    
    % Trigger: baseline 1.
%     lptwrite(taskParam.port, taskParam.baseline1Trigger);
%     WaitSecs(1/taskParam.sampleRate);
%     lptwrite(taskParam.port,0) % Port wieder auf null stellen
    
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    % Show outcome.
    DrawCross(taskParam.window)
    DrawCircle(taskParam.window)
    DrawOutcome(taskParam, taskData.outcome(i)) %%TRIGGER
    PredictionSpot(taskParam)
    
    % Trigger: outcome.
%     lptwrite(taskParam.port, taskParam.outcomeTrigger);
%     WaitSecs(1/taskParam.sampleRate);
%     lptwrite(taskParam.port,0) % Port wieder auf null stellen
     
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    % Show baseline 2.
    DrawCross(taskParam.window)
    DrawCircle(taskParam.window)
    
    % Trigger: baseline 2.
%     lptwrite(taskParam.port, taskParam.baseline2Trigger);
%     WaitSecs(1/taskParam.sampleRate);
%     lptwrite(taskParam.port,0) % Port wieder auf null stellen
    
    Screen('Flip', taskParam.window)
    WaitSecs(1);
    
    % Show boat and calculate performance.       %TRIGGER
    DrawCircle(taskParam.window)
    if taskData.boatType(i) == 1
        DrawGoldBoat(taskParam)
        if taskData.predErr(i) < 13
            taskData.perf(i)  =  0.2;
        end
    elseif taskData.boatType(i) == 2
        DrawBronzeBoat(taskParam)
        if taskData.predErr(i) < 13
            taskData.perf(i) = 0.1;
        end
    else
        DrawSilverBoat(taskParam)     
    end
    
    % Calculate accumulated performance.
    if i >= 2
        taskData.accPerf(i) = taskData.accPerf(i-1) + taskData.perf(i);
    end
    
    % Trigger: boat.
%     lptwrite(taskParam.port, taskParam.boatTrigger);
%     WaitSecs(1/taskParam.sampleRate);
%     lptwrite(taskParam.port,0) % Port wieder auf null stellen
    
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    % Show baseline 3.
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    
    % Trigger: baseline 3.
%     lptwrite(taskParam.port, taskParam.baseline3Trigger);
%     WaitSecs(1/taskParam.sampleRate);
%     lptwrite(taskParam.port,0) % Port wieder auf null stellen
    
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    taskData.trial(i) = i;
    taskData.age(i) = str2double(Subject.age);
    taskData.ID{i} = Subject.ID;
    taskData.sex{i} = Subject.sex;
    taskData.date{i} = Subject.date;
end


%% Save data.

fID = 'ID';
fAge = 'age';
fSex = 'sex';
fSigma = 'sigma';
fTrial = 'trial';
fOutcome = 'outcome';
fDistMean = 'distMean';
fCp = 'cp';
fTAC = 'TAC';
fBoatType = 'boatType';
fCatchTrial = 'catchTrial';
fPred = 'pred';
fPredErr = 'predErr';
fHit = 'hit';
fPerf = 'perf';
fAccPerf ='accPerf';
fDate = 'date';

Data = struct(fID, {taskData.ID}, fAge, taskData.age, fSex, {taskData.sex},...
    fSigma, sigma,  fTrial, taskData.trial, fOutcome, taskData.outcome,...
    fDistMean, taskData.distMean, fCp, taskData.cp,  fTAC, taskData.TAC,...
    fBoatType, taskData.boatType, fCatchTrial, taskData.catchTrial, ...
    fPred, taskData.pred, fPredErr, taskData.predErr, fHit, taskData.hit,...
    fPerf, taskData.perf, fAccPerf, taskData.accPerf, fDate, {taskData.date});

end
