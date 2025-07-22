function [allTaskData, totWin] = al_neverWrongConditions(taskParam)
%AL_NEVERWRONGCONDITIONS This function runs the change-point condition of the cannon
%task tailored to the how-to-never-be-wrong version
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       allTaskData: Structure with all task-data-object instances
%       totWin: Total number of points

% Screen background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
cBal = taskParam.subject.cBal;
passiveViewingCondition = taskParam.gParam.passiveViewing;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

if runIntro
    al_neverWrongInstructions(taskParam)
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

% ------------
% 3. Main task
% ------------

% Run all task blocks
[totWin, allTaskData] = blockLoop(taskParam, cBal, passiveViewingCondition);

end


function [totWin, allTaskData] = blockLoop(taskParam, cBal, passiveViewingCondition)
%BLOCKLOOP This function loops over task blocks for a given noise condition
%
%   Input
%       taskParam: Task-parameter-object instance
%       cBal: Counterbalancing condition
%       passiveViewing: Indicates if we are in passive-viewing condition
%
%   Output
%       allTaskData: Structure with all task-data-object instances
%       totWin: Total number of hits
%


% Extract some variables from task-parameters object
trial = taskParam.gParam.trials;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% Total number of hits across blocks
totWin = 0;

% Create data structure combining all blocks for integration test
allTaskData = struct();

% Loop over blocks
for b = taskParam.subject.startsWithBlock:taskParam.gParam.nBlocks

    % Select noise condition
    % ----------------------
    % 1) odd & cbal 1 = low
    % 2) even & cbal 2 = low
    % 3) odd & cbal 2 = high
    % 4) even & cbal 1 = high

    if (mod(b,2) == 1 && cBal == 1) || (mod(b,2) == 0 && cBal == 2)
        noiseCondition = 1;
    elseif (mod(b,2) == 1 && cBal == 2) || (mod(b,2) == 0 && cBal == 1)
        noiseCondition = 2;
    end

    % Task data
    if ~taskParam.unitTest.run

        % Task-data-object instance
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

        % Generate outcomes using cannon-data function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(noiseCondition), taskParam.gParam.safe);

        % Generate outcomes using confetti-data function
        taskData = taskData.al_confettiData(taskParam);

        % Update block number
        taskData.block(:) = b;
        file_name_suffix = sprintf('_b%i', b);

    else
        if noiseCondition == 1
            taskData = taskParam.unitTest.taskDataIntegrationTest_HamburgLowNoise;
        elseif noiseCondition == 2
            taskData = taskParam.unitTest.taskDataIntegrationTest_HamburgHighNoise;
        end

        % Since we don't save the data, just use empty string
        file_name_suffix = '';

    end

    % Indicate condition
    if noiseCondition == 1
        al_indicateNoise(taskParam, 'lowNoise', true, passiveViewingCondition)
        fieldName = sprintf('lowNoiseBlock%d', b);
    elseif noiseCondition == 2
        al_indicateNoise(taskParam, 'highNoise', true, passiveViewingCondition)
        fieldName = sprintf('highNoiseBlock%d', b);
    end

    % Run task
    data = al_confettiLoop(taskParam, 'main', taskData, trial, file_name_suffix);

    % Transform to structure for integration test
    data = saveobj(data);

    % Add the substructure to the master structure
    allTaskData.(fieldName) = data;

    % Update hit counter after each block
    totWin = totWin + sum(data.hit);

    % Short break before next block
    if b < taskParam.gParam.nBlocks
        al_blockBreak(taskParam, b)
    end

end
end