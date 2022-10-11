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
trials = 20;% 0; % 20;

% Set number of trials of control task testing speed and accuracy
controlTrials = 4;

% Number of practice trials
practTrials = 2; 

% Number of trials to introduce the shield in the cover story
shieldTrials = 4; 

% Risk parameter: Inverse variability of cannonballs
concentration = 12;

% Hazard rate determining a priori changepoint probability
haz = .125;

% Choose if task instructions should be shown
runIntro = false;

% Choose if dialogue box should be shown
askSubjInfo = true;

% Determine blocks
blockIndices = [1 25 999 999];

% Use catch trials where cannon is shown occasionally
useCatchTrials = true; 

% Set sentence length
sentenceLength = 85;

% Choose screen number
screenNumber = 1;

% Number of catches during practice that is required to continue with main task
practiceTrialCriterion = 10;

% Rotation radius
rotationRad = 200;

% Radius of prediction spot
predSpotRad = 10;

% Tickmark width
tickWidth = 1; 

% XX
imageRect = [0 0 60 180];

cannonType = "confetti";

screensize = [1 1 1920 1080];% [1    1    2560    1440];

% Run task in debug mode with smaller window
debug = true;%false;%true; %false;

% Print timing
printTiming = true;

% Run unit test?
unitTest = false;

% ---------------------------------------------------   
% Create object instance with general task parameters
% ---------------------------------------------------

% Initialize
% Create object instance
gParam = al_gparam();

%gparam_init = al_gparaminit();
gParam.taskType = 'Hamburg';
%gParam.computer = computer;
gParam.trials = trials;
gParam.controlTrials = controlTrials;
gParam.practTrials = practTrials;
gParam.shieldTrials = shieldTrials;
gParam.runIntro = runIntro;
gParam.askSubjInfo = askSubjInfo;
gParam.blockIndices = blockIndices;
gParam.useCatchTrials = useCatchTrials;
%gParam.sentenceLength = sentenceLength;
gParam.screenNumber = screenNumber;
gParam.practiceTrialCriterion = practiceTrialCriterion;
gParam.debug = debug;
gParam.printTiming = printTiming;
gParam.concentration = concentration;
gParam.haz = haz;



% ---------------------------------------------
% Create object instance with circle parameters
% ---------------------------------------------

%circle = al_circle();

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

sendTrigger = false; % add triggers for Hamburg
if sendTrigger == true
    config_io;
end

triggers = al_triggers();

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

timingParam = al_timing();

% ----------------------------------------------
% Create object instance with strings to display
% ----------------------------------------------

strings = al_strings();
strings.txtPressEnter = 'Weiter mit Enter';

% ----------
% User Input
% ----------

subject = al_subject();

% Default input
ID = '99999'; % 5 digits
age = '99'; 
sex = 'f';  % m/f/d
group = '1'; % 1=sleep/2=control
cBal = '1'; % 1/2/3/4
day = '1'; % 1/2

% If no user input requested
if gParam.askSubjInfo == false

    % Just add defaults
    subject.ID = str2double(ID);
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

    % Add information that is not specified by user (i.e. date)
    subjInfo = inputdlg(prompt, name, numlines, defaultanswer);

    % Put all relevant subject info in structure
    % ------------------------------------------

    subject.ID = str2double(subjInfo{1});
    subject.age = str2double(subjInfo{2});
    subject.sex = subjInfo{3};
    subject.group = str2double(subjInfo{4});
    subject.cBal = str2double(subjInfo{5});
    subject.testDay = str2double(subjInfo{6});
    subject.date = date;

    % Test user input and selected number of trials
    checkString = dir(sprintf('*d%s*%s*', num2str(subject.testDay), num2str(subject.ID)));
    subject.checkID(checkString);
    subject.checkSex();
    subject.checkGroup();
    subject.checkCBal(),
    subject.checkTestDay();
    subject.check_N_Trials(gParam)
end


% -------------------------------------
% Create object instance for trial flow
% -------------------------------------
% todo: document all cases in trialflow
trialflow = al_trialflow();
trialflow.shot = ' '; % todo: noch machen
trialflow.confetti = 'show confetti cloud'; 
trialflow.cannonball_start = ' '; 
trialflow.cannon = 'hide cannon';
trialflow.background = 'noPicture';
trialflow.currentTickmarks = 'show';
trialflow.cannonType = cannonType;

% ------------------
% Display properties 
% ------------------

% Display-object instance
display = al_display();

% Deal with psychtoolbox warnings
% Todo: Make sure that all tests are passed on task PC
display.screen_warnings();


display.screensize = screensize;
display.backgroundCol = [66, 66, 66];
display.imageRect = imageRect;

% Open psychtoolbox window
display = display.openWindow(gParam);

% Todo: Docment thids
display = display.createRects();
display = display.createTextures(trialflow.cannonType);


% Disable keyboard and, if desired, mouse cursor 
% display.hidePtbCursor = hidePtbCursor;
%if hidePtbCursor == true
    %display.cursorKeys()
 %  HideCursor;
%end
%ListenChar(2);


% ---------------------------------------------
% Create object instance with circle parameterpre
% ---------------------------------------------

% Todo: Delete a couple of variables when versions are independent;
% document properly
circle = al_circle(display.windowRect);
circle.rotationRad = rotationRad;
circle.predSpotRad = predSpotRad;
circle.tickWidth = tickWidth;
circle = circle.compute_circle_props();


% ---------------------------------------
% Put all object instances in task object
% ---------------------------------------

taskParam = al_objectClass();
taskParam.gParam = gParam;
taskParam.circle = circle;
taskParam.colors = colors;
taskParam.keys = keys;
taskParam.triggers = triggers;
taskParam.timingParam = timingParam;
taskParam.strings = strings;
taskParam.trialflow = trialflow;
taskParam.display = display;
taskParam.subject = subject;

% Replace this when getting back to unit tests
taskParam.unitTest = unitTest; 

al_HamburgConditions(taskParam);


% -----------
% End of task
% -----------

header = 'Ende des Versuchs!';
%txt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben %.2f Euro verdient!', totWin);
feedback = true; % indicate that this is the instruction mode
%al_bigScreen(taskParam, header, txt, feedback, true);  

ListenChar();
ShowCursor;
Screen('CloseAll');

% Inform user about timing
fprintf('Total time: %.1f minutes\n', char((GetSecs - timingParam.ref)/60));

%totWin = dataLowNoise.accPerf(end) + dataHighNoise.accPerf(end);