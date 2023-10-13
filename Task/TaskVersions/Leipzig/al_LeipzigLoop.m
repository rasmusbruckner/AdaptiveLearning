function taskData = al_LeipzigLoop(taskParam, condition, taskData, trial)
%AL_LEIPZIGLOOP This function runs the cannon-task trials for the "Leizpig" version
% which basically displays a helicopter instead of a cannon
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
%   Events (Todo: verify)
%       1: Trial Onset
%       2: Prediction            (self-paced)
%       3: Confetti animation    (1500 ms)
%       4: ITI                   (900 ms)
%       5: Jitter                (0-200 ms)
%                                ------------
%                                 2.5 s + pred (~ 2s)
%
% todo: maybe get rid of "condition" input
% todo: some comments should be added and some outdated comments should be
% deleted


% Wait until keys released
KbReleaseWait();

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% Cycle over trials
% -----------------
for i = 1:trial

    % Manage breaks
    taskParam = al_takeBreak(taskParam, taskData, i);

    % Save constant variables on each trial
    taskData.currTrial(i) = i;
    taskData.age(i) = taskParam.subject.age;
    taskData.ID{i} = taskParam.subject.ID;
    taskData.sex{i} = taskParam.subject.sex;
    taskData.date{i} = taskParam.subject.date;
    taskData.cBal(i) = taskParam.subject.cBal;
    taskData.rew(i) = taskParam.subject.rew;
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

    % Send trial-onset trigger (here only timestamp since task without EEG or pupillometry)
    taskData.timestampOnset(i,:) = GetSecs - taskParam.timingParam.ref;

    % Self-paced prediction phase
    % ---------------------------

    % Reset mouse to screen center
    SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen) % 720, 450,

    % Participant indicates prediction
    press = 0;
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp, press);

    if taskParam.gParam.printTiming
        fprintf('Initiation RT: %.5f\n', taskData.initiationRTs(i))
        fprintf('RT: %.5f\n', taskData.RT(i))
    end

    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs;

    % Outcome: Animate supply items
    %------------------------------

    % Send fixation cross 1 trigger
    % todo: this should be done in mouse loop, like I did fo keyboardLoop
    taskData.timestampPrediction(i,:) = GetSecs - taskParam.timingParam.ref;

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
        taskData.perf(i) = taskParam.gParam.rewMag;
    else
        taskData.hit(i) = 0;
        taskData.perf(i) = 0;
    end

    % Accumulated performance
    taskData.accPerf(i) = sum(taskData.perf, 'omitnan');

    % Record belief update
    if i > 1
        taskData.UP(i) = al_diff(taskData.pred(i), taskData.pred(i-1));
    end

    % Supply-item animation
    background = false; % todo: include this in trialflow
    taskData.nParticlesCaught(i) = al_supplies(taskParam, taskData, i, background, timestamp);

    % Optionally, present helicopter
    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_showHelicopter(taskParam, taskData.distMean(i))
    else
        al_drawCross(taskParam)
    end

    % Draw circle
    al_drawCircle(taskParam)

    if taskParam.gParam.printTiming
        shotTiming = GetSecs - taskParam.timingParam.ref;
        fprintf('Shot duration: %.5f\n', shotTiming - taskData.timestampPrediction(i))
    end

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.outcomeLength;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Fixation cross: ITI
    % --------------------

    % Fixed inter-trial interval
    WaitSecs(taskParam.timingParam.fixedITI);

    % Offset timestamp
    taskData.timestampOffset(i) = GetSecs - taskParam.timingParam.ref;
    if taskParam.gParam.printTiming
        fprintf('Fixation-cross duration: %.5f\n', taskData.timestampOffset(i) - shotTiming)
    end
end

% Give feedback and save data
% ----------------------------

% Todo: update this and potentially get rid of condition
if ~taskParam.unitTest

    currPoints = sum(taskData.hit, 'omitnan');
    txt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', currPoints);
    header = 'Zwischenstand';
    feedback = true;
    al_bigScreen(taskParam, header, txt, feedback);

    if ~isequal(condition,'practice')

        % Save data
        %----------

        % todo: do we want to save practice?
        concentration = unique(taskData.concentration);
        savename = sprintf('helicopter_g%d_d%d_conc%d_%s', taskParam.subject.group, taskParam.subject.testDay, concentration, taskParam.subject.ID);
        save(savename, 'taskData')

        % Wait until keys released
        KbReleaseWait();
    end
end
end