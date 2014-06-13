function [taskDataControl, dataControl] = BattleShipsControl(taskParam, sigmas, condition, Subject)

KbReleaseWait()


%% generateOutcomes
taskDataControl = GenerateOutcomes(taskParam, sigmas, condition);

%% Run trials.
for i=1:taskParam.gParam.contTrials
    
    % Trigger: start task.
     SendTrigger(taskParam, taskParam.triggers.startTrigger)
%     if taskParam.gParam.sendTrigger == true
%         lptwrite(taskParam.triggers.port, taskParam.triggers.startTrigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    
     % Trigger: trial onset.
     SendTrigger(taskParam, taskParam.triggers.trialOnsetTrigger)
%         if taskParam.gParam.sendTrigger == true
%             lptwrite(taskParam.triggers.port, taskParam.triggers.trialOnsetTrigger);
%             WaitSecs(1/taskParam.triggers.sampleRate);
%             lptwrite(taskParam.triggers.port,0) % Set port to 0.
%         end
    
    while 1
        
        % Trial onset.
        DrawCircle(taskParam.gParam.window)
        DrawCross(taskParam.gParam.window)
        PredictionSpot(taskParam)
        
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
            elseif keyCode(taskParam.keys.space)
                taskDataControl.pred(i) = (taskParam.circle.rotAngle/taskParam.circle.unit);
                
                % Trigger: prediction.
                SendTrigger(taskParam, taskParam.triggers.predTrigger)
%                 if taskParam.gParam.sendTrigger == true
%                     lptwrite(taskParam.triggers.port, taskParam.triggers.predTrigger);
%                     WaitSecs(1/taskParam.triggers.sampleRate);
%                     lptwrite(taskParam.triggers.port,0) % Set port to 0.
%                 end
                break;
            end
        end
    end
    
    % Calculate prediction error.
    [taskDataControl.predErr(i), taskDataControl.predErrNorm(i), taskDataControl.predErrPlus(i), taskDataControl.predErrMin(i)] = Diff(taskDataControl.outcome(i), taskDataControl.pred(i));
    
    if i >= 2
    % Calculate memory error.
    [taskDataControl.memErr(i), taskDataControl.memErrNorm(i), taskDataControl.memErrPlus(i), taskDataControl.memErrMin(i)] = Diff(taskDataControl.pred(i), taskDataControl.outcome(i-1));
    
    % Calculate update.
    [taskDataControl.UP(i), taskDataControl.UPNorm(i), taskDataControl.UPPlus(i), taskDataControl.UPMin(i)] = Diff(taskDataControl.pred(i), taskDataControl.pred(i-1));
    end
    
    if taskDataControl.memErr(i) <= 13 && i >=2
        taskDataControl.hit(i) = 1;
    end
    
    % Show baseline.
    DrawCross(taskParam.gParam.window)
    DrawCircle(taskParam.gParam.window)
    
    % Trigger: baseline 1.
    SendTrigger(taskParam, taskParam.triggers.baseline1Trigger)

%     if taskParam.gParam.sendTrigger == true
%         lptwrite(taskParam.triggers.port, taskParam.triggers.baseline1Trigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    
    Screen('Flip', taskParam.gParam.window);
    WaitSecs(1);
    
    % Show outcome.
    DrawCross(taskParam.gParam.window)
    DrawCircle(taskParam.gParam.window)
    DrawOutcome(taskParam, taskDataControl.outcome(i)) %%TRIGGER
    PredictionSpot(taskParam)
    
    % Trigger: outcome.
    SendTrigger(taskParam, taskParam.triggers.outcomeTrigger)

%     if taskParam.gParam.sendTrigger == true
%         lptwrite(taskParam.triggers.port, taskParam.triggers.outcomeTrigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    
    Screen('Flip', taskParam.gParam.window);
    WaitSecs(1);
    
    % Show baseline
    DrawCross(taskParam.gParam.window)
    DrawCircle(taskParam.gParam.window)
    
    % Trigger: baseline 2.
    SendTrigger(taskParam, taskParam.triggers.baseline2Trigger)

%     if taskParam.gParam.sendTrigger == true
%         lptwrite(taskParam.triggers.port, taskParam.triggers.baseline2Trigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    
    Screen('Flip', taskParam.gParam.window)
    WaitSecs(1);
    
    % Show boat and calculate performance.       %TRIGGER
    DrawCircle(taskParam.gParam.window)
    if taskDataControl.boatType(i) == 1
        DrawGoldBoat(taskParam)
        if taskDataControl.hit(i) == 1
            taskDataControl.perf(i)  =  0.2;
        end
    elseif taskDataControl.boatType(i) == 2
        DrawBronzeBoat(taskParam)
        if taskDataControl.hit(i) == 1
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
    SendTrigger(taskParam, taskParam.triggers.boatTrigger)

%     if taskParam.gParam.sendTrigger == true
%         lptwrite(taskParam.triggers.port, taskParam.triggers.boatTrigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    Screen('Flip', taskParam.gParam.window);
    WaitSecs(1);
    
    % Show baseline.
    DrawCircle(taskParam.gParam.window)
    DrawCross(taskParam.gParam.window)
    
    % Trigger: baseline 3.
    SendTrigger(taskParam, taskParam.triggers.baseline3Trigger)

%     if taskParam.gParam.sendTrigger == true
%         lptwrite(taskParam.triggers.port, taskParam.triggers.baseline3Trigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    
    Screen('Flip', taskParam.gParam.window);
    WaitSecs(1);
    
    taskDataControl.trial(i) = i;
    taskDataControl.catchTrial(i) = 999;
    taskDataControl.age(i) = str2double(Subject.age);
    taskDataControl.ID{i} = Subject.ID;
    taskDataControl.sex{i} = Subject.sex;
    taskDataControl.date{i} = Subject.date;
    taskDataControl.cBal{i} = Subject.cBal;
    taskDataControl.cond{i} = condition;
end

maxMon = (length(find(taskDataControl.boatType == 1)) * 0.2) + (length(find(taskDataControl.boatType == 2)) * 0.1);

while 1
    
    txtBreak = 'Ende des Blocks';
    txtPressEnter = 'Weiter mit Enter';
    txtFeedback = sprintf('In diesem Block hast du %.2f von %.2f Euro gewonnen', taskDataControl.accPerf(i), maxMon);
    Screen('TextSize', taskParam.gParam.window, 50);
    DrawFormattedText(taskParam.gParam.window, txtBreak, 'center', taskParam.gParam.screensize(4)*0.3);
    Screen('TextSize', taskParam.gParam.window, 30);
    DrawFormattedText(taskParam.gParam.window, txtFeedback, 'center', 'center');
    DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('Flip', taskParam.gParam.window);
    
    [~ ,~ , keyCode ] = KbCheck;
    if find(keyCode) == taskParam.keys.enter % don't know why it does not understand return or enter?
        break
    end
end

KbReleaseWait()


sigmas = repmat(sigmas, length(taskDataControl.trial),1);

fieldNames = taskParam.fieldNames;
dataControl = struct(fieldNames.ID, {taskDataControl.ID}, fieldNames.age, taskDataControl.age, fieldNames.sex, {taskDataControl.sex},...
    fieldNames.cond, {taskDataControl.cond}, fieldNames.cBal, {taskDataControl.cBal}, fieldNames.sigma, sigmas, fieldNames.trial, taskDataControl.trial,...
    fieldNames.outcome, taskDataControl.outcome, fieldNames.distMean, taskDataControl.distMean, fieldNames.cp, taskDataControl.cp,...
    fieldNames.TAC, taskDataControl.TAC, fieldNames.boatType, taskDataControl.boatType, fieldNames.catchTrial, taskDataControl.catchTrial, ...
    fieldNames.pred, taskDataControl.pred, fieldNames.predErr, taskDataControl.predErr, fieldNames.predErrNorm, taskDataControl.predErrNorm,...
    fieldNames.predErrPlus, taskDataControl.predErrPlus, fieldNames.predErrMin, taskDataControl.predErrMin,...
    fieldNames.memErr, taskDataControl.memErr, fieldNames.memErrNorm, taskDataControl.memErrNorm, fieldNames.memErrPlus, taskDataControl.memErrPlus,...
    fieldNames.memErrMin, taskDataControl.memErrMin, fieldNames.UP, taskDataControl.UP,fieldNames.UPNorm, taskDataControl.UPNorm,...
    fieldNames.UPPlus, taskDataControl.UPPlus,fieldNames.UPMin, taskDataControl.UPMin, fieldNames.hit, taskDataControl.hit,...
    fieldNames.perf, taskDataControl.perf, fieldNames.accPerf, taskDataControl.accPerf, fieldNames.date, {taskDataControl.date});

end
