function [dataLowNoise, dataHighNoise] = al_commonConfettiConditions(taskParam)
%AL_COMMONCONFETTICONDITIONS This function runs the change-point condition of the cannon
%task tailored to the common task shared across projects
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataLowNoise: Task-data object low-noise condition
%       dataHighNoise: Task-data object high-noise condition
%

% Screen background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;
cBal = taskParam.subject.cBal;
passiveViewingCondition = taskParam.gParam.passiveViewing;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

% Todo: turn on eye tracker for practice. To monitor saccades. Don't need
% to save et though.

if runIntro
    al_commonConfettiInstructions(taskParam)
end

% Update trial flow
taskParam.trialflow.shot = 'static';
taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.trialflow.saveData = 'true';

if passiveViewingCondition == false
    taskParam.trialflow.exp = 'exp';
elseif passiveViewingCondition == true
    taskParam.trialflow.exp = 'passive';
end

taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

% % Initialize and start eye-tracker
% if taskParam.gParam.eyeTracker
%     [el, et_file_name] = taskParam.eyeTracker.initializeEyeLink(taskParam);
%     taskParam = taskParam.eyeTracker.startRecording(taskParam);
% end

% ------------------------------
% 3. Optionally baseline arousal
% ------------------------------

% Todo: save et_data
if taskParam.gParam.baselineArousal

    % Display pupil info
    if taskParam.gParam.customInstructions
        header = taskParam.instructionText.firstPupilBaselineHeader;
        txt = taskParam.instructionText.firstPupilBaseline;
    else
        header = 'Erste Pupillenmessung';
        txt=['Include correct instructions here'];
    end

    feedback = false; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback);

    % Meaure baseline arousal
    al_baselineArousal(taskParam, '_a1')

end

% ------------
% 4. Main task
% ------------

% Extract number of trials
trial = taskParam.gParam.trials;

% Generate data for each condition
% --------------------------------

% 1) Low noise

if ~taskParam.unitTest.run

    % TaskData-object instance
    taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

    % Generate outcomes using cannon-data function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

    % Generate outcomes using confetti-data function
    taskDataLowNoise = taskData.al_confettiData(taskParam);

else

    taskDataLowNoise = taskParam.unitTest.taskDataIntegrationTest_HamburgLowNoise;

end

% 2) High noise

if ~taskParam.unitTest.run

    % TaskData-object instance
    taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(2), taskParam.gParam.safe);

    % Generate outcomes using confettiData function
    taskDataHighNoise = taskData.al_confettiData(taskParam);

else

    taskDataHighNoise = taskParam.unitTest.taskDataIntegrationTest_HamburgHighNoise;

end


if cBal == 1

    % Low noise first...
    % ------------------

    % Run task
    al_indicateNoise(taskParam, 'lowNoise', true, passiveViewingCondition)
    dataLowNoise = al_confettiLoop(taskParam, 'main', taskDataLowNoise, trial, '_b1');


    % ... high noise second
    % ---------------------

    % Run task
    al_indicateNoise(taskParam, 'highNoise', true, passiveViewingCondition)
    dataHighNoise = al_confettiLoop(taskParam, 'main', taskDataHighNoise, trial, '_b2');

else

    % High noise first...
    % -------------------

    % Run task
    al_indicateNoise(taskParam, 'highNoise', true, passiveViewingCondition)
    dataHighNoise = al_confettiLoop(taskParam, 'main', taskDataHighNoise, trial, '_b1');

    % ... low noise second
    % --------------------

    % Run task
    al_indicateNoise(taskParam, 'lowNoise', true, passiveViewingCondition)
    dataLowNoise = al_confettiLoop(taskParam, 'main', taskDataLowNoise, trial, '_b2');

end

% ------------------------------
% 5. Optionally baseline arousal
% ------------------------------

if taskParam.gParam.baselineArousal

    % Display pupil info
    if taskParam.gParam.customInstructions
        header = taskParam.instructionText.secondPupilBaselineHeader;
        txt = taskParam.instructionText.secondPupilBaseline;
    else
        header = 'Zweite Pupillenmessung';
        txt=['Include correct instructions here'];
    end

    feedback = false; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback, 2);

    % Meaure baseline arousal
    al_baselineArousal(taskParam, '_a2')

end

% % Save Eyelink data
% % -----------------
% 
% if taskParam.gParam.eyeTracker
%     et_path = pwd;
%     et_file_name=[et_file_name, '.edf'];
%     al_saveEyelinkData(et_path, et_file_name)
%     Eyelink('StopRecording');
% end
