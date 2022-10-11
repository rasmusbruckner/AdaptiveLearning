%RUNARCVERSION   This script runs the DRESDEN version of the cannon task.
%
% Documentation
% Unit test
% Contributors
%
% Last updated: 08/21

% ----------------------------
% Set relevant task parameters
% ----------------------------
 
% Indicate your computer
computer = 'Macbook';

% Set number of trials of main task
trials = 2; %20;

% Set number of trials of control task
controlTrials = 4;  % this is the new control version that we added to control for differences between groups

% Number of practice trials 
practTrials = 2; 

% Number of trials to introduce the shield in the cover story
shieldTrials = 4; 

% Choose if task instructions should be shown
runIntro = true; %false;

% Choose if dialogue box should be shown
askSubjInfo = true;

% Determine blocks
blockIndices = [1 101 999 999];

% Use catch trials where cannon is shown occasionally
useCatchTrials = true; 

% Set text size and sentence length
sentenceLength = 85;

% Choose screen number
screenNumber = 2;%2; % 1: one screen; 2: two screens

% Number of catches during practice that is required to continue with main task
practiceTrialCriterion = 10;

% Run task in debug mode with smaller window
debug = false; %false;

%showTickmark = nan;

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

% Initialize
gparam_init = al_gparaminit();
gparam_init.taskType = 'dresden';
gparam_init.computer = computer;
gparam_init.trials = trials;
gparam_init.controlTrials = controlTrials;
gparam_init.practTrials = practTrials;
gparam_init.shieldTrials = shieldTrials;
gparam_init.runIntro = runIntro;
gparam_init.askSubjInfo = askSubjInfo;
gparam_init.blockIndices = blockIndices;
gparam_init.useCatchTrials = useCatchTrials;
gparam_init.sentenceLength = sentenceLength;
gparam_init.screenNumber = screenNumber;
gparam_init.practiceTrialCriterion = practiceTrialCriterion;
gparam_init.debug = debug;
gparam_init.concentration = [8 8 99999999]; % [16 8 99999999];
gparam_init.haz = [.125 1 0];

% Create object instance
gParam = al_gparam(gparam_init);

% ---------------------------------------------
% Create object instance with circle parameters
% ---------------------------------------------

%circle_init = al_circleinit();
circle = al_circle(); %circle_init

% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

%colors_init = al_colorsinit();
colors = al_colors();

% ---------------------------------------------
% Create object instance with key parameters
% ---------------------------------------------

%keys_init = al_keysinit();
keys = al_keys();

% ---------------------------------------------
% Create object instance with trigger parameters
% ---------------------------------------------

sendTrigger = false; 
if sendTrigger == true
    config_io;
end

%triggers_init = al_triggersinit();
triggers = al_triggers();

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

%timing_init = al_timinginit();
timingParam = al_timing();

% ---------------------------------------------
% Create object instance with srings to display
% ---------------------------------------------

%strings_init = al_stringsinit();
strings = al_strings();

% ---------------------------------------
% Put all object instances in task object
% ---------------------------------------

taskParam = ColorClass();
taskParam.gParam = gParam;
taskParam.circle = circle;
taskParam.colors = colors;
taskParam.keys = keys;
taskParam.triggers = triggers;
taskParam.timingParam = timingParam;
taskParam.strings = strings;

% ---------------
% Run ARC version
% ---------------

unitTest = false;
Data = al_dresdenVersion(taskParam, unitTest);

