function [dataMain, dataFollowOutcome, dataFollowCannon] = RunDresdenVersion(runUnitTest, cBal)
%RUNDRESDENVERSION This function runs the Dresden version of the cannon task.
%
%   Input
%       runUnitTest: Indicates if unit test is being done or not
%       cBal: Current cBal (only allowed when running unit test)
%
%   Output 
%       dataMain: Task-data object main condition (standard version)
%       dataFollowOutcome: Task-data object follow-outcome condition (LR = 1)
%       dataFollowCannon: Task-data object follow-outcome condition (LR = 0)
%
%   Testing
%       To run the integration test, run XX
%       To run the unit tests, run "al_unittets" in "DataScripts"
%
%   Last updated
%       03/24

%% Todo: Get back to triggers when updating Hamburg EEG

% Check if unit test is requested
if ~exist('runUnitTest', 'var') || isempty(runUnitTest)
    runUnitTest = false;
end

KbName('UnifyKeyNames')

% Check optional input related to unit test
% -----------------------------------------

if exist('cBal', 'var') && ~runUnitTest
    error('No unit test: cBal cannot be used');
elseif exist('cBal', 'var') && runUnitTest
    if ~ischar(cBal)
        error('cBal must be char');
    end
end

% Reset random number generator to ensure different outcome sequences
% when we don't run a unit test
if ~runUnitTest
    rng('shuffle')
else
    rng(1)
end

% ----------------------------
% Set relevant task parameters
% ----------------------------
 
% Set number of trials of main task
trialsExp = 2; %20;

% Number of practice trials 
practTrials = 2; 

% Risk parameter: Precision of confetti average
concentration = [16, 8];

% Hazard rate determining a priori changepoint probability
haz = .125;

% Number of trials to introduce the shield in the cover story
shieldTrials = 2; 

% Choose if task instructions should be shown
runIntro = true;

% Choose if dialogue box should be shown
askSubjInfo = true;

% Determine blocks
blockIndices = [1 101 999 999];

% Use catch trials where cannon is shown occasionally
useCatchTrials = true; 

% Catch-trial probability
catchTrialProb = 0.1;

% Set text size and sentence length
sentenceLength = 100;

% Set text and header size
textSize = 35;
headerSize = 50;

% Screen size
screensize = [0 0 1920 1080]; %; [1 1 1920 1080];  % fu ohne bildschirm [1    1    2560    1440]; get(0,'MonitorPositions'); ausprobieren

% Number of catches during practice that is required to continue with main task
practiceTrialCriterionNTrials = 5;
practiceTrialCriterionEstErr = 9;

% Rotation radius
rotationRad = 200; % this value should be differen on other computers

% Tickmark width
tickWidth = 1;

% Run task in debug mode with smaller window
debug = false;

% Key codes
s = 40;
enter = 37; 
keySpeed = 1.5;
slowKeySpeed = 0.5;

% Print timing for checking
printTiming = true;

% Hide cursor
hidePtbCursor = true;

% Reward magnitude
rewMag = 0.1;

% Specify data directory
dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';

% Confetti speed
cannonBallAnimation = 0.5;
nFrames = 30;

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

if runUnitTest
    trials = trialsTesting;
else
    trials = trialsExp;
end

% Initialize general task parameters
gParam = al_gparam();
gParam.taskType = 'dresden';
gParam.trials = trials;
gParam.practTrials = practTrials;
gParam.shieldTrials = shieldTrials;
gParam.runIntro = runIntro;
gParam.askSubjInfo = askSubjInfo;
gParam.blockIndices = blockIndices;
gParam.useCatchTrials = useCatchTrials;
gParam.catchTrialProb = catchTrialProb;
gParam.practiceTrialCriterionNTrials = practiceTrialCriterionNTrials;
gParam.practiceTrialCriterionEstErr = practiceTrialCriterionEstErr;
gParam.debug = debug;
gParam.printTiming = printTiming;
gParam.concentration = concentration;
gParam.haz = haz;
gParam.rewMag = rewMag;
gParam.dataDirectory = dataDirectory;

% Save directory
cd(gParam.dataDirectory);

% -------------------------------------
% Create object instance for trial flow
% -------------------------------------

trialflow = al_trialflow();
trialflow.cannon = 'hide cannon';
trialflow.background = 'noPicture';
trialflow.input = "keyboard";
trialflow.shotAndShield = "sequential";
trialflow.shot = "static";
trialflow.currentTickmarks = "show";

% ---------------------------------------------
% Create object instance with cannon parameters
% ---------------------------------------------

cannon = al_cannon(false);
cannon.nFrames = nFrames;

% ------------------------------------------
% Create object instance with key parameters
% ------------------------------------------

keys = al_keys();
if ~exist('kbDev')
  keys = al_kbdev( keys );
else
  keys.kbDev = kbDev;
end
keys.s = s;
keys.enter = enter;
keys.keySpeed = keySpeed;
keys.slowKeySpeed = slowKeySpeed;

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

timingParam = al_timing();
timingParam.cannonBallAnimation = cannonBallAnimation;
timingParam = al_timing();
timingParam.fixCrossOutcome = 1; 
timingParam.outcomeLength = 0.5;
timingParam.shieldLength = 0.5;
timingParam.rewardLength = 1.0;
timingParam.fixedITI = 0.9;

% This is a reference timestamp at the start of the experiment.
% This is not equal to the first trial or so. So be carful when using
% EEG or pupillometry and make sure the reference is specified as desired.
timingParam.ref = GetSecs();

% ----------------------------------------------
% Create object instance with strings to display
% ----------------------------------------------

strings = al_strings();
strings.txtPressEnter = 'Weiter mit Enter';
strings.sentenceLength = sentenceLength;
strings.textSize = textSize;
strings.headerSize = headerSize;

% ----------------------------------------------
% Create object instance with strings to display
% ----------------------------------------------

strings = al_strings();
strings.txtPressEnter = 'Weiter mit Enter';
strings.sentenceLength = sentenceLength;
strings.textSize = textSize;
strings.headerSize = headerSize;

% ----------
% User Input
% ----------

subject = al_subject();

% Default input
ID = '99999'; % 5 digits
age = '99';
gender = 'f';  % m/f/d
group = '1'; % young and old
cBal = '1'; % 1/2/3/4/5/6
rew = '1';
if ~runUnitTest
    cBal = '1'; % 1/2/3/4/5/6
end

% If no user input requested
if gParam.askSubjInfo == false || runUnitTest

    % Just add defaults
    subject.ID = ID;
    subject.age = str2double(age);
    subject.gender = gender;
    subject.group = str2double(group);
    subject.cBal = str2double(cBal);
    subject.rew = str2double(rew);
    subject.date = date;

    % If user input requested
else

    % Variables that we want to put in the dialogue box
    prompt = {'ID:', 'Age:', 'Gender:', 'Group:', 'cBal:', 'Rew:'};
    name = 'SubjInfo';
    numlines = 1;

    % Add defaults from above
    defaultanswer = {ID, age, gender, group, rew, cBal};

    % Add information that is not specified by user (i.e., date)
    subjInfo = inputdlg(prompt, name, numlines, defaultanswer);

    % Put all relevant subject info in structure
    % ------------------------------------------

    subject.ID = subjInfo{1};
    subject.age = str2double(subjInfo{2});
    subject.gender = subjInfo{3};
    subject.group = str2double(subjInfo{4});
    subject.cBal = str2double(subjInfo{5});
    subject.rew = str2double(subjInfo{6});
    subject.date = date;

    % Test user input
    checkString = dir(sprintf('*%s*', num2str(subject.ID)));
    subject.checkID(checkString, 5);
    subject.checkGender();  
    subject.checkGroup();
    subject.checkCBal();
    subject.checkRew();
end

% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

colors = al_colors();

if subject.rew == 1
    colors.colRew = 'gold';
    colors.colNoRew = 'grau';
    colors.winColor = colors.gold;
    colors.neutralColor = colors.silver;
elseif subject.rew == 2
    colors.colRew = 'silber';
    colors.colNoRew = 'gelb';
    colors.winColor = colors.silver;
    colors.neutralColor = colors.gold;
end

colors.background = [66, 66, 66];
colors.blue = colors.purple;

% ------------------
% Display properties
% ------------------

% Display-object instance
display = al_display();

% Deal with psychtoolbox warnings
% Todo: Make sure that all tests are passed on task PC
% display.screen_warnings();

% Set screensize
display.screensize = screensize;

% Open psychtoolbox window
display = display.openWindow(gParam);

% Create stimuli
display = display.createRects();
display = display.createTextures(trialflow.cannonType);

% Disable keyboard and, if desired, mouse cursor
if hidePtbCursor == true
    HideCursor;
end
ListenChar(2);

% ---------------------------------------------
% Create object instance with circle parameters
% ---------------------------------------------

circle = al_circle(display.windowRect);
circle.rotationRad = rotationRad;
circle.tickWidth = tickWidth;
circle = circle.computeCircleProps();

% ---------------------------------------------
% Create object instance with trigger parameters
% ---------------------------------------------

sendTrigger = false; 
if sendTrigger == true
    config_io;
end

triggers = al_triggers();

% ------------------------------------------------
% Create object instance with unit-test parameters
% ------------------------------------------------

unitTest = al_unitTest();
unitTest.run = runUnitTest;

% ---------------------------------------
% Put all object instances in task object
% ---------------------------------------

% Object that harbors all relevant object instances
taskParam = al_objectClass();

% Add these to task-parameters object
taskParam.gParam = gParam;
taskParam.strings = strings;
taskParam.trialflow = trialflow;
taskParam.cannon = cannon;
taskParam.circle = circle;
taskParam.colors = colors;
taskParam.keys = keys;
taskParam.timingParam = timingParam;
taskParam.display = display;
taskParam.subject = subject;
taskParam.unitTest = unitTest;
taskParam.triggers = triggers;

% --------
% Run task
% --------
    
[dataMain, dataFollowCannon, dataFollowOutcome] = al_dresdenConditions(taskParam);
totWin = dataMain.accPerf(end) + dataFollowCannon.accPerf(end) + dataFollowOutcome.accPerf(end);

% Set total bonus to 0 if there were no catches
if isnan(totWin)
    totWin = 0.0;
end

% -----------
% End of task
% -----------

header = 'Ende des Versuchs!';
txt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben insgesamt %.2f Euro gewonnen!', totWin);
feedback = true; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback, true);

ListenChar();
ShowCursor;
Screen('CloseAll');

% Inform user about timing
fprintf('Total time: %.1f minutes\n', char((GetSecs - timingParam.ref)/60));

end
