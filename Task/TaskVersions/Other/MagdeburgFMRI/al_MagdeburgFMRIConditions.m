function totWin = al_MagdeburgFMRIConditions(taskParam)
%AL_MAGDEBURGFMRICONDITIONS This function runs the changepoint condition of the cannon
%   task tailored to the Magdeburg fMRI version
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       totWin: Total number of hits
%
%  Todo: Write a unit test and include this in integration tests

% Extract some variables from task-parameters object
runIntro = taskParam.gParam.runIntro;
cBal = taskParam.subject.cBal;

% --------------------------------
% 1. Show instructions, if desired
% --------------------------------

if runIntro && ~taskParam.unitTest.run

    al_MagdeburgFMRIInstructions(taskParam)

else

    if taskParam.gParam.scanner

        % Instructions button practice
        header = 'Jetzt kommt eine kurze Übung im Scanner';
        txtStartTask = ['Sie haben jetzt die Möglichkeit, sich kurz mit den Tasten im Scanner vertraut zu machen.\n\n'...
            'Bitte berücksichtigen Sie, dass die Zeit zwischen den einzelnen Bildern in der Aufgabe jetzt länger sein wird. Diesen zeitlichen '...
            'Abstand benötigen wir für die Messung Ihrer Hirnaktivität.'];
    
        feedback = false;
        al_bigScreen(taskParam, header, txtStartTask, feedback);
    
        % TaskData-object instance
        trial = 5;
        haz = 0;
        concentration = 12;
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);
        
        % Generate outcomes using cannon-data function
        taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);
    
        % Run task
        al_sleepLoop(taskParam, taskData, trial, false, true);
    
    end
    % Instructions experimental blocks
    header = 'Jetzt kommen wir zum Experiment';
    txtStartTask = ['Bitte berücksichtigen Sie, dass die Zeit zwischen den einzelnen Bildern in der Aufgabe jetzt länger sein wird. Diesen zeitlichen '...
        'Abstand benötigen wir für die Messung Ihrer Hirnaktivität.\n\nVersuchen Sie bitte Ihren Blick meistens auf das Fixationskreuz in der '...
        'Mitte zu richten. Beachten Sie bitte weiterhin, dass Sie 10 Sekunden Zeit haben, um Ihr '...
        'Schild zu platzieren. Danach schießt die Kanone automatisch und der Versuch wird nicht mitgezählt.\n\nViel Erfolg!'];  %Sie werden wie in der Übung zwei Blöcke spielen. In jedem Block gibt es 3 kurze Pausen.

    feedback = false;
    al_bigScreen(taskParam, header, txtStartTask, feedback);

    % ------------
    % 2. Main task
    % ------------

    totWin = 0;

    % Implement conditions
    if cBal == 1

        % Low noise first...
        totWin = blockLoop(taskParam, totWin, 1, 1);

        % ... high noise second
        totWin = blockLoop(taskParam, totWin, 2, 2);

    elseif cBal == 2

        % High noise first...
        totWin = blockLoop(taskParam, totWin, 2, 1);

        % ... low noise second
        totWin = blockLoop(taskParam, totWin, 1, 2);

    end
end
end

function totWin = blockLoop(taskParam, totWin, noiseCondition, half)
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

% Loop over blocks
for b = 1:taskParam.gParam.nBlocks

    % Task data
    if ~taskParam.unitTest.run

        % TaskData-object instance
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(noiseCondition), taskParam.gParam.safe);
        
        % Update block number
        if half == 1
            taskData.block(:) = b;
        elseif half == 2
            taskData.block(:) = b + taskParam.gParam.nBlocks;
        else 
            error('half parameter undefined')
        end

    else
        load('integrationTest_sleep.mat', 'taskData')
    end

    % Indicate condition
    if noiseCondition == 1
        al_indicateCannonNoise(taskParam, 'lowNoise')
    elseif noiseCondition == 2
        al_indicateCannonNoise(taskParam, 'highNoise')
    end

    % Run task
    data = al_sleepLoop(taskParam, taskData, trial, false);

    % Update hit counter after each block
    totWin = totWin + sum(data.hit);

    % Short break before next block
    if b < taskParam.gParam.nBlocks
        al_blockBreak(taskParam, half, b)
    end
end
end

