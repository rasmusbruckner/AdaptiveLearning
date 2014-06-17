%% Adaptive Learning Task - EEG
%
% BattleShips is an adaptive learning EEG task for investigating belief
% updating in dynamical environments with systematic (vola)
% and random changes (sigma).
%
% Outcomes are presented on a circle which is expressed in 360 degrees.
%
% The function GenerateOutcomes generates outcomes that are centerend
% around the mean of a normal distribution (distMean) with
% standard deviation = sigma.

clear all

%% Set general parameters.

runIntro = false;   % Run the intro with practice trials?
askSubjInfo = true; % Do you want some basic demographic subject variables?
vola = [.4 .8]; % Volatility of the environment.
fSendTrigger = 'sendTrigger'; sendTrigger = false; % Do you want to send triggers?
fComputer = 'computer'; computer = 'Macbook'; % On which computer do you run the task? Macbook or Humboldt?
fTrials = 'trials'; trials = 3; % Number of trials per (sigma-)condition.
fIntTrials = 'intTrials'; intTrials = 1; % Trials during the introduction (per condition).
fPractTrials = 'practTrials'; practTrials = 1; % Number of practice trials per condition.
fContTrials = 'contTrials'; contTrials = 3; % Number of control trials.
fSigma = 'sigma'; sigma = 15; % SD's of distribution.
fSafe = 'safe'; safe = 3; % How many guaranteed trials without change-points.

% Savedirectory.
if isequal(computer, 'Macbook')
    savdir = '/Users/Bruckner/Documents/MATLAB/AdaptiveLearning/DataDirectory';
elseif isequal(computer, 'Dresden')
    savdir = 'C:\Users\TU-Dresden\Documents\MATLAB\AdaptiveLearning\DataDirectory';
elseif isequal(computer, 'Humboldt')
    savdir = 'D:\!EXP\AdaptiveLearning\DataDirectory';
end

%% User Input.

fID = 'ID';
fAge = 'age';
fSex = 'sex';
fCBal = 'cBal';
fRew = 'rew';
fDate = 'date';

if askSubjInfo == false
    
    ID = '999';
    age = '999';
    sex = 'm/w';
    cBal = '1';
    reward = '1';
    Subject = struct(fID, ID, fAge, age, fSex, sex, fCBal, cBal, fRew, rew, fDate, date);
    
elseif askSubjInfo == true
    prompt = {'ID:','Alter:', 'Geschlecht:', 'cBal', 'reward'};
    name = 'SubjInfo';
    numlines = 1;
    defaultanswer = {'9999','99', 'm', '1', '1'};
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
    subjInfo{6} = date;
    
    % Make sure you made no mistake
    if subjInfo{3} ~= 'm' && subjInfo{3} ~= 'w'
        msgbox('Geschlecht: "m" oder "w"?');
        return
    end
    
    if subjInfo{4} ~= '1' && subjInfo{4} ~= '2'
        msgbox('cBal muss 1 oder 2 sein!');
        return
    end
    
    if subjInfo{5} ~= '1' && subjInfo{5} ~= '2'
        msgbox('reward muss 1 oder 2 sein!');
        return
    end
    
    % Filenames.
    fName = sprintf('BattleShips_%s.mat', num2str(cell2mat((subjInfo(1)))));
    fNameDataLV = sprintf('DataLV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataHV = sprintf('DataHV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataPracticeLV = sprintf('DataPracticeLV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataPracticeHV = sprintf('DataPracticeHV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControlLV = sprintf('DataControlLV_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControlHV = sprintf('DataControlHV_%s', num2str(cell2mat((subjInfo(1)))));
    
    % Struct with demographic subject variables.
    Subject = struct(fID, subjInfo(1), fAge, subjInfo(2), fSex, subjInfo(3), fCBal, subjInfo(4), fRew, subjInfo(5), fDate, subjInfo(6));
    
    % Make sure that no ID is used twice.
    if exist(fName, 'file') == 2
        msgbox('Diese ID wird bereits verwendet!');
        return
    end
end

%% Open window.

% Prevent input.
ListenChar(2);
HideCursor;

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
[ window, windowRect ] = Screen('OpenWindow', 0, [], []);

fGParam = 'gParam';
gParam = struct(fSendTrigger, sendTrigger, fComputer, computer, fTrials, trials, fIntTrials, intTrials, fPractTrials, practTrials, fContTrials, contTrials,...
    fSigma, sigma, fSafe, safe, fScreensize, screensize, fZero, zero, fWindow, window, fWindowRect, windowRect);

%% Circle parameters.

%Radius of the spots.
fPredSpotRad =  'predSpotRad'; predSpotRad = 15; % Prediction spot (red).
fOutcSize = 'outcSize'; outcSize = 26; % Black bar.
fMeanPoint = 'meanRad'; meanPoint = 1; % Point for radar needle.
fRotationRad = 'rotationRad'; rotationRad = 100; % Rotation Radius.

%Diameter of the spots.
fPredSpotDiam = 'predSpotDiam'; predSpotDiam = predSpotRad * 2; % Diameter of prediction spot.
fOutcSpotDiam = 'outcDiam'; outcDiam = outcSize * 2; % Diameter of outcome.
fSpotDiamMean = 'spotDiamMean'; spotDiamMean = meanPoint * 2; % Size of Radar needle.

%Position of the spots and the boats.
fPredSpotRect = 'predSpotRect'; predSpotRect = [0 0 predSpotDiam predSpotDiam]; % Prediction spot position.
fOuctcRect = 'outcRect'; outcRect = [0 0 outcDiam outcDiam]; % Outcome position.
fSpotRectMean = 'spotRectMean'; spotRectMean =[0 0 spotDiamMean spotDiamMean]; % Radar needle position.
fBoatRect = 'boatRect'; boatRect = [0 0 60 60]; % Boat position.

% Center the objects.
fCentBoatRect = 'centBoatRect'; centBoatRect = CenterRect(boatRect, windowRect); % Center boat
fPredCentSpotRect = 'predCentSpotRect'; predCentSpotRect = CenterRect(predSpotRect, windowRect);% Center the prediction spot.
fOutcCentRect = 'outcCentRect'; outcCentRect = CenterRect(outcRect, windowRect); % Center the outcome.
fCentSpotRectMean = 'centSpotRectMean'; centSpotRectMean = CenterRect(spotRectMean,windowRect); % Center radar needle.

% Rotation angle of prediction spot.
fUnit = 'unit'; unit = 2*pi/360; % This expresses the circle (2*pi) as a fraction of 360 degrees.
fInitialRotAngle = 'initialRotAngle'; initialRotAngle = 0*unit; % The initial rotation angle (on top of circle).
fRotAngle = 'rotAngle'; rotAngle = initialRotAngle; % Rotation angle when prediction spot is moved.

% Circle parameters.
fCircle = 'circle';
circle = struct(fPredSpotRad, predSpotRad, fOutcSize, outcSize, fMeanPoint, meanPoint, fRotationRad, rotationRad, fPredSpotDiam, predSpotDiam, fOutcSpotDiam,...
    outcDiam, fSpotDiamMean, spotDiamMean, fPredSpotRect, predSpotRect, fOuctcRect, outcRect, fSpotRectMean, spotRectMean,...
    fBoatRect, boatRect, fCentBoatRect, centBoatRect, fPredCentSpotRect, predCentSpotRect, fOutcCentRect, outcCentRect, fCentSpotRectMean,...
    centSpotRectMean, fUnit, unit, fInitialRotAngle, initialRotAngle, fRotAngle, rotAngle);

% Boat colors.
fGold = 'gold'; gold = [255 215 0];
fSilver = 'silver'; silver = [192 192 192];
fColors = 'colors';
colors = struct(fGold, gold, fSilver, silver);

% Set key names.
KbName('UnifyKeyNames')
fRightKey = 'rightKey'; rightKey = KbName('RightArrow');
fLeftKey = 'leftKey'; leftKey = KbName('LeftArrow');
fSpace = 'space'; space = KbName('Space');
fEnter = 'enter';
fS = 's';
if isequal(computer, 'Macbook')
    enter = 40;
    s = 22;
elseif isequal(computer, 'Dresden')
    enter = 13;
    s = 83;
elseif isequal(computer, 'Humboldt')
    enter = 13;
    s = 83;
end

fKeys = 'keys';
keys = struct(fRightKey, rightKey, fLeftKey, leftKey, fSpace, space, fEnter, enter, fS, s);

% Fieldnames.
fID = 'ID'; ID = fID; % ID.
fAge = 'age'; age = fAge; % Age.
fSex = 'sex'; sex = fSex; % Sex.
fRew = 'rew'; rew = fRew; %Rew.
fVolas = 'vola'; volas = fVolas; % Volatility.
fSigma = 'sigma'; sigma = fSigma, % Sigma.
fDate = 'date'; date = fDate; % Date.
fCond = 'cond'; cond = fCond; % Condition.
fTrial = 'trial'; trial = fTrial; % Trial.
fOutcome = 'outcome'; outcome = fOutcome; % Outcome.
fDistMean = 'distMean'; distMean = fDistMean; % Distribution mean.
fCp = 'cp'; cp = fCp; % Change point.
fTAC = 'TAC'; TAC = fTAC; % Trials after change-point.
fBoatType = 'boatType'; boatType = fBoatType; % Boat type.
fCatchTrial = 'catchTrial'; catchTrial = fCatchTrial; % Catch trial.
fPred = 'pred';pred = fPred; % Prediction of participant.
fPredErr = 'predErr'; predErr = fPredErr; % Prediction error.
fPredErrNorm = 'predErrNorm'; predErrNorm = fPredErrNorm;% Regular prediction error.
fPredErrPlus = 'predErrPlus'; predErrPlus = fPredErrPlus; %Prediction error plus 360 degrees.
fPredErrMin = 'predErrMin'; predErrMin = fPredErrMin; % Prediction error minus 360 degrees.
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
fieldNames = struct(fID, ID, fSigma, sigma, fAge, age, fSex, sex, fRew, rew, fDate, date, fCond, cond, fTrial, trial, fOutcome, outcome, fDistMean, distMean, fCp, cp,...
    fVolas, volas, fTAC, TAC, fBoatType, boatType, fCatchTrial, catchTrial, fPred, pred, fPredErr, predErr, fPredErrNorm, predErrNorm,...
    fPredErrPlus, predErrPlus, fPredErrMin, predErrMin, fMemErr, memErr, fMemErrNorm, memErrNorm, fMemErrPlus, memErrPlus,...
    fMemErrMin, memErrMin, fUP, UP, fUPNorm, UPNorm, fUPPlus, UPPlus, fUPMin, UPMin, fHit, hit, fCBal, cBal, fPerf, perf, fAccPerf, accPerf);

%% Trigger settings.

fSampleRate = 'sampleRate'; sampleRate = 512; % Sample rate.
fPort = 'port'; port = 53264; % LPT port
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

fTxtLowVola = 'txtLowVola'; txtLowVola = 'Jetzt fahren die Schiffe selten weiter';
fTxtHighVola = 'txtHighVola'; txtHighVola = 'Jetzt fahren die Schiffe häufiger weiter';
fTxtPressEnter = 'txtPressEnter'; txtPressEnter = 'Weiter mit Enter';

fStrings = 'strings';
strings = struct(fTxtLowVola, txtLowVola, fTxtHighVola, txtHighVola, fTxtPressEnter, txtPressEnter);

taskParam = struct(fGParam, gParam, fCircle, circle, fKeys, keys, fFieldNames, fieldNames, fTriggers, triggers,...
    fColors, colors, fStrings, strings);


%% Run task.

% Set port to 0.
if taskParam.gParam.sendTrigger == true
    lptwrite(taskParam.triggers.port,0);
end

% Set text parameters.
Screen('TextFont', taskParam.gParam.window, 'Arial');
Screen('TextSize', taskParam.gParam.window, 30);

KbReleaseWait()

% Run intro with practice trials if true.
if runIntro == true
    
    % Function for instructions.
    BattleShipsInstructions(taskParam, Subject.cBal);
    
    condition = 'practice';
    if Subject.cBal == '1'
        VolaIndication(taskParam, txtLowVola, txtPressEnter)
        [taskDataPracticeLV, DataPracticeLV] = BattleShipsMain(taskParam, vola(1), condition, Subject);
        VolaIndication(taskParam, txtHighVola, txtPressEnter)
        [taskDataPracticeHV, DataPracticeHV] = BattleShipsMain(taskParam, vola(2), condition, Subject);
    else
        VolaIndication(taskParam, txtHighVola, txtPressEnter)
        [taskDataPracticeHV, DataPracticeHV] = BattleShipsMain(taskParam, vola(2), condition, Subject);
        VolaIndication(taskParam, txtLowVola, txtPressEnter)
        [taskDataPracticeLV, DataPracticeLV] = BattleShipsMain(taskParam, vola(1), condition, Subject);
        
    end
    
    % End of practice blocks. This part makes sure that you start your EEG setup!
    header = 'Anfang der Studie';
    if isequal(taskParam.gParam.computer, 'Humboldt')
        txt = 'Zur Erinnerung:\n\nWenn du ein goldenes Schiff triffst, verdienst du 20 CENT.\n\nBei einem Schiff mit Steinen an Board verdienst du NICHTS.\n\n\n\n\n\nBitte achte auch wieder auf Blinzler und deine Augenbewegungen.\n\n\nViel Erfolg!';
    else
        txt = 'Zur Erinnerung:\n\nWenn du ein goldenes Schiff triffst, verdienst du 20 CENT.\n\nBei einem Schiff mit Steinen an Bord verdienst du NICHTS.\n\n\n\n\n\nBitte achte auch wieder auf Blinzler und deine Augenbewegungen.\n\n\nViel Erfolg!';
    end
    
    BigScreen(taskParam, txtPressEnter, header, txt)
    
end

% This functions runs the main task.
condition = 'main';
if Subject.cBal == '1'
    VolaIndication(taskParam, txtLowVola, txtPressEnter) % Low sigma.
    SendTrigger(taskParam, taskParam.triggers.blockLVTrigger) % Trigger.
    [taskDataLV, DataLV] = BattleShipsMain(taskParam, vola(1), condition, Subject); % Run task (low sigma).
    VolaIndication(taskParam, txtHighVola, txtPressEnter) % High sigma.
    SendTrigger(taskParam, taskParam.triggers.blockHVTrigger) % Trigger.
    [taskDataHV, DataHV] = BattleShipsMain(taskParam, vola(2), condition, Subject); % Run task (high sigma).
else
    VolaIndication(taskParam, txtHighVola, txtPressEnter) % High sigma.
    SendTrigger(taskParam, taskParam.triggers.blockHVTrigger) % Trigger.
    [taskDataHV, DataHV] = BattleShipsMain(taskParam, vola(2), condition, Subject); % Run task (high sigma).
    VolaIndication(taskParam, txtLowVola, txtPressEnter) % Low sigma.
    SendTrigger(taskParam, taskParam.triggers.blockLVTrigger) % Trigger.
    [taskDataLV, DataLV] = BattleShipsMain(taskParam, vola(1), condition, Subject); % Run task (low sigma).
end


% Control trials: this task requires a learning rate = 1
BattleShipsControlInstructions(taskParam) % Run instructions.

KbReleaseWait();

% Trigger: control block.
SendTrigger(taskParam, taskParam.triggers.blockControlTrigger)



% This function runs the control trials
condition = 'control';
if Subject.cBal == '1'
    VolaIndication(taskParam, txtLowVola, txtPressEnter) % Low sigma.
    SendTrigger(taskParam, taskParam.triggers.blockLVTrigger) %Trigger.
    [taskDataControlLV, DataControlLV] = BattleShipsMain(taskParam, vola(1), condition, Subject); % Run task (low sigma).
    VolaIndication(taskParam, txtHighVola, txtPressEnter) % High sigma.
    SendTrigger(taskParam, taskParam.triggers.blockLVTrigger) %Trigger.
    [taskDataControlHV, DataControlHV] = BattleShipsMain(taskParam, vola(2), condition, Subject); %Run task (high sigma).
else
    VolaIndication(taskParam, txtHighVola, txtPressEnter) % High sigma.
    SendTrigger(taskParam, taskParam.triggers.blockHVTrigger) %Trigger.
    [taskDataControlHV, DataControlHV] = BattleShipsMain(taskParam, vola(2), condition, Subject); %Run task (high sigma).
    VolaIndication(taskParam, txtLowVola, txtPressEnter) % Low sigma.
    SendTrigger(taskParam, taskParam.triggers.blockLVTrigger) %Trigger.
    [taskDataControlLV, DataControlLV] = BattleShipsMain(taskParam, vola(1), condition, Subject); % Run task (low sigma).
end

totWin = DataLV.accPerf(end) + DataHV.accPerf(end) + DataControlLV.accPerf(end) + DataControlHV.accPerf(end);

while 1
    
    header = 'Ende der Aufgabe!';
    txt = sprintf('Vielen Dank für deine Teilnahme\n\n\nInsgesamt hast du %.2f Euro gewonnen', totWin);
    
    Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0, taskParam.gParam.screensize(4)*0.16, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.16, 5);
    Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0, taskParam.gParam.screensize(4)*0.8, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.8, 5);
    Screen('FillRect', taskParam.gParam.window, [224, 255, 255], [0, (taskParam.gParam.screensize(4)*0.16)+3, taskParam.gParam.screensize(3), (taskParam.gParam.screensize(4)*0.8)-2]);
    Screen('TextSize', taskParam.gParam.window, 50);
    DrawFormattedText(taskParam.gParam.window, header, 'center', taskParam.gParam.screensize(4)*0.1);
    Screen('TextSize', taskParam.gParam.window, 30);
    DrawFormattedText(taskParam.gParam.window, txt, 'center', 'center');
    Screen('Flip', taskParam.gParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode) == taskParam.keys.s
        break
    end
end

%% Save data.

if askSubjInfo == true && runIntro == true
    
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
    save(fullfile(savdir,fName),fNameDataPracticeLV, fNameDataPracticeHV, fNameDataLV, fNameDataHV, fNameDataControlLV, fNameDataControlHV);
    
elseif askSubjInfo == true && runIntro == false
    
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

%% End of task.

% Allow input again.
ListenChar();
ShowCursor;

% Close screen.
Screen('CloseAll');
