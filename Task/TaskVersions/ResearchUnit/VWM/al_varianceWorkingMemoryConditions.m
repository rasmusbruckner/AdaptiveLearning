function taskData = al_varianceWorkingMemoryConditions(taskParam)
%AL_VARIANCEWORKINGMEMORYONDITIONS This function runs the changepoint condition of the cannon
%   task tailored to the "Hamburg" version
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       taskData: Task-data object
%
%  Todo: Write tests

% -----------------------------------------------------
% Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% --------------------------------
% Show instructions, if desired
% --------------------------------

if runIntro && ~unitTest
    al_VWMInstructions(taskParam)
end

% Gray background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.gray);

% -------------
% Task versions 
% -------------

if taskParam.gParam.whichVersion == 1

    % 1. Standard cannon
    % ------------------
    
    % Extract number of trials
    trial = taskParam.gParam.trials;
    
    % Standard change-point task first
    taskParam.trialflow.distMean = "fixed";
    taskParam.trialflow.variability = "stable";
    taskParam.trialflow.currentTickmarks = "show";
    
    % TaskData-object instance
    taskData = al_taskDataMain(trial);
    
    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);
    
    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);
    
    % Run task
    al_indicateCannonType(taskParam)
    taskData = al_confettiLoop(taskParam, 'main', taskData, trial);

elseif taskParam.gParam.whichVersion == 2
    
    % 2. Working memory version
    % -------------------------
    
    % Extract number of trials
    trial = taskParam.gParam.trials;
    
    % Standard change-point task first
    taskParam.trialflow.distMean = "fixed";
    taskParam.trialflow.variability = "stable";
    taskParam.trialflow.currentTickmarks = "workingMemory";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);
    
    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);
    
    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);
    
    % Run task
    al_indicateCannonType(taskParam)
    taskData = al_confettiLoop(taskParam, 'main', taskData, trial);

elseif taskParam.gParam.whichVersion == 3

    % 3. One tick mark with mean and variability changepoints
    % -------------------------------------------------------
    
    % Extract number of trials
    trial = taskParam.gParam.trialsVarCPs;
    
    taskParam.trialflow.currentTickmarks = "show";
    taskParam.trialflow.variability = "changepoint";
    taskParam.trialflow.distMean = "fixed";
    taskParam.trialflow.currentTickmarks = "show";

    % TaskData-object instance
    taskData = al_taskDataMain(trial);
    
    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(2:3), taskParam.gParam.safe);
    
    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);
    
    % Run task
    al_indicateCannonType(taskParam)
    taskData = al_confettiLoop(taskParam, 'main', taskData, trial);

elseif taskParam.gParam.whichVersion == 4


    % 4. Multiple tick marks with mean and variability changepoints
    % --------------------------------------------------------------
    
    % Extract number of trials
    trial = taskParam.gParam.trialsVarCPs;
    
    taskParam.trialflow.currentTickmarks = "show";
    taskParam.trialflow.variability = "changepoint";
    taskParam.trialflow.distMean = "fixed";
    taskParam.trialflow.currentTickmarks = "workingMemory";
    
    % TaskData-object instance
    taskData = al_taskDataMain(trial);
    
    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(2:3), taskParam.gParam.safe);
    
    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);
    
    % Run task
    al_indicateCannonType(taskParam)
    taskData = al_confettiLoop(taskParam, 'main', taskData, trial);

elseif taskParam.gParam.whichVersion == 5

    % 5. One tick mark and switch between drift state and stable state with variance change points 
    % --------------------------------------------------------------------------------------------
    
    % Extract number of trials
    trial = taskParam.gParam.trialsDrift;
    
    taskParam.trialflow.distMean = "drift";
    taskParam.trialflow.variability = "changepoint";
    taskParam.trialflow.currentTickmarks = "show";
    
    % TaskData-object instance
    taskData = al_taskDataMain(trial);
    
    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(2:3), taskParam.gParam.safeDrift);
    
    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);
    
    % Run task
    al_indicateCannonType(taskParam)
    taskData = al_confettiLoop(taskParam, 'main', taskData, trial);

elseif taskParam.gParam.whichVersion == 6

    % 6. Multiple tick marks and switch between drift state and stable state with variance change points
    % --------------------------------------------------------------------------------------------------
    
    % TODO: ADD Short instructions
    
    taskParam.trialflow.distMean = "drift";
    taskParam.trialflow.variability = "changepoint";
    taskParam.trialflow.currentTickmarks = "workingMemory";

    % Generate instruction trials
    % ---------------------------

    % Extract number of trials
    trial = taskParam.gParam.practTrials; 
    
    % TaskData-object instance
    taskData = al_taskDataMain(trial);
    
    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(2:3), taskParam.gParam.safeDrift);
    
    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);
    
    % Run task
    %al_indicateCannonType(taskParam)
    header = 'Übungsaufgabe';
    txt = ['Zunächst kommt eine kurze Übungsaufgabe. Bitte beachten Sie:\n\n'...
        'Im folgenden Block wird sich die Konfetti-Kanone in manchen Phasen langsam bewegen.\n\n'...
        'Außerdem werden Sie den Ort der letzten 5 Konfetti-Wolken sehen.'];
    feedback = false; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback);
    al_confettiLoop(taskParam, 'practice', taskData, trial);

    % Generate main trials
    % --------------------

    % Extract number of trials
    trial = taskParam.gParam.trialsDrift;

    % TaskData-object instance
    taskData = al_taskDataMain(trial);
    
    % Generate outcomes using cannonData function
    taskData = taskData.al_cannonData(taskParam, haz, concentration(2:3), taskParam.gParam.safe);
    
    % Generate outcomes using confettiData function
    taskData = taskData.al_confettiData(taskParam);
    
    % Run task
    % TODO: Big Screen indicating main task
    
    header = 'Beginn der Aufgabe';
    txt = ['Sie fangen jetzt mit der Aufgabe an. Beachten Sie:\n\nIm folgenden Block wird sich die Konfetti-Kanone in manchen Phasen langsam bewegen.\n\n'...
        'Außerdem werden Sie den Ort der letzten 5 Konfetti-Wolken sehen.'];
    feedback = false; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback);
    taskData = al_confettiLoop(taskParam, 'main', taskData, trial);


end