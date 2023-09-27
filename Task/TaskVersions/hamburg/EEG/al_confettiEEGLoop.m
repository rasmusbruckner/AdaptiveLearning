function taskData = al_confettiEEGLoop(taskParam, condition, taskData, trial)
%AL_CONFETTIEEGLOOP This function runs the cannon-task trials for the confetti-cannon EEG version
%
%   Input
%       taskParam: Task-parameter-object instance
%       condtion: Condition type
%       taskData: Task-data-object instance
%       trial: Number of trials
%
%   Output
%       taskData: Task-data-object instance
%
%   Events EEG version
%       1. Trial Onset
%       2. Prediction            self-paced
%       3. Fixation cross 1      500 ms
%       4. Outcome               500 ms
%       5. Fixation cross 2      1000 ms
%       6. Shield                500 ms
%       7. Fixation cross 3      1000 ms
%       8. Reward                1000 ms
%       9. Fixation cross: ITI   1000 ms
%       10. Jitter               0-200 ms
%                                ------------
%                                5.6 s + pred (~ 1.5 s)


% Todo:
% Check timing with Hamburg and document final choices above
% Ensure timing output in console is up to date
% Check triggers with Hamburg

% Wait until keys released
KbReleaseWait();

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% Cycle over trials
% -----------------
for i = 1:trial
    
    % 1. Trial phase: Trial Onset
    % ---------------------------

    % Manage breaks
    taskParam = al_takeBreak(taskParam, taskData, i);
    
    % Save constant variables on each trial
    taskData.currTrial(i) = i;
    taskData.age(i) = taskParam.subject.age;
    taskData.ID{i} = taskParam.subject.ID;
    taskData.sex{i} = taskParam.subject.sex;
    taskData.Date{i} = taskParam.subject.date;
    taskData.cBal(i) = taskParam.subject.cBal;
    taskData.rew(i) = taskParam.subject.rew;
    taskData.startingBudget(i) = taskParam.subject.startingBudget;
    taskData.testDay(i) = taskParam.subject.testDay;
    taskData.group(i) = taskParam.subject.group;
    taskData.confettiStd(i) = taskParam.cannon.confettiStd;
    taskData.cond{i} = condition;

    % Timestamp for measuring jitter duration for validation purposes
    jitTest = GetSecs();

    % Take jitter into account and get timestamps for initiation RT
    taskData.actJitter(i) = rand * taskParam.timingParam.jitter;
    WaitSecs(taskData.actJitter(i));
    initRT_Timestamp = GetSecs();

    % Print out jitter duration, if desired
    if taskParam.gParam.printTiming
        fprintf('\nTrial %.0f:\nJitter duration: %.5f\n', i, GetSecs() - jitTest)
    end
    
    % 2. Trial phase: Self-paced prediction 
    % -------------------------------------

    % Send trial-onset trigger
    taskData.triggers(i,1) = al_sendTrigger(taskParam, taskData, condition, i, 'onset'); % this is the trial onset trigger
    taskData.timestampOnset(i,:) = GetSecs - taskParam.timingParam.ref;

    % Reset mouse to screen center
    SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen) % 720, 450,

    % Participant indicates prediction
    press = 0;
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp, press);

    % send fixation cross 1 trigger
    % todo: this should be done in mouse loop, like I did for keyboardLoop
    taskData.triggers(i,2) = al_sendTrigger(taskParam, taskData, condition, i, 'response'); % this is the prediction / fixation 1 trigger
    taskData.timestampPrediction(i) = GetSecs - taskParam.timingParam.ref;

    if taskParam.gParam.printTiming
        fprintf('Initiation RT: %.5f\n', taskData.initiationRTs(i))
        fprintf('RT: %.5f\n', taskData.RT(i))
    end

    % Deviation from cannon (estimation error) to compute performance
    % criterion in practice
    % Careful: same as est err. -- update in full version
    taskData.cannonDev(i) = al_diff(taskData.distMean(i), taskData.pred(i));

    % Prediction error & estimation error
    taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
    taskData.estErr(i) = al_diff(taskData.distMean(i), taskData.pred(i));
    % todo: compare to memory error in other versions

    % Record hit
    if abs(taskData.predErr(i)) <= taskData.allASS(i)/2
        taskData.hit(i) = 1;
    else
        taskData.hit(i) = 0;
    end

    % Record belief update
    if i > 1
        taskData.UP(i) = al_diff(taskData.pred(i), taskData.pred(i-1));
    end

    % Performance depends on hit vs miss
    if taskData.hit(i) == 1
        taskData.perf(i) = taskParam.gParam.rewMag;
    else
        taskData.perf(i) = -1*taskParam.gParam.rewMag;
    end

    % Accumulated performance
    taskData.accPerf(i) = sum(taskData.perf, 'omitnan') + taskData.startingBudget(i);

    % 3. Trial phase: Fixation cross 1
    % --------------------------------

    al_drawCircle(taskParam)

    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
        Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawCross(taskParam)
    end

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs + 0.01;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % 4. Trial phase: Outcome
    %------------------------

    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
        Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawCross(taskParam)
    end

    % Draw circle and confetti cloud
    al_drawCircle(taskParam)
    al_tickMark(taskParam, taskData.pred(i), 'pred')

    % taskData = al_confetti(taskParam, taskData, i, background, timestamp);
    al_confettiOutcome(taskParam, taskData, i)
    
    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    
    % Extract current time and determine when screen should be flipped
    % for accurate timing
    % timestamp = GetSecs;
    timestamp = timestamp + 0.5;
    % timestamp = timestamp + taskParam.timingParam.cannonBallAnimation;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);
    
    taskData.triggers(i,3) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.reward, i, 'outcome'); % this is the PE
    
    if taskParam.gParam.printTiming
        %fixCrossTiming = GetSecs() - taskParam.timingParam.ref;
        taskData.timestampFixCross2(i) = GetSecs() - taskParam.timingParam.ref;
        fprintf('Fix-cross 1 duration: %.5f\n', taskData.timestampFixCross2(i) - taskData.timestampPrediction(i))
    end

    % 5. Trial phase: Fixation cross 2
    % --------------------------------

    al_drawCross(taskParam)
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        al_drawContext(taskParam, taskData.currentContext(i))
        al_drawCross(taskParam)
    end
    Screen('DrawingFinished', taskParam.display.window.onScreen, 1);

    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
        Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawCross(taskParam)
    end

    timestamp = timestamp + taskParam.timingParam.outcomeLength;
    Screen('Flip', taskParam.display.window.onScreen, timestamp, 1);
    taskData.triggers(i,4) = al_sendTrigger(taskParam, taskData, condition, i, 'fix'); % this is the 2nd fixation
    
    if taskParam.gParam.printTiming
        %shotTiming = GetSecs() - taskParam.timingParam.ref;
        taskData.timestampOutcome(i) = GetSecs() - taskParam.timingParam.ref;
        fprintf('Shot duration: %.5f\n', taskData.timestampOutcome(i) - taskData.timestampFixCross2(i))
    end

    % Send fixation cross 2 trigger
    %taskData.triggers(i,4) = al_sendTrigger(taskParam, taskData, condition, i, 4);

    % 6. Trial phase: Shield
    % ----------------------

    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
        Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawCross(taskParam)
    end

    % Draw circle and confetti cloud
    al_drawCircle(taskParam)

    al_shield(taskParam, taskData.allASS(i), taskData.pred(i), taskData.shieldType(i))

    % taskData = al_confetti(taskParam, taskData, i, background, timestamp);
    al_confettiOutcome(taskParam, taskData, i)

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.fixCrossLength;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);
    taskData.triggers(i,5) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.reward, i, 'shield'); % this is the shield trigger

    if taskParam.gParam.printTiming
        %fixCrossTiming = GetSecs - taskParam.timingParam.ref;
        taskData.timestampFixCross2(i) = GetSecs - taskParam.timingParam.ref;
        fprintf('Fix-cross 2 duration: %.5f\n', taskData.timestampFixCross2(i) - taskData.timestampOutcome(i))
    end

    % 7. Trial phase: Fixation cross 3
    % --------------------------------

    al_drawCross(taskParam)
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        al_drawContext(taskParam, taskData.currentContext(i))
        al_drawCross(taskParam)
    end

    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
        Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawCross(taskParam)
    end

    %Screen('Flip', taskParam.gParam.window.onScreen, t + 1.1, 1);
    Screen('DrawingFinished', taskParam.display.window.onScreen);

    timestamp = timestamp + taskParam.timingParam.shieldLength;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);
    taskData.triggers(i,6) = al_sendTrigger(taskParam, taskData, condition, i, 'fix'); % this is fixation 3

    if taskParam.gParam.printTiming
        % shieldTiming = GetSecs() - taskParam.timingParam.ref;
        taskData.timestampShield(i) = GetSecs() - taskParam.timingParam.ref;
        fprintf('Shield duration: %.5f\n', taskData.timestampShield(i) - taskData.timestampFixCross2(i))
    end

    % 8. Trial phase: Reward
    % ----------------------

    zero = taskParam.display.zero;

    if isequal(taskParam.trialflow.reward, 'social')

        if taskData.hit(i)

            % Display reward feedback
            txt = 'Super!';
            DrawFormattedText2(txt,'win',taskParam.display.window.onScreen, 'sx' ,zero(1), 'sy', taskParam.display.screensize(4)*.35, 'xalign','center','yalign','center');

            r = randi([1,taskParam.display.nHas]);
            Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.socialHasTxts{r}, [], taskParam.display.centeredSocialFeedbackRect, 0);  %  taskParam.display.dstRect taskData.distMean(i)
        else

            % Display reward feedback
            txt = 'Schlecht!';
            DrawFormattedText2(txt,'win',taskParam.display.window.onScreen, 'sx' ,zero(1), 'sy', taskParam.display.screensize(4)*.35, 'xalign','center','yalign','center');

            r = randi([1,taskParam.display.nDis]);
            Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.socialDisTxts{r}, [], taskParam.display.centeredSocialFeedbackRect, 0);  %  taskParam.display.dstRect taskData.distMean(i)
        end

    else

        if taskData.hit(i)
            % Display reward feedback
            txt = sprintf('<color=32CD32>Gewinn: +%.1f Euro\n<color=000000>Total: %.1f Euro', taskData.perf(i), taskData.accPerf(i));
            DrawFormattedText2(txt,'win',taskParam.display.window.onScreen, 'sx' ,zero(1), 'sy', zero(2), 'xalign','center','yalign','center');

        else
            % Display reward feedback
            txt = sprintf('<color=ff0000>Gewinn: %.1f Euro\n<color=000000>Total: %.1f Euro', taskData.perf(i), taskData.accPerf(i));
            DrawFormattedText2(txt,'win',taskParam.display.window.onScreen, 'sx' ,zero(1), 'sy', zero(2), 'xalign','center','yalign','center');

        end

    end

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.fixCrossLength;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);
    taskData.triggers(i,7) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.reward, i, 'reward'); % this is reward


    if taskParam.gParam.printTiming
        taskData.timestampFixCross3(i) = GetSecs - taskParam.timingParam.ref;
        fprintf('Fix-cross 3 duration: %.5f\n', taskData.timestampFixCross3(i) - taskData.timestampShield(i))
    end

    % 9. Trial phase: Fixation cross: ITI
    % -----------------------------------

    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
        Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawCross(taskParam)
    end

    % Draw circle and confetti cloud
    al_drawCircle(taskParam)

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.rewardLength;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);
    taskData.triggers(i,8) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.reward, i, 'fix'); % this is fix cross ITI

    if taskParam.gParam.printTiming
        %rewardTiming = GetSecs - taskParam.timingParam.ref;
        taskData.timestampReward(i) = GetSecs - taskParam.timingParam.ref;
        fprintf('Reward duration: %.5f\n', taskData.timestampReward(i) - taskData.timestampFixCross3(i))
    end

    % Fixed inter-trial interval
    WaitSecs(taskParam.timingParam.fixedITI);

    % Reward timestamp
    if taskParam.gParam.printTiming
        %taskData.timestamp(i) = GetSecs - taskParam.timingParam.ref;
        taskData.timestampOffset(i) = GetSecs - taskParam.timingParam.ref;
        fprintf('Fix-cross ITI duration: %.5f\n', taskData.timestampOffset(i) - taskData.timestampReward(i))
    end
   
end

% Give feedback and save data
% ----------------------------

% Todo: update this and potentially get rid of condition
if ~taskParam.unitTest

    whichBlock = taskData.block;
    [txt, header] = al_feedback(taskData, taskParam, taskParam.subject, condition, whichBlock, trial);
    feedback = true;
    al_bigScreen(taskParam, header, txt, feedback);

    if ~isequal(condition,'practice')

        % Save data
        %----------

        % todo: do we want to save practice?
        concentration = unique(taskData.concentration);
        savename = sprintf('confetti_EEG_%s_g%d_d%d_conc%d_%s', taskParam.trialflow.reward, taskParam.subject.group, taskParam.subject.testDay, concentration, taskParam.subject.ID);
        save(savename, 'taskData')

        % Wait until keys released
        KbReleaseWait();
    end
end
end