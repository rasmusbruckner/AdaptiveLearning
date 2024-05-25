function [dataLowNoise, dataHighNoise] = RunCommonConfettiVersion(config, unitTest, cBal)
%RUNCOMMONCONFETTIVERSION This function runs the common confetti version
%  of the cannon task
%
%   Input
%       config: Structure with local configuration parameters
%       unitTest: Unit-test-object instance
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
%       05/24


KbName('UnifyKeyNames')

% Check if config structure is provided
if ~exist('config', 'var') || isempty(config)
    
    % Create structure
    config = struct();

    % Default parameters
    config.trialsExp = 2;
    config.practTrials = 2;
    config.blockIndices = [1 51 101 151];
    config.runIntro = false;
    config.language = 'German';
    config.sentenceLength = 100;
    config.textSize = 35;
    config.headerSize = 50;
    config.vSpacing = 1;
    config.screenSize = get(0,'MonitorPositions')*1.0;
    config.screenNumber = 1;
    config.s = 40;
    config.enter = 37;
    config.debug = false;
    config.showConfettiThreshold = false;
    config.printTiming = true;
    config.hidePtbCursor = true;
    config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
    config.scanner = false;
    config.eyeTracker = false;
    config.sendTrigger = false;
    config.rotationRad = 140;
    config.customInstructions = true;
    config.instructionText = al_commonConfettiInstructionsDefaultText_updated();
end


% Check if unit test is requested
if ~exist('unitTest', 'var') || isempty(unitTest)
    unitTest = al_unitTest();
end

% Check optional input related to unit test
% -----------------------------------------

if exist('cBal', 'var') && ~unitTest.run
    error('No unit test: cBal cannot be used');
elseif exist('cBal', 'var') && unitTest.run
    if ~ischar(cBal)
        error('cBal must be char');
    end
end


% Reset random number generator to ensure different outcome sequences
% when we don't run a unit test
if ~unitTest.run
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
blockIndices = config.blockIndices; % breaks
runIntro = config.runIntro; % task instructions
language = config.language; % language
sentenceLength = config.sentenceLength; % sentence length instructions
textSize = config.textSize; % textsize
vSpacing = config.vSpacing; % space between text lines
headerSize = config.headerSize; % header size
screensize = config.screenSize; % screen size
screenNumber = config.screenNumber; % screen number 
s = config.s; % s key
enter = config.enter; % enter key
debug = config.debug; % debug mode
showConfettiThreshold = config.showConfettiThreshold; % confetti threshold for validation (don't use in experiment)
printTiming = config.printTiming; % print timing for checking
hidePtbCursor = config.hidePtbCursor; % hide cursor
dataDirectory = config.dataDirectory;
eyeTracker = config.eyeTracker; % doing eye-tracking?
sendTrigger = config.sendTrigger; % EEG
scanner = config.scanner; % turn scanner on/off
rotationRad = config.rotationRad; % rotation radius
customInstructions = config.customInstructions;
instructionText = config.instructionText;

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

% Use catch trials where cannon is shown occasionally
useCatchTrials = true;

% Catch-trial probability
catchTrialProb = 0.1;

% Number of catches during practice that is required to continue with main task
practiceTrialCriterionNTrials = 5;
practiceTrialCriterionEstErr = 9;

% Tickmark width
tickWidth = 2;

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

% Sampling rate for EEG
sampleRate = 500; 


if sendTrigger
    [session, status] = IOPort( 'OpenSerialPort', 'COM3' );
end

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

if unitTest.run
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
gParam.screenNumber = screenNumber;  
gParam.customInstructions = customInstructions;
gParam.language = language;

% Save directory
cd(gParam.dataDirectory);

% -------------------------------------
% Create object instance for trial flow
% -------------------------------------

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

%trialflow.colors = 'dark';
%trialflow.colors = 'blackWhite';
trialflow.colors = 'colorful';

% ---------------------------------------------
% Create object instance with cannon parameters
% ---------------------------------------------

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
if isequal(language, 'German')
    strings.txtPressEnter = 'Weiter mit Enter';
else
    strings.txtPressEnter = 'Press Enter to continue';
end
strings.sentenceLength = sentenceLength;
strings.textSize = textSize;
strings.headerSize = headerSize;
strings.vSpacing = vSpacing;

% ----------
% User Input
% ----------

subject = al_subject();

% Default input
ID = '99999'; % 5 digits
age = '99';
gender = 'f';  % m/f/d
group = '1'; % 1=experimental/2=control
if ~unitTest.run
    cBal = '1'; % 1 or 2 
end

% If no user input requested
if gParam.askSubjInfo == false || unitTest.run

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
circle.circleWidth = circleWidth;
circle = circle.computeCircleProps();

% ----------------------------------------------
% Create object instance with trigger parameters
% ----------------------------------------------

triggers = al_triggers();
if sendTrigger
    triggers.sampleRate = sampleRate;
    triggers.session = session;
end

% ------------------------------------------------
% Create object instance with unit-test parameters
% ------------------------------------------------

% unitTest = al_unitTest();
% unitTest.run = runUnitTest;
% unitTest.pred = [0, 0, 0, 0, 0, 90, 90, 90, 90, 90, 180, 180, 180, 180, 180, 270, 270, 270, 270, 270];

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
taskParam.instructionText = instructionText;

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

if isequal(language, 'German')
    header = 'Ende des Versuchs!';
    txt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben insgesamt %i Punkte gewonnen!', totWin);
elseif isequal(language, 'English')
    header = 'End of the Experiment!';
    txt = sprintf('Thank you for taking part!\n\n\nYou have won a total of %i points!', totWin);
else
    error('language parameter unknown')
end
feedback = true; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback, true);

ListenChar();
ShowCursor;
Screen('CloseAll');

% Inform user about timing
%fprintf('Total time: %.1f minutes\n', char((GetSecs - timingParam.ref)/60));
experimentLength = GetSecs() - timingParam.ref;
t = seconds(experimentLength);
t.Format = 'hh:mm:ss.SSS';
fprintf('Total time: %s', evalc('disp(t)'))

end