function RunMagdeburgFMRIVersion(runUnitTest, cBal)
%RUNMAGDEBURGFMRIVERSION This function runs the fMRI version
%  for the study in Magdeburg
%
%   Input
%       runUnitTest: Indicates if unit test is being done or not
%       cBal: Current cBal (only allowed when running unit test)
%
%   Testing
%       To run the integration test, run "al_sleepIntegrationTest"
%       To run the unit tests, run "al_unittets" in "DataScripts"
%
%   Last updated
%       03/24

% todo: integration test

%% Todo: implement manual start of block if sth. goes wrong in scanner
% - ip-based computer detection for automatic parameters (for all versions)
% - so instead of starting at 1, start at higher value

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

% Set number of trials for experiment
trialsExp = 2;%60;  % 180;  Hier bitte anpassen

% Number of practice trials
practTrials = 2; % 20;  Hier bitte anpassen

% Number of blocks per condition
nBlocks = 2; % usually 3 * 2 = 6

% Risk parameter: Precision of cannonballs
concentration = [16, 8];

% Hazard rate determining a priori changepoint probability
haz = .125;

% Choose if task instructions should be shown
runIntro = true; %false;

% Choose if dialogue box should be shown
askSubjInfo = true;

% Determine blocks
blockIndices = 1;

% Use catch trials where cannon is shown occasionally
useCatchTrials = true;

% Catch-trial probability
catchTrialProb = 0.1;

% Set sentence length
sentenceLength = 60;

% Set text and header size
textSize = 35;
headerSize = 50;

% Screen size
screensize = [1 1 1280 1024]; %[%1    1    2560    1440]; %[1 1 1920 1080];  %[1 1 1920 1080];%[1    1    2560    1440]; %[1 1 1920 1080];%[1    1    2560    1440]; % Für MD: [screenWidth, screenHeight] = Screen('WindowSize', 0); screenSize = [1, 1, screenWidth, screenHeight];
%[1    1    2560    1440]; %[1 1 1920 1080]; %[1    1    2560    1440]; %[1 1 1920 1080]; % [1    1    2560    1440];%[1 1 1920 1080]; % fu ohne bildschirm [1    1    2560    1440];%[1 1 1920 1080]; %fu mit bildschirm [1 1 1920 1080]; % magdeburg : [1    1    2560    1440]; %[1 1 1920 1080];%get(0,'MonitorPositions');%[1    1    2560    1440]; %get(0,'MonitorPositions'); %[1    1    2560    1440]%
%displayobj.screensize = get(0,'MonitorPositions'); %[1    1
%2560    1440]%  laptop [1    1    2560    1440];

% Maximum number of trials exceeding a certain estimation error during practice that is required to continue with main task
practiceTrialCriterionNTrials = 5;
practiceTrialCriterionEstErr = 9;

% Rotation radius
rotationRad = 200;

% Tickmark width
tickWidth = 1;

% Key codes
%% TODO: TAKE md SETTINGS   
keySpeed = 1; %1.5; %2;
keySpeedScanner = 0.6;
slowKeySpeed = 0.0; % 0.5;
leftKey = 42; %50;  % 42
rightKey = 45; %51;  % 45
space = 66; 
s = 40; %83; % MD 83; %40; % Für MD KbDemo in Konsole laufen lassen und s drücken um keyCode zu bekommen  Lavinia: Hier eventuell anpassen
enter = 37; %13;%37%;13; %37;% MD 13; %37; % md = 13   MD: Hier bitte anpassen, müsste bei euch 13 sein

% Run task in debug mode with smaller window
debug = false; %true; %false;

% Print timing for checking
printTiming = true;

% Hide cursor
hidePtbCursor = false;

% Reward magnitude
rewMag = 0.0;

% Specify data directory
dataDirectory = 'DataDirectory'; %'~/Dropbox/AdaptiveLearning/DataDirectory'; %'DataDirectory'; %%'~/Dropbox/AdaptiveLearning/DataDirectory';  % MD: 'DataDirectory' vorher cd AdaptiveLearning

scanner = true;

leftRelease = 43; % MD: 55; %%43;
rightRelease = 44; % MD: 56; %%44;
leftKeyScanner = 42; % MD: 50; %42; %50;  % 42
rightKeyScanner = 45;% MD: 51; %45; %51;  % 45
spaceScanner = 66; %MD 52;

% leftRelease = 43;
% rightRelease = 44;
% leftKeyScanner = 42;
% rightKeyScanner = 45;
% spaceScanner = 66;

nFrames = 20; %30; 80

useResponseThreshold = true;
responseThreshold = 10;


% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

if runUnitTest
    trials = 20;
else
    trials = trialsExp;
end

% Initialize general task parameters
gParam = al_gparam();
gParam.taskType = 'MagdeburgFMRI';
gParam.trials = trials;
gParam.practTrials = practTrials;
gParam.nBlocks = nBlocks;
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
gParam.scanner = scanner;
gParam.useResponseThreshold = useResponseThreshold;
gParam.responseThreshold = responseThreshold;
gParam.shieldMu = 15;                   
gParam.shieldMin = 10;
gParam.shieldMax = 180;


% Save directory
cd(gParam.dataDirectory);

% -------------------------------------
% Create object instance for trial flow
% -------------------------------------

trialflow = al_trialflow();
trialflow.shot = 'animate cannonball';
trialflow.confetti = 'none';
trialflow.cannonball_start = 'center';
trialflow.cannon = 'hide cannon';
trialflow.shieldType = "constant";
trialflow.shield = 'variable';
trialflow.input = "keyboard";
trialflow.currentTickmarks = 'show';

% ---------------------------------------------
% Create object instance with cannon parameters
% ---------------------------------------------

cannon = al_cannon(false);
cannon.nFrames = nFrames;

% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

colors = al_colors();
colors.background = [0, 0, 0];
colors.circleCol = [224, 224, 224];
colors.blue = [122, 96, 215];
colors.winColor = colors.blue;

% ------------------------------------------
% Create object instance with key parameters
% ------------------------------------------

keys = al_keys();
keys.s = s;
keys.enter = enter;
keys.slowKeySpeed = slowKeySpeed;

if scanner
    keys.keySpeed = keySpeedScanner;
    keys.leftKey = leftKeyScanner; %50;
    keys.rightKey = rightKeyScanner; %51;
    keys.space = spaceScanner;% 52;  % optionally also 49
    keys.leftRelease = leftRelease;
    keys.rightRelease = rightRelease;
else
    keys.keySpeed = keySpeed;
    keys.leftKey = leftKey; %50;
    keys.rightKey = rightKey; %51;
    keys.space = space;% 52;  % optionally also 49
    keys.leftRelease = leftRelease;
    keys.rightRelease = rightRelease;

end



% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

timingParam = al_timing();
timingParam.cannonBallAnimation = 0.5;
timingParam.cannonMissAnimation = 0.75;

if runIntro
    timingParam.jitterITI = 1;
    timingParam.fixedITI = 1;
else
    timingParam.jitterITI = 4;
    timingParam.jitterFixCrossOutcome = 4;
    timingParam.fixCrossOutcome = 2;
    timingParam.fixedITI = 2;
end

% Record current time for estimating duraiton of experiment
timestampBeginExp = GetSecs();

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
ID = '01'; % 2 digits
age = '99';
gender = 'f';  % m/f/d
if ~runUnitTest
    cBal = '1'; % 1/2/3/4
end

% If no user input requested
if gParam.askSubjInfo == false || runUnitTest

    % Just add defaults
    subject.ID = ID;
    subject.age = str2double(age);
    subject.gender = gender;
    subject.cBal = str2double(cBal);
    subject.date = date;

    % If user input requested
else

    % Variables that we want to put in the dialogue box
    prompt = {'ID:', 'Age:', 'Gender:', 'cBal:'};
    name = 'SubjInfo';
    numlines = 1;

    % Add defaults from above
    defaultanswer = {ID, age, gender, cBal};

    % Add information that is not specified by user (i.e., date)
    subjInfo = inputdlg(prompt, name, numlines, defaultanswer);

    % Put all relevant subject info in structure
    % ------------------------------------------

    subject.ID = subjInfo{1};
    subject.age = str2double(subjInfo{2});
    subject.gender = subjInfo{3};
    subject.cBal = str2double(subjInfo{4});
    subject.date = date;

    % Test user input and selected number of trials
    checkString = dir(sprintf('*%s*', num2str(subject.ID)));
    subject.checkID(checkString, 2);
    subject.checkGender();
    subject.checkCBal(),
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

% Open psychtoolbox window
display = display.openWindow(gParam);

% Create stimuli
display = display.createRects();
display = display.createTextures("standard");

% Disable keyboard and, if desired, mouse cursor
if hidePtbCursor == true
    HideCursor;
end

if ~scanner
    ListenChar(2); % not compatible with KbQueue
end

% ---------------------------------------------
% Create object instance with circle parameters
% ---------------------------------------------

circle = al_circle(display.windowRect);
circle.rotationRad = rotationRad;
circle.tickWidth = tickWidth;
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
taskParam.gParam.customInstructions = false;

% --------------
% Run intro/task
% --------------

if runIntro 

    al_MagdeburgFMRIConditions(taskParam)

    % -------------------
    % End of instructions
    % -------------------

    header = 'Übung geschafft!';
    txt = 'Sie haben die Übung erfolgreich abgeschlossen\n\n\nGleich geht es mit dem Experiment weiter.';
    feedback = true; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback, true);

else

    totWin = al_MagdeburgFMRIConditions(taskParam);
    
    % -----------
    % End of task
    % -----------

    header = 'Ende des Versuchs!';
    txt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben insgesamt %i Punkte gewonnen!', totWin);
    feedback = true; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback, true);

end

ListenChar();
ShowCursor;
Screen('CloseAll');

% Inform user about timing
fprintf('Total time: %.1f minutes\n', char((GetSecs - timestampBeginExp)/60));

end