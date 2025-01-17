function [dataInfantBlock1, dataInfantBlock2] = RunInfantVersion(config, unitTest, cBal)
%RUNINFANTVERSION This function runs the infant version
%  of the cannon task
%
%   Input
%       config: Structure with local configuration parameters
%       unitTest: Unit-test-object instance
%       cBal: Current cBal (only allowed when running unit test)
%
%   Output
%       dataInfantBlock1: Task-data object block 1
%       dataInfantBlock2: Task-data object block 2
%
%   Last updated
%       07/24

% Todo: write integration test for infant version.
% Todo: add eye tracker and online habituation criterion

KbName('UnifyKeyNames')

% Check if config structure is provided
if ~exist('config', 'var') || isempty(config)

    % Create structure
    config = struct();

    % Default parameters
    config.trialsExp = 4;
    config.practTrials = 8;
    config.sentenceLength = 100;
    config.textSize = 35;
    config.headerSize = 50;
    config.vSpacing = 1;
    config.screenSize = get(0,'MonitorPositions')*1;
    config.screenNumber = 1;
    config.s = 40;
    config.enter = 37;
    config.defaultParticles = false;
    config.debug = false;
    config.printTiming = true;
    config.hidePtbCursor = true;
    config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
    config.eyeTracker = false;
    config.useDegreesVisualAngle = true;
    config.distance2screen = 700;
    config.screenWidthInMM = 309.40;
    config.screenHeightInMM = 210;
    config.sendTrigger = false;
    config.rotationRadPixel = 140;
    config.rotationRadDeg = 3.16;
    config.customInstructions = true;
    config.instructionText = al_commonConfettiInstructionsDefaultText();
    config.noPtbWarnings = false;
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
trialsExp = config.trialsExp; % number of experimental trials per block
practTrials = config.practTrials; % number of practice trials
sentenceLength = config.sentenceLength; % sentence length instructions
textSize = config.textSize; % textsize
vSpacing = config.vSpacing; % space between text lines
headerSize = config.headerSize; % header size
screensize = config.screenSize; % screen size
screenNumber = config.screenNumber; % screen number
s = config.s; % s key
enter = config.enter; % enter key
defaultParticles = config.defaultParticles;
debug = config.debug; % debug mode
printTiming = config.printTiming; % print timing for checking
hidePtbCursor = config.hidePtbCursor; % hide cursor
dataDirectory = config.dataDirectory;
eyeTracker = config.eyeTracker; % doing eye-tracking?
useDegreesVisualAngle = config.useDegreesVisualAngle; % Define stimuli in degrees of visual angle
distance2screen = config.distance2screen; % defined in mm (for degrees visual angle)
screenWidthInMM = config.screenWidthInMM; % defined in mm (for degrees visual angle)
screenHeightInMM = config.screenHeightInMM; % defined in mm (for ET)
sendTrigger = config.sendTrigger; % EEG
rotationRadPixel = config.rotationRadPixel; % rotation radius in pixels
rotationRadDeg = config.rotationRadDeg; % rotation radius in degrees visual angle
customInstructions = config.customInstructions;
instructionText = config.instructionText;
noPtbWarnings = config.noPtbWarnings;

% More general parameters
% ----------------------

% Risk parameter: Precision of confetti shot
concentration = 16;

% Hazard rate determining a priori changepoint probability
haz = 0.0;

% Choose if dialogue box should be shown
askSubjInfo = true;

% Use catch trials where cannon is shown occasionally
useCatchTrials = false;

% Confetti cannon image rectangle determining the size of the cannon
imageRectPixel = [0 0 60 200];

% Degrees visual angle
% -------------------

fixSpotDiamDeg = 0.4519;
circleWidthDeg = 0.2259;
imageRectDeg = [0 0 1.0843 3.6076];

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

if unitTest.run
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
gParam.taskType = 'infant';
gParam.trials = trials;
gParam.practTrials = practTrials;
gParam.askSubjInfo = askSubjInfo;
gParam.useCatchTrials = useCatchTrials;
gParam.debug = debug;
gParam.printTiming = printTiming;
gParam.concentration = concentration;
gParam.haz = haz;
gParam.dataDirectory = dataDirectory;
gParam.eyeTracker = eyeTracker;
gParam.sendTrigger = sendTrigger;
gParam.screenNumber = screenNumber;
gParam.customInstructions = customInstructions;

% Save directory
cd(gParam.dataDirectory);

% -------------------------------------
% Create object instance for trial flow
% -------------------------------------

trialflow = al_trialflow();
trialflow.cannonType = 'duck';

% ---------------------------------------------
% Create object instance with cannon parameters
% ---------------------------------------------

cannon = al_cannon(defaultParticles);

% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

colors = al_colors(nan);
colors.background = [145.0035 142.1199 146.3924];

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
timingParam.baselineFixLength = 0.25;
timingParam.staticDuck = 1.0;
timingParam.movingDuck = 1.0;
timingParam.fixCrossOutcome = 1.0;
timingParam.staticOutcome = 1.0;
timingParam.movingOutcome = 1.0;

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
    subject.date = date;

    if scanner == false
        subject.cBal = str2double(cBal);
    end

    % If user input requested
else

    % Variables that we want to put in the dialogue box
    prompt = {'ID:', 'Age:', 'Gender:', 'Group:', 'cBal:'};
    name = 'SubjInfo';
    numlines = 1;

    % Add defaults from above
    defaultanswer = {ID, age, gender, group, cBal};

    % Put everything together
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
    subject.checkCBal(2);

end

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

% Circle-object instance
circle = al_circle(display.windowRect);
circle.duckImageRad = rotationRadPixel;

% For internal checking, maybe implement translation, if useful
% display.pix2deg(rotationRadPixel)
% display.pix2deg(circle.predSpotDiam)
% display.pix2deg(circle.circleWidth)
% display.pix2deg(circle.tickLengthPred)
% display.pix2deg(circle.tickLengthOutc)
% display.pix2deg(circle.tickLengthShield)

% Determine rotation radius, depending on unit (deg. vis. angle vs. pixels)
% also adjust other parameters accordingly
if display.useDegreesVisualAngle
    circle.rotationRad = display.deg2pix(rotationRadDeg);
    circle.fixSpotDiam = display.deg2pix(fixSpotDiamDeg);
    circle.circleWidth = display.deg2pix(circleWidthDeg);
    circle = circle.getShieldOffset();
    fprintf('\nYou have chosen to use degrees of visual angle.\n\nRotation radius in degrees visual angle: %.2f\n\nIn pixels: %.2f. Other stimuli adjusted accordingly!\n\n',round(rotationRadDeg,2), round(circle.rotationRad, 2));
elseif display.useDegreesVisualAngle == false
    circle.rotationRad = rotationRadPixel;
else
    error('Option undefined')
end

circle = circle.computeCircleProps();

% ----------------------------------------------
% Create object instance with trigger parameters
% ----------------------------------------------

triggers = al_triggers();
if sendTrigger
    triggers.sampleRate = sampleRate;
    triggers.session = session;
end

% ---------------------------------------------------
% Create object instance with eye-tracking parameters
% ---------------------------------------------------

% todo: verify that ET wants cm
eyeTracker = al_eyeTracker(display);
eyeTracker.dist = distance2screen /10;
eyeTracker.width = screenWidthInMM / 10;
eyeTracker.height = screenHeightInMM / 10;
eyeTracker.frameDur = Screen('GetFlipInterval', display.window.onScreen);
eyeTracker.frameRate = Screen('NominalFrameRate', display.window.onScreen);

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
taskParam.eyeTracker = eyeTracker;
taskParam.instructionText = instructionText;

% --------
% Run task
% --------

[dataInfantBlock1, dataInfantBlock2] = al_infantConditions(taskParam);

% -----------
% End of task
% -----------

header = 'Ende des Versuchs!';
txt = 'Vielen Dank für die Teilnahme';
feedback = true; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback, true);

ListenChar();
ShowCursor;
Screen('CloseAll');

% Inform user about timing
experimentLength = GetSecs() - timingParam.ref;
t = seconds(experimentLength);
t.Format = 'hh:mm:ss.SSS';
fprintf('Total time: %s', evalc('disp(t)'))

end