%RUNDRESDENVERSION   This script runs the CHINESE version of the cannon task.
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

% 'Montreal' and 'NoConstraints'
        enemyHaz = 0.15; % probability that enemy changes
        planetHaz = 1; % probability that planet changes color
        safePlanet = 0; % minimum number of trials before planet changes
        safeEnemy = 0; % minimum number of trials before enemy changes
        nPlanets = 6; % number of planets
        nEnemies = 2; % number of enemies
        chinesePractTrials = 2; % 200 number of practice trials
        nb = 1; % number of blocks
% Set number of trials of control task
controlTrials = 4;  % this is the new control version that we added to control for differences between groups

% Number of practice trials - note that in "reversal" version this is muliplied by 2
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
screenNumber = 2; % 1: one screen; 2: two screens

% Number of catches during practice that is required to continue with main task
practiceTrialCriterion = 10;

% XX
useTrialConstraints = 'aging';

% Run task in debug mode with smaller window
debug = false;

% ---------------------------------------------------
% Create object instance with general task parameters
% ---------------------------------------------------

% Initialize
gparam_init = al_gparaminit();
gparam_init.taskType = 'chinese';
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
gparam_init.useTrialConstraints = useTrialConstraints;
gparam_init.debug = debug;
gparam_init.concentration = [8 8 99999999]; % [16 8 99999999];
gparam_init.haz = [.125 1 0];

gparam_init.enemyHaz = enemyHaz;
gparam_init.planetHaz = planetHaz;
gparam_init.safePlanet = safePlanet;
gparam_init.safeEnemy = safeEnemy;
gparam_init.nPlanets = nPlanets;
gparam_init.nEnemies = nEnemies;
gparam_init.chinesePractTrials = chinesePractTrials; 
gparam_init.nb = nb; 

% Create object instance
gParam = al_gparam(gparam_init);

% ---------------------------------------------
% Create object instance with circle parameters
% ---------------------------------------------

%circle_init = al_circleinit();
circle = al_circle(); %

% ---------------------------------------------
% Create object instance with color parameters
% ---------------------------------------------

colors_init = al_colorsinit();
colors = al_colors(colors_init);

% ---------------------------------------------
% Create object instance with key parameters
% ---------------------------------------------

keys_init = al_keysinit();
keys = al_keys(keys_init);

% ---------------------------------------------
% Create object instance with trigger parameters
% ---------------------------------------------

sendTrigger = false; 
if sendTrigger == true
    config_io;
end

triggers_init = al_triggersinit();
triggers = al_triggers(triggers_init);

% ---------------------------------------------
% Create object instance with timing parameters
% ---------------------------------------------

timing_init = al_timinginit();
timingParam = al_timing(timing_init);

% ---------------------------------------------
% Create object instance with srings to display
% ---------------------------------------------

strings_init = al_stringsinit();
strings = al_strings(strings_init);

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
% Run Chinese version
% ---------------

unitTest = false;
DataMain = al_ChineseVersion(taskParam, unitTest);

