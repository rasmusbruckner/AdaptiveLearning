function al_LeipzigInstructions(taskParam)
%AL_LEIPZIGINSTRUCTIONS This function runs the instructions for the
% Leipzig version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None


% Adjust trialflow
taskParam.trialflow.cannon = 'show cannon'; % cannon will be displayed
taskParam.trialflow.currentTickmarks = 'hide'; % tick marks initially not shown
taskParam.trialflow.push = 'practiceNoPush'; % turn off push manipulation

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% 1. Present welcome message
% --------------------------

al_indicateCondition(taskParam, 'Herzlich Willkommen Zum Pandemie-Spiel!')

% Reset background to gray
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);

% Display instructions
header = 'Achtung Virusausbruch!';
txt=['In Ihrer Region ist ein lebensbedrohliches Virus ausgebrochen. Das ganze Gebiet wurde deshalb\n'...
    'von der Umgebung abgeschottet. Da kein direkter Kontakt mit der Außenwelt mehr möglich ist, '...
    'werden Medikamente von Hubschraubern abgeworfen.\n\nSie arbeiten als Koordinationsleitung des Katastrophenschutzes '...
    'und sind für die Entgegennahme der Güter auf dem Boden verantwortlich. Da der Hubschrauber die Medikamente aus '...
    'großer Höhe abwirft, kann der Landungsort nie genau vorhergesagt werden. Werden die überlebenswichtigen '...
    'Medikamente nicht direkt in Empfang genommen, verlieren sie ihre Wirksamkeit und es können weniger Menschen '...
    'versorgt werden.\n\nIhre Aufgabe ist es, Ihr Team immer dorthin zu schicken, wo Sie den Landungsort vermuten. '...
    'Versagen Sie, hat dies weitere Todesfälle zur Folge!​'];
feedback = false; % present text centrally
al_bigScreen(taskParam, header, txt, feedback);

% 2. Introduce the helicopter
% ---------------------------

% Load taskData-object instance
nTrials = 4;
taskData = al_taskDataMain(nTrials, taskParam.gParam.taskType);

% Generate practice-phase data
taskData.catchTrial(1:nTrials) = 0; % no catch trials
taskData.initiationRTs(1:nTrials) = nan; % set initiation RT to nan to indicate that this is the first response
taskData.initialTendency(1:nTrials) = nan; % set initial tendency of mouse movement
taskData.block(1:nTrials) = 1; % block number
taskData.allShieldSize(1:nTrials) = rad2deg(2*sqrt(1/12)); % shield size TODO: Adjust to new noise conditions
taskData.shieldType(1:nTrials) = 1; % shield color
taskData.distMean = [300, 240, 300, 65]; % aim of the helicopter
taskData.outcome = taskData.distMean; % in practice phase, mean and outcome are the same
taskData.pred(1:nTrials) = nan; % initialize predictions

% Introduce helicopter
currTrial = 1;
txt = ['Sie blicken von oben auf das Gefahrengebiet und den Hubschrauber, der die Medikamente abwirft. Ihre Aufgabe ist es, die Medikamente mit einem Eimer zu fangen. Mit dem violetten '...
    'Punkt können Sie angeben, wo auf dem Kreis Sie Ihren Eimer platzieren möchten, um die Medikamente zu fangen. Sie können den Punkt mit der Maus steuern.'];
taskParam = al_introduceCannon(taskParam, taskData, currTrial, txt);

% 3. Introduce supply items
% -------------------------

currTrial = 2; % update trial number
txt = 'Das Ziel des Hubschraubers wird mit der roten Linie angezeigt. Drücken Sie die linke Maustaste, damit der Hubschrauber die Medikamente abwirft.';
[taskData, taskParam] = al_introduceHelicopter(taskParam, taskData, currTrial, txt);

% 4. Introduce prediction spot and ask participant to catch supplies
% ------------------------------------------------------------------

% Add tickmarks to introduce them to participant
taskParam.trialflow.currentTickmarks = 'show';
currTrial = 3; % update trial number

% Repeat as long as subject misses supply items
while 1

    txt=['Der schwarze Strich zeigt Ihnen die mittlere Position der letzten Medikamente. Der violette Strich zeigt Ihnen die '...
        'Position Ihres letzten Eimers. Steuern Sie den violetten Punkt jetzt bitte auf das Ziel des Hubschraubers und drücken Sie die linke Maustaste.'];
    [taskData, taskParam, xyExp] = al_introduceSpot(taskParam, taskData, currTrial, txt);

    % If it is a miss, repeat instruction
    if abs(taskData.predErr(currTrial)) >= taskParam.gParam.practiceTrialCriterionEstErr
        header = 'Leider nicht gefangen!';
        txt = 'Sie haben leider zu wenige Medikamente gefangen. Versuchen Sie es noch mal!';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% 5. Introduce shield
% -------------------

txt = 'Wenn Sie mindestens die Hälfte der Medikamente im Eimer fangen, zählt es als Rettung und Sie erhalten einen Punkt.';
taskData = al_introduceHelicopterBucket(taskParam, taskData, currTrial, txt, xyExp);

% 6. Ask participant to miss supplies
% -----------------------------------

% Update trial number
currTrial = 4;

% Repeat as long as subject catches supplies
while 1

    % Introduce miss with bucket
    txt = 'Versuchen Sie nun Ihren Eimer so zu positionieren, dass Sie die Medikamente verfehlen. Drücken Sie dann die linke Maustaste.';
    [taskData, taskParam, xyExp] = al_introduceShieldMiss(taskParam, taskData, currTrial, txt);

    % If it is a hit, repeat instruction
    if abs(taskData.predErr(currTrial)) <= taskParam.gParam.practiceTrialCriterionEstErr*2 % make sure that miss is really obvious

        WaitSecs(0.5)
        header = 'Leider gefangen!';
        txt = 'Sie haben zu viele Medikamente gefangen. Versuchen Sie bitte, die Medikamente zu verfehlen!';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);  % todo: code needs to be re-organized
    else
        break
    end

end

% 7. Confirm that outcome was missed
% -------------------------------------
txt = 'In diesem Fall haben Sie die Medikamente verfehlt.';
al_confirmHelicopterMiss(taskParam, taskData, currTrial, txt, xyExp);

% 8. Introduce practice blocks
% ----------------------------

% Display instructions
header = '';
txt = 'Im Folgenden durchlaufen Sie zwei Übungsdurchgänge\nund im Anschluss zwei Durchgänge des Experiments.';
feedback = true; % present text centrally
al_bigScreen(taskParam, header, txt, feedback);

% 9. Introduce variability of the environment
% -------------------------------------------

% Display instructions
header = 'Erster Übungsdurchgang';
txt=['Weil die Umgebung sehr windig ist, ist der Landeort der Medikamente ziemlich ungenau. Das heißt, auch wenn '...
    'Sie genau auf das Ziel gehen, können Sie die Medikamente verfehlen. Die Ungenauigkeit ist zufällig, '...
    'dennoch fangen Sie die meisten Medikamente, wenn Sie den violetten Punkt genau auf die Stelle '...
    'steuern, die der Hubschrauber anpeilt.\n\nIn dieser Übung sollen Sie mit der Ungenauigkeit '...
    'des Hubschraubers erst mal vertraut werden. Steuern Sie den violetten Punkt bitte immer auf die anvisierte '...
    'Stelle.'];
feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);

% Load outcomes for practice
condition = 'practice';
taskData = load('visCannonPracticeHamburg.mat');
taskData = taskData.taskData;
%taskParam.condition = condition;
taskParam.trialflow.exp = 'practVis';
taskData.initialTendency = nan(length(taskData.ID), 1);

% Reset roation angle to starting location
taskParam.circle.rotAngle = 0;

% Run task
while 1

    % Task loop
    al_LeipzigLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);

    % If estimation error is larger than a criterion on more than five
    % trials, we repeat the instructions
    repeatBlock = sum(abs(taskData.estErr) >= taskParam.gParam.practiceTrialCriterionEstErr);
    if sum(repeatBlock) > taskParam.gParam.practiceTrialCriterionNTrials
        WaitSecs(0.5)
        header = 'Bitte noch mal probieren!';
        txt = ['Sie haben Ihren Eimer oft neben dem Ziel des Hubschraubers platziert. Versuchen Sie im nächsten '...
            'Durchgang bitte, den Eimer direkt auf das Ziel zu steuern. Das Ziel wird mit dem roten Strich gezeigt.'];
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end

end

% 10. Introduce hidden helicopter
% -------------------------------

% Display instructions
header = 'Zweiter Übungsdurchgang';
txt = ['In diesem Übungsdurchgang ist der Hubschrauber leider nicht mehr sichtbar. Anstelle des Hubschraubers sehen Sie dann ein Kreuz. '...
    'Außerdem sehen Sie, wo die Medikamente abgeworfen werden.\n\nUm weiterhin viele Medikamente zu fangen, müssen Sie aufgrund '...
    'der Flugposition einschätzen, auf welche Stelle der Hubschrauber aktuell zielt und den Eimer auf diese Position '...
    'steuern. Wenn Sie denken, dass der Hubschrauber sein Ziel geändert hat, sollten Sie auch den Eimer '...
    'dorthin bewegen.\n\nIn der folgenden Übung werden Sie es sowohl mit einer relativ ruhigen (wenig Wind) '...
    'als auch einer sehr stürmischen Umgebung (viel Wind) zu tun haben. Beachten Sie, dass Sie die Medikamente trotz '...
    'guter Vorhersagen auch häufig nicht fangen können.'];
feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

 taskParam.trialflow.exp = 'practHid';

% Low noise first...
% ------------------

% Get data
taskData = load('hidCannonPracticeHamburg_c16.mat');
taskData = taskData.taskData;

% Run task
taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore
taskParam.trialflow.confetti = 'none';
al_indicateHelicopterNoise(taskParam, 'lowNoise')
al_LeipzigLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);

% ... high noise second
% ---------------------

% Get data
taskData = load('hidCannonPracticeHamburg_c8.mat');
taskData = taskData.taskData;

% Run task
al_indicateHelicopterNoise(taskParam, 'highNoise')
al_LeipzigLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);

% 11. Instructions experimental blocks
% ------------------------------------

header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst fangen Sie also die meisten Medikamente, '...
    'wenn Sie den Eimer (violetter Punkt) auf die Stelle bewegen, die der Hubschrauber anpeilt. Weil Sie den Hubschrauber meistens nicht mehr '...
    'sehen können, müssen Sie diese Stelle aufgrund der Position der vorherigen Medikamente einschätzen. Beachten Sie, dass Sie die Medikamente trotz '...
    'guter Vorhersagen auch häufig nicht fangen können. \n\nIn wenigen Fällen werden Sie den Hubschrauber zu sehen bekommen und können Ihre Leistung '...
    'verbessern, indem Sie den Eimer genau auf das Ziel steuern.\n\n'...
    'Sie werden wie in der Übung zwei Blöcke spielen. In jedem Block gibt es 3 kurze Pausen.\n\nViel Erfolg!'];

feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);

end