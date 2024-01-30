function taskData = al_dresdenLoop(taskParam, condition, taskData, trial)
%AL_DRESDENLOOP This function runs the cannon-task trials for the "Dresden version"
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
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);

% Cycle over trials
% -----------------
for i = 1:trial

    % Save constant variables on each trial
    taskData.currTrial(i) = i;
    taskData.age(i) = str2double(taskParam.subject.age);
    taskData.ID{i} = taskParam.subject.ID;
    taskData.sex{i} = taskParam.subject.sex;
    taskData.date{i} = taskParam.subject.date;
    taskData.cBal(i) = taskParam.subject.cBal;
    taskData.rew(i) = taskParam.subject.rew;
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

    % Timestamp for measuring jitter duration for validation purposes
    jitTest = GetSecs();

    % Take jitter into account and get timestamps
    taskData.actJitter(i) = rand*taskParam.timingParam.jitter;
    WaitSecs(taskData.actJitter(i));
    initRT_Timestamp = GetSecs();

    % Print out jitter duration, if desired
    if taskParam.gParam.printTiming
        fprintf('\nTrial %.0f:\nJitter duration: %.5f\n', i, GetSecs() - jitTest)
    end

    % Send trial onset trigger
    taskData.triggers(i,1) = al_sendTrigger(taskParam, taskData, condition, taskParam.gParam.haz, i, 1);
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

    % Fixation cross 1  % todo: hier ist jetzt anders als bei sleep
    %-----------------

    t = GetSecs;
    tUpdated = t + 0.1;  % replace with timestamp for consistency
    %timestamp = timestamp + taskParam.timingParam.fixedITI;
    
    % Todo: check if still used
    if ~isequal(condition, 'shield') && ~isequal(condition, 'mainPractice_1') && ~isequal(condition, 'mainPractice_2')

        al_drawCross(taskParam)
        al_drawCircle(taskParam)

        Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
        %Screen('Flip', taskParam.display.window.onScreen, tUpdated, 1);
        Screen('Flip', taskParam.display.window.onScreen, timestamp, 1);

        % Send fixation cross 1 trigger
        taskData.triggers(i,2) = al_sendTrigger(taskParam, taskData, condition, taskParam.gParam.haz, i, 2);
        taskData.timestampPrediction(i,:) = GetSecs - taskParam.timingParam.ref;

    end

    % Outcome 1
    %-----------

    % Deviation from cannon to compute performance criterion in practice
    taskData.estErr(i) = al_diff(taskData.distMean(i), taskData.pred(i)); % changed from cannonDev to estErr

    % PredError and memory error
    taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
    if i > 1
        taskData.diffLastOutcPred(i) = al_diff(taskData.pred(i), taskData.outcome(i-1));  % was memErr before
    end

    % Record hit
    if isequal(condition,'followOutcome') || isequal(condition,'followOutcomePractice')
        if abs(taskData.diffLastOutcPred(i)) <= 5
            taskData.hit(i) = 1;
        end
    else
        if abs(taskData.predErr(i)) <= taskData.allASS(i)/2
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
    
    % Outcome
    %--------

    timestamp = timestamp + taskParam.timingParam.fixedITI;

    % Draw circle
    al_drawCircle(taskParam)

    % XX
    if isequal(taskParam.trialflow.cannon, "show cannon") || isequal(taskParam.trialflow.shot, 'animate cannonball')

        background = false;
        al_cannonball(taskParam, taskData, background, i, timestamp)

    else
        
        al_predictionSpot(taskParam)
        al_drawOutcome(taskParam, taskData.outcome(i))

        Screen('DrawingFinished', taskParam.display.window.onScreen, 1);

        tUpdated = tUpdated + taskParam.timingParam.fixCrossLength;
        Screen('Flip', taskParam.display.window.onScreen, tUpdated);

    end

    % Send outcome 1 trigger
    taskData.triggers(i,3) = al_sendTrigger(taskParam, taskData, condition, taskParam.gParam.haz, i, 3);

    % Fixation cross 2
    % -----------------

    al_drawCross(taskParam)
    al_drawCircle(taskParam)

    Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
    tUpdated = tUpdated + taskParam.timingParam.outcomeLength;
    Screen('Flip', taskParam.display.window.onScreen, tUpdated, 1);

    % Send fixation cross 2 trigger
    taskData.triggers(i,4) = al_sendTrigger(taskParam, taskData, condition, taskParam.gParam.haz, i, 4);

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

  
    al_drawOutcome(taskParam, taskData.outcome(i))

    Screen('DrawingFinished', taskParam.display.window.onScreen, 1);

    tUpdated = tUpdated + taskParam.timingParam.fixCrossLength;
    Screen('Flip', taskParam.display.window.onScreen, tUpdated);

    % Send outcome 2 trigger
    taskData.triggers(i,5) = al_sendTrigger(taskParam, taskData, condition, taskParam.gParam.haz, i, 5);

    % Fixation cross 3
    %-----------------

    al_drawCross(taskParam)
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        al_drawContext(taskParam,taskData.currentContext(i))
        al_drawCross(taskParam)
    end


    Screen('DrawingFinished', taskParam.display.window.onScreen);


    tUpdated = tUpdated + taskParam.timingParam.outcomeLength;
    Screen('Flip', taskParam.display.window.onScreen, tUpdated);

    % Send fixation cross 3 trigger
    taskData.triggers(i,6) = al_sendTrigger(taskParam, taskData, condition, taskParam.gParam.haz, i, 6);
    WaitSecs(taskParam.timingParam.fixedITI / 2);

    % Send trial summary trigger
    taskData.triggers(i,7) =  al_sendTrigger(taskParam, taskData, condition, taskParam.gParam.haz, i, 16);

    WaitSecs(taskParam.timingParam.fixedITI / 2);
    taskData.timestampOffset(i,:) = GetSecs - taskParam.timingParam.ref;

    % Manage breaks
    taskParam = al_takeBreak(taskParam, taskData, i, trial);

end


% Give feedback and save data
% ----------------------------

if ~taskParam.unitTest

% todo: manage practice for all!
if taskParam.subject.rew == 1
    rewName = 'G';
elseif taskParam.subject.rew == 2
    rewName = 'S';
end
savename = sprintf('Cannon_%s_%s_%s', rewName, taskParam.subject.ID, condition);


end

% % Give feedback
% %--------------
% if ~isequal(condition,'shield') 
% 
%    % if isequal(taskParam.gParam.taskType, 'dresden')
%         %[txt, header] = al_feedback(taskData, taskParam, subject, condition);
%         currPoints = sum(taskData.hit, 'omitnan');
%         txt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', currPoints);
%         header = 'Zwischenstand';
%         feedback = true;
%         al_bigScreen(taskParam, header, txt, feedback);
%         %end
% 
%         al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, false);
% end

    %end

    %end

    % necessary?
    %KbReleaseWait();

    % Todo: Get rid of this and ensure that everything is stored in new
    % taskData class

    % Save data
    %----------

   % haz = repmat(1, length(taskData.ID),1);
    %concentration = repmat(concentration, length(taskData.ID),1);
   % concentration = unique(taskData.concentration);
   % oddballProb = repmat(1, length(taskData.ID),1);%repmat(taskParam.gParam.oddballProb(1), length(taskData.ID),1);
   % driftConc = repmat(1, length(taskData.ID),1);%repmat(taskParam.gParam.driftConc(1), length(taskData.ID),1);
% 
%     % todo: use new data class to store data like in sleepLoop
%     Data = struct('actJitter', taskData.actJitter, 'block', taskData.block,...
%         'initiationRTs', taskData.initiationRTs, 'timestampOnset',...
%         taskData.timestampOnset,'timestampPrediction',...
%         taskData.timestampPrediction,'timestampOffset',...
%         taskData.timestampOffset, 'allASS', taskData.allASS, 'driftConc',...
%         driftConc,'oddballProb',oddballProb, ... % 'oddBall', taskData.oddBall,
%         'ID', {taskData.ID}, 'age',taskData.age, 'rew', {taskData.rew},...
%         'actRew', taskData.actRew,'sex', {taskData.sex},  'cBal',{taskData.cBal}, 'trial', taskData.currTrial,... % 'cond',...{taskData.cond},
%         'haz', haz, 'concentration', concentration,'outcome',...
%         taskData.outcome, 'distMean', taskData.distMean, 'cp',...
%         taskData.cp, 'TAC',taskData.TAC, 'shieldType', taskData.shieldType,... %'savedTickmark', taskData.savedTickmark,
%         'catchTrial', taskData.catchTrial, 'triggers', taskData.triggers,...
%         'pred', taskData.pred,'predErr', taskData.predErr,  'cannonDev', taskData.cannonDev,...
%         'UP',taskData.UP, 'hit', taskData.hit, 'perf',...
%         taskData.perf, 'accPerf',taskData.accPerf,...
%         'RT', taskData.RT, 'Date', {taskData.date},...
%         'taskParam', taskParam); %'contextTypes', taskData.contextTypes,... 'memErr',...
%     %taskData.memErr,


    %OtherData = struct('criticalTrial', taskData.critical_trial, 'initialTendency',...
    %   taskData.initialTendency, 'reversal', taskData.reversal, 'currentContext', taskData.currentContext, 'latentState', taskData.latentState);
    %Data = catstruct(Data, OtherData);

   % Data = catstruct(taskParam.subject, Data);


    % A lot of this can be delted but integrate relevant info from
    % trialflow or gParam, e.g. for integration with ARC later on
%     if taskParam.gParam.askSubjInfo && ~taskParam.unitTest && ~isequal(condition, 'shield') && ~isequal(condition, 'mainPractice_1') && ~isequal(condition, 'mainPractice_2')...
%             && ~isequal(condition, 'mainPractice_3') && ~isequal(condition, 'mainPractice_4') && ~isequal(condition, 'onlinePractice') && ~isequal(condition, 'chinesePractice_1')...
%             && ~isequal(condition, 'chinesePractice_2') && ~isequal(condition, 'chinesePractice_3') && ~isequal(condition, 'chinesePractice_4') && ~isequal(condition, 'ARC_controlPractice')...
%             && ~isequal(condition, 'reversalPractice') && ~isequal(condition, 'reversalPracticeNoise') && ~isequal(condition, 'reversalPracticeNoiseInv') && ~isequal(condition, 'reversalPracticeNoiseInv2')
% 
%         
%         if isequal(taskParam.gParam.taskType, 'ARC') && isequal(condition,'main')
%             if taskParam.gParam.showTickmark
%                 savename = sprintf('cannon_ARC_g%s_%s_TM_c%.0f',taskParam.subject.group, subject.ID, unique(concentration));
%             elseif ~taskParam.gParam.showTickmark
%                 savename = sprintf('cannon_ARC_g%s_%s_NTM_c%.0f',taskParam.subject.group, subject.ID, unique(concentration));
%             end
% 
%         elseif isequal(taskParam.gParam.taskType, 'ARC') && isequal(condition,'ARC_controlSpeed')
%             savename = sprintf('cannon_ARC_g%s_%s_ControlSpeed%.0f',subject.group, subject.ID, subject.testDay);
%         elseif isequal(taskParam.gParam.taskType, 'ARC') && isequal(condition,'ARC_controlAccuracy')
%             savename = sprintf('cannon_ARC_g%s_%s_ControlAccuracy%.0f', subject.group, subject.ID, subject.testDay);
%         elseif isequal(taskParam.gParam.taskType, 'dresden')
        
        %         elseif isequal(taskParam.gParam.taskType, 'oddball')
% 
%             if taskParam.subject.rew == 1
%                 rewName = 'B';
%             elseif taskParam.subject.rew == 2
%                 rewName = 'G';
%             end
% 
%             savename = sprintf('Drugstudy_%s_%s_session%s_%s', rewName, taskParam.subject.ID, subject.session, condition);
% 
%         end


        save(savename, 'Data')

    %end

    KbReleaseWait();

end
