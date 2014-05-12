function [taskData, Data] = BattleShipsMain(taskParam, sigma, condition, Subject)

KbReleaseWait()

% Set port to 0.
if taskParam.sendTrigger == true
    lptwrite(taskParam.port,0);
end

%% generateOutcomes
%condition = 'main';
taskData = GenerateOutcomes(taskParam, sigma, condition);

%% Run trials.
for i=1:taskParam.trials %taskData.trial
    
    % Trigger: start task.
    if taskParam.sendTrigger == true
        lptwrite(taskParam.port, taskParam.startTrigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    
    % Trigger: trial onset.
    if taskParam.sendTrigger == true
        lptwrite(taskParam.port, taskParam.trialOnsetTrigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    while 1
        
        if taskData.catchTrial(i) == 1
            DrawHand(taskParam, taskData.distMean(i))
        end
        
        % Start trial - subject predicts boat.
        DrawCircle(taskParam.window)
        DrawCross(taskParam.window)
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
            elseif keyCode(taskParam.space)
                taskData.pred(i) = taskParam.rotAngle/taskParam.unit;
                
                % Trigger: prediction.
                if taskParam.sendTrigger == true
                    lptwrite(taskParam.port, taskParam.predTrigger);
                    WaitSecs(1/taskParam.sampleRate);
                    lptwrite(taskParam.port,0) % Set port to 0.
                end
                
                break
            end
        end
    end
    
    % Calculate prediction error.
    [taskData.predErr(i), taskData.predErrNorm(i), taskData.predErrPlus(i), taskData.predErrMin(i)] = Diff(taskData.outcome(i), taskData.pred(i));
    
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
    DrawOutcome(taskParam, taskData.outcome(i)) %%TRIGGER
    PredictionSpot(taskParam)
    
    % Trigger: outcome.
    if taskParam.sendTrigger
        lptwrite(taskParam.port, taskParam.outcomeTrigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    % Show baseline 2.
    DrawCross(taskParam.window)
    DrawCircle(taskParam.window)
    
    % Trigger: baseline 2.
    if taskParam.sendTrigger
        lptwrite(taskParam.port, taskParam.baseline2Trigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
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
    if taskParam.sendTrigger
        lptwrite(taskParam.port, taskParam.boatTrigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    % Show baseline 3.
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
    
    taskData.trial(i) = i;
    taskData.age(i) = str2double(Subject.age);
    taskData.ID{i} = Subject.ID;
    taskData.sex{i} = Subject.sex;
    taskData.date{i} = Subject.date;
    taskData.cond{i} = condition;
    taskData.cBal{i} = Subject.cBal;
    
end

maxMon = (length(find(taskData.boatType == 1)) * 0.2) + (length(find(taskData.boatType == 2)) * 0.1);
if isequal(taskParam.computer, 'Macbook')
    enter = 40;
elseif isequal(taskParam.computer, 'Humboldt')
    enter = 13;
end

while 1
    
    txtBreak = 'Ende des Blocks';
    txtPressEnter = 'Weiter mit Enter';
    txtFeedback = sprintf('In diesem Block hast du %.2f von %.2f Euro gewonnen', taskData.accPerf(i), maxMon);
    Screen('TextSize', taskParam.window, 50);
    DrawFormattedText(taskParam.window, txtBreak, 'center', 300);
    Screen('TextSize', taskParam.window, 30);
    DrawFormattedText(taskParam.window, txtFeedback, 'center', 'center');
    DrawFormattedText(taskParam.window, txtPressEnter, 'center', 800);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode) == enter % don't know why it does not understand return or enter?
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
