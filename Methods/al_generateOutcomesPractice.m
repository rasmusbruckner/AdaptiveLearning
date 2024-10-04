% Generate outcomes for practice
%
% This script is used to pre-generate outcomes for the practice session.
%
% After a major task update this is often necessary and this script saves
% us some time.

% Number of trials
trial = 20;

% General-parameter-object instance
gParam = al_gparam();
gParam.taskType = 'Hamburg';
gParam.blockIndices = [1, 99, 99, 99];
gParam.useCatchTrials = false;

% Trialflow-object instance
trialflow = al_trialflow();
trialflow.confetti = 'show confetti cloud';
trialflow.cannonball_start = 'center';
trialflow.cannon = 'hide cannon';
trialflow.background = 'noPicture';
trialflow.currentTickmarks = 'show';
trialflow.cannonType = 'confetti';
trialflow.reward = 'standard';
trialflow.shield = 'variableWithSD';
trialflow.shieldType = 'constant';
trialflow.input = 'mouse';
trialflow.colors = 'colorful';

% Display-object instance
display = al_display();

% Circle-object instance
circle = al_circle(display.windowRect);

% Cannon-object instance
cannon = al_cannon(false);
cannon.nParticles = 40;
cannon.confettiStd = 4;
cannon.confettiAnimationStd = 2;

% Colors-object instance
colors = al_colors(cannon.nParticles);

% Put all object instances in task object
taskParam = al_objectClass();
taskParam.gParam = gParam;
taskParam.trialflow = trialflow;
taskParam.display = display;
taskParam.circle = circle;
taskParam.cannon = cannon;
taskParam.colors = colors;

% Hazard rate and concentration
haz = 0.125;
concentration = 12;

% Generate cannon-visible block
% -----------------------------

% Task-data-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

while 1

    % Generate outcomes using cannon-data function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    if sum(taskData.cp(2:9)) == 1 && sum(taskData.cp) == 4
        break
    end

end

% Generate outcomes using confetti-data function
taskData = taskData.al_confettiData(taskParam);

% Save the object without converting to struct
taskData.saveAsStruct = false;
taskData = saveobj(taskData);  % Returns the object itself
% save('Files/visCannonPracticeHamburg.mat', 'taskData');

% Generate cannon-practice block
% ------------------------------

% Update colors
taskParam.trialflow.colors = 'dark';
taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

% TaskData-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

while 1

    % Generate outcomes using cannon-data function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    if sum(taskData.cp) == 4
        break
    end

end

% Generate outcomes using confetti-data function
taskData = taskData.al_confettiData(taskParam);

% Save the object without converting to struct
taskData.saveAsStruct = false;
taskData = saveobj(taskData);  % Returns the object itself
% save('Files/cannonPractice.mat', 'taskData');


% Generate final cannon-hidden block
% ----------------------------------

% Task-data-object instance
taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

while 1

    % Generate outcomes using cannon-data function
    taskData = taskData.al_cannonData(taskParam, haz, concentration, taskParam.gParam.safe);

    if sum(taskData.cp) == 4
        break
    end

end

% Generate outcomes using confetti-data function
taskData = taskData.al_confettiData(taskParam);

% Save the object without converting to struct
taskData.saveAsStruct = false;
taskData = saveobj(taskData);  % Returns the object itself
% save('Files/hidCannonPracticeHamburg_c16.mat', 'taskData');