function [dataLowNoise, dataHighNoise, totWin] = al_commonConfettiConditions(taskParam)
%AL_COMMONCONFETTICONDITIONS This function runs the change-point condition of the cannon
%task tailored to the common task shared across projects
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataLowNoise: Task-data object low-noise condition
%       dataHighNoise: Task-data object high-noise condition
%       totWin: Total number of points

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

if runIntro && passiveViewingCondition == false

    al_commonConfettiInstructions(taskParam)

elseif runIntro && passiveViewingCondition

    % Update trial flow
    taskParam.trialflow.shot = 'static';
    taskParam.trialflow.colors = 'dark';
    taskParam.trialflow.shieldAppearance = 'lines';
    taskParam.trialflow.saveData = 'true';
    taskParam.trialflow.exp = 'passive';
    taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

    % TaskData-object instance
    taskData = al_taskDataMain(taskParam.gParam.passiveViewingPractTrials, taskParam.gParam.taskType);

    % Generate outcomes using cannon-data function using average concentration
    taskData = taskData.al_cannonData(taskParam, haz, mean(concentration), taskParam.gParam.safe);

    % Generate outcomes using confetti-data function
    taskDataPassiveViewingPract = taskData.al_confettiData(taskParam);

    % Run task
    txt = ['Versuchen Sie in dieser Aufgabe bitte in die Mitte '...
        'des Bildschirms zu fixieren. Es ist wichtig, dass Sie Ihre Augen nicht bewegen!\n\n'...
        'Versuchen Sie nur zu blinzeln, wenn der weiße Punkt erscheint. Während dieser Übung '...
        'wird der Versuchsleiter Sie darauf hinweisen.'];
    al_bigScreen(taskParam, 'Übung', txt, true);
    al_confettiLoop(taskParam, 'main', taskDataPassiveViewingPract, taskParam.gParam.passiveViewingPractTrials, '');

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

totWin = 0;

% Implement conditions
if cBal == 1

    % Low noise first...
    [totWin, dataLowNoise] = blockLoop(taskParam, totWin, 1, 1);

    % ... high noise second
    [totWin, dataHighNoise] = blockLoop(taskParam, totWin, 2, 2);

elseif cBal == 2

    % High noise first...
    [totWin, dataHighNoise] = blockLoop(taskParam, totWin, 2, 1);

    % ... low noise second
    [totWin, dataLowNoise] = blockLoop(taskParam, totWin, 1, 2);

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


function [totWin, allTaskData] = blockLoop(taskParam, totWin, noiseCondition, half)
%BLOCKLOOP This function loops over task blocks for a given noise condition
%
%   Input
%       taskParam: Task-parameter-object instance
%       totWin: Total number of hits
%       noiseCondition: Current condition (1: low noise; 2: high noise)
%
%   Output
%       totWin: Total number of hits
%

% Extract some variables from task-parameters object
trial = taskParam.gParam.trials;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% Create data structure combining all blocks for integration test
allTaskData = struct();

% Loop over blocks
for b = 1:taskParam.gParam.nBlocks

    % Task data
    if ~taskParam.unitTest.run

        % TaskData-object instance
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

        % Generate outcomes using cannon-data function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(noiseCondition), taskParam.gParam.safe);

        % Generate outcomes using confetti-data function
        taskData = taskData.al_confettiData(taskParam);

        % Update block number
        taskData.block(:) = b;

    else
        if noiseCondition == 1
            taskData = taskParam.unitTest.taskDataIntegrationTest_HamburgLowNoise;
        elseif noiseCondition == 2
            taskData = taskParam.unitTest.taskDataIntegrationTest_HamburgHighNoise;
        end

    end

    % Indicate condition
    if noiseCondition == 1
        al_indicateNoise(taskParam, 'lowNoise', true, false)
    elseif noiseCondition == 2
        al_indicateNoise(taskParam, 'highNoise', true, false)
    end

    % Run task
    data = al_confettiLoop(taskParam, 'main', taskData, trial, sprintf('_b%i', b));

    % Transform to structure for integration test
    data = saveobj(data);

    % Create a dynamic field name
    fieldName = sprintf('conditionBlock%d', b);

    % Add the substructure to the master structure
    allTaskData.(fieldName) = data;

    % Update hit counter after each block
    totWin = totWin + sum(data.hit);

    % Short break before next block
    if b < taskParam.gParam.nBlocks
        al_blockBreak(taskParam, half, b)
    end
end
end
