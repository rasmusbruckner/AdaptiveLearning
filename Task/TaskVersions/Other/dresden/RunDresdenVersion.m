function [dataLowNoise, dataHighNoise] = RunDresdenVersion(unitTest, cBal, day)
%RUNDRESDENVERSION This function runs the Dresden version of the cannon task.
%
% Documentation
% Unit test
% Contributors
%
% Last updated: 08/21


% Check if unit test is requested
if ~exist('unitTest', 'var') || isempty(unitTest)
    unitTest = false;
end

KbName('UnifyKeyNames')

% Check optional input related to unit test
% -----------------------------------------

if exist('cBal', 'var') && ~unitTest
    error('No unit test: cBal cannot be used');
elseif exist('cBal', 'var') && unitTest
    if ~ischar(cBal)
        error('cBal must be char');
    end
end

if exist('day', 'var') && ~unitTest
    error('No unit test: day cannot be used');
elseif exist('cBal', 'var') && unitTest
    if ~ischar(day)
        error('day must be char');
    end
end

% Reset random number generator to ensure different outcome sequences
% when we don't run a unit test
if ~unitTest
    rng('shuffle')
else
    rng(1)
end

% ----------------------------
% Set relevant task parameters
% ----------------------------
 
% Indicate your computer
computer = 'Macbook';

% Set number of trials of main task
trials = 2; %20;

% Set number of trials of control task
controlTrials = 4;  % this is the new control version that we added to control for differences between groups

% Number of practice trials 
practTrials = 2; 

% Number of trials to introduce the shield in the cover story
shieldTrials = 4; 

% Choose if task instructions should be shown
runIntro = false;

% Choose if dialogue box should be shown
askSubjInfo = true;

% Determine blocks
blockIndices = [1 101 999 999];

% Use catch trials where cannon is shown occasionally
useCatchTrials = true; 

% Set text size and sentence length
sentenceLength = 85;

% Choose screen number
screenNumber = 1;%2; % 1: one screen; 2: two screens

% Number of catches during practice that is required to continue with main task
practiceTrialCriterion = 10;

% Run task in debug mode with smaller window
debug = false; %false;

%showTickmark = nan;

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

% Initialize
gParam = al_gparam();
gParam.taskType = 'dresden';
%gParam.computer = computer;
gParam.trials = trials;
gParam.controlTrials = controlTrials;
gParam.practTrials = practTrials;
gParam.shieldTrials = shieldTrials;
gParam.runIntro = runIntro;
gParam.askSubjInfo = askSubjInfo;
gParam.blockIndices = blockIndices;
gParam.useCatchTrials = useCatchTrials;
%gParam.sentenceLength = sentenceLength;
gParam.screenNumber = screenNumber;
%gParam.practiceTrialCriterion = practiceTrialCriterion;
gParam.debug = debug;
gParam.concentration = [8 8 99999999]; % [16 8 99999999];
gParam.haz = [.125 1 0];
gParam.practiceTrialCriterionEstErr = 9;


% Create object instance
%gParam = al_gparam(gparam_init);

% -------------------------------------
% Create object instance for trial flow
% -------------------------------------

% Todo: What is the best way to document this?
trialflow = al_trialflow();
% trialflow.shot = ' ';
% trialflow.confetti = 'show confetti cloud';
% trialflow.cannonball_start = 'center';
trialflow.cannon = 'hide cannon';
trialflow.background = 'noPicture';
% trialflow.currentTickmarks = 'show';
% trialflow.cannonType = "confetti";
% trialflow.reward = "standard";
% trialflow.shield = "fixed";
% trialflow.shieldType = "constant";
trialflow.input = "keyboard";
trialflow.shotAndShield = "sequential";
trialflow.shot = "static";


% todo update in line with more recent versions

% User Input
% ----------
% If no user input requested
if askSubjInfo == false
    
    ID = '99999';
    age = '99';
    sex = 'm/w';
    cBal = 1;
    reward = 1;
    
    
    group = '1';
    subject = struct('ID', ID, 'age', age, 'sex', sex, 'group', group, 'cBal', cBal, 'rew', reward, 'date', date, 'session', '1');
    
    
    % If user input requested
elseif askSubjInfo == true
   
    
    prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal:', 'Reward:'};
    
    
    name = 'SubjInfo';
    numlines = 1;
    
    randomize = false;
    % You can choose to randomize input, i.e., random cBal
    if randomize
            
        cBal = num2str(randi(6));
        reward = num2str(randi(2));

    else
        cBal = '1';
        reward = '1';
        
    end
    
    % Specify default that is shown on screen
    defaultanswer = {'99999','99', '1', 'm', cBal, reward};
        
    
    % Add information that is not specified by user
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
        
    subjInfo{7} = date;
        
    
    % Check if user input makes sense
    % -------------------------------
    % Check ID
    if numel(subjInfo{1}) < 5 ...
            || numel(subjInfo{1}) > 5
        msgbox('ID: must consist of five numbers!');
        return
    end
    
    % Check group and session 
    if subjInfo{3} ~= '1' && subjInfo{3} ~= '2'
        msgbox('Group: "1" or "2"?');
        return
    end
           
    % Check sex
    if subjInfo{4} ~= 'm' && subjInfo{4} ~= 'f'
        msgbox('Sex: "m" or "f"?');
        return

    end

    % Check cBal   
    if subjInfo{5} ~= '1' && subjInfo{5} ~= '2' && subjInfo{5} ~= '3' && subjInfo{5} ~= '4' && subjInfo{5} ~= '5' && subjInfo{5} ~= '6'
        msgbox('cBal: 1, 2, 3, 4, 5 or 6?');
        return
    end


    % Check reward
    if subjInfo{6} ~= '1' && subjInfo{6} ~= '2'
        msgbox('Reward: 1 or 2?');
        return
    end
    
    
    % Put all relevant subject info in structure
    % ------------------------------------------
    subject = struct('ID', subjInfo(1), 'age', str2double(subjInfo(2)), 'sex', subjInfo(4), 'group', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))), 'rew',...
        str2double(cell2mat(subjInfo(6))), 'date', subjInfo(7), 'session', '1');

    
    % Check if ID exists in save folder
    checkIdInData = dir(sprintf('*%s*', num2str(cell2mat((subjInfo(1))))));

    
    fileNames = {checkIdInData.name};
    
    if  ~isempty(fileNames)
        msgbox('Diese ID wird bereits verwendet!');
        return
    end
end
    

% ------------------
% Display properties
% ------------------


% Screen size
screensize = [1 1 1920 1080]; %[1    1    2560    1440]; %; [1 1 1920 1080];  % fu ohne bildschirm [1    1    2560    1440]; get(0,'MonitorPositions'); ausprobieren
% Confetti cannon image rectangle determining the size of the cannon
%imageRect = [0 00 60 200];


% Display-object instance
display = al_display();

% Deal with psychtoolbox warnings
% Todo: Make sure that all tests are passed on task PC
% display.screen_warnings();

% Set screensize
display.screensize = screensize;
display.backgroundCol = [66, 66, 66];
%display.imageRect = imageRect;

% Open psychtoolbox window
display = display.openWindow(gParam);

% Todo: Docment this
display = display.createRects();
display = display.createTextures(trialflow.cannonType);

% Hide cursor
hidePtbCursor = true;

% Disable keyboard and, if desired, mouse cursor
if hidePtbCursor == true
    HideCursor;
end
ListenChar(2);

% ---------------------------------------------
% Create object instance with circle parameters
% ---------------------------------------------
% Radius of prediction spot
predSpotRad = 10;
circle = al_circle(display.windowRect); 
%circle.rotationRad = rotationRad;
circle.predSpotRad = predSpotRad;
%circle.tickWidth = tickWidth;
% circle.shieldFixedSizeFactor = shieldFixedSizeFactor;
%circle.outcSize = 5;
circle = circle.compute_circle_props();


% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

%colors_init = al_colorsinit();
colors = al_colors();

% ---------------------------------------------
% Create object instance with key parameters
% ---------------------------------------------

%keys_init = al_keysinit();
keys = al_keys();

% ---------------------------------------------
% Create object instance with trigger parameters
% ---------------------------------------------

sendTrigger = false; 
if sendTrigger == true
    config_io;
end

%triggers_init = al_triggersinit();
triggers = al_triggers();

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

%timing_init = al_timinginit();
%timingParam = al_timing();
% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

% Ensure this is properly documented in al_confettiEEGLoop
timingParam = al_timing();
timingParam.fixCrossLength = 1; 
timingParam.outcomeLength = 0.5;
timingParam.shieldLength = 0.5;
timingParam.rewardLength = 1.0;

% This is a reference timestamp at the start of the experiment.
% This is not equal to the first trial or so. So be carful when using
% EEG or pupillometry and make sure the reference is specified as desired.
timingParam.ref = GetSecs();

% ---------------------------------------------
% Create object instance with srings to display
% ---------------------------------------------

%strings_init = al_stringsinit();
%strings = al_strings();

% ----------------------------------------------
% Create object instance with strings to display
% ----------------------------------------------
% Set sentence length
sentenceLength = 100;

% Set text and header size
textSize = 35;
headerSize = 50;


strings = al_strings();
strings.txtPressEnter = 'Weiter mit Enter';
strings.sentenceLength = sentenceLength;
strings.textSize = textSize;
strings.headerSize = headerSize;


% ----------------------------------------------
% Create object instance with trigger parameters
% ----------------------------------------------

triggers = al_triggers();
%triggers.sampleRate = sampleRate;
%triggers.port = port;

% ---------------------------------------
% Put all object instances in task object
% ---------------------------------------

% Object that harbors all relevant object instances
taskParam = al_objectClass();
taskParam.gParam = gParam;
taskParam.circle = circle;
taskParam.colors = colors;
taskParam.keys = keys;
taskParam.triggers = triggers;
taskParam.timingParam = timingParam;
taskParam.strings = strings;

taskParam.unitTest = unitTest;

taskParam.triggers = triggers;
taskParam.trialflow = trialflow;
taskParam.display = display;



% ---------------
% Run ARC version
% ---------------

unitTest = false;
%Data = al_dresdenVersion(taskParam, unitTest);
trials = taskParam.gParam.trials;
askSubjInfo = taskParam.gParam.askSubjInfo;
%randomize = taskParam.gParam.randomize;
randomize = false;
taskType = taskParam.gParam.taskType;
screenNumber = taskParam.gParam.screenNumber;
debug = taskParam.gParam.debug;

% Check number of trials
if  (trials > 1 && mod(trials, 2)) == 1
    msgbox('All trials must be even or equal to 1!');
    return
end

% Check number of trials
% if  (trials > 1 && mod(trials, 2)) == 1
%     msgbox('All trials must be even or equal to 1!');
%     return
% end

% Save directory for different computers that were used in the past
cd('~/Dropbox/AdaptiveLearning/DataDirectory');

% Reset clock
%a = clock;
%rand('twister', a(6).*10000);

% % User Input
% % ----------
% % If no user input requested
% if askSubjInfo == false
%     
%     ID = '99999';
%     age = '99';
%     sex = 'm/w';
%     cBal = 1;
%     reward = 1;
%     
%     
%     group = '1';
%     subject = struct('ID', ID, 'age', age, 'sex', sex, 'group', group, 'cBal', cBal, 'rew', reward, 'date', date, 'session', '1');
%     
%     
%     % If user input requested
% elseif askSubjInfo == true
%    
%     
%     prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal:', 'Reward:'};
%     
%     
%     name = 'SubjInfo';
%     numlines = 1;
%     
%     % You can choose to randomize input, i.e., random cBal
%     if randomize
%             
%         cBal = num2str(randi(6));
%         reward = num2str(randi(2));
% 
%     else
%         cBal = '1';
%         reward = '1';
%         
%     end
%     
%     % Specify default that is shown on screen
%     defaultanswer = {'99999','99', '1', 'm', cBal, reward};
%         
%     
%     % Add information that is not specified by user
%     subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
%         
%     subjInfo{7} = date;
%         
%     
%     % Check if user input makes sense
%     % -------------------------------
%     % Check ID
%     if numel(subjInfo{1}) < 5 ...
%             || numel(subjInfo{1}) > 5
%         msgbox('ID: must consist of five numbers!');
%         return
%     end
%     
%     % Check group and session 
%     if subjInfo{3} ~= '1' && subjInfo{3} ~= '2'
%         msgbox('Group: "1" or "2"?');
%         return
%     end
%            
%     % Check sex
%     if subjInfo{4} ~= 'm' && subjInfo{4} ~= 'f'
%         msgbox('Sex: "m" or "f"?');
%         return
% 
%     end
% 
%     % Check cBal   
%     if subjInfo{5} ~= '1' && subjInfo{5} ~= '2' && subjInfo{5} ~= '3' && subjInfo{5} ~= '4' && subjInfo{5} ~= '5' && subjInfo{5} ~= '6'
%         msgbox('cBal: 1, 2, 3, 4, 5 or 6?');
%         return
%     end
% 
% 
%     % Check reward
%     if subjInfo{6} ~= '1' && subjInfo{6} ~= '2'
%         msgbox('Reward: 1 or 2?');
%         return
%     end
%     
%     
%     % Put all relevant subject info in structure
%     % ------------------------------------------
%     subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(4), 'group', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))), 'rew',...
%         str2double(cell2mat(subjInfo(6))), 'date', subjInfo(7), 'session', '1');
% 
%     
%     % Check if ID exists in save folder
%     checkIdInData = dir(sprintf('*%s*', num2str(cell2mat((subjInfo(1))))));
% 
%     
%     fileNames = {checkIdInData.name};
%     
%     if  ~isempty(fileNames)
%         msgbox('Diese ID wird bereits verwendet!');
%         return
%     end
% end
%     
    
%     % Deal with psychtoolbox warnings
%     Screen('Preference', 'VisualDebugLevel', 3);
%     Screen('Preference', 'SuppressAllWarnings', 1);
%     Screen('Preference', 'SkipSyncTests', 2);
%     
%     % Get screen properties
%     screensize = get(0,'MonitorPositions');
%     screensize = screensize(screenNumber, :);
%     screensizePart = screensize(3:4);
%     zero = screensizePart / 2;
%     [window.onScreen, windowRect, textures] = OpenWindow(debug, screenNumber);
%     [window.screenX, window.screenY] = Screen('WindowSize', window.onScreen);
%     window.centerX = window.screenX * 0.5; % center of screen in X direction
%     window.centerY = window.screenY * 0.5; % center of screen in Y direction
%     window.centerXL = floor(mean([0 window.centerX])); % center of left half of screen in X direction
%     window.centerXR = floor(mean([window.centerX window.screenX])); % center of right half of screen in X direction
%     
% 
     fieldNames = struct('actJitter', 'actJitter', 'block', 'block',...
        'initiationRTs', 'initiationRTs', 'timestampOnset', 'timestampOnset',...
        'timestampPrediction', 'timestampPrediction', 'timestampOffset',...
        'timestampOffset', 'oddBall', 'oddBall', 'oddballProb',...
        'oddballProb', 'driftConc', 'driftConc', 'allASS', 'allASS', 'ID',...
        'ID', 'concentration', 'concentration', 'age', 'age', 'sex', 'sex',...
        'rew', 'rew', 'actRew', 'actRew', 'date','Date', 'cond', 'cond',...
        'trial', 'trial', 'outcome', 'outcome','distMean', 'distMean', 'cp',...
        'cp', 'haz', 'haz', 'TAC', 'TAC', 'shieldType','shieldType',...
        'catchTrial', 'catchTrial', 'triggers', 'triggers', 'pred',...
        'pred','predErr', 'predErr', 'memErr', 'memErr', 'UP', 'UP',...
        'hit', 'hit', 'cBal', 'cBal', 'perf', 'perf', 'accPerf', 'accPerf',...
        'reversalProb', 'reversalProb');
    
    % Start time for triggers etc.
    ref = GetSecs;
    
        %taskParam.timing.ref = ref;
        % ---------------------------------------------
    % Create object instance with timing parameters
    % ---------------------------------------------
    
    timingParam = al_timing();
    timingParam.cannonBallAnimation = 1.5;
    
    % This is a reference timestamp at the start of the experiment.
    % This is not equal to the first trial or so. So be carful when using
    % EEG or pupillometry and make sure the reference is specified as desired.
    timingParam.ref = GetSecs();

%    taskParam.gParam.screensize = screensize;
%    taskParam.display.zero = zero;
 %   taskParam.gParam.window = window;
  %  taskParam.gParam.windowRect = windowRect;
    % taskParam.gParam.showTickmark = showTickmark;
    taskParam.circle.cannonEndRect = [0 0 taskParam.circle.cannonEndDiam taskParam.circle.cannonEndDiam];
    
    
    % Circle XX
%     taskParam.circle.centBoatRect = CenterRect(taskParam.circle.boatRect, windowRect);
%     taskParam.circle.predCentSpotRect = CenterRect(taskParam.circle.predSpotRect, windowRect);
%     taskParam.circle.outcCentRect = CenterRect(taskParam.circle.outcRect, windowRect);
%     taskParam.circle.outcCentSpotRect = CenterRect(taskParam.circle.outcRect, windowRect);
%     taskParam.circle.cannonEndCent = CenterRect(taskParam.circle.cannonEndRect, windowRect);
%     taskParam.circle.centSpotRectMean = CenterRect(taskParam.circle.spotRectMean,windowRect);
    
    
    % Parameters related to keyboard
    % ------------------------------
    KbName('UnifyKeyNames')
    taskParam.fieldNames = fieldNames;  
%    taskParam.textures = textures;  
    %taskParam.unitTest = unitTest; 
    
    % class(taskParam)
    taskParam.subject = subject;
    
    % Condition-object initialization
    % -------------------------------
    cond_init.txtPressEnter = taskParam.strings.txtPressEnter;
    cond_init.runIntro = taskParam.gParam.runIntro;
    cond_init.unitTest = unitTest;
    cond_init.taskType = taskType;
    cond_init.cBal = cBal;
    cond_init.concentration = taskParam.gParam.concentration; 
    cond_init.haz = taskParam.gParam.haz;
    %cond_init.testDay = testDay;
    cond_init.showTickmark = taskParam.gParam.showTickmark;
    

    [dataMain] = al_dresdenConditions(taskParam); %dataFollowCannon, dataFollowOutcome

    % Condition-object instance
    % --------------------------
    
    
      % todo: init anpassen dass für arc spezifisch ist. 
   % cond = al_dresden_conditions(cond_init);
    
%     % hier noch comments!
%     % all of this has to happen in dresdenConditions
%     if subject.cBal == 1
% 
%         % Main task using function
% 
%         % FollowOutcome using function
% 
%         % FollowCannon using function
% 
%         
%         %DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
%          %  header, testDay, cBal, showTickmark);
%        
%          
%          % cond = cond.MainCondition(taskParam, subject);
%         
%        %DataMain = cond.DataMain;
%         %taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam,
%         %debug, unitTest);
%         
%         
%         %cond = cond.FollowOutcomeCondition(taskParam, subject);
%         %DataFollowOutcome = cond.DataFollowOutcome;
%         
%         
%         %taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         %cond = cond.FollowCannonCondition(taskParam, subject);
%         %DataFollowCannon = cond.DataFollowCannon;
%         
%     elseif subject.cBal == 2
%         
%         DataMain = cond.MainCondition(runIntro, unitTest, taskType,subject, taskParam, haz, concentration, txtPressEnter,...
%             header, testDay, cBal, showTickmark);
%         taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         DataFollowCannon = cond.FollowCannonCondition;
%         taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         DataFollowOutcome = cond.FollowOutcomeCondition;
%         
%     elseif subject.cBal == 3
%         
%         DataFollowOutcome = cond.FollowOutcomeCondition;
%         taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
%             header, testDay, cBal, showTickmark);
%         taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         DataFollowCannon = cond.FollowCannonCondition;
%         
%     elseif subject.cBal == 4
%         
%         DataFollowCannon = cond.FollowCannonCondition;
%         taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
%             header, testDay, cBal, showTickmark);
%         taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         DataFollowOutcome = cond.FollowOutcomeCondition;
%         
%     elseif subject.cBal == 5
%         
%         DataFollowOutcome = cond.FollowOutcomeCondition;
%         taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         DataFollowCannon = cond.FollowCannonCondition;
%         taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
%             header, testDay, cBal, showTickmark);
%         
%     elseif subject.cBal == 6
%         
%         DataFollowCannon = cond.FollowCannonCondition;
%         taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         DataFollowOutcome = cond.FollowOutcomeCondition;
%         taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
%         DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
%             header, testDay, cBal, showTickmark);
%         
%     end
    
    % Translate performance into monetary reward
    % ------------------------------------------
    
    totWin = dataMain.accPerf(end);% + DataFollowOutcome.accPerf(end) + DataFollowCannon.accPerf(end);
    
    % Combine data in one structure
    % -----------------------------

    %Data.DataMain = DataMain;
    %Data.DataFollowOutcome = DataFollowOutcome;
    %Data.DataFollowCannon = DataFollowCannon;

%     % End of task
%     % -----------
%     al_endTask(taskType, taskParam, taskParam.strings.textSize, totWin, subject)
%     ListenChar();
%     ShowCursor;
%     Screen('CloseAll');
%     
%     % Inform user about timing
%     sprintf('total time: %.1f minutes', str2mat((GetSecs - ref)/60))
    %     
    % -----------
    % End of task
    % -----------
    
    header = 'Ende des Versuchs!';
    txt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben insgesamt %i Punkte gewonnen!', totWin);
    feedback = true; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback, true); % todo: function has to be cleaned
    
    ListenChar();
    ShowCursor;
    Screen('CloseAll');
    
    % Inform user about timing
    fprintf('Total time: %.1f minutes\n', char((GetSecs - timingParam.ref)/60));



end
