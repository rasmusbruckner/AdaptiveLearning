function [taskData, Data] = Main(taskParam, haz, concentration, condition, Subject)
%MAIN   Runs the experimental part of the cannon task. You can specify
%"main", "practice" or "control". This loop is optimized for triggering
%accuracy
%
% Events
% Trigger 1: Trial Onset
% Trigger 2: Prediction/Fixation1 (500ms): Subject sees fixation cross
% Trigger 3: Outcome (500ms): Subject sees outcome
% Trigger 4: Fixation2 (1000ms)
% Trigger 5: Shield (500ms)
% Trigger 6: Fixation3 (1000ms)
% Trigger 7: Trial Summary
% Jitter: 0-200ms
%
% Timestamps
% trial onset: with trial onset trigger
% prediction: trigger
% InitRT: first button press / mouse move

KbReleaseWait();

ref = taskParam.gParam.ref;

if isequal(taskParam.gParam.taskType, 'dresden')
    textSize = 19;
else
    textSize = 30;
end
Screen('TextSize', taskParam.gParam.window.onScreen, textSize);
Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');

if taskParam.unitTest
    
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
        
    elseif isequal(condition, 'dresden')
        
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
        
    elseif isequal(condition, 'reversal')
        
        taskData = load('unitTest_TestDataReversal');
        taskData = taskData.taskData;
        trial = taskParam.gParam.trials;
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
        taskData.accPerf = nan(trial,1);
        taskData.perf = zeros(trial,1);
        taskData.gParam.taskType = 'reversal';
        savedTickmark = taskData.savedTickmark;
    end
    
elseif ~taskParam.unitTest
    
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
        
    elseif isequal(condition, 'reversal')...
            || isequal(condition, 'reversalPractice')
        %% 08.09.16: gucken dass hier alle bedingungen spezifiziert werden
        
        if isequal(condition, 'reversalPractice')
            taskParam.gParam.practTrials = taskParam.gParam.practTrials * 2;
            trial = taskParam.gParam.practTrials;
            
        else
            trial = taskParam.gParam.trials;
        end
        taskData = GenerateOutcomes...
            (taskParam, haz, concentration, condition);
        savedTickmark(1) = nan;
        savedTickmarkPrevious(1) = nan;
        
    elseif isequal(condition, 'chineseLastPractice')
        
        trial = taskParam.gParam.chinesePractTrials;
        taskData = GenerateOutcomes...
            (taskParam, haz, concentration, condition);
        savedTickmark(1) = nan;
        savedTickmarkPrevious(1) = nan;
        
    elseif isequal(condition, 'chinese') 
        
        trial = taskParam.gParam.trials;
        taskData = GenerateOutcomes...
            (taskParam, haz, concentration, condition);
        savedTickmark(1) = nan;
        savedTickmarkPrevious(1) = nan;
        %keyboard
        
    end
end

[inY,inX,buttons] = GetMouse(taskParam.gParam.window.onScreen);

for i=1:trial
    
    %     if i == taskParam.gParam.blockIndices(2) + 1 ...
    %             || i == taskParam.gParam.blockIndices(3) + 1 ...
    %             || i == taskParam.gParam.blockIndices(4) + 1
    if (i == taskParam.gParam.blockIndices(2) ...
            || i == taskParam.gParam.blockIndices(3) ...
            || i == taskParam.gParam.blockIndices(4)) ...
            && ~isequal(condition, 'chineseLastPractice')
        
        if isequal(taskParam.gParam.taskType, 'oddball') ...
                || isequal(taskParam.gParam.taskType, 'reversal')...
                || isequal(taskParam.gParam.taskType, 'reversalPractice')...
                txt = 'Take a break!';
            header = ' ';
        elseif isequal(taskParam.gParam.taskType, 'chinese')
            %keyboard
            whichBlock = taskData.block == taskData.block(i-1);
            txt = Feedback(taskData, taskParam, Subject, condition, whichBlock);
            header = sprintf(['Ende Block %.0f von 4. Du kannst jetzt eine kurze Pause machen.\n\n'...
                'Beachte, dass die Gegner ihre Kanonen jetzt neu ausrichten!'], taskData.block(i-1));
            
        else
            txt = 'Kurze Pause!';
            header = ' ';
        end
        
        BigScreen(taskParam, taskParam.strings.txtPressEnter,...
            header, txt, true);
        
        KbReleaseWait();
    end
    
    %         while 1
    %             if isequal(taskParam.gParam.taskType, 'oddball') ...
    %                     || isequal(taskParam.gParam.taskType, 'reversal')...
    %                     || isequal(taskParam.gParam.taskType, 'reversalPractice')...
    %                     txt = 'Take a break!';
    %                 header = ' ';
    %             elseif isequal(taskParam.gParam.taskType, 'chinese')
    %
    %                 [txtFeedback, header] = Feedback(taskData, taskParam, Subject, condition);
    %                 txt = '';
    %                 header = '';
    %
    %             else
    %                 txt = 'Kurze Pause!';
    %                 header = ' ';
    %             end
    %
    %             DrawFormattedText(taskParam.gParam.window.onScreen,...
    %                 txt, 'center', 'center', [255 255 255]);
    %
    %             DrawFormattedText(taskParam.gParam.window.onScreen,...
    %                 txtFeedback, 'center', 'center', [255 255 255]);
    %
    %             DrawFormattedText(taskParam.gParam.window.onScreen,...
    %                 taskParam.strings.txtPressEnter,'center',...
    %                 taskParam.gParam.screensize(4)*0.9);
    %             Screen('Flip', taskParam.gParam.window.onScreen);
    %
    %
    %             [~, ~, keyCode] = KbCheck;
    %             if find(keyCode) == taskParam.keys.enter
    %
    %                 break
    %             end
    %         end
    
    %end
    
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
    
    if i == taskParam.gParam.blockIndices(1)...
            || i == taskParam.gParam.blockIndices(2) + 1 ...
            || i == taskParam.gParam.blockIndices(3) + 1 ...
            || i == taskParam.gParam.blockIndices(4) + 1
        taskParam.circle.rotAngle =  taskParam.circle.initialRotAngle;
    end
    
    taskData.actJitter(i) = rand*taskParam.gParam.jitter;
    WaitSecs(taskData.actJitter(i));
    initRT_Timestamp = GetSecs();
    
    taskData.triggers(i,1) = SendTrigger...
        (taskParam, taskData, condition, haz, i, 1); % this is the trial onset trigger
    taskData.timestampOnset(i,:) = GetSecs - ref;
    %keyboard
    if ~taskParam.unitTest
        
        if ~isequal(taskParam.gParam.taskType, 'reversal') && ~isequal(taskParam.gParam.taskType, 'reversalPractice') && ~isequal(taskParam.gParam.taskType, 'chinese')
            while 1
                
                DrawCircle(taskParam)
                if isequal(taskParam.gParam.taskType, 'chinese')
                    DrawContext(taskParam, taskData.currentContext(i))
                    DrawCross(taskParam)
                    
                end
                DrawCross(taskParam)
                PredictionSpot(taskParam)
                
                if i ~= taskParam.gParam.blockIndices(1)...
                        && i ~= taskParam.gParam.blockIndices(2) + 1 ...
                        && i ~= taskParam.gParam.blockIndices(3) + 1 ...
                        && i ~= taskParam.gParam.blockIndices(4) + 1 ...
                        && ~isequal(taskParam.gParam.taskType, 'chinese')
                    %                         if isequal(taskParam.gParam.taskType, 'chinese')
                    %                             TickMark(taskParam, taskData.outcome(i-1), 'outc')
                    %                             TickMark(taskParam, taskData.pred(i-1), 'pred')
                    %else
                    TickMark(taskParam, taskData.outcome(i-1), 'outc')
                    TickMark(taskParam, taskData.pred(i-1), 'pred')
                    %end
                    if isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'reversalPractice')
                        TickMark(taskParam, savedTickmark(i-1), 'saved')
                    end
                    
                end
                
                if (taskData.catchTrial(i) == 1 ...
                        && isequal(taskParam.gParam.taskType, 'dresden'))...
                        || isequal(condition,'followCannon')...
                        || isequal(condition,'followCannonPractice')
                    Cannon(taskParam, taskData.distMean(i))
                    Aim(taskParam, taskData.distMean(i))
                elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'reversalPractice')
                    
                    taskData.catchTrial(i) = 0;
                end
                Screen('DrawingFinished', taskParam.gParam.window.onScreen);
                t = GetSecs;
                
                Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
                
                taskData.timestampOnset(i,:) = GetSecs - ref;
                
                %% get initiation RT
                [ keyIsDown, ~, keyCode ] = KbCheck;
                
                if keyIsDown && isnan(taskData.initiationRTs(i,:)); % initationRTs is nan before first button press: save time of button press. thereafter variable is not nan anymore and not resaved.
                    if keyCode(taskParam.keys.rightKey)...
                            || keyCode(taskParam.keys.leftKey)...
                            || keyCode(taskParam.keys.rightSlowKey)...
                            || keyCode(taskParam.keys.leftSlowKey)...
                            || keyCode(taskParam.keys.space)
                        taskData.initiationRTs(i,:) =...
                            GetSecs() - initRT_Timestamp;
                    end
                elseif keyIsDown
                    if keyCode(taskParam.keys.rightKey)
                        if taskParam.circle.rotAngle <...
                                360*taskParam.circle.unit
                            taskParam.circle.rotAngle =...
                                taskParam.circle.rotAngle...
                                + 0.75*taskParam.circle.unit;
                        else
                            taskParam.circle.rotAngle = 0;
                        end
                    elseif keyCode(taskParam.keys.rightSlowKey)
                        if taskParam.circle.rotAngle <...
                                360*taskParam.circle.unit
                            taskParam.circle.rotAngle =...
                                taskParam.circle.rotAngle +...
                                0.1*taskParam.circle.unit;
                        else
                            taskParam.circle.rotAngle = 0;
                        end
                    elseif keyCode(taskParam.keys.leftKey)
                        if taskParam.circle.rotAngle >...
                                0*taskParam.circle.unit
                            taskParam.circle.rotAngle =...
                                taskParam.circle.rotAngle -...
                                0.75*taskParam.circle.unit;
                        else
                            taskParam.circle.rotAngle =...
                                360*taskParam.circle.unit;
                        end
                    elseif keyCode(taskParam.keys.leftSlowKey)
                        if taskParam.circle.rotAngle >...
                                0*taskParam.circle.unit
                            taskParam.circle.rotAngle =...
                                taskParam.circle.rotAngle -...
                                0.1*taskParam.circle.unit;
                        else
                            taskParam.circle.rotAngle =...
                                360*taskParam.circle.unit;
                        end
                    elseif keyCode(taskParam.keys.space)
                        taskData.pred(i) = (taskParam.circle.rotAngle /...
                            taskParam.circle.unit);
                        
                        time = GetSecs;
                        
                        break
                        
                    end
                end
                
            end
        else
            
            SetMouse(720, 450, taskParam.gParam.window.onScreen)
            press = 0;
            %initialTendencyLogged = false;
            while 1
                [x,y,buttons,focus,valuators,valinfo] =...
                    GetMouse(taskParam.gParam.window.onScreen);
                
                
                x = x-720;
                y = (y-450)*-1 ;
                
                currentDegree = ...
                    mod( atan2(y,x) .* -180./-pi, -360 )*-1 + 90;
                if currentDegree > 360
                    degree = currentDegree - 360;
                else
                    degree = currentDegree;
                end
                
                taskParam.circle.rotAngle = degree * taskParam.circle.unit;
                
                DrawCircle(taskParam)
                if isequal(taskParam.gParam.taskType, 'chinese')
                    DrawContext(taskParam,taskData.currentContext(i))
                    DrawCross(taskParam)
                    
                end
                DrawCross(taskParam)
                
                hyp = sqrt(x^2 + y^2);
                
                if hyp <= 150
                    PredictionSpotReversal(taskParam, x ,y*-1)
                else
                    PredictionSpot(taskParam)
                end
                %keyboard
                if hyp >= taskParam.circle.tendencyThreshold && isnan(taskData.initialTendency(i))
                    taskData.initialTendency(i) = degree;
                    taskData.initiationRTs(i,:) =...
                        GetSecs() - initRT_Timestamp;
                    %initialTendencyLogged = true;
                end
                
                if ~isequal(taskParam.gParam.taskType, 'chinese')
                    if buttons(2) == 1 && i ~=...
                            taskParam.gParam.blockIndices(1)...
                            && i ~= taskParam.gParam.blockIndices(2) + 1 ...
                            && i ~= taskParam.gParam.blockIndices(3) + 1 ...
                            && i ~= taskParam.gParam.blockIndices(4) + 1
                        
                        savedTickmark(i) =...
                            ((taskParam.circle.rotAngle)/taskParam.circle.unit);
                        WaitSecs(0.2);
                        press = 1;
                        
                    elseif i > 1 && press == 0
                        savedTickmarkPrevious(i) = savedTickmarkPrevious(i - 1);
                        savedTickmark(i) = savedTickmark(i - 1);
                    elseif i == 1
                        savedTickmarPrevious(i) = 0;
                    end
                    
                    if press == 1
                        savedTickmarkPrevious(i) = savedTickmark(i-1);
                    end
                end
                
                if i ~= taskParam.gParam.blockIndices(1)...
                        && i ~= taskParam.gParam.blockIndices(2) + 1 ...
                        && i ~= taskParam.gParam.blockIndices(3) + 1 ...
                        && i ~= taskParam.gParam.blockIndices(4) + 1
                    if isequal(taskParam.gParam.taskType, 'chinese')
                        
                        %                             %keyboard
                        %                             if ~isequal(taskData.currentContext(i-1),taskData.currentContext(i))
                        %                                     %keyboard
                        %                             end
                        %
                        %                             if sum(ismember(unique(taskData.currentContext(1:i-1)), taskData.currentContext(i))) >=1
                        %
                        %                                 TickMark(taskParam,taskData.outcome(find(taskData.currentContext(1:i-1) == taskData.currentContext(i),1,'last')), 'outc');
                        %                                 TickMark(taskParam,taskData.pred(find(taskData.currentContext(1:i-1) == taskData.currentContext(i),1,'last')), 'pred');
                        %
                        %                             end
                    else
                        TickMark(taskParam, taskData.outcome(i-1), 'outc');
                        TickMark(taskParam, taskData.pred(i-1), 'pred');
                    end
                    
                    if ~isequal(taskParam.gParam.taskType, 'chinese')
                        if press == 1
                            TickMark(taskParam, savedTickmarkPrevious(i),...
                                'update');
                        end
                        TickMark(taskParam, savedTickmark(i), 'saved');
                    end
                    
                end
                %end
                Screen('DrawingFinished', taskParam.gParam.window.onScreen);
                t = GetSecs;
                
                Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
                
                if buttons(1) == 1
                    taskData.pred(i) =...
                        ((taskParam.circle.rotAngle) / taskParam.circle.unit);
                    taskData.pred(i);
                    
                    time = GetSecs;
                    taskData.RT(i) = GetSecs() - initRT_Timestamp;
                    break
                    
                end
                
            end
            
        end
        
    else
        
        taskParam.circle.rotAngle = ...
            taskData.pred(i) * taskParam.circle.unit;
        DrawCircle(taskParam)
        if isequal(taskParam.gParam.taskType, 'chinese')
            DrawContext(taskParam,taskData.currentContext(i))
            DrawCross(taskParam)
            
        end
        DrawCross(taskParam)
        PredictionSpot(taskParam)
        
        if ~isequal(taskParam.gParam.taskType, 'chinese')
            if i ~= taskParam.gParam.blockIndices(1) && i ~=...
                    taskParam.gParam.blockIndices(2) + 1 && i ~=...
                    taskParam.gParam.blockIndices(3) + 1 && i ~=...
                    taskParam.gParam.blockIndices(4) + 1
                TickMark(taskParam, taskData.outcome(i-1), 'outc')
                TickMark(taskParam, taskData.pred(i-1), 'pred')
                if isequal(taskData.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'reversalPractice')
                    TickMark(taskParam, savedTickmark(i), 'saved')
                end
            end
        end
        
        if (taskData.catchTrial(i) == 1 ...
                && isequal(taskParam.gParam.taskType, 'dresden')) ...
                || isequal(condition,'followCannon') ...
                || isequal(condition,'followCannonPractice')
            Cannon(taskParam, taskData.distMean(i))
            Aim(taskParam, taskData.distMean(i))
        end
        Screen('DrawingFinished', taskParam.gParam.window.onScreen);
        t = GetSecs;
        
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
        taskData.timestampOnset(i,:) = GetSecs - ref;
        
        
        WaitSecs(0.5);
        
        time = GetSecs;
    end
    t = GetSecs;
    
    DrawCross(taskParam)
    DrawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        DrawContext(taskParam,taskData.currentContext(i))
        DrawCross(taskParam)
        
    end
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    [VBLTimestamp(i) StimulusOnsetTime(i) FlipTimestamp(i) Missed(i)...
        Beampos(i)] =...
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1, 1);
    taskData.triggers(i,2) = ...
        SendTrigger(taskParam, taskData, condition, haz, i, 2);
    taskData.timestampPrediction(i,:) = GetSecs - ref;
    
    RT_Flip(i) = GetSecs-time;
    
    taskData.predErr(i) = Diff(taskData.outcome(i), taskData.pred(i));
    
    DrawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        DrawContext(taskParam,taskData.currentContext(i))
        DrawCross(taskParam)
        
    end
    
    PredictionSpot(taskParam)
    DrawOutcome(taskParam, taskData.outcome(i))
    
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    
    if isequal(condition,'main')...
            || isequal(condition,'mainPractice')...
            || isequal(condition, 'followCannon')...
            || isequal(condition, 'oddball')...
            || isequal(taskParam.gParam.taskType, 'reversal')...
            || isequal(taskParam.gParam.taskType, 'reversalPractice')
        taskData.memErr(i) = 999;
        taskData.memErrNorm(i) = 999;
        taskData.memErrPlus(i) = 999;
        taskData.memErrMin(i) = 999;
    else
        if i > 1
            taskData.memErr(i) = Diff(taskData.pred(i),...
                taskData.outcome(i-1));
        else
            taskData.memErr(i) = 999;
        end
    end
    
    %keyboard
    if isequal(condition,'main')...
            || isequal(condition,'mainPractice')...
            || isequal(condition, 'oddballPractice')...
            || isequal(condition, 'oddball')...
            || isequal(condition,'followCannon')...
            || isequal(condition,'followCannonPractice')...
            || isequal(condition,'reversal')...
            || isequal(condition, 'reversalPractice')...
            || isequal(condition, 'chineseLastPractice')...
            || isequal(condition, 'chinese')
        if abs(taskData.predErr(i)) <= taskData.allASS(i)/2
            taskData.hit(i) = 1;
        end
    elseif isequal(condition,'followOutcome')...
            || isequal(condition,'followOutcomePractice')
        if taskData.memErr(i) <= 5
            taskData.hit(i) = 1;
        end
    end
    
    if taskData.actRew(i) == 1 && taskData.hit(i) == 1
        taskData.perf(i) = taskParam.gParam.rewMag;
    end
    
    taskData.accPerf(i) = sum(taskData.perf);
    
    if i > 1
        taskData.UP(i) = Diff(taskData.pred(i), taskData.pred(i-1));
    end
    
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6);
    taskData.triggers(i,3) = ...
        SendTrigger(taskParam, taskData, condition, haz, i, 3);
    
    DrawCross(taskParam)
    DrawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        DrawContext(taskParam, taskData.currentContext(i))
        DrawCross(taskParam)
        
    end
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    Screen('Flip', taskParam.gParam.window.onScreen, t + 1.1, 1);
    taskData.triggers(i,4) = ...
        SendTrigger(taskParam, taskData, condition, haz, i, 4);
    
    DrawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        DrawContext(taskParam, taskData.currentContext(i))
        DrawCross(taskParam)
        
    end
    Shield(taskParam, taskData.allASS(i),...
        taskData.pred(i), taskData.shieldType(i))
    
    DrawOutcome(taskParam, taskData.outcome(i))
    
    
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    Screen('Flip', taskParam.gParam.window.onScreen, t + 2.1);
    taskData.triggers(i,5) = ...
        SendTrigger(taskParam, taskData, condition, haz, i, 5);
    WaitSecs(.5);
    
    DrawCross(taskParam)
    DrawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        DrawContext(taskParam,taskData.currentContext(i))
        DrawCross(taskParam)
        
    end
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    Screen('Flip', taskParam.gParam.window.onScreen, t + 2.6);
    taskData.triggers(i,6) = ...
        SendTrigger(taskParam, taskData, condition, haz, i, 6);             % this is fixation 3
    
    WaitSecs(.5);
    taskData.triggers(i,7) = ...
        SendTrigger(taskParam, taskData, condition, haz, i, 16);            % this is the trial summary trigger
    
    WaitSecs(.5);
    taskData.timestampOffset(i,:) = GetSecs - ref;
end

if isequal(taskParam.gParam.taskType, 'dresden')
    [txt, header] = Feedback(taskData, taskParam, Subject, condition);
    
elseif isequal(taskParam.gParam.taskType, 'chinese')
    
    whichBlock = taskData.block == taskData.block(i);
    txt = Feedback(taskData, taskParam, Subject, condition, whichBlock);
    
    if isequal(condition,'chinese')
        header = sprintf('Ende Block %.0f von 4', taskData.block(i-1));
    elseif isequal(condition, 'chineseLastPractice')
        header = 'Ergebnis';
    end
    
    
elseif isequal(taskParam.gParam.taskType, 'oddball')
    
    if isequal(condition, 'oddballPractice')
        
        [txt, header] = Feedback(taskData, taskParam, Subject, condition);
        
    else
        
        [txt, header] = Feedback(taskData, taskParam, Subject, condition);
        
    end
    
elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'reversalPractice')
    header = 'Performance';
    [txt, header] = Feedback(taskData, taskParam, Subject, condition);
    
end

%feedback = true;
fw = BigScreen(taskParam, taskParam.strings.txtPressEnter,...
    header, txt, true);

KbReleaseWait();

haz = repmat(haz, length(taskData.trial),1);
concentration = repmat(concentration, length(taskData.trial),1);
oddballProb = repmat(taskParam.gParam.oddballProb(1),...
    length(taskData.trial),1);
driftConc = repmat(taskParam.gParam.driftConc(1),...
    length(taskData.trial),1);


Data = struct('actJitter', taskData.actJitter, 'block', taskData.block,...
    'initiationRTs', taskData.initiationRTs, 'timestampOnset',...
    taskData.timestampOnset,'timestampPrediction',...
    taskData.timestampPrediction,'timestampOffset',...
    taskData.timestampOffset, 'allASS', taskData.allASS, 'driftConc',...
    driftConc,'oddballProb',oddballProb, 'oddBall', taskData.oddBall,...
    'ID', {taskData.ID}, 'age',taskData.age, 'rew', {taskData.rew},...
    'actRew', taskData.actRew,'sex', {taskData.sex}, 'cond',...
    {taskData.cond}, 'cBal',{taskData.cBal}, 'trial', taskData.trial,...
    'haz', haz, 'concentration', concentration,'outcome',...
    taskData.outcome, 'distMean', taskData.distMean, 'cp',...
    taskData.cp, 'reversal', taskData.reversal, 'savedTickmark',...
    savedTickmark, 'TAC',taskData.TAC, 'shieldType', taskData.shieldType,...
    'catchTrial', taskData.catchTrial, 'triggers', taskData.triggers,...
    'pred', taskData.pred,'predErr', taskData.predErr, 'memErr',...
    taskData.memErr, 'UP',taskData.UP, 'hit', taskData.hit, 'perf',....
    taskData.perf, 'accPerf',taskData.accPerf,'initialTendency',...
    taskData.initialTendency, 'RT', taskData.RT, 'Date', {taskData.Date},...
    'currentContext', taskData.currentContext,...
    'hiddenContext', taskData.hiddenContext, 'contextTypes', taskData.contextTypes,...
    'latentState', taskData.latentState,'taskParam',taskParam);

Data = catstruct(Subject, Data);

if (taskParam.gParam.askSubjInfo && isequal(condition, 'followOutcome'))...
        || (taskParam.gParam.askSubjInfo && isequal(condition, 'main'))...
        || (taskParam.gParam.askSubjInfo && isequal(condition, 'oddball'))...
        || (taskParam.gParam.askSubjInfo && isequal(condition, 'followCannon'))...
        || (taskParam.gParam.askSubjInfo && isequal(condition, 'reversal'))
    
    if isequal(taskParam.gParam.taskType, 'dresden')
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
        savename = sprintf('ReversalTask_%s_%s',...
            rewName, Subject.ID);
        save(savename, 'Data')
    end
    
elseif (taskParam.gParam.askSubjInfo && isequal(condition, 'chinese'))
    if ~taskParam.unitTest
        savename = sprintf('chinese_%s', Subject.ID);
        save(savename, 'Data')
    end
end

end
