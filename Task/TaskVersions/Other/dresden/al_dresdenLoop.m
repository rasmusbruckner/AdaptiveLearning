function taskData = al_dresdenLoop(taskParam, taskData, trial, fileEnding)
%AL_DRESDENLOOP This function runs the cannon-task trials for the "Dresden version"
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       trial: Number of trials
%       fileEnding: Optional condition type
%
%   Output
%       taskData: Task-data-object instance

%% Todo: time stamps currently incomplete
% add back in when working on integration test

% Check if fileEnding optional input is provided
if ~exist('fileEnding', 'var') || isempty(fileEnding)
    fileEnding = '';
end

% Wait until keys released
KbReleaseWait();

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);

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
    taskData.group(i) = taskParam.subject.group;
    taskData.cond{i} = taskParam.trialflow.condition;

    % Determine actual reward (what shield is associate with reward?)
    if taskData.rew(i) == 1 && taskData.shieldType(i) == 1
        taskData.actRew(i) = 1;
    elseif taskData.rew(i) == 1 && taskData.shieldType(i) == 0
        taskData.actRew(i) = 2;
    elseif taskData.rew(i) == 2 && taskData.shieldType(i) == 1
        taskData.actRew(i) = 2;
    elseif taskData.rew(i) == 2 && taskData.shieldType(i) == 0
        taskData.actRew(i) = 1;
    end

    % Timestamp for measuring jitter duration for validation purposes
    jitTest = GetSecs();

    % Take jitter into account and get timestamps
    taskData.actJitterOnset(i) = rand*taskParam.timingParam.jitterITI;
    WaitSecs(taskData.actJitterOnset(i));
    initRT_Timestamp = GetSecs();

    % Print out jitter duration, if desired
    if taskParam.gParam.printTiming
        fprintf('\nTrial %.0f:\nJitter duration: %.5f\n', i, GetSecs() - jitTest)
    end

    % Send trial onset trigger
    taskData.triggers(i,1) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.condition, i, 1);
    taskData.timestampOnset(i,:) = GetSecs - taskParam.timingParam.ref;

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

    % Fixation cross 1
    %-----------------

    timestamp = timestamp + 0.001;

    % Static cannon
    if ~isequal(taskParam.trialflow.shot, "animate cannonball")

        al_drawCross(taskParam)
        al_drawCircle(taskParam)
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Send fixation cross 1 trigger
        taskData.triggers(i,2) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.condition, i, 2);
        taskData.timestampPrediction(i,:) = GetSecs - taskParam.timingParam.ref;

    end

    % Outcome 1
    %-----------

    % Deviation from cannon to compute performance criterion in practice
    taskData.estErr(i) = al_diff(taskData.distMean(i), taskData.pred(i));

    % Prediction error and difference between last outcome and current
    % prediction ("memory error" befoe)
    taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
    if i > 1
        taskData.diffLastOutcPred(i) = al_diff(taskData.pred(i), taskData.outcome(i-1));
    end

    % Record hit
    if isequal(taskParam.trialflow.condition,'followOutcome') && i > 1
        if abs(taskData.diffLastOutcPred(i)) <= 5
            taskData.hit(i) = 1;
        else 
            taskData.hit(i) = 0;
        end
    else
        if abs(taskData.predErr(i)) <= taskData.allShieldSize(i)/2
            taskData.hit(i) = 1;
        else
            taskData.hit(i) = 0;
        end
    end

    % Record performance
    if taskData.actRew(i) == 1 && taskData.hit(i) == 1
        taskData.perf(i) = taskParam.gParam.rewMag;
    else
        taskData.perf(i) = 0;
    end

    % Accumulated performance
    taskData.accPerf(i) = sum(taskData.perf(1:i));

    % Record belief update
    if i > 1
        taskData.UP(i) = al_diff(taskData.pred(i), taskData.pred(i-1));
    end

    timestamp = timestamp + taskParam.timingParam.fixedITI;

    % Draw circle
    al_drawCircle(taskParam)

    % Present outcome: Depending on mode, w/ or w/o animation
    if isequal(taskParam.trialflow.shot, 'animate cannonball') && isequal(taskParam.trialflow.cannon, "show cannon")

        % With animation
        background = false;
        al_cannonball(taskParam, taskData, background, i, timestamp)

    elseif isequal(taskParam.trialflow.cannon, "hide cannon")

        % Static
        al_predictionSpot(taskParam)
        al_drawOutcome(taskParam, taskData.outcome(i))
        al_drawCross(taskParam)

        % Tell PTB that everything has been drawn and flip screen
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        timestamp = timestamp + taskParam.timingParam.fixCrossOutcome;
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

    else

        % Static
        al_predictionSpot(taskParam)
        al_drawOutcome(taskParam, taskData.outcome(i))
        al_drawCannon(taskParam, taskData.distMean(i))

        % Tell PTB that everything has been drawn and flip screen
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        timestamp = timestamp + taskParam.timingParam.fixCrossOutcome;
        Screen('Flip', taskParam.display.window.onScreen, timestamp);
    end

    % Send outcome 1 trigger
    %% Todo: haz not used in trigger system anymore
    taskData.triggers(i,3) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.condition, i, 3);

    % Fixation cross 2
    % -----------------

    al_drawCross(taskParam)
    al_drawCircle(taskParam)

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.outcomeLength;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Send fixation cross 2 trigger
    taskData.triggers(i,4) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.condition, i, 4);

    % Outcome 2 (shield)
    %-------------------

    al_drawCircle(taskParam)
    al_shield(taskParam, taskData.allShieldSize(i), taskData.pred(i), taskData.shieldType(i))

    %% Todo: check if in this version cannon was shown in shield phase
    if isequal(taskParam.trialflow.cannon, 'show cannon')
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        al_drawCross(taskParam)
    end

    al_drawOutcome(taskParam, taskData.outcome(i))

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.fixCrossShield;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Send outcome 2 trigger
    %% todo: ditch condition here and in other cases... in future versions done with trialflow.condition
    taskData.triggers(i,5) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.condition, i, 5);

    % Fixation cross 3
    %-----------------

    al_drawCross(taskParam)
    al_drawCircle(taskParam)

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.outcomeLength;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    % Send fixation cross 3 trigger
    %% todo: same here: ditch condition
    taskData.triggers(i,6) = al_sendTrigger(taskParam, taskData, taskParam.trialflow.condition, i, 6);
    WaitSecs(taskParam.timingParam.fixedITI / 2);

    % Send trial summary trigger
    %% todo: same here: ditch condition
    taskData.triggers(i,7) =  al_sendTrigger(taskParam, taskData, taskParam.trialflow.condition, i, 16);
    WaitSecs(taskParam.timingParam.fixedITI / 2);
    taskData.timestampOffset(i,:) = GetSecs - taskParam.timingParam.ref;

    % Manage breaks
    taskParam = al_takeBreak(taskParam, taskData, i, trial);

end

% Give feedback and save data
% ---------------------------

if ~taskParam.unitTest.run && (isequal(taskParam.trialflow.condition, 'main') || isequal(taskParam.trialflow.condition, 'followCannon') || isequal(taskParam.trialflow.condition, 'followOutcome'))
    % Give feedback
    % -------------

    % Adjust color word depending on reward condition
    if taskParam.subject.rew == 1
        colRewCap = 'goldenen';
    elseif taskParam.subject.rew == 2
        colRewCap = 'silbernen';
    end

    % taskParam.trialflow.condition
    % Shield name depending on condition
    if isequal(taskParam.trialflow.condition, 'main') || isequal(taskParam.trialflow.condition, 'followCannon')

        schildVsKorb = 'Schild';
        gefangenVsGesammelt = 'abgewehrt';

    elseif isequal(taskParam.trialflow.condition, 'followOutcome')

        schildVsKorb = 'Korb';
        gefangenVsGesammelt = 'aufgesammelt';

    end

    % Experimental vs. main condition
    if isequal(taskParam.trialflow.exp, 'pract')
        wouldHave = 'hätten';
    else
        wouldHave = 'haben';
    end

    % Present feedback text
    header = 'Leistung';
    rewCatches = max(taskData.accPerf)/taskParam.gParam.rewMag;
    rewTrials = sum(taskData.actRew == 1);
    maxMon = (length(find(taskData.shieldType == 1)) * taskParam.gParam.rewMag);

    % Display zero for no-catch case
    if isnan(rewCatches) && isnan(max(taskData.accPerf))
        rewCatches = 0;
        bonus = 0;
    else
        bonus = max(taskData.accPerf);
    end

    txt = sprintf('Weil Sie %.0f von %.0f Kugeln mit dem %s %s %s haben,\n\n%s Sie %.2f von maximal %.2f Euro gewonnen.', rewCatches,...
        rewTrials, colRewCap, schildVsKorb, gefangenVsGesammelt, wouldHave, bonus, maxMon);
    feedback = true;
    al_bigScreen(taskParam, header, txt, feedback);

    if taskParam.subject.rew == 1
        rewName = 'G';
    elseif taskParam.subject.rew == 2
        rewName = 'S';
    end
    savename = sprintf('Cannon_%s_%s_%s_%s%s', taskParam.trialflow.exp, rewName, taskParam.subject.ID, taskParam.trialflow.condition, fileEnding);

    % Ensure that files cannot be overwritten
    checkString = dir([savename '*']);
    fileNames = {checkString.name};
    if  ~isempty(fileNames)
        savename = [savename '_new'];
    end
    
    % Save object as structure
    taskData = saveobj(taskData);
    save(savename, 'taskData')

end

% Wait until keys released
KbReleaseWait();

end