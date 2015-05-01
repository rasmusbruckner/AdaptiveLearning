
%% Adaptive Learning Task - EEG
%
% Cannonball is an adaptive learning EEG task battery for investigating
% belief updating in dynamic environments.
%
% The code is optimized for EEG recordings but should be tested on every
% machine.
%
% TODO:
%       - clean code:
%           - replace type with condition but first check whether this
%           works and maybe add deterministic trials for control in second
%           practice
%           - check sigma vola driftConc - what is still used?
%       - task specific
%           - group in output file: when controlling for all the output stuff!
%           - ältere Siezen. Automatisch bei altersgruppencode einbauen
%           - don't mess up oddball task!
%           - in output group is sex. adapt this...
clear all

% indentifies your machine. IF you have internet!
[computer, Computer2] = identifyPC;
%computer = 'Macbook'
%% Set general parameters.

runIntro = true; % Run the intro with practice trials?
askSubjInfo = true; % Do you want some basic demographic subject variables?
oddball = false; % Run oddball or uncertainty version
sendTrigger = false; % Do you want to send triggers?
randomize = true; % Chooses cBal and reward condition automatically
shieldTrials =1; % Trials during the introduction (per condition). Für Pilot: 10
practTrials = 1; % Number of practice trials per condition. Für Pilot: 20
trials = 1;% Number of trials per (sigma-)condition. Für Pilot: 120 // EEG: 240
blockIndices = [1 60 120 180]; % When should new block begin?
vola = [.25 1 0]; % Volatility of the environment.
oddballProb = [.25 0]; % Oddball probability. .15
sigma = [10 12 99999999];  % [10 12 99999999] SD's of distribution.
driftConc = [30 99999999]; % Concentration of the drift. 10
safe = [3 0]; % How many guaranteed trials without change-points.
rewMag = 0.2; % Reward magnitude.
jitter = 0.2; % Set jitter.
catchTrialCriterion = 10;
test = false; % Test triggering timing accuracy (see PTB output CW).
debug = false; % Debug mode.

% currently not in use:
runVola = false; % Do you want to run different volatility conditions?
runSigma = false; % Do you want to run different sigma conditions?
catchTrials = false;
PE_Bar = false; % Use a prediction error bar?
contTrials = 1; % Number of control trials. Für Pilot: 60 EEG: 80
practContTrials = 1;
% Computer2 = false;

% Check number of trials in each condition
if (practTrials > 1 && mod(practTrials, 2) == 1) || (trials > 1 && mod(trials, 2)) == 1 || (practContTrials > 1 && mod(practContTrials, 2) == 1) || (contTrials > 1 && mod(contTrials, 2) == 1)
    msgbox('All trials must be even or equal to 1!');
    break
end

% Savedirectory
if isequal(computer, 'Macbook')
    savdir = '/Users/Bruckner/Documents/MATLAB/AdaptiveLearning/DataDirectory';
elseif isequal(computer, 'Dresden')
    savdir = 'C:\\Users\\TU-Dresden\\Documents\\MATLAB\\AdaptiveLearning\\DataDirectory';
elseif isequal(computer, 'D_Pilot') && Computer2 == false
    savdir = '/Users/lifelabtudresden/Documents/MATLAB/AdaptiveLearning/DataDirectory';
elseif isequal(computer, 'D_Pilot') && Computer2 == true
    savdir = '/Users/TUDresden/Documents/MATLAB/AdaptiveLearning/DataDirectory';
elseif isequal(computer, 'Dresden_Rene')
    savdir = 'F:\\dokumente\\MATLAB\\adaptive_learning\\DataDirectory';
elseif isequal(computer, 'Matt')
    savdir = 'F:\\dokumente\\MATLAB\\adaptive_learning\\DataDirectory';
elseif isequal(computer, 'Brown')
    savdir = 'C:\Users\lncc\Dropbox\HeliEEG';
end

%% User Input

fID = 'ID';
fAge = 'age';
fGroup = 'group';
fSex = 'sex';
fCBal = 'cBal';
fRew = 'rew';
fDate = 'Date';

if askSubjInfo == false
    ID = '999';
    age = '99';
    group = '1';
    sex = 'm/w';
    cBal = 1;
    reward = 1;
    Subject = struct(fID, ID, fAge, age, fSex, sex, fCBal, cBal, fRew, reward, fDate, date);
elseif askSubjInfo == true
    prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal', 'Reward'};
    name = 'SubjInfo';
    numlines = 1;
    
    if randomize
        cBal = num2str(round(unifrnd(1,2)));
        reward = num2str(round(unifrnd(1,2)));
        defaultanswer = {'9999','99', '1', 'm', cBal, reward};
    else
        defaultanswer = {'9999','99', '1', 'm', '1', '1'};
    end
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
    subjInfo{7} = date;
    
    % Make sure you made no mistake
    if numel(subjInfo{1}) < 4 || numel(subjInfo{1}) >4
        msgbox('ID: consists of four numbers!');
        return
    end
    
    if subjInfo{3} ~= '1' && subjInfo{3} ~= '2'
        msgbox('Group: "1" or "2"?');
        return
    end
    
    if subjInfo{4} ~= 'm' && subjInfo{4} ~= 'f'
        msgbox('Sex: "m" or "f"?');
        return
    end
    
    if subjInfo{5} ~= '1' && subjInfo{5} ~= '2'
        msgbox('cBal: 1 or 2?');
        return
    end
    
    if subjInfo{6} ~= '1' && subjInfo{6} ~= '2'
        msgbox('Reward: 1 or 2?');
        return
    end
    
    % Tranlate reward code in letter
    if subjInfo{6} == '1'
        rewName = 'B';
    elseif subjInfo{6} == '2'
        rewName = 'G';
    end
    
    % Filenames
    fName = sprintf('ADL_%s_%s.mat', rewName ,num2str(cell2mat((subjInfo(1)))));
    fNameDataOddball = sprintf('DataOddball_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataCP = sprintf('DataCP_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControl = sprintf('DataControl_%s', num2str(cell2mat((subjInfo(1)))));
    
    % Struct with demographic subject variables
    Subject = struct(fID, subjInfo(1), fAge, subjInfo(2), fSex,...
        subjInfo(3), fGroup, subjInfo(4), fCBal, str2double(cell2mat(subjInfo(5))), fRew,...
        str2double(cell2mat(subjInfo(6))), fDate, subjInfo(7));
    
    % Make sure that no ID is used twice
    if exist(fName, 'file') == 2
        msgbox('Diese ID wird bereits verwendet!');
        return
    end
end

%% Open window

% Prevent input
ListenChar(2);
%HideCursor;

% Suppress warnings
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'SkipSyncTests', 2);

% Open a new window
fScreensize = 'screensize'; screensize = get(0,'MonitorPositions');
screensizePart = (screensize(3:4));
fZero = 'zero'; zero = screensizePart / 2;
fWindow = 'window';
fWindowRect = 'windowRect';
if debug == true
    [ window, windowRect ] = Screen('OpenWindow', 0, [40 40 40], [420 250 1020 650]);
else
    [ window, windowRect ] = Screen('OpenWindow', 0, [40 40 40], []);
end

% Fieldnames
fID = 'ID'; ID = fID; % ID
fAge = 'age'; age = fAge; % Age
fSex = 'sex'; sex = fSex; % Sex
fRew = 'rew'; rew = fRew; %Rew
fActRew = 'actRew'; actRew = fActRew; % Actual Reward
fVolas = 'vola'; volas = fVolas; % Volatility
fOddball = 'oddball';
fOddballProb = 'oddballProb'; oddballProbs = fOddballProb;
fDriftConc = 'driftConc'; driftConcentrations = fDriftConc;
fSigmas = 'sigma'; sigmas = fSigmas; % Sigma
fOddBall = 'oddBall'; oddBall = fOddBall;
fDate = 'Date'; Date = fDate; % Date
fCond = 'cond'; cond = fCond; % Condition
fTrial = 'trial'; trial = fTrial; % Trial
fOutcome = 'outcome'; outcome = fOutcome; % Outcome
fAllASS = 'allASS'; allASS = fAllASS;
fDistMean = 'distMean'; distMean = fDistMean; % Distribution mean
fCp = 'cp'; cp = fCp; % Change point
fTAC = 'TAC'; TAC = fTAC; % Trials after change-point
fBoatType = 'boatType'; boatType = fBoatType; % Boat type
fCatchTrial = 'catchTrial'; catchTrial = fCatchTrial; % Catch trial
fPredT = 'predT'; predT = fPredT; % Trigger: prediction
fOutT = 'outT'; outT = fOutT; % Trigger: outcome
fTriggers = 'triggers'; triggers = fTriggers; % Trigger: boat
fPred = 'pred';pred = fPred; % Prediction of participant
fPredErr = 'predErr'; predErr = fPredErr; % Prediction error
fPredErrNorm = 'predErrNorm'; predErrNorm = fPredErrNorm;% Regular prediction error
fPredErrPlus = 'predErrPlus'; predErrPlus = fPredErrPlus; %Prediction error plus 360 degrees
fPredErrMin = 'predErrMin'; predErrMin = fPredErrMin; % Prediction error minus 360 degrees
fRawPredErr = 'rawPredErr'; rawPredErr = fRawPredErr;
fMemErr = 'memErr'; memErr = fMemErr;% Memory error
fMemErrNorm = 'memErrNorm'; memErrNorm = fMemErrNorm;% Regular memory error
fMemErrPlus = 'memErrPlus'; memErrPlus = fMemErrPlus; % Memory error plus 360 degrees
fMemErrMin = 'memErrMin'; memErrMin = fMemErrMin; % Memory error minus 360 degrees
fUP = 'UP'; UP = fUP; % Update of participant
fUPNorm = 'UPNorm'; UPNorm = fUPNorm;% Regular prediction error
fUPPlus = 'UPPlus'; UPPlus = fUPPlus; %Prediction error plus 360 degrees
fUPMin = 'UPMin'; UPMin = fUPMin;
fHit = 'hit'; hit = fHit; % Hit
fCBal = 'cBal'; cBal = fCBal; % Counterbalancing
fPerf = 'perf'; perf = fPerf; % Performance
fAccPerf = 'accPerf'; accPerf = fAccPerf; % Accumulated performance

fFieldNames = 'fieldNames';
fieldNames = struct('actJitter', 'actJitter', 'block', 'block',...
    'initiationRTs', 'initiationRTs','timestampOnset', 'timestampOnset',...
    'timestampPrediction', 'timestampPrediction', 'timestampOffset',...
    'timestampOffset', fOddBall, oddBall, fOddball, oddball, fOddballProb,...
    oddballProbs, fDriftConc, driftConcentrations, fAllASS, allASS, fID, ID,...
    fSigmas, sigmas, fAge, age, fSex, sex, fRew, rew, fActRew, actRew, fDate,...
    Date, fCond, cond, fTrial, trial, fOutcome, outcome, fDistMean, distMean, fCp, cp,...
    fVolas, volas, fTAC, TAC, fBoatType, boatType, fCatchTrial, catchTrial,...
    fPredT, predT, fOutT, outT, fTriggers, triggers, fPred, pred, fPredErr,...
    predErr, fPredErrNorm, predErrNorm, fPredErrPlus, predErrPlus,...
    fPredErrMin, predErrMin, fMemErr, memErr, fMemErrNorm, memErrNorm,...
    fMemErrPlus, memErrPlus,fMemErrMin, memErrMin, fUP, UP, fUPNorm,...
    UPNorm, fUPPlus, UPPlus, fUPMin, UPMin, fHit, hit, fCBal, cBal,...
    fPerf, perf, fAccPerf, accPerf, fRawPredErr, rawPredErr);

fOddball = 'oddball';
fGParam = 'gParam';
fRunVola = 'runVola';
fRunSigma = 'runSigma';
fPE_Bar = 'PE_Bar';
fSendTrigger = 'sendTrigger';
fDriftConc = 'driftConc';
fOddballProb = 'oddballProb';
fComputer = 'computer';
fTrials = 'trials';
fPractContTrials = 'practContTrials';
fShieldTrials = 'shieldTrials';
fPractTrials = 'practTrials';
fContTrials = 'contTrials';
fSafe = 'safe';
fRewMag = 'rewMag';
fSentenceLength = 'sentenceLength';
if isequal(computer, 'Dresden')
    sentenceLength = 55;
elseif isequal(computer, 'Brown')
    sentenceLength = 75;
else
    sentenceLength = 85;
end
ref = GetSecs;
gParam = struct('jitter', jitter, 'blockIndices', blockIndices,...
    'ref', ref, fSentenceLength, sentenceLength, fOddball, oddball,...
    fDriftConc, driftConc, fOddballProb, oddballProb, fSigmas, sigma,...
    fVolas, vola, fRunVola, runVola, fRunSigma, runSigma, fPE_Bar,...
    PE_Bar, fSendTrigger, sendTrigger, fComputer, computer, fTrials,...
    trials, fPractContTrials, practContTrials, fShieldTrials,...
    shieldTrials, fPractTrials, practTrials, fContTrials, contTrials,...
    fSafe, safe, fRewMag, rewMag, fScreensize, screensize, fZero, zero,...
    fWindow, window, fWindowRect, windowRect, 'catchTrialCriterion',...
    catchTrialCriterion);

%% Circle parameters

%Radius of the spots
fPredSpotRad =  'predSpotRad'; predSpotRad = 10; % Prediction spot (red). This is expressed in pixel, not in degrees! it used to be 25
fOutcSpotRad = 'outcSpotRad'; outcSpotRad = 10; % Prediction spot (red). This is expressed in pixel, not in degrees!
fShieldAngle = 'shieldAngle'; shieldAngle = 30; %Shield Angle.
fOutcSize = 'outcSize'; outcSize = 10; % Black bar. Number must be equal.This is expressed in pixel, not in degrees!
fCannonEnd = 'cannonEnd'; cannonEnd = 5; %This is in pixel, not in degrees!
fMeanPoint = 'meanRad'; meanPoint = 1; % Point for radar needle. This is expressed in pixel, not in degrees!
fRotationRad = 'rotationRad'; rotationRad = 150; % Rotation Radius. This is expressed in pixel, not in degrees!

%Diameter of the spots
fPredSpotDiam = 'predSpotDiam'; predSpotDiam = predSpotRad * 2; % Diameter of prediction spot
fOutcSpotDiam = 'outcDiam'; outcDiam = outcSize * 2; % Diameter of outcome
fSpotDiamMean = 'spotDiamMean'; spotDiamMean = meanPoint * 2; % Size of Radar needle
fCannonEndDiam = 'cannonEndDiam'; cannonEndDiam = cannonEnd * 2;

%Position of the spots and the boats
fPredSpotRect = 'predSpotRect'; predSpotRect = [0 0 predSpotDiam predSpotDiam]; % Prediction spot position
fOuctcRect = 'outcRect'; outcRect = [0 0 outcDiam outcDiam]; % Outcome position
fCannonEndRect = 'cannonEndRect'; cannonEndRect = [0 0 cannonEndDiam cannonEndDiam];
fSpotRectMean = 'spotRectMean'; spotRectMean =[0 0 spotDiamMean spotDiamMean]; % Radar needle position
fBoatRect = 'boatRect'; boatRect = [0 0 50 50]; % Boat position

% Center the objects
fCentBoatRect = 'centBoatRect'; centBoatRect = CenterRect(boatRect, windowRect); % Center boat
fPredCentSpotRect = 'predCentSpotRect'; predCentSpotRect = CenterRect(predSpotRect, windowRect);% Center the prediction spot
fOutcCentRect = 'outcCentRect'; outcCentRect = CenterRect(outcRect, windowRect); % Center the outcome
fOutcCentSpotRect = 'outcCentSpotRect'; outcCentSpotRect = CenterRect(outcRect, windowRect); % Center the outcome
fCannonEndCent = 'cannonEndCent'; cannonEndCent = CenterRect(cannonEndRect, windowRect);
fCentSpotRectMean = 'centSpotRectMean'; centSpotRectMean = CenterRect(spotRectMean,windowRect); % Center radar needle

% Rotation angle of prediction spot
fUnit = 'unit'; unit = 2*pi/360; % This expresses the circle (2*pi) as a fraction of 360 degrees
fInitialRotAngle = 'initialRotAngle'; initialRotAngle = 0*unit; % The initial rotation angle (on top of circle)
fRotAngle = 'rotAngle'; rotAngle = initialRotAngle; % Rotation angle when prediction spot is moved

% Circle parameters
fCircle = 'circle';
circle = struct(fShieldAngle, shieldAngle, fCannonEndCent,...
    cannonEndCent, fOutcCentSpotRect, outcCentSpotRect, fPredSpotRad,...
    predSpotRad, fOutcSize, outcSize, fMeanPoint, meanPoint, fRotationRad,...
    rotationRad, fPredSpotDiam, predSpotDiam, fOutcSpotDiam,...
    outcDiam, fSpotDiamMean, spotDiamMean, fPredSpotRect, predSpotRect,...
    fOuctcRect, outcRect, fSpotRectMean, spotRectMean,...
    fBoatRect, boatRect, fCentBoatRect, centBoatRect, fPredCentSpotRect,...
    predCentSpotRect, fOutcCentRect, outcCentRect, fCentSpotRectMean,...
    centSpotRectMean, fUnit, unit, fInitialRotAngle, initialRotAngle, fRotAngle, rotAngle);

% Boat colors
fGold = 'gold'; gold = [255 215 0];
fSilver = 'silver'; silver = [160 160 160];
fColors = 'colors';
colors = struct(fGold, gold, fSilver, silver);

% Set key names
KbName('UnifyKeyNames')
fRightKey = 'rightKey'; rightKey = KbName('j');
fLeftKey = 'leftKey'; leftKey = KbName('f');
fDelete = 'delete'; delete = KbName('DELETE');
fRightArrow = 'rightArrow'; rightArrow = KbName('RightArrow');
fLeftArrow = 'leftArrow'; leftArrow = KbName('LeftArrow');
fRightSlowKey = 'rightSlowKey'; rightSlowKey = KbName('h');
fLeftSlowKey = 'leftSlowKey'; leftSlowKey = KbName('g');
fSpace = 'space'; space = KbName('Space');
fEnter = 'enter';
fS = 's';

if isequal(computer, 'Macbook')
    enter = 40;
    s = 22;
elseif isequal(computer, 'Dresden')
    enter = 13;
    s = 83;
elseif isequal(computer, 'D_Pilot')
    enter = 40;
    s = 22;
elseif isequal(computer, 'Dresden_Rene')
    enter = 13;
    s = 32;
elseif isequal(computer, 'Brown')
    enter = 13;
    s = 83;
end

fKeys = 'keys';
keys = struct(fDelete, delete, fRightKey, rightKey, fRightArrow, rightArrow, fLeftArrow, leftArrow, fRightSlowKey, rightSlowKey, fLeftKey, leftKey, fLeftSlowKey, leftSlowKey, fSpace, space, fEnter, enter, fS, s);

imageRect = [0 0 120 120];
dstRect = CenterRect(imageRect, windowRect);
[cannonPic, ~, alpha]  = imread('cannon.png');
cannonPic(:,:,4) = alpha(:,:);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
cannonTxt = Screen('MakeTexture', window, cannonPic);
fCannonTxt = 'cannonTxt';
fDstRect = 'dstRect';

imageRect = [0 0 120 120];
dstRect = CenterRect(imageRect, windowRect);
[aimPic, ~, alpha]  = imread('arrow.png');
aimPic(:,:,4) = alpha(:,:);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
aimTxt = Screen('MakeTexture', window, aimPic);
fAimTxt = 'aimTxt';
fDstRect = 'dstRect';

%% Trigger settings

% should be adapted to current triggers settings!
if sendTrigger == true
    config_io;             % IS THIS STILL NECESSARY?
end

fSampleRate = 'sampleRate'; sampleRate = 512; % Sample rate.
%fPort = 'port'; port = 53328; % LPT port (Dresden)
%LPT1address = hex2dec('E050'); %standard location of LPT1 port % copied from heliEEG_main
fPort = 'port'; port = hex2dec('E050'); % LPT port
fStartTrigger = 'startTrigger'; startTrigger = 7; % Start of the task.
fTrialOnset = 'trialOnsetTrigger'; trialOnsetTrigger = 1; % Trial onset.
fPredTrigger = 'predTrigger'; predTrigger = 2; % Prediction.
fBaseline1Trigger = 'baseline1Trigger'; baseline1Trigger = 3; % Baseline.
fOutcomeTrigger = 'outcomeTrigger'; outcomeTrigger = 4; % Outcome.
fBaseline2Trigger = 'baseline2Trigger'; baseline2Trigger = 5; % Baseline.
fBoatTrigger = 'boatTrigger'; boatTrigger = 6; % Boat type.
fBaseline3Trigger = 'baseline3Trigger'; baseline3Trigger = 9; % Baseline.
fBlockLVTrigger = 'blockLVTrigger'; blockLVTrigger = 10; % Block with low sigma.
fBlockHVTrigger = 'blockHVTrigger'; blockHVTrigger = 11; % Block with high sigma.
fBlockControlTrigger = 'blockControlTrigger'; blockControlTrigger = 12; % Control block.

fTriggers = 'triggers';
triggers = struct(fSampleRate, sampleRate, fPort, port, fStartTrigger,...
    startTrigger, fTrialOnset, trialOnsetTrigger, fPredTrigger,...
    predTrigger, fBaseline1Trigger, baseline1Trigger, fOutcomeTrigger,...
    outcomeTrigger, fBaseline2Trigger, baseline2Trigger,...
    fBoatTrigger, boatTrigger, fBaseline3Trigger, baseline3Trigger,...
    fBlockLVTrigger, blockLVTrigger, fBlockHVTrigger, blockHVTrigger,...
    fBlockControlTrigger, blockControlTrigger);

IndicateOddball = 'Oddball Task';
IndicateCP = 'Change Point Task';
IndicateControl = 'Control Task';
fTxtLowVola = 'txtLowVola'; txtLowVola = 'Jetzt verändert sich das Ziel der Kanone selten';
fTxtHighVola = 'txtHighVola'; txtHighVola = 'Jetzt verändert sich das Ziel der Kanone häufiger';
fTxtPressEnter = 'txtPressEnter';

if oddball
    txtPressEnter = 'Delete to go back - Enter to continue';
else
    txtPressEnter = 'Zurück mit Löschen - Weiter mit Enter';
end

fTxtLVLS = 'txtLVLS'; txtLVLS = 'Jetzt fahren die Schiffe selten weiter\n\nund der Seegang ist schwach';
fTxtHVLS = 'txtHVLS'; txtHVLS = 'Jetzt fahren die Schiffe häufiger weiter\n\nund der Seegang ist schwach';
fTxtLVHS = 'txtLVHS'; txtLVHS = 'Jetzt fahren die Schiffe selten weiter\n\nund der Seegang ist stark';
fTxtHVHS = 'txtHVHS'; txtHVHS = 'Jetzt fahren die Schiffe häufiger weiter\n\nund der Seegang ist stark';

fStrings = 'strings';
strings = struct(fTxtLowVola, txtLowVola, fTxtHighVola, txtHighVola,...
    fTxtLVLS, txtLVLS, fTxtHVLS, txtHVLS, fTxtLVHS, txtLVHS, fTxtHVHS,...
    txtHVHS, fTxtPressEnter, txtPressEnter);
taskParam = struct(fGParam, gParam, fCircle, circle, fKeys, keys,...
    fFieldNames, fieldNames, fTriggers, triggers,...
    fColors, colors, fStrings, strings, fCannonTxt, cannonTxt, fAimTxt,...
    aimTxt, fDstRect, dstRect);

% If true you run through one main block which enables you to check timing
% accuracy (see PTB output in command window)
if test == true
    
    [taskDataLV, DataLV] = Main(taskParam, vola(1), 'main', Subject);
    
%     ListenChar();
%     ShowCursor;
%     Screen('CloseAll');
    
elseif ~test
    
    if runIntro == true
        if oddball
            if Subject.cBal == 1
                Instructions(taskParam, 'Oddball', Subject);
                condition = 'practiceOddball';
                [taskDataOddballPractice, DataOddballPracticeLV] = Main(taskParam, vola(3), sigma(1), condition, Subject);
            elseif Subject.cBal == 2
                Instructions(taskParam, 'Main', Subject);
                condition = 'practice';
                [taskDataOddballPractice, DataOddballPracticeLV] = Main(taskParam, vola(3), sigma(1), condition, Subject);
            end
        else
            if Subject.cBal == 1
                Instructions(taskParam, 'Practice', Subject);
                condition = 'practiceCont';
                [taskDataControlPractice, DataControlPracticeLV] = Main(taskParam, vola(3), sigma(1), condition, Subject);
            elseif Subject.cBal == 2
                Instructions(taskParam, 'PracticeCont', Subject);
                condition = 'practiceCont';
                [taskDataControlPractice, DataControlPracticeLV] = Main(taskParam, vola(3), sigma(1), condition, Subject);
            end
        end
        if taskParam.gParam.oddball == false
            header = 'Anfang der Studie';
            if Subject.cBal == 1
                txt = ['Du hast die Übungsphase abgeschlossen. Kurz '...
                    'zusammengefasst fängst du also die meisten '...
                    'Kugeln, wenn du den orangenen Punkt auf die Stelle bewegst, auf die '...
                    'die Kanone zielt. Weil du die Kanone nicht mehr sehen kannst, musst du diese Stelle aufgrund der Position der letzten Kugeln einschätzen. Das Geld für die gefangenen '...
                    'Kugeln bekommst du nach der Studie '...
                    'ausgezahlt.\n\nViel Erfolg!'];
            elseif Subject.cBal == 2
                txt = ['Du hast die Übungsphase abgeschlossen. Kurz zusammengefasst ist es deine '...
                    'Aufgabe Kanonenkugeln aufzusammeln, indem du deinen orangenen Punkt zur Stelle der letzten Kanonenkugel steuerst, welche mit dem schwarzen Strich markiert ist. '...
                    'Das Geld für die gesammelten '...
                    'Kugeln bekommst du nach der Studie '...
                    'ausgezahlt.\n\nViel Erfolg!'];
            end
            
        elseif taskParam.gParam.oddball == true
            header = 'Real Task!';
            if Subject.cBal == 1
                txt = ['This is the beginning of the real task. During '...
                    'this block you will earn real money for your performance. '...
                    'The trials will be exactly the same as those in the '...
                    'previous practice block. On each trial a cannon will aim '...
                    'at a location on the circle. On most trials the cannon will '...
                    'fire a ball somewhere near the point of aim. '...
                    'However, on a few trials a ball will be shot from a different '...
                    'cannon that is equally likely to hit any location on the circle. Like in the previous '...
                    'block you will not see the cannon, but still have to infer its '...
                    'aim in order to catch balls and earn money.'];
            elseif Subject.cBal == 2
                txt = ['This is the beginning of the real task. During '...
                    'this block you will earn real money for your performance. '...
                    'The trials will be exactly the same as those in the '...
                    'previous practice block. On each trial a cannon will aim '...
                    'at a location on the circle. On all trials the cannon will '...
                    'fire a ball somewhere near the point of aim. '...
                    'Most of the time the cannon will remain aimed at the same location, '...
                    'but occasionally the cannon will be reaimed. Like in the previous '...
                    'block you will not see the cannon, but still have to infer its '...
                    'aim in order to catch balls and earn money.'];
            end
        end
        feedback = false;
        BigScreen(taskParam, txtPressEnter, header, txt, feedback);
    else
        Screen('TextSize', taskParam.gParam.window, 30);
        Screen('TextFont', taskParam.gParam.window, 'Arial');
        if (oddball && Subject.cBal == 1)
            VolaIndication(taskParam, IndicateOddball, txtPressEnter)
        elseif (~oddball && Subject.cBal == 2)
            VolaIndication(taskParam, IndicateControl, txtPressEnter)
        elseif oddball && Subject.cBal == 2 || (~oddball && Subject.cBal == 1)
            VolaIndication(taskParam, IndicateCP, txtPressEnter)
        end
    end
    
    %% first block
    
    if Subject.cBal == 1
        if oddball
            condition = 'oddball';
            type = 'Oddball';
        else
            condition = 'main';
        end
        [taskDataCP, DataCP] = Main(taskParam, vola(1), sigma(1), condition, Subject);
        DataCP = catstruct(Subject, DataCP);
        assignin('base',['DataCP_' num2str(cell2mat((subjInfo(1))))],DataCP)
        save(fullfile(savdir,fName),fNameDataCP);
    elseif Subject.cBal == 2;
        if oddball
            condition = 'main';
            type = 'Main';
        else
            condition = 'control';
        end
        [taskDataControl, DataControl] = Main(taskParam, vola(1), sigma(1), condition, Subject);
        DataControl = catstruct(Subject, DataControl);
        assignin('base',['DataControl_' num2str(cell2mat((subjInfo(1))))],DataControl)
        save(fullfile(savdir,fName),fNameDataControl);
    end
    
    %% second intro
    
    if runIntro == true
        if (oddball == true && Subject.cBal == 1) || (oddball == false && Subject.cBal == 2)
            Instructions(taskParam, 'Practice', Subject);
        elseif oddball == true && Subject.cBal == 2
            Instructions(taskParam, 'Oddball', Subject);
        elseif oddball == false && Subject.cBal == 1
            Instructions(taskParam, 'PracticeCont', Subject)
        end
        condition = 'practice';
        [taskDataPracticeMain, DataPracticeMain] = Main(taskParam, vola(3), sigma(1), condition, Subject);
        header = 'Real Task!';
        if taskParam.gParam.oddball == false
            header = 'Anfang der Studie';
            if Subject.cBal == 1
                txt = ['Du hast die Übungsphase abgeschlossen. Kurz '...
                    'zusammengefasst fängst du also die meisten '...
                    'Kugeln, wenn du den orangenen Punkt auf die Stelle bewegst, auf die '...
                    'die Kanone zielt. Weil du die Kanone nicht mehr sehen kannst, musst du diese Stelle aufgrund der Position der letzten Kugeln einschätzen. Das Geld für die gefangenen '...
                    'Kugeln bekommst du nach der Studie '...
                    'ausgezahlt.\n\nViel Erfolg!'];
            elseif Subject.cBal == 2
                txt = ['Du hast die Übungsphase abgeschlossen. Kurz zusammengefasst ist es deine '...
                    'Aufgabe Kanonenkugeln aufzusammeln, indem du deinen orangenen Punkt zur Stelle der letzten Kanonenkugel steuerst, welche mit dem schwarzen Strich markiert ist. '...
                    'Das Geld für die gesammelten '...
                    'Kugeln bekommst du nach der Studie '...
                    'ausgezahlt.\n\nViel Erfolg!'];
            end
            
        elseif taskParam.gParam.oddball == true
            if Subject.cBal == 1
                txt = ['This is the beginning of the real task. During '...
                    'this block you will earn real money for your performance. '...
                    'The trials will be exactly the same as those in the '...
                    'previous practice block. On each trial a cannon will aim '...
                    'at a location on the circle. On all trials the cannon will '...
                    'fire a ball somewhere near the point of aim. '...
                    'Most of the time the cannon will remain aimed at the same location, '...
                    'but occasionally the cannon will be reaimed. Like in the previous '...
                    'block you will not see the cannon, but still have to infer its '...
                    'aim in order to catch balls and earn money.'];
            elseif Subject.cBal == 2
                txt = ['This is the beginning of the real task. During '...
                    'this block you will earn real money for your performance. '...
                    'The trials will be exactly the same as those in the '...
                    'previous practice block. On each trial a cannon will aim '...
                    'at a location on the circle. On most trials the cannon will '...
                    'fire a ball somewhere near the point of aim. '...
                    'However, on a few trials a ball will be shot from a different '...
                    'cannon that is equally likely to hit any location on the circle. Like in the previous '...
                    'block you will not see the cannon, but still have to infer its '...
                    'aim in order to catch balls and earn money.'];
            end
        end
        feedback = false;
        BigScreen(taskParam, txtPressEnter, header, txt, feedback);
    else
        if (oddball && Subject.cBal == 1) || (~oddball && Subject.cBal == 2)
            VolaIndication(taskParam, IndicateCP, txtPressEnter)
        elseif oddball && Subject.cBal == 2
            VolaIndication(taskParam, IndicateOddball, txtPressEnter)
        elseif (~oddball && Subject.cBal == 1)
            VolaIndication(taskParam, IndicateControl, txtPressEnter)
        end
    end
    WaitSecs(0.1);
    
    %% second block
    
    if Subject.cBal == 1
        if oddball
            condition = 'main';
        else
            condition = 'control';
        end
        [taskDataControl, DataControl] = Main(taskParam, vola(1), sigma(1), condition, Subject);
        DataControl = catstruct(Subject, DataControl);
        assignin('base',['DataControl_' num2str(cell2mat((subjInfo(1))))],DataControl)
        save(fullfile(savdir,fName),fNameDataCP, fNameDataControl);
        
    elseif Subject.cBal == 2
        if oddball
            condition = 'oddball';
        else
            
            condition = 'main';
            [taskDataCP, DataCP] = Main(taskParam, vola(1), sigma(1), condition, Subject);
            DataCP = catstruct(Subject, DataCP);
            assignin('base',['DataCP_' num2str(cell2mat((subjInfo(1))))],DataCP)
            save(fullfile(savdir,fName),fNameDataCP, fNameDataControl);
        end
    end
    WaitSecs(0.1);
    
    % Compute total gain
    if oddball
        totWin = DataOddball.accPerf(end) + DataCP.accPerf(end);
    else
        totWin = DataControl.accPerf(end) + DataCP.accPerf(end);
    end
    
    while 1
        
        if oddball
            header = 'End of task!';
            txt = sprintf('Thank you for participating\n\n\nYou earned $ %.2f', totWin);
        else
            header = 'Ende der Aufgabe!';
            txt = sprintf('Vielen Dank für deine Teilnahme\n\n\nDu hast %.2f Euro verdient', totWin);
        end
        Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0, taskParam.gParam.screensize(4)*0.16, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.16, 5);
        Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0, taskParam.gParam.screensize(4)*0.8, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.8, 5);
        Screen('FillRect', taskParam.gParam.window, [0 25 51], [0, (taskParam.gParam.screensize(4)*0.16)+3, taskParam.gParam.screensize(3), (taskParam.gParam.screensize(4)*0.8)-2]);
        Screen('TextSize', taskParam.gParam.window, 50);
        DrawFormattedText(taskParam.gParam.window, header, 'center', taskParam.gParam.screensize(4)*0.1);
        Screen('TextSize', taskParam.gParam.window, 30);
        DrawFormattedText(taskParam.gParam.window, txt, 'center', 'center');
        Screen('DrawingFinished', taskParam.gParam.window, [], []);
        time = GetSecs;
        Screen('Flip', taskParam.gParam.window, time + 0.1);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if find(keyCode) == taskParam.keys.s
            break
        end
    end
end

%% End of task

ListenChar();
ShowCursor;
Screen('CloseAll');

