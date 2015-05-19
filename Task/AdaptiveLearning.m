function [DataMain, DataFollowOutcome, DataFollowCannon] = AdaptiveLearning(unitTest)

if nargin == 0
    unitTest = false;
end

if ~unitTest
    clear all
    unitTest = false;
end

% indentifies your machine. IF you have internet!
[computer, Computer2] = identifyPC;
%computer = 'Macbook'

%% unit test:
%
% select acutal data and expectedSolution!


%% TODO:

% sind catch trials in practice? irgendwo noch erwähnen


%%       - sachen fett drucken (AUFGABE UND FARBE)
%%       - überlegen wie viel gezahlt werden sollte
%%       - check jitter
%%      - daten laden für bedingungen (keyboard in alle bedingungen setzen und auf zwei bildschirmen checken ob alles erreicht wird)


%%       - performance überprüfen (ob alles richtig rausgeschrieben wird, MIT TEST)
%%       - feedback für main checken!! (mit test!!)
%%           - triggers should be controlled (mit test)

%           - trigger timing liste erstellen und paper lesen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       - condition:
%%           - shield
%%               - oddballPractice
%%               - oddballPractice_NoOddball
%%               - main
%%               - mainPractice
%%           - followOutcome
%%          - followOutcomePractice
%%          - followCannon
%%          - followCannonPractice        
%
%       - whichPractice:
%           oddballPractice
%           cpPractice
%           followOutcomePractice
%           followCannonPractice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

runIntro = true;
askSubjInfo = true;
oddball = false;
allThreeConditions = true;
sendTrigger = false;
randomize = true;
shieldTrials = 1; % 6
practTrials = 1; % 20
trials = 20; % 240
controlTrials = 20; % 120 
blockIndices = [1 60 120 180]; 
vola = [.25 1 0]; 
oddballProb = [.25 0];  
sigma = [10 12 99999999];  
driftConc = [30 99999999]; 
safe = [3 0];
rewMag = 0.2;
jitter = 0.2;
practiceTrialCriterion = 10;
test = false; 
debug = false;

% Check number of trials in each condition
if  (trials > 1 && mod(trials, 2)) == 1 || (controlTrials > 1 && mod(controlTrials, 2) == 1)
    msgbox('All trials must be even or equal to 1!');
    return
end

% Savedirectory
if isequal(computer, 'Macbook')
    % savdir = '/Users/Bruckner/Documents/MATLAB/AdaptiveLearning/DataDirectory';
    cd('/Users/Bruckner/Documents/MATLAB/AdaptiveLearning/DataDirectory');
elseif isequal(computer, 'Dresden')
    cd('C:\\Users\\TU-Dresden\\Documents\\MATLAB\\AdaptiveLearning\\DataDirectory');
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
    ID = '9999';
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
        if allThreeConditions
            cBal = num2str(round(unifrnd(1,6)));
        else
            cBal = num2str(round(unifrnd(1,2)));
        end
        reward = num2str(round(unifrnd(1,2)));
        group = num2str(round(unifrnd(1,2)));
        defaultanswer = {'9999','99', group, 'm', cBal, reward};
    else
        defaultanswer = {'9999','99', '1', 'm', '1', '1'};
    end
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
    subjInfo{7} = date;
    
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
    
    if allThreeConditions
        if subjInfo{5} ~= '1' && subjInfo{5} ~= '2' && subjInfo{5} ~= '3'...
                && subjInfo{5} ~= '4' && subjInfo{5} ~= '5' && subjInfo{5} ~= '6'
            msgbox('cBal: 1, 2, 3, 4, 5 or 6?');
            return
        end
    elseif ~allThreeConditions
        if subjInfo{5} ~= '1' && subjInfo{5} ~= '2'
            msgbox('cBal: 1 or 2 ?');
            return
        end
    end
    
    if subjInfo{6} ~= '1' && subjInfo{6} ~= '2'
        msgbox('Reward: 1 or 2?');
        return
    end
    
    if subjInfo{6} == '1'
        rewName = 'G';
    elseif subjInfo{6} == '2'
        rewName = 'S';
    end
    
    Subject = struct(fID, subjInfo(1), fAge, subjInfo(2), fSex,...
        subjInfo(4), fGroup, subjInfo(3), fCBal, str2double(cell2mat(subjInfo(5))), fRew,...
        str2double(cell2mat(subjInfo(6))), fDate, subjInfo(7));
    
    checkIdInData = dir(sprintf('*%s*', num2str(cell2mat((subjInfo(1))))));
    fileNames = {checkIdInData.name};
    
    if  ~isempty(fileNames);
        msgbox('Diese ID wird bereits verwendet!');
        return
    end
end

Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'SkipSyncTests', 2);

fScreensize = 'screensize'; screensize = get(0,'MonitorPositions');
screensizePart = (screensize(3:4));
fZero = 'zero'; zero = screensizePart / 2;
fWindow = 'window';
fWindowRect = 'windowRect';

[window, windowRect, textures] = OpenWindow;

startTime = GetSecs;

fID = 'ID'; ID = fID;
fAge = 'age'; age = fAge;
fSex = 'sex'; sex = fSex;
fRew = 'rew'; rew = fRew;
fActRew = 'actRew'; actRew = fActRew;
fVolas = 'vola'; volas = fVolas;
fOddball = 'oddball';
fOddballProb = 'oddballProb'; oddballProbs = fOddballProb;
fDriftConc = 'driftConc'; driftConcentrations = fDriftConc;
fSigmas = 'sigma'; sigmas = fSigmas;
fOddBall = 'oddBall'; oddBall = fOddBall;
fDate = 'Date'; Date = fDate;
fCond = 'cond'; cond = fCond;
fTrial = 'trial'; trial = fTrial;
fOutcome = 'outcome'; outcome = fOutcome;
fAllASS = 'allASS'; allASS = fAllASS;
fDistMean = 'distMean'; distMean = fDistMean;
fCp = 'cp'; cp = fCp;
fTAC = 'TAC'; TAC = fTAC;
fBoatType = 'boatType'; boatType = fBoatType;
fCatchTrial = 'catchTrial'; catchTrial = fCatchTrial;
fPredT = 'predT'; predT = fPredT;
fOutT = 'outT'; outT = fOutT;
fTriggers = 'triggers'; triggers = fTriggers;
fPred = 'pred';pred = fPred;
fPredErr = 'predErr'; predErr = fPredErr;
fPredErrNorm = 'predErrNorm'; predErrNorm = fPredErrNorm;
fPredErrPlus = 'predErrPlus'; predErrPlus = fPredErrPlus;
fPredErrMin = 'predErrMin'; predErrMin = fPredErrMin;
fRawPredErr = 'rawPredErr'; rawPredErr = fRawPredErr;
fMemErr = 'memErr'; memErr = fMemErr;
fMemErrNorm = 'memErrNorm'; memErrNorm = fMemErrNorm;
fMemErrPlus = 'memErrPlus'; memErrPlus = fMemErrPlus;
fMemErrMin = 'memErrMin'; memErrMin = fMemErrMin;
fUP = 'UP'; UP = fUP;
fUPNorm = 'UPNorm'; UPNorm = fUPNorm;
fUPPlus = 'UPPlus'; UPPlus = fUPPlus;
fUPMin = 'UPMin'; UPMin = fUPMin;
fHit = 'hit'; hit = fHit;
fCBal = 'cBal'; cBal = fCBal;
fPerf = 'perf'; perf = fPerf;
fAccPerf = 'accPerf'; accPerf = fAccPerf;

fFieldNames = 'fieldNames';
fieldNames = struct('actJitter', 'actJitter', 'block', 'block',...
    'initiationRTs', 'initiationRTs','timestampOnset', 'timestampOnset',...
    'timestampPrediction', 'timestampPrediction', 'timestampOffset',...
    'timestampOffset', fOddBall, oddBall, 'oddball', oddball, 'oddballProb',...
    oddballProbs, fDriftConc, driftConcentrations, fAllASS, allASS, fID, ID,...
    fSigmas, sigmas, fAge, age, fSex, sex, fRew, rew, fActRew, actRew, fDate,...
    Date, fCond, cond, fTrial, trial, fOutcome, outcome, fDistMean, distMean, fCp, cp,...
    fVolas, volas, fTAC, TAC, fBoatType, boatType, fCatchTrial, catchTrial,...
    fPredT, predT, fOutT, outT, fTriggers, triggers, fPred, pred, fPredErr,...
    predErr, fPredErrNorm, predErrNorm, fPredErrPlus, predErrPlus,...
    fPredErrMin, predErrMin, fMemErr, memErr, fMemErrNorm, memErrNorm,...
    fMemErrPlus, memErrPlus,fMemErrMin, memErrMin, fUP, UP, fUPNorm,...
    UPNorm, fUPPlus, UPPlus, fUPMin, UPMin, fHit, hit, fCBal, cBal,...
    fPerf, 'perf', 'accPerf', accPerf, fRawPredErr, rawPredErr);

fOddball = 'oddball';
fGParam = 'gParam';
fSendTrigger = 'sendTrigger';
fDriftConc = 'driftConc';
fOddballProb = 'oddballProb';
fComputer = 'computer';
fTrials = 'trials';
fShieldTrials = 'shieldTrials';
fPractTrials = 'practTrials';
fControlTrials = 'controlTrials';
fSafe = 'safe';
fRewMag = 'rewMag';
fSentenceLength = 'sentenceLength';
if isequal(computer, 'Dresden')
    sentenceLength = 70;
elseif isequal(computer, 'Brown')
    sentenceLength = 75;
else
    sentenceLength = 85;
end
ref = GetSecs;
gParam = struct('jitter', jitter,'allThreeConditions', allThreeConditions,...
    'blockIndices', blockIndices, 'ref', ref, fSentenceLength,...
    sentenceLength, fOddball, oddball, fDriftConc, driftConc,...
    fOddballProb, oddballProb, fSigmas, sigma, fVolas, vola,...
    fSendTrigger, sendTrigger, fComputer, computer, fTrials,...
    trials, fShieldTrials, shieldTrials, fPractTrials, practTrials,...
    fControlTrials, controlTrials,fSafe, safe, fRewMag, rewMag,...
    fScreensize, screensize, fZero, zero,fWindow, window, fWindowRect,...
    windowRect, 'practiceTrialCriterion',practiceTrialCriterion, 'askSubjInfo',...
    askSubjInfo);

fPredSpotRad =  'predSpotRad'; predSpotRad = 10; 
fOutcSpotRad = 'outcSpotRad'; outcSpotRad = 10; 
fShieldAngle = 'shieldAngle'; shieldAngle = 30; 
fOutcSize = 'outcSize'; outcSize = 10; 
fCannonEnd = 'cannonEnd'; cannonEnd = 5; 
fMeanPoint = 'meanRad'; meanPoint = 1; 
fRotationRad = 'rotationRad'; rotationRad = 150; 

fPredSpotDiam = 'predSpotDiam'; predSpotDiam = predSpotRad * 2;
fOutcSpotDiam = 'outcDiam'; outcDiam = outcSize * 2; 
fSpotDiamMean = 'spotDiamMean'; spotDiamMean = meanPoint * 2; 
fCannonEndDiam = 'cannonEndDiam'; cannonEndDiam = cannonEnd * 2;

fPredSpotRect = 'predSpotRect'; predSpotRect = [0 0 predSpotDiam predSpotDiam]; 
fOuctcRect = 'outcRect'; outcRect = [0 0 outcDiam outcDiam]; 
fCannonEndRect = 'cannonEndRect'; cannonEndRect = [0 0 cannonEndDiam cannonEndDiam];
fSpotRectMean = 'spotRectMean'; spotRectMean =[0 0 spotDiamMean spotDiamMean]; 
fBoatRect = 'boatRect'; boatRect = [0 0 50 50]; 

fCentBoatRect = 'centBoatRect'; centBoatRect = CenterRect(boatRect, windowRect); 
fPredCentSpotRect = 'predCentSpotRect'; predCentSpotRect = CenterRect(predSpotRect, windowRect);
fOutcCentRect = 'outcCentRect'; outcCentRect = CenterRect(outcRect, windowRect);
fOutcCentSpotRect = 'outcCentSpotRect'; outcCentSpotRect = CenterRect(outcRect, windowRect); 
fCannonEndCent = 'cannonEndCent'; cannonEndCent = CenterRect(cannonEndRect, windowRect);
fCentSpotRectMean = 'centSpotRectMean'; centSpotRectMean = CenterRect(spotRectMean,windowRect); 

fUnit = 'unit'; unit = 2*pi/360; 
fInitialRotAngle = 'initialRotAngle'; initialRotAngle = 0*unit; 
fRotAngle = 'rotAngle'; rotAngle = initialRotAngle; 

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

fGold = 'gold'; gold = [255 215 0];
fSilver = 'silver'; silver = [160 160 160];
fColors = 'colors';
colors = struct(fGold, gold, fSilver, silver);

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

%% Trigger settings

if sendTrigger == true
    config_io;             
end

fSampleRate = 'sampleRate'; sampleRate = 512; % Sample rate.
fPort = 'port'; port = 53328; % LPT port (Dresden)
%LPT1address = hex2dec('E050'); %standard location of LPT1 port % copied from heliEEG_main
%fPort = 'port'; port = hex2dec('E050'); % LPT port
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
IndicateMain = 'Change Point Task';
IndicateFollowCannon = 'Follow Cannon Task';
IndicateFollowOutcome = 'Follow Outcome Task';
fTxtPressEnter = 'txtPressEnter';

if oddball
    header = 'Real Task!';
    txtPressEnter = 'Delete to go back - Enter to continue';
    if Subject.cBal == 1
        txtStartTask = ['This is the beginning of the real task. During '...
            'this block you will earn real money for your performance. '...
            'The trials will be exactly the same as those in the '...
            'previous practice block. On each trial a cannon will aim '...
            'at a location on the circle. On most trials the cannon will '...
            'fire a ball somewhere near the point of aim. '...
            'However, on a few trials a ball will be shot '...
            'from a different cannon that is equally likely to '...
            'hit any location on the circle. Like in the previous '...
            'block you will not see the cannon, but still have to infer its '...
            'aim in order to catch balls and earn money.'];
    else
        txtStartTask = ['This is the beginning of the real task. During '...
            'this block you will earn real money for your performance. '...
            'The trials will be exactly the same as those in the '...
            'previous practice block. On each trial a cannon will aim '...
            'at a location on the circle. On all trials the cannon will '...
            'fire a ball somewhere near the point of aim. '...
            'Most of the time the cannon will remain aimed at '...
            'the same location, but occasionally the cannon '...
            'will be reaimed. Like in the previous '...
            'block you will not see the cannon, but still '...
            'have to infer its aim in order to catch balls and earn money.'];
    end
else
    %txtPressEnter = 'Zurück mit Löschen - Weiter mit Enter';
    txtPressEnter = 'Weiter mit Enter';
    
    header = 'Anfang der Studie';
    if Subject.cBal == 1
        txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz '...
            'zusammengefasst fängst du also die meisten '...
            'Kugeln, wenn du den orangenen Punkt auf die Stelle '...
            'bewegst, auf die die Kanone zielt. Weil du die '...
            'Kanone nicht mehr sehen kannst, musst du diese '...
            'Stelle aufgrund der Position der letzten Kugeln '...
            'einschätzen. Das Geld für die gefangenen '...
            'Kugeln bekommst du nach der Studie '...
            'ausgezahlt.\n\nViel Erfolg!'];
    else
        txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz '...
            'zusammengefasst ist es deine Aufgabe Kanonenkugeln '...
            'aufzusammeln, indem du deinen orangenen Punkt '...
            'zur Stelle der letzten Kanonenkugel steuerst, '...
            'welche mit dem schwarzen Strich markiert ist. '...
            'Das Geld für die gesammelten '...
            'Kugeln bekommst du nach der Studie '...
            'ausgezahlt.\n\nViel Erfolg!'];
    end
end

fStrings = 'strings';
strings = struct(fTxtPressEnter, txtPressEnter);
taskParam = struct(fGParam, gParam, fCircle, circle, fKeys, keys,...
    fFieldNames, fieldNames, fTriggers, triggers,...
    fColors, colors, fStrings, strings, 'textures', textures,...
    'unitTest', unitTest);

if ~test && ~allThreeConditions
    
    if oddball
        
        if Subject.cBal == 1
            OddballCondition
            MainCondition
        elseif Subject.cBal == 2
            MainCondition
            OddballCondition
        end
        
    elseif ~oddball
        
        if Subject.cBal == 1
            MainCondition;
            FollowOutcomeCondition
        elseif Subject.cBal == 2
            FollowOutcomeCondition
            MainCondition
        end
        
    end
    
    if oddball
        totWin = DataOddball.accPerf(end) + DataMain.accPerf(end);
    else
        totWin = DataFollowOutcome.accPerf(end) + DataMain.accPerf(end);
    end
    
    Screen('TextSize', taskParam.gParam.window, 19);
    Screen('TextFont', taskParam.gParam.window, 'Arial');
    EndOfTask
    
elseif test && ~allThreeConditions
    
    [taskDataLV, DataLV] = Main(taskParam, vola(1), 'main', Subject);
    
elseif allThreeConditions
    
    if Subject.cBal == 1
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        
    elseif Subject.cBal == 2
        
        % läuft!
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        
    elseif Subject.cBal == 3
        
        % läuft
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        
    elseif Subject.cBal == 4
        
        % hier ändern
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        
    elseif Subject.cBal == 5
        
        % hier ändern
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        
    elseif Subject.cBal == 6
        
        % hier ändern
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        
    end
    
    totWin = DataFollowOutcome.accPerf(end) + DataMain.accPerf(end)...
        + DataFollowCannon.accPerf(end);
    
    
    EndOfTask
    
end

ListenChar();
ShowCursor;
Screen('CloseAll');


    function OddballCondition
        
        condition = 'oddball';
        [taskDataOddball, DataOddball] = Main(taskParam, vola(1), sigma(1), condition, Subject);
        
    end

    function DataMain = MainCondition
        
        if runIntro && ~unitTest
            txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz '...
                'zusammengefasst fängst du also die meisten '...
                'Kugeln, wenn du den orangenen Punkt auf die Stelle '...
                'bewegst, auf die die Kanone zielt. Weil du die '...
                'Kanone nicht mehr sehen kannst, musst du diese '...
                'Stelle aufgrund der Position der letzten Kugeln '...
                'einschätzen. Das Geld für die gefangenen '...
                'Kugeln bekommst du nach der Studie '...
                'ausgezahlt.\n\nViel Erfolg!'];
            Instructions(taskParam, 'mainPractice', Subject);
            Main(taskParam, vola(3), sigma(1), 'mainPractice', Subject);
            feedback = false;
            BigScreen(taskParam, txtPressEnter, header, txtStartTask, feedback);
        else
            Screen('TextSize', taskParam.gParam.window, 30);
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            VolaIndication(taskParam, IndicateMain, txtPressEnter)
        end
        [~, DataMain] = Main(taskParam, vola(1), sigma(1), 'main', Subject);
        
    end

    function DataFollowOutcome = FollowOutcomeCondition
        
        if runIntro && ~unitTest
            
            txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz '...
                'zusammengefasst ist es deine Aufgabe Kanonenkugeln '...
                'aufzusammeln, indem du deinen orangenen Punkt '...
                'zur Stelle der letzten Kanonenkugel steuerst, '...
                'welche mit dem schwarzen Strich markiert ist. '...
                'Das Geld für die gesammelten '...
                'Kugeln bekommst du nach der Studie '...
                'ausgezahlt.\n\nViel Erfolg!'];
            Instructions(taskParam, 'followOutcomePractice', Subject)
            Main(taskParam, vola(3),sigma(1), 'followOutcomePractice', Subject);
            feedback = false;
            BigScreen(taskParam, txtPressEnter, header, txtStartTask, feedback);
        else
            Screen('TextSize', taskParam.gParam.window, 30);
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            VolaIndication(taskParam, IndicateFollowOutcome, txtPressEnter)
        end
        [~, DataFollowOutcome] = Main(taskParam, vola(1), sigma(1), 'followOutcome', Subject);
        
    end

    function DataFollowCannon = FollowCannonCondition
        
        if runIntro && ~unitTest
            
            txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz '...
                'zusammengefasst fängst du also die meisten '...
                'Kugeln, wenn du den orangenen Punkt auf die Stelle '...
                'bewegst, auf die die Kanone zielt (schwarze Nadel). '...
                'Diesmal kannst du die Kanone sehen.\n\nViel Erfolg!'];
            Instructions(taskParam, 'followCannonPractice', Subject)
            Main(taskParam, vola(3),sigma(1), 'followCannonPractice', Subject);
            feedback = false;
            BigScreen(taskParam, txtPressEnter, header, txtStartTask, feedback);
        else
            Screen('TextSize', taskParam.gParam.window, 30);
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            VolaIndication(taskParam, IndicateFollowCannon, txtPressEnter)
        end
        [~, DataFollowCannon] = Main(taskParam, vola(1), sigma(1), 'followCannon', Subject);
        
    end

    function [window, windowRect, textures] = OpenWindow
        
        if debug == true
            [ window, windowRect] = Screen('OpenWindow', 0, [66 66 66], [420 250 1020 650]);
        else
            [ window, windowRect ] = Screen('OpenWindow', 0, [66 66 66], []);
        end
        
        imageRect = [0 0 120 120];
        dstRect = CenterRect(imageRect, windowRect);
        [cannonPic, ~, alpha]  = imread('cannon.png');
        cannonPic(:,:,4) = alpha(:,:);
        Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        cannonTxt = Screen('MakeTexture', window, cannonPic);
        [aimPic, ~, alpha]  = imread('arrow.png');
        aimPic(:,:,4) = alpha(:,:);
        aimTxt = Screen('MakeTexture', window, aimPic);
        textures = struct('cannonTxt', cannonTxt, 'aimTxt', aimTxt,...
            'dstRect', dstRect);
        
        ListenChar(2);
        %HideCursor;
        
    end

    function window = CloseScreenAndOpenAgain
   
        if ~unitTest
        Screen('TextFont', taskParam.gParam.window, 'Arial');
        Screen('TextSize', taskParam.gParam.window, 30);
        
        txt='Ende der Aufgabe!\n\nBitte auf den Versuchsleiter warten';
        
        while 1
            
            Screen('FillRect', taskParam.gParam.window, []);
            DrawFormattedText(taskParam.gParam.window, txt,...
                'center', 100, [0 0 0]);
            Screen('DrawingFinished', taskParam.gParam.window);
            
            
            t = GetSecs;
            Screen('Flip', taskParam.gParam.window, t + 0.1);
            [~, ~, keyCode] = KbCheck;
            
            if find(keyCode) == taskParam.keys.s
                break
            end
        end
        
        WaitSecs(1);
        
        %ListenChar();
        ShowCursor;
        Screen('CloseAll');
        disp('Press start to continue...')
        WaitSecs(1);
        
        while 1
            [ keyIsDown, ~, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(taskParam.keys.s)
                    break
                end
            end
        end
        
        window = OpenWindow;
        
        end
        window = taskParam.gParam.window;
    end

    function EndOfTask
        
        while 1
            
            if oddball
                header = 'End of task!';
                txt = sprintf('Thank you for participating\n\n\nYou earned $ %.2f', totWin);
            else
                header = 'Ende des Versuchs!';
                txt = sprintf('Vielen Dank für deine Teilnahme\n\n\nDu hast %.2f Euro verdient', totWin);
            end
            Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0,...
                taskParam.gParam.screensize(4)*0.16,...
                taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.16, 5);
            Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0,...
                taskParam.gParam.screensize(4)*0.8,...
                taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.8, 5);
            Screen('FillRect', taskParam.gParam.window, [0 25 51],...
                [0, (taskParam.gParam.screensize(4)*0.16)+3,...
                taskParam.gParam.screensize(3), (taskParam.gParam.screensize(4)*0.8)-2]);
            Screen('TextSize', taskParam.gParam.window, 30);
            DrawFormattedText(taskParam.gParam.window, header,...
                'center', taskParam.gParam.screensize(4)*0.1);
            Screen('TextSize', taskParam.gParam.window, 19);
            DrawFormattedText(taskParam.gParam.window, txt,...
                'center', 'center');
            Screen('DrawingFinished', taskParam.gParam.window, [], []);
            time = GetSecs;
            Screen('Flip', taskParam.gParam.window, time + 0.1);
            
            [ ~, ~, keyCode ] = KbCheck;
            if find(keyCode) == taskParam.keys.s & ~taskParam.unitTest
                break
            elseif taskParam.unitTest               
                WaitSecs(1);
                break
            end
        end
    end

totalTime = (GetSecs - startTime)/60

end

