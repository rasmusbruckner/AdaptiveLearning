function al_HamburgInstructions(taskParam)
%AL_HAMBURGINSTRUCTIONS This function runs the instructions for the
% "Hamburg" version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       ~

% Extract test day and cBal variables
testDay = taskParam.subject.testDay;
cBal = taskParam.subject.cBal;

% Adjust trialflow
taskParam.trialflow.cannon = 'show cannon'; % cannon will be displayed
taskParam.trialflow.currentTickmarks = 'hide'; % tick marks initially not shown
taskParam.trialflow.push = 'practiceNoPush'; % turn off push manipulation

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% 1. Present welcome message
% --------------------------

al_indicateCondition(taskParam, 'Herzlich Willkommen Zur Konfetti-Kanonen-Aufgabe!')

% Reset background to gray
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);

if testDay == 1

    % 2. Introduce the cannon
    % -----------------------

    % Load taskData-object instance
    nTrials = 4;
    taskData = al_taskDataMain(nTrials);

    % Generate practice-phase data
    taskData.catchTrial(1:nTrials) = 0; % no catch trials
    taskData.initiationRTs(1:nTrials) = nan;  % set initiation RT to nan to indicate that this is the first response
    taskData.initialTendency(1:nTrials) = nan;  % set initial tendency of mouse movement
    taskData.block(1:nTrials) = 1; % block number
    taskData.allASS(1:nTrials) = rad2deg(2*sqrt(1/12)); % shield size  taskParam.gParam.concentration TODO: Adjust to new noise conditions
    taskData.shieldType(1:nTrials) = 1; % shield color
    taskData.distMean = [300, 240, 300, 65]; % aim of the cannon
    taskData.outcome = taskData.distMean; % in practice phase, mean and outcome are the same
    taskData.pred(1:nTrials) = nan; % initialize predictions
    taskData.nParticles(1:nTrials) = taskParam.cannon.nParticles; % number of confetti particles
    taskData.greenCaught(1:nTrials) = nan;
    taskData.redCaught(1:nTrials) = nan;
    for t = 1:nTrials
        taskData.dotCol(t).rgb = uint8(round(rand(3, taskParam.cannon.nParticles)*255));
    end

    % Introduce cannon
    current_trial = 1;
    txt = ['Sie blicken von oben auf eine Konfetti-Kanone, die in der Mitte eines Kreises positioniert ist. Ihre Aufgabe ist es, das Konfetti mit einem Eimer zu fangen. Mit dem violetten '...
        'Punkt können Sie angeben, wo auf dem Kreis Sie Ihren Eimer platzieren möchten, um das Konfetti zu fangen. Sie können den Punkt mit der '...
        'Maus steuern.'];
    taskParam = al_introduceCannon(taskParam, taskData, current_trial, txt);

    % 3. Introduce confetti
    % ---------------------

    current_trial = 2; % update trial number
    txt = 'Das Ziel der Konfetti-Kanone wird mit der schwarzen Linie angezeigt. Drücken Sie die linke Maustaste, damit die Konfetti-Kanone schießt.';
    [taskData, taskParam] = al_introduceConfetti(taskParam, taskData, current_trial, txt);

    % 4. Introduce prediction spot and ask participant to catch confetti
    % ------------------------------------------------------------------

    % Add tickmarks to introduce them to participant
    taskParam.trialflow.currentTickmarks = 'show';
    current_trial = 3; % update trial number


    % Repeat as long as subject misses confetti
    while 1

        txt=['Der schwarze Strich zeigt Ihnen die mittlere Position der letzten Konfettiwolke. Der violette Strich zeigt Ihnen die '...
            'Position Ihres letzten Eimers. Steuern Sie den violetten Punkt jetzt bitte auf das Ziel der Konfetti-Kanone und drücken Sie die linke Maustaste.'];
        %[taskData, taskParam, xyExp, dotCol, dotSize] = al_introduceSpot(taskParam, taskData, current_trial, txt);
        [taskData, taskParam, xyExp, dotSize] = al_introduceSpot(taskParam, taskData, current_trial, txt);

        % If it is a miss, repeat instruction
        if abs(taskData.predErr(current_trial)) >= taskParam.gParam.practiceTrialCriterionEstErr
            header = 'Leider nicht gefangen!';
            txt = 'Sie haben leider zu wenig Konfetti gefangen. Versuchen Sie es noch mal!';
            feedback = false; % indicate that this is the instruction mode
            al_bigScreen(taskParam, header, txt, feedback);
        else
            break
        end
    end

    % 5. Introduce shield
    % -------------------

    win = true; % color of shield when catch is rewarded
    txt = ['Wenn Sie mindestens die Hälfte des Konfettis im Eimer fangen, zählt es als Treffer und Sie erhalten einen Punkt.'];
    taskData = al_introduceShield(taskParam, taskData, win, current_trial, txt, xyExp, taskData.dotCol(current_trial).rgb, dotSize);

    % 6. Ask participant to miss confetti
    % -----------------------------------

    % Update trial number
    current_trial = 4;

    % Repeat as long as subject catches confetti
    while 1

        % Introduce miss with bucket
        txt = 'Versuchen Sie nun Ihren Eimer so zu positionieren, dass Sie das Konfetti verfehlen. Drücken Sie dann die linke Maustaste.';
        [taskData, taskParam, xyExp, dotSize] = al_introduceShieldMiss(taskParam, taskData, current_trial, txt);

        % If it is a hit, repeat instruction
        if abs(taskData.predErr(current_trial)) <= taskParam.gParam.practiceTrialCriterionEstErr*2 % make sure that miss is really obvious

            WaitSecs(0.5)
            header = 'Leider gefangen!';
            txt = 'Sie haben zu viel Konfetti gefangen. Versuchen Sie bitte, das Konfetti zu verfehlen!';
            feedback = false; % indicate that this is the instruction mode
            al_bigScreen(taskParam, header, txt, feedback);  % todo: code needs to be re-organized
        else
            break
        end

    end

    % 7. Confirm that confetti was missed
    % -------------------------------------
    win = true;
    txt = 'In diesem Fall haben Sie das Konfetti verfehlt.';
    al_confirmMiss(taskParam, taskData, win, current_trial, txt, xyExp, taskData.dotCol(current_trial).rgb, dotSize);

    % 8. Introduce practice blocks
    % ----------------------------

    % Display instructions
    header = '';
    txt=['Im Folgenden durchlaufen Sie zwei Übungsdurchgänge\nund im Anschluss zwei Durchgänge des Experiments.'];
    feedback = true; % present text centrally
    al_bigScreen(taskParam, header, txt, feedback);

    % 9. Introduce variability of the confetti cannon
    % -----------------------------------------------

    % Display instructions
    header = 'Erster Übungsdurchgang';
    txt=['Weil die Konfetti-Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. Das heißt, auch wenn '...
        'Sie genau auf das Ziel gehen, können Sie das Konfetti verfehlen. Die Ungenauigkeit ist zufällig, '...
        'dennoch fangen Sie am meisten Konfetti, wenn Sie den violetten Punkt genau auf die Stelle '...
        'steuern, auf die die Konfetti-Kanone zielt.\n\nIn dieser Übung sollen Sie mit der Ungenauigkeit '...
        'der Konfetti-Kanone erst mal vertraut werden. Steuern Sie den violetten Punkt bitte immer auf die anvisierte '...
        'Stelle.'];
    feedback = false; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback);

    % Load outcomes for practice
    condition = 'practice';
    taskData = load('visCannonPracticeHamburg.mat');
    taskData = taskData.taskData;
    taskParam.condition = condition;
    taskData.initialTendency = nan(length(taskData.ID), 1);

    % Reset roation angle to starting location
    taskParam.circle.rotAngle = 0;

    % Run task
    while 1

        % Task loop
        al_confettiLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);

        % If estimation error is larger than a criterion on more than five
        % trials, we repeat the instructions
        repeatBlock = sum(abs(taskData.estErr) >= taskParam.gParam.practiceTrialCriterionEstErr);
        if sum(repeatBlock) > taskParam.gParam.practiceTrialCriterionNTrials
            WaitSecs(0.5)
            header = 'Bitte noch mal probieren!';
            txt = ['Sie haben Ihren Eimer oft neben dem Ziel der Kanone platziert. Versuchen Sie im nächsten '...
                'Durchgang bitte, den Eimer direkt auf das Ziel zu steuern. Das Ziel wird mit der Nadel gezeigt.'];
            al_bigScreen(taskParam, header, txt, feedback);
        else
            break
        end

    end

    % 10. Introduce hidden confetti cannon
    % -----------------------------------

    % Display instructions
    header = 'Zweiter Übungsdurchgang';
    txt = ['In diesem Übungsdurchgang ist die Konfetti-Kanone nicht mehr sichtbar. Anstelle der Konfetti-Kanone sehen Sie dann ein Kreuz. '...
        'Außerdem sehen Sie, wo das Konfetti hinfliegt.\n\nUm weiterhin viel Konfetti zu fangen, müssen Sie aufgrund '...
        'der Flugposition einschätzen, auf welche Stelle die Konfetti-Kanone aktuell zielt und den Eimer auf diese Position '...
        'steuern. Wenn Sie denken, dass die Konfetti-Kanone ihre Richtung geändert hat, sollten Sie auch den Eimer '...
        'dorthin bewegen.\n\nIn der folgenden Übung werden Sie es sowohl mit einer relativ genauen '...
        'als auch einer eher ungenauen Konfetti-Kanone zu tun haben. Beachten Sie, dass Sie das Konfetti trotz '...
        'guter Vorhersagen auch häufig nicht fangen können.'];
    feedback = false;
    al_bigScreen(taskParam, header, txt, feedback);

    if cBal == 1
       
        % Low noise first...
        % ------------------
    
        % Get data
        taskData = load('hidCannonPracticeHamburg_c16.mat');
        taskData = taskData.taskData;
    
        % Run task
        taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore
        taskParam.trialflow.confetti = 'show confetti cloud';
        al_indicateNoise(taskParam, 'lowNoise')
        al_confettiLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);
    
        % ... high noise second
        % ---------------------
    
        % Get data
        taskData = load('hidCannonPracticeHamburg_c8.mat');
        taskData = taskData.taskData;
    
        % Run task
        al_indicateNoise(taskParam, 'highNoise')
        al_confettiLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);
    
    elseif cBal == 2

        % High noise first...
        % ------------------
    
        % Get data
        taskData = load('hidCannonPracticeHamburg_c8.mat');
        taskData = taskData.taskData;
    
        % Run task
        taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore
        taskParam.trialflow.confetti = 'show confetti cloud';
        al_indicateNoise(taskParam, 'highNoise')
        al_confettiLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);
    
        % ... low noise second
        % ---------------------
    
        % Get data
        taskData = load('hidCannonPracticeHamburg_c16.mat');
        taskData = taskData.taskData;
    
        % Run task
        al_indicateNoise(taskParam, 'lowNoise')
        al_confettiLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);

    end

else

    % Add tickmarks to introduce them to participant
    taskParam.trialflow.currentTickmarks = 'show';

    % Text settings
    Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
    Screen('TextSize', taskParam.display.window.onScreen, 50);
    header = 'Tag 2: Übungsdurchgang';
    txtStartTask = ['Herzlich willkommen zum zweiten Teil des Experiments. Wie beim letzten Mal werden Sie mit einer Übung anfangen. '...
        'Bei jedem Versuch wird eine Konfetti-Kanone auf eine Stelle des Kreises zielen. Das Konfetti wird in der Nähe des Ziels laden. '...
        'Meistens wird die Konfetti-Kanone auf dieselbe Stelle zielen, aber es kommt auch vor, dass sich die Konfetti-Kanone neu ausrichtet.\n\n'...
        'Sie werden die Konfetti-Kanone meistens nicht sehen, sondern müssen das Ziel bestmöglich einschätzen, um möglichst viel Konfetti in Ihrem Eimer zu '...
        'fangen und das gewonnene Geld zu maximieren.\n\nWenn die Konfetti-Kanone in seltenen Fällen gezeigt wird, sollten Sie Ihren violetten Punkt '...
        'genau auf das Ziel steuern.'];

    feedback = false;
    al_bigScreen(taskParam, header, txtStartTask, feedback);

    % Load data set for practice phase
    % taskData = load('hidCannonPracticeSleep.mat');
    taskData = load('hidCannonPracticeHamburg_c16.mat');
    taskData = taskData.taskData;

    % Run task
    taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore...
    taskParam.trialflow.confetti = 'show confetti cloud'; ... but confetti cloud instead
    condition = 'practice';
    al_confettiLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);

end

% 11. Instructions experimental blocks
% ------------------------------------

header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst fangen Sie also das meiste Konfetti, '...
    'wenn Sie den Eimer (violetter Punkt) auf die Stelle bewegen, auf die die Konfetti-Kanone zielt. Weil Sie die Konfetti-Kanone meistens nicht mehr '...
    'sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Konfettiwolken einschätzen. Beachten Sie, dass Sie das Konfetti trotz '...
    'guter Vorhersagen auch häufig nicht fangen können. \n\nIn wenigen Fällen werden Sie die Konfetti-Kanone zu sehen bekommen und können Ihre Leistung '...
    'verbessern, indem Sie den Eimer genau auf das Ziel steuern.\n\n'...
    'Sie werden wie in der Übung zwei Blöcke spielen. In jedem Block gibt es 3 kurze Pausen.\n\nViel Erfolg!'];

feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);

end