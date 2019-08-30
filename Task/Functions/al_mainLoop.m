function [taskData, Data] = al_mainLoop(taskParam, haz, concentration, condition, subject, taskData)
%AL_MAINLOOP   This function runs the experimental part of the cannon task. You can specify
% "main", "practice" or "control". This loop is optimized for triggering
% accuracy
%
% Events
% Trigger 1: Trial Onset
% Trigger 2: Prediction/Fixation1 (500 ms)
% Trigger 3: Outcome              (500 ms)
% Trigger 4: Fixation2            (500 ms)
% Trigger 5: Shield               (500 ms)
% Trigger 6: Fixation3            (500 ms)
% Trigger 7: Trial Summary
% Jitter:                         (0-200 ms)
%
%   Input
%       taskParam: structure containing task paramters
%       haz: hazard rate
%       concentration: noise in the environment
%       condtion: noise condition type
%       subject: structure containing subject information
%
%   Output
%       taskData: task data
%       Data: participant data 


% Initiate task
%--------------

KbReleaseWait();

ref = taskParam.gParam.ref;
fixCrossLength = taskParam.timingParam.fixCrossLength;
outcomeLength = taskParam.timingParam.outcomeLength;
jitter = taskParam.timingParam.jitter;
fixedITI = taskParam.timingParam.fixedITI;

% textsize
if isequal(taskParam.gParam.taskType, 'dresden')
    textSize = 19;
else
    textSize = 30;
end
Screen('TextSize', taskParam.gParam.window.onScreen, textSize);
Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');

% Load data if specified
%-----------------------

if ~exist('taskData', 'var')
    % Load condition-specific task data and get correct number of trials
    [taskData, trial] = al_loadTaskData(taskParam, condition, haz, concentration);
else
    
    trial = taskParam.gParam.trials;
end
% Loop through trials
%--------------------

if ~isequal(condition,'ARC_controlSpeed') && ~isequal(condition,'ARC_controlAccuracy') && ~isequal(condition,'ARC_controlPractice')
    
    for i = 1:trial
       
        % Manage breaks
        %if (i == taskParam.gParam.blockIndices(2) || i == taskParam.gParam.blockIndices(3) || i == taskParam.gParam.blockIndices(4)) && ~isequal(condition, 'chinesePractice_4')
        if i > 1 && ~(taskData.block(i) == taskData.block(i-1))

            if isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'reversalPractice') || isequal(taskParam.gParam.taskType, 'ARC')
                txt = 'Take a break!';
                header = ' ';
            elseif isequal(taskParam.gParam.taskType, 'chinese')
                whichBlock = taskData.block(i-1) == taskData.block;   %taskData.block == %taskData.block(i-1);
                txt = al_feedback(taskData, taskParam, subject, condition, whichBlock);
                header = sprintf('End of block %.0f of %.0f', taskData.block(i-1), taskData.block(end));
                al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, true);
                txt = 'Take a short break.\n\nKeep in mind that the enemies have recalibrated their cannons!';
                header = ' ';
                %header = sprintf(['Ende Block %.0f von 4. Du kannst jetzt eine kurze Pause machen.\n\nBeachte, dass die Gegner '...
                 %   'ihre Kanonen jetzt neu ausrichten!'], taskData.block(i-1));
            else
                txt = 'Kurze Pause!';
                header = ' ';
            end
            
            al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, true);
            
            KbReleaseWait();
        end
        
        % Save constant variables
        taskData.trial(i) = i;
        taskData.age(i) = str2double(subject.age);
        taskData.ID{i} = subject.ID;
        taskData.sex{i} = subject.sex;
        taskData.Date{i} = subject.date;
        taskData.cond{i} = condition;
        taskData.cBal(i) = subject.cBal;
        taskData.rew(i) = subject.rew;
        
        % Determine actRew
        if taskData.rew(i) == 1 && taskData.shieldType(i) == 1
            taskData.actRew(i) = 1;
        elseif taskData.rew(i) == 1 && taskData.shieldType(i) == 0
            taskData.actRew(i) = 2;
        elseif taskData.rew(i) == 2 && taskData.shieldType(i) == 1
            taskData.actRew(i) = 2;
        elseif taskData.rew(i) == 2 && taskData.shieldType(i) == 0
            taskData.actRew(i) = 1;
        end
        
        % Set prediction spot to default after break
        if i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) + 1 || i == taskParam.gParam.blockIndices(3) + 1 || i == taskParam.gParam.blockIndices(4) + 1
            taskParam.circle.rotAngle =  taskParam.circle.initialRotAngle;
        end
        
        % Take jitter into account and get timestamps
        taskData.actJitter(i) = rand*jitter;
        WaitSecs(taskData.actJitter(i));
        initRT_Timestamp = GetSecs();
        
        % Send trial onset trigger
        taskData.triggers(i,1) = al_sendTrigger(taskParam, taskData, condition, haz, i, 1);
        taskData.timestampOnset(i,:) = GetSecs - ref;
        
        if ~taskParam.unitTest
            
            % Versions with keyboard
            %------------------------
            
            if ~isequal(taskParam.gParam.taskType, 'reversal') && ~isequal(taskParam.gParam.taskType, 'reversalPractice') && ~isequal(taskParam.gParam.taskType, 'chinese') && ~isequal(taskParam.gParam.taskType, 'ARC')
                 
                % Note: I put the keyboard stuff into a function, similar to the mouse loop. Input and output have to be added to this function
                % The rest works 13.09.18
                %[] = al_keyboardLoop()
            else
                
                % Versions with mouse
                %---------------------
                
                SetMouse(720, 450, taskParam.gParam.window.onScreen)
                press = 0;
                [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp, press);
                
            end
        end    
        
        % Fixation cross 1
        %-------------------
       
        t = GetSecs;
        tUpdated = t + 0.1;
        
        if ~isequal(condition, 'shield') && ~isequal(condition, 'mainPractice_1') && ~isequal(condition, 'mainPractice_2') && ~isequal(condition, 'chinesePractice_1') && ~isequal(condition, 'chinesePractice_2') && ~isequal(condition, 'chinesePractice_3')
            
            al_drawCross(taskParam)
            al_drawCircle(taskParam)
            if isequal(taskParam.gParam.taskType, 'chinese')
                al_drawContext(taskParam,taskData.currentContext(i))
                al_drawCross(taskParam)
            end
            
            Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
            Screen('Flip', taskParam.gParam.window.onScreen, tUpdated, 1);
            
            % send fixation cross 1 trigger
            taskData.triggers(i,2) = al_sendTrigger(taskParam, taskData, condition, haz, i, 2);
            taskData.timestampPrediction(i,:) = GetSecs - ref;
            
        end
        
        % Outcome 1
        %-----------
        
        % Deviation from cannon to compute performance criterion in practice
        taskData.cannonDev(i) = al_diff(taskData.distMean(i), taskData.pred(i));
        
        % PredError and memory error
        taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
        if isequal(condition,'main') || isequal(condition,'mainPractice_3') || isequal(condition,'mainPractice_4') || isequal(condition, 'followCannon') || isequal(condition, 'oddball')...
                || isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'reversalPractice')
            taskData.memErr(i) = 999;
            taskData.memErrNorm(i) = 999;
            taskData.memErrPlus(i) = 999;
            taskData.memErrMin(i) = 999;
        else
            if i > 1
                %warning('adjust this')
                % falls nochmal "dresden" hier anpassen, weiß gerade
                % nicht genau wofür das noch verwendet wird
                %             taskData.memErr(i) = al_diff(taskData.pred(i),...
                %                 taskData.outcome(i-1));
                taskData.memErr(i) = al_diff(taskData.pred(i), taskData.distMean(i));
                
            else
                taskData.memErr(i) = 999;
            end
        end
        
        if isequal(condition,'main') || isequal(condition,'mainPractice_1') || isequal(condition,'mainPractice_2') || isequal(condition,'mainPractice_3')...
                || isequal(condition,'mainPractice_4') || isequal(condition, 'oddballPractice') || isequal(condition, 'oddball') || isequal(condition,'followCannon')...
                || isequal(condition,'followCannonPractice') || isequal(condition,'reversal') || isequal(condition, 'reversalPractice') || isequal(condition, 'chinesePractice_4')...
                || isequal(condition, 'chinese') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
            if abs(taskData.predErr(i)) <= taskData.allASS(i)/2
                taskData.hit(i) = 1;
            end
        elseif isequal(condition,'followOutcome') || isequal(condition,'followOutcomePractice')
            if taskData.memErr(i) <= 5
                taskData.hit(i) = 1;
            end
        end
        
        if taskData.actRew(i) == 1 && taskData.hit(i) == 1
            taskData.perf(i) = taskParam.gParam.rewMag;
        end
        
        taskData.accPerf(i) = sum(taskData.perf);
        
        if i > 1
            taskData.UP(i) = al_diff(taskData.pred(i), taskData.pred(i-1));
        end
        al_drawCircle(taskParam)
        if isequal(taskParam.gParam.taskType, 'chinese')
            al_drawContext(taskParam,taskData.currentContext(i))
            al_drawCross(taskParam)
        end
        
        %tUpdated = tUpdated + fixCrossLength;
        
        if isequal(condition, 'shield') || isequal(condition, 'mainPractice_1') || isequal(condition, 'mainPractice_2') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
            
            background = false;
            al_cannonball(taskParam, taskData.distMean(i), taskData.outcome(i), background, taskData.currentContext(i), taskData.latentState(i))
            waitingTime = 0.2;
            WaitSecs(waitingTime);
            
            tUpdated = tUpdated + fixCrossLength + waitingTime;
            % tUpdated = tUpdated + fixCrossLength;
        else
            
            al_predictionSpot(taskParam)
            al_drawOutcome(taskParam, taskData.outcome(i))
            
            Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
            
            %Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6);
            tUpdated = tUpdated + fixCrossLength;
            Screen('Flip', taskParam.gParam.window.onScreen, tUpdated);
            
        end
        
        % Send outcome 1 trigger
        taskData.triggers(i,3) = al_sendTrigger(taskParam, taskData, condition, haz, i, 3);
        
        % Fixation cross 2
        %-----------------
        
        al_drawCross(taskParam)
        al_drawCircle(taskParam)
        if isequal(taskParam.gParam.taskType, 'chinese')
            al_drawContext(taskParam, taskData.currentContext(i))
            al_drawCross(taskParam)
        end
        Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
        %Screen('Flip', taskParam.gParam.window.onScreen, t + 1.1, 1);
        tUpdated = tUpdated + outcomeLength;
        Screen('Flip', taskParam.gParam.window.onScreen, tUpdated, 1);
        
        % Send fixation cross 2 trigger
        taskData.triggers(i,4) = al_sendTrigger(taskParam, taskData, condition, haz, i, 4);
        
        % Outcome 2
        %----------
        
        al_drawCircle(taskParam)
        if isequal(taskParam.gParam.taskType, 'chinese')
            al_drawContext(taskParam, taskData.currentContext(i))
            al_drawCross(taskParam)
        end
        al_shield(taskParam, taskData.allASS(i), taskData.pred(i), taskData.shieldType(i))
        
        if isequal(condition,'shield') || isequal(condition, 'mainPractice_1') || isequal(condition, 'mainPractice_2') || isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
            al_drawCannon(taskParam, taskData.distMean(i), taskData.latentState(i))
        else
            al_drawCross(taskParam)
        end
        
        al_drawOutcome(taskParam, taskData.outcome(i))
        
        Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
        %Screen('Flip', taskParam.gParam.window.onScreen, t + 2.1);
        
        tUpdated = tUpdated + fixCrossLength;
        Screen('Flip', taskParam.gParam.window.onScreen, tUpdated);
        
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
        Screen('DrawingFinished', taskParam.gParam.window.onScreen);
        
        %Screen('Flip', taskParam.gParam.window.onScreen, t + 2.6);
        tUpdated = tUpdated + outcomeLength;
        Screen('Flip', taskParam.gParam.window.onScreen, tUpdated);
        
        % Send fixation cross 3 trigger
        taskData.triggers(i,6) = al_sendTrigger(taskParam, taskData, condition, haz, i, 6);
        %WaitSecs();
        WaitSecs(fixedITI / 2);
        
        % Send trial summary trigger
        taskData.triggers(i,7) =  al_sendTrigger(taskParam, taskData, condition, haz, i, 16);
        
        %WaitSecs(.5);
        WaitSecs(fixedITI / 2);
        taskData.timestampOffset(i,:) = GetSecs - ref;
        
    end
    
    % Give feedback
    %--------------
    if ~isequal(condition,'shield') && ~isequal(condition,'onlinePractice')
        
        if isequal(taskParam.gParam.taskType, 'dresden')
            [txt, header] = Feedback(taskData, taskParam, subject, condition);
            
        elseif isequal(taskParam.gParam.taskType, 'chinese')
            
            whichBlock = taskData.block(1:i);
            [txt, header] = al_feedback(taskData, taskParam, subject, condition, whichBlock);
            
%             if isequal(condition,'chinese')
%                 header = sprintf('Ende Block %.0f von 4', taskData.block(i-1));
%             elseif isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3') || isequal(condition, 'chinesePractice_4')
%                 header = 'Ergebnis';
%             end
            
        elseif isequal(taskParam.gParam.taskType, 'oddball')
            
            if isequal(condition, 'oddballPractice')
                
                [txt, header] = Feedback(taskData, taskParam, subject, condition);
                
            else
                
                [txt, header] = Feedback(taskData, taskParam, subject, condition);
                
            end
            
        elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'reversalPractice') || isequal(taskParam.gParam.taskType, 'ARC')
            
            [txt, header] = al_feedback(taskData, taskParam, subject, condition);
            
        end
        
        al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, true);
        
        
    end
    
elseif isequal(condition,'ARC_controlSpeed') || isequal(condition,'ARC_controlAccuracy') || isequal(condition, 'ARC_controlPractice')
    
    for i = 1:trial
        
        %warning('was muss man hier speichern?')
        % Save constant variables
        taskData.trial(i)   = i;
        taskData.age(i)     = str2double(subject.age);
        taskData.ID{i}      = subject.ID;
        taskData.sex{i}     = subject.sex;
        taskData.Date{i}    = subject.date;
        taskData.cond{i}    = condition;
        taskData.cBal(i)    = subject.cBal;
        taskData.rew(i)     = subject.rew;
        taskData.actRew(i)  = nan;
        taskData.cannonDev(i)  = nan;
        
        % Take jitter into account and get timestamps
        taskData.actJitter(i) = rand*jitter;
        WaitSecs(taskData.actJitter(i));
        
        % Send trial onset trigger
        taskData.triggers(i,1) = nan;
        
        t = GetSecs;
        tUpdated = t + 0.1;
        
        al_drawCross(taskParam)
        al_drawCircle(taskParam)
        
        Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
        Screen('Flip', taskParam.gParam.window.onScreen, tUpdated, 1);
        
        al_drawCircle(taskParam)
        
        al_drawOutcome(taskParam, taskData.outcome(i))
        
        Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
        
        %Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6);
        tUpdated = tUpdated + fixCrossLength;
        Screen('Flip', taskParam.gParam.window.onScreen, tUpdated);
        WaitSecs(1);
        
        SetMouse(720, 450, taskParam.gParam.window.onScreen);
        press = 0;
        initRT_Timestamp = GetSecs();
        al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp, press)
        %taskData.outcome(i)
        %taskData.pred(i)
        taskData.predErr(i) = al_diff(taskData.outcome(i), taskData.pred(i));
        %taskData.predErr(i)
        
    end
    
end

% necessary?
KbReleaseWait();


% Save data
%----------

haz = repmat(haz, length(taskData.trial),1);
concentration = repmat(concentration, length(taskData.trial),1);
oddballProb = repmat(taskParam.gParam.oddballProb(1), length(taskData.trial),1);
driftConc = repmat(taskParam.gParam.driftConc(1), length(taskData.trial),1);

% This should ultimately be an object
Data = struct('actJitter', taskData.actJitter, 'block', taskData.block,...
    'initiationRTs', taskData.initiationRTs, 'timestampOnset',...
    taskData.timestampOnset,'timestampPrediction',...
    taskData.timestampPrediction,'timestampOffset',...
    taskData.timestampOffset, 'allASS', taskData.allASS, 'driftConc',...
    driftConc,'oddballProb',oddballProb, 'oddBall', taskData.oddBall,...
    'ID', {taskData.ID}, 'age',taskData.age, 'rew', {taskData.rew},...
    'actRew', taskData.actRew,'sex', {taskData.sex}, 'cond',...
    {taskData.cond}, 'cBal',{taskData.cBal}, 'trial', taskData.trial,...
    'haz', haz, 'concentration', concentration,'outcome',...
    taskData.outcome, 'distMean', taskData.distMean, 'cp',...
    taskData.cp, 'reversal', taskData.reversal, 'savedTickmark',...
    taskData.savedTickmark, 'TAC',taskData.TAC, 'shieldType', taskData.shieldType,...
    'catchTrial', taskData.catchTrial, 'triggers', taskData.triggers,...
    'pred', taskData.pred,'predErr', taskData.predErr, 'memErr',...
    taskData.memErr, 'cannonDev', taskData.cannonDev,...
    'UP',taskData.UP, 'hit', taskData.hit, 'perf',...
    taskData.perf, 'accPerf',taskData.accPerf,'initialTendency',...
    taskData.initialTendency, 'RT', taskData.RT, 'Date', {taskData.Date},...
    'currentContext', taskData.currentContext,...
    'latentState', taskData.latentState,'taskParam', taskParam,...
    'criticalTrial', taskData.critical_trial); %'contextTypes', taskData.contextTypes,...

Data = catstruct(subject, Data);

% save is currently only specified for reversal, chinese and ARC!

if taskParam.gParam.askSubjInfo && ~taskParam.unitTest && ~isequal(condition, 'shield') && ~isequal(condition, 'mainPractice_1') && ~isequal(condition, 'mainPractice_2')...
        && ~isequal(condition, 'mainPractice_3') && ~isequal(condition, 'mainPractice_4') && ~isequal(condition, 'onlinePractice') && ~isequal(condition, 'chinesePractice_1')...
        && ~isequal(condition, 'chinesePractice_2') && ~isequal(condition, 'chinesePractice_3') && ~isequal(condition, 'chinesePractice_4') && ~isequal(condition, 'ARC_controlPractice')
    
    if isequal(condition, 'reversal')
        
        if subject.rew == 1
            rewName = 'B';
        elseif subject.rew == 2
            rewName = 'G';
        end
        
        savename = sprintf('ReversalTask_%s_%s', rewName, subject.ID);
        
    elseif isequal(condition, 'chinese')
        
        if taskParam.gParam.showCue == true
            
            savename = sprintf('chinese_cued_%s_block_%.0f', subject.ID, taskData.block(1));
            
        elseif taskParam.gParam.showCue == false
            
            savename = sprintf('chinese_uncued_%s_block_%.0f', subject.ID, taskData.block(1));
        
        end
        
    elseif isequal(taskParam.gParam.taskType, 'ARC') && isequal(condition,'main')
        if taskParam.gParam.showTickmark
            savename = sprintf('cannon_ARC_g%s_%s_TM_c%.0f',subject.group, subject.ID,unique(concentration));
        elseif ~taskParam.gParam.showTickmark
            savename = sprintf('cannon_ARC_g%s_%s_NTM_c%.0f',subject.group, subject.ID,unique(concentration));
        end
        
    elseif isequal(taskParam.gParam.taskType, 'ARC') && isequal(condition,'ARC_controlSpeed')
        savename = sprintf('cannon_ARC_g%s_%s_ControlSpeed%.0f',subject.group, subject.ID, subject.testDay);
    elseif isequal(taskParam.gParam.taskType, 'ARC') && isequal(condition,'ARC_controlAccuracy')
        savename = sprintf('cannon_ARC_g%s_%s_ControlAccuracy%.0f',subject.group, subject.ID, subject.testDay);
    end
    
    save(savename, 'Data')
    
end

KbReleaseWait();

end
