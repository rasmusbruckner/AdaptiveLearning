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

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

if runIntro
    al_commonConfettiInstructions(taskParam)
end

% Update trial flow
taskParam.trialflow.shot = 'static';
taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.trialflow.exp = 'exp';

taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

% Initialize and set up eye-tracker file
if taskParam.gParam.eyeTracker
    et_file_name = sprintf('ec_%s', taskParam.subject.ID);
    et_file_name=[et_file_name]; % todo: check if this is really necessary

    % options.dist = 40; % viewing distance in cm
    % options.width = 30; % physical width of the screen in cm
    % options.height = 21; % physical height of the screen in cm
    % options.window_rect = taskParam.display.windowRect;
    % options.frameDur = Screen('GetFlipInterval', taskParam.display.window.onScreen); % duration of one frame
    % options.frameRate = Screen('NominalFrameRate', taskParam.display.window.onScreen); % Hz
    
    % Todo test if we can also pass object instead instead of new structure
    options.dist = taskParam.eyeTracker.dist;
    options.width = taskParam.eyeTracker.width;
    options.height = taskParam.eyeTracker.height;
    options.window_rect = taskParam.display.windowRect;
    options.frameDur = taskParam.eyeTracker.frameDur;
    options.frameRate = taskParam.eyeTracker.frameRate;
    [el, options] = ELconfig(taskParam.display.window.onScreen, et_file_name, options, 1); % eye-link config file

    % Calibrate the eye tracker
    EyelinkDoTrackerSetup(el);
end


% Start Eyelink recording - calibration and validation of eye-tracker before each block
if taskParam.gParam.eyeTracker
    Eyelink('StartRecording');
    WaitSecs(0.1);
    Eyelink('message', 'Start recording Eyelink');

    % Reference time stamp
    taskParam.timingParam.ref = GetSecs();
end

% ------------------------------
% 3. Optionally baseline arousal
% ------------------------------

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
    al_baselineArousal(taskParam)

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
    al_indicateNoise(taskParam, 'lowNoise', true)
    dataLowNoise = al_confettiLoop(taskParam, 'main', taskDataLowNoise, trial);

    % ... high noise second
    % ---------------------

    % Run task
    al_indicateNoise(taskParam, 'highNoise', true)
    dataHighNoise = al_confettiLoop(taskParam, 'main', taskDataHighNoise, trial);

else

    % High noise first...
    % -------------------

    % Run task
    al_indicateNoise(taskParam, 'highNoise', true)
    dataHighNoise = al_confettiLoop(taskParam, 'main', taskDataHighNoise, trial);

    % ... low noise second
    % --------------------

    % Run task
    al_indicateNoise(taskParam, 'lowNoise', true)
    dataLowNoise = al_confettiLoop(taskParam, 'main', taskDataLowNoise, trial);

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
    al_bigScreen(taskParam, header, txt, feedback);

    % Meaure baseline arousal
    al_baselineArousal(taskParam)

end

% Save Eyelink data
% -----------------

if taskParam.gParam.eyeTracker
    et_path=pwd;
    et_file_name=[et_file_name, '.edf'];

    fprintf('Saving EyeLink data to %s\n', et_path)
    eyefilename = fullfile(et_path,et_file_name);
    Eyelink('CloseFile');
    Eyelink('WaitForModeReady', 500);
    try
        status = Eyelink('ReceiveFile', et_file_name, eyefilename);
        disp(['File ' eyefilename ' saved to disk']);
    catch
        warning(['File ' eyefilename ' not saved to disk']);
    end
    Eyelink('StopRecording');
end
