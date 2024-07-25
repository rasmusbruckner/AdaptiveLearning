function taskData = al_confettiLoop(taskParam, condition, taskData, trial, file_name_suffix)
%AL_CONFETTILOOP This function runs the cannon-task trials for the common confetti-cannon version
%
%   Input
%       taskParam: Task-parameter-object instance
%       condtion: Condition type
%       taskData: Task-data-object instance
%       trial: Number of trials
%       file_name_suffix: Suffix of saved files
%
%   Output
%       taskData: Task-data-object instance


% Check if unit test is requested
if ~exist('file_name_suffix', 'var') || isempty(file_name_suffix)
    error('No file name suffix provides ')
end

% Wait until keys released
KbReleaseWait();

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% Initialize and start eye-tracker
if taskParam.gParam.eyeTracker
    [el, et_file_name] = taskParam.eyeTracker.initializeEyeLink(taskParam, file_name_suffix);
    taskParam = taskParam.eyeTracker.startRecording(taskParam);
end

% Wait for scanner trigger
if taskParam.gParam.scanner

    % Display that we're waiting for scanner
    al_waitForScanner(taskParam, 'Messung startet in wenigen Sekunden...')

    triggered = 0;
    fprintf('Waiting for trigger\n')
    while triggered == 0
        [ ~, t_Vol, keyCode] = KbCheck();
        if keyCode(taskParam.keys.five)
            triggered = 1;
            fprintf('Triggered!\n')
        end
    end

    % Reference time stamp
    taskParam.timingParam.ref = t_Vol;

end

% Indicate if passive viewing or not to determine what to save later on
taskData.passiveViewingCondition = taskParam.gParam.passiveViewing;

% Cycle over trials
% -----------------

for i = 1:trial

    % Presenting trial number at the bottom of the eyetracker display - optional
    if taskParam.gParam.eyeTracker && isequal(taskParam.trialflow.exp, 'exp')
        Eyelink('command', 'record_status_message "TRIAL %d/%d"', i, trial);
        Eyelink('message', 'TRIALID %d', i);
    end

    % % This is a pre-liminary test-trigger for MEG
    % %% Todo: implement all triggers in al_sendTrigger
    % if taskParam.gParam.meg
    %     trigger(50);
    % end

    % Save constant variables on each trial
    taskData.currTrial(i) = i;
    taskData.age(i) = taskParam.subject.age;
    taskData.ID{i} = taskParam.subject.ID;
    taskData.gender{i} = taskParam.subject.gender;
    taskData.date{i} = taskParam.subject.date;
    taskData.cBal(i) = taskParam.subject.cBal;
    taskData.rew(i) = taskParam.subject.rew;
    taskData.group(i) = taskParam.subject.group;
    taskData.confettiStd(i) = taskParam.cannon.confettiStd;
    taskData.cond{i} = condition;
    taskData.passiveViewing(i) = taskParam.gParam.passiveViewing;

    % Timestamp for measuring jitter duration for validation purposes
    jitTest = GetSecs();

    % Take jitter into account and get timestamps for initiation RT
    taskData.actJitterOnset(i) = rand * taskParam.timingParam.jitterITI;
    taskData.actJitterOutcome(i) = rand * taskParam.timingParam.jitterOutcome;
    taskData.actJitterShield(i) = rand * taskParam.timingParam.jitterShield;

    % Onset jitter
    % ------------

    WaitSecs(taskData.actJitterOnset(i));

    % Print out jitter duration, if desired
    if taskParam.gParam.printTiming
        fprintf('\nTrial %.0f:\nJitter duration: %.5f\n', i, GetSecs() - jitTest)
    end

    % Baseline period
    % ---------------
    % This is the new baseline period
    % Todo: check if timing is good
    % And consider adding trigger (but coordinate with others first)
    if taskParam.gParam.passiveViewing == false
        fixationPhase(taskParam)
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        timestamp = GetSecs() + 0.001;
        Screen('Flip', taskParam.display.window.onScreen, timestamp);
        WaitSecs(taskParam.timingParam.baselineFixLength);
    else
        taskData = al_passiveViewingAttentionCheck(taskParam, taskData, i);
    end

    % Send trial-onset trigger
    taskData.triggers(i,1) = al_sendTrigger(taskParam, taskData, condition, i, 'trialOnset');
    taskData.timestampOnset(i,:) = GetSecs - taskParam.timingParam.ref;

    % Timestamp prediction phase onset for RT
    initRT_Timestamp = GetSecs();

    % Self-paced prediction phase
    % ---------------------------

    % Reset mouse to screen center
    SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen)

    % Participant indicates prediction
    if taskParam.gParam.passiveViewing == false
        [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp);
    else
        taskData = al_passiveViewingSpot(taskParam, taskData, i, initRT_Timestamp);
    end

    % Timestamp prediction
    taskData.timestampPrediction(i) = GetSecs - taskParam.timingParam.ref;

    % Display RT and initiation RT in console
    if taskParam.gParam.printTiming
        fprintf('Initiation RT: %.5f\n', taskData.initiationRTs(i))
        fprintf('RT: %.5f\n', taskData.RT(i))
    end

    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs;

    % Prediction error & estimation error
    taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
    taskData.estErr(i) = al_diff(taskData.distMean(i), taskData.pred(i));

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

    % Optionally, show confetti animation
    if isequal(taskParam.trialflow.shot, 'animate cannonball')

        % Confetti animation
        background = false; % todo: include this in trialflow
        taskData = al_confetti(taskParam, taskData, i, background, timestamp);

        % Display timing info in console
        if taskParam.gParam.printTiming
            shotTiming = GetSecs() - taskParam.timingParam.ref;
            fprintf('Shot duration: %.5f\n', shotTiming - taskData.timestampPrediction(i))
        end
    end

    % Compute performance
    if strcmp(taskParam.trialflow.reward, 'asymmetric')

        % Performance depends on green vs. red particles caught
        taskData.perf(i) = taskData.greenCaught(i) - taskData.redCaught(i);

        % Reward prediction error: actual reward - (green minus red confetti particles assuming that all particles would be collected)
        taskData.RPE(i) = taskData.perf(i) - (taskData.nGreenParticles(i) - (taskData.nParticles(i)-taskData.nGreenParticles(i)));

    else

        % Performance depends on hit vs. miss
        if taskData.hit(i) == 1
            taskData.perf(i) = taskParam.gParam.rewMag;
        else
            taskData.perf(i) = 0;
        end

    end

    % Accumulated performance
    taskData.accPerf(i) = nansum(taskData.perf);
    % The above is included for backward compatibility. In future, when all
    % labs have more recent Matlab versions, potentially change to:
    % taskData.accPerf(i) = sum(taskData.perf, 'omitnan');

    % Fixation cross
    % --------------
    if isequal(taskParam.trialflow.shot, 'static')

        fixationPhase(taskParam)
        timestamp = timestamp + 0.001;
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Send fixation cross 1 trigger
        taskData.triggers(i,4) = al_sendTrigger(taskParam, taskData, condition, i, 'fix');
        taskData.timestampFixCross1(i) = GetSecs() - taskParam.timingParam.ref;

    end

    % For asymmetric reward: Display feedback and fixation crosss
    if strcmp(taskParam.trialflow.reward, 'asymmetric')

        % Feedback
        % --------

        timestamp = timestamp + taskParam.timingParam.shieldLength;

        % Display reward feedback
        txt = sprintf('<color=32CD32>Grünes Konfetti: %.0f\n<color=ff0000>Rotes Konfetti: %.0f\n<color=ffa500>Gewinn: %.0f Punkte', taskData.greenCaught(i), taskData.redCaught(i), taskData.perf(i));
        zero = taskParam.display.zero;
        DrawFormattedText2(txt,'win',taskParam.display.window.onScreen, 'sx' ,zero(1), 'sy', zero(2), 'xalign','center','yalign','center');

        % Tell PTB that everything has been drawn and flip screen
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Display timing info in console
        if taskParam.gParam.printTiming
            fixCrossTiming = GetSecs - taskParam.timingParam.ref;
            fprintf('Fixation-cross duration: %.5f\n', fixCrossTiming -  shotTiming)
        end

        % Fixation cross: ITI
        % -------------------

        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawFixPoint(taskParam)

        % Draw circle and confetti cloud
        al_drawCircle(taskParam)

        % Tell PTB that everything has been drawn and flip screen
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        timestamp = timestamp + taskParam.timingParam.rewardLength;
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Display timing info in console
        if taskParam.gParam.printTiming
            taskData.timestampReward(i) = GetSecs - taskParam.timingParam.ref;
            fprintf('Feedback duration: %.5f\n', taskData.timestampReward(i) - fixCrossTiming)
        end
    end

    % Outcome
    % -------

    if isequal(taskParam.trialflow.shot, 'static')

        % Draw circle and confetti cloud
        al_drawCircle(taskParam)
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawFixPoint(taskParam)
        al_tickMark(taskParam, taskData.pred(i), 'pred');
        taskParam = al_confettiOutcome(taskParam, taskData, i);

        % Tell PTB that everything has been drawn and flip screen
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        timestamp = timestamp + taskParam.timingParam.fixCrossOutcome + taskData.actJitterOutcome(i);
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Send outcome trigger
        taskData.triggers(i,5) = al_sendTrigger(taskParam, taskData, condition, i, 'outcome');
        taskData.timestampOutcome(i) = GetSecs - taskParam.timingParam.ref;

        % Display timing info in console
        if taskParam.gParam.printTiming
            fprintf('Fixation-cross 1 duration: %.5f\n', taskData.timestampOutcome(i) - taskData.timestampFixCross1(i))
        end
    end

    % Fixation cross (animated version) or shield (static version)
    % ------------------------------------------------------------
    if isequal(taskParam.trialflow.shot, 'static')

        % Tell PTB that everything has been drawn and flip screen
        fixationPhase(taskParam)
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        timestamp = timestamp + taskParam.timingParam.outcomeLength;
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Send fixation cross 2 trigger
        taskData.triggers(i,6) = al_sendTrigger(taskParam, taskData, condition, i, 'fix');
        taskData.timestampFixCross2(i) = GetSecs - taskParam.timingParam.ref;

        % Display timing info in console
        if taskParam.gParam.printTiming
            fprintf('Outcome duration: %.5f\n', taskData.timestampFixCross2(i) - taskData.timestampOutcome(i))
        end
    end

    % Draw circle and confetti cloud
    al_drawCircle(taskParam)
    Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    al_drawFixPoint(taskParam)

    % Optionally draw outcome and shield
    if isequal(taskParam.trialflow.shot, 'static')
        al_shield(taskParam, taskData.allShieldSize(i), taskData.pred(i), taskData.shieldType(i))
        regenerateParticles = false;
        al_confettiOutcome(taskParam, taskData, i, regenerateParticles);
    end

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.fixCrossShield + taskData.actJitterShield(i);
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Send shield trigger
    taskData.triggers(i,7) = al_sendTrigger(taskParam, taskData, condition, i, 'shield');
    taskData.timestampShield(i) = GetSecs - taskParam.timingParam.ref;

    % Display timing info in console
    if taskParam.gParam.printTiming && isequal(taskParam.trialflow.shot, 'static')
        fprintf('Fixation-cross 2 duration: %.5f\n', taskData.timestampShield(i) - taskData.timestampFixCross2(i))
    end

    % Fixation cross (static version)
    % -------------------------------
    if isequal(taskParam.trialflow.shot, 'static')

        % Tell PTB that everything has been drawn and flip screen
        fixationPhase(taskParam, [222,222,222])
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        timestamp = timestamp + taskParam.timingParam.shieldLength;
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Send fixation cross 3 trigger
        taskData.triggers(i,8) = al_sendTrigger(taskParam, taskData, condition, i, 'fix');
        taskData.timestampFixCross3(i) = GetSecs - taskParam.timingParam.ref;

        % Display timing info in console
        if taskParam.gParam.printTiming
            fprintf('Shield duration: %.5f\n', taskData.timestampFixCross3(i) - taskData.timestampShield(i))
        end
    end

    % Fixed inter-trial interval
    WaitSecs(taskParam.timingParam.fixedITI);

    % Offset timestamp
    taskData.timestampOffset(i) = GetSecs - taskParam.timingParam.ref;
    if taskParam.gParam.printTiming
        if strcmp(taskParam.trialflow.reward, 'asymmetric')
            fprintf('Fixation-cross duration: %.5f\n', taskData.timestampOffset(i) - taskData.timestampReward(i))
        elseif isequal(taskParam.trialflow.shot, 'animate cannonball')
            fprintf('Shield duration: %.5f\n', taskData.timestampOffset(i) - taskData.timestampShield(i))
        else
            fprintf('Fixation-cross 3 duration: %.5f\n', taskData.timestampOffset(i) - taskData.timestampFixCross3(i))
        end
    end

    % Manage breaks
    taskParam = al_takeBreak(taskParam, taskData, i, trial);

end

% Add stimulus values
%--------------------

taskData.rotationRad = taskParam.circle.rotationRad;

% Give feedback and save data
% ---------------------------

if ~taskParam.unitTest.run

    % Save Eyelink data
    % -----------------
    
    if taskParam.gParam.eyeTracker
        et_path = pwd;
        et_file_name=[et_file_name, '.edf'];
        al_saveEyelinkData(et_path, et_file_name)
        Eyelink('StopRecording');
    end

    if isequal(taskParam.trialflow.reward, 'asymmetric') == false && taskParam.gParam.passiveViewing == false
        currPoints = nansum(taskData.hit);
        % The above is included for backward compatibility. In future, when all
        % labs have more recent Matlab versions, potentially change to:
        % currPoints = sum(taskData.hit, 'omitnan');

        if taskParam.gParam.customInstructions
            taskParam.instructionText = taskParam.instructionText.giveFeedback(currPoints, 'block');
            txt = taskParam.instructionText.dynamicFeedbackTxt;
        else
            if isequal(taskParam.gParam.language, 'German')
                txt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', currPoints);
            elseif isequal(taskParam.gParam.language, 'English')
                txt = sprintf('You have earned %.0f points in this block.', currPoints);
            else
                error('language parameter unknown')
            end
        end
    elseif isequal(taskParam.trialflow.reward, 'asymmetric') == true && taskParam.gParam.passiveViewing == false
        txt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', round(sum(taskData.nParticlesCaught))/10);
    elseif taskParam.gParam.passiveViewing
        txt = sprintf('In diesem Block haben Sie %.0f Mal richtig reagiert.', sum(taskData.targetCorr));
    end

    if isequal(taskParam.gParam.language, 'German')
        header = 'Zwischenstand';
    elseif isequal(taskParam.gParam.language, 'English')
        header = 'Your Score';
    else
        error('language parameter unknown')
    end

    feedback = true;
    al_bigScreen(taskParam, header, txt, feedback);

    % Save data
    %----------

    if isequal(taskParam.gParam.saveName, 'vwm')
        savename = sprintf('confetti_vwm_dm_%s_tm_%s_var_%s_id_%s', taskParam.trialflow.distMean, taskParam.trialflow.currentTickmarks, taskParam.trialflow.variability, taskParam.subject.ID);
    elseif isequal(taskParam.gParam.saveName, 'asymmetric')
        concentration = unique(taskData.concentration);
        savename = sprintf('confetti_asymrew_%s_g%d_conc%d_%s', taskParam.trialflow.exp, taskParam.subject.group, concentration, taskParam.subject.ID);
    else
        concentration = unique(taskData.concentration);
        savename = sprintf('commonConfetti_%s_g%d_conc%d_%s_%s', taskParam.trialflow.exp, taskParam.subject.group, concentration, taskParam.subject.ID, file_name_suffix);
    end

    % Ensure that files cannot be overwritten
    checkString = dir([savename '*']);
    fileNames = {checkString.name};
    if  ~isempty(fileNames)
        savename = [savename '_new'];
    end

    % Save as struct
    taskData = saveobj(taskData);
    save(savename, 'taskData');

    % Wait until keys released
    KbReleaseWait();

end
end

function fixationPhase(taskParam, color)
%FIXATIONPHASE This function implements the fixation phase
%
%   Input
%       taskParam: task-parameter-objects instance
%       color: optional color of fixation dot
%
%   Output
%       None

% Check if reduced shield is requested
if ~exist('color', 'var') || isempty(color)
    color = taskParam.colors.fixDot;
end

Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
al_drawFixPoint(taskParam, color)

% Draw circle and confetti cloud
al_drawCircle(taskParam)

% Tell PTB that everything has been drawn and flip screen
Screen('DrawingFinished', taskParam.display.window.onScreen);

end
