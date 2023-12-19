function al_sleepInstructions(taskParam)
%AL_SLEEPINSTRUCTIONS This function runs the instructions for the
% "sleep" version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       ~

% Extract test day and cBal variables
testDay = taskParam.subject.testDay;
cBal = taskParam.subject.cBal;

% Indicate that cannon will be displayed during instructions
taskParam.trialflow.cannon = 'show cannon';
taskParam.trialflow.currentTickmarks = 'hide';

% Turn off push manipulation
taskParam.trialflow.push = 'practiceNoPush';

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% 1. Present welcome message
% --------------------------

al_indicateCondition(taskParam, 'Herzlich Willkommen zur Kanonenaufgabe!')


if testDay == 1

    % 2. Introduce the cannon
    % -----------------------

    % Load taskData-object instance
    nTrials = 4;
    taskData = al_taskDataMain(nTrials);

    % Generate practice-phase data
    taskData.catchTrial(1:nTrials) = 0; % no catch trials
    taskData.initiationRTs(1:nTrials) = nan;  % set initiation RT to nan to indicate that this is the first response
    taskData.block(1:nTrials) = 1; % block number
    taskData.allASS(1:nTrials) = rad2deg(2*sqrt(1/taskParam.gParam.concentration)); % shield size
    taskData.shieldType(1:nTrials) = 1; % shield color
    taskData.distMean = [300, 240, 300, 65]; % aim of the cannon
    taskData.outcome = taskData.distMean; % in practice phase, mean and outcome are the same

    % Introduce cannon
    currTrial = 1;
    txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Ihre Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem violetten '...
        'Punkt können Sie angeben, wo Sie Ihr Schild platzieren möchten, um die Kanonenkugel abzuwehren.\nSie können den Punkt mit den '...
        'grünen und blauen Tasten steuern. Grün können Sie für schnelle Bewegungen und blau für langsame Bewegungen benutzen.'];
    taskParam = al_introduceCannon(taskParam, taskData, currTrial, txt);

    % 3. Introduce shot of the cannon
    % -------------------------------

    currTrial = 2; % update trial number
    txt = 'Das Ziel der Kanone wird mit der schwarzen Linie angezeigt. Drücken Sie die Leertaste, damit die Kanone schießt.';
    [taskData, taskParam] = al_introduceShot(taskParam, taskData, currTrial, txt);

    % 4. Introduce prediction spot and ask participant to catch cannonball
    % --------------------------------------------------------------------

    % Add tickmarks to introduce them to participant
    taskParam.trialflow.currentTickmarks = 'show';
    currTrial = 3; % update trial number

    % Repeat as long as subject misses cannonball
    while 1

        txt=['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. Der violette Strich zeigt Ihnen die '...
            'Position Ihres letzten Schildes. Steuern Sie den violetten Punkt jetzt bitte auf das Ziel der Kanone und drücken Sie LEERTASTE.'];
        [taskData, taskParam] = al_introduceSpot(taskParam, taskData, currTrial, txt);

        % If it is a miss, repeat instruction
        if abs(taskData.predErr(currTrial)) >= taskParam.gParam.practiceTrialCriterionEstErr
            header = 'Leider nicht gefangen!';
            txt = 'Sie haben die Kanonenkugel verfehlt. Versuchen Sie es noch mal!';
            feedback = false; % indicate that this is the instruction mode
            al_bigScreen(taskParam, header, txt, feedback);
        else
            break
        end
    end

    % 5. Introduce shield
    % -------------------

    win = true; % Color of shield when catch is rewarded
    txt = ['Das Schild erscheint während des Schusses. In diesem Fall haben Sie die Kanonenkugel abgewehrt. '...
        'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, zählt es als Treffer.'];
    taskData = al_introduceShield(taskParam, taskData, win, currTrial, txt);

    % 6. Ask participant to miss cannonball
    % -------------------------------------

    % Update trial number
    currTrial = 4;

    % Repeat as long as subject catches cannonball
    while 1

        % Introduce miss with shield
        txt = 'Versuchen Sie nun Ihr Schild so zu positionieren, dass Sie die Kanonenkugel verfehlen. Drücken Sie dann die LEERTASTE.';
        [taskData, taskParam] = al_introduceShieldMiss(taskParam, taskData, currTrial, txt);

        % If it is a hit, repeat instruction
        if abs(taskData.predErr) <= taskParam.gParam.practiceTrialCriterionEstErr

            WaitSecs(0.5)
            header = 'Leider gefangen!';
            txt = 'Sie haben die Kanonenkugel gefangen. Versuchen Sie bitte, die Kugel nicht zu fangen!';
            feedback = false; % indicate that this is the instruction mode
            al_bigScreen(taskParam, header, txt, feedback);  % todo: code needs to be re-organized
        else
            break
        end

    end

    % 7. Confirm that cannonball was missed
    % -------------------------------------
    win = true;
    txt = 'In diesem Fall haben Sie die Kanonenkugel verfehlt.';
    al_confirmMiss(taskParam, taskData, win, currTrial, txt);

    % 8. Introduce variability of the cannon
    % --------------------------------------

    % Display instructions
    header = 'Erster Übungsdurchgang';
    txt=['Weil die Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. Das heißt, auch wenn '...
        'Sie genau auf das Ziel gehen, können Sie die Kugel verfehlen. Die Ungenauigkeit ist zufällig, '...
        'dennoch wehren Sie die meisten Kugeln ab, wenn Sie das Schild genau auf die Stelle '...
        'steuern, auf die die Kanone zielt.\n\nIn der nächsten Übung sollen Sie mit der Ungenauigkeit '...
        'der Kanone erst mal vertraut werden. Lassen Sie das Schild bitte immer auf der anvisierten '...
        'Stelle stehen. Wenn Sie Ihr Schild zu oft neben die anvisierte Stelle steuern, wird die '...
        'Übung wiederholt.'];
    feedback = false; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback);

    % Load outcomes for practice
    condition = 'practice';
    taskData = load('visCannonPracticeSleep.mat');
    taskData = taskData.taskData;
    taskParam.condition = condition;
    taskData.initialTendency = nan(length(taskData.ID), 1);

    % Reset roation angle to starting location
    taskParam.circle.rotAngle = 0;

    % Run task
    while 1

        % Task loop
        al_sleepLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);

        % If estimation error is larger than a criterion on more than five
        % trials, we repeat the instructions
        repeatBlock = sum(abs(taskData.estErr) >= taskParam.gParam.practiceTrialCriterionEstErr);
        if sum(repeatBlock) > taskParam.gParam.practiceTrialCriterionNTrials
            WaitSecs(0.5)
            header = 'Bitte noch mal probieren!';
            txt = ['Sie haben Ihr Schild oft neben dem Ziel der Kanone platziert. Versuchen Sie im nächsten '...
                'Durchgang bitte, das Schild direkt auf das Ziel zu steuern. Das Ziel wird mit der Nadel gezeigt.'];
            al_bigScreen(taskParam, header, txt, feedback);
        else
            break
        end

    end

    % 9. Introduce hidden cannon
    % --------------------------

    % Display instructions
    header = 'Zweiter Übungsdurchgang';
    txt = ['Bis jetzt kannten Sie das Ziel der Kanone und Sie konnten die meisten Kugeln abwehren. Im nächsten '...
        'Übungsdurchgang wird die Kanone nicht mehr sichtbar sein. Anstelle der Kanone sehen Sie dann ein Kreuz. '...
        'Außerdem sehen Sie, wo die Kanonenkugeln landen.\n\nUm weiterhin viele Kanonenkugeln abzuwehren, müssen Sie aufgrund '...
        'der Landeposition einschätzen, auf welche Stelle die Kanone zielt und das Schild auf diese Position '...
        'steuern. Wenn Sie denken, dass die Kanone auf eine neue Stelle zielt, sollten Sie auch Ihr Schild '...
        'dorthin bewegen. Beachten Sie, dass Sie die Kanonenkugeln trotz guter Vorhersagen auch häufig nicht fangen können.'];
    feedback = false;
    al_bigScreen(taskParam, header, txt, feedback);

    % Load data set for practice phase
    taskData = load('hidCannonPracticeSleep.mat');
    taskData = taskData.taskData;

    % Run task
    taskParam.trialflow.cannon = 'none'; % don't show cannon anymore
    al_sleepLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);

    % 10. Introduce bucket push
    % -------------------------

    % Present
    header = 'Letzter Übungsdurchgang: Zufälliger Ausgangspunkt';

    txtStartTask = ['Jezt kommen wir zum letzten Übungsdurchgang. In der Hälfte der Durchgänge der richtigen Aufgabe wird der '...
        'Ausgangspunkt Ihrer Vorhersage (der violette Punkt) zufällig links oder rechts von Ihrer letzten Vorhersage erscheinen. '...
        'Versuchen Sie, sich davon nicht ablenken zu lassen und steuern Sie das Schild wie bisher auf die Stelle des '...
        'Kreises, wo Sie das Ziel der Kanone vermuten.'];

    feedback = false;
    al_bigScreen(taskParam, header, txtStartTask, feedback);

    % Load data set for practice phase
    taskData = load('hidCannonPracticeSleepPush.mat');
    taskData = taskData.taskData;

    % Run task
    taskParam.trialflow.cannon = 'none'; % don't show cannon anymore
    taskParam.trialflow.push = 'push';
    al_sleepLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);

else

    % practice = true;

    % Text settings
    Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
    Screen('TextSize', taskParam.display.window.onScreen, 50);
    header = 'Tag 2: Übungsdurchgang';

    txtStartTask = ['Herzlich willkommen zum zweiten Teil des Experiments. Wie beim letzten Mal werden Sie mit einer Übung anfangen. '...
        'Bei jedem Versuch wird eine Kanone auf eine Stelle des Kreises zielen. Die Schüsse der Kanone werden in der Nähe des Ziels eintreffen. '...
        'Meistens wird die Kanone auf dieselbe Stelle zielen, aber es kommt auch vor, dass sich die Kanone neu ausrichtet.\n\n'...
        'Sie werden die Kanone meistens nicht sehen, sondern müssen das Ziel bestmöglich einschätzen, um möglichst viele Kugeln '...
        'mit Ihrem Schild zu fangen. Beachten Sie, dass Sie die Kanonenkugeln trotz guter Vorhersagen auch häufig nicht fangen können.\n\n'...
        'Wenn die Kanone in seltenen Fällen gezeigt wird, sollten Sie Ihr Schild (violetter Punkt) genau auf das Ziel steuern.\n\nBeachten Sie '...
        'außerdem, dass in der Hälfte der Durchgänge der Ausgangspunkt Ihrer Vorhersage zufällig links oder rechts von Ihrer letzten Vorhersage '...
        'erscheint. Versuchen Sie, sich davon nicht ablenken zu lassen und steuern Sie das Schild auf die Stelle des Kreises, wo Sie das Ziel der Kanone vermuten.'];

    feedback = false;
    al_bigScreen(taskParam, header, txtStartTask, feedback);

    if cBal == 1 || cBal == 4

        taskParam.trialflow.cannon = 'none'; % don't show cannon anymore
        taskParam.trialflow.currentTickmarks = 'show'; % show tickmarks

        % No-push first...
        % ----------------

        % Load data set for practice phase
        taskData = load('hidCannonPracticeSleep.mat');
        taskData = taskData.taskData;

        % Run task
        taskParam.trialflow.push = 'noPush';
        al_indicatePush(taskParam)
        trial = taskParam.gParam.practTrials;
        condition = 'practice';
        al_sleepLoop(taskParam, condition, taskData, trial);

        % ... push second
        % ----------------

        % Load data set for practice phase
        taskData = load('hidCannonPracticeSleepPush.mat');
        taskData = taskData.taskData;

        % Run task
        taskParam.trialflow.push = 'push';
        al_indicatePush(taskParam)
        trial = taskParam.gParam.practTrials;
        al_sleepLoop(taskParam, condition, taskData, trial);

    else

        taskParam.trialflow.cannon = 'none'; % don't show cannon anymore
        taskParam.trialflow.currentTickmarks = 'show'; % show tickmarks

        % Push first...
        % -------------

        % Load data set for practice phase
        taskData = load('hidCannonPracticeSleepPush.mat');
        taskData = taskData.taskData;

        % Run task
        taskParam.trialflow.push = 'push';
        al_indicatePush(taskParam)
        trial = taskParam.gParam.practTrials;
        condition = 'practice';
        al_sleepLoop(taskParam, condition, taskData, trial);

        % ... no-push second
        % ------------------

        % Load data set for practice phase
        taskData = load('hidCannonPracticeSleep.mat');
        taskData = taskData.taskData;

        % Run task
        taskParam.trialflow.push = 'noPush';
        al_indicatePush(taskParam)
        trial = taskParam.gParam.practTrials;
        al_sleepLoop(taskParam, condition, taskData, trial);

    end
end

% Instructions experimental blocks
header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst wehren Sie also die meisten Kugeln ab, '...
    'wenn Sie den violetten Punkt auf die Stelle bewegen, auf die die Kanone zielt. Weil Sie die Kanone meistens nicht mehr '...
    'sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Kugeln einschätzen. Beachten Sie, dass Sie '...
    'die Kanonenkugeln trotz guter Vorhersagen auch häufig nicht fangen können.\n\nIn wenigen Fällen werden Sie '...
    'die Kanone zu sehen bekommen und können Ihre Leistung verbessern, indem Sie den violetten Punkt genau auf das Ziel steuern.\n\n'...
    'In manchen Fällen wird der Ausgangspunkt Ihrer Vorhersage zufällig links oder rechts von Ihrer vorherigen Position abweichen.'...
    '\n\nSie werden wie in der Übung zwei Blöcke spielen. In jedem Block gibt es 3 kurze Pausen.\n\nViel Erfolg!'];

feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);

end