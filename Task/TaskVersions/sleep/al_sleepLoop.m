function taskData = al_sleepLoop(taskParam, condition, taskData, trial)
%AL_SLEEPLOOP This function runs the cannon-task trials for the "sleep version"
%
%   Input
%       taskParam: Task-parameter-object instance
%       condtion: Condition type
%       taskData: Task-data-object instance
%       trial: Number of trials
%       practice: Whether or not function is used in practice phase
%
%   Output
%       taskData: Task-data-object instance
%
%   Events
%       1: Trial Onset
%       2: Prediction            (self-paced)
%       3: Cannonball animation  (500 ms)
%       4: Miss/Hit animation    (1000 ms)
%       5: ITI                   (900 ms)
%       6: Jitter                (0-200 ms)
%                                ------------
%                                 3 s + pred (~ 2s)
%
% todo: maybe get rid of "condition" input
% todo: some comments should be added and some outdated comments should be
% deleted

% Wait until keys released
KbReleaseWait();

if taskParam.gParam.scanner 
    n_Vols = 0;
    s.SkipVolumesNumber = 10; 
    s.TriggerButton = KbName('t'); % 116
    %%%%%%%%%%% Hans code
    % check only for MR trigger
    DisableKeysForKbCheck([]);
    RestrictKeysForKbCheck(s.TriggerButton);
    % Loop as long as volumes should be skipped
    %while n_Vols<s.SkipVolumesNumber
    keyIsDown = 0;
    % check for MR trigger. For example letter "t"
    while keyIsDown == 0
        [keyIsDown, t_Vol, ~] = KbCheck;
        %if n_Vols == 1
       % first_trigger = t_Vol;
        %end
    end
    n_Vols=n_Vols+1;
   % end
    %TimeStart = first_trigger;
    DisableKeysForKbCheck([]);
    RestrictKeysForKbCheck([]);

    % rasmus: das hier quasi als timestamp bei mr-onset?
    taskParam.timingParam.ref = t_Vol; %denke ich


end

%%%%%%%%%%%%%%


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
    taskData.cond{i} = taskParam.trialflow.push;

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
    taskData.timestampOnset(i) = GetSecs - taskParam.timingParam.ref;

    % Self-paced prediction phase
    % ---------------------------

    [taskData, taskParam] = al_keyboardLoop(taskParam, taskData, i, initRT_Timestamp);
   
    if taskParam.gParam.printTiming
        fprintf('Initiation RT: %.5f\n', taskData.initiationRTs(i))
        fprintf('RT: %.5f\n', taskData.RT(i))
    end

    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs;

    % Outcome: Animate cannonball
    %----------------------------

    % Deviation from cannon (estimation error) to compute performance
    % criterion in practice
    % Careful: same as est err. -- update in full version
    taskData.cannonDev(i) = al_diff(taskData.distMean(i), taskData.pred(i));

    % Prediction error & estimation error
    taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
    taskData.estErr(i) = al_diff(taskData.distMean(i), taskData.pred(i));
    % todo: compare to memory error in other versions

    % Record hit and performance
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

    % Outcome: Animate hit and miss
    % -----------------------------

    % Animate cannonball
    background = false; % todo: include this in trialflow
    al_cannonball(taskParam, taskData, background, i, timestamp)

    if taskParam.gParam.printTiming
        shotTiming = GetSecs - taskParam.timingParam.ref;
        fprintf('Shot duration: %.5f\n', shotTiming - taskData.timestampPrediction(i))
    end

    % Animate explosion when it is a miss
    timestamp = timestamp + taskParam.timingParam.cannonBallAnimation;
    al_cannonMiss(taskParam, taskData, i, background, timestamp)

    if taskParam.gParam.printTiming
        missTiming = GetSecs - taskParam.timingParam.ref;
        fprintf('Miss duration: %.5f\n', missTiming - shotTiming)
    end

    % Fixation cross: ITI
    % --------------------

    % Present background, fixation cross, and circle
    Screen('FillRect', taskParam.display.window.onScreen, [0 0 0]);
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.backgroundTxt,[], [taskParam.display.backgroundCoords], []);
    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
        % al_aim(taskParam, taskData.distMean(i))  # check if this should
        % be included at all
    else
        al_drawCross(taskParam)
    end
    al_drawCircle(taskParam)

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.cannonMissAnimation + taskParam.timingParam.outcomeLength; % hier schauen, dass outcomeLength angepasst
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Fixed inter-trial interval
    WaitSecs(taskParam.timingParam.fixedITI);

    % Offset timestamp
    taskData.timestampOffset(i) = GetSecs - taskParam.timingParam.ref;
    if taskParam.gParam.printTiming
        fprintf('Fixation-cross duration: %.5f\n', taskData.timestampOffset(i) - missTiming)
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
        % ---------

        % Todo: do we want to save practice?
        concentration = unique(taskData.concentration);
        savename = sprintf('cannon_Sleep_g%d_d%d_conc%d_%s_MORPHEUS%s', taskParam.subject.group, taskParam.subject.testDay, concentration, taskParam.trialflow.push, taskParam.subject.ID);
        save(savename, 'taskData')

        % Wait until keys released
        KbReleaseWait();
    end
end
end