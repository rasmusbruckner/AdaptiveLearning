function [dataStandardTickmarks, dataAddTickmarks, dataStandardCannonVar, dataDriftingCannonVar, dataDriftingCannonVarWM] = RunVarianceWorkingMemoryVersion(runUnitTest, cBal, day)
%RUNVARIANCEWORKINGMEMORY This function runs the first Gläscher version of
%   VWM including variance change points and working memory manipulations
%
%   Input
%       runUnitTest: Indicates if unit test is being done or not
%       cBal: Current cBal (only allowed when running unit test)
%       day: Current tes day (only allowed when running unit test)
%
%   Output
%       dataStandardTickmarks: Task-data object standard tick mark
%       dataAddTickmarks: Task-data object multiple tick marks
%       dataStandardCannonVar Task-data object change point + variance
%       dataDriftingCannonVar: Task-data object drift + variance
%       dataDriftingCannonVarWM: Task-data object drift + variance + tick
%       marks
%
%   Testing
%       To run the integration test, run "al_HamburgIntegrationTest"
%       To run the unit tests, run "al_unittets" in "DataScripts"
%
%   Last updated
%       01/24

% Todo: ensure that practice is saved too

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

if exist('day', 'var') && ~runUnitTest
    error('No unit test: day cannot be used');
elseif exist('cBal', 'var') && runUnitTest
    if ~ischar(day)
        error('day must be char');
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

% Set number of trials for experiment
trialsExp = 2; % 200;  Hier bitte anpassen

% Set number of trials for integration test
trialsTesting = 20;

% Number of practice trials
practTrials = 2; % 20;  Hier bitte anpassen

% Risk parameter: Precision of confetti average
concentration = [12, 16, 8]; % the first value is the concentration
% in the versions without variability changepoints. The second and third
% are for the different variability changepoints.

% Cannon drift in drift conditions
driftConc = 30;

% Factor that translates concentration into shield size
shieldFixedSizeFactor = 2;

% Hazard rate determining a priori changepoint probability
haz = .125;

% Variability hazard rate
hazVar = 0.1;

% Safe trials variance change point
safeVar = 10;

% Number of confetti particles 
nParticles = 40;

% Confetti standard deviations
confettiStd = 1;

% Choose if task instructions should be shown
runIntro = true;

% Choose if dialogue box should be shown
askSubjInfo = true;

% Determine blocks
blockIndices = [1 51 101 151]; % These indicate start of new block (e.g., break after 20 trials = 21)

% Use catch trials where cannon is shown occasionally
useCatchTrials = true;

% Catch-trial probability
catchTrialProb = 0.1;

% Set sentence length
sentenceLength = 100;

% Set text and header size
textSize = 35;
headerSize = 50;

% Screen size
screensize = [1 1 1920 1080]; %[1    1    2560    1440]; %; [1 1 1920 1080];  % fu ohne bildschirm [1    1    2560    1440]; get(0,'MonitorPositions'); ausprobieren

% Number of catches during practice that is required to continue with main task
practiceTrialCriterionNTrials = 5;
practiceTrialCriterionEstErr = 9;

% Rotation radius
rotationRad = 200;
    
% Tickmark width
tickWidth = 1;

% Key codes
s = 40; % Für Hamburg KbDemo in Konsole laufen lassen und s drücken um keyCode zu bekommen: Hier eventuell anpassen
enter = 37; % Hamburg: Hier bitte anpassen

% Keyboard device number
% kbDev = 19;

% Run task in debug mode with smaller window
debug = false;

% Show random confetti threshold for validation (don't use in experiment)
showConfettiThreshold = false;

% Print timing for checking
printTiming = true;

% Hide cursor
hidePtbCursor = true;

% Reward magnitude
rewMag = 0.1;

% Specify data directory
dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory'; % '~/Projects/for/data/reward_pilot';  % Hier bitte anpassen

% Confetti cannon image rectangle determining the size of the cannon
imageRect = [0 00 60 200];

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
gParam.taskType = 'Hamburg'; % todo: maybe specific category for this version (let's see)
gParam.trials = trials;
gParam.practTrials = practTrials;
gParam.runIntro = runIntro;
gParam.passiveViewing = false;
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
gParam.hazVar = hazVar;
gParam.safeVar = safeVar;
gParam.rewMag = rewMag;
gParam.dataDirectory = dataDirectory;
gParam.saveName = 'vwm';
gParam.driftConc = driftConc;
gParam.customInstructions = false;

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
trialflow.cannonType = "confetti";
trialflow.reward = "standard";
trialflow.shield = "variable";
trialflow.shieldType = "constant";
trialflow.input = "mouse"; 
trialflow.shot = 'animate cannonball';

% ---------------------------------------------
% Create object instance with cannon parameters
% ---------------------------------------------

% Todo: Add some of the other cannon properties
defaultParticles = false;
cannon = al_cannon(defaultParticles);
cannon.nParticles = nParticles;
cannon.confettiStd = confettiStd;

cannon = cannon.al_staticConfettiCloud(trialflow.colors);

% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

% Todo: Are all color already part of this class?
colors = al_colors();

% ------------------------------------------
% Create object instance with key parameters
% ------------------------------------------

keys = al_keys();
if ~exist('kbDev')
  keys = al_kbdev(keys);
else
  keys.kbDev = kbDev;
end
keys.s = s;
keys.enter = enter;

% -----------------------------------------------------------------
% Todo: Do we have to create object instance with mouse parameters?
% -----------------------------------------------------------------

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

timingParam = al_timing();
timingParam.cannonBallAnimation = 1.5;

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
if ~runUnitTest
    cBal = '1'; % 1/2/3/4
    day = '1'; % 1/2
end

% If no user input requested
if gParam.askSubjInfo == false || runUnitTest

    % Just add defaults
    subject.ID = ID;
    subject.age = str2double(age);
    subject.gender = gender;
    subject.group = str2double(group);
    subject.cBal = str2double(cBal);
    subject.testDay = str2double(day);
    subject.date = date;

    % If user input requested
else

    % Variables that we want to put in the dialogue box
    prompt = {'ID:', 'Age:', 'Gender:', 'Group:', 'cBal:', 'Day:'};
    name = 'SubjInfo';
    numlines = 1;

    % Add defaults from above
    defaultanswer = {ID, age, gender, group, cBal, day};

    % Add information that is not specified by user (i.e., date)
    subjInfo = inputdlg(prompt, name, numlines, defaultanswer);

    % Put all relevant subject info in structure
    % ------------------------------------------

    subject.ID = subjInfo{1};
    subject.age = str2double(subjInfo{2});
    subject.gender = subjInfo{3};
    subject.group = str2double(subjInfo{4});
    subject.cBal = str2double(subjInfo{5});
    subject.testDay = str2double(subjInfo{6});
    subject.date = date;

    % Test user input
    checkString = dir(sprintf('*id_%s*', num2str(subject.ID)));
    subject.checkID(checkString, 5);
    subject.checkGender();
    subject.checkGroup();
    subject.checkCBal(),
    subject.checkTestDay();
end

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

circle = al_circle(display.windowRect);
circle.rotationRad = rotationRad;
circle.tickWidth = tickWidth;
circle.shieldFixedSizeFactor = shieldFixedSizeFactor;
circle = circle.computeCircleProps();

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

% --------
% Run task
% --------

[dataStandardTickmarks, dataAddTickmarks, dataStandardCannonVar, dataDriftingCannonVar, dataDriftingCannonVarWM] = al_varianceWorkingMemoryConditions(taskParam);
totWin = sum(dataStandardTickmarks.hit) + sum(dataAddTickmarks.hit) + sum(dataStandardCannonVar.hit) + sum(dataDriftingCannonVar.hit) + sum(dataDriftingCannonVarWM.hit);

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