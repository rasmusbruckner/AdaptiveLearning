function testPassed = al_cannonPractice(taskParam, taskData, nTrials, file_name_suffix)
% AL_CANNONPRACTICE This function implements the practice session in which
% participants control the cannon to indicate their belief about the aim
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       nTrials: Number of trials
%       file_name_suffix: File ending for different blocks
%
%   Output
%       testPassed: Whether test was passed or not


% Check if file name suffix is provided
if ~exist('file_name_suffix', 'var') || isempty(file_name_suffix)
    file_name_suffix = '';
end

% Save name
concentration = unique(taskData.concentration);
taskData.savename = sprintf('commonConfetti_%s_g%d_conc%d_%s%s', taskParam.trialflow.exp, taskParam.subject.group, concentration, taskParam.subject.ID, file_name_suffix);

% Wait until keys released
KbReleaseWait();

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% Use correct condition for mouse loop
condition = "cannonPract1";

% Use correct trialflow settings
taskParam.trialflow.cannon = 'hide cannon';
taskParam.trialflow.confetti = 'none';
taskParam.trialflow.currentTickmarks = 'cannonPractice';

% Initialize variables for cannon test
trialsAfterPred = 0; % counting trials after prediction
testPassed = 0; % test passed variable

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

    % Take jitter into account and get timestamps for initiation RT
    taskData.actJitterOnset(i) = rand * taskParam.timingParam.jitterITIPract;
    taskData.actJitterFixCrossOutcome(i) = rand * taskParam.timingParam.jitterFixCrossOutcomePract;
    taskData.actJitterOutcome(i) = rand * taskParam.timingParam.jitterOutcomePract;
    taskData.actJitterFixCrossShield(i) = rand * taskParam.timingParam.jitterFixCrossShieldPract;
    taskData.actJitterShield(i) = rand * taskParam.timingParam.jitterShield;

    % Onset jitter
    % ------------

    WaitSecs(taskData.actJitterOnset(i));

    % Baseline period
    % ---------------
    al_fixationPhase(taskParam)
    Screen('DrawingFinished', taskParam.display.window.onScreen);

    timestamp = GetSecs() + 0.001;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);
    WaitSecs(taskParam.timingParam.baselineFixLength);

    % Fixation cross
    % --------------

    al_fixationPhase(taskParam)
    timestamp = GetSecs() + 0.001;
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Outcome
    % -------

    % Draw circle and confetti cloud
    al_drawCircle(taskParam)
    Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    al_drawFixPoint(taskParam)

    % Ensure that last tick marks are shown
    al_showTickMarkSeries(taskData, taskParam, i)

    % Also present the current outcome
    taskParam = al_confettiOutcome(taskParam, taskData, i);

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = GetSecs() + 0.001;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);
    WaitSecs(taskParam.timingParam.outcomeLength);

    % When pre-defined number of trials has been completed,
    % ask participant to indicate cannon aim
    if trialsAfterPred == taskParam.gParam.cannonPractNumOutcomes

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

        % Provide feedback about estimate
        % -------------------------------

        % Show circle
        al_drawCircle(taskParam)

        % Show estimate and compare to actual cannon
        alpha = 0.4;
        sampleMean = rad2deg(circ_mean(deg2rad(taskData.outcome(i-(taskParam.gParam.cannonPractNumOutcomes-1):i)))); 
        al_drawCannon(taskParam, taskData.pred(i), alpha, [1 1 1])
        al_aim(taskParam, taskData.pred(i))
        al_drawCannon(taskParam, sampleMean)
        al_aim(taskParam, sampleMean)

        % Compute estimation error and give feedback
        taskData.estErr(i) = al_diff(sampleMean, taskData.pred(i));
        if abs(taskData.estErr(i)) >= taskParam.gParam.practiceTrialCriterionEstErr
            cannonText = 'Leider daneben!';
        elseif abs(taskData.estErr(i)) < taskParam.gParam.practiceTrialCriterionEstErr
            cannonText = 'Super! Konfetti-Kanone sehr gut eingeschätzt!';
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
        Screen('Flip', taskParam.display.window.onScreen);

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
    end
end

% Save behavioral data
% --------------------

al_saveData(taskData)

end

