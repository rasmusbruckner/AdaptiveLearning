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
%  Todo: Write a unit test and integration test for high/low noise

% Screen background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;
unitTest = taskParam.unitTest;
concentration = taskParam.gParam.concentration;
haz = taskParam.gParam.haz;

% Not yet included but relevant in future
cBal = taskParam.subject.cBal;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

if runIntro && ~unitTest
    al_commonConfettiInstructions(taskParam)
end

taskParam.trialflow.exp = 'exp';
% Turn off animations
taskParam.trialflow.shot = 'static';
%taskParam.trialflow.shot = 'animate cannonball';
taskParam.trialflow.colors = 'dark'; %'blackWhite';
taskParam.trialflow.shieldAppearance = 'lines';

taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors);

% Initialize eye-tracker file
if taskParam.gParam.eyeTracker
    et_file_name = sprintf('ec_%s', taskParam.subject.ID);
    et_file_name=[et_file_name, '.edf']; 
end

% Set up eye-tracker
if taskParam.gParam.eyeTracker
    
    options.dist = 40; % viewing distance in cm
    options.width = 30; % physical width of the screen in cm
    options.height = 21; % physical height of the screen in cm
    options.window_rect = taskParam.display.windowRect;
    options.frameDur = Screen('GetFlipInterval', taskParam.display.window.onScreen); %duration of one frame
    options.frameRate = Screen('NominalFrameRate', taskParam.display.window.onScreen); %Hz
    [el, options] = ELconfig(taskParam.display.window.onScreen, et_file_name, options, 1); % screenNumber
    
    % Calibrate the eye tracker
    EyelinkDoTrackerSetup(el);
end

% ------------
% 3. Main task
% ------------

% Extract number of trials
trial = taskParam.gParam.trials;

%% Todo: ensure that outcome generation is done only once for each
% condition.. just order is adjusted. this will be especially 
% relevant to longer cBal cases such as Dresden or M/EEG
%% In this context, cBal will be udpated

if cBal == 1

    % Low noise first...
    % ------------------

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

        % Generate outcomes using cannon-data function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(1), taskParam.gParam.safe);

        % Generate outcomes using confetti-data function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    al_indicateNoise(taskParam, 'lowNoise')
    dataLowNoise = al_confettiLoop(taskParam, 'main', taskData, trial);

    % ... high noise second
    % ---------------------

    % Get data
    if ~unitTest

        % TaskData-object instance
        taskData = al_taskDataMain(trial, taskParam.gParam.taskType);

        % Generate outcomes using cannonData function
        taskData = taskData.al_cannonData(taskParam, haz, concentration(2), taskParam.gParam.safe);

        % Generate outcomes using confettiData function
        taskData = taskData.al_confettiData(taskParam);

    else
        load('integrationTest_Hamburg.mat','taskData')
    end

    % Run task
    al_indicateNoise(taskParam, 'highNoise')
    dataHighNoise = al_confettiLoop(taskParam, 'main', taskData, trial);

else

    error('cBal 2 not yet updated')
% 
%     % High noise first...
%     % -------------------
% 
%     % Get data
%     if ~unitTest
%         taskData = al_generateOutcomesMain(taskParam, haz, concentration(2), 'main');
%     else
%         load('integrationTest_Hamburg.mat','taskData')
%     end
% 
%     % Run task
%     al_indicateNoise(taskParam, 'highNoise')
%     dataLowNoise = al_confettiLoop(taskParam, 'main', taskData, trial);
% 
%     % ... low noise second
%     % --------------------
% 
%     % Get data
%     if ~unitTest
%         taskData = al_generateOutcomesMain(taskParam, haz, concentration(1), 'main');
%     else
%         load('integrationTest_Hamburg.mat','taskData')
%     end
% 
%     % Run task
%     al_indicateNoise(taskParam, 'lowNoise')
%     dataHighNoise = al_confettiLoop(taskParam, 'main', taskData, trial);
% 
% end
end