function [taskDataControl, dataControl] = BattleShipsControl(taskParam, sigma, condition, Subject)

KbReleaseWait()

% Set port to 0.
%lptwrite(taskParam.port,0);

%% generateOutcomes
% taskData = GenerateControlOutcomes(taskParam);

%taskData = GenerateOutcomes(taskParam, sigma, condition);
taskDataControl = GenerateOutcomes(taskParam, sigma, condition);
%% Run trials.
for i=1:taskParam.contTrials
    
    % Trigger: start task.
    if taskParam.sendTrigger == true
        lptwrite(taskParam.port, taskParam.startTrigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    while 1
        
        
        % Trial onset.
        DrawCircle(taskParam.window)
        DrawCross(taskParam.window)
        PredictionSpot(taskParam)
        
        
        % Trigger: trial onset.
        if taskParam.sendTrigger == true
            lptwrite(taskParam.port, taskParam.trialOnsetTrigger);
            WaitSecs(1/taskParam.sampleRate);
            lptwrite(taskParam.port,0) % Set port to 0.
        end
        
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
                taskDataControl.pred(i) = taskParam.rotAngle/taskParam.unit;
                
                % Trigger: prediction.
                if taskParam.sendTrigger == true
                    lptwrite(taskParam.port, taskParam.predTrigger);
                    WaitSecs(1/taskParam.sampleRate);
                    lptwrite(taskParam.port,0) % Set port to 0.
                end
                break;
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
    
    taskDataControl.predErrNorm(i) = sqrt((taskDataControl.outcome(i) - taskDataControl.pred(i))^2);
    taskDataControl.predErrPlus(i) = sqrt((taskDataControl.outcome(i) - taskDataControl.pred(i)+360)^2);
    taskDataControl.predErrMin(i) =  sqrt((taskDataControl.outcome(i) - taskDataControl.pred(i)-360)^2);
    if taskDataControl.predErrNorm(i) >= 0 && taskDataControl.predErrNorm(i) <= 180
        taskDataControl.predErr(i) = taskDataControl.predErrNorm(i);
    elseif taskDataControl.predErrPlus(i) >= 0 && taskDataControl.predErrPlus(i) <= 180
        taskDataControl.predErr(i) = taskDataControl.predErrPlus(i);
    else
        taskDataControl.predErr(i) = taskDataControl.predErrMin(i);
    end
    
    if taskDataControl.predErr(i) <= 13
        taskDataControl.hit(i) = 1;
    end
    
    % Show baseline.
    DrawCross(taskParam.window)
    DrawCircle(taskParam.window)
    
    % Trigger: baseline 1.
    if taskParam.sendTrigger == true
        lptwrite(taskParam.port, taskParam.baseline1Trigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    % Show outcome.
    DrawCross(taskParam.window)
    DrawCircle(taskParam.window)
    DrawOutcome(taskParam, taskDataControl.outcome(i)) %%TRIGGER
    PredictionSpot(taskParam)
    
    % Trigger: outcome.
    if taskParam.sendTrigger == true
        lptwrite(taskParam.port, taskParam.outcomeTrigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    % Show baseline
    DrawCross(taskParam.window)
    DrawCircle(taskParam.window)
    
    % Trigger: baseline 2.
    if taskParam.sendTrigger == true
        lptwrite(taskParam.port, taskParam.baseline2Trigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    Screen('Flip', taskParam.window)
    WaitSecs(1);
    
    % Show boat and calculate performance.       %TRIGGER
    DrawCircle(taskParam.window)
    if taskDataControl.boatType(i) == 1
        DrawGoldBoat(taskParam)
        if taskDataControl.predErr(i) < 13
            taskDataControl.perf(i)  =  0.2;
        end
    elseif taskDataControl.boatType(i) == 2
        DrawBronzeBoat(taskParam)
        if taskDataControl.predErr(i) < 13
            taskDataControl.perf(i) = 0.1;
        end
    else
        DrawSilverBoat(taskParam)
    end
    
    % Calculate accumulated performance.
    if i >= 2
        taskDataControl.accPerf(i) = taskDataControl.accPerf(i-1) + taskDataControl.perf(i);
    end
    
    % Trigger: boat.
    
    if taskParam.sendTrigger == true
        lptwrite(taskParam.port, taskParam.boatTrigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    % Show baseline.
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    
    % Trigger: baseline 3.
    if taskParam.sendTrigger == true
        lptwrite(taskParam.port, taskParam.baseline3Trigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    taskDataControl.trial(i) = i;
    taskDataControl.age(i) = str2double(Subject.age);
    taskDataControl.ID{i} = Subject.ID;
    taskDataControl.sex{i} = Subject.sex;
    taskDataControl.date{i} = Subject.date;
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

dataControl = struct(fID, {taskDataControl.ID}, fAge, taskDataControl.age, fSex, {taskDataControl.sex},...
    fSigma, sigma,  fTrial, taskDataControl.trial, fOutcome, taskDataControl.outcome,...
    fDistMean, taskDataControl.distMean, fCp, taskDataControl.cp,  fTAC, taskDataControl.TAC,...
    fBoatType, taskDataControl.boatType, fCatchTrial, taskDataControl.catchTrial, ...
    fPred, taskDataControl.pred, fPredErr, taskDataControl.predErr, fHit, taskDataControl.hit,...
    fPerf, taskDataControl.perf, fAccPerf, taskDataControl.accPerf, fDate, {taskDataControl.date});


end
