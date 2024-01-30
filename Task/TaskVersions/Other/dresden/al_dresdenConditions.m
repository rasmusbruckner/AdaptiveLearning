function [dataMain] = al_dresdenConditions(taskParam)
%AL_DRESDENCONDITIONS This function implements the Dresden-EEG version of the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataMain: Task-data object change-point condition
%       dataFollowCannon: Task-data object control condition (LR = 0)
%       dataFollowOutcome: Task-data object control condition (LR = 1)

% Todo: Re-run tests
% todo: dataFollowCannon, dataFollowOutcome to output

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
cBal = taskParam.subject.cBal;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

if runIntro && ~unitTest
    al_commonConfettiInstructions(taskParam)
end

Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);

% ------------
% 3. Main task
% ------------

% Extract number of trials
trial = taskParam.gParam.trials;

% TaskData-object instance
taskData = al_taskDataMain(trial);

        % Generate outcomes using cannon-data function
taskData = taskData.al_cannonData(taskParam, haz(1), concentration(1), taskParam.gParam.safe);


dataMain = al_dresdenLoop(taskParam, 'main', taskData, trial);



% Todo: ensure that outcome generation is done only once for each
% condition.. just order is adjusted. this will be especially 
% relevant to longer cBal cases such as Dresden or M/EEG














%maybe relevant
%     % "Du" for younger adults
%     if isequal(subject.group, '1')
%         txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz zusammengefasst wehrst du also die meisten Kugeln ab, '...
%             'wenn du den orangenen Punkt auf die Stelle bewegst, auf die die Kanone zielt. Weil du die Kanone meistens nicht mehr '...
%             'sehen kannst, musst du diese Stelle aufgrund der Position der letzten Kugeln einschätzen. Das Geld für die abgewehrten '...
%             'Kugeln bekommst du nach der Studie ausgezahlt.\n\nViel Erfolg!'];
% 
%         % "Sie" for older adults
%     else
%         txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst wehren Sie also die meisten Kugeln ab, '...
%             'wenn Sie den orangenen Punkt auf die Stelle bewegen, auf die die Kanone zielt. Weil Sie die Kanone meistens nicht mehr '...
%             'sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Kugeln einschätzen. Das Geld für die abgewehrten '...
%             'Kugeln bekommen Sie nach der Studie ausgezahlt.\n\nViel Erfolg!'];
%     end

    % Indicate beginning of main task
    %al_instructions(taskParam, 'mainPractice', subject);
%     whichPractice = 'mainPractice';
%     al_dresdenInstructions(taskParam, subject, true, whichPractice);
% 


%     %[taskData, trial] = al_loadTaskData(taskParam, 'mainPractice_3', condobj.haz(3), condobj.concentration(1));
%     % ------------------------
%     taskData = load('pract3');
%     taskData = taskData.taskData;
%     taskData.critical_trial = nan;
%     trial = taskParam.gParam.practTrials;
%     % ------------------------------------
%     al_dresdenLoop(taskParam, condobj.haz(3), condobj.concentration(1), 'mainPractice_3', subject, taskData, trial);
%     feedback = false;
%     %al_bigScreen(taskParam, condobj.txtPressEnter, condobj.header, txtStartTask, feedback);
%     al_bigScreen(taskParam, condobj.txtPressEnter, 'Erste Aufgabe...', txtStartTask, feedback);
% 
% end
    
%currentConcentration = condobj.concentration(1);

%[taskData, trial] = al_loadTaskData(taskParam, 'main', condobj.haz(1), currentConcentration);
trial = taskParam.gParam.trials;
% TaskData-object instance
taskData = al_taskDataMain(trial);

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
%testDay = taskParam.subject.testDay;
cBal = taskParam.subject.cBal;
% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz(1), concentration(1), taskParam.gParam.safe);


%taskData = al_generateOutcomesMain(taskParam, condobj.haz(1), currentConcentration, 'main');
dataMain = al_dresdenLoop(taskParam, 'main', taskData, trial);
%dataLowNoise = al_confettiLoop(taskParam, 'main', taskData, trial);


end

function condobj = FollowOutcomeCondition(condobj, taskParam, subject)
%FOLLOWOUTCOMECONDITION   Runs the follow-outcome condition of the cannon task
%
%   Input
%       runIntro: indicate if practice session should be conducted
%       unitTest: indicate if unit test should be conducted
%       haz: hazard rate
%       concentration: noise in the environment
%       txtPressEnter: text that is presented to indicate that subject should press "Enter"
%   Output
%       DataFollowOutcome: Participant data

% TaskData-object instance
trial = taskParam.gParam.controlTrials;
taskData = al_taskDataMain(trial);

if condobj.runIntro && ~condobj.unitTest

    if isequal(subject.group, '1')

        txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz zusammengefasst ist es deine Aufgabe Kanonenkugeln aufzusammeln, indem du '...
            'deinen Korb an der Stelle platzierst, wo die letzte Kanonenkugel gelandet ist (schwarzer Strich). Das Geld für die gesammelten '...
            'Kugeln bekommst du nach der Studie ausgezahlt.\n\nViel Erfolg!'];

    else

        txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst ist es Ihre Aufgabe Kanonenkugeln aufzusammeln, indem Sie '...
            'Ihren Korb an der Stelle platzieren, wo die letzte Kanonenkugel gelandet ist (schwarzer Strich). Das Geld für die gesammelten '...
            'Kugeln bekommen Sie nach der Studie ausgezahlt.\n\nViel Erfolg!'];

    end

    al_instructions(taskParam, 'followOutcomePractice', subject)
    %[taskData, trial] = al_loadTaskData(taskParam, 'followOutcomePractice', condobj.haz(3), condobj.concentration(1));
    % ----------------------------

    taskData = load('CPInvisible');
    taskData = taskData.taskData;
    clear taskData.cBal taskData.rew
    trial = taskParam.gParam.practTrials;
    taskData.cBal = nan(trial,1);
    taskData.rew = nan(trial,1);
    taskData.initiationRTs = nan(trial,1);
    taskData.initialTendency = nan(trial,1);
    taskData.actJitter = nan(trial,1);
    taskData.block = ones(trial,1);
    taskData.savedTickmark(1) = nan;
    taskData.reversal = nan(length(trial),1);
    taskData.currentContext = nan(length(trial),1);
    taskData.hiddenContext = nan(length(trial),1);
    taskData.contextTypes = nan(length(trial),1);
    taskData.latentState = nan(length(trial),1);
    taskData.RT = nan(length(trial),1);
    taskData.critical_trial = nan(length(trial),1);
    % ---------------------------------------------
    al_dresdenLoop(taskParam, condobj.haz(3), condobj.concentration(1), 'followOutcomePractice', subject, taskData, trial);
    feedback = false;
    header = 'Anfang der Aufgabe';
    al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);

else

    Screen('TextSize', taskParam.display.window.onScreen, 30);
    Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
    % IndicateFollowCannon = 'Follow Cannon Task';
    % IndicateFollowOutcome = 'Follow Outcome Task';
    al_indicateDresdenCondition(taskParam, 'Follow Outcome Task')

end

%[taskData, trial] = al_loadTaskData(taskParam, 'followOutcome', condobj.haz(1), condobj.concentration(1));
% --------------------------------------

trial = taskParam.gParam.controlTrials;
%trial = taskParam.gParam.trials;
%taskData = al_generateOutcomesMain(taskParam, condobj.haz(1), condobj.concentration(1), 'followOutcome');
runIntro = taskParam.gParam.runIntro;
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
%testDay = taskParam.subject.testDay;
cBal = taskParam.subject.cBal;
% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz(1), concentration(1), taskParam.gParam.safe);

% -----------------------------------------------------------------------
[~, condobj.DataFollowOutcome] = al_dresdenLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'followOutcome', subject, taskData, trial);

end

% function DataFollowCannon = FollowCannonCondition(runIntro, unitTest, haz, concentration, txtPressEnter)
function condobj = FollowCannonCondition(condobj, taskParam, subject)
%FOLLOWCANNONCONDITION   Runs the follow-the-cannon condition of the cannon task
%
%   Input
%       runIntro: indicate if practice session should be conducted
%       unitTest: indicate if unit test should be conducted
%       haz: hazard rates
%       concentration: noise in the environment
%       txtPressEnter: text that is presented to indicate that subject should press "Enter"
%   Output
%       DataFollowCannon: Participant data

% TaskData-object instance
trial = taskParam.gParam.controlTrials;
taskData = al_taskDataMain(trial);



if condobj.runIntro && ~condobj.unitTest

    if isequal(subject.group, '1')
        txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz zusammengefasst wehrst du die meisten Kugeln ab, wenn du den orangenen Punkt auf die Stelle bewegst, auf die die Kanone '...
            'zielt (schwarze Nadel). Dieses Mal kannst du die Kanone sehen.\n\nViel Erfolg!'];
    else
        txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst wehren Sie die meisten Kugeln ab, wenn Sie den orangenen Punkt auf die Stelle bewegen, auf die die Kanone '...
            'zielt (schwarze Nadel). Dieses Mal können Sie die Kanone sehen.\n\nViel Erfolg!'];
    end

    al_instructions(taskParam, 'followCannonPractice', subject)
    %[taskData, trial] = al_loadTaskData(taskParam, 'followCannonPractice', condobj.haz(3), condobj.concentration(1)); % am 15.10.21 hier geändert, um das unabhängig zu machen.
    % ----
    taskData = load('CPInvisible');
    taskData = taskData.taskData;
    clear taskData.cBal taskData.rew
    trial = taskParam.gParam.practTrials;
    taskData.cBal = nan(trial,1);
    taskData.rew = nan(trial,1);
    taskData.initiationRTs = nan(trial,1);
    taskData.initialTendency = nan(trial,1);
    taskData.actJitter = nan(trial,1);
    taskData.block = ones(trial,1);
    taskData.savedTickmark(1) = nan;
    taskData.reversal = nan(length(trial),1);
    taskData.currentContext = nan(length(trial),1);
    taskData.hiddenContext = nan(length(trial),1);
    taskData.contextTypes = nan(length(trial),1);
    taskData.latentState = nan(length(trial),1);
    taskData.RT = nan(length(trial),1);
    taskData.critical_trial = nan(length(trial),1);
    % ----
    al_dresdenLoop(taskParam, condobj.haz(3), condobj.concentration(1), 'followCannonPractice', subject, taskData, trial);
    feedback = false;
    header = 'Anfang der Aufgabe';
    al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
else
    Screen('TextSize', taskParam.display.window.onScreen, 30);
    Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
    %al_conditionIndication(taskParam, 'Follow Cannon Task', condobj.txtPressEnter)
    al_indicateDresdenCondition(taskParam, 'Follow Outcome Task')
end
%[taskData, trial] = al_loadTaskData(taskParam, 'followOutcome', condobj.haz(1), condobj.concentration(1));
% ----
%trial = taskParam.gParam.controlTrials;
trial = taskParam.gParam.controlTrials; % sollte eig. controlTrials sein

%taskData = al_generateOutcomesMain(taskParam, condobj.haz(1), condobj.concentration(1), 'followOutcome');
% -----
trial = taskParam.gParam.trials;
%taskData = al_generateOutcomesMain(taskParam, condobj.haz(1), condobj.concentration(1), 'followOutcome');
runIntro = taskParam.gParam.runIntro;
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
%testDay = taskParam.subject.testDay;
cBal = taskParam.subject.cBal;
% Generate outcomes using cannonData function
taskData = taskData.al_cannonData(taskParam, haz(1), concentration(1), taskParam.gParam.safe);

% -----------------------------------------------------------------------
% [~, condobj.DataFollowOutcome] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'followOutcome', subject, taskData, trial);


[~, condobj.DataFollowCannon] = al_dresdenLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'followCannon', subject, taskData, trial);
end

%end
%end


