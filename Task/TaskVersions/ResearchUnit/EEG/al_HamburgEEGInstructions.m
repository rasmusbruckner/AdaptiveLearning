function al_HamburgEEGInstructions(taskParam)
%AL_HAMBURGINSTRUCTIONS This function runs the instructions for the
% "HamburgEEG" version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None    

%% todo: can take test day out: certainly in EEG, but I think also in common

% Extract test day and cBal variables (relevant for later)
testDay = taskParam.subject.testDay;
cBal = taskParam.subject.cBal;

% Adjust trialflow
%taskParam.trialflow.cannon = 'show cannon'; % cannon will be displayed
taskParam.trialflow.currentTickmarks = 'hide'; % tick marks initially not shown
taskParam.trialflow.push = 'practiceNoPush'; % turn off push manipulation

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% 1. Present welcome message
% --------------------------

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

% Counterbalancing
% ----------------

% cBal = 1: ABCD
% 1) Monetary reward

% cBal = 2: ABDC
% 1) Monetary reward
%
% cBal = 3: BACD
% 1) Monetary punishment
%
% cBal = 4: BADC
% 1) Monetary punishment

% cBal = 5: CDAB
% 1) Social reward

% cBal = 6: CDBA
% 1) Social reward

% cBal = 7: DCAB
% 1) Social punishment 
%
% cBal = 8: DCBA
% 1) Social punishment

% Generate data for each condition
% --------------------------------

% Extract number of trials
trial = taskParam.gParam.practTrials;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% 1) Monetary reward

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataMonetaryReward = taskData.al_confettiData(taskParam);

% 2) Monetary punishment

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataMonetaryPunishmen = taskData.al_confettiData(taskParam);

% 3) Social reward

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataSocialReward = taskData.al_confettiData(taskParam);

% 4) Social punishment

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

% Generate outcomes using confettiData function
taskDataSocialPunishment = taskData.al_confettiData(taskParam);

if cBal == 1

    % 1) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryReward, trial);

elseif cBal == 2

    % 1) Monetary reward
    % ------------------

    taskParam.trialflow.reward = "monetaryReward";

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryReward, trial);
    
elseif cBal == 3

    
    % 1) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryPunishment, trial);
    
elseif cBal == 4

    % 1) Monetary punishment
    % ----------------------

    taskParam.trialflow.reward = "monetaryPunishment";

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskDataMonetaryPunishment, trial);

elseif cBal == 5

    % 1) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskDataSocialReward, trial);

elseif cBal == 6

    % 1) Social reward
    % ----------------

    taskParam.trialflow.reward = "socialReward";

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskDataSocialReward, trial);

elseif cBal == 7

    % 1) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskDataSocialPunishment, trial);

elseif cBal == 8

    % 1) Social punishment
    % --------------------

    taskParam.trialflow.reward = "socialPunishment";

    % Run task
    al_indicateSocial(taskParam)
    al_confettiEEGLoop(taskParam, 'main', taskDataSocialPunishment, trial);

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