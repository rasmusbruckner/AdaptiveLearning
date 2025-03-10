function taskData = al_confettiLoop(taskParam, condition, taskData, trial, file_name_suffix)
%AL_CONFETTILOOP This function runs the cannon-task trials for the common confetti-cannon version
%
%   Input
%       taskParam: Task-parameter-object instance
%       condition: Condition type
%       taskData: Task-data-object instance
%       trial: Number of trials
%       file_name_suffix: Suffix of saved files
%
%   Output
%       taskData: Task-data-object instance


% Check if file name suffix is provided
if ~exist('file_name_suffix', 'var') || isempty(file_name_suffix)
    file_name_suffix = '';
end

% Save name
if isequal(taskParam.gParam.saveName, 'vwm')
    taskData.savename = sprintf('confetti_vwm_dm_%s_tm_%s_var_%s_id_%s', taskParam.trialflow.distMean, taskParam.trialflow.currentTickmarks, taskParam.trialflow.variability, taskParam.subject.ID);
elseif isequal(taskParam.gParam.saveName, 'asymmetric')
    concentration = unique(taskData.concentration);
    taskData.savename = sprintf('confetti_asymrew_%s_g%d_conc%d_%s', taskParam.trialflow.exp, taskParam.subject.group, concentration, taskParam.subject.ID);
else
    concentration = unique(taskData.concentration);
    taskData.savename = sprintf('commonConfetti_%s_g%d_conc%d_%s%s', taskParam.trialflow.exp, taskParam.subject.group, concentration, taskParam.subject.ID, file_name_suffix);
end

% Wait until keys released
KbReleaseWait();

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% Initialize and start eye-tracker
if taskParam.gParam.eyeTracker
    taskParam.eyeTracker = taskParam.eyeTracker.initializeEyeLink(taskParam, file_name_suffix);
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

% Store commit hash
taskData.commitHash = taskParam.gParam.commitHash;

if taskParam.gParam.eyeTracker && taskParam.gParam.onlineSaccades
    eyeused = Eyelink('EyeAvailable');
end

% Cycle over trials
% -----------------

for i = 1:trial

    % Presenting trial number at the bottom of the eyetracker display - optional
    if taskParam.gParam.eyeTracker
        if isequal(taskParam.gParam.trackerVersion, 'eyelink')
            Eyelink('command', 'record_status_message "TRIAL %d/%d"', i, trial);
            Eyelink('message', 'TRIALID %d', i);
        elseif isequal(taskParam.gParam.trackerVersion, 'SMI')
            taskParam.eyeTracker.el.sendMessage(sprintf('TRIALID %d', i));
        end
    end

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

    if isequal(taskParam.trialflow.exp, 'exp') || isequal(taskParam.trialflow.exp, 'practHid') || isequal(taskParam.trialflow.exp, 'passive')

        % Take jitter into account and get timestamps for initiation RT
        taskData.actJitterOnset(i) = rand * taskParam.timingParam.jitterITI;
        taskData.actJitterFixCrossOutcome(i) = rand * taskParam.timingParam.jitterFixCrossOutcome;
        taskData.actJitterOutcome(i) = rand * taskParam.timingParam.jitterOutcome;
        taskData.actJitterFixCrossShield(i) = rand * taskParam.timingParam.jitterFixCrossShield;
        taskData.actJitterShield(i) = rand * taskParam.timingParam.jitterShield;

    else 
        
         % Take jitter into account and get timestamps for initiation RT
        taskData.actJitterOnset(i) = rand * taskParam.timingParam.jitterITIPract;
        taskData.actJitterFixCrossOutcome(i) = rand * taskParam.timingParam.jitterFixCrossOutcomePract;
        taskData.actJitterOutcome(i) = rand * taskParam.timingParam.jitterOutcomePract;
        taskData.actJitterFixCrossShield(i) = rand * taskParam.timingParam.jitterFixCrossShieldPract;
        taskData.actJitterShield(i) = rand * taskParam.timingParam.jitterShieldPract;

    end

    % Onset jitter
    % ------------

    WaitSecs(taskData.actJitterOnset(i));

    % Print out jitter duration, if desired
    if taskParam.gParam.printTiming
        fprintf('\nTrial %.0f:\nJitter duration: %.5f\n', i, GetSecs() - jitTest)
    end

    % Baseline period
    % ---------------
    al_fixationPhase(taskParam)
    Screen('DrawingFinished', taskParam.display.window.onScreen);

    % Timestamp prediction
    taskData.timestampBaseline(i) = GetSecs() - taskParam.timingParam.ref;
    timestamp = GetSecs() + 0.001;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);
    WaitSecs(taskParam.timingParam.baselineFixLength);

    % Display timing info in console
    if taskParam.gParam.printTiming
        baselineTiming = GetSecs() - taskParam.timingParam.ref;
        fprintf('Baseline duration: %.5f\n', baselineTiming - taskData.timestampBaseline(i) )
    end

    % Send trial-onset trigger
    taskData.triggers(i,1) = al_sendTrigger(taskParam, taskData, condition, i, 'trialOnset');
    taskData.timestampOnset(i) = GetSecs() - taskParam.timingParam.ref;

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
    taskData.timestampPrediction(i) = GetSecs() - taskParam.timingParam.ref;

    % Display RT and initiation RT in console
    if taskParam.gParam.printTiming
        fprintf('Initiation RT: %.5f\n', taskData.initiationRTs(i))
        fprintf('RT: %.5f\n', taskData.RT(i))
    end

    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs();

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

        al_fixationPhase(taskParam)
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
            fixCrossTiming = GetSecs() - taskParam.timingParam.ref;
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
            taskData.timestampReward(i) = GetSecs() - taskParam.timingParam.ref;
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
        
        % Presentation duration depends on trial flow
        if isequal(taskParam.trialflow.exp, 'exp') || isequal(taskParam.trialflow.exp, 'practHid')
            fixCrossOutcome = taskParam.timingParam.fixCrossOutcome;
        else
            fixCrossOutcome = taskParam.timingParam.fixCrossOutcomePract;
        end
        timestamp = timestamp + fixCrossOutcome + taskData.actJitterFixCrossOutcome(i);
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Send outcome trigger
        taskData.triggers(i,5) = al_sendTrigger(taskParam, taskData, condition, i, 'outcome');
        taskData.timestampOutcome(i) = GetSecs() - taskParam.timingParam.ref;

        % Display timing info in console
        if taskParam.gParam.printTiming
            fprintf('Fixation-cross 1 duration: %.5f\n', taskData.timestampOutcome(i) - taskData.timestampFixCross1(i))
        end
    end

    % Fixation cross (animated version) or shield (static version)
    % ------------------------------------------------------------
    if isequal(taskParam.trialflow.shot, 'static')

        % Tell PTB that everything has been drawn and flip screen
        al_fixationPhase(taskParam)
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        % timestamp = timestamp + taskParam.timingParam.outcomeLength;
        timestamp = timestamp + taskParam.timingParam.outcomeLength + taskData.actJitterOutcome(i);
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Send fixation cross 2 trigger
        taskData.triggers(i,6) = al_sendTrigger(taskParam, taskData, condition, i, 'fix');
        taskData.timestampFixCross2(i) = GetSecs() - taskParam.timingParam.ref;

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
    timestamp = timestamp + taskParam.timingParam.fixCrossShield + taskData.actJitterFixCrossShield(i);
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Send shield trigger
    taskData.triggers(i,7) = al_sendTrigger(taskParam, taskData, condition, i, 'shield');
    taskData.timestampShield(i) = GetSecs() - taskParam.timingParam.ref;

    % Display timing info in console
    if taskParam.gParam.printTiming && isequal(taskParam.trialflow.shot, 'static')
        fprintf('Fixation-cross 2 duration: %.5f\n', taskData.timestampShield(i) - taskData.timestampFixCross2(i))
    end

    if taskParam.gParam.eyeTracker && taskParam.gParam.onlineSaccades
        taskData.sacc(i) = taskParam.eyeTracker.checkSaccade(eyeused, taskParam.display.zero);
    end

    % Fixation cross (static version)
    % -------------------------------
    if isequal(taskParam.trialflow.shot, 'static')

        % Tell PTB that everything has been drawn and flip screen
        al_fixationPhase(taskParam, [222,222,222])
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        timestamp = timestamp + taskParam.timingParam.shieldLength + taskData.actJitterShield(i);
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Send fixation cross 3 trigger
        taskData.triggers(i,8) = al_sendTrigger(taskParam, taskData, condition, i, 'fix');
        taskData.timestampFixCross3(i) = GetSecs() - taskParam.timingParam.ref;

        % Display timing info in console
        if taskParam.gParam.printTiming
            fprintf('Shield duration: %.5f\n', taskData.timestampFixCross3(i) - taskData.timestampShield(i))
        end
    end

    % Fixed inter-trial interval
    WaitSecs(taskParam.timingParam.fixedITI);

    % Offset timestamp
    taskData.timestampOffset(i) = GetSecs() - taskParam.timingParam.ref;
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

    if taskParam.gParam.eyeTracker && isequal(taskParam.trialflow.saveEtData, 'true')
        et_path = pwd;

        if isequal(taskParam.gParam.trackerVersion, 'eyelink')
            et_file_name=[taskParam.eyeTracker.et_file_name, '.edf'];
            al_saveEyelinkData(et_path, et_file_name)
            Eyelink('StopRecording');

        elseif isequal(taskParam.gParam.trackerVersion, 'SMI')
            et_file_name=[taskParam.eyeTracker.et_file_name];
            al_saveSMIData(taskParam.eyeTracker.el, et_path, et_file_name)
            taskParam.eyeTracker.el.stopRecording();
            
        end
        
    end

    % Save behavioral data
    % --------------------

    al_saveData(taskData)

    % Give feedback
    % -------------

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
        txt = 'Block geschafft!';
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

    if taskParam.gParam.eyeTracker && taskParam.gParam.onlineSaccades
        feedback = true;
        header = 'Information zu Ihren Augenbewegungen';
        txt = sprintf('In diesem Block haben Sie %d Mal weggeschaut.', sum(taskData.sacc));
        al_bigScreen(taskParam, header, txt, feedback);
    end

    % Wait until keys released
    KbReleaseWait();

end
end