
%% Adaptive Learning Task - EEG
%
% Cannonball is an adaptive learning EEG task battery for investigating
% belief updating in dynamical environments.
%
% There are three tasks: Change-Point Task
%                        Oddball Task
%                        Change-Point Control Task that requires LR = 1
%
% The function GenerateOutcomes generates outcomes that are centered
% around the mean of a normal distribution (distMean) with
% a cetain amount of variability.
%
% The code is optimized for EEG recordings but should be tested on every
% machine.

% TODO:
%       
%       - Reward has to be calculated
%       - oddBall versus control
%       - check sigma vola driftConc - what is still used?
% store shieldSize
% daten generieren ohne aufgabe zu machen


clear all

% indentifies your machine
[computer, Computer2] = identifyPC;

%% Set general parameters.

runIntro = true; % Run the intro with practice trials?
askSubjInfo = true; % Do you want some basic demographic subject variables?
oddball = true; % Run oddball or perceptual version
sendTrigger = false; % Do you want to send triggers?
shieldTrials = 1; % Trials during the introduction (per condition). Für Pilot: 10
practTrials = 10; % Number of practice trials per condition. Für Pilot: 20
trials = 10;% Number of trials per (sigma-)condition. Für Pilot: 120 // EEG: 150
vola = [.25 .7 0]; % Volatility of the environment.
oddballProb = [.25 0]; % Oddball probability. .15
sigma = [10 12 99999999];  % [10 12 99999999] SD's of distribution.
driftConc = [30 99999999]; % Concentration of the drift. 10
safe = 3; % How many guaranteed trials without change-points.
rewMag = 0.2; % Reward magnitude.
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

% Check number of trials in each condition.
if (practTrials > 1 && mod(practTrials, 2) == 1) || (trials > 1 && mod(trials, 2)) == 1 || (practContTrials > 1 && mod(practContTrials, 2) == 1) || (contTrials > 1 && mod(contTrials, 2) == 1)
    msgbox('All trials must be even or equal to 1!');
    break
end

% Savedirectory.
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

%% User Input.

fID = 'ID';
fAge = 'age';
fSex = 'sex';
fCBal = 'cBal';
fRew = 'rew';
fDate = 'Date';

if askSubjInfo == false
    ID = '999';
    age = '999';
    sex = 'm/w';
    cBal = 1;
    reward = '1';
    Subject = struct(fID, ID, fAge, age, fSex, sex, fCBal, cBal, fRew, reward, fDate, date);
elseif askSubjInfo == true
    prompt = {'ID:','Age:', 'Sex:', 'cBal', 'Reward'};
    name = 'SubjInfo';
    numlines = 1;
    defaultanswer = {'9999','99', 'm', '1', '1'};
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
    subjInfo{6} = date;
    
    % Make sure you made no mistake
    if subjInfo{3} ~= 'm' && subjInfo{3} ~= 'f'
        msgbox('Sex: "m" or "f"?');
        return
    end
    
    if subjInfo{4} ~= '1' && subjInfo{4} ~= '2'
        msgbox('cBal: 1 or 2?');
        return
    end
    
    if subjInfo{5} ~= '1' && subjInfo{5} ~= '2'
        msgbox('Reward: 1 or 2?');
        return
    end
    
    % Tranlate reward code in letter.
    if subjInfo{5} == '1'
        rewName = 'B';
    elseif subjInfo{5} == '2'
        rewName = 'G';
    end
    
    % Filenames.
    fName = sprintf('ADL_%s_%s.mat', rewName ,num2str(cell2mat((subjInfo(1)))));
    fNameDataOddball = sprintf('DataOddball_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataCP = sprintf('DataCP_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataLV = sprintf('DataLV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataHV = sprintf('DataHV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataLVLS = sprintf('DataLVLS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataHVLS = sprintf('DataHVLS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataLVHS = sprintf('DataLVHS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataHVHS = sprintf('DataHVHS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataPracticeLV = sprintf('DataPracticeLV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataPracticeHV = sprintf('DataPracticeHV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataPracticeLVHS = sprintf('DataPracticeLVHS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataPracticeHVLS = sprintf('DataPracticeHVLS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControlLV = sprintf('DataControlLV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControlHV = sprintf('DataControlHV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControlLVLS = sprintf('DataControlLVLS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControlHVLS = sprintf('DataControlHVLS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControlLVHS = sprintf('DataControlLVHS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControlHVHS = sprintf('DataControlHVHS_%s', num2str(cell2mat((subjInfo(1)))));
    
    % Struct with demographic subject variables.
    Subject = struct(fID, subjInfo(1), fAge, subjInfo(2), fSex, subjInfo(3), fCBal, str2double(cell2mat(subjInfo(4))), fRew, str2double(cell2mat(subjInfo(5))), fDate, subjInfo(6));
    
    % Make sure that no ID is used twice.
    if exist(fName, 'file') == 2
        msgbox('Diese ID wird bereits verwendet!');
        return
    end
end

%% Open window.

% Prevent input.
ListenChar(2);
%HideCursor;

% Suppress warnings.
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'SkipSyncTests', 2);

% Open a new window.
fScreensize = 'screensize'; screensize = get(0,'MonitorPositions');
screensizePart = (screensize(3:4));
fZero = 'zero'; zero = screensizePart / 2;
fWindow = 'window';
fWindowRect = 'windowRect';
if debug == true
    [ window, windowRect ] = Screen('OpenWindow', 0, [40 40 40], [420 250 1020 650]); %420 250 1020 650  64 64 64
else
    [ window, windowRect ] = Screen('OpenWindow', 0, [40 40 40], []); %420 250 1020 650  64 64 64
end

% Fieldnames.
fID = 'ID'; ID = fID; % ID.
fAge = 'age'; age = fAge; % Age.
fSex = 'sex'; sex = fSex; % Sex.
fRew = 'rew'; rew = fRew; %Rew.
fActRew = 'actRew'; actRew = fActRew; % Actual Reward;
fVolas = 'vola'; volas = fVolas; % Volatility.
fOddball = 'oddball';
fOddballProb = 'oddballProb'; oddballProbs = fOddballProb;
fDriftConc = 'driftConc'; driftConcentrations = fDriftConc;
fSigmas = 'sigma'; sigmas = fSigmas; % Sigma.
fOddBall = 'oddBall'; oddBall = fOddBall;
fDate = 'Date'; Date = fDate; % Date.
fCond = 'cond'; cond = fCond; % Condition.
fTrial = 'trial'; trial = fTrial; % Trial.
fOutcome = 'outcome'; outcome = fOutcome; % Outcome.
fAllASS = 'allASS'; allASS = fAllASS;
fDistMean = 'distMean'; distMean = fDistMean; % Distribution mean.
fCp = 'cp'; cp = fCp; % Change point.
fTAC = 'TAC'; TAC = fTAC; % Trials after change-point.
fBoatType = 'boatType'; boatType = fBoatType; % Boat type.
fCatchTrial = 'catchTrial'; catchTrial = fCatchTrial; % Catch trial.
fPredT = 'predT'; predT = fPredT; % Trigger: prediction.
fOutT = 'outT'; outT = fOutT; % Trigger: outcome.
fTriggers = 'triggers'; triggers = fTriggers; % Trigger: boat.
fPred = 'pred';pred = fPred; % Prediction of participant.
fPredErr = 'predErr'; predErr = fPredErr; % Prediction error.
fPredErrNorm = 'predErrNorm'; predErrNorm = fPredErrNorm;% Regular prediction error.
fPredErrPlus = 'predErrPlus'; predErrPlus = fPredErrPlus; %Prediction error plus 360 degrees.
fPredErrMin = 'predErrMin'; predErrMin = fPredErrMin; % Prediction error minus 360 degrees.
fRawPredErr = 'rawPredErr'; rawPredErr = fRawPredErr;
fMemErr = 'memErr'; memErr = fMemErr;% Memory error.
fMemErrNorm = 'memErrNorm'; memErrNorm = fMemErrNorm;% Regular memory error.
fMemErrPlus = 'memErrPlus'; memErrPlus = fMemErrPlus; % Memory error plus 360 degrees.
fMemErrMin = 'memErrMin'; memErrMin = fMemErrMin; % Memory error minus 360 degrees.
fUP = 'UP'; UP = fUP; % Update of participant.
fUPNorm = 'UPNorm'; UPNorm = fUPNorm;% Regular prediction error.
fUPPlus = 'UPPlus'; UPPlus = fUPPlus; %Prediction error plus 360 degrees.
fUPMin = 'UPMin'; UPMin = fUPMin;
fHit = 'hit'; hit = fHit; % Hit.
fCBal = 'cBal'; cBal = fCBal; % Counterbalancing.
fPerf = 'perf'; perf = fPerf; % Performance.
fAccPerf = 'accPerf'; accPerf = fAccPerf; % Accumulated performance.

fFieldNames = 'fieldNames';
fieldNames = struct('hallo', 'hallo', fOddBall, oddBall, fOddball, oddball, fOddballProb, oddballProbs, fDriftConc, driftConcentrations, fAllASS, allASS, fID, ID, fSigmas, sigmas, fAge, age, fSex, sex, fRew, rew, fActRew, actRew, fDate, Date, fCond, cond, fTrial, trial, fOutcome, outcome, fDistMean, distMean, fCp, cp,...
    fVolas, volas, fTAC, TAC, fBoatType, boatType, fCatchTrial, catchTrial, fPredT, predT, fOutT, outT, fTriggers, triggers, fPred, pred, fPredErr, predErr, fPredErrNorm, predErrNorm,...
    fPredErrPlus, predErrPlus, fPredErrMin, predErrMin, fMemErr, memErr, fMemErrNorm, memErrNorm, fMemErrPlus, memErrPlus,...
    fMemErrMin, memErrMin, fUP, UP, fUPNorm, UPNorm, fUPPlus, UPPlus, fUPMin, UPMin, fHit, hit, fCBal, cBal, fPerf, perf, fAccPerf, accPerf, fRawPredErr, rawPredErr);

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
gParam = struct(fSentenceLength, sentenceLength, fOddball, oddball, fDriftConc, driftConc, fOddballProb, oddballProb, fSigmas, sigma, fVolas, vola, fRunVola, runVola, fRunSigma, runSigma, fPE_Bar, PE_Bar, fSendTrigger, sendTrigger, fComputer, computer, fTrials, trials, fPractContTrials, practContTrials, fShieldTrials, shieldTrials, fPractTrials, practTrials, fContTrials, contTrials,...
    fSafe, safe, fRewMag, rewMag, fScreensize, screensize, fZero, zero, fWindow, window, fWindowRect, windowRect);

%% Circle parameters.

%Radius of the spots.
fPredSpotRad =  'predSpotRad'; predSpotRad = 10; % Prediction spot (red). This is expressed in pixel, not in degrees! it used to be 25
fOutcSpotRad = 'outcSpotRad'; outcSpotRad = 10; % Prediction spot (red). This is expressed in pixel, not in degrees!
fShieldAngle = 'shieldAngle'; shieldAngle = 30; %Shield Angle.
fOutcSize = 'outcSize'; outcSize = 10; % Black bar. Number must be equal.This is expressed in pixel, not in degrees!
fCannonEnd = 'cannonEnd'; cannonEnd = 5; %This is in pixel, not in degrees!
fMeanPoint = 'meanRad'; meanPoint = 1; % Point for radar needle. This is expressed in pixel, not in degrees!
fRotationRad = 'rotationRad'; rotationRad = 150; % Rotation Radius. This is expressed in pixel, not in degrees!

%Diameter of the spots.
fPredSpotDiam = 'predSpotDiam'; predSpotDiam = predSpotRad * 2; % Diameter of prediction spot.
fOutcSpotDiam = 'outcDiam'; outcDiam = outcSize * 2; % Diameter of outcome.
fSpotDiamMean = 'spotDiamMean'; spotDiamMean = meanPoint * 2; % Size of Radar needle.
fCannonEndDiam = 'cannonEndDiam'; cannonEndDiam = cannonEnd * 2;

%Position of the spots and the boats.
fPredSpotRect = 'predSpotRect'; predSpotRect = [0 0 predSpotDiam predSpotDiam]; % Prediction spot position.
fOuctcRect = 'outcRect'; outcRect = [0 0 outcDiam outcDiam]; % Outcome position.
fCannonEndRect = 'cannonEndRect'; cannonEndRect = [0 0 cannonEndDiam cannonEndDiam];
fSpotRectMean = 'spotRectMean'; spotRectMean =[0 0 spotDiamMean spotDiamMean]; % Radar needle position.

fBoatRect = 'boatRect'; boatRect = [0 0 60 60]; % Boat position.

% Center the objects.
fCentBoatRect = 'centBoatRect'; centBoatRect = CenterRect(boatRect, windowRect); % Center boat
fPredCentSpotRect = 'predCentSpotRect'; predCentSpotRect = CenterRect(predSpotRect, windowRect);% Center the prediction spot.
fOutcCentRect = 'outcCentRect'; outcCentRect = CenterRect(outcRect, windowRect); % Center the outcome.
fOutcCentSpotRect = 'outcCentSpotRect'; outcCentSpotRect = CenterRect(outcRect, windowRect); % Center the outcome.
fCannonEndCent = 'cannonEndCent'; cannonEndCent = CenterRect(cannonEndRect, windowRect);
fCentSpotRectMean = 'centSpotRectMean'; centSpotRectMean = CenterRect(spotRectMean,windowRect); % Center radar needle.

% Rotation angle of prediction spot.
fUnit = 'unit'; unit = 2*pi/360; % This expresses the circle (2*pi) as a fraction of 360 degrees.
fInitialRotAngle = 'initialRotAngle'; initialRotAngle = 0*unit; % The initial rotation angle (on top of circle).
fRotAngle = 'rotAngle'; rotAngle = initialRotAngle; % Rotation angle when prediction spot is moved.

% Circle parameters.
fCircle = 'circle';
circle = struct(fShieldAngle, shieldAngle, fCannonEndCent, cannonEndCent, fOutcCentSpotRect, outcCentSpotRect, fPredSpotRad, predSpotRad, fOutcSize, outcSize, fMeanPoint, meanPoint, fRotationRad, rotationRad, fPredSpotDiam, predSpotDiam, fOutcSpotDiam,...
    outcDiam, fSpotDiamMean, spotDiamMean, fPredSpotRect, predSpotRect, fOuctcRect, outcRect, fSpotRectMean, spotRectMean,...
    fBoatRect, boatRect, fCentBoatRect, centBoatRect, fPredCentSpotRect, predCentSpotRect, fOutcCentRect, outcCentRect, fCentSpotRectMean,...
    centSpotRectMean, fUnit, unit, fInitialRotAngle, initialRotAngle, fRotAngle, rotAngle);

% Boat colors.
fGold = 'gold'; gold = [255 215 0];
fSilver = 'silver'; silver = [160 160 160];
fColors = 'colors';
colors = struct(fGold, gold, fSilver, silver);

% Set key names.
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

% % -------------
% % Practice data
% % -------------
%
% % No vola.
% distMean = [233;233;233;233;233];
% outcome = [242;222;239;234;250];
% boatType = [2;1;1;2;1];
% pred = zeros(length(outcome),1);
% predErr = zeros(length(outcome),1);
% PredErrRaw = zeros(length(outcome),1);
% fPractDataNV = 'practDataNV';
% practDataNV = struct(fDistMean, distMean, fOutcome, outcome, fBoatType, boatType, fPred, pred, fPredErr, predErr, fRawPredErr, PredErrRaw);
%
% % Low vola.
% distMean = [239;239;239;239;239;239;239;100;100;100];
% outcome = [247;256;243;251;232;250;255;104;116;79];
% boatType = [1;2;1;2;2;1;2;1;1;2];
% pred = zeros(length(outcome),1);
% predErr = zeros(length(outcome),1);
% PredErrRaw = zeros(length(outcome),1);
% fCannonDev = 'CannonDev'; CannonDev = zeros(length(outcome),1);
% fPractDataLV = 'practDataLV';
% practDataLV = struct(fCannonDev, CannonDev, fDistMean, distMean, fOutcome, outcome, fBoatType, boatType, fPred, pred, fPredErr, predErr, fRawPredErr, PredErrRaw);
%
% % High vola.
% outcome = [6;13;26;35;53;39;55;65;293;278];
% distMean = [16;16;16;16;46;46;46;46;290;290];
% boatType = [1;1;2;1;2;1;2;1;2;2];
% pred = zeros(length(outcome),1);
% predErr = zeros(length(outcome),1);
% PredErrRaw = zeros(length(outcome),1);
% fCannonDev = 'CannonDev'; CannonDev = zeros(length(outcome),1);
% fPractDataHV = 'practDataHV';
% practDataHV = struct(fCannonDev, CannonDev, fDistMean, distMean, fOutcome, outcome, fBoatType, boatType, fPred, pred, fPredErr, predErr, fRawPredErr, PredErrRaw);
%
% fPractData = 'practData';
% practData = struct(fPractDataNV, practDataNV, fPractDataLV, practDataLV, fPractDataHV, practDataHV);

%% Trigger settings.

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
triggers = struct(fSampleRate, sampleRate, fPort, port, fStartTrigger, startTrigger, fTrialOnset, trialOnsetTrigger,...
    fPredTrigger, predTrigger, fBaseline1Trigger, baseline1Trigger, fOutcomeTrigger, outcomeTrigger, fBaseline2Trigger, baseline2Trigger,...
    fBoatTrigger, boatTrigger, fBaseline3Trigger, baseline3Trigger, fBlockLVTrigger, blockLVTrigger, fBlockHVTrigger, blockHVTrigger,...
    fBlockControlTrigger, blockControlTrigger);

IndicateOddball = 'Oddball Task';
IndicateCP = 'Change Point Task';
fTxtLowVola = 'txtLowVola'; txtLowVola = 'Jetzt verändert sich das Ziel der Kanone selten';
fTxtHighVola = 'txtHighVola'; txtHighVola = 'Jetzt verändert sich das Ziel der Kanone häufiger';
fTxtPressEnter = 'txtPressEnter'; txtPressEnter = 'Delete to go back - Enter to continue';
fTxtLVLS = 'txtLVLS'; txtLVLS = 'Jetzt fahren die Schiffe selten weiter\n\nund der Seegang ist schwach';
fTxtHVLS = 'txtHVLS'; txtHVLS = 'Jetzt fahren die Schiffe häufiger weiter\n\nund der Seegang ist schwach';
fTxtLVHS = 'txtLVHS'; txtLVHS = 'Jetzt fahren die Schiffe selten weiter\n\nund der Seegang ist stark';
fTxtHVHS = 'txtHVHS'; txtHVHS = 'Jetzt fahren die Schiffe häufiger weiter\n\nund der Seegang ist stark';


fStrings = 'strings';
strings = struct(fTxtLowVola, txtLowVola, fTxtHighVola, txtHighVola, fTxtLVLS, txtLVLS, fTxtHVLS, txtHVLS, fTxtLVHS, txtLVHS, fTxtHVHS, txtHVHS, fTxtPressEnter, txtPressEnter);

taskParam = struct(fGParam, gParam, fCircle, circle, fKeys, keys, fFieldNames, fieldNames, fTriggers, triggers,...
    fColors, colors, fStrings, strings, fCannonTxt, cannonTxt, fDstRect, dstRect);

% If true you run through one main block which enables you to check timing
% accuracy (see PTB output in command window).
if test == true
    
    [taskDataLV, DataLV] = Main(taskParam, vola(1), 'main', Subject); % Run task (low sigma).
    
    % Allow input again.
    ListenChar();
    ShowCursor;
    Screen('CloseAll');
    
else
    %% Run task.
    
    % Run intro with practice trials if true.
    if runIntro == true
        if Subject.cBal == 1
            Instructions(taskParam, 'Oddball', Subject);
            condition = 'practiceOddball';
            [taskDataOddballPractice, DataOddballPracticeLV] = Main(taskParam, vola(3), sigma(1), condition, Subject);
        elseif Subject.cBal == 2
            Instructions(taskParam, 'Main', Subject);
            condition = 'practice';
            [taskDataOddballPractice, DataOddballPracticeLV] = Main(taskParam, vola(3), sigma(1), condition, Subject);
        end
        if taskParam.gParam.oddball == false
            header = 'Anfang der Studie';
            txt = ['Du hast die Übungsphase abgeschlossen. Kurz '...
                'zusammengefasst fängst du also die meisten '...
                'Kugeln, wenn du den blauen Punkt auf die Stelle bewegst, auf die '...
                'die Kanone zielt. Weil du die Kanonen nicht mehr sehen kannst, musst du diese Stelle aufgrund der Position der letzten Kugeln einschätzen. Das Geld für die gefangenen '...
                'goldenen Kugeln bekommst du nach der Studie '...
                'ausgezahlt.\n\nViel Erfolg!'];
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
        BigScreen(taskParam, txtPressEnter, header, txt, feedback)
    else
        Screen('TextSize', taskParam.gParam.window, 30);
        Screen('TextFont', taskParam.gParam.window, 'Arial');

        VolaIndication(taskParam, IndicateOddball, txtPressEnter)
    end
    
    %% first block
   
    condition = 'oddball';
    type = 'Oddball';
    if Subject.cBal == 1
        [taskDataOddball, DataOddball] = Main(taskParam, vola(1), sigma(1), condition, Subject); % Run task (high sigma).
    elseif Subject.cBal == 2;
        condition = 'main';
        type = 'Main';
        [taskDataCP, DataCP] = Main(taskParam, vola(1), sigma(1), condition, Subject); % Run task (high sigma).
    end
    
    %% second intro
    
    if runIntro == true
        if Subject.cBal == 1 
            Instructions(taskParam, 'Main', Subject);
        elseif Subject.cBal == 2
            Instructions(taskParam, 'Oddball', Subject);
        end
        condition = 'practice';
        [taskDataPracticeMain, DataPracticeMain] = Main(taskParam, vola(3), sigma(1), condition, Subject);
        header = 'Real Task!';
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
        feedback = false;
        BigScreen(taskParam, txtPressEnter, header, txt, feedback)
    else
        VolaIndication(taskParam, IndicateCP, txtPressEnter)
    end
    WaitSecs(0.1);
    
%% second block

if Subject.cBal == 1
    condition = 'main';
    [taskDataCP, DataCP] = Main(taskParam, vola(1), sigma(1), condition, Subject); % Run task (high sigma).
elseif Subject.cBal == 2
    condition = 'oddball';
    [taskDataOddball, DataOddball] = Main(taskParam, vola(1), sigma(1), condition, Subject); % Run task (high sigma).
end
WaitSecs(0.1);



    % Control trials: this task requires a learning rate = 1
    %InstructionsControl(taskParam, Subject) % Run instructions.
    
    
    %     % This function runs the control trials
    %     condition = 'control';
    %     if Subject.cBal == '1'
    %         if runSigma == true
    %             VolaIndication(taskParam, txtLVHS, txtPressEnter) % Low sigma.
    %             [taskDataControlLVHS, DataControlLVHS] = Main(taskParam, vola(1), sigma(2), condition, Subject); % Run task (low sigma).
    %             %VolaIndication(taskParam, txtHVLS, txtPressEnter) % High sigma.
    %             %[taskDataHVLS, DataHVLS] = BattleShipsMain(taskParam, vola(2), sigma(1), condition, Subject); % Run task (high sigma).
    %             %VolaIndication(taskParam, txtLVHS, txtPressEnter) % Low sigma.
    %             %[taskDataLVHS, DataLVHS] = BattleShipsMain(taskParam, vola(1), sigma(2), condition, Subject); % Run task (low sigma).
    %             VolaIndication(taskParam, txtHVLS, txtPressEnter) % High sigma.
    %             [taskDataControlHVLS, DataControlHVLS] = Main(taskParam, vola(2), sigma(1), condition, Subject); % Run task (high sigma).
    %             %VolaIndication(taskParam, txtLowVola, txtPressEnter) % Low sigma.
    %             %[taskDataControlLV, DataControlLV] = BattleShipsMain(taskParam, vola(1), condition, Subject); % Run task (low sigma).
    %             %VolaIndication(taskParam, txtHighVola, txtPressEnter) % High sigma.
    %             %[taskDataControlHV, DataControlHV] = BattleShipsMain(taskParam, vola(2), condition, Subject); %Run task (high sigma).
    %         else
    %             VolaIndication(taskParam, txtLowVola, txtPressEnter) % Low sigma.
    %             [taskDataControlLV, DataControlLV] = Main(taskParam, vola(1), sigma(1), condition, Subject); % Run task (low sigma).
    %             VolaIndication(taskParam, txtHighVola, txtPressEnter) % High sigma.
    %             [taskDataControlHV, DataControlHV] = Main(taskParam, vola(2), sigma(1), condition, Subject); %Run task (high sigma).
    %         end
    %     else
    %         VolaIndication(taskParam, txtHighVola, txtPressEnter) % High sigma.
    %         [taskDataControlHV, DataControlHV] = Main(taskParam, vola(2), condition, Subject); %Run task (high sigma).
    %         VolaIndication(taskParam, txtLowVola, txtPressEnter) % Low sigma.
    %         [taskDataControlLV, DataControlLV] = Main(taskParam, vola(1), condition, Subject); % Run task (low sigma).
    %     end
    %
    % Compute total gain.
    if runSigma == true
        
        %totWin = DataLVLS.accPerf(end) + DataHVLS.accPerf(end) + DataLVHS.accPerf(end) + DataHVHS.accPerf(end) + DataControlLVHS.accPerf(end) + DataControlHVLS.accPerf(end);
        %totWin = DataLV.accPerf(end) + DataHV.accPerf(end) + DataControlLV.accPerf(end) + DataControlHV.accPerf(end);
    else
        totWin = DataOddball.accPerf(end) + DataCP.accPerf(end);
        
        %totWin = DataLV.accPerf(end) + DataHV.accPerf(end) + DataControlLV.accPerf(end) + DataControlHV.accPerf(end);
    end
    
    while 1
        %header = 'Ende der Aufgabe!';
        %txt = sprintf('Vielen Dank für deine Teilnahme\n\n\nInsgesamt hast du %.2f Euro gewonnen', totWin);
        
        header = 'End of task!';
        txt = sprintf('Thank you for participating\n\n\nYou earned $ %.2f', totWin);
        
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
    
    %% Save data.
    
    if askSubjInfo == true && oddball == true
        DataOddball = catstruct(Subject, DataOddball);
        DataCP = catstruct(Subject, DataCP);
        assignin('base',['DataOddball_' num2str(cell2mat((subjInfo(1))))],DataOddball)
        assignin('base',['DataCP_' num2str(cell2mat((subjInfo(1))))],DataCP)
        save(fullfile(savdir,fName),fNameDataOddball, fNameDataCP);
        
    elseif askSubjInfo == true && runIntro == true
        
        if runSigma == true
            DataPracticeLVHS = catstruct(Subject, DataPracticeLVHS);
            DataPracticeHVLS = catstruct(Subject, DataPracticeHVLS);
            DataLVHS = catstruct(Subject, DataLVHS);
            DataHVHS = catstruct(Subject, DataHVHS);
            DataControlLVHS = catstruct(Subject, DataControlLVHS);
            DataControlHVLS = catstruct(Subject, DataControlHVLS);
            %         DataLV = catstruct(Subject, DataLV);
            %         DataHV = catstruct(Subject, DataHV);
            %         DataControlLV = catstruct(Subject, DataControlLV);
            %         DataControlHV = catstruct(Subject, DataControlHV);
            
            assignin('base',['DataPracticeLVHS_' num2str(cell2mat((subjInfo(1))))],DataPracticeLVHS)
            assignin('base',['DataPracticeHVLS_' num2str(cell2mat((subjInfo(1))))],DataPracticeHVLS)
            assignin('base',['DataLVLS_' num2str(cell2mat((subjInfo(1))))],DataLVLS)
            assignin('base',['DataHVLS_' num2str(cell2mat((subjInfo(1))))],DataHVLS)
            assignin('base',['DataLVHS_' num2str(cell2mat((subjInfo(1))))],DataLVHS)
            assignin('base',['DataHVHS_' num2str(cell2mat((subjInfo(1))))],DataHVHS)
            assignin('base', ['DataControlLVHS_' num2str(cell2mat((subjInfo(1))))], DataControlLVHS)
            assignin('base', ['DataControlHVLS_' num2str(cell2mat((subjInfo(1))))], DataControlHVLS)
            save(fullfile(savdir,fName), fNameDataPracticeLVHS, fNameDataPracticeHVLS, fNameDataLVLS, fNameDataHVLS, fNameDataLVHS, fNameDataHVHS, fNameDataControlLVHS, fNameDataControlHVLS);
            
        else
            DataPracticeLV = catstruct(Subject, DataPracticeLV);
            DataPracticeHV = catstruct(Subject, DataPracticeHV);
            DataLV = catstruct(Subject, DataLV);
            DataHV = catstruct(Subject, DataHV);
            DataControlLV = catstruct(Subject, DataControlLV);
            DataControlHV = catstruct(Subject, DataControlHV);
            
            assignin('base',['DataPracticeLV_' num2str(cell2mat((subjInfo(1))))],DataPracticeLV)
            assignin('base',['DataPracticeHV_' num2str(cell2mat((subjInfo(1))))],DataPracticeHV)
            assignin('base',['DataLV_' num2str(cell2mat((subjInfo(1))))],DataLV)
            assignin('base',['DataHV_' num2str(cell2mat((subjInfo(1))))],DataHV)
            assignin('base', ['DataControlLV_' num2str(cell2mat((subjInfo(1))))], DataControlLV)
            assignin('base', ['DataControlHV_' num2str(cell2mat((subjInfo(1))))], DataControlHV)
            %save(fullfile(savdir,fName), fNameDataLVLS, fNameDataHVLS, fNameDataLVHS, fNameDataHVHS, fNameDataControlLVLS, fNameDataControlHVHS);
            save(fullfile(savdir,fName),fNameDataPracticeLV, fNameDataPracticeHV, fNameDataLV, fNameDataHV, fNameDataControlLV, fNameDataControlHV);
        end
    elseif askSubjInfo == true && runIntro == false
        
        if runSigma == true
            DataLVLS = catstruct(Subject, DataLVLS);
            DataHVLS = catstruct(Subject, DataHVLS);
            DataLVHS = catstruct(Subject, DataLVHS);
            DataHVHS = catstruct(Subject, DataHVHS);
            DataControlLVLS = catstruct(Subject, DataControlLVLS);
            DataControlHVHS = catstruct(Subject, DataControlHVHS);
            assignin('base',['DataLVLS_' num2str(cell2mat((subjInfo(1))))],DataLVLS)
            assignin('base',['DataHVLS_' num2str(cell2mat((subjInfo(1))))],DataHVLS)
            assignin('base',['DataLVHS_' num2str(cell2mat((subjInfo(1))))],DataLVHS)
            assignin('base',['DataHVHS_' num2str(cell2mat((subjInfo(1))))],DataHVHS)
            assignin('base', ['DataControlLVLS_' num2str(cell2mat((subjInfo(1))))], DataControlLVLS)
            assignin('base', ['DataControlHVHS_' num2str(cell2mat((subjInfo(1))))], DataControlHVHS)
            save(fullfile(savdir,fName), fNameDataLVLS, fNameDataHVLS, fNameDataLVHS, fNameDataHVHS, fNameDataControlLVLS, fNameDataControlHVHS);
        else
            DataLV = catstruct(Subject, DataLV);
            DataHV = catstruct(Subject, DataHV);
            DataControlLV = catstruct(Subject, DataControlLV);
            DataControlHV = catstruct(Subject, DataControlHV);
            assignin('base',['DataLV_' num2str(cell2mat((subjInfo(1))))],DataLV)
            assignin('base',['DataHV_' num2str(cell2mat((subjInfo(1))))],DataHV)
            assignin('base', ['DataControlLV_' num2str(cell2mat((subjInfo(1))))], DataControlLV)
            assignin('base', ['DataControlHV_' num2str(cell2mat((subjInfo(1))))], DataControlHV)
            save(fullfile(savdir,fName), fNameDataLV, fNameDataHV, fNameDataControlLV, fNameDataControlHV);
        end
    end
    
    
    %% End of task.
    
    % Allow input again.
    ListenChar();
    ShowCursor;
    
    % Close screen.
    Screen('CloseAll');
end