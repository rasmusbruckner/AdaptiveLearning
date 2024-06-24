function taskData = al_MRILoop(taskParam, condition, taskData, trial)
%AL_MRILoop This function runs the cannon-task trials for the fMRI version
% with shocks and integrated webcam
%
%   The main difference to the common version is that the screen is updated
%   continuously to ensure that shocks are uniformly distributed on a trial
%   and that the webcam is updated continuously
%
%   Input
%       taskParam: Task-parameter-object instance
%       condtion: Condition type
%       taskData: Task-data-object instance
%       trial: Number of trials
%
%   Output
%       taskData: Task-data-object instance

% Todo: add shock function (quite easy but need shock machine settings first)
% add webcam code (also straightforward since now continuously updated)
% for both cases: don't forget to add functions to al_mouseLoop to ensure
% that shocks/video are compatible with prediction phase
% Todo: If we use this function, take scanner part out of common confetti
% loop
% todo: validate timing, especially whether time logging only takes place
% the first or last time a stimulus is presented (and that logging doesn't
% constantly take place)

% Wait until keys released
KbReleaseWait();

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

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

% Cycle over trials
% -----------------

for i = 1:trial

    % Define trial-onset clock for events before the prediction
    trialOnsetClock = GetSecs();

    % Presenting trial number at the bottom of the eyetracker display
    if taskParam.gParam.eyeTracker && isequal(taskParam.trialflow.exp, 'exp')
        Eyelink('command', 'record_status_message "TRIAL %d/%d"', i, trial);
        Eyelink('message', 'TRIALID %d', i);
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

    % Timestamp for measuring jitter duration for validation purposes
    jitTest = GetSecs();

    % Take jitter into account and get timestamps for initiation RT
    taskData.actJitterOnset(i) = rand * taskParam.timingParam.jitterITI;
    taskData.actJitterOutcome(i) = rand * taskParam.timingParam.jitterOutcome;
    taskData.actJitterShield(i) = rand * taskParam.timingParam.jitterShield;

    % Initialize conditional statements depending on the state of the trial
    baselineStarted = false;
    mouseLoopFinished = false;
    fixationCross_1_Started = false;
    shotStarted = false;
    fixationCross_2_Started = false;
    shieldStarted = false;
    fixationCross_3_Started = false;

    % Initialize variable indicating when display should be updated
    % -------------------------------------------------------------

    % Before prediction
    timestampITIOffset = taskData.actJitterOnset(i);
    timestampBaselineOffset = timestampITIOffset + taskParam.timingParam.baselineFixLength;

    % After prediction
    timestampfixCrossOutcomeOffset = taskParam.timingParam.fixCrossOutcome + taskData.actJitterOutcome(i);
    timestampOutcomeOffset = timestampfixCrossOutcomeOffset + taskParam.timingParam.outcomeLength;
    timestampFixCrossShieldOffset = timestampOutcomeOffset + taskParam.timingParam.fixCrossShield + taskData.actJitterShield(i);
    timestampShieldOffset = timestampFixCrossShieldOffset + taskParam.timingParam.shieldLength;
    timestampFixedITIOffset = timestampShieldOffset + taskParam.timingParam.fixedITI;

    % Update display constantly
    % -------------------------

    while 1

        % Check for quit
        [ ~, ~, keyCode] = KbCheck( taskParam.keys.kbDev );
        if keyCode(taskParam.keys.esc)
            ListenChar();
            ShowCursor;
            Screen('CloseAll');
            error('User pressed Escape to finish task')
        end

        % Onset jitter
        % ------------
        if (GetSecs() - trialOnsetClock > 0) && (GetSecs() - trialOnsetClock <= timestampITIOffset) && (i > 1)

            % Show gray dot indicating blink period according to jitter
            fixationPhaseMRI(taskParam, [222,222,222])

            % Baseline period
            % ---------------
        elseif (GetSecs() - trialOnsetClock > timestampITIOffset) && (GetSecs() - trialOnsetClock <= timestampBaselineOffset)

            % Show black dot baseline period before prediction
            fixationPhaseMRI(taskParam)

            % Send trial-onset trigger
            if baselineStarted == false
                taskData.triggers(i,1) = al_sendTrigger(taskParam, taskData, condition, i, 'trialOnset');
                taskData.timestampOnset(i,:) = GetSecs - taskParam.timingParam.ref;
                baselineStarted = true;

                % Print out jitter duration, if desired
                if taskParam.gParam.printTiming
                    fprintf('\nTrial %.0f:\nJitter duration: %.5f\n', i, GetSecs() - jitTest)
                end
            end

            % Self-paced prediction phase
            % ---------------------------
        elseif mouseLoopFinished == false

            % Timestamp prediction phase onset for RT
            initRT_Timestamp = GetSecs();

            % Reset mouse to screen center
            SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen)

            % Participant indicates prediction
            [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp);
            taskData.timestampPrediction(i) = GetSecs - taskParam.timingParam.ref;

            % Start clock for timing during post-prediction part of trial
            trialPostPredClock = GetSecs();

            % Indicate that prediction phase is over; this avoids that
            % we're entering this condition again
            mouseLoopFinished = true;

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

            % Performance depends on hit vs. miss
            if taskData.hit(i) == 1
                taskData.perf(i) = taskParam.gParam.rewMag;
            else
                taskData.perf(i) = 0;
            end

            % Accumulated performance
            % taskData.accPerf(i) = nansum(taskData.perf);
            % The above is included for backward compatibility. In future, when all
            % labs have more recent Matlab versions, potentially change to:
            taskData.accPerf(i) = sum(taskData.perf, 'omitnan'); % trying this for UKE scanner

            % Display RT and initiation RT in console
            if taskParam.gParam.printTiming
                fprintf('Initiation RT: %.5f\n', taskData.initiationRTs(i))
                fprintf('RT: %.5f\n', taskData.RT(i))
            end

            % Fixation cross 1
            % ----------------
        elseif (GetSecs() - trialPostPredClock > 0) && (GetSecs() - trialPostPredClock <= timestampfixCrossOutcomeOffset)

            % Show black dot before outcome
            fixationPhaseMRI(taskParam)

            % Send fixation cross 1 trigger
            if fixationCross_1_Started == false
                taskData.triggers(i,4) = al_sendTrigger(taskParam, taskData, condition, i, 'fix');
                taskData.timestampFixCross1(i) = GetSecs() - taskParam.timingParam.ref;
                fixationCross_1_Started = true;
            end

            % Outcome
            % -------
        elseif (GetSecs() - trialPostPredClock > timestampfixCrossOutcomeOffset) && (GetSecs() - trialPostPredClock <= timestampOutcomeOffset)

            % Draw circle and confetti cloud
            al_drawCircle(taskParam)
            Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
            al_drawFixPoint(taskParam)
            al_tickMark(taskParam, taskData.pred(i), 'pred');

            % On first frame, generate new dot patterns and send trigger
            if shotStarted == false

                % Generate outcome dots once
                taskParam = al_confettiOutcome(taskParam, taskData, i);
                shotStarted = true;

                % Send outcome trigger
                taskData.triggers(i,5) = al_sendTrigger(taskParam, taskData, condition, i, 'outcome');
                taskData.timestampOutcome(i) = GetSecs - taskParam.timingParam.ref;

                % Display timing info in console
                if taskParam.gParam.printTiming
                    fprintf('Fixation-cross 1 duration: %.5f\n', taskData.timestampOutcome(i) - taskData.timestampFixCross1(i))
                end

                % ... then re-use dots for rest of the trial
            else
                regenerateParticles = false;
                al_confettiOutcome(taskParam, taskData, i, regenerateParticles);
            end

            % Tell PTB that everything has been drawn and flip screen
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen);

            % Fixation cross 2
            % ----------------
        elseif (GetSecs() - trialPostPredClock > timestampOutcomeOffset) && (GetSecs() - trialPostPredClock <= timestampFixCrossShieldOffset)

            % Show black dot before shield
            fixationPhaseMRI(taskParam)

            % Send fixation cross 2 trigger
            if fixationCross_2_Started == false

                % Trigger
                taskData.triggers(i,6) = al_sendTrigger(taskParam, taskData, condition, i, 'fix');
                taskData.timestampFixCross2(i) = GetSecs - taskParam.timingParam.ref;
                fixationCross_2_Started = true;

                % Display timing info in console
                if taskParam.gParam.printTiming
                    fprintf('Outcome duration: %.5f\n', taskData.timestampFixCross2(i) - taskData.timestampOutcome(i))
                end

            end

            % Shield
            % ------
        elseif (GetSecs() - trialPostPredClock > timestampFixCrossShieldOffset) && (GetSecs() - trialPostPredClock <= timestampShieldOffset)

            % Draw circle and confetti cloud
            al_drawCircle(taskParam)
            Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
            al_drawFixPoint(taskParam)

            % Optionally draw outcome and shield
            al_shield(taskParam, taskData.allShieldSize(i), taskData.pred(i), taskData.shieldType(i))
            regenerateParticles = false;
            al_confettiOutcome(taskParam, taskData, i, regenerateParticles);

            % Tell PTB that everything has been drawn and flip screen
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen);

            % Send shield trigger
            if shieldStarted == false

                % Trigger
                taskData.triggers(i,7) = al_sendTrigger(taskParam, taskData, condition, i, 'shield');
                taskData.timestampShield(i) = GetSecs - taskParam.timingParam.ref;
                shieldStarted = true;

                % Display timing info in console
                if taskParam.gParam.printTiming && isequal(taskParam.trialflow.shot, 'static')
                    fprintf('Fixation-cross 2 duration: %.5f\n', taskData.timestampShield(i) - taskData.timestampFixCross2(i))
                end
            end

            % Fixation cross
            % --------------
        elseif (GetSecs() - trialPostPredClock > timestampShieldOffset) && (GetSecs() - trialPostPredClock <= timestampFixedITIOffset)

            % Show black dot before outcome
            fixationPhaseMRI(taskParam, [222, 222, 222])

            % Send fixation cross 3 trigger
            if fixationCross_3_Started == false

                % Trigger
                taskData.triggers(i,8) = al_sendTrigger(taskParam, taskData, condition, i, 'fix');
                taskData.timestampFixCross3(i) = GetSecs - taskParam.timingParam.ref;
                fixationCross_3_Started = true;

                % Display timing info in console
                if taskParam.gParam.printTiming
                    fprintf('Shield duration: %.5f\n', taskData.timestampFixCross3(i) - taskData.timestampShield(i))
                end
            end

        else

            % Record fixed offset
            taskData.timestampOffset(i) = GetSecs - taskParam.timingParam.ref;

            % Display timing info in console
            if taskParam.gParam.printTiming
                fprintf('Fixation-cross 3 duration: %.5f\n', taskData.timestampOffset(i) - taskData.timestampFixCross3(i))
            end

            % Break out of while-condition and start next trial
            break
        end
    end
end

% Add stimulus values
%--------------------

taskData.rotationRad = taskParam.circle.rotationRad;

% Give feedback and save data
% ---------------------------

if ~taskParam.unitTest.run

    % currPoints = nansum(taskData.hit);
    % The above is included for backward compatibility. In future, when all
    % labs have more recent Matlab versions, potentially change to:
    currPoints = sum(taskData.hit, 'omitnan');

    txt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', currPoints);
    header = 'Zwischenstand';
    feedback = true;
    al_bigScreen(taskParam, header, txt, feedback);

    % Save data
    %----------

    concentration = unique(taskData.concentration);
    savename = sprintf('fmriConfetti_%s_g%d_conc%d_%s', taskParam.trialflow.exp, taskParam.subject.group, concentration, taskParam.subject.ID);

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

function fixationPhaseMRI(taskParam, color)
%FIXATIONPHASEMRI This function implements the fixation phase for the MRI
%version
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

% Draw circle and confetti cloud
Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
al_drawFixPoint(taskParam, color)
al_drawCircle(taskParam)

% Tell PTB that everything has been drawn and flip screen
Screen('DrawingFinished', taskParam.display.window.onScreen);
Screen('Flip', taskParam.display.window.onScreen);

end