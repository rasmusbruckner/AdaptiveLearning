function al_asymRewardInstructions(taskParam)
%AL_ASYMREWARDINSTRUCTIONS This function runs the instructions for the
% asymmetric reward version of the confetti-cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None

% Extract test day and cBal variables
testDay = taskParam.subject.testDay;
cBal = taskParam.subject.cBal;

% Adjust trialflow
taskParam.trialflow.cannon = 'show cannon'; % cannon will be displayed
taskParam.trialflow.currentTickmarks = 'hide'; % tick marks initially not shown
taskParam.trialflow.push = 'practiceNoPush'; % turn off push manipulation
taskParam.trialflow.reward = "standard";

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
    taskData = al_taskDataMain(nTrials, taskParam.gParam.taskType);

    % Generate practice-phase data
    taskData.catchTrial(1:nTrials) = 0; % no catch trials
    taskData.initiationRTs(1:nTrials) = nan;  % set initiation RT to nan to indicate that this is the first response
    taskData.initialTendency(1:nTrials) = nan;  % set initial tendency of mouse movement
    taskData.block(1:nTrials) = 1; % block number
    taskData.allShieldSize(1:nTrials) = rad2deg(2*sqrt(1/12)); % shield size
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
    txt = 'Je mehr Konfetti Sie im Eimer fangen, desto mehr Punkte erhalten Sie.';
    al_introduceShield(taskParam, taskData, win, current_trial, txt, xyExp, taskData.dotCol(current_trial).rgb, dotSize); %taskData.dotCol(currTrial).rgb;

    % 6. Introduce practice blocks
    % ----------------------------

    % Display instructions
    header = '';
    txt = 'Im Folgenden durchlaufen Sie zwei Übungsdurchgänge\nund im Anschluss zwei Durchgänge des Experiments.';
    feedback = true; % present text centrally
    al_bigScreen(taskParam, header, txt, feedback);

    % 7. Introduce variability of the confetti cannon
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
    taskParam.trialflow.exp = 'practVis';

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

    % 8. Introduce hidden confetti cannon
    % -----------------------------------

    % Display instructions
    header = 'Zweiter Übungsdurchgang';
    txt = ['In diesem Übungsdurchgang ist die Konfetti-Kanone nicht mehr sichtbar. Anstelle der Konfetti-Kanone sehen Sie dann ein Kreuz. '...
        'Außerdem sehen Sie, wo das Konfetti hinfliegt.\n\nUm weiterhin viel Konfetti zu fangen, müssen Sie aufgrund '...
        'der Flugposition einschätzen, auf welche Stelle die Konfetti-Kanone aktuell zielt.\n\nIm ersten Übungsblock schießt die '...
        'Konfetti-Kanone immer buntes Konfetti. Im zweiten Übungsblock schießt die Kanone nur rotes und grünes Konfetti. '];
    feedback = false;
    al_bigScreen(taskParam, header, txt, feedback);


    % 9. Introduce difference between the two task conditions
    % -------------------------------------------------------

    if cBal == 1

        % Adjust trialflow
        taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore...
        taskParam.trialflow.confetti = 'show confetti cloud'; ... but confetti cloud instead

        % Standard task first...
        % ----------------------

        % Display instructions
        txt = ['Um im ersten Block so viel wie möglich zu fangen, steuern Sie den Eimer auf die Position, wo Sie das Ziel der Konfetti-Kanone vermuten. '...
          'Wenn Sie denken, dass die Konfetti-Kanone ihre Richtung geändert hat, sollten Sie auch den Eimer dorthin bewegen.'];
        feedback = false;
        al_bigScreen(taskParam, header, txt, feedback);

        % Turn on standard confetti condition
        taskParam.trialflow.reward = 'standard';
        taskParam.trialflow.exp = 'practHidColor';
        taskParam.gParam.saveName = 'standard';

        % Task-data-object instance
        taskData = al_taskDataMain(taskParam.gParam.practTrials, taskParam.gParam.taskType);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration, taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration, taskParam.gParam.safe);

        % Run task
        al_indicateReward(taskParam)
        al_confettiLoop(taskParam, 'practice', taskData, taskParam.gParam.practTrials);

        % ... asymmetric-reward task second
        % ---------------------------------

        % Display instructions
        txt = ['Im zweiten Block schießt die Konfetti-Kanone nur rotes und grünes Konfetti. Für jedes eingefangene grüne Konfetti gewinnen Sie einen '...
          'Punkt, für jedes rote Konfetti verlieren Sie einen Punkt. Der Anteil von rotem und grünem Konfetti ändert sich, je weiter der aktuelle Schuss '...
          'nach rechts oder links von der mittleren Schussrichtung der Kanone abweicht. Wenn Sie mehr grünes als rotes Konfetti fangen, gewinnen Sie im aktuellen '...
          'Durchgang; wenn Sie mehr rotes als grünes Konfetti fangen, verlieren Sie.\n\nJe weiter Sie den Eimer von der mittleren Schussrichtung der '...
          'Konfetti-Kanone entfernen, desto seltener wird der Schuss Ihren Eimer treffen, aber wenn dann die Seite stimmt, überwiegt das grüne Konfetti und '...
          'Sie gewinnen. Bei der Positionierung des Eimers muss man sich demnach entscheiden, ob man lieber häufig einen kleinen Gewinn anstrebt. Dann steuern '...
          'Sie den Eimer dahin, wo Sie das Ziel der Kanone vermuten. Oder ob man lieber selten eine größeren Gewinn anstrebt. In diesem Fall steuern Sie den '...
          'Eimer auf die Seite mit viel grünem Konfetti.\n\nAuch in diesem Block kann sich die Richtung der Konfetti-Kanone verändern, es kann sich aber auch ' ...
          'die Seite ändern, auf der mehr grünes Konfetti verschossen wird.\n\n'...
          'Beachten Sie in beiden Blöcken, dass Sie das Konfetti trotz guter Vorhersagen häufig nicht '...
          'vollständig fangen können!'];
        feedback = false;
        al_bigScreen(taskParam, header, txt, feedback);

        % Turn on asymmetric confetti condition
        taskParam.trialflow.reward = 'asymmetric';
        taskParam.trialflow.exp = 'practHidAsym';
        taskParam.gParam.saveName = 'asymmetric';

        % TaskData-object instance
        taskData = al_taskDataMain(taskParam.gParam.practTrials, taskParam.gParam.taskType);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration, taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration, taskParam.gParam.safe);

        % Run task
        al_indicateReward(taskParam)
        al_confettiLoop(taskParam, 'practice', taskData, taskParam.gParam.practTrials);


    elseif cBal == 2

        al_indicateCondition(taskParam, 'cBal = 2 not yet implemented')

    end

else

    al_indicateCondition(taskParam, 'day = 2 not yet implemented')

end

% 10. Instructions experimental blocks
% ------------------------------------

header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Wie in der Übung werden Sie im ersten Block mit einer Konfetti-Kanone spielen, die immer buntes '...
    'Konfetti verschießt. Hier fangen Sie das meiste Konfetti, wenn Sie den Eimer (violetter Punkt) auf die Stelle bewegen, auf die die Konfetti-Kanone zielt. '...
    'Weil Sie die Konfetti-Kanone meistens nicht mehr sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Konfettiwolken einschätzen. '...
    'Im zweiten Block kommt eine Kanone, die nur grünes oder rotes Konfetti verschießt, was zu Gewinnen und Verlusten führt.\n\nBeachten Sie in beiden Blöcken, '...
    'dass Sie das Konfetti trotz guter Vorhersagen auch häufig nicht fangen können. \n\nIn wenigen Fällen werden Sie die Konfetti-Kanone zu sehen bekommen.\n\n'...
    'In jedem Block gibt es 2 kurze Pausen.\n\nViel Erfolg!'];

feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);

end