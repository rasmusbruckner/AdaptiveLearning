function [dataMain, dataFollowCannon, dataFollowOutcome] = al_dresdenConditions(taskParam)
%AL_DRESDENCONDITIONS This function implements the Dresden EEG version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataMain: Task-data object change-point condition
%       dataFollowCannon: Task-data object control condition (LR = 0)
%       dataFollowOutcome: Task-data object control condition (LR = 1)

% Todo: Re-run tests

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
cBal = taskParam.subject.cBal;

% Background color
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);

% ---------------------------------------
% 2. Pre-generate data for all conditions
% ---------------------------------------

% Main condition
% --------------

% Extract number of trials
trial = taskParam.gParam.trials;

% TaskData-object instance
taskDataMain = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannon-data function
taskDataMain = taskDataMain.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

% Follow-outcome condition
% ------------------------

% TaskData-object instance
taskDataFollowOutcome = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannon-data function
taskDataFollowOutcome = taskDataFollowOutcome.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

% Follow-cannon condition
% -----------------------

% TaskData-object instance
taskDataFollowCannon = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannon-data function
taskDataFollowCannon = taskDataFollowCannon.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

% Choose order of conditions according to cBal
if cBal == 1

    % Main condition
    % --------------

    % Define condition
    taskParam.trialflow.condition = 'main';

    % Show instructions
    if runIntro && ~unitTest
        whichPractice = 'main';
        al_dresdenInstructions(taskParam, whichPractice)
    end

    dataMain = al_dresdenLoop(taskParam, taskDataMain, trial);

    % Follow-outcome condition
    % ------------------------

    % Define condition
    taskParam.trialflow.condition = 'followOutcome';

    % Show instructions
    if runIntro && ~unitTest
        whichPractice = 'followOutcome';
        al_dresdenInstructions(taskParam, whichPractice)
    else
        header = 'Anfang der Studie';
        txt = 'Hier käme eine finale Zusammenfassung';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    end

    dataFollowOutcome = al_dresdenLoop(taskParam, taskDataFollowOutcome, trial);

    % Follow-cannon condition
    % -----------------------

    % Define condition
    taskParam.trialflow.condition = 'followCannon';

    % Show instructions
    if runIntro && ~unitTest
        followCannonShortInstructions(taskParam)
    else
        header = 'Anfang der Studie';
        txt = 'Hier käme eine finale Zusammenfassung';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    end

    taskParam.trialflow.cannon = 'show cannon';
    taskParam.trialflow.shot = 'no animation';

    dataFollowCannon = al_dresdenLoop(taskParam, taskDataFollowCannon, trial);

elseif cBal == 2

    % Main condition
    % --------------

    % Define condition
    taskParam.trialflow.condition = 'main';

    % Show instructions
    if runIntro && ~unitTest
        whichPractice = 'main';
        al_dresdenInstructions(taskParam, whichPractice)
    end

    dataMain = al_dresdenLoop(taskParam, taskDataMain, trial);

    % Follow-cannon condition
    % -----------------------

    % Define condition
    taskParam.trialflow.condition = 'followCannon';

    % Show instructions
    if runIntro && ~unitTest
        followCannonShortInstructions(taskParam)
    else
        header = 'Anfang der Studie';
        txt = 'Hier käme eine finale Zusammenfassung';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    end

    taskParam.trialflow.cannon = 'show cannon';
    dataFollowCannon = al_dresdenLoop(taskParam, taskDataFollowCannon, trial);

    % Follow-outcome condition
    % ------------------------

    % Define condition
    taskParam.trialflow.condition = 'followOutcome';

    % Show instructions
    if runIntro && ~unitTest
        whichPractice = 'followOutcome';
        al_dresdenInstructions(taskParam, whichPractice)
    else
        header = 'Anfang der Studie';
        txt = 'Hier käme eine finale Zusammenfassung';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    end

    dataFollowOutcome = al_dresdenLoop(taskParam, taskDataFollowOutcome, trial);

elseif cBal == 3

    % Follow-outcome condition
    % ------------------------

    % Define condition
    taskParam.trialflow.condition = 'followOutcome';

    % Show instructions
    if runIntro && ~unitTest
        whichPractice = 'followOutcome';
        al_dresdenInstructions(taskParam, whichPractice)
    else
        header = 'Anfang der Studie';
        txt = 'Hier käme eine finale Zusammenfassung';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    end

    dataFollowOutcome = al_dresdenLoop(taskParam, taskDataFollowOutcome, trial);

    % Main condition
    % --------------

    % Define condition
    taskParam.trialflow.condition = 'main';

    % Show instructions
    if runIntro && ~unitTest
        whichPractice = 'main';
        al_dresdenInstructions(taskParam, whichPractice)
    else
        header = 'Anfang der Studie';
        txt = 'Hier käme eine finale Zusammenfassung';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    end

    % Main condition
    dataMain = al_dresdenLoop(taskParam, taskDataMain, trial);

    % Follow-cannon condition
    % -----------------------

    % Define condition
    taskParam.trialflow.condition = 'followCannon';

    % Show instructions
    if runIntro && ~unitTest
        followCannonShortInstructions(taskParam)
    else
        header = 'Anfang der Studie';
        txt = 'Hier käme eine finale Zusammenfassung';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    end

    taskParam.trialflow.cannon = 'show cannon';
    dataFollowCannon = al_dresdenLoop(taskParam, taskDataFollowCannon, trial);

elseif cBal == 4

    % Follow-cannon condition
    % -----------------------

    % Show instructions
    if runIntro && ~unitTest
        whichPractice = 'followCannon';
        al_dresdenInstructions(taskParam, whichPractice)
    else
        header = 'Anfang der Studie';
        txt = 'Hier käme eine finale Zusammenfassung';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    end

    % Follow-cannon condition
    taskParam.trialflow.cannon = 'show cannon';
    taskParam.trialflow.shot = 'no animation';

    % Follow-cannon condition
    dataFollowCannon = al_dresdenLoop(taskParam, taskDataMain, trial);

    % Main condition
    % --------------

    % Define condition
    taskParam.trialflow.condition = 'main';

    % Show instructions
    if runIntro && ~unitTest
        mainShortInstructions(taskParam)
    else
        header = 'Anfang der Studie';
        txt = 'Hier käme eine finale Zusammenfassung';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    end

    % Main condition
    dataMain = al_dresdenLoop(taskParam, taskDataMain, trial);

    % Follow-outcome condition
    % ------------------------

    % Define condition
    taskParam.trialflow.condition = 'followOutcome';

    % Show instructions
    if runIntro && ~unitTest
        whichPractice = 'followOutcome';
        al_dresdenInstructions(taskParam, whichPractice)
    else
        header = 'Anfang der Studie';
        txt = 'Hier käme eine finale Zusammenfassung';
        feedback = false; % indicate that this is the instruction mode
        al_bigScreen(taskParam, header, txt, feedback);
    end

    dataFollowOutcome = al_dresdenLoop(taskParam, taskDataFollowOutcome, trial);

elseif cBal == 5

    % Follow-outcome condition
    % ------------------------

    % Show instructions
    if runIntro && ~unitTest
        whichPractice = 'followOutcome';
        al_dresdenInstructions(taskParam, whichPractice)
    end

    dataFollowOutcome = al_dresdenLoop(taskParam, taskDataFollowOutcome, trial);

    % Just follow cannon

    % Follow-cannon condition
    dataFollowCannon = al_dresdenLoop(taskParam, taskDataFollowCannon, trial);

    % Just main

    % Main condition
    dataMain = al_dresdenLoop(taskParam, taskDataMain, trial);

elseif cBal == 6

    % Regular instructions (without flying ball)

    % Follow-cannon condition
    dataFollowCannon = al_dresdenLoop(taskParam, taskDataFollowCannon, trial);

    % Follow-outcome condition
    % ------------------------

    % Show instructions
    if runIntro && ~unitTest
        whichPractice = 'followOutcome';
        al_dresdenInstructions(taskParam, whichPractice)
    end

    dataFollowOutcome = al_dresdenLoop(taskParam, taskDataFollowOutcome, trial);

    % Just main

    % Main condition
    dataMain = al_dresdenLoop(taskParam, taskDataMain, trial);

end
end

function followCannonShortInstructions(taskParam)

% 1. Indicate current task version
% --------------------------------

al_indicateCondition(taskParam, ['Nächste Aufgabe\n\n'...
    'Dieses Spiel heißt wieder "Kanonenkugeln Abwehren"'])

% 2. Summary of task
% ------------------

header = 'Kanonenkugeln Abwehren';
txt = ['In dieser Aufgabe ist das Ziel wieder möglichst viele Kanonenkugeln abzuwehren. '...
    'Der Unterschied ist allerdings, dass Sie die Kanone dieses Mal sehen können.'];
feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);
WaitSecs(0.1);

% 3. Practice block
% ------------------

header = 'Erste Übung';
txt = ['In dieser Aufgabe sollen Sie wieder versuchen möglichst viele Kanonenkugeln abzuwehren. Da Sie '...
    'das Ziel der Kanone die ganze Zeit sehen, steuern Sie Ihr Schild am besten genau auf die schwarze Nadel.'];
feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);
WaitSecs(0.1);

% Get data
taskData = load('CP_Noise.mat');
taskData = taskData.practData;

% Run task
taskParam.trialflow.cannon = 'show cannon';

% Practice session
taskParam.trialflow.exp = 'pract';

% Task loop
al_dresdenLoop(taskParam, taskData, taskParam.gParam.practTrials);

% 4. Instructions experimental blocks
% ------------------------------------

header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst wehren Sie die meisten Kugeln ab, wenn Sie den orangenen Punkt auf die Stelle bewegen, auf die die Kanone '...
    'zielt (schwarze Nadel). Dieses Mal können Sie die Kanone sehen.\n\nViel Erfolg!'];

feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);

end

function mainShortInstructions(taskParam)


% 1. Indicate current task version
% --------------------------------

al_indicateCondition(taskParam, ['Nächste Aufgabe\n\n'...
    'Dieses Spiel heißt wieder "Kanonenkugeln Abwehren"'])

% 2. Summary of task
% ------------------

header = 'Kanonenkugeln Abwehren';
txt = ['In dieser Aufgabe ist das Ziel wieder möglichst viele Kanonenkugeln abzuwehren. '...
    'Der Unterschied ist allerdings, dass Sie die Kanone diesmal nur noch selten sehen können.'];
feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);
WaitSecs(0.1);

% 3. Practice block
% ------------------

header = 'Erste Übung';
txt = ['Bis jetzt kannten Sie das Ziel der Kanone und Sie konnten die meisten '...
    'Kugeln abwehren. Im nächsten Übungsdurchgang wird die Kanone in den '...
    'meisten Fällen nicht mehr sichtbar sein. Anstelle der Kanone sehen Sie dann ein Kreuz. '...
    'Außerdem sehen Sie wo die Kanonenkugeln landen.\n\nUm weiterhin viele Kanonenkugeln '...
    'abzuwehren, müssen Sie aufgrund der Landeposition einschätzen, auf welche Stelle die Kanone zielt und '...
    'den orangenen Punkt auf diese Position steuern. Wenn Sie denken, dass die Kanone auf eine neue Stelle zielt, '...
    'sollten Sie auch den orangenen Punkt dorthin bewegen.\n\nWenn Sie die Kanone sehen, steuern Sie Ihr Schild '...
    'am besten genau auf das Ziel der Kanone.'];
feedback = false; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback);
WaitSecs(0.1);

% Get data
taskData = load('CP_Noise.mat');
taskData = taskData.practData;

% Run task
taskParam.trialflow.cannon = 'hide cannon';

% Task loop
al_dresdenLoop(taskParam, taskData, taskParam.gParam.practTrials);

% 4. Instructions experimental blocks
% -----------------------------------

header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst ist es Ihre Aufgabe Kanonenkugeln '...
    'aufzusammeln, indem Sie Ihren Korb an der Stelle platzieren, wo die letzte Kanonenkugel gelandet ist (schwarzer Strich). '...
    'Das Geld für die gesammelten Kugeln bekommen Sie nach der Studie ausgezahlt.\n\nViel Erfolg!'];
feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);

end
