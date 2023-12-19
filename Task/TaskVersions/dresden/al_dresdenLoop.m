function [taskData, Data] = al_dresdenLoop(taskParam, haz, concentration, condition, subject, taskData, trial)
%AL_DRESDENLOOP This function runs the cannon-task trials for the "Dresden version"
%
%   Input
%       taskParam: Task-parameter-object instance
%       haz:
%       concentration:
%       condtion: Condition type
%       subject:
%       taskData: Task-data-object instance
%       trial: Number of trials
%
%   Output
%       taskData: Task-data-object instance
%
%   Events -- Todo: UPDATE
%        1: Trial Onset
%        2: Prediction/Fixation1 (500 ms)
%        3: Outcome              (500 ms)
%        4: Fixation2            (500 ms)
%        5: Shield               (500 ms)
%        6: Fixation3            (500 ms)
%        8: Jitter:              (0-200 ms)
%

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
    taskData.age(i) = str2double(subject.age);
    taskData.ID{i} = subject.ID;
    taskData.sex{i} = subject.sex;
    taskData.date{i} = subject.date;
    taskData.cBal(i) = subject.cBal;
    taskData.rew(i) = subject.rew;
    taskData.group(i) = taskParam.subject.group;
    taskData.cond{i} = condition;

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

    % Take jitter into account and get timestamps
    taskData.actJitter(i) = rand*taskParam.timingParam.jitter;
    WaitSecs(taskData.actJitter(i));
    initRT_Timestamp = GetSecs();

    % Print out jitter duration, if desired
    if taskParam.gParam.printTiming
        fprintf('\nTrial %.0f:\nJitter duration: %.5f\n', i, GetSecs() - jitTest)
    end

    % Send trial onset trigger
    taskData.triggers(i,1) = al_sendTrigger(taskParam, taskData, condition, haz, i, 1);
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
    timestamp = GetSecs; % ist timestamp = t? 

    % Fixation cross 1  % todo: hier ist jetzt anders als bei sleep
    %-----------------

    t = GetSecs;
    tUpdated = t + 0.1;

    % Todo: check if still useful
    if ~isequal(condition, 'shield') && ~isequal(condition, 'mainPractice_1') && ~isequal(condition, 'mainPractice_2') && ~isequal(condition, 'chinesePractice_1') && ~isequal(condition, 'chinesePractice_2') && ~isequal(condition, 'chinesePractice_3')

        al_drawCross(taskParam)
        al_drawCircle(taskParam)

        Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
        Screen('Flip', taskParam.display.window.onScreen, tUpdated, 1);

        % Send fixation cross 1 trigger
        taskData.triggers(i,2) = al_sendTrigger(taskParam, taskData, condition, haz, i, 2);
        taskData.timestampPrediction(i,:) = GetSecs - taskParam.timingParam.ref;

    end

    % Outcome 1
    %-----------

    % Deviation from cannon to compute performance criterion in practice
    taskData.estErr(i) = al_diff(taskData.distMean(i), taskData.pred(i)); % changed from cannonDev to estErr

    % PredError and memory error
    taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
    if isequal(condition,'main') || isequal(condition,'mainPractice_3') || isequal(condition,'mainPractice_4') || isequal(condition, 'followCannon') || isequal(condition, 'oddball')...
            || isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'reversalPractice')
        %taskData.memErr(i) = 999;
        %taskData.memErrNorm(i) = 999;
        %taskData.memErrPlus(i) = 999;
        %taskData.memErrMin(i) = 999;
    else
        if i > 1
            taskData.diffLastOutcPred(i) = al_diff(taskData.pred(i), taskData.outcome(i-1));  % was memErr before
        end
    end

    % Record hit
    % todo: reduce when practice implemented
    if isequal(condition,'main') || isequal(condition,'mainPractice_1') || isequal(condition,'mainPractice_2') || isequal(condition,'mainPractice_3')...
            || isequal(condition,'mainPractice_4') || isequal(condition, 'oddballPractice') || isequal(condition, 'oddball') || isequal(condition,'followCannon')...
            || isequal(condition,'followCannonPractice') || isequal(condition,'reversal') || isequal(condition, 'reversalPractice') || isequal(condition, 'chinesePractice_4')...
            || isequal(condition, 'chinese') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
        if abs(taskData.predErr(i)) <= taskData.allASS(i)/2
            taskData.hit(i) = 1;
        end
    elseif isequal(condition,'followOutcome') || isequal(condition,'followOutcomePractice')
        if abs(taskData.diffLastOutcPred(i)) <= 5 %abs(taskData.memErr(i)) <= 5
            taskData.hit(i) = 1;
        end
    end

    % Record performance
    if taskData.actRew(i) == 1 && taskData.hit(i) == 1
        taskData.perf(i) = taskParam.gParam.rewMag;
    end

    % Accumulated performance
    taskData.accPerf(i) = sum(taskData.perf);

    % Record belief update
    if i > 1
        taskData.UP(i) = al_diff(taskData.pred(i), taskData.pred(i-1));
    end
    
    % XX    
    al_drawCircle(taskParam)


    %tUpdated = tUpdated + fixCrossLength;

    %al_confetti(taskParam, taskData.distMean(i), taskData.outcome(i), background, taskData.currentContext(i), taskData.latentState(i))
    % todo: check in practice
    % but definitely manage via trialflow
    waitingTime = 0.2;
    WaitSecs(waitingTime);
    if isequal(taskParam.trialflow.cannon, "show cannon") || isequal(condition, 'shield') || isequal(condition, 'mainPractice_1') || isequal(condition, 'mainPractice_2') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3') %|| isequal(taskParam.trialflow.shot, 'animate cannonball')

        background = false;
        %al_cannonball(taskParam, taskData.distMean(i), taskData.outcome(i), background, taskData.currentContext(i), taskData.latentState(i))
%        al_cannonball(taskParam, taskData.distMean(i), taskData.outcome(i), background, 1, 0, i, taskData, tUpdated)
        al_cannonball(taskParam, taskData, background, i, timestamp)

        waitingTime = 0.2;
        WaitSecs(waitingTime);

        tUpdated = tUpdated + taskParam.timingParam.fixCrossLength + waitingTime;
        % tUpdated = tUpdated + fixCrossLength;
    else
        
        al_predictionSpot(taskParam)
        al_drawOutcome(taskParam, taskData.outcome(i))

        Screen('DrawingFinished', taskParam.display.window.onScreen, 1);

        %Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6);
        tUpdated = tUpdated + taskParam.timingParam.fixCrossLength;
        Screen('Flip', taskParam.display.window.onScreen, tUpdated);

    end

    % Send outcome 1 trigger
    taskData.triggers(i,3) = al_sendTrigger(taskParam, taskData, condition, haz, i, 3);


    % Fixation cross 2
    % -----------------

    al_drawCross(taskParam)
    al_drawCircle(taskParam)

    Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
    %Screen('Flip', taskParam.gParam.window.onScreen, t + 1.1, 1);
    tUpdated = tUpdated + taskParam.timingParam.outcomeLength;
    Screen('Flip', taskParam.display.window.onScreen, tUpdated, 1);

    % Send fixation cross 2 trigger
    taskData.triggers(i,4) = al_sendTrigger(taskParam, taskData, condition, haz, i, 4);

    % Outcome 2
    %----------

    al_drawCircle(taskParam)

    al_shield(taskParam, taskData.allASS(i), taskData.pred(i), taskData.shieldType(i))

    % also trialflow
    if isequal(condition,'shield') || isequal(condition, 'mainPractice_1') || isequal(condition, 'mainPractice_2') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
        al_drawCannon(taskParam, taskData.distMean(i), taskData.latentState(i))
    else
        al_drawCross(taskParam)

    end

    %         if isequal(taskParam.trialflow.shot, 'animate cannonball')
    %             al_cannon_miss(taskParam, taskData.distMean(i), taskData.outcome(i), background, taskData.currentContext(i), taskData.latentState(i), taskData.allASS(i), taskData.pred(i), taskData.shieldType(i))
    %         end

    al_drawOutcome(taskParam, taskData.outcome(i))

    Screen('DrawingFinished', taskParam.display.window.onScreen, 1);

    tUpdated = tUpdated + taskParam.timingParam.fixCrossLength;
    Screen('Flip', taskParam.display.window.onScreen, tUpdated);

    % Send outcome 2 trigger
    taskData.triggers(i,5) = al_sendTrigger(taskParam, taskData, condition, haz, i, 5);

    %WaitSecs(.5);

    % Fixation cross 3
    %-----------------

    al_drawCross(taskParam)
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        al_drawContext(taskParam,taskData.currentContext(i))
        al_drawCross(taskParam)
    end
    Screen('DrawingFinished', taskParam.display.window.onScreen);

    %Screen('Flip', taskParam.gParam.window.onScreen, t + 2.6);
    tUpdated = tUpdated + taskParam.timingParam.outcomeLength;
    Screen('Flip', taskParam.display.window.onScreen, tUpdated);

    % Send fixation cross 3 trigger
    taskData.triggers(i,6) = al_sendTrigger(taskParam, taskData, condition, haz, i, 6);
    WaitSecs(taskParam.timingParam.fixedITI / 2);

    % Send trial summary trigger
    taskData.triggers(i,7) =  al_sendTrigger(taskParam, taskData, condition, haz, i, 16);

    %WaitSecs(.5);
    WaitSecs(taskParam.timingParam.fixedITI / 2);
    taskData.timestampOffset(i,:) = GetSecs - taskParam.timingParam.ref;

end

% Give feedback
%--------------
if ~isequal(condition,'shield') 

   % if isequal(taskParam.gParam.taskType, 'dresden')
        %[txt, header] = al_feedback(taskData, taskParam, subject, condition);
        currPoints = sum(taskData.hit, 'omitnan');
        txt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', currPoints);
        header = 'Zwischenstand';
        feedback = true;
        al_bigScreen(taskParam, header, txt, feedback);
        %end

        al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, false);
end

    %end

    %end

    % necessary?
    %KbReleaseWait();

    % Todo: Get rid of this and ensure that everything is stored in new
    % taskData class

    % Save data
    %----------

    haz = repmat(haz, length(taskData.ID),1);
    concentration = repmat(concentration, length(taskData.ID),1);
    oddballProb = repmat(taskParam.gParam.oddballProb(1), length(taskData.ID),1);
    driftConc = repmat(taskParam.gParam.driftConc(1), length(taskData.ID),1);

    % todo: use new data class to store data like in sleepLoop
    Data = struct('actJitter', taskData.actJitter, 'block', taskData.block,...
        'initiationRTs', taskData.initiationRTs, 'timestampOnset',...
        taskData.timestampOnset,'timestampPrediction',...
        taskData.timestampPrediction,'timestampOffset',...
        taskData.timestampOffset, 'allASS', taskData.allASS, 'driftConc',...
        driftConc,'oddballProb',oddballProb, ... % 'oddBall', taskData.oddBall,
        'ID', {taskData.ID}, 'age',taskData.age, 'rew', {taskData.rew},...
        'actRew', taskData.actRew,'sex', {taskData.sex},  'cBal',{taskData.cBal}, 'trial', taskData.currTrial,... % 'cond',...{taskData.cond},
        'haz', haz, 'concentration', concentration,'outcome',...
        taskData.outcome, 'distMean', taskData.distMean, 'cp',...
        taskData.cp, 'TAC',taskData.TAC, 'shieldType', taskData.shieldType,... %'savedTickmark', taskData.savedTickmark,
        'catchTrial', taskData.catchTrial, 'triggers', taskData.triggers,...
        'pred', taskData.pred,'predErr', taskData.predErr,  'cannonDev', taskData.cannonDev,...
        'UP',taskData.UP, 'hit', taskData.hit, 'perf',...
        taskData.perf, 'accPerf',taskData.accPerf,...
        'RT', taskData.RT, 'Date', {taskData.date},...
        'taskParam', taskParam); %'contextTypes', taskData.contextTypes,... 'memErr',...
    %taskData.memErr,


    %OtherData = struct('criticalTrial', taskData.critical_trial, 'initialTendency',...
    %   taskData.initialTendency, 'reversal', taskData.reversal, 'currentContext', taskData.currentContext, 'latentState', taskData.latentState);
    %Data = catstruct(Data, OtherData);

    Data = catstruct(subject, Data);


    % A lot of this can be delted but integrate relevant info from
    % trialflow or gParam, e.g. for integration with ARC later on
    if taskParam.gParam.askSubjInfo && ~taskParam.unitTest && ~isequal(condition, 'shield') && ~isequal(condition, 'mainPractice_1') && ~isequal(condition, 'mainPractice_2')...
            && ~isequal(condition, 'mainPractice_3') && ~isequal(condition, 'mainPractice_4') && ~isequal(condition, 'onlinePractice') && ~isequal(condition, 'chinesePractice_1')...
            && ~isequal(condition, 'chinesePractice_2') && ~isequal(condition, 'chinesePractice_3') && ~isequal(condition, 'chinesePractice_4') && ~isequal(condition, 'ARC_controlPractice')...
            && ~isequal(condition, 'reversalPractice') && ~isequal(condition, 'reversalPracticeNoise') && ~isequal(condition, 'reversalPracticeNoiseInv') && ~isequal(condition, 'reversalPracticeNoiseInv2')

        
        if isequal(taskParam.gParam.taskType, 'ARC') && isequal(condition,'main')
            if taskParam.gParam.showTickmark
                savename = sprintf('cannon_ARC_g%s_%s_TM_c%.0f',subject.group, subject.ID, unique(concentration));
            elseif ~taskParam.gParam.showTickmark
                savename = sprintf('cannon_ARC_g%s_%s_NTM_c%.0f',subject.group, subject.ID, unique(concentration));
            end

        elseif isequal(taskParam.gParam.taskType, 'ARC') && isequal(condition,'ARC_controlSpeed')
            savename = sprintf('cannon_ARC_g%s_%s_ControlSpeed%.0f',subject.group, subject.ID, subject.testDay);
        elseif isequal(taskParam.gParam.taskType, 'ARC') && isequal(condition,'ARC_controlAccuracy')
            savename = sprintf('cannon_ARC_g%s_%s_ControlAccuracy%.0f', subject.group, subject.ID, subject.testDay);
        elseif isequal(taskParam.gParam.taskType, 'dresden')
            if subject.rew == 1
                rewName = 'G';
            elseif subject.rew == 2
                rewName = 'S';
            end
            savename = sprintf('Cannon_%s_%s_%s', rewName, subject.ID, condition);
        elseif isequal(taskParam.gParam.taskType, 'oddball')

            if subject.rew == 1
                rewName = 'B';
            elseif subject.rew == 2
                rewName = 'G';
            end

            savename = sprintf('Drugstudy_%s_%s_session%s_%s', rewName, subject.ID, subject.session, condition);

        end


        save(savename, 'Data')

    end

    KbReleaseWait();

end
