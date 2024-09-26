function [dataRun1, dataRun2, dataRun3] = al_commonConfettiConditionsFMRI(taskParam, startsWithRun)
%AL_COMMONCONFETTICONDITIONSFMRI This function runs the change-point condition of the cannon
%task in the scanner
%
%   Input
%       taskParam: Task-parameter-object instance
%       startsWithRun: Number of first run
%
%   Output
%       dataRun1: Task-data object run 1
%       dataRun2: Task-data object run 2
%       dataRun3: Task-data object run 3

% TODO: turn off cbal when scanner is on (same noise anyway)
% build an integration test

% Screen background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% -----------------------------------------------------
% 1. Extract some variables from task-parameters object
% -----------------------------------------------------

runIntro = taskParam.gParam.runIntro;

% --------------------------------
% 2. Show instructions, if desired
% --------------------------------

% Todo: should we implement these 2 different cases like in MD (training outside of scanner?)
% Now implemented as separate cases

if runIntro && ~taskParam.unitTest.run

    al_commonConfettiInstructions(taskParam)

else

    % Update trial flow
    taskParam.trialflow.shot = 'static';
    taskParam.trialflow.colors = 'dark';
    taskParam.trialflow.shieldAppearance = 'lines';

    % Update confetti cloud
    taskParam.cannon = taskParam.cannon.al_staticConfettiCloud(taskParam.trialflow.colors, taskParam.display);

    % Todo: potentially has to be adjusted to scanner too

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

    % Todo: Will there be a baseline arouasal session?

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

        % Measure baseline arousal
        al_baselineArousal(taskParam)

    end

    % ------------
    % 4. Main task
    % ------------

    % Extract number of trials
    trial = taskParam.gParam.trials;

    % Generate data for each run
    % --------------------------

    % Run 1
    taskDataRun1 = generateFMRIRun(trial, taskParam);

    % Run 2
    taskDataRun2 = generateFMRIRun(trial, taskParam);

    % Run 3
    taskDataRun3 = generateFMRIRun(trial, taskParam);

    % Run the task
    % ------------

    if startsWithRun == 1

        % Run 1
        al_indicateRun(taskParam, 1)
        taskParam.trialflow.exp = 'run1';
        dataRun1 = al_MRILoop(taskParam, 'main', taskDataRun1, trial);
    else
        dataRun1.hit = 0;
    end

    if startsWithRun == 1 || startsWithRun == 2

        % Run 2
        al_indicateRun(taskParam, 2)
        taskParam.trialflow.exp = 'run2';
        dataRun2 = al_MRILoop(taskParam, 'main', taskDataRun2, trial);

        % Questions with Likert scale
        % ---------------------------

        % Pain
        questionTxt = 'Wie schmerzhaft waren die letzten 20 Minuten?';
        scaleTxt = 'Schmerz-Level:';
        painLevel = al_stressSlider(taskParam, questionTxt, scaleTxt);
        KbReleaseWait;

        % Difficulty
        questionTxt = 'Wie schwierig waren die letzten 20 Minuten?';
        scaleTxt = 'Schwierigkeits-Level:';
        difficultyLevel = al_stressSlider(taskParam, questionTxt, scaleTxt);
        KbReleaseWait
        
        % Stress
        questionTxt = 'Wie gestresst fühlen Sie sich?';
        scaleTxt = 'Stress-Level:';
        stressLevel = al_stressSlider(taskParam, questionTxt, scaleTxt);
        KbReleaseWait;

        % Save rating data
        subjectRatings = struct();
        subjectRatings.painLevel = painLevel;
        subjectRatings.difficultyLevel = difficultyLevel;
        subjectRatings.stressLevel = stressLevel;
        KbReleaseWait;
        savename = sprintf('subjectRatings_%s',taskParam.subject.ID);
        save(savename, 'subjectRatings');
    else
        dataRun2.hit = 0;

    end

    if startsWithRun == 1 || startsWithRun == 2 || startsWithRun == 3

        % Run 3
        al_indicateRun(taskParam, 3)       
        taskParam.trialflow.exp = 'run3';
        dataRun3 = al_MRILoop(taskParam, 'main', taskDataRun3, trial);

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

        % Measure baseline arousal
        al_baselineArousal(taskParam)

    end

    % Save Eyelink data
    % -----------------
    
    % Todo: If we end up using this, create a function
    % Currently not sure about eye-tracker in scanner
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
end


    function taskDataRun = generateFMRIRun(trial, taskParam)
        % GENERATEFMRIRUN This helper function gets the data for the
        % different blocks
        %
        %   Input
        %       trial: Number of trials per block
        %       taskParam: Task-parameter-object instance
        % 
        %   Output
        %       taskDataRun: Task-data-object instance for current run 

        if ~taskParam.unitTest.run

            % TaskData-object instance
            taskDataRun = al_taskDataMain(trial, taskParam.gParam.taskType);

            % Generate outcomes using cannon-data function
            taskDataRun = taskDataRun.al_cannonData(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration, taskParam.gParam.safe);

            % Generate outcomes using confetti-data function
            taskDataRun = taskDataRun.al_confettiData(taskParam);

        else

            taskDataRun = taskParam.unitTest.taskDataIntegrationTest_HamburgLowNoise;

        end
    end

end