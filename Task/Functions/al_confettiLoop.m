function [taskData, Data, subject] = al_confettiLoop(taskParam, haz, concentration, condition, subject, taskData, trial)
%AL_CONFETTILOOP This function runs the cannon-task trials for the "confetti-cannon version"
%
%   Input
%       taskParam: Task-parameter-object instance
%       haz: Hazard rate
%       concentration: Noise in the environment
%       condtion: Noise condition type
%       subject: structure containing subject information
%       taskData: Task-data-object instance 
%
%   Output
%       taskData: Task-data-object instance 
%       Data: Participant data
%       subject: not necessary anymore
%
%   TODO: Verify this
%   Events
%       1: Trial Onset
%       2: Prediction            self-paced
%       3: Confetti animation    XX ms
%       4: Miss/Hit animation    XX ms
%       5: ITI                   XX ms
%       6: Jitter                0-XX ms
%                                ------------       
%                                XXs + pred (~ XXs)
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
    taskData.ID(i) = subject.ID;
    taskData.sex{i} = subject.sex;
    taskData.Date{i} = subject.date;
    taskData.cBal(i) = subject.cBal;
    taskData.rew(i) = subject.rew;
    taskData.cond{i} = condition;

    % Timestamp for measuring jitter duration for validation purposes
    jitTest = GetSecs();
   
    % Take jitter into account and get timestamps for initiation RT
    taskData.actJitter(i) = rand * taskParam.timingParam.jitter;
    WaitSecs(taskData.actJitter(i));
    initRT_Timestamp = GetSecs();
    
    % Send trial onset trigger
    taskData.triggers(i,1) = al_sendTrigger(taskParam, taskData, condition, haz, i, 1);
    taskData.timestampOnset(i,:) = GetSecs - taskParam.timingParam.ref;
    
    % Print out jitter duration, if desired
    if taskParam.gParam.printTiming
        fprintf('\nTrial %.0f:\nJitter duration: %.5f\n', i, GetSecs() - jitTest)
    end

    % Send trial-onset trigger (here only timestamp since task without EEG or pupillometry)
    taskData.timestampOnset(i,:) = GetSecs - taskParam.timingParam.ref;
    
    % Self-paced prediction phase
    % ---------------------------

    % Only do this when not testing the code
    if ~taskParam.unitTest

            % XX
            SetMouse(720, 450, taskParam.display.window.onScreen)
            
            % XX
            press = 0;
            [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp, press);    
    end

    if taskParam.gParam.printTiming
        fprintf('Initiation RT: %.5f\n', taskData.initiationRTs(i))
        fprintf('RT: %.5f\n', taskData.RT(i))
    end
        
    % Extract current time and determine when screen should be flipped
    % for accurate timing
    tUpdated = GetSecs;

    if ~isequal(condition, 'shield') && ~isequal(condition, 'mainPractice_1') && ~isequal(condition, 'mainPractice_2') && ~isequal(condition, 'chinesePractice_1') && ~isequal(condition, 'chinesePractice_2') && ~isequal(condition, 'chinesePractice_3')
        
        %al_drawCross(taskParam)
        al_drawCircle(taskParam)
         
        % send fixation cross 1 trigger
        % todo: this should be done in mouse loop, like I did for
        % keyboardLoop
        taskData.triggers(i,2) = al_sendTrigger(taskParam, taskData, condition, haz, i, 2);
        taskData.timestampPrediction(i,:) = GetSecs - taskParam.timingParam.ref;
        
    end
    
    % Outcome: Animate confetti
    %--------------------------

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
    
    % todo: verify before running real experiment
    taskData.accPerf(i) = sum(taskData.perf, 'omitnan');
    
    % Record belief update
    if i > 1
        taskData.UP(i) = al_diff(taskData.pred(i), taskData.pred(i-1));
    end
            
    % Outcome: Animate hit and miss
    % -----------------------------

    background = false;
    al_confetti(taskParam, taskData, i, background)
    
    if strcmp(taskParam.trialflow.cannon, 'hide cannon')    
         al_drawCross(taskParam)
    else
        al_drawCannon(taskParam, taskData.distMean(i), taskData.latentState(i))
    end

    al_drawCircle(taskParam)
    if isequal(taskParam.trialflow.confetti, 'show confetti cloud')
        [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
        Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1); 
        al_drawCross(taskParam)
    end
    
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    
    tUpdated = tUpdated + taskParam.timingParam.outcomeLength;
    Screen('Flip', taskParam.display.window.onScreen, tUpdated);
    
    % Send fixation cross 3 trigger
    taskData.triggers(i,6) = al_sendTrigger(taskParam, taskData, condition, haz, i, 6);
    WaitSecs(taskParam.timingParam.fixedITI / 2);
    
    % Send trial summary trigger
    taskData.triggers(i,7) =  al_sendTrigger(taskParam, taskData, condition, haz, i, 16);
    
    WaitSecs(taskParam.timingParam.fixedITI / 2);
    taskData.timestampOffset(i,:) = GetSecs - taskParam.timingParam.ref;
    
end

% Give feedback
%--------------
if ~isequal(condition,'shield') && ~isequal(condition,'onlinePractice')
    
     whichBlock = taskData.block(1:i);
     header = 'Performance';
     whichBlock = taskData.block(1:i);
     hits = sum(taskData.hit);

     maxMon = (length(find(taskData.shieldType)) * taskParam.gParam.rewMag);

     txt = sprintf('Catches: %.0f of %.0f\n\nIn this block you earned %.0f of possible %.0f points.', hits, length(whichBlock), max(taskData.accPerf)*10, maxMon*10);

    al_bigScreen(taskParam, header, txt, true);
    
end

% necessary?
KbReleaseWait();


% Save data
%----------

haz = repmat(haz, length(trial),1);
concentration = repmat(concentration, length(trial),1);
oddballProb = repmat(taskParam.gParam.oddballProb(1), length(trial),1);
driftConc = repmat(taskParam.gParam.driftConc(1), length(trial),1);

% Todo: Update this and make sure data object is used
Data = struct('actJitter', taskData.actJitter, 'block', taskData.block,...
    'initiationRTs', taskData.initiationRTs, 'timestampOnset',...
    taskData.timestampOnset,'timestampPrediction',...
    taskData.timestampPrediction,'timestampOffset',...
    taskData.timestampOffset, 'allASS', taskData.allASS, 'driftConc',...
    driftConc,...
    'ID', {taskData.ID}, 'age',taskData.age, 'rew', {taskData.rew},...
    'actRew', taskData.actRew,'sex', {taskData.sex}, 'cond',...
    {taskData.cond}, 'cBal',{taskData.cBal}, 'trial', taskData.currTrial,...
    'haz', haz, 'concentration', concentration,'outcome',...
    taskData.outcome, 'distMean', taskData.distMean, 'cp',...
    taskData.cp, 'TAC',taskData.TAC, 'shieldType', taskData.shieldType,...
    'catchTrial', taskData.catchTrial, 'triggers', taskData.triggers,...
    'pred', taskData.pred,'predErr', taskData.predErr, 'memErr',...
    taskData.memErr, 'cannonDev', taskData.cannonDev,...
    'UP',taskData.UP, 'hit', taskData.hit, 'perf',...
    taskData.perf, 'accPerf',taskData.accPerf,...
    'RT', taskData.RT, 'Date', {taskData.Date},...
    'taskParam', taskParam); %'contextTypes', taskData.contextTypes,...  % 'oddballProb',oddballProb, 'oddBall', taskData.oddBall 'savedTickmark', taskData.savedTickmark,
    
    % Todo: also store initialTendency in data object

KbReleaseWait();

end
