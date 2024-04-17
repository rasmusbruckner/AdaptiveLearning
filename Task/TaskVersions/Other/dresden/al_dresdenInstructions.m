function al_dresdenInstructions(taskParam, whichPractice)
%AL_DRESDENINSTRUCTIONS This function runs the instructions for the Dresden Version
%
%   Input
%       taskParam: Task-parameter-object instance
%       whichPractice: Indicates which practice condition is presented
%
%   Output
%       None


%% ok nach cleaning muss ich noch sicherstellen dass die "just instructions"
% in conditions dann kommen.. aber das ist ja nu text... also morgen
% erstaml diese funktion aufräumen
%% todo: schon gemacht??


% Indicate that cannon will be displayed during instructions
taskParam.trialflow.cannon = 'show cannon';

% Turn off tick marks for first trial
taskParam.trialflow.currentTickmarks = 'hide';

% Adjust text settings
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('TextSize', taskParam.display.window.onScreen, 50);

% 1. Display first slide indicating the current task version
% ----------------------------------------------------------

if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')

    al_indicateCondition(taskParam, ['Herzlich Willkommen Zur Kanonen-Aufgabe!\n\n'...
        'Dieses Spiel heißt "Kanonenkugeln Abwehren"'])

elseif isequal(whichPractice, 'followOutcome')

    al_indicateCondition(taskParam, ['Herzlich Willkommen Zur Kanonen-Aufgabe!\n\n'...
        'Dieses Spiel heißt "Kanonenkugeln Aufsammeln"'])

end

% 2. Introduce the cannon
% -----------------------

% Load task-data-object instance
nTrials = 8;
taskData = al_taskDataMain(nTrials, taskParam.gParam.taskType);

% Generate practice-phase data
taskData.catchTrial(1:nTrials) = 0; % no catch trials
taskData.initiationRTs(1:nTrials) = nan;  % set initiation RT to nan to indicate that this is the first response
taskData.block(1:nTrials) = 1; % block number
taskData.allShieldSize(1:nTrials) = rad2deg(2*sqrt(1/12)); % shield size todo: check if concentration is as desired (curr 12)
taskData.shieldType(1:nTrials) = 1; % shield color
taskData.distMean = [0, 300, 300, 65, 290, 35, 190, 160]; % aim of the cannon
taskData.outcome = taskData.distMean; % in practice phase, mean and outcome are the same
currTrial = 1;

if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
    txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Ihre Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem violetten Punkt können Sie angeben, '...
        'wo Sie Ihr Schild platzieren möchten, um die Kanonenkugel abzuwehren.\nSie können den Punkt mit den grünen und blauen Tasten steuern. Grün können Sie für schnelle '...
        'Bewegungen und blau für langsame Bewegungen benutzen.'];

elseif isequal(whichPractice, 'followOutcome')

    txt=['Eine Kanone zielt auf eine Stelle des Kreises. Ihre Aufgabe ist es, Kanonenkugeln mit einem Korb aufzusammeln. Mit dem violetten Punkt können Sie angeben, '...
        'wo Sie Ihren Korb platzieren möchten, um die Kanonenkugel aufzusammeln.\nSie können den Punkt mit den grünen und blauen Tasten steuern. Grün können Sie für schnelle Bewegungen und '...
        'blau für langsame Bewegungen benutzen.'];

end

% Introduce cannon
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

    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')

        txt=['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. Der violette Strich zeigt Ihnen die '...
            'Position Ihres letzten Schildes. Steuern Sie den violetten Punkt jetzt bitte auf das Ziel der Kanone und drücken Sie LEERTASTE.'];

    elseif isequal(whichPractice, 'followOutcome')

        txt=['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. Der violette Strich zeigt Ihnen die Position Ihres '...
            'letzten Korbes. Bewegen Sie den violetten Punkt zur Stelle der letzten Kanonenkugel und drücken Sie LEERTASTE um die Kugel aufzusammeln. '...
            'Gleichzeitig schießt die Kanone dann eine neue Kugel ab.'];

    end

    % Show instructions
    [taskData, taskParam] = al_introduceSpot(taskParam, taskData, currTrial, txt);

    % Miss feedback depending on condition
    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')

        % Miss criterion
        voi = abs(taskData.predErr(currTrial));

        % Miss feedback text
        header = 'Leider nicht gefangen!';
        txt = 'Sie haben die Kanonenkugel verfehlt. Versuchen Sie es noch mal!';

    elseif isequal(whichPractice, 'followOutcome')

        % Miss criterion
        voi = abs(taskData.diffLastOutcPred(currTrial));

        % Miss feedback text
        header = 'Leider nicht aufgesammelt!';
        txt = 'Sie haben die Kanonenkugel leider nicht aufgesammelt. Versuchen Sie es bitte nochmal!';
    end

    % If it is a miss, repeat instruction
    if voi >= taskParam.gParam.practiceTrialCriterionEstErr
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% 5. Introduce shield
% -------------------

win = true;
if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')

    % When aim is to catch cannon balls
    txt=['Das Schild erscheint nach dem Schuss. In diesem Fall haben Sie die Kanonenkugel abgewehrt. '...
        'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, zählt es als Treffer.'];

elseif isequal(whichPractice, 'followOutcome')

    % When aim is to collect cannon balls
    txt=['Der Korb erscheint nach dem Schuss. '...
        'In diesem Fall haben Sie die Kanonenkugel mit dem Korb aufgesammelt. '...
        'Wie Sie sehen können, hat die Kanone auch eine neue Kugel abgeschossen, '...
        'die Sie im nächsten Durchgang aufsammeln können. '...
        'Wenn mindestens die Hälfte der Kugel im Korb ist, '...
        'zählt es als aufgesammelt.'];
end

% Present instruction
al_introduceShield(taskParam, taskData, win, currTrial, txt);

% 6. Ask participant to miss cannonball
% -------------------------------------

% Update trial number
currTrial = 4;

if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')

    % Repeat as long as subject catches cannonball
    while 1

        % Introduce miss with shield
        txt = 'Versuchen Sie nun Ihr Schild so zu positionieren, dass Sie die Kanonenkugel verfehlen. Drücken Sie dann die LEERTASTE.';
        [taskData, taskParam] = al_introduceShieldMiss(taskParam, taskData, currTrial, txt);

        % If it is a hit, repeat instruction
        if abs(taskData.predErr(currTrial)) <= taskParam.gParam.practiceTrialCriterionEstErr

            WaitSecs(0.5);
            header = 'Leider gefangen!';
            txt = 'Sie haben die Kanonenkugel gefangen. Versuchen Sie bitte, die Kugel nicht zu fangen!';
            feedback = false; % indicate that this is the instruction mode
            al_bigScreen(taskParam, header, txt, feedback);  % todo: code needs to be re-organized
        else
            break
        end
    end

    % Confirm that cannonball was missed
    win = true;
    txt = 'In diesem Fall haben Sie die Kanonenkugel verfehlt.';
    al_confirmMiss(taskParam, taskData, win, currTrial, txt);

elseif isequal(whichPractice, 'followOutcome')

    % Repeat as long as subject catches cannonball
    while 1

        % Introduce collecting cannon ball with basket
        txt= ['Versuchen Sie bitte die letzte Kanonenkugel extra nicht '...
            'aufzusammeln.'];
        [taskData, taskParam] = al_introduceSpot(taskParam, taskData, currTrial, txt);

        % If it is a hit, repeat instruction
        if abs(taskData.diffLastOutcPred(currTrial)) <= taskParam.gParam.practiceTrialCriterionEstErr

            WaitSecs(0.5);
            header = 'Leider aufgesammelt!';
            txt=['Sie haben die Kanonenkugel aufgesammelt. '...
                'Versuchen Sie sie bitte extra nicht aufzusammeln!'];
            feedback = false; % indicate that this is the instruction mode
            al_bigScreen(taskParam, header, txt, feedback);
        else
            break
        end
    end

    % Confirm that cannonball was collected
    win = true;
    txt = 'In diesem Fall haben Sie die Kanonenkugel nicht aufgesammelt.';
    al_confirmMiss(taskParam, taskData, win, currTrial, txt);

end

% 7. Introduce variability and color of the shield
% ------------------------------------------------

% Display instructions
if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')

    header = 'Das Schild';
    txt = sprintf(['Wenn Sie Kanonenkugeln abwehren, können Sie Geld verdienen. Wenn das Schild %s ist, verdienen Sie %s CENT wenn Sie die '...
        'Kanonenkugel abwehren. Wenn das Schild %s ist, verdienen Sie nichts. Ebenso wie die Farbe, kann auch die Größe Ihres Schildes variieren. '...
        'Die Farbe und die Größe des Schildes sehen Sie erst, nachdem die Kanone geschossen hat. Daher versuchen Sie am besten jede Kanonenkugel abzuwehren.\n\n'...
        'Um einen Eindruck von der wechselnden Größe und Farbe des Schildes zu bekommen, kommt jetzt eine kurze Übung.\n\n'], taskParam.colors.colRew, num2str(100*taskParam.gParam.rewMag), taskParam.colors.colNoRew);

elseif isequal(whichPractice, 'followOutcome')

    header = 'Der Korb';
    txt = sprintf(['Wenn Sie Kanonenkugeln aufsammeln, können Sie Geld verdienen. Wenn der Korb %s ist, verdienen Sie %s CENT wenn Sie die '...
        'Kanonenkugel aufsammeln. Wenn der Korb %s ist, verdienen Sie nichts. Ebenso wie die Farbe, kann auch die Größe Ihres Korbes variieren. '...
        'Die Farbe und die Größe des Korbes sehen Sie erst, nachdem die Kanone geschossen hat. Daher versuchen Sie am besten jede Kanonenkugel aufzusammeln.\n\n'...
        'Um einen Eindruck von der wechselnden Größe und Farbe des Korbes zu bekommen, kommt jetzt eine kurze Übung.\n\n'], taskParam.colors.colRew, num2str(100*taskParam.gParam.rewMag), taskParam.colors.colNoRew);
end

feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);

% Generate outcomes using cannon-data function
taskData.trials = taskParam.gParam.shieldTrials;
taskData = taskData.al_cannonData(taskParam, 1, 100, taskParam.gParam.safe);

% Run practice session
currCondition = taskParam.trialflow.condition; % store current condition
taskParam.trialflow.cannon = "show cannon";
taskParam.trialflow.shot = "animate cannonball";
taskParam.trialflow.condition = 'shield'; % temporarily set to shield condition
al_dresdenLoop(taskParam, taskData, taskParam.gParam.shieldTrials);

% Reset to current condition
taskParam.trialflow.condition = currCondition;

% 8. Reward shield and hit
% ------------------------

header = 'Gewinnmöglichkeiten';
txt = 'Um Ihnen genau zu zeigen, wann Sie Geld verdienen, spielen wir jetzt alle Möglichkeiten durch.';
feedback = false;
al_bigScreen(taskParam, header, txt, feedback);
WaitSecs(0.1);

% Update trial number
currTrial = 5;

% Repeat as long as subject misses cannonball
while 1

    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
        txt ='Versuche die Kanonenkugel jetzt wieder zu abzuwehren.';
    elseif isequal(whichPractice, 'followOutcome')
        txt = 'Versuchen Sie bitte die letzte Kanonenkugel wieder aufzusammeln (angezeigt durch den schwarzen Strich).';
    end

    % Show instructions
    [taskData, taskParam] = al_introduceSpot(taskParam, taskData, currTrial, txt);

    % Repeat instructions when missedd/not collected
    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')

        % Miss criterion
        voi = abs(taskData.predErr(currTrial));

        % Instructions
        header = 'Leider nicht gefangen!';
        txt = 'Sie haben die Kanonenkugel verfehlt. Versuchen Sie es noch mal!';

    elseif isequal(whichPractice, 'followOutcome')

        % Miss criterion
        voi = abs(taskData.diffLastOutcPred(currTrial));

        % Instructions
        header = 'Leider nicht aufgesammelt!';
        txt = 'Sie haben die Kanonenkugel leider nicht aufgesammelt. Versuchen Sie es bitte nochmal!';

    end

    % If it is a miss, repeat instruction
    if voi >= taskParam.gParam.practiceTrialCriterionEstErr

        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% Confirm that cannonball was collected
win = true;
if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
    txt = sprintf('Weil Sie die Kanonenkugel abgewehrt haben und das Schild %s war, hätten Sie jetzt %s CENT verdient.', taskParam.colors.colRew, num2str(100*taskParam.gParam.rewMag));
elseif isequal(whichPractice, 'followOutcome')
    txt = sprintf('Weil Sie die Kanonenkugel aufgesammelt haben und der Korb %s war, hätten Sie jetzt %s CENT verdient.', taskParam.colors.colRew, num2str(100*taskParam.gParam.rewMag));
end
al_introduceShield(taskParam, taskData, win, currTrial, txt);

% 9. Reward shield and miss
% -------------------------

% Update trial number
currTrial = 6;

% Repeat as long as subject catches cannonball
while 1

    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
        txt = 'Versuchen Sie nun Ihr Schild so zu positionieren, dass Sie die Kanonenkugel verfehlen. Drücken Sie dann die LEERTASTE.';
    elseif isequal(whichPractice, 'followOutcome')
        txt = 'Versuchen Sie bitte die letzte Kanonenkugel extra nicht aufzusammeln.';
    end
    [taskData, taskParam] = al_introduceShieldMiss(taskParam, taskData, currTrial, txt);

    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')

        % Miss criterion
        voi = abs(taskData.predErr(currTrial));

        % Instructions
        header = 'Leider gefangen!';
        txt = 'Sie haben die Kanonenkugel gefangen. Versuchen Sie bitte, die Kugel nicht zu fangen!';

    elseif isequal(whichPractice, 'followOutcome')

        % Miss criterion
        voi = abs(taskData.diffLastOutcPred(currTrial));

        % Instructions
        header = 'Leider aufgesammelt!';
        txt = 'Sie haben die Kanonenkugel aufgesammelt. Versuchen Sie sie bitte extra nicht aufzusammeln!';

    end

    % If it is a hit, repeat instruction
    if voi <= taskParam.gParam.practiceTrialCriterionEstErr

        WaitSecs(0.5);
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% Confim that cannon ball was missed
win = true;
if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
    txt = 'Weil Sie die Kanonenkugel verpasst haben, hätten Sie nichts verdient.';
elseif isequal(whichPractice, 'followOutcome')
    txt = 'Weil Sie die Kanonenkugel nicht aufgesammelt haben, hätten Sie nichts verdient.';
end
al_introduceShield(taskParam, taskData, win, currTrial, txt);

% 10. Neutral shield and hit
% --------------------------

% Update trial number
currTrial = 7;

% Repeat as long as subject misses cannonball
while 1

    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
        txt='Versuche die Kanonenkugel jetzt wieder zu abzuwehren.';
    elseif isequal(whichPractice, 'followOutcome')
        txt= 'Versuchen Sie bitte die letzte Kanonenkugel wieder aufzusammeln (angezeigt durch den schwarzen Strich).';
    end
    [taskData, taskParam] = al_introduceSpot(taskParam, taskData, currTrial, txt);

    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')

        % Miss criterion
        voi = abs(taskData.predErr(currTrial));

        % Instructions
        header = 'Leider nicht gefangen!';
        txt = 'Sie haben die Kanonenkugel verfehlt. Versuchen Sie es noch mal!';

    elseif isequal(whichPractice, 'followOutcome')

        % Miss criterion
        voi = abs(taskData.diffLastOutcPred(currTrial));

        % Instructions
        header = 'Leider nicht aufgesammelt!';
        txt=['Sie haben die Kanonenkugel leider nicht aufgesammelt. '...
            'Versuchen Sie es bitte nochmal!'];

    end

    % If it is a miss, repeat instruction
    if voi >= taskParam.gParam.practiceTrialCriterionEstErr

        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% Confirm hit
win = false;
if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
    txt = sprintf('Sie haben die Kanonenkugel abgewehrt, aber das Schild war %s. Daher hätten Sie nichts verdient.', taskParam.colors.colNoRew);
elseif isequal(whichPractice, 'followOutcome')
    txt = sprintf('Sie haben die Kanonenkugel aufgesammelt, aber das Schild war %s. Daher hätten Sie nichts verdient.', taskParam.colors.colNoRew);
end
al_introduceShield(taskParam, taskData, win, currTrial, txt);

% 11. Neutal shield and miss
% --------------------------

% Update trial number
currTrial = 8;

% Repeat as long as subject catches cannonball
while 1

    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
        txt = 'Versuchen Sie die Kanonenkugel jetzt wieder zu verfehlen.';
    elseif isequal(whichPractice, 'followOutcome')
        txt= ['Versuchen Sie bitte die letzte Kanonenkugel extra nicht '...
            'aufzusammeln.'];
    end

    [taskData, taskParam] = al_introduceShieldMiss(taskParam, taskData, currTrial, txt);

    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
        voi = abs(taskData.predErr(currTrial));

        header = 'Leider gefangen!';
        txt = 'Sie haben die Kanonenkugel gefangen. Versuchen Sie bitte, die Kugel nicht zu fangen!';

    elseif isequal(whichPractice, 'followOutcome')

        voi = abs(taskData.diffLastOutcPred(currTrial));

        header = 'Leider aufgesammelt!';
        txt=['Sie haben die Kanonenkugel aufgesammelt. '...
            'Versuchen Sie sie bitte extra nicht aufzusammeln!'];
    end

    % If it is a hit, repeat instruction
    if voi <= taskParam.gParam.practiceTrialCriterionEstErr

        WaitSecs(0.5);

        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% Confirm miss
win = false;
if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
    txt = 'Weil Sie die Kanonenkugel verpasst haben, hätten Sie nichts verdient.';
elseif isequal(whichPractice, 'followOutcome')
    txt = 'Weil Sie die Kanonenkugel nicht aufgesammelt haben, hätten Sie nichts verdient.';
end

al_introduceShield(taskParam, taskData, win, currTrial, txt);

% 12. Introduce variability of the cannon
% ---------------------------------------

% Display instructions
header = 'Erster Übungsdurchgang';

if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
    txt=['Weil die Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. Das heißt, auch wenn '...
        'Sie genau auf das Ziel gehen, können Sie die Kugel verfehlen. Die Ungenauigkeit ist zufällig, '...
        'dennoch wehren Sie die meisten Kugeln ab, wenn Sie das Schild genau auf die Stelle '...
        'steuern, auf die die Kanone zielt.\n\nIn der nächsten Übung sollen Sie mit der Ungenauigkeit '...
        'der Kanone erst mal vertraut werden. Lassen Sie das Schild bitte immer auf der anvisierten '...
        'Stelle stehen. Wenn Sie Ihr Schild zu oft neben die anvisierte Stelle steuern, wird die '...
        'Übung wiederholt.'];
elseif isequal(whichPractice, 'followOutcome')
    txt=['In dieser Übung ist das Ziel möglichst viele Kanonenkugeln aufzusammeln. Sie werden feststellen, dass die Kanone '...
        'relativ ungenau schießt, aber meistens auf die selbe Stelle zielt. Diese Ungenauigkeit ist zufällig. Manchmal '...
        'dreht sich die Kanone auch und zielt auf eine andere Stelle. Sie verdienen am meisten, wenn Sie den violetten Punkt genau auf den '...
        'schwarzen Strich steuern, weil Sie so sicher die Kugel aufsammeln. \n\nWenn Sie die Kugel zu oft nicht aufsammeln, '...
        'wird die Übung wiederholt.'];
end

feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);

% Starting with noisy cannon. In very first version, we had no noise, but
% that's too easy and actually quite boring.

% Load outcomes for practice
practData = load('CP_Noise.mat');
taskData = practData.practData;

% Reset roation angle to starting location
taskParam.circle.rotAngle = 0;

% Practice session
taskParam.trialflow.exp = 'pract';

% Run task
while 1

    % Task loop
    taskData = al_dresdenLoop(taskParam, taskData, taskParam.gParam.practTrials, '_1');

    % If estimation error is larger than a criterion on more than five
    % trials, we repeat the instructions
    repeatBlock = sum(abs(taskData.estErr) >= taskParam.gParam.practiceTrialCriterionEstErr);

    % Miss instructions
    if isequal(whichPractice, 'main') || isequal(whichPractice, 'followCannon')
        txt = ['Sie haben Ihr Schild oft neben dem Ziel der Kanone platziert. Versuchen Sie im nächsten '...
            'Durchgang bitte, das Schild direkt auf das Ziel zu steuern. Das Ziel wird mit der Nadel gezeigt.'];
    elseif isequal(whichPractice, 'followOutcome')
        txt = ['In der letzten Übung haben Sie die jeweils letzte Kugel zu selten aufgesammelt.\n\nIn der nächsten Runde '...
            'können Sie nochmal üben. Wenn Sie noch Fragen haben, können Sie sich auch an den Versuchsleiter wenden.'];
    end

    if sum(repeatBlock) > taskParam.gParam.practiceTrialCriterionNTrials
        WaitSecs(0.5);
        header = 'Bitte noch mal probieren!';
        al_bigScreen(taskParam, header, txt, feedback);
    else
        break
    end
end

% 13. Introduce hidden cannon
% ---------------------------

% Display instructions
header = 'Zweiter Übungsdurchgang';

if isequal(whichPractice, 'main')
    txt = ['Bis jetzt kannten Sie das Ziel der Kanone und Sie konnten die meisten Kugeln abwehren. Im nächsten '...
        'Übungsdurchgang wird die Kanone in den meisten Fällen nicht mehr sichtbar sein. Anstelle der '...
        'Kanone sehen Sie dann ein Kreuz. Außerdem sehen Sie wo die Kanonenkugeln landen.\n\nUm weiterhin viele Kanonenkugeln '...
        'abzuwehren, müssen Sie aufgrund der Landeposition einschätzen, auf welche Stelle die Kanone zielt und '...
        'den violetten Punkt auf diese Position steuern. Wenn Sie denken, dass die Kanone auf eine neue Stelle zielt, '...
        'sollten Sie auch den violetten Punkt dorthin bewegen.\n\nWenn Sie die Kanone sehen, steuern Sie Ihr Schild '...
        'am besten genau auf das Ziel der Kanone.'];
elseif isequal(whichPractice, 'followCannon')
    txt = ['In dieser Aufgabe sollen Sie wieder versuchen möglichst viele Kanonenkugeln abzuwehren. Da Sie das Ziel der Kanone die ganze Zeit sehen, '...
        'steuern Sie Ihr Schild am besten genau auf die schwarze Nadel.\n\nBeachten Sie allerdings, dass Sie jetzt nicht mehr '...
        'sehen können wie die Kanonenkugel fliegt, sondern nur wo sie landet.'];
elseif isequal(whichPractice, 'followOutcome')
    txt = ['Im nächsten Übungsdurchgang wird die Kanone meistens nicht mehr sichtbar sein. Anstelle der Kanone sehen Sie dann ein Kreuz, ansonsten bleibt alles gleich. '...
        'Da Sie in dieser Aufgabe Kanonenkugeln aufsammeln, brauchen Sie nicht auf die Kanone zu achten.'];
end

feedback = false;
al_bigScreen(taskParam, header, txt, feedback);

% Get data
taskData = load('CPInvisible.mat');
taskData = taskData.taskData;

% Depending on condition, hide or show cannon
if isequal(whichPractice, 'followCannon')
    taskParam.trialflow.cannon = 'show cannon'; % don't show cannon anymore
else
    taskParam.trialflow.cannon = 'hide cannon'; % show cannon
end

taskParam.trialflow.shot = 'no animation';

% Task loop
al_dresdenLoop(taskParam, taskData, taskParam.gParam.practTrials, '_2');

% 14. Instructions experimental blocks
% ------------------------------------

header = 'Jetzt kommen wir zum Experiment';

if isequal(whichPractice, 'main')
    txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst wehren Sie also die meisten '...
        'Kugeln ab, wenn Sie den violetten Punkt auf die Stelle bewegen, auf die die Kanone zielt. Weil Sie die '...
        'Kanone meistens nicht mehr sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Kugeln '...
        'einschätzen. Das Geld für die abgewehrten Kugeln bekommen Sie nach der Studie ausgezahlt.\n\nViel Erfolg!'];
elseif isequal(whichPractice, 'followOutcome')
    txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst ist es Ihre Aufgabe Kanonenkugeln aufzusammeln, indem Sie Ihren Korb '...
        'an der Stelle platzieren, wo die letzte Kanonenkugel gelandet ist (schwarzer Strich). Das Geld für die gesammelten Kugeln bekommen Sie nach der Studie '...
        'ausgezahlt.\n\nViel Erfolg!'];
elseif isequal(whichPractice, 'followCannon')
    txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst wehren Sie die meisten Kugeln ab, wenn Sie den violetten Punkt auf die Stelle '...
        'bewegen, auf die die Kanone zielt (schwarze Nadel). Dieses Mal können Sie die Kanone sehen.\n\nViel Erfolg!'];
end

feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);

end
