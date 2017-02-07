function [taskData, Data] = al_mainLoop(taskParam, haz, concentration, condition, subject)
%MAIN   Runs the experimental part of the cannon task. You can specify
%"main", "practice" or "control". This loop is optimized for triggering
%accuracy
%
% Events
% Trigger 1: Trial Onset
% Trigger 2: Prediction/Fixation1 (500 ms)
% Trigger 3: Outcome              (500 ms)
% Trigger 4: Fixation2            (500 ms)
% Trigger 5: Shield               (500 ms)
% Trigger 6: Fixation3            (500 ms)
% Trigger 7: Trial Summary
% Jitter:                         (0-200 ms)

%% ------------------------------------------------------------------------
% initiate task
%--------------------------------------------------------------------------

KbReleaseWait();

ref             = taskParam.gParam.ref;
fixCrossLength  = taskParam.timingParam.fixCrossLength;
outcomeLength   = taskParam.timingParam.outcomeLength;
jitter          = taskParam.timingParam.jitter;
fixedITI        = taskParam.timingParam.fixedITI;

% textsize
if isequal(taskParam.gParam.taskType, 'dresden')
    textSize = 19;
else
    textSize = 30;
end
Screen('TextSize', taskParam.gParam.window.onScreen, textSize);
Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');

%% ------------------------------------------------------------------------
% load data if specified
%--------------------------------------------------------------------------

% data for unit tests
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
        %savedTickmark = taskData.savedTickmark;
    end
    
    % data for regular runs
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
            ||isequal(condition, 'mainPractice_3')...
            ||isequal(condition, 'followCannonPractice')
        taskData = load('CPInvisible');
        taskData = taskData.taskData;
        clear taskData.cBal taskData.rew
        trial = taskParam.gParam.practTrials;
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.initialTendency = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
        taskData.savedTickmark(1) = nan;
        % savedTickmarkPrevious(1) = nan;
        taskData.reversal = nan(length(trial),1);
        taskData.currentContext = nan(length(trial),1);
        taskData.hiddenContext = nan(length(trial),1);
        taskData.contextTypes = nan(length(trial),1);
        taskData.latentState = nan(length(trial),1);
        
    elseif isequal(condition, 'mainPractice_1')
        
        taskData = load('CP_NoNoise');
        taskData = taskData.practData;
        taskData.latentState = zeros(20,1);
        taskData.currentContext = nan(20,1);
        taskData.savedTickmark = nan(20,1);
        trial = taskParam.gParam.practTrials;
        taskData.initialTendency = nan(trial,1);
        %savedTickmark(1) = nan;
        taskData.reversal = nan(20,1);
        taskData.currentContext = nan(20,1);
        taskData.hiddenContext = nan(20,1);
        taskData.contextTypes = nan(20,1);
        taskData.latentState = nan(20,1);
        taskData.shieldType = ones(20,1);
        
    elseif isequal(condition, 'mainPractice_2')
        
        taskData = load('CP_Noise');
        taskData = taskData.practData;
        taskData.latentState = zeros(20,1);
        taskData.currentContext = nan(20,1);
        taskData.savedTickmark = nan(20,1);
        trial = taskParam.gParam.practTrials;
        taskData.initialTendency = nan(trial,1);
        %savedTickmark(1) = nan;
        taskData.reversal = nan(20,1);
        taskData.currentContext = nan(20,1);
        taskData.hiddenContext = nan(20,1);
        taskData.contextTypes = nan(20,1);
        taskData.latentState = nan(20,1);
        taskData.shieldType = ones(20,1);

    elseif isequal(condition, 'shield')
        
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
        taskParam.condition = condition;
        trial = taskData.trial;
        taskData.initialTendency = nan(trial,1);
        %savedTickmark = nan(trial,1);
        
    elseif isequal(condition, 'reversal')...
            || isequal(condition, 'reversalPractice')
        warning('gucken dass hier alle bedingungen spezifiziert werden')
        
        if isequal(condition, 'reversalPractice')
            taskParam.gParam.practTrials = taskParam.gParam.practTrials * 2;
            trial = taskParam.gParam.practTrials;
            
        else
            trial = taskParam.gParam.trials;
        end
        taskData = al_generateOutcomes...
            (taskParam, haz, concentration, condition);
        %savedTickmark(1) = nan;
        %savedTickmarkPrevious(1) = nan;
        
    elseif isequal(condition, 'chinesePractice_4')
        
        trial = taskParam.gParam.chinesePractTrials;
        taskData = al_generateOutcomes...
            (taskParam, haz, concentration, condition);
        %savedTickmark(1) = nan;
        %savedTickmarkPrevious(1) = nan;
        
    elseif isequal(condition, 'chinese') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
        
        trial = taskParam.gParam.trials;
        taskData = al_generateOutcomes...
            (taskParam, haz, concentration, condition);
        %savedTickmark(1) = nan;
        %savedTickmarkPrevious(1) = nan;
        
    elseif isequal(condition, 'main') 
        
        trial = taskParam.gParam.trials;
        taskData = al_generateOutcomes...
            (taskParam, haz, concentration, condition);
        %savedTickmark(1) = nan;
        %savedTickmarkPrevious(1) = nan;
        %taskData.reversal = nan(length(trial),1);
        %taskData.currentContext = nan(length(trial),1);
        %taskData.hiddenContext = nan(length(trial),1);
        %taskData.contextTypes = nan(length(trial),1);
        %taskData.latentState = nan(length(trial),1);
        
    end
end

%% ------------------------------------------------------------------------
% Loop through trials
%--------------------------------------------------------------------------

for i = 1:trial
    
    % manage breaks
    if (i == taskParam.gParam.blockIndices(2) ...
            || i == taskParam.gParam.blockIndices(3) ...
            || i == taskParam.gParam.blockIndices(4)) ...
            && ~isequal(condition, 'chinesePractice_4')
        
        if isequal(taskParam.gParam.taskType, 'oddball') ...
                || isequal(taskParam.gParam.taskType, 'reversal')...
                || isequal(taskParam.gParam.taskType, 'reversalPractice')...
                
            txt = 'Take a break!';
            header = ' ';
        elseif isequal(taskParam.gParam.taskType, 'chinese')
            
            whichBlock = taskData.block == taskData.block(i-1);
            txt = Feedback(taskData, taskParam, subject, condition,...
                whichBlock);
            header = sprintf(['Ende Block %.0f von 4. Du kannst jetzt '...
                'eine kurze Pause machen.\n\nBeachte, dass die Gegner '...
                'ihre Kanonen jetzt neu ausrichten!'], taskData.block(i-1));
            
        else
            txt = 'Kurze Pause!';
            header = ' ';
        end
        
        al_bigScreen(taskParam, taskParam.strings.txtPressEnter,...
            header, txt, true);
        
        KbReleaseWait();
    end
    
    % save constant variables
    taskData.trial(i)   = i;
    taskData.age(i)     = str2double(subject.age);
    taskData.ID{i}      = subject.ID;
    taskData.sex{i}     = subject.sex;
    taskData.Date{i}    = subject.date;
    taskData.cond{i}    = condition;
    taskData.cBal(i)    = subject.cBal;
    taskData.rew(i)     = subject.rew;
    
    % determine actRew
    if taskData.rew(i) == 1 && taskData.shieldType(i) == 1
        taskData.actRew(i) = 1;
    elseif taskData.rew(i) == 1 && taskData.shieldType(i) == 0
        taskData.actRew(i) = 2;
    elseif taskData.rew(i) == 2 && taskData.shieldType(i) == 1
        taskData.actRew(i) = 2;
    elseif taskData.rew(i) == 2 && taskData.shieldType(i) == 0
        taskData.actRew(i) = 1;
    end
    
    % set prediction spot to default after break
    if i == taskParam.gParam.blockIndices(1)...
            || i == taskParam.gParam.blockIndices(2) + 1 ...
            || i == taskParam.gParam.blockIndices(3) + 1 ...
            || i == taskParam.gParam.blockIndices(4) + 1
        taskParam.circle.rotAngle =  taskParam.circle.initialRotAngle;
    end
    
    % take jitter into account and get timestamps
    taskData.actJitter(i) = rand*jitter;
    WaitSecs(taskData.actJitter(i));
    initRT_Timestamp = GetSecs();
    
    % send trial onset trigger
    taskData.triggers(i,1) = al_sendTrigger...
        (taskParam, taskData, condition, haz, i, 1);
    taskData.timestampOnset(i,:) = GetSecs - ref;
    
    if ~taskParam.unitTest
        
        %% ----------------------------------------------------------------
        % Versions with keyboard
        %------------------------------------------------------------------
        
        if ~isequal(taskParam.gParam.taskType, 'reversal') &&...
                ~isequal(taskParam.gParam.taskType, 'reversalPractice') &&...
                ~isequal(taskParam.gParam.taskType, 'chinese') &&...
                ~isequal(taskParam.gParam.taskType, 'ARC')
            
            while 1
                
                al_drawCircle(taskParam)
                if isequal(taskParam.gParam.taskType, 'chinese')
                    drawContext(taskParam, taskData.currentContext(i))
                    al_drawCross(taskParam)
                    
                end
                al_drawCross(taskParam)
                al_predictionSpot(taskParam)
                
                if i ~= taskParam.gParam.blockIndices(1)...
                        && i ~= taskParam.gParam.blockIndices(2) + 1 ...
                        && i ~= taskParam.gParam.blockIndices(3) + 1 ...
                        && i ~= taskParam.gParam.blockIndices(4) + 1 ...
                        && ~isequal(taskParam.gParam.taskType, 'chinese')
                    
                    al_tickMark(taskParam, taskData.outcome(i-1), 'outc')
                    al_tickMark(taskParam, taskData.pred(i-1), 'pred')
                    if isequal(taskParam.gParam.taskType, 'reversal') ||...
                            isequal(taskParam.gParam.taskType, 'reversalPractice')
                        al_tickMark(taskParam, taskParam.savedTickmark(i-1), 'saved')
                    end
                    
                end
                
                if (taskData.catchTrial(i) == 1 ...
                        && isequal(taskParam.gParam.taskType, 'dresden'))...
                        || isequal(condition,'followCannon')...
                        || isequal(condition,'followCannonPractice')...
                        || isequal(condition,'shield')...
                        || isequal(condition, 'mainPractice_1')...
                        || isequal(condition, 'mainPractice_2')...
                        || isequal(condition, 'chinesePractice_1')...
                        || isequal(condition, 'chinesePractice_2')...
                        || isequal(condition, 'chinesePractice_3')
                    
                    Cannon(taskParam, taskData.distMean(i))
                    al_aim(taskParam, taskData.distMean(i))
                elseif isequal(taskParam.gParam.taskType, 'reversal') ||...
                        isequal(taskParam.gParam.taskType, 'reversalPractice')
                    
                    taskData.catchTrial(i) = 0;
                end
                Screen('DrawingFinished', taskParam.gParam.window.onScreen);
                t = GetSecs;
                
                Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
                
                taskData.timestampOnset(i,:) = GetSecs - ref;
                
                % get initiation RT
                [ keyIsDown, ~, keyCode ] = KbCheck;
                
                % initationRTs is nan before first button press: save time
                % of button press. thereafter variable is not nan anymore
                % and not resaved.
                if keyIsDown && isnan(taskData.initiationRTs(i,:));
                    
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
            
            %% ----------------------------------------------------------------
            % Versions with mouse
            %------------------------------------------------------------------
            
            
            SetMouse(720, 450, taskParam.gParam.window.onScreen)
            press = 0;
            
            while 1
                
                [x,y,buttons] =...
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
                
                al_drawCircle(taskParam)
                if isequal(taskParam.gParam.taskType, 'chinese') && ~isequal(condition,'shield') && ~isequal(condition, 'chinesePractice_1') && ~isequal(condition, 'chinesePractice_2') && ~isequal(condition, 'chinesePractice_3')
                    drawContext(taskParam,taskData.currentContext(i))
                    al_drawCross(taskParam)
                elseif isequal(condition,'shield') ||...
                        isequal(condition, 'mainPractice_1') ||...
                        isequal(condition, 'mainPractice_2') ||...
                        isequal(condition, 'chinesePractice_1') ||...
                        isequal(condition, 'chinesePractice_2') ||...
                        isequal(condition, 'chinesePractice_3')
                    
                    if isequal(taskParam.gParam.taskType, 'chinese')
                        drawContext(taskParam,taskData.currentContext(i))
                        al_drawCross(taskParam)
                    end
                    al_drawCannon(taskParam, taskData.distMean(i), taskData.latentState(i))
                    al_aim(taskParam, taskData.distMean(i))
                else
                    al_drawCross(taskParam)
                end
                
                hyp = sqrt(x^2 + y^2);
                if hyp <= 150
                    al_predictionSpotReversal(taskParam, x ,y*-1)
                else
                    al_predictionSpot(taskParam)
                end
                
                if hyp >= taskParam.circle.tendencyThreshold &&...
                        isnan(taskData.initialTendency(i))
                    taskData.initialTendency(i) = degree;
                    taskData.initiationRTs(i,:) =...
                        GetSecs() - initRT_Timestamp;
                end
                
                if ~isequal(taskParam.gParam.taskType, 'chinese')...
                        || ~isequal(taskParam.gParam.taskType, 'ARC')
                    if buttons(2) == 1 && i ~=...
                            taskParam.gParam.blockIndices(1)...
                            && i ~= taskParam.gParam.blockIndices(2) + 1 ...
                            && i ~= taskParam.gParam.blockIndices(3) + 1 ...
                            && i ~= taskParam.gParam.blockIndices(4) + 1
                        
                        taskData.savedTickmark(i) =...
                            ((taskParam.circle.rotAngle)/taskParam.circle.unit);
                        WaitSecs(0.2);
                        press = 1;
                        
                    elseif i > 1 && press == 0
                        taskData.savedTickmarkPrevious(i) = taskData.savedTickmarkPrevious(i - 1);
                        taskData.savedTickmark(i) = taskData.savedTickmark(i - 1);
                    elseif i == 1
                        taskData.savedTickmarkPrevious(i) = 0;
                    end
                    
                    if press == 1
                        taskData.savedTickmarkPrevious(i) = taskData.savedTickmark(i-1);
                    end
                end
                
                % manage tickmarks
                if taskParam.gParam.showTickmark == true && ~isequal(condition,'shield') %&& ~isequal(condition,'mainPractice_1') && ~isequal(condition,'mainPractice_2')
                    if i ~= taskParam.gParam.blockIndices(1)...
                            && i ~= taskParam.gParam.blockIndices(2) + 1 ...
                            && i ~= taskParam.gParam.blockIndices(3) + 1 ...
                            && i ~= taskParam.gParam.blockIndices(4) + 1
                        if ~isequal(taskParam.gParam.taskType, 'chinese')
                            
                        %else
                            al_tickMark(taskParam, taskData.outcome(i-1), 'outc');
                            al_tickMark(taskParam, taskData.pred(i-1), 'pred');
                        end
                        
                        if ~isequal(taskParam.gParam.taskType, 'chinese')
                            if press == 1
                                al_tickMark(taskParam, taskData.savedTickmarkPrevious(i),...
                                    'update');
                            end
                            al_tickMark(taskParam, taskData.savedTickmark(i), 'saved');
                        end
                        
                    end
                end
                
                
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
        
        %% --------------------------------------------------------------------
        % Unit test
        %----------------------------------------------------------------------
        
        taskParam.circle.rotAngle = ...
            taskData.pred(i) * taskParam.circle.unit;
        al_drawCircle(taskParam)
        
        if isequal(taskParam.gParam.taskType, 'chinese')
            drawContext(taskParam,taskData.currentContext(i))
            al_drawCross(taskParam)
        end
        al_drawCross(taskParam)
        al_predictionSpot(taskParam)
        
        if ~isequal(taskParam.gParam.taskType, 'chinese')
            if i ~= taskParam.gParam.blockIndices(1) && i ~=...
                    taskParam.gParam.blockIndices(2) + 1 && i ~=...
                    taskParam.gParam.blockIndices(3) + 1 && i ~=...
                    taskParam.gParam.blockIndices(4) + 1
                al_tickMark(taskParam, taskData.outcome(i-1), 'outc')
                al_tickMark(taskParam, taskData.pred(i-1), 'pred')
                if isequal(taskData.gParam.taskType, 'reversal') ||...
                        isequal(taskParam.gParam.taskType, 'reversalPractice')
                    al_tickMark(taskParam, taskData.savedTickmark(i), 'saved')
                end
            end
        end
        
        if (taskData.catchTrial(i) == 1 ...
                && isequal(taskParam.gParam.taskType, 'dresden'))...
                || isequal(condition,'followCannon') ...
                || isequal(condition,'followCannonPractice')
            Cannon(taskParam, taskData.distMean(i))
            al_aim(taskParam, taskData.distMean(i))
        end
        Screen('DrawingFinished', taskParam.gParam.window.onScreen);
        t = GetSecs;
        
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
        taskData.timestampOnset(i,:) = GetSecs - ref;
        
        WaitSecs(0.5);
        
        %time = GetSecs;
    end
    
    %% --------------------------------------------------------------------
    % Fixation cross 1
    %----------------------------------------------------------------------
    %keyboard
    t = GetSecs;
    tUpdated = t + 0.1;
    
    if ~isequal(condition, 'shield') && ~isequal(condition, 'mainPractice_1') && ~isequal(condition, 'mainPractice_2') && ~isequal(condition, 'chinesePractice_1') && ~isequal(condition, 'chinesePractice_2') && ~isequal(condition, 'chinesePractice_3')
        
        al_drawCross(taskParam)
        al_drawCircle(taskParam)
        if isequal(taskParam.gParam.taskType, 'chinese')
            drawContext(taskParam,taskData.currentContext(i))
            al_drawCross(taskParam)
        end
        
        Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
        [VBLTimestamp(i) StimulusOnsetTime(i) FlipTimestamp(i) Missed(i)...
            Beampos(i)] =...
            Screen('Flip', taskParam.gParam.window.onScreen, tUpdated, 1);
        
        % send fixation cross 1 trigger
        taskData.triggers(i,2) = ...
            al_sendTrigger(taskParam, taskData, condition, haz, i, 2);
        taskData.timestampPrediction(i,:) = GetSecs - ref;
        
    end
    
    % ---------------------------------------------------------------------
    % Outcome 1
    %----------------------------------------------------------------------
    
    % deviation from cannon to compute performance criterion in practice
    taskData.cannonDev(i) = al_diff(taskData.distMean(i), taskData.pred(i)); 
    
    % predError and memory error
    taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
    if isequal(condition,'main')...
            || isequal(condition,'mainPractice_3')...
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
            warning('adjust this')
%             taskData.memErr(i) = al_diff(taskData.pred(i),...
%                 taskData.outcome(i-1));
              taskData.memErr(i) = al_diff(taskData.pred(i),...
                 taskData.distMean(i));

        else
            taskData.memErr(i) = 999;
        end
    end
    
    if isequal(condition,'main')...
            || isequal(condition,'mainPractice_1')...
            || isequal(condition,'mainPractice_2')...
            || isequal(condition,'mainPractice_3')...
            || isequal(condition, 'oddballPractice')...
            || isequal(condition, 'oddball')...
            || isequal(condition,'followCannon')...
            || isequal(condition,'followCannonPractice')...
            || isequal(condition,'reversal')...
            || isequal(condition, 'reversalPractice')...
            || isequal(condition, 'chinesePractice_4')...
            || isequal(condition, 'chinese')...
            || isequal(condition, 'chinesePractice_1')...
            || isequal(condition, 'chinesePractice_2')...
            || isequal(condition, 'chinesePractice_3')

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
        taskData.UP(i) = al_diff(taskData.pred(i), taskData.pred(i-1));
    end
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        al_drawContext(taskParam,taskData.currentContext(i))
        al_drawCross(taskParam)
    end
    
    %tUpdated = tUpdated + fixCrossLength;
    
    if isequal(condition, 'shield') || isequal(condition, 'mainPractice_1') || isequal(condition, 'mainPractice_2') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
        
        background = false;
        al_cannonball(taskParam, taskData.distMean(i),...
            taskData.outcome(i), background, taskData.currentContext(i),...
            taskData.latentState(i))
        waitingTime = 0.2;
        WaitSecs(waitingTime);
        
       tUpdated = tUpdated + fixCrossLength + waitingTime;
      % tUpdated = tUpdated + fixCrossLength;
    else
        
        al_predictionSpot(taskParam)
        al_drawOutcome(taskParam, taskData.outcome(i))
        
        Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
        
        %Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6);
        tUpdated = tUpdated + fixCrossLength;
        Screen('Flip', taskParam.gParam.window.onScreen, tUpdated);
        
    end
    
    % send outcome 1 trigger
    taskData.triggers(i,3) = ...
        al_sendTrigger(taskParam, taskData, condition, haz, i, 3);
    
    
    %% --------------------------------------------------------------------
    % Fixation cross 2
    %----------------------------------------------------------------------
    
    al_drawCross(taskParam)
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        al_drawContext(taskParam, taskData.currentContext(i))
        al_drawCross(taskParam)
    end
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    %Screen('Flip', taskParam.gParam.window.onScreen, t + 1.1, 1);
    tUpdated = tUpdated + outcomeLength;
    Screen('Flip', taskParam.gParam.window.onScreen, tUpdated, 1);
    
    % send fixation cross 2 trigger
    taskData.triggers(i,4) = ...
        al_sendTrigger(taskParam, taskData, condition, haz, i, 4);
    
    %% --------------------------------------------------------------------
    % Outcome 2
    %----------------------------------------------------------------------
    
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        al_drawContext(taskParam, taskData.currentContext(i))
        al_drawCross(taskParam)
    end
    al_shield(taskParam, taskData.allASS(i),...
        taskData.pred(i), taskData.shieldType(i))

    if isequal(condition,'shield') || isequal(condition, 'mainPractice_1') || isequal(condition, 'mainPractice_2') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
        al_drawCannon(taskParam, taskData.distMean(i), taskData.latentState(i))
    else
        al_drawCross(taskParam)
    end
    
    al_drawOutcome(taskParam, taskData.outcome(i))
    
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    %Screen('Flip', taskParam.gParam.window.onScreen, t + 2.1);
    
    tUpdated = tUpdated + fixCrossLength;
    Screen('Flip', taskParam.gParam.window.onScreen, tUpdated);
    
    % send outcome 2 trigger
    taskData.triggers(i,5) = ...
        al_sendTrigger(taskParam, taskData, condition, haz, i, 5);
    %WaitSecs(.5);
    
    %% --------------------------------------------------------------------
    % Fixation cross 3
    %----------------------------------------------------------------------
    
    al_drawCross(taskParam)
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        al_drawContext(taskParam,taskData.currentContext(i))
        al_drawCross(taskParam)
    end
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    
    %Screen('Flip', taskParam.gParam.window.onScreen, t + 2.6);
    tUpdated = tUpdated + outcomeLength;
    Screen('Flip', taskParam.gParam.window.onScreen, tUpdated);
    
    % send fixation cross 3 trigger
    taskData.triggers(i,6) = ...
        al_sendTrigger(taskParam, taskData, condition, haz, i, 6);
    %WaitSecs();
    WaitSecs(fixedITI / 2);
    
    % send trial summary trigger
    taskData.triggers(i,7) = ...
        al_sendTrigger(taskParam, taskData, condition, haz, i, 16);
    
    %WaitSecs(.5);
    WaitSecs(fixedITI / 2);
    taskData.timestampOffset(i,:) = GetSecs - ref;
end

%% ------------------------------------------------------------------------
% Give feedback
%--------------------------------------------------------------------------
if ~isequal(condition,'shield')
    
    if isequal(taskParam.gParam.taskType, 'dresden')
        [txt, header] = Feedback(taskData, taskParam, subject, condition);
        
    elseif isequal(taskParam.gParam.taskType, 'chinese')
        
        whichBlock = taskData.block == taskData.block(i);
        txt = AL_feedback(taskData, taskParam, subject, condition, whichBlock);
        
        if isequal(condition,'chinese')
            header = sprintf('Ende Block %.0f von 4', taskData.block(i-1));
        elseif isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3') || isequal(condition, 'chinesePractice_4')
            header = 'Ergebnis';
        end
        
    elseif isequal(taskParam.gParam.taskType, 'oddball')
        
        if isequal(condition, 'oddballPractice')
            
            [txt, header] = Feedback(taskData, taskParam, subject, condition);
            
        else
            
            [txt, header] = Feedback(taskData, taskParam, subject, condition);
            
        end
        
    elseif isequal(taskParam.gParam.taskType, 'reversal') ||...
            isequal(taskParam.gParam.taskType, 'reversalPractice') ||...
            isequal(taskParam.gParam.taskType, 'ARC')

        [txt, header] = al_feedback(taskData, taskParam, subject, condition);
        
    end
    
    al_bigScreen(taskParam, taskParam.strings.txtPressEnter,...
        header, txt, true);
    
    
end
% necessary?
KbReleaseWait();

%% ------------------------------------------------------------------------
% Save data
%--------------------------------------------------------------------------

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
    taskData.savedTickmark, 'TAC',taskData.TAC, 'shieldType', taskData.shieldType,...
    'catchTrial', taskData.catchTrial, 'triggers', taskData.triggers,...
    'pred', taskData.pred,'predErr', taskData.predErr, 'memErr',...
    taskData.memErr, 'cannonDev', taskData.cannonDev,...
    'UP',taskData.UP, 'hit', taskData.hit, 'perf',...
    taskData.perf, 'accPerf',taskData.accPerf,'initialTendency',...
    taskData.initialTendency, 'RT', taskData.RT, 'Date', {taskData.Date},...
    'currentContext', taskData.currentContext,...
    'hiddenContext', taskData.hiddenContext,...
    'contextTypes', taskData.contextTypes,...
    'latentState', taskData.latentState,'taskParam',taskParam);

Data = catstruct(subject, Data);

% save is currently only specified for reversal, chinese and ARC!

if taskParam.gParam.askSubjInfo && ~taskParam.unitTest && ~isequal(condition, 'shield') && ~isequal(condition, 'mainPractice_1')  && ~isequal(condition, 'mainPractice_2') && ~isequal(condition, 'mainPractice_3') && ~isequal(condition, 'chinesePractice_1') && ~isequal(condition, 'chinesePractice_2') && ~isequal(condition, 'chinesePractice_3') && ~isequal(condition, 'chinesePractice_4')
    
    if isequal(condition, 'reversal')
        
        if subject.rew == 1
            rewName = 'B';
        elseif subject.rew == 2
            rewName = 'G';
        end
        
        savename = sprintf('ReversalTask_%s_%s',...
            rewName, subject.ID);
        
    elseif isequal(condition, 'chinese')
        
        savename = sprintf('chinese_%s', subject.ID);
        
    elseif isequal(taskParam.gParam.taskType, 'ARC') && isequal(condition,'main')
        
        if taskParam.gParam.showTickmark
            savename = sprintf('ARC_cannon_gr%s_TM_%s_conc%1.f',subject.group, subject.ID,...
                concentration);
        elseif ~taskParam.gParam.showTickmark
            savename = sprintf('ARC_cannon_gr%s_NTM_%s_conc%1.f',subject.group, subject.ID,...
                concentration);
        end
        
    end
    
    save(savename, 'Data')
    
end

KbReleaseWait();
end
