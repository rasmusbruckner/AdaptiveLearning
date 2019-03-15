function DataMain = AdaptiveLearning(unitTest)
%ADAPTIVELEARNING   Master function for the cannon task
%   AdaptiveLearning(false) or adaptiveLearning runs the cannon task.
%   adaptiveLearning(true) is part of a unit test to control task
%   output after task changes. Scripts for unit test:
%   ~/AdaptiveLearning/DataScripts
%
%   You can choose between five task types:
%   "Dresden version":      Change point task with two control conditions
%                               - optimal learning rate = 1
%                               - optimal learning rate = 0
%   "Oddball version":      Change point task with oddball condition
%   "Reversal version":     Change point task with occasional reversals to
%                           previous change point location
%   "Chinese restaurant":   Learning of a state space
%   "ARC version":          Owen's Cambridge version
%                               - Different noise conditions
%                               - Tickmark on vs. off
%
%   Written by Rasmus Bruckner (MPI/FU Berlin)
%   Contributors: Ben Eppinger (Concordia), Matt Nassar (Brown), 
%   Lennart Wittkuhn (MPI), Owen Parsons (Cambridge)
%
%   Version 01/2019


% Initialize task
% ----------------

% Check if unit test is required
if nargin == 0
    unitTest = false;
end

if ~unitTest
    clear vars
    unitTest = false;
end

% Indentifies your machine; if you have internet!
computer = 'MacMini';
computer = 'Macbook';

% Choose task type:
%   - 'oddball'
%   - 'dresden'
%   - 'reversal'
%   - 'chinese'
%   - 'ARC'
taskType = 'chinese';

% Version specific parameters
% ---------------------------

switch taskType
    
    case 'dresden'
    
        trials              = 2; % 240
        controlTrials       = 1; % 120
        concentration       = [12 8 99999999];
        DataFollowOutcome   = nan;
        DataFollowCannon    = nan;
        textSize            = 18;

        % Check number of trials in each condition
        if  (trials > 1 && mod(trials, 2)) == 1 || (controlTrials >...
                1 && mod(controlTrials, 2) == 1)
            msgbox('All trials must be even or equal to 1!');
            return
        end
    
    case 'oddball'
    
        % Trials first session
        trialsS1        = 50; % 40
        % Trials second session
        trialsS2S3      = 50; % 240
        controlTrials   = nan;
        concentration   = [10 12 99999999];
        DataOddball     = nan;
        textSize        = 30;
    
    case 'reversal'
    
        trials          = 20;
        controlTrials   = nan;
        concentration   = [10 12 99999999];
        nPlanets        = 1;
        nEnemies        = nan;
        planetHaz       = nan;
        enemyHaz        = nan;
        safePlanet      = nan;
        safeEnemy       = nan;
        DataOddball     = nan;
        textSize        = 19;
    
    case 'chinese'
        
        useTrialConstraints = true; % uses code with trial constraints
        blockIndices = [1 999 999 999]; % only for useTrialConstraints = false!
        nb = 6; % number of blocks: only for useTrialConstraints = true!
        trials = 300; %400; % use 400 for useTrialConstraints = true!
        chinesePractTrials = 2; % 200 number of practice trials
        nPlanets = 2; % number of planets
        nEnemies = 2; % number of enemies
        planetHaz = 1; % probability that planet changes color
        enemyHaz = 0.15; % probability that enemy changes
        safePlanet = 0; % minimum number of trials before planet changes (on) 
        safeEnemy = 0; % minimum number of trials before enemy changes
        concentration = [12 12 99999999]; % anpassen?
        textSize = 16; % text size for instructions
        showTickmark = nan; % do not show tickmark
        DataOddball = nan; % do not use anything from oddball condition
        controlTrials = nan; % do not use control trials from "Dresden condition"
        language = 2; % 1: German, 2: English

    case 'ARC'
    
        trials          = 2; % 240
        controlTrials   = 4; % 60; % this is the new control version that we added to control for differences between groups
        concentration   = [16 8 99999999]; 
        blockIndices    = [1 101 999 999]; %[1 121 999 999];
        textSize        = 19;
        nPlanets        = 1;
        nEnemies         = nan;
        planetHaz      = nan;
        enemyHaz        = nan;
        safePlanet     = nan;
        safeEnemy       = nan;
        chinesePractTrials = nan;

        % Check number of trials
        if  (trials > 1 && mod(trials, 2)) == 1
            msgbox('All trials must be even or equal to 1!');
            return
        end
end

% Version-independent parameters
runIntro                = false;
askSubjInfo             = true;
sendTrigger             = false;
randomize               = false;
shieldTrials            = 4; % 4
practTrials             = 2; % 20 in reversal muliplied by 2!
useCatchTrials          = true;
haz                     = [.12 1 0]; % .125
oddballProb             = [.25 0];
reversalProb            = [.5 1];
driftConc               = [30 99999999];
safe                    = [3 0];
rewMag                  = 0.1;
practiceTrialCriterion  = 10; % 10
fixCrossLength          = 0.5;
outcomeLength           = 1;
jitter                  = 0.2;
fixedITI                = 0.9;
debug                   = false; %true;
screenNumber            = 1; %2;  % Use 1 if use one screen. Use 2 if you use two screens

% @Sean: add your directory
% Save directory
if isequal(computer, 'Macbook')
    cd('~/Dropbox/AdaptiveLearning/DataDirectory');
elseif isequal(computer, 'Dresden')
    cd(['C:\\Users\\TU-Dresden\\Documents\\MATLAB\\AdaptiveLearning\\DataDirectory']);
elseif isequal(computer, 'Brown')
    cd('C:\Users\lncc\Dropbox\ReversalTask\data');
elseif isequal(computer, 'Lennart')
    cd('/Users/Lenni/Dropbox/AdaptiveLearning/DataDirectory');
elseif isequal(computer, 'Dresden1')
    cd('C:\Users\ma_epsy\Desktop\AdaptiveLearning\DataDirectory');
elseif isequal(computer, 'ARC')
    cd('C:\Users\PsycchLab1\Documents\MATLAB\AdaptiveLearning\Task');
elseif isequal(computer, 'MacMini')
    cd('C:\Users\LSDMlab_RA\Desktop\AdaptiveLearning\Task')
end

% Reset clock
a = clock;
rand('twister', a(6).*10000);

% User Input
% ----------
%@Sean: maybe interesting
% If no user input requested
if askSubjInfo == false
    
    ID = '99999';
    age = '99';
    sex = 'm/w';
    cBal = 1;
    reward = 1;
    
    if strcmp(taskType, 'dresden') || strcmp(taskType, 'chinese') || strcmp(taskType, 'ARC')
        group = '1';
        subject = struct('ID', ID, 'age', age, 'sex', sex, 'group', group, 'cBal', cBal, 'rew', reward, 'date', date, 'session', '1');
    elseif strcmp(taskType, 'oddball')
        session = '1';
        subject = struct('ID', ID, 'age', age, 'sex', sex, 'session', session, 'cBal', cBal, 'rew', reward, 'date', date);
    end
    
    % If user input requested
elseif askSubjInfo == true
    
    if strcmp(taskType, 'dresden')
        prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal:', 'Reward:'};
    elseif strcmp(taskType, 'oddball')
        prompt = {'ID:','Age:', 'Session:', 'Sex:', 'cBal:', 'Reward:'};
    elseif isequal(taskType, 'reversal')
        prompt = {'ID:','Age:', 'Sex:','Reward:'};
    elseif isequal(taskType, 'chinese')
        prompt = {'ID:','Age:', 'Sex:'};
    elseif strcmp(taskType, 'ARC')
        prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal:', 'day:'}; 
    end
    
    name = 'SubjInfo';
    numlines = 1;
    
    % You can choose to randomize input, i.e., random cBal
    if randomize
        
        switch taskType
            
            case 'dresden'
                cBal = num2str(randi(6));
                reward = num2str(randi(2));
            case 'oddball'
                cBal = num2str(randi(2));
                reward = num2str(randi(2));
            case'reversal'
                cBal = nan;
                reward = num2str(randi(2));
            case 'ARC'
                cBal = num2str(randi(4));
                reward = '1';
                testDay = num2str(randi(2));
        end
        
    else
        cBal = '1';
        reward = '1';
        testDay = '1';
    end
    
    % Specify default that is shown on screen
    switch taskType
    
        case 'dresden'
            defaultanswer = {'99999','99', '1', 'm', cBal, reward};
        case 'oddball'
            defaultanswer = {'99999','99', '1', 'm', cBal, reward};
        case 'reversal'
            defaultanswer = {'99999','99', 'm', reward};
        case 'chinese'
            defaultanswer = {'99999','99', 'm', 1};
        case 'ARC'
            defaultanswer = {'99999','99', '1', 'm', cBal, testDay};
    end
    
    % Add information that is not specified by user
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
    switch taskType
        case'dresden' 
            subjInfo{7} = date;
        case'oddball'
            subjInfo{7} = date;
        case 'reversal' 
            subjInfo{5} = date;
        case 'chinese'
            subjInfo{4} = 1; % reward
            subjInfo{5} = '1'; % group
            subjInfo{6} = date;
        case 'ARC' 
            subjInfo{7} = reward;
            subjInfo{8} = date;
    end
    
    % Check if user input makes sense
    % -------------------------------
    % Check ID
    if numel(subjInfo{1}) < 5 ...
            || numel(subjInfo{1}) > 5
        msgbox('ID: must consist of five numbers!');
        return
    end
    
    % Check group and session
    switch taskType 
        case 'dresden'
            if subjInfo{3} ~= '1' && subjInfo{3} ~= '2'
                msgbox('Group: "1" or "2"?');
                return
            end
        case 'oddball'
            if subjInfo{3} ~= '1' && subjInfo{3} ~= '2' && subjInfo{3} ~= '3'
                msgbox('Session: "1", "2" or "3"?');
                return
            end
        case 'ARC'
            if subjInfo{3} ~= '0' && subjInfo{3} ~= '1'
                msgbox('Group: "0" or "1"?');
                return
            end
    end
    
    % Check sex
    if strcmp(taskType, 'dresden') || strcmp(taskType, 'oddball') || strcmp(taskType, 'ARC')
        if subjInfo{4} ~= 'm' && subjInfo{4} ~= 'f'
            msgbox('Sex: "m" or "f"?');
            return
            
        end
    else
        if subjInfo{3} ~= 'm' && subjInfo{3} ~= 'f'
            msgbox('Sex: "m" or "f"?');
            return
            
        end
    end
    
    % Check cBal
    switch taskType 
        case 'dresden'
            if subjInfo{5} ~= '1' && subjInfo{5} ~= '2' && subjInfo{5} ~= '3' && subjInfo{5} ~= '4' && subjInfo{5} ~= '5' && subjInfo{5} ~= '6'
                msgbox('cBal: 1, 2, 3, 4, 5 or 6?');
                return
            end
        case 'oddball'
            if subjInfo{5} ~= '1' && subjInfo{5} ~= '2'
                msgbox('cBal: 1 or 2?');
                return
            end
        case 'ARC'
            if subjInfo{5} ~= '1' && subjInfo{5} ~= '2' && subjInfo{5} ~= '3' && subjInfo{5} ~= '4'
                msgbox('cBal: 1,2,3 or 4?');
                return
            end
    end
    
    % Check reward
    if strcmp(taskType, 'dresden') || strcmp(taskType, 'oddball')
        if subjInfo{6} ~= '1' && subjInfo{6} ~= '2'
            msgbox('Reward: 1 or 2?');
            return
        end
    elseif strcmp(taskType, 'reversal')
        if subjInfo{4} ~= '1' && subjInfo{4} ~= '2'
            msgbox('Reward: 1 or 2?');
            return
        end
    end
    
    % Check test day for ARC
    if strcmp(taskType, 'ARC')
        if subjInfo{6} ~= '1' && subjInfo{6} ~= '2'
            msgbox('Day: 1 or 2?')
            return
        end
    end
    
    % Put all relevant subject info in structure
    % ------------------------------------------
    switch taskType 
        case 'dresden'
            subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(4), 'group', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))), 'rew',...
                str2double(cell2mat(subjInfo(6))), 'date', subjInfo(7), 'session', '1');
        case 'oddball'
        
            subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(4), 'session', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))), 'rew',...
                str2double(cell2mat(subjInfo(6))), 'date', subjInfo(7));
        case 'reversal'
        
            subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(3), 'rew', str2double(cell2mat(subjInfo(4))), 'date',subjInfo(5), 'session', '1', 'cBal', nan);
        case 'chinese'
            subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(3), 'rew', subjInfo(4), 'group', subjInfo(5), 'date',subjInfo(6), 'session', '1', 'cBal', nan);
        case 'ARC'       
            subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(4), 'group', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))),...
                'rew', str2double(cell2mat(subjInfo(7))), 'testDay',str2double(cell2mat(subjInfo(6))), 'date', subjInfo(8), 'session', '1');
            testDay = subject.testDay;  
    end
    
    % For ARC: check if tickmark on or off
    % cbal = 1,2: day1 - tickmark on, day2 - tickmark off
    % cbal = 3,4: day1 - tickmark off, day2 - tickmark on
    cBal = subject.cBal;
    if (isequal(taskType, 'ARC') && cBal == 1 && testDay == 1) || (isequal(taskType, 'ARC') && cBal == 2 && testDay == 1) ||...
            (isequal(taskType, 'ARC') && cBal == 3 && testDay == 2) || (isequal(taskType, 'ARC') && cBal == 4 && testDay == 2)
        showTickmark = true;
    elseif (isequal(taskType, 'ARC') && cBal == 1 && testDay == 2) || (isequal(taskType, 'ARC') && cBal == 2 && testDay == 2) ||...
            (isequal(taskType, 'ARC') && cBal == 3 && testDay == 1) || (isequal(taskType, 'ARC') && cBal == 4 && testDay == 1)
        showTickmark = false;
    end
    
    % Check if ID exists in save folder
    if strcmp(taskType, 'dresden') || strcmp(taskType, 'reversal') || strcmp(taskType, 'chinese')
        checkIdInData = dir(sprintf('*%s*', num2str(cell2mat((subjInfo(1))))));
    elseif strcmp(taskType, 'oddball')
        checkIdInData = dir(sprintf('*%s_session%s*', num2str(cell2mat((subjInfo(1)))), num2str(cell2mat((subjInfo(3))))));
    elseif strcmp(taskType, 'ARC')
        
        if showTickmark
            checkIdInData = dir(sprintf('*%s_TM*', num2str(cell2mat((subjInfo(1))))));
        elseif ~showTickmark
            checkIdInData = dir(sprintf('*%s_NTM*', num2str(cell2mat((subjInfo(1))))));
        end
    end
    
    fileNames = {checkIdInData.name};
    
    if  ~isempty(fileNames)
        if strcmp(taskType, 'dresden')
            msgbox('Diese ID wird bereits verwendet!');
        elseif strcmp(taskType, 'oddball') || strcmp(taskType, 'reversal') || strcmp(taskType, 'chinese') || strcmp(taskType, 'ARC')
            msgbox('ID and day have already been used!');
        end
        return
    end
end

% For oddball: check how many trials should be selected
if isequal(taskType, 'oddball') && isequal(subject.session, '1')
    trials = trialsS1;
elseif isequal(taskType, 'oddball') && isequal(subject.session, '3')
    trials = trialsS2S3;
end

% Deal with psychtoolbox warnings
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'SkipSyncTests', 2);

% Get screen properties
screensize = get(0,'MonitorPositions');
screensize = screensize(screenNumber, :);
screensizePart = screensize(3:4);
zero = screensizePart / 2;
[window.onScreen, windowRect, textures] = OpenWindow(debug, screenNumber);
[window.screenX, window.screenY] = Screen('WindowSize', window.onScreen);
window.centerX = window.screenX * 0.5; % center of screen in X direction
window.centerY = window.screenY * 0.5; % center of screen in Y direction
window.centerXL = floor(mean([0 window.centerX])); % center of left half of screen in X direction
window.centerXR = floor(mean([window.centerX window.screenX])); % center of right half of screen in X direction

% Define variable names
fieldNames = struct('actJitter', 'actJitter', 'block', 'block',...
    'initiationRTs', 'initiationRTs', 'timestampOnset', 'timestampOnset',...
    'timestampPrediction', 'timestampPrediction', 'timestampOffset',...
    'timestampOffset', 'oddBall', 'oddBall', 'oddballProb',...
    'oddballProb', 'driftConc', 'driftConc', 'allASS', 'allASS', 'ID',...
    'ID', 'concentration', 'concentration', 'age', 'age', 'sex', 'sex',...
    'rew', 'rew', 'actRew', 'actRew', 'date','Date', 'cond', 'cond',...
    'trial', 'trial', 'outcome', 'outcome','distMean', 'distMean', 'cp',...
    'cp', 'haz', 'haz', 'TAC', 'TAC', 'shieldType','shieldType',...
    'catchTrial', 'catchTrial', 'triggers', 'triggers', 'pred',...
    'pred','predErr', 'predErr', 'memErr', 'memErr', 'UP', 'UP',...
    'hit', 'hit', 'cBal', 'cBal', 'perf', 'perf', 'accPerf', 'accPerf',...
    'reversalProb', 'reversalProb');

% Set sentence length for text printed on screen
switch computer
    case 'Dresden'
        sentenceLength = 70;
    case 'Brown'
        sentenceLength = 75;
    case 'Lennart'
        sentenceLength = 75;
    otherwise
        sentenceLength = 85;
end     

% Start time for triggers etc.
ref = GetSecs;

% General task parameters
gParam = struct('taskType', taskType , 'blockIndices', blockIndices, 'ref', ref, 'sentenceLength',...
    sentenceLength, 'driftConc', driftConc, 'oddballProb', oddballProb, 'reversalProb', reversalProb,...
    'concentration', concentration, 'haz', haz, 'sendTrigger', sendTrigger, 'computer', computer, 'trials',...
    trials, 'shieldTrials', shieldTrials, 'practTrials', practTrials, ...
    'chinesePractTrials', chinesePractTrials, 'controlTrials', controlTrials,'nPlanets', nPlanets, 'nEnemies',...
    nEnemies, 'safe', safe, 'rewMag', rewMag, 'screensize', screensize, 'planetHaz', planetHaz, 'enemyHaz', enemyHaz,...
    'safePlanet', safePlanet, 'safeEnemy', safeEnemy, 'zero', zero,'window', window, 'windowRect', windowRect,...
    'practiceTrialCriterion', practiceTrialCriterion, 'askSubjInfo', askSubjInfo, 'showTickmark', showTickmark,...
    'useCatchTrials', useCatchTrials, 'screenNumber', screenNumber, 'language', language, 'useTrialConstraints', useTrialConstraints,...
    'nb', nb); 

% Parameters related to the circle
% --------------------------------
predSpotRad         = 10;
shieldAngle         = 30;
outcSize            = 10;
cannonEnd           = 5;
meanPoint           = 1;
rotationRad         = 150;
chineseCannonRad    = 300;
tendencyThreshold   = 15;
predSpotDiam        = predSpotRad * 2;
outcDiam            = outcSize * 2;
spotDiamMean        = meanPoint * 2;
cannonEndDiam       = cannonEnd * 2;
predSpotRect        = [0 0 predSpotDiam predSpotDiam];
outcRect            = [0 0 outcDiam outcDiam];
cannonEndRect       = [0 0 cannonEndDiam cannonEndDiam];
spotRectMean        = [0 0 spotDiamMean spotDiamMean];
boatRect            = [0 0 50 50];
centBoatRect        = CenterRect(boatRect, windowRect);
predCentSpotRect    = CenterRect(predSpotRect, windowRect);
outcCentRect        = CenterRect(outcRect, windowRect);
outcCentSpotRect    = CenterRect(outcRect, windowRect);
cannonEndCent       = CenterRect(cannonEndRect, windowRect);
centSpotRectMean    = CenterRect(spotRectMean,windowRect);
unit                = 2*pi/360;
initialRotAngle     = 0*unit;
rotAngle            = initialRotAngle;

circle = struct('shieldAngle', shieldAngle, 'cannonEndCent', cannonEndCent, 'outcCentSpotRect', outcCentSpotRect,...
    'predSpotRad', predSpotRad, 'outcSize', outcSize, 'meanRad', meanPoint, 'rotationRad', rotationRad,...
    'chineseCannonRad', chineseCannonRad, 'tendencyThreshold', tendencyThreshold, 'predSpotDiam', predSpotDiam, 'outcDiam',...
    outcDiam, 'spotDiamMean', spotDiamMean, 'predSpotRect', predSpotRect, 'outcRect', outcRect, 'spotRectMean',...
    spotRectMean, 'boatRect', boatRect, 'centBoatRect', centBoatRect, 'predCentSpotRect', predCentSpotRect, 'outcCentRect', outcCentRect,...
    'centSpotRectMean', centSpotRectMean, 'unit', unit, 'initialRotAngle', initialRotAngle, 'rotAngle', rotAngle);

% Parameters related to color
% ---------------------------
gold    = [255 215 0];
blue    = [122,96,215];
silver  = [160 160 160];
green   = [169,227,153];
black   = [0 0 0];
colors  = struct('gold', gold, 'blue', blue, 'silver', silver,...
    'green', green, 'black', black);

% Parameters related to keyboard
% ------------------------------
KbName('UnifyKeyNames')
rightKey = KbName('j');
leftKey = KbName('f');
delete = KbName('DELETE');
rightArrow = KbName('RightArrow');
leftArrow = KbName('LeftArrow');
rightSlowKey = KbName('h');
leftSlowKey = KbName('g');
space = KbName('Space');

switch computer
    case 'MacMini'
        enter = 13;
        s = 83;
        t = 84; 
        z = 90;
    case 'Macbook'
        enter = 40;
        s = 22;
        t = 23;
        z = 28;
    case 'Lennart'
        enter = 40;
        s = 22;
        t = 23;
        z = 28;
    case 'Brown'
        enter = 13;
        s = 83;
    case 'ARC'
        enter = 13;
        s = 83;
        t = 84;
        z = 90;     
end

keys = struct('delete', delete, 'rightKey', rightKey, 'rightArrow',...
    rightArrow, 'leftArrow', leftArrow, 'rightSlowKey', rightSlowKey,...
    'leftKey', leftKey, 'leftSlowKey', leftSlowKey, 'space', space,...
    'enter', enter, 's', s, 't', t, 'z', z);

% Parameters related to triggers
% ------------------------------
if sendTrigger == true
    config_io;
end
sampleRate = 500;
port = hex2dec('E050');
triggers = struct('sampleRate', sampleRate, 'port', port);

% Parameters related to timing
% ----------------------------
timingParam = struct('fixCrossLength', fixCrossLength, 'outcomeLength', outcomeLength, 'jitter', jitter, 'fixedITI', fixedITI);

% Start task
% ----------

switch taskType
    case 'dresden'        
        txtPressEnter = 'Weiter mit Enter';
        header = 'Anfang der Studie';    
    case 'oddball'
        header = 'Real Task!';
        txtPressEnter = 'Press Enter to continue';    
    case 'reversal'    
        txtPressEnter = 'Press Enter to continue';    
    case 'chinese'
        txtPressEnter = 'Press Enter to continue';
    case 'ARC'
        txtPressEnter = 'Press Enter to continue';
end

% Put all paramters in structure
% ------------------------------
fTxtPressEnter = 'txtPressEnter';
strings = struct(fTxtPressEnter, txtPressEnter);
taskParam = struct('gParam', gParam, 'circle', circle, 'keys', keys,...
    'fieldNames', fieldNames, 'triggers', triggers, 'timingParam',...
    timingParam,'colors', colors, 'strings', strings, 'textures',...
    textures, 'unitTest', unitTest);

% Condition object initialization
% -------------------------------
cond_init.txtPressEnter = txtPressEnter;
cond_init.runIntro = runIntro;
cond_init.unitTest = unitTest;
cond_init.taskType = taskType;
cond_init.cBal = cBal;
cond_init.concentration = concentration;
cond_init.haz = haz;
cond_init.testDay = testDay;
cond_init.showTickmark = showTickmark;

% Conditions object instance
% --------------------------
cond = al_conditions(cond_init); 

switch taskType

    case 'dresden'

        if subject.cBal == 1

            DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
                header, testDay, cBal, showTickmark);
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataFollowOutcome = cond.FollowOutcomeCondition;
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataFollowCannon = cond.FollowCannonCondition;

        elseif subject.cBal == 2

            DataMain = cond.MainCondition(runIntro, unitTest, taskType,subject, taskParam, haz, concentration, txtPressEnter,...
                header, testDay, cBal, showTickmark);
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataFollowCannon = cond.FollowCannonCondition;
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataFollowOutcome = cond.FollowOutcomeCondition;

        elseif subject.cBal == 3

            DataFollowOutcome = cond.FollowOutcomeCondition;
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
                header, testDay, cBal, showTickmark);
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataFollowCannon = cond.FollowCannonCondition;

        elseif subject.cBal == 4

            DataFollowCannon = cond.FollowCannonCondition;
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
                header, testDay, cBal, showTickmark);
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataFollowOutcome = cond.FollowOutcomeCondition;

        elseif subject.cBal == 5

            DataFollowOutcome = cond.FollowOutcomeCondition;
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataFollowCannon = cond.FollowCannonCondition;
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
                header, testDay, cBal, showTickmark);

        elseif subject.cBal == 6

            DataFollowCannon = cond.FollowCannonCondition;
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataFollowOutcome = cond.FollowOutcomeCondition;
            taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitText);
            DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
                header, testDay, cBal, showTickmark);

        end
    
    case 'oddball'
    
        if subject.cBal == 1
            DataOddball = cond.OddballCondition(runIntro, unitTest, subject,...
                taskParam, txtPressEnter, haz, concentration);
            DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
                header, testDay, cBal, showTickmark);
        elseif subject.cBal == 2
            DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
                header, testDay, cBal, showTickmark);
            DataOddball = cond.OddballCondition(runIntro, unitTest, subject, taskParam, txtPressEnter, haz, concentration);
        end
    
    case 'reversal'
   
        DataReversal = cond.ReversalCondition;
    
    case'chinese'

        cond = cond.ChineseCondition(taskParam, subject);
        DataChineseCued = cond.DataChineseCued;
        DataChineseMain = cond.DataChineseMain;


    case 'ARC'
    
        % Session 1
        subject.session = '1';
        cond = cond.MainCondition(taskParam, subject);
        DataMain = cond.DataMain;
        blockWin(1) = DataMain.accPerf(end);

        % Session 2
        if ~unitTest
            subject.session = '2';
            cond = cond.MainCondition(taskParam, subject);
            DataMain = cond.DataMain;
            blockWin(2) = DataMain.accPerf(end);
        end

         % Control condition
        if ~unitTest && testDay == 1
            cond = cond.ARC_ControlCondition('ARC_controlSpeed', taskParam, subject);
            Data = cond.Data;
        elseif ~unitTest && testDay == 2
            cond.ARC_ControlCondition('ARC_controlAccuracy', taskParam, subject);
        end

        % Control condition
        if ~unitTest && testDay == 1
            cond = cond.ARC_ControlCondition('ARC_controlAccuracy', taskParam, subject);
            Data = cond.Data;
        elseif ~unitTest && testDay == 2
            cond.ARC_ControlCondition('ARC_controlSpeed', taskParam, subject);
        end
end

% Translate performance into monetary reward
% ------------------------------------------
switch taskType
    case 'dresden'
        totWin = DataFollowOutcome.accPerf(end) + DataMain.accPerf(end) + DataFollowCannon.accPerf(end);
    case 'oddball' 
        totWin = DataOddball.accPerf(end) + DataMain.accPerf(end);
    case 'reversal'
        totWin = DataReversal.accPerf(end);
    case 'chinese'
        totWin = DataChineseCued.accPerf(end) + DataChineseMain.accPerf(end);
    case 'ARC'
        totWin = sum(blockWin);
end
        
% Combine data in one structure
% -----------------------------
switch taskType
    case 'dresden'
        Data.DataMain = DataMain;
        Data.DataFollowOutcome = DataFollowOutcome;
        Data.DataFollowCannon = DataFollowCannon;
    case 'oddball'
        Data.DataMain = DataMain;
        Data.DataOddball = DataOddball;
    case 'reversal'
        Data.DataReversal = DataReversal;
end

% End of task
% -----------
al_endTask(taskType, taskParam, textSize, totWin, subject)
ListenChar();
ShowCursor;
Screen('CloseAll');

% Inform user about timing
sprintf('total time: %.1f minutes', str2mat((GetSecs - ref)/60))

end

