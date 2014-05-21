function [taskData, Data] = BattleShipsMain(taskParam, sigma, condition, Subject)

KbReleaseWait()

% Set port to 0.
if taskParam.gParam.sendTrigger == true
    lptwrite(taskParam.triggers.port,0);
end

%% generateOutcomes
%condition = 'main';
taskData = GenerateOutcomes(taskParam, sigma, condition);

%% Run trials.
for i=1:taskData.trial %taskData.trial
    
    % Trigger: start task.
    SendTrigger(taskParam, taskParam.triggers.startTrigger)
%     if taskParam.gParam.sendTrigger == true
%         lptwrite(taskParam.triggers.port, taskParam.triggers.startTrigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    
    
    % Trigger: trial onset.
    SendTrigger(taskParam, taskParam.triggers.trialOnsetTrigger)
%     if taskParam.gParam.sendTrigger == true
%         lptwrite(taskParam.triggers.port, taskParam.triggers.trialOnsetTrigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    
    while 1
        
        if taskData.catchTrial(i) == 1
            DrawHand(taskParam, taskData.distMean(i))
        end
        
        % Start trial - subject predicts boat.
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
                taskData.pred(i) = taskParam.circle.rotAngle/taskParam.circle.unit;
                
                % Trigger: prediction.
                SendTrigger(taskParam, taskParam.triggers.predTrigger)
%                 if taskParam.gParam.sendTrigger == true
%                     lptwrite(taskParam.triggers.port, taskParam.triggers.predTrigger);
%                     WaitSecs(1/taskParam.triggers.sampleRate);
%                     lptwrite(taskParam.triggers.port,0) % Set port to 0.
%                 end
                
                break
            end
        end
    end


    
    % Calculate prediction error.
    [taskData.predErr(i), taskData.predErrNorm(i), taskData.predErrPlus(i), taskData.predErrMin(i)] = Diff(taskData.outcome(i), taskData.pred(i));
    
    % Calculate hits
    if taskData.predErr(i) <= 13
        taskData.hit(i) = 1;
    end
    
    if i >= 2
        % Calculate update.
        [taskData.UP(i), taskData.UPNorm(i), taskData.UPPlus(i), taskData.UPMin(i)] = Diff(taskData.pred(i), taskData.pred(i-1));
    end
    
    % Memory error = 99 because there is no memory error in this condition.
    taskData.memErr(i) = 999;
    taskData.memErrNorm(i) = 999;
    taskData.memErrPlus(i) = 999;
    taskData.memErrMin(i) = 999;
    
    % Show baseline 1.
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
    DrawOutcome(taskParam, taskData.outcome(i)) %%TRIGGER
    PredictionSpot(taskParam)
    
    % Trigger: outcome.
    SendTrigger(taskParam, taskParam.triggers.outcomeTrigger)
%     if taskParam.gParam.sendTrigger
%         lptwrite(taskParam.triggers.port, taskParam.triggers.outcomeTrigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    
    Screen('Flip', taskParam.gParam.window);
    WaitSecs(1);
    
    % Show baseline 2.
    DrawCross(taskParam.gParam.window)
    DrawCircle(taskParam.gParam.window)
    
    % Trigger: baseline 2.
    SendTrigger(taskParam, taskParam.triggers.baseline2Trigger)
%     if taskParam.gParam.sendTrigger
%         lptwrite(taskParam.triggers.port, taskParam.triggers.baseline2Trigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    
    Screen('Flip', taskParam.gParam.window)
    WaitSecs(1);
    
    % Show boat and calculate performance.       %TRIGGER
    DrawCircle(taskParam.gParam.window)
    if taskData.boatType(i) == 1
        DrawGoldBoat(taskParam)
        if taskData.hit(i) == 1
            taskData.perf(i)  =  0.2;
        end
    elseif taskData.boatType(i) == 2
        DrawBronzeBoat(taskParam)
        if taskData.hit(i) == 1;
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
    SendTrigger(taskParam, taskParam.triggers.boatTrigger)
%     if taskParam.gParam.sendTrigger
%         lptwrite(taskParam.triggers.port, taskParam.triggers.boatTrigger);
%         WaitSecs(1/taskParam.triggers.sampleRate);
%         lptwrite(taskParam.triggers.port,0) % Set port to 0.
%     end
    
    Screen('Flip', taskParam.gParam.window);
    WaitSecs(1);
    
    % Show baseline 3.
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
    
    taskData.trial(i) = i;
    taskData.age(i) = str2double(Subject.age);
    taskData.ID{i} = Subject.ID;
    taskData.sex{i} = Subject.sex;
    taskData.date{i} = Subject.date;
    taskData.cond{i} = condition;
    taskData.cBal{i} = Subject.cBal;
    
end

maxMon = (length(find(taskData.boatType == 1)) * 0.2) + (length(find(taskData.boatType == 2)) * 0.1);


while 1
    if isequal(condition, 'practice')
        txtFeedback = sprintf('In diesem Block hättest du %.2f von %.2f Euro gewonnen', taskData.accPerf(i), maxMon);
    else
        txtFeedback = sprintf('In diesem Block hast du %.2f von %.2f Euro gewonnen', taskData.accPerf(i), maxMon);
    end
    txtBreak = 'Ende des Blocks';
    txtPressEnter = 'Weiter mit Enter';
    Screen('TextSize', taskParam.gParam.window, 50);
    DrawFormattedText(taskParam.gParam.window, txtBreak, 'center', taskParam.gParam.screensize(4)*0.3);
    Screen('TextSize', taskParam.gParam.window, 30);
    DrawFormattedText(taskParam.gParam.window, txtFeedback, 'center', 'center');
    DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('Flip', taskParam.gParam.window);
    
    [~, ~, keyCode ] = KbCheck;
    if find(keyCode) == taskParam.keys.enter % don't know why it does not understand return or enter?
        break
    end
end

KbReleaseWait()


sigma = repmat(sigma, length(taskData.trial),1);

%% Save data.

fieldNames = taskParam.fieldNames;
Data = struct(fieldNames.ID, {taskData.ID}, fieldNames.age, taskData.age, fieldNames.sex, {taskData.sex},...
    fieldNames.cond, {taskData.cond}, fieldNames.cBal, {taskData.cBal}, fieldNames.sigma, sigma, fieldNames.trial, taskData.trial,...
    fieldNames.outcome, taskData.outcome, fieldNames.distMean, taskData.distMean, fieldNames.cp, taskData.cp,...
    fieldNames.TAC, taskData.TAC, fieldNames.boatType, taskData.boatType, fieldNames.catchTrial, taskData.catchTrial, ...
    fieldNames.pred, taskData.pred, fieldNames.predErr, taskData.predErr, fieldNames.predErrNorm, taskData.predErrNorm,...
    fieldNames.predErrPlus, taskData.predErrPlus, fieldNames.predErrMin, taskData.predErrMin,...
    fieldNames.memErr, taskData.memErr, fieldNames.memErrNorm, taskData.memErrNorm, fieldNames.memErrPlus, taskData.memErrPlus,...
    fieldNames.memErrMin, taskData.memErrMin, fieldNames.UP, taskData.UP,fieldNames.UPNorm, taskData.UPNorm,...
    fieldNames.UPPlus, taskData.UPPlus, fieldNames.UPMin, taskData.UPMin, fieldNames.hit, taskData.hit,...
    fieldNames.perf, taskData.perf, fieldNames.accPerf, taskData.accPerf, fieldNames.date, {taskData.date});

end
