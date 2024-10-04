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
%       09/24

% Todo: write integration test for fMRI version.
% First ensure version is good to go and then keep in mind that output
% arguments have to updated to include the three runs (this has to be
% compatible with two files in no-scanner version)

KbName('UnifyKeyNames')

% Check if config structure is provided
if ~exist('config', 'var') || isempty(config)

    % Create structure
    config = struct();

    % Default parameters
    config.trialsExp = 2;
    config.nBlocks = 2;
    config.practTrialsVis = 10;
    config.practTrialsHid = 20;
    config.cannonPractCriterion = 4;
    config.cannonPractNumOutcomes = 5;
    config.passiveViewingPractTrials = 10;
    config.passiveViewing = false;
    config.baselineFixLength = 0.25;
    config.blockIndices = [1 51 101 151];
    config.runIntro = true;
    config.baselineArousal = false;
    config.language = 'German';
    config.sentenceLength = 100;
    config.textSize = 35;
    config.headerSize = 50;
    config.vSpacing = 1;
    config.screenSize = get(0,'MonitorPositions')*0.5;
    config.screenNumber = 1;
    config.s = 40;
    config.five = 15;
    config.enter = 37;
    config.defaultParticles = false;
    config.debug = false;
    config.showConfettiThreshold = false;
    config.printTiming = true;
    config.hidePtbCursor = true;
    config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
    config.meg = false;
    config.scanner = false;
    config.eyeTracker = false;
    config.onlineSaccades = true;
    config.saccThres = 0.7;
    config.useDegreesVisualAngle = true;
    config.distance2screen = 700;
    config.screenWidthInMM = 309.40;
    config.screenHeightInMM = 210;
    config.sendTrigger = false;
    config.sampleRate = 500;
    config.port = hex2dec('E050');
    config.rotationRadPixel = 140;
    config.rotationRadDeg = 2.5;
    config.customInstructions = true;
    config.instructionText = al_commonConfettiInstructionsDefaultText();
    config.noPtbWarnings = false;
    config.predSpotCircleTolerance = 2;
    
    if config.sendTrigger
        [config.session, ~] = IOPort( 'OpenSerialPort', 'COM3' );
    else 
        config.session = nan;
    end
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
nBlocks = config.nBlocks; % number of blocks for each 
practTrialsVis = config.practTrialsVis; % number of practice trials visible cannon
practTrialsHid = config.practTrialsHid; % number of practice trials hidden cannon
cannonPractCriterion = config.cannonPractCriterion; % criterion cannon practice
cannonPractNumOutcomes = config.cannonPractNumOutcomes; % number of trials cannon practice
passiveViewingPractTrials = config.passiveViewingPractTrials;
passiveViewing = config.passiveViewing; % Passive viewing for pupillometry validation
baselineFixLength = config.baselineFixLength;
blockIndices = config.blockIndices; % breaks
runIntro = config.runIntro; % task instructions
baselineArousal = config.baselineArousal; % w/ or w/o baseline arousal
language = config.language; % language
sentenceLength = config.sentenceLength; % sentence length instructions
textSize = config.textSize; % textsize
vSpacing = config.vSpacing; % space between text lines
headerSize = config.headerSize; % header size
screensize = config.screenSize; % screen size
screenNumber = config.screenNumber; % screen number
s = config.s; % s key
enter = config.enter; % enter key
five = config.five; % number 5 for triggering at UKE
defaultParticles = config.defaultParticles;
debug = config.debug; % debug mode
showConfettiThreshold = config.showConfettiThreshold; % confetti threshold for validation (don't use in experiment)
printTiming = config.printTiming; % print timing for checking
hidePtbCursor = config.hidePtbCursor; % hide cursor
dataDirectory = config.dataDirectory;
eyeTracker = config.eyeTracker; % doing eye-tracking?
onlineSaccades = config.onlineSaccades; % online saccades tracking?
saccThresh = config.saccThres;
useDegreesVisualAngle = config.useDegreesVisualAngle; % Define stimuli in degrees of visual angle
distance2screen = config.distance2screen; % defined in mm (for degrees visual angle)
screenWidthInMM = config.screenWidthInMM; % defined in mm (for degrees visual angle)
screenHeightInMM = config.screenHeightInMM; % defined in mm (for ET)
sendTrigger = config.sendTrigger; % EEG
sampleRate = config.sampleRate; % EEG sampling rate
session = config.session; % EEG session
port = config.port; % EEG port
meg = config.meg; % running task in MEG?
scanner = config.scanner; % turn scanner on/off
rotationRadPixel = config.rotationRadPixel; % rotation radius in pixels
rotationRadDeg = config.rotationRadDeg; % rotation radius in degrees visual angle
customInstructions = config.customInstructions;
instructionText = config.instructionText;
noPtbWarnings = config.noPtbWarnings;
predSpotCircleTolerance = config.predSpotCircleTolerance;

% More general parameters
% ----------------------

% Risk parameter: Precision of confetti shot
if scanner == false
    concentration = [16, 8];
elseif scanner == true
    concentration = 12;
end

% Hazard rate determining a priori changepoint probability
haz = 0.125;

% Number of confetti particles
nParticles = 40;

% Confetti standard deviations
confettiStd = 4;

% Standard deviation during animation
confettiAnimationStd = 2;

% Choose if dialogue box should be shown
askSubjInfo = true;

% Use catch trials where cannon is shown occasionally (not for passive viewing)
if passiveViewing == false
    useCatchTrials = true;
elseif passiveViewing 
    useCatchTrials = false;
end

% Catch-trial probability
catchTrialProb = 0.1;

% Number of predictions above threshold and estimation-error size leading to repetition of block
practiceTrialCriterionNTrials = 2;
practiceTrialCriterionEstErr = 9;

% Reward magnitude
rewMag = 0.1;

% Confetti cannon image rectangle determining the size of the cannon
imageRectPixel = [0 0 60 200];

% Confetti end point
confettiEndMean = 100; % 150% this is added to the circle radius
confettiEndStd = 4; % 20 % this is the spread around the average end point

% Running task at UKE (will be harmonized with scanner)
uke = false;

% ID for UKE joystick
joy = nan;

% % Sampling rate for EEG
% sampleRate = 500;
% 
% if sendTrigger
%     [session, ~] = IOPort( 'OpenSerialPort', 'COM3' );
% end

% Degrees visual angle
% -------------------

predSpotDiamDeg = 0.45;
fixSpotDiamDeg = 0.45;
circleWidthDeg = 0.2; 
tickLengthPredDeg = 0.9;
tickLengthOutcDeg = 0.7; 
tickLengthShieldDeg = 1.1;
particleSizeDeg = 0.1;
confettiStdDeg = 0.08; %0.1;
imageRectDeg = [0 0 1.1 3.7];

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

if unitTest.run
    trials = 20;
else
    trials = trialsExp;
end

% Check if practice trials exceeds max of 20
if practTrialsVis > 20 || practTrialsHid > 20
    error('Practice trials max 20 (because pre-defined)')
end

% Check if cannon practice trials is too low
if cannonPractNumOutcomes < 2
    error('Cannon practice trials has to be 2 or larger')
end

% Initialize general task parameters
gParam = al_gparam();
gParam.taskType = 'Hamburg';
gParam.trials = trials;
gParam.nBlocks = nBlocks;
gParam.practTrialsVis = practTrialsVis;
gParam.practTrialsHid = practTrialsHid;
gParam.passiveViewingPractTrials = passiveViewingPractTrials;
gParam.passiveViewing = passiveViewing;
gParam.runIntro = runIntro;
gParam.baselineArousal = baselineArousal;
gParam.askSubjInfo = askSubjInfo;
gParam.blockIndices = blockIndices;
gParam.useCatchTrials = useCatchTrials;
gParam.catchTrialProb = catchTrialProb;
gParam.practiceTrialCriterionNTrials = practiceTrialCriterionNTrials;
gParam.practiceTrialCriterionEstErr = practiceTrialCriterionEstErr;
gParam.cannonPractCriterion = cannonPractCriterion;
gParam.cannonPractNumOutcomes = cannonPractNumOutcomes;
gParam.debug = debug;
gParam.showConfettiThreshold = showConfettiThreshold;
gParam.printTiming = printTiming;
gParam.concentration = concentration;
gParam.haz = haz;
gParam.rewMag = rewMag;
gParam.dataDirectory = dataDirectory;
gParam.meg = meg;
gParam.eyeTracker = eyeTracker;
gParam.onlineSaccades = onlineSaccades;
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
trialflow.colors = 'colorful';

% ---------------------------------------------
% Create object instance with cannon parameters
% ---------------------------------------------

cannon = al_cannon(defaultParticles);
cannon.nParticles = nParticles;
cannon.confettiStd = confettiStd;
cannon.confettiAnimationStd = confettiAnimationStd;
cannon.nFrames = 50;
cannon.confettiEndMean = confettiEndMean;
cannon.confettiEndStd = confettiEndStd;

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
keys.five = five;

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

timingParam = al_timing();
timingParam.baselineFixLength = baselineFixLength;
timingParam.cannonBallAnimation = 0.9;
timingParam.fixCrossOutcome = 2;
timingParam.fixCrossShield = 0.7;
timingParam.fixedITI = 1.0;
timingParam.jitterFixCrossOutcome = 2;
timingParam.jitterFixCrossShield = 0.6;
timingParam.outcomeLength = 0.65;
timingParam.jitterOutcome = 0.15;
timingParam.shieldLength = 0.65; 
timingParam.jitterShield = 0.15;
timingParam.jitterITI = 0.5;

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
    subject.date = date;

    if scanner == false
        subject.cBal = str2double(cBal);
    end

    % If user input requested
else

    if scanner == false
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
        if passiveViewing == false
            checkString = dir(sprintf('*exp*%s*', num2str(subject.ID)));
        elseif passiveViewing == true
            checkString = dir(sprintf('*passive*%s*', num2str(subject.ID)));
        end
        subject.checkID(checkString, 5);
        subject.checkGender();
        subject.checkGroup();
        subject.checkCBal(2);

    elseif scanner == true

        % Variables that we want to put in the dialogue box
        prompt = {'ID:', 'Age:', 'Gender:', 'Group:', 'startsWithRun:'};
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
        subject.date = date;

        % Extract startsWithRun variable
        startsWithRun = str2double(subjInfo{5});

        % Test user input
        checkString = dir(sprintf('*%s*', num2str(subject.ID)));
        subject.checkID(checkString, 5);
        subject.checkGender();
        subject.checkGroup();
    end
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
    HideCursor(screenNumber-1);
end
ListenChar(2);

% ---------------------------------------------
% Create object instance with circle parameters
% ---------------------------------------------

% Circle-object instance
circle = al_circle(display.windowRect);
circle.predSpotCircleTolerance = predSpotCircleTolerance;
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
    circle.predSpotDiam = display.deg2pix(predSpotDiamDeg);
    circle.fixSpotDiam = display.deg2pix(fixSpotDiamDeg);
    circle.circleWidth = display.deg2pix(circleWidthDeg);
    circle.tickLengthPred = display.deg2pix(tickLengthPredDeg);
    circle.tickLengthOutc = display.deg2pix(tickLengthOutcDeg);
    circle.tickLengthShield = display.deg2pix(tickLengthShieldDeg);
    circle = circle.getShieldOffset();
    %fprintf('\nYou have chosen to use degrees of visual angle.\n\nRotation radius in degrees visual angle: %.2f\n\nIn pixels: %.2f. Other stimuli adjusted accordingly!\n\n',round(rotationRadDeg,2), round(circle.rotationRad, 2));
    fprintf('\nYou have chosen to use degrees of visual angle.\n\nRotation radius in degrees visual angle: %.2f\n\nIn pixels: %.2f. Other stimuli adjusted accordingly!\n\n', rotationRadDeg, circle.rotationRad);
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
    triggers.port = port;
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
eyeTracker.resolutionX = screensize(3);
eyeTracker = eyeTracker.estimatePixelsPerDegree;
eyeTracker.saccThres = saccThresh;

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

if scanner == false

    % When experiment does not take place in scanner
    [dataLowNoise, dataHighNoise, totWin] = al_commonConfettiConditions(taskParam);

elseif scanner == true

    % For Hendrik's project in the scanner and with stress manipulation
    [dataRun1, dataRun2, dataRun3] = al_commonConfettiConditionsFMRI(taskParam, startsWithRun);
    totWin = sum(dataRun1.hit) + sum(dataRun2.hit) + sum(dataRun3.hit);
    
end

% -----------
% End of task
% -----------

if taskParam.gParam.customInstructions && passiveViewing == false
    taskParam.instructionText = taskParam.instructionText.giveFeedback(totWin, 'task');
    header = taskParam.instructionText.dynamicFeedbackHeader;
    txt = taskParam.instructionText.dynamicFeedbackTxt;
elseif taskParam.gParam.customInstructions == false && passiveViewing == false
    if isequal(language, 'German')
        header = 'Ende des Versuchs!';
        txt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben insgesamt %i Punkte gewonnen!', totWin);
    elseif isequal(language, 'English')
        header = 'End of the Experiment!';
        txt = sprintf('Thank you for taking part!\n\n\nYou have won a total of %i points!', totWin);
    else
        error('language parameter unknown')
    end
elseif passiveViewing
    header = 'Ende des Versuchs!';
    txt = 'Vielen Dank für Ihre Teilnahme!';
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