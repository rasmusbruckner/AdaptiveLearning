function [dataMonetary, dataSocial] = RunConfettiEEGVersion(config, runUnitTest, cBal)
%RUNCONFETTIEEGVERSION This function runs the EEG version of the confetti-cannon task
%
%   Input
%       config: Structure with local configuration parameters
%       runUnitTest: Indicates if unit test is being done or not
%       cBal: Current cBal (only allowed when running unit test)
%
%   Output
%       dataMonetary: Task-data object monetary condition
%       dataSocial: Task-data object social condition
%
%   Testing
%       To run the integration test, run "al_HamburgIntegrationTest"
%       To run the unit tests, run "al_unittets" in "DataScripts"
%
%   Last updated
%       06/24

% todo: tailored integration tests

KbName('UnifyKeyNames')

% Check if config structure is provided
if ~exist('config', 'var') || isempty(config)
    
    % Create structure
    config = struct();

    % Default parameters
    config.trialsExp = 2;
    config.practTrials = 3;
    config.blockIndices = [1 51 101 151];
    config.runIntro = true;
    config.sentenceLength = 100;
    config.textSize = 35;
    config.headerSize = 50;
    config.vSpacing = 1;
    config.screenSize = get(0,'MonitorPositions')*1.0;
    config.s = 40;
    config.enter = 37;
    config.defaultParticles = true;
    config.debug = false;
    config.showConfettiThreshold = false;
    config.printTiming = true;
    config.hidePtbCursor = true;
    config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
    config.eyeTracker = false;
    config.useDegreesVisualAngle = true;
    config.distance2screen = 700;
    config.screenWidthInMM = 309.40;
    config.sendTrigger = false;
    config.rotationRadPixel = 140;
    config.rotationRadDeg = 2.5; %3.16;
    config.noPtbWarnings = false;
    config.predSpotCircleTolerance = 2;

    % config.customInstructions = true;
    % config.instructionText = al_commonConfettiInstructionsDefaultText_updated();
end

% Check if unit test is requested
if ~exist('runUnitTest', 'var') || isempty(runUnitTest)
    runUnitTest = false;
end

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

% Config parameters
% -----------------
trialsExp = config.trialsExp; % number of experimental trials
practTrials = config.practTrials; % number of practice trials
blockIndices = config.blockIndices; % breaks
runIntro = config.runIntro; % task instructions
sentenceLength = config.sentenceLength; % sentence length instructions
textSize = config.textSize; % textsize
vSpacing = config.vSpacing; % space between text lines    
headerSize = config.headerSize; % header size
screensize = config.screenSize; % screen size
s = config.s; % s key
enter = config.enter; % enter key
defaultParticles = config.defaultParticles;
debug = config.debug; % debug mode
showConfettiThreshold = config.showConfettiThreshold; % confetti threshold for validation (don't use in experiment)
printTiming = config.printTiming; % print timing for checking
hidePtbCursor = config.hidePtbCursor; % hide cursor
dataDirectory = config.dataDirectory;
useDegreesVisualAngle = config.useDegreesVisualAngle; % Define stimuli in degrees of visual angle
distance2screen = config.distance2screen; % defined in mm (for degrees visual angle)
screenWidthInMM = config.screenWidthInMM; % defined in mm (for degrees visual angle)
% screenHeightInMM = config.screenHeightInMM; % defined in mm (for ET)
sendTrigger = config.sendTrigger; % EEG
%rotationRad = config.rotationRad; % rotation radius
rotationRadPixel = config.rotationRadPixel; % rotation radius in pixels
rotationRadDeg = config.rotationRadDeg; % rotation radius in degrees visual angle
noPtbWarnings = config.noPtbWarnings;
predSpotCircleTolerance = config.predSpotCircleTolerance;

% customInstructions = config.customInstructions;
% instructionText = config.instructionText;

% More general paramters
% ----------------------

% Risk parameter: Precision of confetti average
concentration = 12;

% Hazard rate determining a priori changepoint probability
haz = 0.2; %.125;

% Number of confetti particles 
nParticles = 40;

% Confetti standard deviations
confettiStd = 6;

% Start-up budget in Euros
startingBudget = 20;  % for monetary condition

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
% tickWidth = 2;

% Reward magnitude
rewMag = 0.2;

% Sampling rate for EEG
sampleRate = 500; 

% Confetti cannon image rectangle determining the size of the cannon
imageRect = [0 00 60 200];
socialFeedbackRect = [0 0 562 762]/4;

% Confetti end point
confettiEndMean = 0; % 50; % 150% this is added to the circle radius
confettiEndStd = 10; % 10; % 20 % this is the spread around the average end point

if sendTrigger
    [session, ~] = IOPort( 'OpenSerialPort', 'COM3' );
end

% Degrees visal angle
% -------------------

predSpotDiamDeg = 0.45;
fixSpotDiamDeg = 0.45;
circleWidthDeg = 0.2; 
tickLengthPredDeg = 0.9;
tickLengthOutcDeg = 0.7; 
tickLengthShieldDeg = 1.1;
particleSizeDeg = 0.1;
confettiStdDeg = 0.1;
imageRectDeg = [0 0 1.1 3.7];


% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

if runUnitTest
    trials = 20;
else
    trials = trialsExp;
end

% Check if practice trials exceeds max of 20
if practTrials > 20
    error('Practice trials max 20 (because pre-defined)')
end

% Initialize general task parameters
gParam = al_gparam();
gParam.taskType = 'HamburgEEG';
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
gParam.sendTrigger = sendTrigger;
gParam.dataDirectory = dataDirectory;

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
trialflow.shieldType = 'constant';
trialflow.shield = 'variableWithSD';
trialflow.input = "mouse";
trialflow.shieldAppearance = 'lines';
trialflow.colors = 'dark';

% ---------------------------------------------
% Create object instance with cannon parameters
% ---------------------------------------------

cannon = al_cannon(defaultParticles);
cannon.nParticles = nParticles;
cannon.confettiStd = confettiStd;
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

 % Check the keyboard device, which is necessary on some Macs
keys = al_keys();
if ~exist('kbDev')
  keys = al_kbdev(keys);
else
  keys.kbDev = kbDev;
end
keys.s = s;
keys.enter = enter;

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

% Ensure this is properly documented in al_confettiEEGLoop
timingParam = al_timing();
timingParam.fixCrossOutcome = 1;
timingParam.fixCrossShield = 1;
timingParam.fixedITI = 0.9;
timingParam.jitterFixCrossOutcome = 0.0;
timingParam.jitterFixCrossShield = 0.0;
timingParam.outcomeLength = 0.5;
timingParam.rewardLength = 1.0;
timingParam.jitterOutcome = 0.0;  %0.15;
timingParam.jitterShield = 0.0; % 0.15; % we use this one for the reward phase 
% for consistency with common task
timingParam.jitterITI = 0.2;  

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
strings.socialVersionFeedbackTextSize = 55;
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
cBal = '1'; % 1/2/3/4
if ~runUnitTest
    cBal = '1'; % 1/2/3/4
end

% If no user input requested
if gParam.askSubjInfo == false || runUnitTest

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
    checkString = dir(sprintf('*EEG*%s*', num2str(subject.ID)));
    subject.checkID(checkString, 5);
    subject.checkGender();
    subject.checkGroup();
    subject.checkCBal(),
end

% Add starting bugdet
subject.startingBudget = startingBudget;

% ------------------
% Display properties
% ------------------

% Display-object instance
display = al_display();

% Deal with psychtoolbox warnings
%% Todo: Make sure that all tests are passed on task PC
if noPtbWarnings
    display.screen_warnings();
end

% Set screensize
display.screensize = screensize;
% display.imageRect = imageRect;
display.socialFeedbackRect = socialFeedbackRect;
display.distance2screen = distance2screen;
display.screenWidthInMM = screenWidthInMM;
display.useDegreesVisualAngle = useDegreesVisualAngle;

% Cannon image
if display.useDegreesVisualAngle
    display.imageRect(3) = display.deg2pix(imageRectDeg(3));
    display.imageRect(4) = display.deg2pix(imageRectDeg(4));
else
    display.imageRect = imageRectPixel;
end

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
circle.predSpotCircleTolerance = predSpotCircleTolerance;

% circle.rotationRad = rotationRad;
% circle.tickWidth = tickWidth;
% circle = circle.computeCircleProps();

% Determine rotation radius, depending on unit (deg. vis. angle vs. pixels)
% also adjust other parameters accordingly
if display.useDegreesVisualAngle
    circle.rotationRad = display.deg2pix(rotationRadDeg);
    circle.predSpotDiam = display.deg2pix(predSpotDiamDeg);
    circle.fixSpotDiam = display.deg2pix(fixSpotDiamDeg);
    circle.circleWidth = display.deg2pix(circleWidthDeg);
    circle.tickLengthPred = display.deg2pix(tickLengthPredDeg);
    circle.tickLengthOutc = display.deg2pix(tickLengthOutcDeg);
    circle.tickLengthShield = display.deg2pix(tickLengthShieldDeg);
    circle = circle.getShieldOffset();
    fprintf('\nYou have chosen to use degrees of visual angle.\n\nRotation radius in degrees visual angle: %.2f\n\nIn pixels: %.2f. Other stimuli adjusted accordingly!\n\n',round(rotationRadDeg,2), round(circle.rotationRad, 2));
elseif display.useDegreesVisualAngle == false
    circle.rotationRad = rotationRadPixel;
else
    error('Option undefined')
end

circle = circle.computeCircleProps();

% Adjust size according to degrees visual angle for cannon parameters
if display.useDegreesVisualAngle
    cannon.particleSize = display.deg2pix(particleSizeDeg);
    cannon.confettiStd = display.deg2pix(confettiStdDeg);   
    cannon = cannon.al_staticConfettiCloud(trialflow.colors, display);
else
    cannon = cannon.al_staticConfettiCloud(trialflow.colors);
end


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

% Check and update background rgb:
% It turns out that depending on screen resolution, the exactly ideal
% background values are slightly different. But for research unit it is
% more important to use the same values for comparability. We therefore use
% fixed values based on a common screen. But it is recommended to check if these values strongly
% differ from your set-up. Therefore, we print out a warning. 

colors = colors.computeBackgroundColor(taskParam);
expectedVal = [137 137 137];

warning('Ensure that background RGB color computed for your display is close to actual values')

fprintf('\n\nComputed values: %i %i %i', colors.background(1), colors.background(2), colors.background(3));

taskParam.colors.background = expectedVal;
fprintf('\n\nUsed values: %i %i %i', taskParam.colors.background(1), taskParam.colors.background(2), taskParam.colors.background(3));
Screen('FillRect', display.window.onScreen, colors.background);
Screen('Flip', taskParam.display.window.onScreen);

% --------
% Run task
% --------

[dataMonetary, dataSocial] = al_confettiEEGConditions(taskParam);

% Compute bonus
totWin = dataMonetary.accPerf(end);

% -----------
% End of task
% -----------

header = 'Ende des Versuchs!';
txt = sprintf('Vielen Dank für Deine Teilnahme!\n\n\nDu hast insgesamt %.2f Euro gewonnen!', totWin);
feedback = true; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback, true);

ListenChar();
ShowCursor;
Screen('CloseAll');

% Inform user about timing
fprintf('Total time: %.1f minutes\n', char((GetSecs - timingParam.ref)/60));

end