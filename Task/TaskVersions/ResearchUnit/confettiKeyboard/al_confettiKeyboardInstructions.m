function al_confettiKeyboardInstructions(taskParam)
%AL_CONFETTIIKEYBOARDNSTRUCTIONS This function runs the instructions for the
% keyobard version of the confetti-cannon task
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
if taskParam.gParam.language == "German"
    txt = 'Herzlich Willkommen Zur Konfetti-Kanonen-Aufgabe!';
elseif taskParam.gParam.language == "English"
    txt = 'Welcome to the Confetti-Cannon Task!';
else
    error('language parameter unknown')
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
if taskParam.gParam.language == "German"
    txt = ['Sie blicken von oben auf eine Konfetti-Kanone, die in der Mitte eines Kreises positioniert ist. Ihre Aufgabe ist es, das Konfetti mit einem Eimer zu fangen. Mit dem rosafarbenen '...
        'Punkt können Sie angeben, wo auf dem Kreis Sie Ihren Eimer platzieren möchten, um das Konfetti zu fangen. Sie können den Punkt mit der '...
        'Tastatur steuern. Nutzen Sie die Tasten F und J für schnelle Bewegunge und G und H für genauere Anpassungen.'];
elseif taskParam.gParam.language == "English"
    txt = ['You are looking from above at a confetti cannon placed in the center of a circle. Your task is to catch the confetti with a bucket. Use the pink dot '...
        'to indicate where you would like to place your bucket to catch the confetti. '...
        'You can move the pink dot using the keyboard. The F and J keys are for fast movements and G and H for more precise adjustments.'];
else
    error('language parameter unknown')
end
currTrial = 1;
taskParam = al_introduceCannon(taskParam, taskData, currTrial, txt);

% 3. Introduce confetti
% ---------------------
if taskParam.gParam.language == "German"
    txt = 'Das Ziel der Konfetti-Kanone wird mit der schwarzen Linie angezeigt. Drücken Sie die LEERTASTE, damit die Konfetti-Kanone schießt.';
elseif taskParam.gParam.language == "English"
    txt = 'The aim of the cannon is indicated by the black line. Hit SPACE to fire the cannon.';
else
    error('language parameter unknown')
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

    if taskParam.gParam.language == "German"
        txt = ['Der schwarze Strich zeigt Ihnen die mittlere Position der letzten Konfettiwolke. Der rosafarbene Strich zeigt Ihnen die '...
            'letzte Position Ihres Eimers. Steuern Sie den rosafarbenen Punkt jetzt bitte auf das Ziel der Konfetti-Kanone und drücken Sie die LEERTASTE.'];
    elseif taskParam.gParam.language == "English"
        txt = ['The black line shows the central position of the last confetti burst. The pink line shows the '...
            'last position of your bucket. Now move the pink dot to the aim of the confetti cannon and hit SPACE.'];
    else
        error('language parameter unknown')
    end
    [taskData, taskParam, xyExp, dotSize] = al_introduceSpot(taskParam, taskData, currTrial, txt);

    % If it is a miss, repeat instruction
    if abs(taskData.predErr(currTrial)) >= taskParam.gParam.practiceTrialCriterionEstErr
        if taskParam.gParam.language == "German"
            header = 'Leider nicht gefangen!';
            txt = 'Sie haben leider zu wenig Konfetti gefangen. Versuchen Sie es noch mal!';
        elseif taskParam.gParam.language == "English"
            header = 'Unfortunately no catch!';
            txt = 'Unfortunately, you did not catch enough confetti. Try again!';
        else
            error('language parameter unknown')
        end
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% 5. Introduce bucket
% -------------------

if taskParam.gParam.language == "German"
    txt = 'Wenn Sie mindestens die Hälfte des Konfettis im Eimer fangen, zählt es als Treffer und Sie erhalten einen Punkt.';
elseif taskParam.gParam.language == "English"
    txt = 'If you catch at least half of the confetti with the bucket, it is considered a "catch" and you get a point.';
else
    error('language parameter unknown')
end
win = true; % color of shield when catch is rewarded
al_introduceShield(taskParam, taskData, win, currTrial, txt, xyExp, taskData.dotCol(currTrial).rgb, dotSize);

% 6. Introduce practice blocks
% ----------------------------

% Display instructions
if taskParam.gParam.language == "German"
    txt = 'Im Folgenden durchlaufen Sie zwei Übungsdurchgänge\nund im Anschluss vier Durchgänge des Experiments.';
elseif taskParam.gParam.language == "English"
    txt = 'In the following, you will go through two practice runs\nand then four blocks of the experiment.';
else
    error('language parameter unknown')
end
header = '';
feedback = true; % present text centrally
al_bigScreen(taskParam, header, txt, feedback);

% 7. Cannon visible
% -----------------

% Display instructions
if taskParam.gParam.language == "German"
    header = 'Erster Übungsdurchgang';
    txt=['Weil die Konfetti-Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. Das heißt, auch wenn '...
        'Sie genau auf das Ziel gehen, können Sie das Konfetti verfehlen. Die Ungenauigkeit ist zufällig, '...
        'dennoch fangen Sie am meisten Konfetti, wenn Sie den rosanen Punkt genau auf die Stelle '...
        'steuern, auf die die Konfetti-Kanone zielt.\n\nIn dieser Übung sollen Sie mit der Ungenauigkeit '...
        'der Konfetti-Kanone erst mal vertraut werden. Steuern Sie den rosanen Punkt bitte immer auf die anvisierte '...
        'Stelle.'];
elseif taskParam.gParam.language == "English"
    header = 'First Practice Run';
    txt = ['In this block, the confetti cannon is very old '...
        'and its aim therefore pretty inaccurate. Even if you move the bucket to the exact aim of the confetti cannon, '...
        'you might miss the confetti. This inaccuracy is random. '...
        'Still, your best strategy is to place the '...
        'bucket in the location where the cannon is '...
        'aimed.\n\nThe purpose of this practice session is to familiarize yourself with the inaccuracy '...
        'of the confetti cannon. Please always move the pink dot to the '...
        'aim of the cannon.'];
else
    error('language parameter unknown')
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
totalFail = 0;

% Run task
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

        % Break out of loop, even if criterion missed, after 3 attempts
        totalFail = totalFail + 1;
        if totalFail == taskParam.gParam.cannonPractFailCrit
            break
        end

        if taskParam.gParam.language == "German"
            header = 'Bitte noch mal probieren!';
            txt = ['Sie haben Ihren Eimer oft neben dem Ziel der Kanone platziert. Versuchen Sie im nächsten '...
                'Durchgang bitte, den Eimer direkt auf das Ziel zu steuern. Das Ziel wird mit der Nadel gezeigt.'];
        elseif taskParam.gParam.language == "English"
            header = 'Please try again!';
            txt = ['You have often placed your bucket next to the aim of the cannon. In the next '...
                'phase, please try to move the bucket directly to the cannon aim. The aim is indicated by the black line.'];
        else
            error('language parameter unknown')
        end
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end

    % Update block counter
    b = b+1;
end

% 8. Introduce hidden confetti cannon
% ------------------------------------

% Update condition
condition = 'main';

% Display instructions
if taskParam.gParam.language == "German"
    header = 'Zweiter Übungsdurchgang';
    txt = ['Jetzt kommen wir zur nächsten Übung.\n\nDiesmal müssen Sie mit dem rosafarbenen Punkt Ihr Schild platzieren und sehen dabei die Kanone nicht mehr. Außerdem werden Sie es sowohl mit einer relativ genauen '...
        'als auch einer eher ungenauen versteckten Konfetti-Kanone zu tun haben.\n\n'...
        'Beachten Sie bitte, dass das Ziel der Konfetti-Kanone in manchen Fällen sichtbar sein wird. In diesen Fällen ist die beste Strategie, zum Ziel der Kanone zu gehen.'];
elseif taskParam.gParam.language == "English"
    header = 'Second Practice Run';
    txt = ['Now we come to the next practice session.\n\nThis time, you have to place your shield using the pink dot and you will no longer be able to see the cannon. In addition, you will be dealing with both a relatively accurate '...
        'and a rather inaccurate hidden confetti cannon.\n\n'...
        'Please note that in some cases the target of the confetti cannon will be visible. In these cases, the best strategy is to go to the target of the cannon.'];
else
    error('language parameter unknown')
end


feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

% Update task parameters
taskParam.trialflow.exp = 'practHid';
taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

% 1) Low noise
taskData = load('hidCannonPracticeJena_c16.mat');
taskDataLowNoise = taskData.taskData;
taskDataLowNoise.saveAsStruct = true; % ensure that we save as struct

% 2) High noise
taskData = load('hidCannonPracticeJena_c8.mat');
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

% 9. Instructions experimental blocks
% ------------------------------------

% Display instructions
if taskParam.gParam.language == "German"
    header = 'Jetzt kommen wir zum Experiment';
    txt = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst fangen Sie also das meiste Konfetti, '...
        'wenn Sie den Eimer (rosafarbener Punkt) auf die Stelle bewegen, auf die die Konfetti-Kanone zielt. Weil Sie die Konfetti-Kanone meistens nicht mehr '...
        'sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Konfettiwolken einschätzen. Beachten Sie, dass Sie das Konfetti trotz '...
        'guter Vorhersagen auch häufig nicht fangen können. \n\nIn wenigen Fällen werden Sie die Konfetti-Kanone zu sehen bekommen und können Ihre Leistung '...
        'verbessern, indem Sie den Eimer genau auf das Ziel steuern.\n\n'...
        'Viel Erfolg!'];
elseif taskParam.gParam.language == "English"
    header = 'Beginning of the Experiment';
    txt = ['You have completed the practice phase. To summarize, you catch the most confetti, '...
        'when you move the bucket (pink dot) to the aim of the confetti cannon. Because you can usually no longer see the cannon, '...
        'you will have to estimate the aim based on the last confetti bursts. Please note that despite '...
        'good predictions, you often will not be able to catch it. \n\nIn a few cases, you will see the confetti cannon and can improve your performance '...
        'by moving the bucket to its aim.\n\nGood luck!'];
else
    error('language parameter unknown')
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

end