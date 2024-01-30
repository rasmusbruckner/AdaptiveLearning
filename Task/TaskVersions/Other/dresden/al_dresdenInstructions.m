function al_dresdenInstructions(taskParam, subject, cannon, whichPractice)
%AL_DRESDENINSTRUCTIONS This function runs the instructions for the "Dresden Version"
%
%   Input
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%       cannon: logical that indicates if cannon should be shown during instruction
%       whichPractice: indicates which practice condition should be presented
%
%   Output
%       None

% todo: cannon centered as previously in dresden


% Indicate that cannon will be displayed during instructions
taskParam.trialflow.cannon = 'show cannon';
taskParam.trialflow.currentTickmarks = 'hide';

% Adjust text settings
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('TextSize', taskParam.display.window.onScreen, 50);

% Todo: Add to colors and put in RunDresdenVersion
if subject.rew == 1
    colRew = 'gold';
    colNoRew = 'grau';
elseif subject.rew == 2
    colRew = 'silber';
    colNoRew = 'gelb';
end

% 1. Display first slide indicating the current task version
% ----------------------------------------------------------
al_indicateCondition(taskParam, ['Herzlich Willkommen Zur Konfetti-Kanonen-Aufgabe!\n\n'...
    'Das erste Spiel heißt "Kanonenkugeln Abwehren"'])

% 2. Introduce the cannon
% -----------------------

% Todo ensure these are reasonable params
% Load task-data-object instance
nTrials = 8;
taskData = al_taskDataMain(nTrials);

% Generate practice-phase data
taskData.catchTrial(1:nTrials) = 0; % no catch trials
taskData.initiationRTs(1:nTrials) = nan;  % set initiation RT to nan to indicate that this is the first response
taskData.block(1:nTrials) = 1; % block number
taskData.allASS(1:nTrials) = rad2deg(2*sqrt(1/12)); % shield size todo: check if concentration is as desired (curr 12)
taskData.shieldType(1:nTrials) = 1; % shield color
taskData.distMean = [0, 300, 300, 65, 290, 35, 190, 160]; % aim of the cannon
taskData.outcome = taskData.distMean; % in practice phase, mean and outcome are the same

% Introduce cannon
currTrial = 1;
if isequal(taskParam.subject.group, '1')
    txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Deine Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen Punkt kannst du angeben, '...
        'wo du dein Schild platzieren möchtest, um die Kanonenkugel abzuwehren.\nDu kannst den Punkt mit den grünen und blauen Tasten steuern. Grün kannst du für schnelle '...
        'Bewegungen und blau für langsame Bewegungen benutzen.'];
else
    txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Ihre Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen '...
        'Punkt können Sie angeben, wo Sie Ihr Schild platzieren möchten, um die Kanonenkugel abzuwehren.\nSie können den Punkt mit den '...
        'grünen und blauen Tasten steuern. Grün können Sie für schnelle Bewegungen und blau für langsame Bewegungen benutzen.'];
end

% before continuing, use trialflow in introduceCannon
taskParam = al_introduceCannon(taskParam, taskData, currTrial, txt);

%case 3

% 3. Introduce shot of the cannon
% -------------------------------

currTrial = 2; % update trial number
txt = 'Das Ziel der Kanone wird mit der schwarzen Linie angezeigt. Drücken Sie die Leertaste, damit die Kanone schießt.';
[taskData, taskParam] = al_introduceShot(taskParam, taskData, currTrial, txt);

% todo: necessary?
% WaitSecs(0.1);
 
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

% todo noch nicht ganz
win = true;
txt=['Das Schild erscheint nach dem Schuss. In diesem Fall haben Sie die Kanonenkugel abgewehrt. '...
    'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, zählt es als Treffer.'];
al_introduceShield(taskParam, taskData, win, currTrial, txt)

% 6. Ask participant to miss cannonball
% -------------------------------------

% Update trial number
currTrial = 4;

% Repeat as long as subject catches cannonball
while 1

    % todo add fixation cross in between
    % Introduce miss with shield
    txt = 'Versuchen Sie nun Ihr Schild so zu positionieren, dass Sie die Kanonenkugel verfehlen. Drücken Sie dann die LEERTASTE.';
    [taskData, taskParam] = al_introduceShieldMiss(taskParam, taskData, currTrial, txt);

    % If it is a hit, repeat instruction
    if abs(taskData.predErr(currTrial)) <= taskParam.gParam.practiceTrialCriterionEstErr

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

% 8. Introduce variability and color of the shield
% ------------------------------------------------

% Display instructions
header = 'Das Schild';
txt = sprintf(['Wenn Sie Kanonenkugeln abwehren, '...
    'können Sie Geld verdienen. Wenn das Schild '...
    '%s ist, verdienen Sie %s CENT wenn Sie die '...
    'Kanonenkugel abwehren. Wenn das Schild %s '...
    'ist, verdienen Sie nichts. Ebenso wie die '...
    'Farbe, kann auch die Größe Ihres '...
    'Schildes variieren. '...
    'Die Farbe und die Größe des Schildes sehen '...
    'Sie erst, nachdem die Kanone geschossen hat. '...
    'Daher versuchen Sie am besten jede '...
    'Kanonenkugel abzuwehren.\n\n'...
    'Um einen Eindruck von der wechselnden Größe '...
    'und Farbe des Schildes zu bekommen, '...
    'kommt jetzt eine kurze Übung.\n\n'], colRew, num2str(100*taskParam.gParam.rewMag), colNoRew);
feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);

% Generate outcomes using cannon-data function
taskData.trials = taskParam.gParam.shieldTrials;
taskData = taskData.al_cannonData(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(2), taskParam.gParam.safe);

taskParam.trialflow.cannon = "show cannon";
[~, dataMain] = al_dresdenLoop(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(2), 'main', subject, taskData, taskParam.gParam.shieldTrials);

% hier kommen jetzt die gewinnmöglichkeiten

header = 'Gewinnmöglichkeiten';
if isequal(taskParam.subject.group, '1')
    
    txt = 'Um dir genau zu zeigen, wann du Geld verdienst, spielen wir jetzt alle Möglichkeiten durch.';
else
    txt = 'Um Ihnen genau zu zeigen, wann Sie Geld verdienen, spielen wir jetzt alle Möglichkeiten durch.';
end
feedback = false;
al_bigScreen(taskParam, header, txt, feedback);
WaitSecs(0.1)

% 9. Reward shield and hit
% ------------------------

% Update trial number
currTrial = 5;

% Repeat as long as subject misses cannonball
while 1

     txt='Versuche die Kanonenkugel jetzt wieder zu abzuwehren.';
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

win = true;
txt = sprintf(['Weil du die Kanonenkugel abgewehrt hast und das Schild %s war, '...
'hättest du jetzt %s CENT verdient.'], colRew, num2str(100*taskParam.gParam.rewMag));
al_introduceShield(taskParam, taskData, win, currTrial, txt)

% 10. Reward shield and miss
% --------------------------

% Update trial number
currTrial = 6;

% Repeat as long as subject catches cannonball
while 1

    % todo add fixation cross in between
    % Introduce miss with shield
    txt = 'Versuchen Sie nun Ihr Schild so zu positionieren, dass Sie die Kanonenkugel verfehlen. Drücken Sie dann die LEERTASTE.';
    [taskData, taskParam] = al_introduceShieldMiss(taskParam, taskData, currTrial, txt);

    % If it is a hit, repeat instruction
    if abs(taskData.predErr(currTrial)) <= taskParam.gParam.practiceTrialCriterionEstErr

        WaitSecs(0.5)
        header = 'Leider gefangen!';
        txt = 'Sie haben die Kanonenkugel gefangen. Versuchen Sie bitte, die Kugel nicht zu fangen!';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);  % todo: code needs to be re-organized
    else
        break
    end
end

win = false;
txt = 'Weil du die Kanonenkugel verpasst hast, hättest du nichts verdient.';
al_introduceShield(taskParam, taskData, win, currTrial, txt)

% 11. Neutral shield and hit
% --------------------------

% Update trial number
currTrial = 7;

% Repeat as long as subject misses cannonball
while 1

     txt='Versuche die Kanonenkugel jetzt wieder zu abzuwehren.';
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

win = true;
txt=sprintf(['Du hast die Kanonenkugel abgewehrt, '...
             'aber das Schild war %s. Daher hättest '...
             'du nichts verdient.'], colNoRew);al_introduceShield(taskParam, taskData, win, currTrial, txt)

% 12. Neutal shield and miss
% --------------------------

% Update trial number
currTrial = 8;

% Repeat as long as subject catches cannonball
while 1

    % todo add fixation cross in between
    % Introduce miss with shield
    txt = 'Versuchen Sie die Kanonenkugel jetzt wieder zu verfehlen.';
    [taskData, taskParam] = al_introduceShieldMiss(taskParam, taskData, currTrial, txt);

    % If it is a hit, repeat instruction
    if abs(taskData.predErr(currTrial)) <= taskParam.gParam.practiceTrialCriterionEstErr

        WaitSecs(0.5)
        header = 'Leider gefangen!';
        txt = 'Sie haben die Kanonenkugel gefangen. Versuchen Sie bitte, die Kugel nicht zu fangen!';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);  % todo: code needs to be re-organized
    else
        break
    end
end

win = false;
txt = 'Weil du die Kanonenkugel verpasst hast, hättest du nichts verdient.';
al_introduceShield(taskParam, taskData, win, currTrial, txt)


% Todo: here we first need the 3 practice sessions (2 are already implemented in sleep)
% and then followOutcome and followCannon has to be implemented, incl. 
% the different order depending on cBal. then it should be done.




% 14. Introduce variability of the cannon
% ---------------------------------------

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
practData = load('CP_NoNoise.mat');
taskData = practData.practData;
taskParam.condition = condition;
%taskData.initialTendency = nan(length(taskData.ID), 1);

% Reset roation angle to starting location
taskParam.circle.rotAngle = 0;

% Run task
while 1

    % todo: should be dresden loop
    % first update dresden loop in line with other loops
    % Task loop
    al_dresdenLoop(taskParam, condition, taskData, taskParam.gParam.practTrials);

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


if isequal(whichPractice, 'mainPractice') || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 4) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 6)

    warning('turned first practice off')
    %MainAndFollowCannon_CannonVisibleNoNoise
    % warning('turned second practice off')
    MainAndFollowCannon_CannonVisibleNoise(whichPractice, taskParam, subject)

    %LoadData = 'CP_Noise';
    %condition = 'mainPractice_2';
    condition = 'onlinePractice';
    [taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(1), taskParam.gParam.concentration(3));
    al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject, taskData, trial);

    %elseif isequal(whichPractice, 'oddballPractice')

    % oddballPractice(taskParam, subject)

    %  elseif isequal(taskParam.gParam.taskType, 'reversal')

    %   reversalPractice(taskParam, subject)

elseif isequal(taskParam.gParam.taskType, 'dresden')

    FollowCannonJustInstructions

    % elseif (isequal(whichPractice, 'chinese'))

    % Run task-specific instructions for chinese condition
    % chinesePractice(taskParam, subject)

end

% break
%end
% end

% elseif isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'mainPractice') && subject.cBal == 4) || (isequal(whichPractice, 'mainPractice')...
%         && subject.cBal == 5) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 6)
%     MainJustInstructions
% elseif isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 1)...
%         || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 2) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 3)
%     FollowCannonJustInstructions(taskParam)
% elseif isequal(whichPractice, 'followOutcomePractice')
%     FollowOutcomeInstructions(taskParam, subject, true, whichPractice)
%end
end


