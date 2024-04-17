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


% Todo:
% Check timing with Hamburg and document final choices above
% Ensure timing output in console is up to date

% Wait until keys released
KbReleaseWait();

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% Reset reference time stamp
taskParam.timingParam.ref = GetSecs();

% Cycle over trials
% -----------------
for i = 1:trial

    % 1. Trial phase: Trial Onset
    % ---------------------------

    % Save constant variables on each trial
    taskData.currTrial(i) = i;
    taskData.age(i) = taskParam.subject.age;
    taskData.ID{i} = taskParam.subject.ID;
    taskData.gender{i} = taskParam.subject.gender;
    taskData.date{i} = taskParam.subject.date;
    taskData.cBal(i) = taskParam.subject.cBal;
    taskData.rew(i) = taskParam.subject.rew;
    taskData.testDay(i) = taskParam.subject.testDay;
    taskData.group(i) = taskParam.subject.group;
    taskData.confettiStd(i) = taskParam.cannon.confettiStd;
    taskData.cond{i} = condition;

    if isequal(taskParam.trialflow.reward, 'monetaryPunishment')
        taskData.startingBudget(i) = taskParam.subject.startingBudget;
    else
        taskData.startingBudget(i) = 0;
    end

    % Timestamp for measuring jitter duration for validation purposes
    jitTest = GetSecs();

    % Take jitter into account and get timestamps for initiation RT
    taskData.actJitter(i) = rand * taskParam.timingParam.jitterITI;
    WaitSecs(taskData.actJitter(i));
    initRT_Timestamp = GetSecs();

    % Print out jitter duration, if desired
    if taskParam.gParam.printTiming
        fprintf('\nTrial %.0f:\nJitter duration: %.5f\n', i, GetSecs() - jitTest)
    end

    % 2. Trial phase: Self-paced prediction
    % -------------------------------------

    % Send trial-onset trigger
    taskData.triggers(i,1) = al_sendTrigger(taskParam, taskData, condition, i, 'trialOnset');
    taskData.timestampOnset(i,:) = GetSecs - taskParam.timingParam.ref;

    % Reset mouse to screen center
    SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen)

    % Participant indicates prediction
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp);
    taskData.timestampPrediction(i) = GetSecs - taskParam.timingParam.ref;

    % Print timing
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
    %% todo: compare to memory error in other versions

    % Record hit
    if abs(taskData.predErr(i)) <= taskData.allShieldSize(i)/2
        taskData.hit(i) = 1;
    else
        taskData.hit(i) = 0;
    end

    % Record belief update
    if i > 1
        taskData.UP(i) = al_diff(taskData.pred(i), taskData.pred(i-1));
    end

    % Performance depends on hit vs miss and condition
    if taskData.hit(i) == 1 && isequal(taskParam.trialflow.reward, 'monetaryReward')
        taskData.perf(i) = taskParam.gParam.rewMag;
    elseif taskData.hit(i) == 0 && isequal(taskParam.trialflow.reward, 'monetaryPunishment')
        taskData.perf(i) = -1*taskParam.gParam.rewMag;
    else
        taskData.perf(i) = 0;
    end

    % Accumulated performance
    taskData.accPerf(i) = sum(taskData.perf, 'omitnan') + taskData.startingBudget(i);

    % 3. Trial phase: Fixation cross 1
    % --------------------------------

    % Draw circle
    al_drawCircle(taskParam)

    % Cannon optionally
    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawFixPoint(taskParam)
    end

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);

    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs + 0.01;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Send fixation cross 1 trigger
    taskData.triggers(i,4) = al_sendTrigger(taskParam, taskData, condition, i, 'fix');
    taskData.timestampFixCross1(i) = GetSecs() - taskParam.timingParam.ref;

    % 4. Trial phase: Shield
    % ----------------------

    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        %[xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawFixPoint(taskParam)
    end

    % Draw circle and confetti cloud
    al_drawCircle(taskParam)

    % Draw shield
    al_shield(taskParam, taskData.allShieldSize(i), taskData.pred(i), taskData.shieldType(i))

    % taskData = al_confetti(taskParam, taskData, i, background, timestamp);
    al_confettiOutcome(taskParam, taskData, i)

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.fixCrossOutcome;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Send shield trigger
    taskData.triggers(i,5) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.reward, i, 'shield');
    taskData.timestampShield(i) = GetSecs - taskParam.timingParam.ref;

    if taskParam.gParam.printTiming
        fprintf('Fixation-cross 1 duration: %.5f\n', taskData.timestampShield(i) - taskData.timestampFixCross1(i))
    end

    % 5. Trial phase: Fixation cross 2
    % --------------------------------

    al_drawFixPoint(taskParam)
    al_drawCircle(taskParam)

    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawFixPoint(taskParam)
    end

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.shieldLength;  % taskParam.timingParam.cannonBallAnimation; %
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Send fixation cross 2 trigger
    taskData.triggers(i,6) = al_sendTrigger(taskParam, taskData, condition, i, 'fix');
    taskData.timestampFixCross2(i) = GetSecs() - taskParam.timingParam.ref;

    if taskParam.gParam.printTiming
        fprintf('Shield duration: %.5f\n', taskData.timestampFixCross2(i) - taskData.timestampShield(i))
    end

    % 6. Trial phase: Reward
    % ----------------------

    % Monetary-reward condition
    if isequal(taskParam.trialflow.reward, 'monetaryReward') && taskData.hit(i)

        txt = sprintf('+%.1f Euro', taskData.perf(i));
        DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', 'center', taskParam.colors.green);

        % Monetary-punishment condition
    elseif isequal(taskParam.trialflow.reward, 'monetaryPunishment') && ~taskData.hit(i)

        txt = sprintf('%.1f Euro', taskData.perf(i));
        DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', 'center', taskParam.colors.red); %[255 0 0]

        % Social-reward condition
    elseif isequal(taskParam.trialflow.reward, 'socialReward') && taskData.hit(i)

        txt = 'Super!';
        DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', taskParam.display.screensize(4)*0.35, taskParam.colors.green);
        r = randi([1,taskParam.display.nHas]);
        Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.socialHasTxts{r}, [], taskParam.display.centeredSocialFeedbackRect, 0);

        % Social-punishment condition
    elseif isequal(taskParam.trialflow.reward, 'socialPunishment') && ~taskData.hit(i)

        txt = 'Schlecht!';
        DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', taskParam.display.screensize(4)*0.35, taskParam.colors.red); % [255 0 0]

        r = randi([1,taskParam.display.nDis]);
        Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.socialDisTxts{r}, [], taskParam.display.centeredSocialFeedbackRect, 0);
    else

        % If not feedback is shown, show circle
        al_drawFixPoint(taskParam)
        al_drawCircle(taskParam)

        % Optionally, show cannon
        if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
            al_drawCannon(taskParam, taskData.distMean(i))
        else
            Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
            al_drawFixPoint(taskParam)
        end
    end

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.fixCrossOutcome;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Send reward trigger
    taskData.triggers(i,7) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.reward, i, 'reward');
    taskData.timestampReward(i) = GetSecs - taskParam.timingParam.ref;

    % Print timing
    if taskParam.gParam.printTiming
        fprintf('Fixation-cross 2 duration: %.5f\n', taskData.timestampReward(i) - taskData.timestampFixCross2(i))
    end

    % 7. Trial phase: Fixation cross: ITI
    % -----------------------------------

    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawFixPoint(taskParam)
    end

    % Draw circle and confetti cloud
    al_drawCircle(taskParam)

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.rewardLength;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Send fixation cross 3 trigger
    taskData.triggers(i,8) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.reward, i, 'fix');
    taskData.timestampFixCross3(i) = GetSecs - taskParam.timingParam.ref;

    % Print timing
    if taskParam.gParam.printTiming
        fprintf('Reward duration: %.5f\n', taskData.timestampFixCross3(i) - taskData.timestampReward(i))
    end

    % Fixed inter-trial interval
    WaitSecs(taskParam.timingParam.fixedITI);
    taskData.timestampOffset(i) = GetSecs - taskParam.timingParam.ref;

    % Reward timestamp
    if taskParam.gParam.printTiming
        fprintf('Fixation-cross 3 duration: %.5f\n', taskData.timestampOffset(i) - taskData.timestampFixCross3(i))
    end

    % Manage breaks
    taskParam = al_takeBreak(taskParam, taskData, i, trial, false);

end

% Give feedback and save data
% ----------------------------

if ~taskParam.unitTest

    % currPoints = sum(taskData.hit, 'omitnan');
    if isequal(taskParam.trialflow.reward, "monetaryReward")

        txt = sprintf('In diesem Block hast Du %.2f Euro verdient.', taskData.accPerf(end));

    elseif isequal(taskParam.trialflow.reward, "monetaryPunishment")

        txt = sprintf('In diesem Block hast Du inklusive Deines Startbudgets %.2f Euro verdient.', taskData.accPerf(end));

    elseif isequal(taskParam.trialflow.reward, "socialReward")

        txt = sprintf('In diesem Block hast Du %.0f Likes erhalten.', sum(taskData.hit==1));

    else

        txt = sprintf('In diesem Block hast Du %.0f Dislikes erhalten.', sum(taskData.hit==0));

    end

    header = 'Zwischenstand';
    feedback = true;
    al_bigScreen(taskParam, header, txt, feedback);

    % Save data
    %----------

    concentration = unique(taskData.concentration);
    savename = sprintf('confetti_EEG_%s_%s_g%d_conc%d_%s', taskParam.trialflow.exp, taskParam.trialflow.reward, taskParam.subject.group, concentration, taskParam.subject.ID);

    %% Todo: create function for this
    checkString = dir([savename '*']);
    fileNames = {checkString.name};
    if  ~isempty(fileNames)
        savename = [savename '_new'];
    end

    % Save as struct
    taskData = saveobj(taskData);
    save(savename, 'taskData')

    % Wait until keys released
    KbReleaseWait();
end
end