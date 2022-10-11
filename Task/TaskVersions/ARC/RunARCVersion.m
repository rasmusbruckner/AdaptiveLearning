%RUNARCVERSION   This script runs the ARC version of the cannon task.
%
% Documentation
% Unit test
% Contributors
%
% Last updated: 12/21

% ----------------------------
% Set relevant task parameters
% ----------------------------
 
% Indicate your computer
computer = 'Macbook';

% Set number of trials of main task
trials = 2; % 20;

% Set number of trials of control task testing speed and accuracy
controlTrials = 4;

% Number of practice trials
practTrials = 2; 

% Number of trials to introduce the shield in the cover story
shieldTrials = 4; 

% Risk parameter: Inverse variability of cannonballs
concentration = [8 8 99999999]; % [16 8 99999999];

% Hazard rate determining a priori changepoint probability
haz = [.125 1 0];

% Choose if task instructions should be shown
runIntro = true; %%true; %false;

% Choose if dialogue box should be shown
askSubjInfo = true;

% Determine blocks
blockIndices = [1 101 999 999];

% Use catch trials where cannon is shown occasionally
useCatchTrials = true; 

% Set sentence length
sentenceLength = 85;

% Choose screen number
screenNumber = 1; % 2;% 2; % 1: one screen; 2: two screens

% Number of catches during practice that is required to continue with main task
practiceTrialCriterion = 10;

% Run task in debug mode with smaller window
debug = true;%true; %false;

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

% % Initialize
% gparam_init = al_gparaminit();
% gparam_init.taskType = 'ARC';
% gparam_init.computer = computer;
% gparam_init.trials = trials;
% gparam_init.controlTrials = controlTrials;
% gparam_init.practTrials = practTrials;
% gparam_init.shieldTrials = shieldTrials;
% gparam_init.runIntro = runIntro;
% gparam_init.askSubjInfo = askSubjInfo;
% gparam_init.blockIndices = blockIndices;
% gparam_init.useCatchTrials = useCatchTrials;
% gparam_init.sentenceLength = sentenceLength;
% gparam_init.screenNumber = screenNumber;
% gparam_init.practiceTrialCriterion = practiceTrialCriterion;
% gparam_init.debug = debug;
% gparam_init.concentration = concentration;
% gparam_init.haz = haz;
% 
% % Create object instance
% gParam = al_gparam(gparam_init);

% Specify data directory
dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';


gParam = al_gparam();
% gparam_init = al_gparaminit();
gParam.taskType = 'ARC';
gParam.computer = computer; 
gParam.trials = trials;
%gParam.controlTrials = controlTrials;
gParam.practTrials = practTrials;
gParam.shieldTrials = shieldTrials;
gParam.runIntro = runIntro;
gParam.askSubjInfo = askSubjInfo;
gParam.blockIndices = blockIndices;
gParam.useCatchTrials = useCatchTrials;
gParam.sentenceLength = sentenceLength;
gParam.textSize = 30;%textSize; %30; % todo: in taskParam!!
gParam.screenNumber = screenNumber;
gParam.practiceTrialCriterion = practiceTrialCriterion;
gParam.debug = debug;
gParam.concentration = concentration;
gParam.haz = haz;
gParam.dataDirectory = dataDirectory;
gParam.showTickmark = true;
% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

colors = al_colors();

% ------------------------------------------
% Create object instance with key parameters
% ------------------------------------------

keys = al_keys();

% ----------------------------------------------
% Create object instance with trigger parameters
% ----------------------------------------------

sendTrigger = false;
if sendTrigger == true
    config_io;
end

triggers = al_triggers();

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

timingParam = al_timing();
timingParam.outcomeLength = 1;

% ----------------------------------------------
% Create object instance with strings to display
% ----------------------------------------------

strings = al_strings();

% -------------------------------------
% Create object instance for trial flow
% -------------------------------------

trialflow = al_trialflow();
trialflow.background = 'none';
trialflow.confetti = 'none';


% ---------------
% Run ARC version
% ---------------

unitTest = false;
%DataMain = al_ARCVersion(taskParam, unitTest);

% Initialize task
% ----------------

if ~unitTest
    clear vars
    unitTest = false;
end

% Check number of trials
if  (gParam.trials > 1 && mod(gParam.trials, 2)) == 1
    msgbox('All trials must be even or equal to 1!');
    return
end

% Save directory
cd('~/Dropbox/AdaptiveLearning/DataDirectory');
%cd('\\vboxsvr\dropbox\AdaptiveLearning\DataDirectory');

% Reset clock
a = clock;
rand('twister', a(6).*10000);

% User Input
% ----------

% If no user input requested
if gParam.askSubjInfo == false
    
    ID = '99999';
    age = '99';
    sex = 'm/w';
    cBal = 1;
    reward = 1;
    
    group = '1';
    subject = struct('ID', ID, 'age', age, 'sex', sex, 'group', group, 'cBal', cBal, 'rew', reward, 'date', date, 'session', '1');

    
    % If user input requested
else
    
    prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal:', 'day:'};
    
    name = 'SubjInfo';
    numlines = 1;
    
    % You can choose to randomize input, i.e., random cBal
%    if gParam.randomize
        
 %       cBal = num2str(randi(4));
  %      reward = '1';
   %     testDay = num2str(randi(2));
        % end
        
   % else
        cBal = '1';
        reward = '1';
        testDay = '1';
    %end
    
    defaultanswer = {'99999','99', '1', 'm', cBal, testDay};
    
    % Add information that is not specified by user
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
    subjInfo{7} = reward;
    subjInfo{8} = date;
    
    % Put all relevant subject info in structure
    % ------------------------------------------
    subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(4), 'group', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))),...
        'rew', str2double(cell2mat(subjInfo(7))), 'testDay',str2double(cell2mat(subjInfo(6))), 'date', subjInfo(8), 'session', '1');
    testDay = subject.testDay;
    
    %sub_init = al_subinit();
    subobj = al_subject();
    subobj.ID = subjInfo{1}; %str2double(cell2mat(subjInfo(1)));
    subobj.age = subjInfo{2};%str2double(cell2mat(subjInfo(2)));
    subobj.sex = subjInfo{4};
    subobj.group = subjInfo{3};%str2double(cell2mat(subjInfo(3)));
    subobj.cBal = str2double(cell2mat(subjInfo(5)));
    subobj.rew = str2double(cell2mat(subjInfo(7)));
    subobj.testDay = str2double(cell2mat(subjInfo(6)));
    subobj.date = (cell2mat(subjInfo(8)));
    subobj.session = '1';
    
    subobj.checkID()
    subobj.checkGroup()
    subobj.checkSex()
    subobj.checkCBal()
    subobj.checkTestDay()
    
    %subject = subobj;
    
    % For ARC: check if tickmark on or off
    % cbal = 1,2: day1 - tickmark on, day2 - tickmark off
    % cbal = 3,4: day1 - tickmark off, day2 - tickmark on
    cBal = subject.cBal;
    if (isequal(gParam.taskType, 'ARC') && cBal == 1 && testDay == 1) || (isequal(gParam.taskType, 'ARC') && cBal == 2 && testDay == 1) ||...
            (isequal(gParam.taskType, 'ARC') && cBal == 3 && testDay == 2) || (isequal(gParam.taskType, 'ARC') && cBal == 4 && testDay == 2)
        showTickmark = true;
    elseif (isequal(gParam.taskType, 'ARC') && cBal == 1 && testDay == 2) || (isequal(gParam.taskType, 'ARC') && cBal == 2 && testDay == 2) ||...
            (isequal(gParam.taskType, 'ARC') && cBal == 3 && testDay == 1) || (isequal(gParam.taskType, 'ARC') && cBal == 4 && testDay == 1)
        showTickmark = false;
    end
    
    % Check if ID exists in save folder
    
    if showTickmark
        checkIdInData = dir(sprintf('*%s_TM*', num2str(cell2mat((subjInfo(1))))));
    elseif ~showTickmark
        checkIdInData = dir(sprintf('*%s_NTM*', num2str(cell2mat((subjInfo(1))))));
    end
    
    fileNames = {checkIdInData.name};
    
    if  ~isempty(fileNames)
        msgbox('ID and day have already been used!');
        return
    end
    
   
    
%     
%     % Deal with psychtoolbox warnings
%     Screen('Preference', 'VisualDebugLevel', 3);
%     Screen('Preference', 'SuppressAllWarnings', 1);
%     Screen('Preference', 'SkipSyncTests', 2);
%     
%     % Get screen properties
%     screensize = get(0,'MonitorPositions');
%     screensize = screensize(taskParam.gParam.screenNumber, :);
%     screensizePart = screensize(3:4);
%     zero = screensizePart / 2;
%     [window.onScreen, windowRect, textures] = OpenWindow(taskParam.gParam.debug, taskParam.gParam.screenNumber);
%     [window.screenX, window.screenY] = Screen('WindowSize', window.onScreen);
%     window.centerX = window.screenX * 0.5; % center of screen in X direction
%     window.centerY = window.screenY * 0.5; % center of screen in Y direction
%     window.centerXL = floor(mean([0 window.centerX])); % center of left half of screen in X direction
%     window.centerXR = floor(mean([window.centerX window.screenX])); % center of right half of screen in X direction
%     



% Deal with psychtoolbox warnings
    display = al_display();
    display.screen_warnings();
    display = display.openWindow(gParam);

    display = display.createRects();
    display = display.createTextures();

    display.cursorChar()


% ---------------------------------------------
% Create object instance with circle parameters
% ---------------------------------------------




circle = al_circle(display.windowRect);

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
    
%     taskParam.timingParam.ref = ref;
%     taskParam.gParam.screensize = screensize;
%     taskParam.gParam.zero = zero;
%     taskParam.gParam.window = window;
%     taskParam.gParam.windowRect = windowRect;
%     taskParam.gParam.showTickmark = showTickmark;
%     taskParam.circle.cannonEndRect = [0 0 taskParam.circle.cannonEndDiam taskParam.circle.cannonEndDiam];
%     
%     % Circle XX
%     taskParam.circle.centBoatRect = CenterRect(taskParam.circle.boatRect, windowRect);
%     taskParam.circle.predCentSpotRect = CenterRect(taskParam.circle.predSpotRect, windowRect);
%     taskParam.circle.outcCentRect = CenterRect(taskParam.circle.outcRect, windowRect);
%     taskParam.circle.outcCentSpotRect = CenterRect(taskParam.circle.outcRect, windowRect);
%     taskParam.circle.cannonEndCent = CenterRect(taskParam.circle.cannonEndRect, windowRect);
%     taskParam.circle.centSpotRectMean = CenterRect(taskParam.circle.spotRectMean,windowRect);
%     




    % Parameters related to keyboard
    % ------------------------------
    KbName('UnifyKeyNames')
    



    % ---------------------------------------
    % Put all object instances in task object
    % ---------------------------------------
    
    % Start time for triggers etc.
    taskParam = al_objectClass();
    
    %taskParam = ColorClass();
    taskParam.gParam = gParam;
    taskParam.circle = circle;
    taskParam.colors = colors;
    taskParam.keys = keys;
    taskParam.triggers = triggers;
    taskParam.timingParam = timingParam;
    taskParam.strings = strings;
    taskParam.trialflow = trialflow;
    taskParam.display = display;
    taskParam.unitTest = unitTest;
    
    % Condition-object initialization
    % -------------------------------
    cond_init.txtPressEnter = taskParam.strings.txtPressEnter;
    cond_init.runIntro = taskParam.gParam.runIntro;
    cond_init.unitTest = unitTest;
    cond_init.taskType = taskParam.gParam.taskType; %taskType;
    cond_init.cBal = cBal;
    cond_init.concentration = taskParam.gParam.concentration;
    cond_init.haz = taskParam.gParam.haz;
    cond_init.testDay = testDay;
    cond_init.showTickmark = showTickmark;
    
    % Condition-object instance
    % --------------------------
    
    cond = al_ARC_conditions(cond_init);
    
    
    % Session 1
    subject.session = '1';
    cond = cond.MainCondition(taskParam, subject);
    DataMain = cond.DataMain;
    blockWin(1) = DataMain.accPerf(end);
    
    % Session 2
    if ~unitTest
        subject.session = '2';
        cond = cond.MainCondition(taskParam, subject);
        DataMain = cond.DataMain;
        blockWin(2) = DataMain.accPerf(end);
    end
    
    % Control condition
    if ~unitTest && testDay == 1
        cond = cond.ARC_ControlCondition('ARC_controlSpeed', taskParam, subject);
        Data = cond.Data;
    elseif ~unitTest && testDay == 2
        cond.ARC_ControlCondition('ARC_controlAccuracy', taskParam, subject);
    end
    
    % Control condition
    if ~unitTest && testDay == 1
        cond = cond.ARC_ControlCondition('ARC_controlAccuracy', taskParam, subject);
        Data = cond.Data;
    elseif ~unitTest && testDay == 2
        cond.ARC_ControlCondition('ARC_controlSpeed', taskParam, subject);
    end
    
    % Translate performance into monetary reward
    % ------------------------------------------
    
    totWin = sum(blockWin);
    
    % End of task
    % -----------
    al_endTask(taskParam.gParam.taskType, taskParam, taskParam.strings.textSize, totWin, subject)
    ListenChar();
    ShowCursor;
    Screen('CloseAll');
    
    % Inform user about timing
    sprintf('total time: %.1f minutes', char((GetSecs - ref)/60))
    
end


