function al_HamburgEEGInstructions(taskParam)
%AL_HAMBURGINSTRUCTIONS This functio,,n runs the instructions for the
% "Hamburg" version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       ~

% Extract test day and cBal variables (relevant for later)
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
taskData.allASS(1:nTrials) = rad2deg(2*sqrt(1/12)); % shield size 
% taskParam.gParam.concentration TODO: Adjust to new noise conditions
taskData.shieldType(1:nTrials) = 1; % shield color
taskData.distMean = [300, 240, 300, 65]; % aim of the cannon
taskData.outcome = taskData.distMean; % in practice phase, mean and outcome are the same
taskData.pred(1:nTrials) = nan; % initialize predictions
taskData.nParticles(1:nTrials) = taskParam.cannon.nParticles; % number of confetti particles
taskData.greenCaught(1:nTrials) = nan; % we don't deal with asymmetric rewards here
taskData.redCaught(1:nTrials) = nan;
for t = 1:nTrials  % determine random colors for each trial
    taskData.dotCol(t).rgb = uint8(round(rand(3, taskParam.cannon.nParticles)*255));
end

% Introduce cannon
current_trial = 1;
txt = ['Du blickst von oben auf eine Konfetti-Kanone, die in der Mitte eines Kreises positioniert ist. Deine Aufgabe ist es, das Konfetti mit einem Eimer zu fangen. Mit dem violetten '...
    'Punkt kannst Du angeben, wo auf dem Kreis Du Deinen Eimer platzieren möchten, um das Konfetti zu fangen. Du kannst den Punkt mit der '...
    'Maus steuern.'];
taskParam = al_introduceCannon(taskParam, taskData, current_trial, txt);

% 3. Introduce confetti
% ---------------------

current_trial = 2; % update trial number
txt = 'Das Ziel der Konfetti-Kanone wird mit der schwarzen Linie angezeigt. Drücke die linke Maustaste, damit die Konfetti-Kanone schießt.';
[taskData, taskParam] = al_introduceConfetti(taskParam, taskData, current_trial, txt);

% 4. Introduce prediction spot and ask participant to catch confetti
% ------------------------------------------------------------------

% Add tickmarks to introduce them to participant
taskParam.trialflow.currentTickmarks = 'show';
current_trial = 3; % update trial number


% Repeat as long as subject misses confetti
while 1

    txt=['Der schwarze Strich zeigt Dir die mittlere Position der letzten Konfettiwolke. Der violette Strich zeigt Dir die '...
        'Position Deines letzten Eimers. Steuere den violetten Punkt jetzt bitte auf das Ziel der Konfetti-Kanone und drücke die linke Maustaste.'];
    [taskData, taskParam, xyExp, dotSize] = al_introduceSpot(taskParam, taskData, current_trial, txt);

    % If it is a miss, repeat instruction
    if abs(taskData.predErr(current_trial)) >= taskParam.gParam.practiceTrialCriterionEstErr
        header = 'Leider nicht gefangen!';
        txt = 'Du has leider zu wenig Konfetti gefangen. Versuche es noch mal!';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% 5. Introduce shield
% -------------------

win = true; % color of shield when catch is rewarded
txt = 'Wenn Du mindestens die Hälfte des Konfettis im Eimer fängst, zählt es als Treffer und Du erhälst eine Belohnung.';
taskData = al_introduceShield(taskParam, taskData, win, current_trial, txt, xyExp, taskData.dotCol(current_trial).rgb, dotSize);

% 6. Ask participant to miss confetti
% -----------------------------------

% Update trial number
current_trial = 4;

% Repeat as long as subject catches confetti
while 1

    % Introduce miss with bucket
    txt = 'Versuche nun Deinen Eimer so zu positionieren, dass Du das Konfetti verfehlst. Drücke dann die linke Maustaste.';
    [taskData, taskParam, xyExp, dotSize] = al_introduceShieldMiss(taskParam, taskData, current_trial, txt);

    % If it is a hit, repeat instruction
    if abs(taskData.predErr(current_trial)) <= taskParam.gParam.practiceTrialCriterionEstErr*2 % make sure that miss is really obvious

        WaitSecs(0.5)
        header = 'Leider gefangen!';
        txt = 'Du hast zu viel Konfetti gefangen. Versuche bitte, das Konfetti zu verfehlen!';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);  % todo: code needs to be re-organized
    else
        break
    end

end

% 7. Confirm that confetti was missed
% -------------------------------------
win = true;
txt = 'In diesem Fall hast Du das Konfetti verfehlt.';
al_confirmMiss(taskParam, taskData, win, current_trial, txt, xyExp, taskData.dotCol(current_trial).rgb, dotSize);

% 8. Introduce practice blocks
% ----------------------------

% Display instructions
header = '';
txt='Im Folgenden durchläufst Du zwei Übungsdurchgänge\nund im Anschluss zwei Durchgänge des Experiments.';
feedback = true; % present text centrally
al_bigScreen(taskParam, header, txt, feedback);

% 9. Introduce variability of the confetti cannon
% -----------------------------------------------

% Display instructions
header = 'Erster Übungsdurchgang';
txt=['Weil die Konfetti-Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. Das heißt, auch wenn '...
    'Du genau auf das Ziel gehst, kannst Du das Konfetti verfehlen. Die Ungenauigkeit ist zufällig, '...
    'dennoch fängst du am meisten Konfetti, wenn Du den violetten Punkt genau auf die Stelle '...
    'steuerst, auf die die Konfetti-Kanone zielt.\n\nIn dieser Übung sollst Du mit der Ungenauigkeit '...
    'der Konfetti-Kanone erst mal vertraut werden. Steuere den violetten Punkt bitte immer auf die anvisierte '...
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
        txt = ['Du hast Deinen Eimer oft neben dem Ziel der Kanone platziert. Versuche im nächsten '...
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
txt = ['In diesem Übungsdurchgang ist die Konfetti-Kanone nicht mehr sichtbar. Anstelle der Konfetti-Kanone siehst Du dann ein Kreuz. '...
    'Außerdem siehst Du nicht mehr wie das Konfetti fliegt, sondern nur noch, wo es landet.\n\nUm weiterhin viel Konfetti zu fangen, musst Du aufgrund '...
    'der Landeposition einschätzen, auf welche Stelle die Konfetti-Kanone aktuell zielt und den Eimer auf diese Position '...
    'steuern. Wenn Du denkst, dass die Konfetti-Kanone ihre Richtung geändert hat, solltest Du auch den Eimer '...
    'dorthin bewegen.\n\nIn der folgenden Übung wirst Du in einem Block für Deine Leistung Geld gewinnen '...
    'und in einem anderen Block von Freund:innen für Deine Leistung beurteilt werden. Beachte in beiden Fällen, dass Du das Konfetti trotz '...
    'guter Vorhersagen auch häufig nicht fangen kannst.'];
feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

if cBal == 1

    % Monetary reward first...
    % ------------------------

    taskParam.trialflow.reward = "monetary";
    taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore

    % TaskData-object instance
    taskData = al_taskDataMain(taskParam.gParam.practTrials);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskData, taskParam.gParam.practTrials); % todo: here and in other practice blocks: 'main' -> 'practice'?

    % ... social reward second
    % ------------------------

    % Turn on social condition
    taskParam.trialflow.reward = "social";

    % TaskData-object instance
    taskData = al_taskDataMain(taskParam.gParam.practTrials);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);
    
    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskData, taskParam.gParam.practTrials);

else

    % Social reward first...
    % ----------------------

    taskParam.trialflow.reward = "social";
    taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore
    
    % TaskData-object instance
    taskData = al_taskDataMain(taskParam.gParam.practTrials);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);
    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskData, taskParam.gParam.practTrials);

    % ... monetary reward second
    % --------------------------

    taskParam.trialflow.reward = "monetary";

    % TaskData-object instance
    taskData = al_taskDataMain(taskParam.gParam.practTrials);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration, taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);
    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskData, taskParam.gParam.practTrials);

end

% 11. Instructions experimental blocks
% ------------------------------------

header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz zusammengefasst fängst Du also das meiste Konfetti, '...
    'wenn Du den Eimer (violetter Punkt) auf die Stelle bewegst, auf die die Konfetti-Kanone zielt. Weil Du die Konfetti-Kanone meistens nicht mehr '...
    'sehen kannst, musst Du diese Stelle aufgrund der Position der letzten Konfettiwolken einschätzen. Beachten, dass Du das Konfetti trotz '...
    'guter Vorhersagen auch häufig nicht fangen kannst. \n\nIn wenigen Fällen wirst Du die Konfetti-Kanone zu sehen bekommen und kannst Deine Leistung '...
    'verbessern, indem Du den Eimer genau auf das Ziel steuerst.\n\n'...
    'Du wirst wie in der Übung zwei Blöcke spielen. In jedem Block gibt es 3 kurze Pausen.\n\nViel Erfolg!'];

feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);

end