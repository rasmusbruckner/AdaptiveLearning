function taskData = al_sleepLoop(taskParam, taskData, trial, disableResponseThreshold, buttonPractice)
%AL_SLEEPLOOP This function runs the cannon-task trials for the sleep and Magedeburg-fMRI version
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       trial: Number of trials
%       disableResponseThreshold: Optionally activate response time
%                                   limit (if additionally specified in trialflow)
%       buttonPractice: Optional button practice with scanner settings but
%       no initial trigger
%
%   Output
%       taskData: Task-data-object instance

% Check for optional response-threshold input:
% By default, threshold not active, independent of trialflow
% That way, instructions are without time limit
if ~exist('disableResponseThreshold', 'var') || isempty(disableResponseThreshold)
    disableResponseThreshold = true;
end

% Check for optional button-practice input
if ~exist('buttonPractice', 'var') || isempty(buttonPractice)
    buttonPractice = false;
end

% Wait until keys released
KbReleaseWait();

% Wait for scanner trigger
if taskParam.gParam.scanner && buttonPractice == false

    % Display that we're waiting for scanner
    al_waitForScanner(taskParam, 'Messung startet in wenigen Sekunden...')
    
    fprintf('Waiting for trigger\n')
   
    % Deal with buttons
    DisableKeysForKbCheck([]);
    RestrictKeysForKbCheck(KbName('t'));
    
    % Wait for MR trigger
    keyIsDown = 0;
    while keyIsDown == 0
        [keyIsDown, t_Vol, ~] = KbCheck;
    end
    fprintf("Triggered!\n")

    % Reference time stamp right after trigger
    taskParam.timingParam.ref = t_Vol; 

     % Disable trigger key again
    DisableKeysForKbCheck([]);
    RestrictKeysForKbCheck([]);

else

    % Reference time stamp at block start
    taskParam.timingParam.ref = GetSecs; 

end

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
    taskData.cond{i} = taskParam.trialflow.push;

    % Timestamp for measuring jitter duration for validation purposes
    jitTest = GetSecs();

    % Take jitter into account and get timestamps for initiation RT
    taskData.actJitter(i) = rand * taskParam.timingParam.jitterITI;
    WaitSecs(taskData.actJitter(i));
    initRT_Timestamp = GetSecs();

    % Print out jitter duration, if desired
    if taskParam.gParam.printTiming
        fprintf('\nTrial %.0f:\nJitter 1 duration: %.5f\n', i, GetSecs() - jitTest)
    end

    % Send trial-onset trigger (here only timestamp since task without EEG or pupillometry)
    taskData.timestampOnset(i) = GetSecs - taskParam.timingParam.ref;

    % Self-paced prediction phase
    % ---------------------------

    [taskData, taskParam] = al_keyboardLoop(taskParam, taskData, i, initRT_Timestamp, [], [], disableResponseThreshold);
   
    if taskParam.gParam.printTiming
        fprintf('Initiation RT: %.5f\n', taskData.initiationRTs(i))
        fprintf('RT: %.5f\n', taskData.RT(i))
    end

    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs;

    % Outcome: Compute performance
    % ----------------------------

    % Deviation from cannon (estimation error) to compute performance
    % criterion in practice
    % Careful: same as est err. -- update in full version
    taskData.cannonDev(i) = al_diff(taskData.distMean(i), taskData.pred(i));

    % Prediction error & estimation error
    taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
    taskData.estErr(i) = al_diff(taskData.distMean(i), taskData.pred(i));
    %% todo: compare to memory error in other versions

    % Record hit and performance
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

    % For fMRI: Jitter before animation
    if taskParam.gParam.scanner
        
        % Fixation cross: ITI
        % --------------------
    
        % Present background, fixation cross, and circle
        Screen('FillRect', taskParam.display.window.onScreen, [0 0 0]);
        Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.backgroundTxt,[], [taskParam.display.backgroundCoords], []);
        if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
            al_drawCannon(taskParam, taskData.distMean(i))
        else
            al_drawCross(taskParam)
        end
        al_drawCircle(taskParam)
    
        % Tell PTB that everything has been drawn and flip screen
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        Screen('Flip', taskParam.display.window.onScreen, timestamp + 0.001);
        
        % Fixation-cross time stamp
        taskData.timestampFixCross2(i) = GetSecs - taskParam.timingParam.ref;
            
        % Sample fixation length
        fixCossTemp = taskParam.timingParam.fixCrossOutcome + rand * taskParam.timingParam.jitterOutcome;
        WaitSecs(fixCossTemp);
        timestamp = timestamp + fixCossTemp;
        
        % Print out length of jitter
        if taskParam.gParam.printTiming
            jitterTiming = GetSecs - taskParam.timingParam.ref;
            fprintf('Jitter 2 duration: %.5f\n', jitterTiming - taskData.timestampPrediction(i))
        end

    end

    % Outcome: Animate hit and miss
    % -----------------------------

    % Record time stamp for onset of outcome animation
    taskData.timestampOutcome(i) = GetSecs - taskParam.timingParam.ref;

    % Animate cannonball
    background = false; % todo: include this in trialflow
    al_cannonball(taskParam, taskData, background, i, timestamp)

    if taskParam.gParam.printTiming
        shotTiming = GetSecs - taskParam.timingParam.ref;
        fprintf('Shot duration: %.5f\n', shotTiming - taskData.timestampOutcome(i))  
    end
    
    % Record time stamp for onset of miss animation
    taskData.timestampShield(i) = GetSecs - taskParam.timingParam.ref;

    % Animate explosion when it is a miss
    timestamp = timestamp + taskParam.timingParam.cannonBallAnimation;
    al_cannonMiss(taskParam, taskData, i, background, timestamp)

    if taskParam.gParam.printTiming
        missTiming = GetSecs - taskParam.timingParam.ref;
        fprintf('Miss duration: %.5f\n', missTiming - shotTiming)
    end

    % Fixation cross: ITI
    % -------------------

    % Present background, fixation cross, and circle
    Screen('FillRect', taskParam.display.window.onScreen, [0 0 0]);
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.backgroundTxt,[], [taskParam.display.backgroundCoords], []);
    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        al_drawCross(taskParam)
    end
    al_drawCircle(taskParam)

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.cannonMissAnimation;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Fixation-cross time stamp
    taskData.timestampFixCross3(i) = GetSecs - taskParam.timingParam.ref;
        
    % Fixed inter-trial interval
    WaitSecs(taskParam.timingParam.fixedITI);

    % Offset timestamp
    taskData.timestampOffset(i) = GetSecs - taskParam.timingParam.ref;
    if taskParam.gParam.printTiming
        fprintf('Fixation-cross duration: %.5f\n', taskData.timestampOffset(i) - missTiming)
    end

    % Manage breaks
    taskParam = al_takeBreak(taskParam, taskData, i, trial);

    if taskParam.gParam.printTiming
        fprintf('Total trial duration: %.5f\n', GetSecs() - jitTest)
    end

end

% Give feedback and save data
% ----------------------------

if ~taskParam.unitTest && ~buttonPractice

        currPoints = sum(taskData.hit, 'omitnan');
        txt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', currPoints);
        header = 'Zwischenstand';
        feedback = true;
        al_bigScreen(taskParam, header, txt, feedback);
        
        % Save data
        % ---------

        concentration = unique(taskData.concentration);
        block = unique(taskData.block);
        if isequal(taskParam.gParam.taskType, 'sleep')
            savename = sprintf('cannon_Sleep_%s_g%d_d%d_conc%d_%s_MORPHEUS%s', taskParam.trialflow.exp, taskParam.subject.group, taskParam.subject.testDay, concentration, taskParam.trialflow.push, taskParam.subject.ID);
        else
            savename = sprintf('cannon_fMRI_%s_run%d_conc%d_%s', taskParam.trialflow.exp, block, concentration, taskParam.subject.ID);
        end

        % Ensure that files cannot be overwritten
        checkString = dir([savename '*']);
        fileNames = {checkString.name};
        if  ~isempty(fileNames)
            savename = [savename '_new'];
        end

        % Save data as struct
        taskData = saveobj(taskData);
        save(savename, 'taskData')

        % Wait until keys released
        KbReleaseWait();
end
end