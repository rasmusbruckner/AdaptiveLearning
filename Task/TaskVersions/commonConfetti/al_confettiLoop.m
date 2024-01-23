function taskData = al_confettiLoop(taskParam, condition, taskData, trial)
%AL_CONFETTILOOP This function runs the cannon-task trials for the "confetti-cannon version"
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
%   Events standard condition
%       1: Trial Onset
%       2: Prediction            (self-paced)
%       3: Confetti animation    (1500 ms)
%       4: ITI                   (900 ms)
%       5: Jitter                (0-200 ms)
%                                ------------
%                                 2.5 s + pred (~ 2s)
%
%   Events asymmetric-reward condition
%       1: Trial Onset
%       2: Prediction            (self-paced)
%       3: Confetti animation    (1500 ms)
%       4: ISI                   (500 ms)
%       5: Reward                (1000 ms)
%       6: ITI                   (900 ms)
%       7: Jitter                (0-200 ms)
%                                ------------
%                                 4.0 s + pred (~ 2s)
%
% todo: maybe get rid of "condition" input
% todo: some comments should be added and some outdated comments should be
% deleted


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
    [taskData, taskParam] = al_mouseLoop(taskParam, taskData, condition, i, initRT_Timestamp);

    if taskParam.gParam.printTiming
        fprintf('Initiation RT: %.5f\n', taskData.initiationRTs(i))
        fprintf('RT: %.5f\n', taskData.RT(i))
    end

    % Extract current time and determine when screen should be flipped
    % for accurate timing
    timestamp = GetSecs;

    % Outcome: Animate confetti
    %--------------------------

    % send fixation cross 1 trigger
    % todo: this should be done in mouse loop, like I did for keyboardLoop
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
    else
        taskData.hit(i) = 0;
    end

    % Record belief update
    if i > 1
        taskData.UP(i) = al_diff(taskData.pred(i), taskData.pred(i-1));
    end

    % Confetti animation
    background = false; % todo: include this in trialflow
    taskData = al_confetti(taskParam, taskData, i, background, timestamp);

    % Compute performance
    if strcmp(taskParam.trialflow.reward, 'asymmetric')

        % Performance depends on green vs. red particles caught
        taskData.perf(i) = taskData.greenCaught(i) - taskData.redCaught(i);
        
        % Reward prediction error: actual reward - (green minus red confetti particles assuming that all particles would be collected)
        taskData.RPE(i) = taskData.perf(i) - (taskData.nGreenParticles(i) - (taskData.nParticles(i)-taskData.nGreenParticles(i)));

    else

        % Performance depends on hit vs miss
        if taskData.hit(i) == 1
            taskData.perf(i) = taskParam.gParam.rewMag;
        else
            taskData.perf(i) = 0;
        end

    end

    % Accumulated performance
    taskData.accPerf(i) = nansum(taskData.perf);
    % The above is included for backward compatibility. In future, when all
    % labs have more recent Matlab versions, potentially change to: 
    % taskData.accPerf(i) = sum(taskData.perf, 'omitnan');

    % Fixation cross: ITI (standard version) or ISI (asymmetric reward)
    % -----------------------------------------------------------------

    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
        al_drawCannon(taskParam, taskData.distMean(i))
    else
        [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
        Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawCross(taskParam)
    end

    % Draw circle and confetti cloud
    al_drawCircle(taskParam)

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    timestamp = timestamp + taskParam.timingParam.cannonBallAnimation;
    Screen('Flip', taskParam.display.window.onScreen, timestamp);

    if taskParam.gParam.printTiming
        shotTiming = GetSecs() - taskParam.timingParam.ref;
        fprintf('Shot duration: %.5f\n', shotTiming - taskData.timestampPrediction(i))
    end

    % For asymmetric reward: Display feedback and fixation cross (ISI)
    if strcmp(taskParam.trialflow.reward, 'asymmetric')

        % Feedback
        % --------

        timestamp = timestamp + taskParam.timingParam.fixCrossLength;

        % Display reward feedback
        txt = sprintf('<color=32CD32>Grünes Konfetti: %.0f\n<color=ff0000>Rotes Konfetti: %.0f\n<color=ffa500>Gewinn: %.0f Punkte', taskData.greenCaught(i), taskData.redCaught(i), taskData.perf(i));
        zero = taskParam.display.zero;
        DrawFormattedText2(txt,'win',taskParam.display.window.onScreen, 'sx' ,zero(1), 'sy', zero(2), 'xalign','center','yalign','center');

        % Tell PTB that everything has been drawn and flip screen
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        if taskParam.gParam.printTiming
            fixCrossTiming = GetSecs - taskParam.timingParam.ref;
            fprintf('Fix-cross duration: %.5f\n', fixCrossTiming -  shotTiming)
        end

        % Fixation cross: ITI
        % --------------------

        if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(i)
            al_drawCannon(taskParam, taskData.distMean(i))
        else
            [xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();
            Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
            al_drawCross(taskParam)
        end

        % Draw circle and confetti cloud
        al_drawCircle(taskParam)

        % Tell PTB that everything has been drawn and flip screen
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        timestamp = timestamp + taskParam.timingParam.rewardLength;
        Screen('Flip', taskParam.display.window.onScreen, timestamp);

        % Reward timestamp
        if taskParam.gParam.printTiming
            taskData.timestampReward(i) = GetSecs - taskParam.timingParam.ref;
            fprintf('Feedback duration: %.5f\n', taskData.timestampReward(i) - fixCrossTiming)
        end
    end

    % Fixed inter-trial interval
    WaitSecs(taskParam.timingParam.fixedITI);

    % Offset timestamp
    taskData.timestampOffset(i) = GetSecs - taskParam.timingParam.ref;
    if taskParam.gParam.printTiming
        if strcmp(taskParam.trialflow.reward, 'asymmetric')
            fprintf('Fixation-cross duration: %.5f\n', taskData.timestampOffset(i) - taskData.timestampReward(i))
        else
            fprintf('Fixation-cross duration: %.5f\n', taskData.timestampOffset(i) - shotTiming)
        end
    end

    % Manage breaks
    taskParam = al_takeBreak(taskParam, taskData, i);

end

% Give feedback and save data
% ----------------------------

if ~taskParam.unitTest
    
    if ~isequal(taskParam.trialflow.reward, 'asymmetric')
        currPoints = nansum(taskData.hit);
        % The above is included for backward compatibility. In future, when all
        % labs have more recent Matlab versions, potentially change to:     
        % currPoints = sum(taskData.hit, 'omitnan');

        txt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', currPoints);
    else
        txt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', round(sum(taskData.nParticlesCaught))/10);
    end
    
    header = 'Zwischenstand';
    feedback = true;
    al_bigScreen(taskParam, header, txt, feedback);

    % Save data
    %----------

    if ~isequal(condition,'practice')

        if isequal(taskParam.gParam.saveName, 'vwm')
            savename = sprintf('confetti_vwm_dm_%s_tm_%s_var_%s_id_%s', taskParam.trialflow.distMean, taskParam.trialflow.currentTickmarks, taskParam.trialflow.variability, taskParam.subject.ID);
        else
            concentration = unique(taskData.concentration);
            savename = sprintf('confetti_%s_g%d_d%d_conc%d_%s', taskParam.trialflow.reward, taskParam.subject.group, taskParam.subject.testDay, concentration, taskParam.subject.ID);
        end

            % Ensure that files cannot be overwritten
            checkString = dir([savename '*']);            
            fileNames = {checkString.name};            
            if  ~isempty(fileNames)
                savename = [savename '_new'];
            end
            save(savename, 'taskData')
            

        % Wait until keys released
        KbReleaseWait();
    end
end
end