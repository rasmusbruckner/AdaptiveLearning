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

    % Timestamp for measuring jitter duration for validation purposes
    jitTest = GetSecs();

    % Take jitter into account and get timestamps for initiation RT
    taskData.actJitterOnset(i) = rand * taskParam.timingParam.jitterITI;
    WaitSecs(taskData.actJitterOnset(i));
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
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp);

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
    % taskData.cannonDev(i) = al_diff(taskData.distMean(i), taskData.pred(i));

    % Prediction error & estimation error
    taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
    taskData.estErr(i) = al_diff(taskData.distMean(i), taskData.pred(i));
    % todo: compare to memory error in other versions

    % Record hit
    if abs(taskData.predErr(i)) <= taskData.allShieldSize(i)/2
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

     % Manage breaks
    taskParam = al_takeBreak(taskParam, taskData, i, trial);

end

% Give feedback and save data
% ----------------------------

% Todo: update this and potentially get rid of condition
% add _new to avoid overwriting
if ~taskParam.unitTest.run

    currPoints = sum(taskData.hit, 'omitnan');
    txt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', currPoints);
    header = 'Zwischenstand';
    feedback = true;
    al_bigScreen(taskParam, header, txt, feedback);
    
    % Save data
    %----------

    concentration = unique(taskData.concentration);
    savename = sprintf('helicopter_%s_g%d_d%d_conc%d_%s', taskParam.trialflow.exp, taskParam.subject.group, taskParam.subject.testDay, concentration, taskParam.subject.ID);

    % Ensure that files cannot be overwritten
    %% todo: common function for this
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