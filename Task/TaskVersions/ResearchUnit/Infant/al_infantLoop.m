function taskData = al_infantLoop(taskParam, condition, concentration, trial)
%AL_INFANTLOOP This function runs the cannon-task trials for the infant version
%
%   The task updates the display continuously to ensure smooth interaction
%   with the eye-tracker
%
%   Input
%       taskParam: Task-parameter-object instance
%       condtion: Condition type
%       concentration: Noise in outcomes
%       trial: Number of trials
%
%   Output
%       taskData: Task-data-object instance

% Todo: add eye tracker and triggers

% Wait until keys released
KbReleaseWait();

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Reference time stamp
taskParam.timingParam.ref = GetSecs();

% Extract cBal
cBal = taskParam.subject.cBal;

% Trial counter
i = 0;

% Cycle over trials
% -----------------

while 1

    % Update trial counter
    i = i+1;

    % Define trial-onset clock for events before the prediction
    trialOnsetClock = GetSecs();

    % Timestamp for measuring jitter duration for validation purposes
    jitTest = GetSecs();

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

    % Take jitter into account and get timestamps for initiation RT
    taskData.actJitterOnset(i) = rand * taskParam.timingParam.jitterITI;
    taskData.actJitterOutcome(i) = rand * taskParam.timingParam.jitterOutcome;

    % Record concentration
    taskData.concentration(i) = concentration;

    % Initialize conditional statements depending on the state of the trial
    baselineStarted = false;
    duckCenterStaticStarted = false;
    duckCenterMovingStarted = false;
    fixationCross_1_Started = false;
    outcomeStaticStarted = false;
    outcomeMovementStarted = false;

    % Initialize variable indicating when display should be updated
    % -------------------------------------------------------------

    timestampITIOffset = taskData.actJitterOnset(i);
    timestampBaselineOffset = timestampITIOffset + taskParam.timingParam.baselineFixLength;
    timestampDuckStaticOffset = timestampBaselineOffset + taskParam.timingParam.staticDuck;
    timestampDuckMovementOffset = timestampDuckStaticOffset + taskParam.timingParam.movingDuck;
    timestampfixCrossOutcomeOffset = timestampDuckMovementOffset + taskParam.timingParam.fixCrossOutcome;
    timestampOutcomeStaticOffset = timestampfixCrossOutcomeOffset + taskParam.timingParam.staticOutcome;
    timestampOutcomeMovementOffset = timestampOutcomeStaticOffset + taskParam.timingParam.movingOutcome;

    % Initilalize variable controlling movement frequency
    duckLastMovement = GetSecs() - taskParam.gParam.duckMovementFrequency;

    % Generate change point
    safe = 0;
    s = 0;
    if i == 1
        haz = 1;
    else
        haz = taskParam.gParam.haz;
    end
    [taskData, ~] = taskData.generateCP(taskParam, haz, s, safe, i);

    % Habituation phase
    if i <= taskParam.gParam.practTrials

        taskData.outcome(i) = taskData.sampleOutcome(taskData.distMean(i), taskData.concentration(i));
        taskData.oddball(i) = 0;

        % Oddball phase
    else

        % Determine order of test trials
        if (cBal == 1 && mod(i, 2) == 0) || (cBal == 2 && mod(i, 2) == 1)
            taskData.outcome(i) = adjustValue(taskData.distMean(i), 'add');
            taskData.oddball(i) = 1;
        else
            taskData.outcome(i) = taskData.distMean(i);
            taskData.oddball(i) = 0;
        end
    end

    % Cycle over phases within trial
    % ------------------------------

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
        if (GetSecs() - trialOnsetClock > 0) && (GetSecs() - trialOnsetClock <= timestampITIOffset) %&& (i > 1)

            al_drawFixPoint(taskParam)
            al_drawCircle(taskParam)
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen);

            % Baseline period
            % ---------------
        elseif (GetSecs() - trialOnsetClock > timestampITIOffset) && (GetSecs() - trialOnsetClock <= timestampBaselineOffset)

            al_drawFixPoint(taskParam)
            al_drawCircle(taskParam)

            % todo should be possible without (i,:)
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

            % Todo: for test phase we will add attention getter to ensure
            % infant fixates screen again before next stimulus appears

            % Stimulus appears in screen center
            % ---------------------------------
        elseif (GetSecs() - trialOnsetClock > timestampBaselineOffset) && (GetSecs() - trialOnsetClock <= timestampDuckStaticOffset)

            % Show stimulus (for now heli, but will be duck or sth. similar)
            duckAngle = 0; % static duck
            al_showDuck(taskParam, nan, true, duckAngle)

            % Draw circle
            al_drawCircle(taskParam)

            % Tell PTB that everything has been drawn and flip screen
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen);

            % Send static-duck trigger
            if duckCenterStaticStarted == false

                taskData.timestampDuckCenterStatic(i,:) = GetSecs - taskParam.timingParam.ref;
                duckCenterStaticStarted = true;

                % Display timing info in console
                if taskParam.gParam.printTiming
                    fprintf('Baseline duration: %.5f\n',  taskData.timestampDuckCenterStatic(i,:) - taskData.timestampOnset(i,:))
                end
            end

            % Todo: add trigger once code clear

            % Onset of movement
            % -----------------
        elseif (GetSecs() - timestampDuckStaticOffset > timestampBaselineOffset) && (GetSecs() - trialOnsetClock <= timestampDuckMovementOffset)

            % Show stimulus (for now heli, but will be duck or sth. similar)
            if GetSecs() - duckLastMovement >= taskParam.gParam.duckMovementFrequency
                duckAngle = normrnd(0, taskParam.gParam.duckMovementRange, 1); % static duck
                duckLastMovement = GetSecs();
            end

            al_showDuck(taskParam, nan, true, duckAngle)

            % Draw circle
            al_drawCircle(taskParam)

            % Tell PTB that everything has been drawn and flip screen
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen);

            % Send moving-duck trigger
            if duckCenterMovingStarted == false

                taskData.timestampDuckCenterMoving(i,:) = GetSecs - taskParam.timingParam.ref;
                duckCenterMovingStarted = true;

                % Display timing info in console
                if taskParam.gParam.printTiming
                    fprintf('Static duck duration: %.5f\n',  taskData.timestampDuckCenterMoving(i,:) - taskData.timestampDuckCenterStatic(i,:))
                end
            end

            % Todo: add trigger once code clear

            % Fixation spot
            % -------------
        elseif (GetSecs() - timestampDuckMovementOffset > 0) && (GetSecs() - trialOnsetClock <= timestampfixCrossOutcomeOffset)

            duckAngle = 0;
            al_drawFixPoint(taskParam)
            al_drawCircle(taskParam)

            % Tell PTB that everything has been drawn and flip screen
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen);

            % Send fixation-cross-1 trigger
            if fixationCross_1_Started == false

                taskData.timestampFixCross1(i) = GetSecs - taskParam.timingParam.ref;
                fixationCross_1_Started = true;

                % Display timing info in console
                if taskParam.gParam.printTiming
                    fprintf('Moving duck duration: %.5f\n',  taskData.timestampFixCross1(i) - taskData.timestampDuckCenterMoving(i,:))
                end
            end

            % Todo: add trigger once code clear

            % Outcome static
            % --------------
        elseif (GetSecs() - trialOnsetClock > timestampfixCrossOutcomeOffset) && (GetSecs() - trialOnsetClock <= timestampOutcomeStaticOffset)

            al_drawCircle(taskParam)
            al_drawFixPoint(taskParam)
            al_showDuck(taskParam, taskData.outcome(i), false, duckAngle)
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen);

            % Send static-outcome trigger
            if outcomeStaticStarted == false

                taskData.timestampOutcomeStatic(i) = GetSecs - taskParam.timingParam.ref;
                outcomeStaticStarted = true;

                % Display timing info in console
                if taskParam.gParam.printTiming
                    fprintf('Fixation-cross 1 duration: %.5f\n',  taskData.timestampOutcomeStatic(i) - taskData.timestampFixCross1(i) )
                end
            end

            % Todo: add trigger once code clear

            % Outcome movement
            % --------------
        elseif (GetSecs() - trialOnsetClock > timestampOutcomeStaticOffset) && (GetSecs() - trialOnsetClock <= timestampOutcomeMovementOffset)


            al_drawFixPoint(taskParam)
            al_drawCircle(taskParam)

            if GetSecs() - duckLastMovement >= taskParam.gParam.duckMovementFrequency
                duckAngle = normrnd(0, taskParam.gParam.duckMovementRange, 1); % static duck
                duckLastMovement = GetSecs();
            end

            al_showDuck(taskParam, taskData.outcome(i), false, duckAngle)
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            Screen('Flip', taskParam.display.window.onScreen);

            % Send moving-outcome trigger
            if outcomeMovementStarted == false

                taskData.timestampOutcomeMovement(i) = GetSecs - taskParam.timingParam.ref;
                outcomeMovementStarted = true;

                % Display timing info in console
                if taskParam.gParam.printTiming
                    fprintf('Outcome static duration: %.5f\n',  taskData.timestampOutcomeMovement(i) - taskData.timestampOutcomeStatic(i) )
                end
            end
            % Todo: add trigger once code clear

        else
            % Go to next trial
            break
        end
    end

    % Stop block
    if i >= trial

        break
    end
end

% Add stimulus values
%--------------------

taskData.rotationRad = taskParam.circle.rotationRad;

% Save data
%----------

if ~taskParam.unitTest.run

    concentration = unique(taskData.concentration);
    savename = sprintf('infant_%s_g%d_conc%d_%s', taskParam.trialflow.exp, taskParam.subject.group, concentration, taskParam.subject.ID);

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

    function newValue = adjustValue(value, operation)
        % ADJUSTVALUE This function adjusts the value by adding or subtracting 180
        % operation should be 'add' or 'subtract'
        %
        %   Input
        %       value: Input value to which we add or subtract 180
        %       operation: 'add' or 'subtract'
        %
        %   Output
        %       newValue: Updated value

        if strcmp(operation, 'add')
            newValue = mod(value + 180, 360);
        elseif strcmp(operation, 'subtract')
            newValue = mod(value - 180, 360);
            if newValue < 0
                newValue = newValue + 360; % ensure the result is non-negative
            end
        else
            error('Invalid operation. Use ''add'' or ''subtract''.');
        end
    end
end
