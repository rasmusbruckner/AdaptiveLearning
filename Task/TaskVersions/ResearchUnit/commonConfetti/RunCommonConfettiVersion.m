function [dataLowNoise, dataHighNoise] = RunCommonConfettiVersion(config, unitTest, cBal)
%RUNCOMMONCONFETTIVERSION This function runs the common confetti version
%  of the cannon task
%
%   Input
%       config: Structure with local configuration parameters
%       unitTest: Indicates if unit test is being done or not
%       cBal: Current cBal (only allowed when running unit test)
%
%   Output
%       dataLowNoise: Task-data object low-noise condition
%       dataHighNoise: Task-data object high-noise condition
%
%   Testing
%       To run the integration test, run "al_HamburgIntegrationTest"
%       To run the unit tests, run "al_unittets" in "DataScripts"
%
%   Last updated
%       04/24


KbName('UnifyKeyNames')

% Check if config structure is provided
if ~exist('config', 'var') || isempty(config)
    
    % Create structure
    config = struct();

    % Default parameters
    config.trialsExp = 2;
    config.practTrials = 2;
    config.runIntro = true;
    config.sentenceLength = 75;
    config.textSize = 35;
    config.headerSize = 50;
    config.screenSize = get(0,'MonitorPositions')*1.0;
    config.s = 40;
    config.enter = 37;
    config.debug = false;
    config.showConfettiThreshold = false;
    config.printTiming = true;
    config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
    config.scanner = false;
    config.eyeTracker = false;
    config.sendTrigger = false;
end


% Check if unit test is requested
if ~exist('unitTest', 'var') || isempty(unitTest)
    unitTest = false;
end


% Check optional input related to unit test
% -----------------------------------------

if exist('cBal', 'var') && ~unitTest
    error('No unit test: cBal cannot be used');
elseif exist('cBal', 'var') && unitTest
    if ~ischar(cBal)
        error('cBal must be char');
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

% Config parameters
% -----------------
trialsExp = config.trialsExp; % number of experimental trials
practTrials = config.practTrials; % number of practice trials
runIntro = config.runIntro; % task instructions
sentenceLength = config.sentenceLength; % sentence length instructions
textSize = config.textSize; % texthsize
headerSize = config.headerSize; % header size
screensize = config.screenSize; % screen size
s = config.s; % s key
enter = config.enter; % enter key
debug = config.debug; % debug mode
showConfettiThreshold = config.showConfettiThreshold; % confetti threshold for validation (don't use in experiment)
printTiming = config.printTiming; % print timing for checking
dataDirectory = config.dataDirectory;
eyeTracker = config.eyeTracker; % doing eye-tracking?
sendTrigger = config.sendTrigger; % EEG
scanner = config.scanner; % turn scanner on/off

% More general paramters
% ----------------------

% Risk parameter: Precision of confetti average
concentration = [16, 8];

% Hazard rate determining a priori changepoint probability
haz = .125;

% Number of confetti particles 
nParticles = 40;

% Confetti standard deviations
confettiStd = 6;

% Standard deviation during animation
confettiAnimationStd = 2; 

% Choose if dialogue box should be shown
askSubjInfo = true;

% Determine blocks
blockIndices = [1 51 101 151];

% Use catch trials where cannon is shown occasionally
useCatchTrials = true;

% Catch-trial probability
catchTrialProb = 0.1;

% Number of catches during practice that is required to continue with main task
practiceTrialCriterionNTrials = 5;
practiceTrialCriterionEstErr = 9;

% Rotation radius
rotationRad = 170;

% Radius of prediction spot
predSpotRad = 10;

% Tickmark width
tickWidth = 2;

% Hide cursor
hidePtbCursor = true;

% Reward magnitude
rewMag = 0.1;

% Confetti cannon image rectangle determining the size of the cannon
imageRect = [0 00 60 200];

% Confetti end point
confettiEndMean = 100; % 150% this is added to the circle radius
confettiEndStd = 4; % 20 % this is the spread around the average end point

circleWidth = 10;

% Running task in MEG?
meg = false;

% Running task at UKE (will be harmonized with scanner)
uke = false;

% ID for UKE joystick
%ID = 1;
%joy = vrjoystick(ID);
joy = nan;

%% to do add option to make sure default is used finally
% automaticBackgroundRGB = true;

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

if unitTest
    trials = 20;
else
    trials = trialsExp;
end

% Initialize general task parameters
gParam = al_gparam();
gParam.taskType = 'Hamburg';
gParam.trials = trials;
gParam.practTrials = practTrials;
gParam.runIntro = runIntro;
gParam.askSubjInfo = askSubjInfo;
gParam.blockIndices = blockIndices;
gParam.useCatchTrials = useCatchTrials;
gParam.catchTrialProb = catchTrialProb;
gParam.practiceTrialCriterionNTrials = practiceTrialCriterionNTrials;
gParam.practiceTrialCriterionEstErr = practiceTrialCriterionEstErr;
gParam.debug = debug;
gParam.showConfettiThreshold = showConfettiThreshold;
gParam.printTiming = printTiming;
gParam.concentration = concentration;
gParam.haz = haz;
gParam.rewMag = rewMag;
gParam.dataDirectory = dataDirectory;
gParam.meg = meg; 
gParam.eyeTracker = eyeTracker;
gParam.sendTrigger = sendTrigger;
gParam.scanner = scanner;
gParam.uke = uke;
gParam.joy = joy;
gParam.screenNumber = 1;  
%gParam.shieldMu = 1;
%gParam.shieldMin = 1;
%gParam.shieldMax = 100;

% Save directory
cd(gParam.dataDirectory);

% -------------------------------------
% Create object instance for trial flow
% -------------------------------------

%% Todo: What is the best way to document this?
trialflow = al_trialflow();
trialflow.shot = ' ';
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

%trialflow.colors = 'dark';
%trialflow.colors = 'blackWhite';
trialflow.colors = 'colorful';


% ---------------------------------------------
% Create object instance with cannon parameters
% ---------------------------------------------

%% Todo: Add some of the other cannon properties
cannon = al_cannon();
cannon.nParticles = nParticles;
cannon.confettiStd = confettiStd;
cannon.confettiAnimationStd = confettiAnimationStd;
cannon.nFrames = 50;
cannon.confettiEndMean = confettiEndMean;
cannon.confettiEndStd = confettiEndStd;
cannon = cannon.al_staticConfettiCloud(trialflow.colors);

% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

%% Todo: Are all colors already part of this class?
colors = al_colors(nParticles);

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

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

timingParam = al_timing();
timingParam.cannonBallAnimation = 0.9;
timingParam.fixCrossOutcome = 2;
timingParam.fixCrossShield = 0.7;
timingParam.fixedITI = 1.0;
timingParam.jitterOutcome = 2;
timingParam.jitterShield = 0.6;
timingParam.jitterITI = 0.5;
timingParam.outcomeLength = 0.5;
timingParam.shieldLength = 0.5;

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

% ----------
% User Input
% ----------

subject = al_subject();

% Default input
ID = '99999'; % 5 digits
age = '99';
gender = 'f';  % m/f/d
group = '1'; % 1=experimental/2=control
cBal = '1'; % 1/2/3/4
if ~unitTest
    cBal = '1'; % 1/2/3/4
end

% If no user input requested
if gParam.askSubjInfo == false || unitTest

    % Just add defaults
    subject.ID = ID;
    subject.age = str2double(age);
    subject.gender = gender;
    subject.group = str2double(group);
    subject.cBal = str2double(cBal);
    subject.date = date;

    % If user input requested
else

    % Variables that we want to put in the dialogue box
    prompt = {'ID:', 'Age:', 'Gender:', 'Group:', 'cBal:'};
    name = 'SubjInfo';
    numlines = 1;

    % Add defaults from above
    defaultanswer = {ID, age, gender, group, cBal};

    % Add information that is not specified by user (i.e., date)
    subjInfo = inputdlg(prompt, name, numlines, defaultanswer);

    % Put all relevant subject info in structure
    % ------------------------------------------

    subject.ID = subjInfo{1};
    subject.age = str2double(subjInfo{2});
    subject.gender = subjInfo{3};
    subject.group = str2double(subjInfo{4});
    subject.cBal = str2double(subjInfo{5});
    subject.date = date;

    % Test user input
    checkString = dir(sprintf('*%s*', num2str(subject.ID)));
    subject.checkID(checkString, 5);
    subject.checkGender();
    subject.checkGroup();
    subject.checkCBal(),
end

% ------------------
% Display properties
% ------------------

% Display-object instance
display = al_display();



% Deal with psychtoolbox warnings
%% Todo: Make sure that all tests are passed on task PC
% display.screen_warnings();

% Set screensize
display.screensize = screensize;
display.backgroundCol = colors.background;% [127.5 127.5 127.5];%[66, 66, 66];
display.imageRect = imageRect;

% Open psychtoolbox window
display = display.openWindow(gParam);

% Todo: Docment this
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

% Todo: Delete a couple of variables when versions are independent;
% document properly
circle = al_circle(display.windowRect);
circle.rotationRad = rotationRad;
circle.predSpotRad = predSpotRad;
% circle.outcSize = outcSpotRad;
circle.tickWidth = tickWidth;
circle.circleWidth = circleWidth;
circle = circle.compute_circle_props();


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

colors = colors.computeBackgroundColor(taskParam);
taskParam.colors = colors;

Screen('FillRect', display.window.onScreen, colors.background);
Screen('Flip', taskParam.display.window.onScreen);

% --------
% Run task
% --------

[dataLowNoise, dataHighNoise] = al_commonConfettiConditions(taskParam);
totWin = sum(dataLowNoise.hit) + sum(dataHighNoise.hit);

% -----------
% End of task
% -----------

header = 'Ende des Versuchs!';
txt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben insgesamt %i Punkte gewonnen!', totWin);
feedback = true; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback, true);

ListenChar();
ShowCursor;
Screen('CloseAll');

% Inform user about timing
fprintf('Total time: %.1f minutes\n', char((GetSecs - timingParam.ref)/60));

end