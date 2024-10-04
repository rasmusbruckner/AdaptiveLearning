function al_commonConfettiInstructions(taskParam)
%AL_COMMONCONFETTIINSTRUCTIONS This function runs the instructions for the
% Hamburg version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None

% Extract cBal variable
cBal = taskParam.subject.cBal;

% Adjust trialflow
taskParam.trialflow.cannon = 'show cannon'; % cannon will be displayed
taskParam.trialflow.currentTickmarks = 'hide'; % tick marks initially not shown
taskParam.trialflow.push = 'practiceNoPush'; % turn off push manipulation
taskParam.trialflow.shot = 'animate cannonball'; % in instructions, we animate the confetti
taskParam.trialflow.colors = 'colorful';
taskParam.trialflow.exp = 'pract'; % ensure that no triggers are sent during practice
taskParam.trialflow.saveData = 'false';
taskParam.trialflow.saveEtData = 'false';

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% 1. Present welcome message
% --------------------------

if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.welcomeText;
else
    txt = 'Herzlich Willkommen Zur Konfetti-Kanonen-Aufgabe!';
end
al_indicateCondition(taskParam, txt);

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
taskParam.unitTest.pred = [300, 0, 300, 0];

% Introduce cannon
if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.introduceCannon;
else
    txt = ['Sie blicken von oben auf eine Konfetti-Kanone, die in der Mitte eines Kreises positioniert ist. Ihre Aufgabe ist es, das Konfetti mit einem Eimer zu fangen. Mit dem rosafarbenen '...
        'Punkt können Sie angeben, wo auf dem Kreis Sie Ihren Eimer platzieren möchten, um das Konfetti zu fangen. Sie können den Punkt mit der '...
        'Maus steuern.'];
end
currTrial = 1;
taskParam = al_introduceCannon(taskParam, taskData, currTrial, txt);

% 3. Introduce confetti
% ---------------------

if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.introduceConfetti;
else
    txt = 'Das Ziel der Konfetti-Kanone wird mit der schwarzen Linie angezeigt. Steuern Sie den rosafarbenen Punkt auf den Kreis und drücken Sie die linke Maustaste, damit die Konfetti-Kanone schießt.';
end
currTrial = 2; % update trial number
[taskData, taskParam] = al_introduceConfetti(taskParam, taskData, currTrial, txt);

% 4. Introduce prediction spot and ask participant to catch confetti
% ------------------------------------------------------------------

% Add tickmarks to introduce them to participant
taskParam.trialflow.currentTickmarks = 'show';
currTrial = 3; % update trial number

% Repeat as long as subject misses confetti
while 1

    if taskParam.gParam.customInstructions
        txt = taskParam.instructionText.introduceSpot;
    else
        txt = ['Der schwarze Strich zeigt Ihnen die mittlere Position der letzten Konfettiwolke. Der rosafarbene Strich zeigt Ihnen die '...
            'Position Ihres letzten Eimers. Steuern Sie den rosa Punkt jetzt bitte auf das Ziel der Konfetti-Kanone und drücken Sie die linke Maustaste.'];
    end

    [taskData, taskParam, xyExp, dotSize] = al_introduceSpot(taskParam, taskData, currTrial, txt);

    % If it is a miss, repeat instruction
    if abs(taskData.predErr(currTrial)) >= taskParam.gParam.practiceTrialCriterionEstErr

        if taskParam.gParam.customInstructions
            header = taskParam.instructionText.noCatchHeader;
            txt = taskParam.instructionText.noCatch;
        else
            header = 'Leider nicht gefangen!';
            txt = 'Sie haben leider zu wenig Konfetti gefangen. Versuchen Sie es noch mal!';
        end

        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% 5. Introduce shield
% -------------------

if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.introduceShield;
else
    txt = 'Wenn Sie mindestens die Hälfte des Konfettis im Eimer fangen, zählt es als Treffer und Sie erhalten einen Punkt.';
end

win = true; % color of shield when catch is rewarded
al_introduceShield(taskParam, taskData, win, currTrial, txt, xyExp, taskData.dotCol(currTrial).rgb, dotSize);

% 6. Introduce practice blocks
% ----------------------------

% Display instructions
if taskParam.gParam.customInstructions
    txt = taskParam.instructionText.introducePracticeSession;
else
    txt = 'Im Folgenden durchlaufen Sie ein paar Übungsdurchgänge\nund im Anschluss zwei Durchgänge des Experiments.';
end
header = '';
feedback = true; % present text centrally
al_bigScreen(taskParam, header, txt, feedback);

% 7. Cannon visible
% -----------------

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.firstPracticeHeader;
    txt = taskParam.instructionText.firstPractice;
else
    header = 'Erster Übungsdurchgang';
    txt=['Weil die Konfetti-Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. Das heißt, auch wenn '...
        'Sie genau auf das Ziel gehen, können Sie das Konfetti verfehlen. Die Ungenauigkeit ist zufällig, '...
        'dennoch fangen Sie am meisten Konfetti, wenn Sie den rosanen Punkt genau auf die Stelle '...
        'steuern, auf die die Konfetti-Kanone zielt.\n\nIn dieser Übung sollen Sie mit der Ungenauigkeit '...
        'der Konfetti-Kanone erst mal vertraut werden. Steuern Sie den rosanen Punkt bitte immer auf die anvisierte '...
        'Stelle.'];
end

feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);

% Load outcomes for practice
condition = 'practice';
taskData = load('visCannonPracticeHamburg.mat');
taskData = taskData.taskData;
taskData.saveAsStruct = true; % ensure that we save as struct
taskParam.trialflow.exp = 'practVis';
taskParam.trialflow.saveData = 'true';
taskParam.trialflow.shieldAppearance = 'full';

% Reset roation angle to starting location
taskParam.circle.rotAngle = 0;

% Update unit test predictions
taskParam.unitTest.pred = zeros(20,1);

% Initialize block counter
b = 1;

while 1

    % File name suffix
    file_name_suffix = sprintf('_b%i', b);

    % Task loop
    taskData = al_confettiLoop(taskParam, condition, taskData, taskParam.gParam.practTrialsVis, file_name_suffix);

    % If estimation error is larger than a criterion on more than five
    % trials, we repeat the instructions
    repeatBlock = sum(abs(taskData.estErr) >= taskParam.gParam.practiceTrialCriterionEstErr);
    if (sum(repeatBlock) > taskParam.gParam.practiceTrialCriterionNTrials) && taskParam.unitTest.run == false
        WaitSecs(0.5)
        if taskParam.gParam.customInstructions
            header = taskParam.instructionText.practiceBlockFailHeader;
            txt = taskParam.instructionText.practiceBlockFail;
        else
            header = 'Bitte noch mal probieren!';
            txt = ['Sie haben Ihren Eimer oft neben dem Ziel der Kanone platziert. Versuchen Sie im nächsten '...
                'Durchgang bitte, den Eimer direkt auf das Ziel zu steuern. Das Ziel wird mit der Nadel gezeigt.'];
        end

        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end

    % Update block counter
    b = b+1;
end

% 8. Reduce shield
% ----------------

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.reduceShieldHeader;
    txt = taskParam.instructionText.reduceShield;
else
    header = 'Illustration Ihres Eimers';
    txt = ['Ab jetzt sehen Sie den Eimer nur noch mit zwei Strichen dargestellt. Außerdem sehen Sie die Aufgabe in weniger Farben. ' ...
        'Dies ist notwendig, damit wir Ihre Pupillengröße gut messen können. Achten Sie daher bitte besonders darauf, '...
        'Ihren Blick auf den Punkt in der Mitte des Kreises zu fixieren. Bitte versuchen Sie Augenbewegungen und blinzeln '...
        'so gut es geht zu vermeiden.\n\n'...
        'Jetzt folgt zunächst eine kurze Demonstration, wie der Eimer mit Strichen im Vergleich zum Eimer der vorherigen Übung aussieht.'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

% Show reduced shield animation
taskData = struct();
taskData.allShieldSize = [20, 30, 15, 50, 10];
taskData.pred = [40, 190, 80, 1, 340];
taskParam.trialflow.colors = 'dark';
taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);
al_introduceReducedShield(taskParam, taskData, 5)

% 9. Illustrate and test if subject understands the idea of the cannon mean
% -------------------------------------------------------------------------

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.secondPracticeHeader;
    txt = taskParam.instructionText.secondPractice;
else
    header = 'Zweiter Übungsdurchgang';
    txt = ['Um sicherzugehen, dass Sie die Aufgabe verstanden haben, machen wir jetzt eine kurze Übung:\n\n'...
        'Sie werden hintereinander fünf Schüsse der Konfetti-Kanone sehen. Danach geben Sie bitte an, wo Sie das Ziel der Konfetti-Kanone vermuten.\n\n'...
        'Die beste Strategie ist, die mittlere Position der Schüsse anzugeben. Diese Position ist die beste Vohersage, um in der Aufgabe am meisten Konfetti zu fangen.'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

% TaskData-object instance
nTrials = taskParam.gParam.practTrialsHid; %20; % taskParam.gParam.passiveViewingPractTrials
taskData = al_taskDataMain(nTrials, taskParam.gParam.taskType);
haz = 0;
concentration = 12;

% Update trialflow
taskParam.trialflow.exp = 'cannonPract1';

% Initialize block counter
b = 1;

% Run task
while 1

    % File name suffix
    file_name_suffix = sprintf('_b%i', b);

    % Generate outcomes using cannon-data function using average concentration
    nRep = taskParam.gParam.practTrialsHid/taskParam.gParam.cannonPractNumOutcomes;
    endPoint = taskParam.gParam.practTrialsHid;
    taskParam.gParam.blockIndices = linspace(1, endPoint+1, nRep+1);
    taskParam.gParam.catchTrialProb = 0.0;
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    % Generate outcomes using confetti-data function
    taskData = taskData.al_confettiData(taskParam);

    % Run cannon practice
    testPassed = al_cannonPractice(taskParam, taskData, nTrials, file_name_suffix);

    % If estimation error was too large, we repeat the instructions
    if (sum(testPassed) < taskParam.gParam.cannonPractCriterion)  && taskParam.unitTest.run == false
        WaitSecs(0.5)
        if taskParam.gParam.customInstructions
            header = taskParam.instructionText.practiceBlockFailHeader;
            txt = taskParam.instructionText.practiceBlockFail;
        else
            header = 'Bitte noch mal probieren!';
            txt = ['Sie haben die Konfetti-Kanone nicht genau genug eingeschätzt. Versuchen Sie im nächsten '...
                'Durchgang bitte, den Mittelpunkt der einzelnen Schüsse auszuwählen. Bei Fragen, wenden Sie sich an die Versuchsleitung.'];
        end
        feedback = true;
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end

    % Update block counter
    b = b+1;
end

% Wait until keys released
KbReleaseWait();

% 11. Introduce hidden confetti cannon
% ------------------------------------

% Update condition
condition = 'cannonPract2';
taskParam.trialflow.exp = condition;

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.thirdPracticeHeader;
    txt = taskParam.instructionText.thirdPractice;
else
    header = 'Dritter Übungsdurchgang';
    txt = ['In dieser Übung sehen Sie nur noch einen Schuss der Konfetti-Kanone. Bitte geben Sie wieder an, wo Sie die Konfetti-Kanone vermuten.\n\nWenn Sie denken, dass die Konfetti-Kanone ihre Richtung geändert hat, sollten Sie auch den Eimer '...
        'dorthin bewegen.\n\nBeachten Sie, dass Sie das Konfetti trotz '...
        'guter Vorhersagen auch häufig nicht fangen können.'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

% Update trial flow
taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shot = 'static';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

% todo: think about potential criterion for this one as well

% Load data
taskData = load('cannonPractice.mat');
taskData = taskData.taskData;
taskData.saveAsStruct = true; % ensure that we save as struct

% Update trial flow
taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore
taskParam.trialflow.confetti = 'show confetti cloud';

% Run practice block
al_confettiLoop(taskParam, condition, taskData, taskParam.gParam.practTrialsHid);

% 11. Introduce hidden confetti cannon
% ------------------------------------

% Update condition
condition = 'main';

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.fourthPracticeHeader;
    txt = taskParam.instructionText.fourthPractice;
else
    header = 'Vierter Übungsdurchgang';
    txt = ['Jetzt kommen wir zur letzten Übung.\n\nDiesmal müssen Sie mit dem rosafarbenen Punkt Ihr Schild platzieren und sehen dabei die Kanone nicht mehr. Außerdem werden Sie es sowohl mit einer relativ genauen '...
        'als auch einer eher ungenauen versteckten Konfetti-Kanone zu tun haben.\n\n'...
        'Bitte versuchen Sie Augenbewegungen und blinzeln '...
        'so gut es geht zu vermeiden.'...
        '\n\nBeachten Sie bitte auch, dass das Ziel der Konfetti-Kanone in manchen Fällen sichtbar sein wird. In diesen Fällen ist die beste Strategie, zum Ziel der Kanone zu gehen.'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shot = 'static';
taskParam.trialflow.exp = 'practHid';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

% 1) Low noise
taskData = load('hidCannonPracticeHamburg_c16.mat');
taskDataLowNoise = taskData.taskData;
taskDataLowNoise.saveAsStruct = true; % ensure that we save as struct

% 2) High noise
taskData = load('hidCannonPracticeHamburg_c8.mat');
taskDataHighNoise = taskData.taskData;
taskDataHighNoise.saveAsStruct = true; % ensure that we save as struct

if cBal == 1

    % Low noise first...
    % ------------------

    taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore
    taskParam.trialflow.confetti = 'show confetti cloud';
    al_indicateNoise(taskParam, 'lowNoise', true)
    al_confettiLoop(taskParam, condition, taskDataLowNoise, taskParam.gParam.practTrialsHid);

    % ... high noise second
    % ---------------------

    al_indicateNoise(taskParam, 'highNoise', true)
    al_confettiLoop(taskParam, condition, taskDataHighNoise, taskParam.gParam.practTrialsHid);

elseif cBal == 2

    % High noise first...
    % ------------------

    taskParam.trialflow.cannon = 'hide cannon'; % don't show cannon anymore
    taskParam.trialflow.confetti = 'show confetti cloud';
    al_indicateNoise(taskParam, 'highNoise', true)
    al_confettiLoop(taskParam, condition, taskDataHighNoise, taskParam.gParam.practTrialsHid);

    % ... low noise second
    % ---------------------

    % Run task
    al_indicateNoise(taskParam, 'lowNoise', true)
    al_confettiLoop(taskParam, condition, taskDataLowNoise, taskParam.gParam.practTrialsHid);

end

% 12. Instructions experimental blocks
% ------------------------------------

% Display instructions
if taskParam.gParam.customInstructions
    header = taskParam.instructionText.startTaskHeader;
    txt = taskParam.instructionText.startTask;
else
    header = 'Jetzt kommen wir zum Experiment';
    txt = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst fangen Sie also das meiste Konfetti, '...
        'wenn Sie den Eimer (rosafarbener Punkt) auf die Stelle bewegen, auf die die Konfetti-Kanone zielt. Weil Sie die Konfetti-Kanone meistens nicht mehr '...
        'sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Konfettiwolken einschätzen. Beachten Sie, dass Sie das Konfetti trotz '...
        'guter Vorhersagen auch häufig nicht fangen können. \n\nIn wenigen Fällen werden Sie die Konfetti-Kanone zu sehen bekommen und können Ihre Leistung '...
        'verbessern, indem Sie den Eimer genau auf das Ziel steuern.\n\n'...
        'Achten Sie bitte auf Ihre Augenbewegungen und vermeiden Sie es während eines Versuchs zu blinzeln. Wenn der Punkt in der Mitte am Ende eines Versuchs weiß ist, dürfen Sie blinzeln.\n\nViel Erfolg!'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

end