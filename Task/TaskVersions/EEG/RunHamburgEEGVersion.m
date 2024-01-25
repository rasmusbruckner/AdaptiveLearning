function [dataMonetaryReward, dataMonetaryPunishment, dataSocialReward, dataSocialPunishment] = RunHamburgEEGVersion(unitTest, cBal, day)
%RUNHAMBURGEEGVERSION This function runs the EEG version of the confetti-cannon task
%
%   Input
%       unitTest: Indicates if unit test is being done or not
%       cBal: Current cBal (only allowed when running unit test)
%       day: Current test day (only allowed when running unit test)
%
%   Output
%       dataMonetaryReward: Task-data object monetary-reward condition
%       dataMonetaryPunishment: Task-data object monetary-punishment condition
%       dataSocialReward: Task-data object social-reward condition
%       dataSocialPunishment: Task-data object social-punishment condition
%
%   Documentation
%       This function runs the EEG version of the confetti-cannon task.
%       Subjects see a confetti cannon shooting confetti particles.
%       Currently, there is a monetary and a social condition.
%
%   Testing
%       To run the integration test, run "al_HamburgIntegrationTest"
%       To run the unit tests, run "al_unittets" in "DataScripts"
%
%   Last updated
%       01/24

% Todo: remuneration
% todo: tailored integration tests


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

% Set number of trials for experiment
trialsExp = 2;  % 200;  Hier bitte anpassen

% Set number of trials for integration test
trialsTesting = 20;

% Number of practice trials
practTrials = 2; % 20;  Hier bitte anpassen

% Risk parameter: Precision of confetti average
concentration = 12;

% Factor that translates concentration into shield size
% shieldFixedSizeFactor = 2;

% Hazard rate determining a priori changepoint probability
haz = .125;

% Number of confetti particles 
nParticles = 100;

% Confetti standard deviations
confettiStd = 1;  % Todo: the confetti EEG "dot" is not yet generated using this setting

% Start-up budget in Euros
startingBudget = 20;

% Choose if task instructions should be shown
runIntro = true;

% Choose if dialogue box should be shown
askSubjInfo = true;

% Determine blocks
blockIndices = [1 4 7 150];

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
screensize = [1    1    2560    1440]; %[1 1 1920 1080];  % fu ohne bildschirm [1    1    2560    1440]; get(0,'MonitorPositions'); ausprobieren

% Number of catches during practice that is required to continue with main task
practiceTrialCriterionNTrials = 5;
practiceTrialCriterionEstErr = 9;

% Rotation radius
rotationRad = 200;

% Radius of prediction spot
predSpotRad = 10;

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

% Send EEG trigge in this case
sendTrigger = false;  % In Hamburg bitte auf true setzten  
sampleRate = 500;  % hier ggf. anpassen
port = hex2dec('E050');  % hier ggf. anpassen
  
% Specify data directory
dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory'; % '~/Projects/for/data/reward_pilot';  % Hier bitte anpassen

% Confetti cannon image rectangle determining the size of the cannon
imageRect = [0 00 60 200];
socialFeedbackRect = [0 0 562 762]/4;

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

if unitTest
    trials = trialsTesting;
else
    trials = trialsExp;
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

% Todo: What is the best way to document this?
trialflow = al_trialflow();
trialflow.shot = ' ';
trialflow.confetti = 'show confetti cloud';
trialflow.cannonball_start = 'center';
trialflow.cannon = 'hide cannon';
trialflow.background = 'noPicture';
trialflow.currentTickmarks = 'show';
trialflow.cannonType = 'confetti';
trialflow.reward = 'standard';
trialflow.shieldType = 'constant';
trialflow.input = "mouse";

% ---------------------------------------------
% Create object instance with cannon parameters
% ---------------------------------------------

% Todo: Add some of the other cannon properties
cannon = al_cannon();
cannon.nParticles = nParticles;
cannon.confettiStd = confettiStd;

% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

% Todo: Are all color already part of this class?
colors = al_colors();

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

% -----------------------------------------------------------------
% Todo: Do we have to create object instance with mouse parameters?
% -----------------------------------------------------------------

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
sex = 'f';  % m/f/d
group = '1'; % 1=experimental/2=control
cBal = '1'; % 1/2/3/4
if ~unitTest
    cBal = '1'; % 1/2/3/4
    day = '1'; % 1/2
end

% If no user input requested
if gParam.askSubjInfo == false || unitTest

    % Just add defaults
    subject.ID = ID;
    subject.age = str2double(age);
    subject.sex = sex;
    subject.group = str2double(group);
    subject.cBal = str2double(cBal);
    subject.testDay = str2double(day);
    subject.date = date;

    % If user input requested
else

    % Variables that we want to put in the dialogue box
    prompt = {'ID:', 'Age:', 'Sex:', 'Group:', 'cBal:', 'Day:'};
    name = 'SubjInfo';
    numlines = 1;

    % Add defaults from above
    defaultanswer = {ID, age, sex, group, cBal, day};

    % Add information that is not specified by user (i.e., date)
    subjInfo = inputdlg(prompt, name, numlines, defaultanswer);

    % Put all relevant subject info in structure
    % ------------------------------------------

    subject.ID = subjInfo{1};
    subject.age = str2double(subjInfo{2});
    subject.sex = subjInfo{3};
    subject.group = str2double(subjInfo{4});
    subject.cBal = str2double(subjInfo{5});
    subject.testDay = str2double(subjInfo{6});
    subject.date = date;

    % Test user input
    checkString = dir(sprintf('*d%s*%s*', num2str(subject.testDay), num2str(subject.ID)));
    subject.checkID(checkString, 5);
    subject.checkSex();
    subject.checkGroup();
    subject.checkCBal(),
    subject.checkTestDay();
end

% Add starting bugdet
subject.startingBudget = startingBudget;

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
display.backgroundCol = [66, 66, 66];
display.imageRect = imageRect;
display.socialFeedbackRect = socialFeedbackRect;

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
circle.tickWidth = tickWidth;
% circle.shieldFixedSizeFactor = shieldFixedSizeFactor;
circle.outcSize = 5;
circle = circle.compute_circle_props();

% ----------------------------------------------
% Create object instance with trigger parameters
% ----------------------------------------------

triggers = al_triggers();
triggers.sampleRate = sampleRate;
triggers.port = port;

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

[dataMonetaryReward, dataMonetaryPunishment, dataSocialReward, dataSocialPunishment] = al_HamburgEEGConditions(taskParam);

% Todo: determine payment
% todo: should be actual amount of money
totWin = sum(dataMonetaryReward.hit) + sum(dataMonetaryReward.hit);

% -----------
% End of task
% -----------

header = 'Ende des Versuchs!';
txt = 'Vielen Dank für Deine Teilnahme! Wir hoffen, es hat Dir gefallen.';
feedback = true; % indicate that this is the instruction mode
al_bigScreen(taskParam, header, txt, feedback, true); % todo: function has to be cleaned

ListenChar();
ShowCursor;
Screen('CloseAll');

% Inform user about timing
fprintf('Total time: %.1f minutes\n', char((GetSecs - timingParam.ref)/60));

end