function al_confettiEEGInstructions(taskParam)
%AL_CONFETTIEEGINSTRUCTIONS This function runs the instructions for the
% social-EEG version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None


% Extract test day and cBal variables (relevant for later)
cBal = taskParam.subject.cBal;

% Adjust trialflow
%taskParam.trialflow.cannon = 'show cannon'; % cannon will be displayed
taskParam.trialflow.currentTickmarks = 'hide'; % tick marks initially not shown
taskParam.trialflow.push = 'practiceNoPush'; % turn off push manipulation
taskParam.trialflow.saveData = 'true';

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% Present welcome message
% -----------------------

al_indicateCondition(taskParam, 'Herzlich Willkommen zum Zweiten Teil der Konfetti-Kanonen-Aufgabe!')

% Reset background to gray
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

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

% Generate data for each condition
% --------------------------------

% Extract number of trials
trial = taskParam.gParam.practTrials;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% 1) Monetary

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataMonetary = taskData.al_confettiData(taskParam);

% 2) Social

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataSocial = taskData.al_confettiData(taskParam);

% Update trialflow
taskParam.trialflow.exp = 'pract';
taskParam.trialflow.currentTickmarks = 'show';

if cBal == 1

    % Monetary
    % --------

    taskParam.trialflow.reward = "monetary";

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskDataMonetary, trial);

elseif cBal == 2

    % Social
    % ------

    taskParam.trialflow.reward = "social";

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskDataSocial, trial);

end

% Instructions experimental blocks
% ------------------------------------

header = 'Jetzt kommen wir zum Experiment';
txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz zusammengefasst fängst Du also das meiste Konfetti, '...
    'wenn Du den Eimer (violetter Punkt) auf die Stelle bewegst, auf die die Konfetti-Kanone zielt. Weil Du die Konfetti-Kanone meistens nicht mehr '...
    'sehen kannst, musst Du diese Stelle aufgrund der Position der letzten Konfettiwolken einschätzen. Beachten, dass Du das Konfetti trotz '...
    'guter Vorhersagen auch häufig nicht fangen kannst. \n\nIn wenigen Fällen wirst Du die Konfetti-Kanone zu sehen bekommen und kannst Deine Leistung '...
    'verbessern, indem Du den Eimer genau auf das Ziel steuerst.\n\nViel Erfolg!'];

feedback = false;
al_bigScreen(taskParam, header, txtStartTask, feedback);

end