function al_commonConfettiInstructions(taskParam)
%AL_COMMONCONFETTIINSTRUCTIONS This function runs the instructions for the
% Hamburg version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       ~

% Extract cBal variable
cBal = taskParam.subject.cBal;

% Adjust trialflow
taskParam.trialflow.cannon = 'show cannon'; % cannon will be displayed
taskParam.trialflow.currentTickmarks = 'hide'; % tick marks initially not shown
taskParam.trialflow.push = 'practiceNoPush'; % turn off push manipulation
taskParam.trialflow.shot = 'animate cannonball'; % in instructions, we animate the confetti
taskParam.trialflow.colors = 'colorful';

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% 1. Present welcome message
% --------------------------

al_indicateCondition(taskParam, 'Herzlich Willkommen Zur Konfetti-Kanonen-Aufgabe!')

% Reset background to gray
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% 2. Introduce the cannon
% -----------------------

% Load task-data-object instance
nTrials = 4;
taskData = al_taskDataMain(nTrials, taskParam.gParam.taskType);

% Generate practice-phase data
taskData.catchTrial(1:nTrials) = 0; % no catch trials
taskData.initiationRTs(1:nTrials) = nan;  % set initiation RT to nan to indicate that this is the first response
taskData.initialTendency(1:nTrials) = nan;  % set initial tendency of mouse movement
taskData.block(1:nTrials) = 1; % block number
taskData.allShieldSize(1:nTrials) = rad2deg(2*sqrt(1/12)); % shield size  taskParam.gParam.concentration TODO: Adjust to new noise conditions
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
currTrial = 1;
txt = ['Sie blicken von oben auf eine Konfetti-Kanone, die in der Mitte eines Kreises positioniert ist. Ihre Aufgabe ist es, das Konfetti mit einem Eimer zu fangen. Mit dem rosafarbenen '...
    'Punkt können Sie angeben, wo auf dem Kreis Sie Ihren Eimer platzieren möchten, um das Konfetti zu fangen. Sie können den Punkt mit der '...
    'Maus steuern.'];
taskParam = al_introduceCannon(taskParam, taskData, currTrial, txt);

% 3. Introduce confetti
% ---------------------

currTrial = 2; % update trial number
txt = 'Das Ziel der Konfetti-Kanone wird mit der schwarzen Linie angezeigt. Drücken Sie die linke Maustaste, damit die Konfetti-Kanone schießt.';
[taskData, taskParam] = al_introduceConfetti(taskParam, taskData, currTrial, txt);

% 4. Introduce prediction spot and ask participant to catch confetti
% ------------------------------------------------------------------

% Add tickmarks to introduce them to participant
taskParam.trialflow.currentTickmarks = 'show';
currTrial = 3; % update trial number

% Repeat as long as subject misses confetti
while 1

    txt=['Der schwarze Strich zeigt Ihnen die mittlere Position der letzten Konfettiwolke. Der rosafarbene Strich zeigt Ihnen die '...
        'Position Ihres letzten Eimers. Steuern Sie den rosa Punkt jetzt bitte auf das Ziel der Konfetti-Kanone und drücken Sie die linke Maustaste.'];
    %[taskData, taskParam, xyExp, dotCol, dotSize] = al_introduceSpot(taskParam, taskData, currTrial, txt);
    [taskData, taskParam, xyExp, dotSize] = al_introduceSpot(taskParam, taskData, currTrial, txt);

    % If it is a miss, repeat instruction
    if abs(taskData.predErr(currTrial)) >= taskParam.gParam.practiceTrialCriterionEstErr
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
txt = 'Wenn Sie mindestens die Hälfte des Konfettis im Eimer fangen, zählt es als Treffer und Sie erhalten einen Punkt.';
taskData = al_introduceShield(taskParam, taskData, win, currTrial, txt, xyExp, taskData.dotCol(currTrial).rgb, dotSize);

% 6. Ask participant to miss confetti
% -----------------------------------

% Update trial number
currTrial = 4;

% Repeat as long as subject catches confetti
while 1

    % Introduce miss with bucket
    txt = 'Versuchen Sie nun Ihren Eimer so zu positionieren, dass Sie das Konfetti verfehlen. Drücken Sie dann die linke Maustaste.';
    [taskData, taskParam, xyExp, dotSize] = al_introduceShieldMiss(taskParam, taskData, currTrial, txt);

    % If it is a hit, repeat instruction
    if abs(taskData.predErr(currTrial)) <= taskParam.gParam.practiceTrialCriterionEstErr*2 % make sure that miss is really obvious

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
al_confirmMiss(taskParam, taskData, win, currTrial, txt, xyExp, taskData.dotCol(currTrial).rgb, dotSize);

% 8. Introduce practice blocks
% ----------------------------

% Display instructions
header = '';
txt = 'Im Folgenden durchlaufen Sie zwei Übungsdurchgänge\nund im Anschluss zwei Durchgänge des Experiments.';
feedback = true; % present text centrally
al_bigScreen(taskParam, header, txt, feedback);

% 9. Introduce variability of the confetti cannon
% -----------------------------------------------

% Display instructions
header = 'Erster Übungsdurchgang';
txt=['Weil die Konfetti-Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. Das heißt, auch wenn '...
    'Sie genau auf das Ziel gehen, können Sie das Konfetti verfehlen. Die Ungenauigkeit ist zufällig, '...
    'dennoch fangen Sie am meisten Konfetti, wenn Sie den rosanen Punkt genau auf die Stelle '...
    'steuern, auf die die Konfetti-Kanone zielt.\n\nIn dieser Übung sollen Sie mit der Ungenauigkeit '...
    'der Konfetti-Kanone erst mal vertraut werden. Steuern Sie den rosanen Punkt bitte immer auf die anvisierte '...
    'Stelle.'];
feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);

% Load outcomes for practice
condition = 'practice';
taskData = load('visCannonPracticeHamburg.mat');
taskData = taskData.taskData;
%taskParam.condition = condition;
taskParam.trialflow.exp = 'practVis';
taskParam.trialflow.shieldAppearance = 'full';

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
% ------------------------------------

% Display instructions
header = 'Zweiter Übungsdurchgang';
txt = ['In diesem Übungsdurchgang ist die Konfetti-Kanone nicht mehr sichtbar. Anstelle der Konfetti-Kanone sehen Sie dann einen Punkt. '...
    'Außerdem sehen Sie, wo das Konfetti hinfliegt.\n\nUm weiterhin viel Konfetti zu fangen, müssen Sie aufgrund '...
    'der Flugposition einschätzen, auf welche Stelle die Konfetti-Kanone aktuell zielt und den Eimer auf diese Position '...
    'steuern. Wenn Sie denken, dass die Konfetti-Kanone ihre Richtung geändert hat, sollten Sie auch den Eimer '...
    'dorthin bewegen.\n\nIn der folgenden Übung werden Sie es sowohl mit einer relativ genauen '...
    'als auch einer eher ungenauen Konfetti-Kanone zu tun haben. Beachten Sie, dass Sie das Konfetti trotz '...
    'guter Vorhersagen auch häufig nicht fangen können.'];
feedback = false;
al_bigScreen(taskParam, header, txt, feedback);


% Display instructions
header = 'Zweiter Übungsdurchgang';
txt = ['Außerdem sehen Sie das Spiel ab jetzt ohne Animationen und mit weniger bunten Farben. Ihr Eimer wird jetzt durch zwei Striche ' ...
    'dargestellt. Wie in der vorherigen Übung zählt es als Treffer, wenn mindestens die Hälfte der Konfetti-Wolke im Eimer gefangen wurde.\n\n'...
    'Dies ist notwendig, damit wir Ihre Pupillengröße gut messen können. Achten Sie daher bitte besonders darauf, '...
    'Ihren Blick auf den Punkt in der Mitte des Kreises zu fixieren. Bitte versuchen Sie Augenbewegungen und Blinzeln '...
    'so gut es geht zu vermeiden.'];
feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shot = 'static';
taskParam.trialflow.exp = 'practHid';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors);

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



% 11. Instructions experimental blocks
% ------------------------------------

header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst fangen Sie also das meiste Konfetti, '...
    'wenn Sie den Eimer (rosafarbener Punkt) auf die Stelle bewegen, auf die die Konfetti-Kanone zielt. Weil Sie die Konfetti-Kanone meistens nicht mehr '...
    'sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Konfettiwolken einschätzen. Beachten Sie, dass Sie das Konfetti trotz '...
    'guter Vorhersagen auch häufig nicht fangen können. \n\nIn wenigen Fällen werden Sie die Konfetti-Kanone zu sehen bekommen und können Ihre Leistung '...
    'verbessern, indem Sie den Eimer genau auf das Ziel steuern.\n\n'...
    'Sie werden wie in der Übung zwei Blöcke spielen. In jedem Block gibt es 3 kurze Pausen.\n\nViel Erfolg!'];

feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);

end