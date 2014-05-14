function [taskDataControl, dataControl] = BattleShipsControl(taskParam, sigmas, condition, Subject)

KbReleaseWait()

% Set port to 0.
%lptwrite(taskParam.port,0);

%% generateOutcomes
% taskData = GenerateControlOutcomes(taskParam);

%taskData = GenerateOutcomes(taskParam, sigma, condition);
taskDataControl = GenerateOutcomes(taskParam, sigmas, condition);

%% Run trials.
for i=1:taskParam.contTrials
    
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
        
        % Trial onset.
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
    taskDataControl.cBal{i} = Subject.cBal;
    taskDataControl.cond{i} = condition;
end

maxMon = (length(find(taskDataControl.boatType == 1)) * 0.2) + (length(find(taskDataControl.boatType == 2)) * 0.1);
if isequal(taskParam.computer, 'Macbook')
    enter = 40;
elseif isequal(taskParam.computer, 'Humboldt')
    enter = 13;
end

while 1
    
    txtBreak = 'Ende des Blocks';
    txtPressEnter = 'Weiter mit Enter';
    txtFeedback = sprintf('In diesem Block hast du %.2f von %.2f Euro gewonnen', taskDataControl.accPerf(i), maxMon);
    Screen('TextSize', taskParam.window, 50);
    DrawFormattedText(taskParam.window, txtBreak, 'center', taskParam.screensize(4)*0.3);
    Screen('TextSize', taskParam.window, 30);
    DrawFormattedText(taskParam.window, txtFeedback, 'center', 'center');
    DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode) == enter % don't know why it does not understand return or enter?
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
