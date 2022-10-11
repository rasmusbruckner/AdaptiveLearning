
% Clear all variables
clearvars

% ----------------------------
% Set relevant task parameters
% ----------------------------

% Set number of trials of main task
trials = 20;% 30;

% Number of practice trials
practTrials = 20; 

% Number of trials to introduce the shield in the cover story
shieldTrials = 5;% 4;   

% Risk parameter: Precision of cannonballs
concentration = 12;     

% Hazard rate determining a priori changepoint probability
haz = [0.125 1 0];  % 
% Choose if task instructions should be shown
runIntro = true; %false;

% Choose if dialogue box should be shown
askSubjInfo = false;

% Determine blocks
blockIndices = [1 99 101 999 999]; 

% Use catch trials where cannon is shown occasionally
useCatchTrials = true;                                    

% Set sentence length
sentenceLength = 85;  

% Set text size
textSize = 30;

% Choose screen number
screenNumber = 1;  % 1: one screen; 2: two screens               

% Number of catches during practice that is required to continue with main task
practiceTrialCriterion = 10;

% Run task in debug mode with smaller window
debug = false;

% XX                                                                          
hideCursor_listenChar = false;

% Run unit test?
unitTest = false; 

% Specify data directory
dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

% Initialize
gParam = al_gparam();
gParam.taskType = 'Sleep';
gParam.trials = trials;
gParam.practTrials = practTrials;
gParam.shieldTrials = shieldTrials;
gParam.runIntro = runIntro;
gParam.askSubjInfo = askSubjInfo;
gParam.blockIndices = blockIndices;
gParam.useCatchTrials = useCatchTrials;
gParam.screenNumber = screenNumber;
gParam.practiceTrialCriterion = practiceTrialCriterion;
gParam.debug = debug;
gParam.concentration = concentration;
gParam.haz = haz;
gParam.dataDirectory = dataDirectory;

% -------------------------------------
% Create object instance for trial flow
% -------------------------------------

trialflow = al_trialflow();
trialflow.shot = 'animate cannonball';
trialflow.confetti = 'none';
trialflow.cannonball_start = 'center';
trialflow.cannon = 'hide cannon';                    

% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

colors = al_colors();

% ------------------------------------------
% Create object instance with key parameters
% ------------------------------------------

keys = al_keys();
keys.keySpeed = 2;
keys.slowKeySpeed = 0.5;

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

timingParam = al_timing();
ref = GetSecs();
timingParam.ref = ref; GetSecs();

% ----------------------------------------------
% Create object instance with strings to display
% ----------------------------------------------

strings = al_strings();
strings.txtPressEnter = 'Weiter mit Enter';

% -------------------------------------------
% Create object instance with display setting
% -------------------------------------------

display = al_display();
%display.hideCursor_listenChar = hideCursor_listenChar;

% -----------------
% Run sleep version
% -----------------

% Save directory
cd(gParam.dataDirectory);

rng('shuffle')

% User Input
% ----------

% Default input
ID = '99999';
age = '99';
sex = 'f';  % m/f/d
group = '1'; % 1=sleep/2=control
cBal = '1'; % 1/2/3/4
day = '1'; % 1/2

% If no user input requested
if gParam.askSubjInfo == false
    
    % Just add defaults
    subject = struct('ID', ID, 'age', age, 'sex', sex, 'group', group, 'cBal', cBal, 'day', day, 'date', date);
    
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
    
    subject = al_subject();
    subject.ID = subjInfo{1}; 
    subject.age = subjInfo{2}; 
    subject.sex = subjInfo{3};
    subject.group = subjInfo{4};
    subject.cBal = str2double(cell2mat(subjInfo(5)));
    subject.testDay = str2double(cell2mat(subjInfo(6)));
    subject.date = date;

    % Test user input and selected number of trials
    subject.checkID();
    subject.checkSex();
    subject.checkGroup();
    subject.checkCBal(),
    subject.checkTestDay();
    subject.check_N_Trials(gParam)
     
end
    % Deal with psychtoolbox warnings
    %display = al_display();
    %display.screen_warnings();

    % Open psychtoolbox window
    %display = display.openWindow(gParam);

    % XX
    %display = display.createRects();
    %display = display.createTextures();

    %display.cursorChar()     
    
    % ---------------------------------------------
    % Create object instance with circle parameters
    % ---------------------------------------------
    
%    circle = al_circle(display.windowRect);
    
    % ---------------------------------------
    % Put all object instances in task object
    % ---------------------------------------
    % todo: das sowieso erst am ende
    
    % Object that harbors all relevant object instances
    taskParam = al_objectClass();

    % Add these to task-parameters object 
    taskParam.gParam = gParam;
    taskParam.strings = strings;
    taskParam.trialflow = trialflow;
    %taskParam.circle = circle;
    taskParam.colors = colors;
    taskParam.keys = keys;
    taskParam.timingParam = timingParam;
    taskParam.display = display;
    taskParam.subject = subject;

    taskParam.unitTest = unitTest;


    %condition = 'shield';
    condition = 'main';
    taskData = al_generateOutcomesMain(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(1), condition);
    taskData.cp