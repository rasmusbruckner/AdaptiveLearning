function [taskData, Data] = Main(taskParam, haz, concentration, condition, Subject)
% This function acutally runs the task. You can specify "main",
% "practice" or "control". This loop is optimized for triggering accuracy.

%% Events

% Trigger 1: Trial Onset
% Trigger 2: Prediction/Fixation1 (500ms): Subject sees fixation cross
% Trigger 3: Outcome (500ms): Subject sees outcome
% Trigger 4: Fixation2 (1000ms)
% Trigger 5: Shield (500ms)
% Trigger 6: Fixation3 (1000ms)
% Trigger 7: Trial Summary
% Jitter: 0-200ms

%% Timestamps

% trial onset: with trial onset trigger
% prediction: trigger


% InitRT: first button press 


KbReleaseWait();

ref = taskParam.gParam.ref;

if isequal(condition, 'oddballPractice')
    
    taskData = load('OddballInvisible');
    taskData = taskData.taskData;
    clear taskData.cBal taskData.rew %% should be checked at some point!!
    
    trial = taskParam.gParam.practTrials;
    taskData.cBal = nan(trial,1);
    taskData.rew = nan(trial,1);
    taskData.initiationRTs = nan(trial,1);
    taskData.actJitter = nan(trial,1);
    taskData.block = ones(trial,1);
elseif isequal(condition, 'followOutcomePractice')...
        ||isequal(condition, 'mainPractice')...
        ||isequal(condition, 'followCannonPractice')
    taskData = load('CPInvisible');
    taskData = taskData.taskData;
    clear taskData.cBal taskData.rew
    
    trial = taskParam.gParam.practTrials;
    taskData.cBal = nan(trial,1);
    taskData.rew = nan(trial,1);
    taskData.initiationRTs = nan(trial,1);
    taskData.actJitter = nan(trial,1);
    taskData.block = ones(trial,1);
elseif taskParam.unitTest
    %keyboard
    if isequal(condition, 'oddball')
        taskData = load('unitTest_TestDataOddball');
        taskData = taskData.taskData;
        clear taskData.cBal taskData.rew
        trial = taskParam.gParam.trials;
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
        taskData.accPerf = nan(trial,1);
        taskData.perf = zeros(trial,1);
    else
        
        taskData = load('unitTest_TestData');
        taskData = taskData.taskData;
        clear taskData.cBal taskData.rew
        
        trial = taskParam.gParam.trials;
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
        if isequal(condition, 'main')
            taskData.pred = taskData.predMain;
        elseif isequal(condition, 'followOutcome')
            taskData.pred = taskData.predFollowOutcome;
        elseif isequal(condition, 'followCannon')
            taskData.pred = taskData.predFollowCannon;
            
        end
        
    end

else

    taskData = GenerateOutcomes(taskParam, haz, concentration, condition);
    trial = taskData.trial;
end

% For trigger testing.
%RT_Flip = zeros(taskData.trial, 1);

% Enable real-time mode.
% Priority(9);

for i=1:trial
    
    if i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1|| i == taskParam.gParam.blockIndices(4) + 1
        
        Screen('TextSize', taskParam.gParam.window, 19);
        Screen('TextFont', taskParam.gParam.window, 'Arial');
        while 1
            if taskParam.gParam.oddball
                txt = 'Take a break!';
            else
                txt = 'Kurze Pause!';
            end
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
    %keyboard
    taskData.trial(i) = i;
    taskData.age(i) = str2double(Subject.age);
    taskData.ID{i} = Subject.ID;
    taskData.sex{i} = Subject.sex;
    taskData.Date{i} = Subject.date;
    taskData.cond{i} = condition;
    taskData.cBal(i) = Subject.cBal;
    taskData.rew(i) = Subject.rew;
    
    if taskData.rew(i) == 1 && taskData.shieldType(i) == 1
        taskData.actRew(i) = 1;
    elseif taskData.rew(i) == 1 && taskData.shieldType(i) == 0
        taskData.actRew(i) = 2;
    elseif taskData.rew(i) == 2 && taskData.shieldType(i) == 1
        taskData.actRew(i) = 2;
    elseif taskData.rew(i) == 2 && taskData.shieldType(i) == 0
        taskData.actRew(i) = 1;
    end
    
    if i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1 || i == taskParam.gParam.blockIndices(4) + 1
        taskParam.circle.rotAngle =  taskParam.circle.initialRotAngle;
    end
    
    taskData.actJitter(i) = rand*taskParam.gParam.jitter;
    WaitSecs(taskData.actJitter(i));
    initRT_Timestamp = GetSecs();
    
    taskData.triggers(i,1) = SendTrigger(taskParam, taskData, condition, haz, i, 1); % this is the trial onset trigger
    taskData.timestampOnset(i,:) = GetSecs - ref;

    if ~taskParam.unitTest
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
            
            % taskData.triggers(i,1) = SendTrigger(taskParam, taskData, condition, haz, i, 1); % this is the trial onset trigger
            
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
    else
        
        % taskData.pred(i) = (taskParam.circle.rotAngle / taskParam.circle.unit);
        % 57.2958 = 1 / (2*pi/360)
        taskParam.circle.rotAngle = taskData.pred(i) * taskParam.circle.unit;
        % 1 = 57.2958 * (2*pi/360)
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
        taskData.timestampOnset(i,:) = GetSecs - ref;
        

        WaitSecs(0.5);
        
        time = GetSecs;
    end
    
    t = GetSecs;
    
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    [VBLTimestamp(i) StimulusOnsetTime(i) FlipTimestamp(i) Missed(i) Beampos(i)] = Screen('Flip', taskParam.gParam.window, t + 0.1, 1);
    taskData.triggers(i,2) = SendTrigger(taskParam, taskData, condition, haz, i, 2); % this is the prediction / fixation 1 trigger
    taskData.timestampPrediction(i,:) = GetSecs - ref;
    
    RT_Flip(i) = GetSecs-time;
    
    taskData.predErr(i) = Diff(taskData.outcome(i), taskData.pred(i));
    
    DrawCircle(taskParam)
    
    PredictionSpot(taskParam)
    DrawOutcome(taskParam, taskData.outcome(i))
    
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    
    if isequal(condition,'main') || isequal(condition,'mainPractice') || isequal(condition, 'followCannon') || isequal(condition, 'oddball')
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
    
    if isequal(condition,'main') || isequal(condition,'mainPractice') || isequal(condition, 'oddballPractice') || isequal(condition, 'oddball') || isequal(condition,'followCannon') || isequal(condition,'followCannonPractice')
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
    %keyboard
    taskData.accPerf(i) = sum(taskData.perf);% + taskData.perf(i);
    
    if i > 1
        taskData.UP(i) = Diff(taskData.pred(i), taskData.pred(i-1));
    end
    
    Screen('Flip', taskParam.gParam.window, t + 0.6);
    taskData.triggers(i,3) = SendTrigger(taskParam, taskData, condition, haz, i, 3); % this is the PE
    
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    Screen('Flip', taskParam.gParam.window, t + 1.1, 1);
    taskData.triggers(i,4) = SendTrigger(taskParam, taskData, condition, haz, i, 4); % this is the 2nd fixation
    
    DrawCircle(taskParam)
    Shield(taskParam, taskData.allASS(i), taskData.pred(i), taskData.shieldType(i))
    DrawOutcome(taskParam, taskData.outcome(i))
    
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    Screen('Flip', taskParam.gParam.window, t + 2.1);
    taskData.triggers(i,5) = SendTrigger(taskParam, taskData, condition, haz, i, 5); % this is the shield trigger
    
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window);
    Screen('Flip', taskParam.gParam.window, t + 2.6);
    taskData.triggers(i,6) = SendTrigger(taskParam, taskData, condition, haz, i, 6); % this is fixation 3
    
    WaitSecs(.5);
    taskData.triggers(i,7) = SendTrigger(taskParam, taskData, condition, haz, i, 16); % this is the trial summary trigger
    
    WaitSecs(.5);
    taskData.timestampOffset(i,:) = GetSecs - ref;
end

% hits = sum(taskData.hit == 1);
% goldBall = sum(taskData.shieldType == 1);
% goldHit = taskData.accPerf(end)/taskParam.gParam.rewMag;
% silverBall = sum(taskData.shieldType == 0);
% silverHit = hits - goldHit;
% maxMon = (length(find(taskData.shieldType == 1))...
%     * taskParam.gParam.rewMag);
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
[fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header,...
    txt, feedback);

KbReleaseWait();

haz = repmat(haz, length(taskData.trial),1);
concentration = repmat(concentration, length(taskData.trial),1);
oddballProb = repmat(taskParam.gParam.oddballProb(1), length(taskData.trial),1);
driftConc = repmat(taskParam.gParam.driftConc(1), length(taskData.trial),1);

%keyboard

%fieldNames = taskParam.fieldNames;
Data = struct('actJitter', taskData.actJitter, 'block', taskData.block,...
    'initiationRTs', taskData.initiationRTs, 'timestampOnset',...
    taskData.timestampOnset,'timestampPrediction',...
    taskData.timestampPrediction,'timestampOffset', taskData.timestampOffset,...
    'allASS', taskData.allASS, 'driftConc', driftConc,'oddballProb',...
    oddballProb, 'oddBall', taskData.oddBall, 'ID', {taskData.ID}, 'age',...
    taskData.age, 'rew', {taskData.rew}, 'actRew', taskData.actRew,...
    'sex', {taskData.sex}, 'cond', {taskData.cond}, 'cBal',...
    {taskData.cBal}, 'trial', taskData.trial, 'haz', haz, 'concentration', concentration,...
    'outcome', taskData.outcome, 'distMean', taskData.distMean, 'cp',...
    taskData.cp, 'TAC',taskData.TAC, 'shieldType', taskData.shieldType,...
    'catchTrial', taskData.catchTrial, 'triggers', taskData.triggers, 'pred', taskData.pred,...
    'predErr', taskData.predErr, 'memErr', taskData.memErr, 'UP',...
    taskData.UP, 'hit', taskData.hit, 'perf', taskData.perf, 'accPerf',...
    taskData.accPerf, 'Date', {taskData.Date});

% predT
% outT
% triggers


%% in OutputTest

% block?
% timestampOnset
% timestampPrediction
% timestampOffset
% allASS
% driftConc
% oddballProb
% oddball
% cond
% trial
% haz
% concentration
% outcome
% distMean
% cp
% catchTrial
% welche trigger?
% pred 
% predErr
% memErr
% UP
% hit
% perf
% accPerf



Data = catstruct(Subject, Data);

if (taskParam.gParam.askSubjInfo && isequal(condition, 'followOutcome')) || (taskParam.gParam.askSubjInfo && isequal(condition, 'main')) || (taskParam.gParam.askSubjInfo && isequal(condition, 'oddball')) || (taskParam.gParam.askSubjInfo && isequal(condition, 'followCannon'))
    
    if taskParam.gParam.oddball == false
        if Subject.rew == 1
            rewName = 'G';
        elseif Subject.rew == 2
            rewName = 'S';
        end
    else
        if Subject.rew == 1
            rewName = 'B';
        elseif Subject.rew == 2
            rewName = 'G';
        end
    end
    
    if ~taskParam.unitTest
        savename = sprintf('Drugstudy_%s_%s_session%s_%s', rewName, Subject.ID, Subject.session, condition);
        save(savename, 'Data')
    end
end

end
