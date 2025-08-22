function testPassed = al_sequentialCannonCondition(taskParam, taskData, nTrials, file_name_suffix, withSlider, withFeedback)
% AL_SEQUENTIALCANNONCONDITION This function implements the practice session in which
% participants control the cannon to indicate their belief about the aim
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       nTrials: Number of trials
%       file_name_suffix: File ending for different blocks
%       withSlider: Optional slider for subjective rating (default = false)
%       withFeedback: Optional text feedback (default = true)
%
%   Output
%       testPassed: Whether test was passed or not


% Check if file name suffix is provided
if ~exist('file_name_suffix', 'var') || isempty(file_name_suffix)
    file_name_suffix = '';
end

% Check if slider option is provided
if ~exist('withSlider', 'var') || isempty(withSlider)
    withSlider = false;
end

% Check if feedback option is provided
if ~exist('withFeedback', 'var') || isempty(withFeedback)
    withFeedback = true;
end

% Wait until keys released
KbReleaseWait();

% Extract task type (we have one version for commonConfetti and one for neverWrong)
condition = taskParam.trialflow.exp;

% Check if we're in neverWrong version
isNeverWrong = startsWith(condition, 'neverWrong');

% Save name
concentration = unique(taskData.concentration);
if isNeverWrong == false
    taskData.savename = sprintf('commonConfetti_%s_g%d_conc%d_%s%s', taskParam.trialflow.exp, taskParam.subject.group, concentration, taskParam.subject.ID, file_name_suffix);
else
    taskData.savename = sprintf('%s_g%d_conc%d_%s%s', taskParam.trialflow.exp, taskParam.subject.group, concentration, taskParam.subject.ID, file_name_suffix);
end

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% Use correct trialflow settings
taskParam.trialflow.cannon = 'hide cannon';
taskParam.trialflow.confetti = 'none';
taskParam.trialflow.currentTickmarks = 'cannonPractice';

% Initialize variables for cannon test
trialsAfterPred = 0; % counting trials after prediction
testPassed = 0; % test passed variable

% In neverWrong, subject predicts next outcome, otherwise reports mean of
% the cannon
if isNeverWrong
    probeTrialPoint = taskParam.gParam.cannonPractNumOutcomes+1;
else
    probeTrialPoint = taskParam.gParam.cannonPractNumOutcomes;
end

% Cycle over trials
% -----------------

for i = 1:nTrials

    % Update trials after prediction
    trialsAfterPred = trialsAfterPred + 1;

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
    taskData.passiveViewing(i) = taskParam.gParam.passiveViewing;

    % Baseline period
    % ---------------
    al_fixationPhase(taskParam)
    Screen('DrawingFinished', taskParam.display.window.onScreen);

    % Timestamp baseline
    baselineTiming = GetSecs() - taskParam.timingParam.ref;
    timestamp = GetSecs() + 0.001;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);
    WaitSecs(taskParam.timingParam.baselineFixLength);

    % Display timing info in console
    if taskParam.gParam.printTiming
        fixCrossTiming = GetSecs() - taskParam.timingParam.ref;
        fprintf('\nTrial %.0f:\nBaseline/outcome duration: %.5f\n', i, fixCrossTiming - baselineTiming)
    end

    % Check if we still present the series of outcomes before estimation
    isFinalTrial = (trialsAfterPred == taskParam.gParam.cannonPractNumOutcomes + 1);

    % Present series of outcomes
    if ~(isFinalTrial && isNeverWrong)

        % Draw circle and confetti cloud
        al_drawCircle(taskParam)
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawFixPoint(taskParam)

        % Show sequence of outcomes
        al_showTickMarkSeries(taskData, taskParam, i);
        taskParam = al_confettiOutcome(taskParam, taskData, i);

        % Tell PTB that everything has been drawn and flip screen
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        timestamp = GetSecs() + 0.001;
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Display timing info in console
        if taskParam.gParam.printTiming
            fixCrossTiming = GetSecs() - taskParam.timingParam.ref;
            fprintf('Fixation-cross duration: %.5f\n', fixCrossTiming - baselineTiming)
        end

        WaitSecs(taskParam.timingParam.outcomeLength);
    end

    % When pre-defined number of trials has been completed,
    % ask participant to indicate cannon aim/predict outcome
    if trialsAfterPred == probeTrialPoint

        % Fixation cross
        % --------------

        al_fixationPhase(taskParam)
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        Screen('Flip', taskParam.display.window.onScreen, timestamp);
        WaitSecs(taskParam.timingParam.fixCrossOutcomePract);

        % Timestamp prediction phase onset for RT
        initRT_Timestamp = GetSecs();

        % Reset mouse to screen center
        SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen)

        % Participant indicates prediction
        [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp);

        % Prediction error & estimation error
        taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
        taskData.estErr(i) = al_diff(taskData.distMean(i), taskData.pred(i));

        % Update trials after prediction variable
        trialsAfterPred = 0;

        if withFeedback

            % Provide feedback about estimate
            % -------------------------------

            % Show circle
            al_drawCircle(taskParam)

            % Show estimate and compare to actual cannon
            alpha = 0.4;
            sampleMean = rad2deg(circ_mean(deg2rad(taskData.outcome(i-(taskParam.gParam.cannonPractNumOutcomes-1):i))));

            % Show actual cannon position
            al_drawCannon(taskParam, taskData.pred(i), alpha, [1 1 1])
            al_aim(taskParam, taskData.pred(i))

            % Show estimated cannon position
            al_drawCannon(taskParam, sampleMean)
            al_aim(taskParam, sampleMean)

            % Optional feedback for common confetti practice
            taskData.estErr(i) = al_diff(sampleMean, taskData.pred(i));
            if abs(taskData.estErr(i)) >= taskParam.gParam.practiceTrialCriterionEstErr
                if taskParam.gParam.customInstructions
                    cannonText = taskParam.instructionText.cannonErrorFeedbackText;
                else
                    cannonText = 'Leider daneben!';
                end
            elseif abs(taskData.estErr(i)) < taskParam.gParam.practiceTrialCriterionEstErr
                if taskParam.gParam.customInstructions
                    cannonText = taskParam.instructionText.cannonCorrectFeedbackText;
                else
                    cannonText = 'Super! Konfetti-Kanone sehr gut eingeschätzt!';
                end
                testPassed = testPassed + 1;
            end

            % Cannon feedback
            if taskParam.gParam.customInstructions
                cannonText = strcat(cannonText, taskParam.instructionText.cannonFeedbackText);
            else
                cannonText = strcat(cannonText, '\n\nHier können Sie Ihre Angabe und die echte Konfetti-Kanone vergleichen.');
            end

            DrawFormattedText(taskParam.display.window.onScreen,cannonText, 'center', taskParam.display.screensize(4)*0.05, [255 255 255], taskParam.strings.sentenceLength, [], [], taskParam.strings.vSpacing);
            DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter, 'center', taskParam.display.screensize(4)*0.9);

            % Extract current time and determine when screen should be flipped
            % for accurate timing
            timestamp = GetSecs() + 0.001;
            Screen('Flip', taskParam.display.window.onScreen, timestamp);

            % Terminate when subject presses enter
            while 1

                [keyIsDown, ~, keyCode] = KbCheck( taskParam.keys.kbDev );
                if keyIsDown
                    if keyCode(taskParam.keys.enter)
                        break
                    elseif keyCode(taskParam.keys.esc)
                        ListenChar();
                        ShowCursor;
                        Screen('CloseAll');
                        error('User pressed Escape to finish task')
                    end
                elseif taskParam.unitTest.run
                    WaitSecs(1);
                    break
                end
            end
        else

            % Draw circle and confetti cloud
            al_drawCircle(taskParam)
            Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
            al_drawFixPoint(taskParam)
            timestamp = GetSecs() + 0.001;
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen, timestamp);

            % Outcome
            outcomeTiming = GetSecs() - taskParam.timingParam.ref;
            al_drawCircle(taskParam)
            Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
            al_drawFixPoint(taskParam)
            taskParam = al_confettiOutcome(taskParam, taskData, i);
            al_tickMark(taskParam, taskData.pred(i), 'pred');
            timestamp = timestamp + taskParam.timingParam.fixCrossOutcome;
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen, timestamp);

            % Display timing info in console
            if taskParam.gParam.printTiming
                fixCrossTiming1 = GetSecs() - taskParam.timingParam.ref;
                fprintf('Fixation-cross duration: %.5f\n', fixCrossTiming1 - outcomeTiming)
            end

            % Fixation cross
            al_drawCircle(taskParam)
            Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
            al_drawFixPoint(taskParam)
            timestamp = timestamp + taskParam.timingParam.neverWrongOutcome;
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen, timestamp);

            % Display timing info in console
            if taskParam.gParam.printTiming
                fixCrossTiming2 = GetSecs() - taskParam.timingParam.ref;
                fprintf('Outcome duration: %.5f\n', fixCrossTiming2 - fixCrossTiming1)
            end
        end

        % Optional slider rating
        % ----------------------
        if withSlider
            KbReleaseWait;
            questionTxt = 'How likely was the confetti shot?';
            scaleTxt = 'Likelihood rating:';
            al_stressSlider(taskParam, questionTxt, scaleTxt);
            KbReleaseWait;
        end
    end
end

% Save behavioral data
% --------------------

al_saveData(taskData)

end