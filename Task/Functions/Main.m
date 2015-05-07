function [taskData, Data] = Main(taskParam, vola, sigma, condition, Subject)
% This function acutally runs the task. You can specify "main",
% "practice" or "control". This loop is optimized for triggering accuracy.

%% Events
% Trigger 1: Trial Onset (subject presses buttons to indicate prediction)
% Trigger 2: Prediction/Fixation Cross 1: When subject presses Space until 500 mSec
% Trigger 3: Outcome: 500 - 1000 mSec
% Trigger 4: Fixation Cross 2: 1000 - 2000 mSec
% Trigger 5: Shield: 2000 - 2500 mSec
% Trigger 6: Fixation Cross 3: 2500 - 3500 mSec
% Trigger 7: Trial Summary (no timing trigger)

KbReleaseWait();

ref = taskParam.gParam.ref;
%% generateOutcomes
if isequal(condition, 'oddballPractice')
    
    taskData = load('OddballInvisible');
    taskData = taskData.taskData;
    clear taskData.cBal taskData.rew
    
    trial = taskParam.gParam.practTrials;
    taskData.cBal = nan(trial,1);
    taskData.rew = nan(trial,1);
    taskData.initiationRTs = nan(trial,1);
    taskData.actJitter = nan(trial,1);
    taskData.block = ones(trial,1);
elseif isequal(condition, 'followOutcomePractice')
    taskData = load('CPInvisible');
    taskData = taskData.taskData;
    clear taskData.cBal taskData.rew
    
    trial = taskParam.gParam.practTrials;
    taskData.cBal = nan(trial,1);
    taskData.rew = nan(trial,1);
    taskData.initiationRTs = nan(trial,1);
    taskData.actJitter = nan(trial,1);
    taskData.block = ones(trial,1);
else
    taskData = GenerateOutcomes(taskParam, vola, sigma, condition);
    trial = taskData.trial;
end

% For trigger testing.
RT_Flip = zeros(taskData.trial, 1);

%% Run trials.

% Enable real-time mode.
% Priority(9);

for i=1:trial
    
    if i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1|| i == taskParam.gParam.blockIndices(4) + 1
        
        while 1
            txt = 'Take a break!';
            DrawFormattedText(taskParam.gParam.window, txt,...
                'center', 'center', [255 255 255]);
            
            
            DrawFormattedText(taskParam.gParam.window,...
                taskParam.strings.txtPressEnter,'center',...
                taskParam.gParam.screensize(4)*0.9);
            Screen('Flip', taskParam.gParam.window);
            [~, ~, keyCode] = KbCheck;
            if find(keyCode) == taskParam.keys.enter
                
                break
            end
        end
        
    end
    
    taskData.trial(i) = i;
    taskData.age(i) = str2double(Subject.age);
    taskData.ID{i} = Subject.ID;
    taskData.sex{i} = Subject.sex;
    taskData.Date{i} = Subject.Date;
    taskData.cond{i} = condition;
    taskData.cBal(i) = Subject.cBal;
    taskData.rew(i) = Subject.rew;
    
    
    if taskData.rew(i) == 1 && taskData.boatType(i) == 1
        taskData.actRew(i) = 1;
    elseif taskData.rew(i) == 1 && taskData.boatType(i) == 0
        taskData.actRew(i) = 2;
    elseif taskData.rew(i) == 2 && taskData.boatType(i) == 1
        taskData.actRew(i) = 2;
    elseif taskData.rew(i) == 2 && taskData.boatType(i) == 0
        taskData.actRew(i) = 1;
    end
    
    if i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1 || i == taskParam.gParam.blockIndices(4) + 1
        taskParam.circle.rotAngle =  taskParam.circle.initialRotAngle;
    end
    
    taskData.actJitter(i) = rand*taskParam.gParam.jitter;
    WaitSecs(taskData.actJitter(i));
    initRT_Timestamp = GetSecs();
    
    while 1
        
        DrawCircle(taskParam)
        DrawCross(taskParam)
        PredictionSpot(taskParam)
        
        if i ~= taskParam.gParam.blockIndices(1) && i ~= taskParam.gParam.blockIndices(2) + 1 && i ~= taskParam.gParam.blockIndices(3) + 1 && i ~= taskParam.gParam.blockIndices(4) + 1
            TickMark(taskParam, taskData.outcome(i-1), 'outc')
            TickMark(taskParam, taskData.pred(i-1), 'pred')
        end
        
        if (taskData.catchTrial(i) == 1 && ~taskParam.gParam.oddball) || isequal(condition,'followCannon') || isequal(condition,'followCannonPractice') %|| isequal(condition,'mainPractice')
            Cannon(taskParam, taskData.distMean(i))
            Aim(taskParam, taskData.distMean(i))
        end
        Screen('DrawingFinished', taskParam.gParam.window);
        t = GetSecs;
        
        Screen('Flip', taskParam.gParam.window, t + 0.001);% taskData.actJitter(i)); %% Inter trial jitter.
        
        taskData.triggers(i,1) = SendTrigger(taskParam, taskData, condition, vola, i, 1); % this is the trial onset trigger
        
        taskData.timestampOnset(i,:) = GetSecs - ref;
        
        %% get initiation RT
        
        
        [ keyIsDown, ~, keyCode ] = KbCheck;
        
        if keyIsDown && isnan(taskData.initiationRTs(i,:)); % initationRTs is nan before first button press: save time of button press. thereafter variable is not nan anymore and not resaved.
            if keyCode(taskParam.keys.rightKey) || keyCode(taskParam.keys.leftKey) || keyCode(taskParam.keys.rightSlowKey) || keyCode(taskParam.keys.leftSlowKey) || keyCode(taskParam.keys.space)
                taskData.initiationRTs(i,:) = GetSecs() - initRT_Timestamp;
            end
        elseif keyIsDown
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
            elseif keyCode(taskParam.keys.space)
                taskData.pred(i) = (taskParam.circle.rotAngle / taskParam.circle.unit);
                
                time = GetSecs;
                
                break
            end
        end
    end
    
    t = GetSecs;
    
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    [VBLTimestamp(i) StimulusOnsetTime(i) FlipTimestamp(i) Missed(i) Beampos(i)] = Screen('Flip', taskParam.gParam.window, t + 0.1, 1);
    taskData.triggers(i,2) = SendTrigger(taskParam, taskData, condition, vola, i, 2); % this is the prediction / fixation 1 trigger
    taskData.timestampPrediction(i,:) = GetSecs - ref;
    
    RT_Flip(i) = GetSecs-time;
    
    taskData.predErr(i) = Diff(taskData.outcome(i), taskData.pred(i));
    
    
    
    DrawCircle(taskParam)
    
    PredictionSpot(taskParam)
    DrawOutcome(taskParam, taskData.outcome(i)) %%TRIGGER
    
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    
    
    if isequal(condition,'main') || isequal(condition,'mainPractice') || isequal(condition, 'followCannon')
        taskData.memErr(i) = 999;
        taskData.memErrNorm(i) = 999;
        taskData.memErrPlus(i) = 999;
        taskData.memErrMin(i) = 999;
    else
        if i > 1
            taskData.memErr(i) = Diff(taskData.pred(i), taskData.outcome(i-1));
        else
            taskData.memErr(i) = 999;
        end
    end
    
    if isequal(condition,'main') || isequal(condition,'mainPractice') || isequal(condition, 'oddballPractice') || isequal(condition, 'oddball') || isequal(condition,'followCannon')
        if taskData.predErr(i) <= taskData.allASS(i)/2
            taskData.hit(i) = 1;
        end
    elseif isequal(condition,'followOutcome') || isequal(condition,'followOutcomePractice')
        if taskData.memErr(i) <= 5
            taskData.hit(i) = 1;
        end
    end
    
    
    if taskData.actRew(i) == 1 && taskData.hit(i) == 1
        taskData.perf(i) = taskParam.gParam.rewMag;
    end
    
    taskData.accPerf(i) = sum(taskData.perf);% + taskData.perf(i);
    
    if i > 1
        % Calculate update.
        taskData.UP(i) = Diff(taskData.pred(i), taskData.pred(i-1));
    end
    
    Screen('Flip', taskParam.gParam.window, t + 0.6);
    taskData.triggers(i,3) = SendTrigger(taskParam, taskData, condition, vola, i, 3); % this is the PE
    
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    Screen('Flip', taskParam.gParam.window, t + 1.1, 1);
    taskData.triggers(i,4) = SendTrigger(taskParam, taskData, condition, vola, i, 4); % this is the 2nd fixation
    
    DrawCircle(taskParam)
    Shield(taskParam, taskData.allASS(i), taskData.pred(i), taskData.boatType(i))
    DrawOutcome(taskParam, taskData.outcome(i)) %%TRIGGER
    
    
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    Screen('Flip', taskParam.gParam.window, t + 2.1);
    taskData.triggers(i,5) = SendTrigger(taskParam, taskData, condition, vola, i, 5); % this is the shield trigger
    
    % Show baseline 3.
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window);
    Screen('Flip', taskParam.gParam.window, t + 2.6);
    taskData.triggers(i,6) = SendTrigger(taskParam, taskData, condition, vola, i, 6); % this is fixation 3
    
    
    
    WaitSecs(.5);
    taskData.triggers(i,7) = SendTrigger(taskParam, taskData, condition, vola, i, 16); % this is the trial summary trigger
    
    
    taskData.timestampOffset(i,:) = GetSecs - ref;
    
    WaitSecs(.5);
    
    
end

hits = sum(taskData.hit == 1);
goldBall = sum(taskData.boatType == 1);
goldHit = taskData.accPerf(end)/taskParam.gParam.rewMag;
silverBall = sum(taskData.boatType == 0);
silverHit = hits - goldHit;
maxMon = (length(find(taskData.boatType == 1))...
    * taskParam.gParam.rewMag);
if taskParam.gParam.oddball == false
    [txt, header] = Feedback(taskData, taskParam, Subject, condition);
    
    
elseif taskParam.gParam.oddball == true
    header = 'Performance';
    if isequal(condition, 'oddballPractice')
        
        [txt, header] = Feedback(taskData, taskParam, Subject, condition);
        
    else
        
        [txt, header] = Feedback(taskData, taskParam, Subject, condition);
        
    end
end

feedback = true;
[fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);


KbReleaseWait();

vola = repmat(vola, length(taskData.trial),1);
sigma = repmat(sigma, length(taskData.trial),1);
oddballProb = repmat(taskParam.gParam.oddballProb(1), length(taskData.trial),1);
driftConc = repmat(taskParam.gParam.driftConc(1), length(taskData.trial),1);

%% Save data

fieldNames = taskParam.fieldNames;
Data = struct(fieldNames.actJitter, taskData.actJitter, fieldNames.block, taskData.block, fieldNames.initiationRTs, taskData.initiationRTs, fieldNames.timestampOnset, taskData.timestampOnset, fieldNames.timestampPrediction, taskData.timestampPrediction, fieldNames.timestampOffset, taskData.timestampOffset, fieldNames.allASS, taskData.allASS, fieldNames.driftConc, driftConc, fieldNames.oddballProb, oddballProb, fieldNames.oddBall, taskData.oddBall, fieldNames.ID, {taskData.ID}, fieldNames.age, taskData.age, fieldNames.rew, {taskData.rew}, fieldNames.actRew, taskData.actRew, fieldNames.sex, {taskData.sex},...
    fieldNames.cond, {taskData.cond}, fieldNames.cBal, {taskData.cBal}, fieldNames.trial, taskData.trial,...
    fieldNames.vola, vola, taskParam.fieldNames.sigma, sigma, fieldNames.outcome, taskData.outcome, fieldNames.distMean, taskData.distMean, fieldNames.cp, taskData.cp,...
    fieldNames.TAC, taskData.TAC, fieldNames.boatType, taskData.boatType, fieldNames.catchTrial, taskData.catchTrial, ...
    fieldNames.predT, taskData.predT, fieldNames.outT, taskData.outT, fieldNames.triggers, taskData.triggers, fieldNames.pred, taskData.pred, fieldNames.predErr, taskData.predErr, fieldNames.predErrNorm, taskData.predErrNorm,...
    fieldNames.predErrPlus, taskData.predErrPlus, fieldNames.predErrMin, taskData.predErrMin,...
    fieldNames.memErr, taskData.memErr, fieldNames.memErrNorm, taskData.memErrNorm, fieldNames.memErrPlus, taskData.memErrPlus,...
    fieldNames.memErrMin, taskData.memErrMin, fieldNames.UP, taskData.UP,fieldNames.UPNorm, taskData.UPNorm,...
    fieldNames.UPPlus, taskData.UPPlus, fieldNames.UPMin, taskData.UPMin, fieldNames.hit, taskData.hit,...
    fieldNames.perf, taskData.perf, fieldNames.accPerf, taskData.accPerf, fieldNames.Date, {taskData.Date});

Data = catstruct(Subject, Data);

if (taskParam.gParam.askSubjInfo && isequal(condition, 'followOutcome')) || (taskParam.gParam.askSubjInfo && isequal(condition, 'main')) || (taskParam.gParam.askSubjInfo && isequal(condition, 'oddball')) || (taskParam.gParam.askSubjInfo && isequal(condition, 'followCannon'))
    
    if Subject.rew == 1
        rewName = 'B';
    elseif Subject.rew == 2
        rewName = 'G';
    end
    
    savename = sprintf('Cannon_%s_%s_%s', rewName, Subject.ID, condition);
    save(savename, 'Data')
end

end
