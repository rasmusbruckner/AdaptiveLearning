 function Data = AdaptiveLearning(unitTest)

% This function is the master function for the cannon task
% ------------------------------------------------------------------------- 
 
% You can choose between four task types: 
%   "Dresden version":      Change point task with two control conditions
%                               - learning rate = 1
%                               - learning rate = 0
%   "Oddball version":      Change point task with oddball condition
%   "Reversal version":     Change point task with occasional reversals to 
%                           previous change point location
%   "Chinese restaurant":   Change point task with multiple contexts

% -------------------------------------------------------------------------                            
%  Current task condition (condition):
%   - shield
%       - oddballPractice
%       - oddballPractice_NoOddball
%       - main
%       - mainPractice
%   - followOutcome
%       - followOutcomePractice
%   - followCannon
%       - followCannonPractice
%
%   Current practice conditions (whichPractice)
%       - oddballPractice
%       - cpPractice
%       - followOutcomePractice
%       - followCannonPractice
% -------------------------------------------------------------------------

% Changes in the task (relative to first data collection at Brown):
% renamed variables:
%   - boatType -> shieldType
%   - sigma -> concentration
%   - vola -> haz
% added trialsS1 = XX, trialsS2S3 = XX;
% -------------------------------------------------------------------------

% 06.05.16 starting to extend the task to include multiple task contexts
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Check whether or not to run a unit test (not yet implemented for context
% task)
% -------------------------------------------------------------------------
if nargin == 0
    unitTest = false;
end

if ~unitTest
    clear all
    unitTest = false;
end

% -------------------------------------------------------------------------
% Initialize task
% -------------------------------------------------------------------------

% indentifies your machine. If you have internet!
computer = identifyPC;
%computer = 'Macbook'

% Dresden or Brown version?
% Choose task type: 
%   - 'oddball'
%   - 'dresden' 
%   - 'reversal'
%   - 'chinese'
taskType = 'reversal';


if strcmp(taskType, 'dresden')
    
    % Dresden
    trials = 2; % 240
    controlTrials = 1; % 120
    concentration = [12 12 99999999];
    DataFollowOutcome = nan;
    DataFollowCannon = nan;
    textSize = 19;
    
    % Check number of trials in each condition
    if  (trials > 1 && mod(trials, 2)) == 1 || (controlTrials > 1 && mod(controlTrials, 2) == 1)
        msgbox('All trials must be even or equal to 1!');
        return
    end
elseif strcmp(taskType, 'oddball')
    
    % Brown
    %% How many trials in first session?
    trialsS1 = 2; % 40
    %% How many trials in second and third session?
    trialsS2S3 = 2; % 240
    controlTrials = nan;
    concentration = [10 12 99999999];
    DataOddball = nan;
    textSize = 30;
    
elseif strcmp(taskType, 'reversal')
    
    trials = 100;
    controlTrials = nan;
    concentration = [10 12 99999999];
    DataOddball = nan;
    textSize = 19;
    
elseif strcmp(taskType, 'chinese')
    
end

runIntro = false;
askSubjInfo = true;
sendTrigger = false;
randomize = false;
shieldTrials = 1; % 4
practTrials = 1; % 20
blockIndices = [1 60 120 180];
haz = [.25 1 0];
oddballProb = [.25 0];
reversalProb = [.5 0];
driftConc = [30 99999999];
safe = [3 0];
rewMag = 0.1;
jitter = 0.2;
practiceTrialCriterion = 10;
debug = false;

% Savedirectory
if isequal(computer, 'Macbook')
    cd('/Users/Bruckner/Dropbox/MATLAB/AdaptiveLearning/DataDirectory');
elseif isequal(computer, 'Dresden')
    cd('C:\\Users\\TU-Dresden\\Documents\\MATLAB\\AdaptiveLearning\\DataDirectory');
elseif isequal(computer, 'Brown')
    cd('C:\Users\lncc\Dropbox\CannonDrugStudy\data');
end

% -------------------------------------------------------------------------
% User Input
% -------------------------------------------------------------------------

a = clock;
rand('twister', a(6).*10000);

if askSubjInfo == false
    
    ID = '99999';
    age = '99';
    sex = 'm/w';
    cBal = 1;
    reward = 1;
    
    if ~oddball || strcmp(taskType, 'dresden')
        group = '1';
        Subject = struct('ID', ID, 'age', age, 'sex', sex, 'group', group, 'cBal', cBal, 'rew', reward, 'date', date, 'session', '1');
    elseif oddball || strcmp(taskType, 'oddball')
        session = '1';
        Subject = struct('ID', ID, 'age', age, 'sex', sex, 'session', session, 'cBal', cBal, 'rew', reward, 'date', date);
    end
    
elseif askSubjInfo == true
   
    if strcmp(taskType, 'dresden')
        prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal', 'Reward'};
    elseif strcmp(taskType, 'oddball')
        prompt = {'ID:','Age:', 'Session:', 'Sex:', 'cBal', 'Reward'}; 
    elseif isequal(taskType, 'reversal') || isequal(taskType, 'chinese')
        prompt = {'ID:','Age:', 'Sex:', 'cBal', 'Reward'};
    end
    
    name = 'SubjInfo';
    numlines = 1;
    
    if randomize
        
        if ~oddball || strcmp(taskType, 'dresden')
            cBal = num2str(round(unifrnd(1,6)));
        elseif oddball || strcmp(taskType, 'oddball')
            cBal = num2str(round(unifrnd(1,2)));
        end
        
        reward = num2str(round(unifrnd(1,2)));
        defaultanswer = {'99999','99', '1', 'm', cBal, reward};
        
    else
        defaultanswer = {'99999','99', '1', 'm', '1', '1'};
    end
    
    
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
    if strcmp(taskType, 'dresden') || strcmp(taskType, 'oddball') 
        subjInfo{7} = date;
    else 
        subjInfo{6} = date;

    end
    
    if numel(subjInfo{1}) < 5 || numel(subjInfo{1}) > 5
        msgbox('ID: must consist of five numbers!');
        return
    end
    
    if strcmp(taskType, 'dresden') 
        if subjInfo{3} ~= '1' && subjInfo{3} ~= '2'    
            msgbox('Group: "1" or "2"?');
            return
        end
        
    elseif strcmp(taskType, 'oddball')
        if subjInfo{3} ~= '1' && subjInfo{3} ~= '2' && subjInfo{3} ~= '3'
            msgbox('Session: "1", "2" or "3"?');
            return
        end
        
    end
    
    if strcmp(taskType, 'dresden') || strcmp(taskType, 'oddball')
        if subjInfo{4} ~= 'm' && subjInfo{4} ~= 'f'
            
            msgbox('Sex: "m" or "f"?');
            return
            
        end
    end
    
    if strcmp(taskType, 'dresden')
        if subjInfo{5} ~= '1' && subjInfo{5} ~= '2' && subjInfo{5} ~= '3'...
                && subjInfo{5} ~= '4' && subjInfo{5} ~= '5' && subjInfo{5} ~= '6'
            msgbox('cBal: 1, 2, 3, 4, 5 or 6?');
            return
        end
    elseif strcmp(taskType, 'oddball')
        if subjInfo{5} ~= '1' && subjInfo{5} ~= '2'
            msgbox('cBal: 1 or 2 ?');
            return
        end
    end
    
    if strcmp(taskType, 'dresden') || strcmp(taskType, 'oddball')
        if subjInfo{6} ~= '1' && subjInfo{6} ~= '2'
            msgbox('Reward: 1 or 2?');
            return
        end
    end
    
    if strcmp(taskType, 'dresden')
        
        Subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex',...
            subjInfo(4), 'group', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))), 'rew',...
            str2double(cell2mat(subjInfo(6))), 'date', subjInfo(7), 'session', '1');
    
    elseif strcmp(taskType, 'oddball')
        
        Subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex',...
            subjInfo(4), 'session', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))), 'rew',...
            str2double(cell2mat(subjInfo(6))), 'date', subjInfo(7));
        
    elseif strcmp(taskType, 'reversal') || strcmp(taskType, 'chinese')
       
        Subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex',...
            subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(4))), 'rew',...
            str2double(cell2mat(subjInfo(5))), 'date', subjInfo(6), 'session', '1');
        
    end
    
    if strcmp(taskType, 'dresden') || strcmp(taskType, 'reversal') || strcmp(taskType, 'chinese')
        checkIdInData = dir(sprintf('*%s*', num2str(cell2mat((subjInfo(1))))));
    elseif strcmp(taskType, 'oddball')
        checkIdInData = dir(sprintf('*%s_session%s*' , num2str(cell2mat((subjInfo(1)))), num2str(cell2mat((subjInfo(3))))));
    end
    
    fileNames = {checkIdInData.name};
    
    if  ~isempty(fileNames);
        if strcmp(taskType, 'dresden')
            msgbox('Diese ID wird bereits verwendet!');
        elseif strcmp(taskType, 'oddball') || strcmp(taskType, 'reversal') || strcmp(taskType, 'chinese')
            msgbox('ID and session have already been used!');
        end
        return
    end
end

if isequal(taskType, 'oddball') && isequal(Subject.session, '1')
    trials = trialsS1;
elseif isequal(taskType, 'oddball') && isequal(Subject.session, '3')
    trials = trialsS2S3;
end

% -------------------------------------------------------------------------
% Initialize task
% -------------------------------------------------------------------------

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

%ID = 'ID';
%age = 'age';
%sex = 'sex';
%rew = 'rew';
%actRew = 'actRew';
%Date = 'Date';
%cond = 'cond';
%trial = 'trial';
%outcome = 'outcome';
%allASS = 'allASS';
%distMean = 'distMean';
%cp = 'cp';
%fTAC = 'TAC'; TAC = fTAC;
%shieldType = 'shieldType';
%catchTrial = 'catchTrial';
%triggers = 'triggers';
%pred = 'pred';
%predErr = 'predErr';
%memErr = 'memErr';
%UP = 'UP';
%hit = 'hit';
%cBal = 'cBal';
%perf = 'perf';
%accPerf = 'accPerf';
%actJitter = 'actJitter';
%block = 'block';
%initiationRTs = 'initiationRTs';
%timestampOnset = 'timestampOnset';
%timestampPrediction = 'timestampPrediction';
%timestampOffset = 'timestampOffset';
%fhazs = 'haz'; hazs = fhazs;
%fOddballProb = 'oddballProb'; %oddballProbs = fOddballProb;
%fDriftConc = 'driftConc'; driftConcentrations = fDriftConc;
%fconcentrations = 'concentration'; concentrations = fconcentrations;
%oddBall = 'oddBall';

% sollte ich wohl irgendwann ersetzen
fieldNames = struct('actJitter', 'actJitter', 'block', 'block',...
    'initiationRTs', 'initiationRTs', 'timestampOnset', 'timestampOnset',...
    'timestampPrediction', 'timestampPrediction', 'timestampOffset',...
    'timestampOffset', 'oddBall', 'oddBall', 'oddballProb',...
    'oddballProb', 'driftConc', 'driftConc', 'allASS', 'allASS', 'ID', 'ID',...
    'concentration', 'concentration', 'age', 'age', 'sex', 'sex', 'rew', 'rew', 'actRew',...
    'actRew', 'date','Date', 'cond', 'cond', 'trial', 'trial', 'outcome', 'outcome',...
    'distMean', 'distMean', 'cp', 'cp', 'haz', 'haz', 'TAC', 'TAC', 'shieldType',...
    'shieldType', 'catchTrial', 'catchTrial', 'triggers', 'triggers', 'pred', 'pred',...
    'predErr', 'predErr', 'memErr', 'memErr', 'UP', 'UP',...
    'hit', 'hit', 'cBal', 'cBal', 'perf', 'perf', 'accPerf', 'accPerf',...
    'reversalProb', 'reversalProb');

if isequal(computer, 'Dresden')
    sentenceLength = 70;
elseif isequal(computer, 'Brown')
    sentenceLength = 75;
else
    sentenceLength = 85;
end
ref = GetSecs;
gParam = struct('taskType', taskType ,'jitter', jitter,...
    'blockIndices', blockIndices, 'ref', ref, 'sentenceLength',...
    sentenceLength, 'driftConc', driftConc,...
    'oddballProb', oddballProb, 'reversalProb', reversalProb,...
    'concetration', concentration, 'haz', haz,...
    'sendTrigger', sendTrigger, 'computer', computer, 'trials',...
    trials, 'shieldTrials', shieldTrials, 'practTrials', practTrials,...
    'controlTrials', controlTrials, 'safe', safe, 'rewMag', rewMag,...
    'screensize', screensize, 'zero', zero,'window', window, fWindowRect,...
    windowRect, 'practiceTrialCriterion',practiceTrialCriterion, 'askSubjInfo',...
    askSubjInfo);

predSpotRad = 10;
shieldAngle = 30;
outcSize = 10;
cannonEnd = 5;
meanPoint = 1;
rotationRad = 150;
predSpotDiam = predSpotRad * 2;
outcDiam = outcSize * 2;
spotDiamMean = meanPoint * 2;
cannonEndDiam = cannonEnd * 2;
predSpotRect = [0 0 predSpotDiam predSpotDiam];
outcRect = [0 0 outcDiam outcDiam];
cannonEndRect = [0 0 cannonEndDiam cannonEndDiam];
spotRectMean = [0 0 spotDiamMean spotDiamMean];
boatRect = [0 0 50 50];
centBoatRect = CenterRect(boatRect, windowRect);
predCentSpotRect = CenterRect(predSpotRect, windowRect);
outcCentRect = CenterRect(outcRect, windowRect);
outcCentSpotRect = CenterRect(outcRect, windowRect);
cannonEndCent = CenterRect(cannonEndRect, windowRect);
centSpotRectMean = CenterRect(spotRectMean,windowRect);

unit = 2*pi/360;
initialRotAngle = 0*unit;
rotAngle = initialRotAngle;

circle = struct('shieldAngle', shieldAngle, 'cannonEndCent',...
    cannonEndCent, 'outcCentSpotRect', outcCentSpotRect, 'predSpotRad',...
    predSpotRad, 'outcSize', outcSize, 'meanRad', meanPoint, 'rotationRad',...
    rotationRad, 'predSpotDiam', predSpotDiam, 'outcDiam',...
    outcDiam, 'spotDiamMean', spotDiamMean, 'predSpotRect', predSpotRect,...
    'outcRect', outcRect, 'spotRectMean', spotRectMean,...
    'boatRect', boatRect, 'centBoatRect', centBoatRect, 'predCentSpotRect',...
    predCentSpotRect, 'outcCentRect', outcCentRect, 'centSpotRectMean',...
    centSpotRectMean, 'unit', unit, 'initialRotAngle', initialRotAngle, 'rotAngle', rotAngle);

gold = [255 215 0];
blue = [0 0 255];
silver = [160 160 160];
green = [0 255 0];
colors = struct('gold', gold, 'blue', blue, 'silver', silver, 'green', green);

KbName('UnifyKeyNames')
rightKey = KbName('j');
leftKey = KbName('f');
delete = KbName('DELETE');
rightArrow = KbName('RightArrow');
leftArrow = KbName('LeftArrow');
rightSlowKey = KbName('h');
leftSlowKey = KbName('g');
space = KbName('Space');

if isequal(computer, 'Macbook')
    enter = 40;
    s = 22;
    t = 23;
    z = 28;
elseif isequal(computer, 'Dresden')
    enter = 13;
    s = 83;
elseif isequal(computer, 'Brown')
    enter = 13;
    s = 83;
end

keys = struct('delete', delete, 'rightKey', rightKey, 'rightArrow',...
    rightArrow, 'leftArrow', leftArrow, 'rightSlowKey', rightSlowKey,...
    'leftKey', leftKey, 'leftSlowKey', leftSlowKey, 'space', space,...
    'enter', enter, 's', s, 't', t, 'z', z);

% -------------------------------------------------------------------------
% Trigger settings
% -------------------------------------------------------------------------

if sendTrigger == true
    config_io;
end

fSampleRate = 'sampleRate'; sampleRate = 512; % Sample rate.
%fPort = 'port'; port = 53328; % LPT port (Dresden)
%LPT1address = hex2dec('E050'); %standard location of LPT1 port % copied from heliEEG_main
fPort = 'port'; port = hex2dec('E050'); % LPT port
triggers = struct(fSampleRate, sampleRate, fPort, port);

% -------------------------------------------------------------------------
% Start task
% -------------------------------------------------------------------------

%IndicateOddball = 'Oddball Task';
%IndicateMain = 'Change Point Task';
IndicateFollowCannon = 'Follow Cannon Task';
IndicateFollowOutcome = 'Follow Outcome Task';
fTxtPressEnter = 'txtPressEnter';

if isequal(taskType, 'oddball')
    header = 'Real Task!';
    txtPressEnter = 'Press Enter to continue';
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
            'aufzusammeln, indem du deinen Korb '...
            'an der Stelle platzierst, wo die letzte Kanonenkugel '...
            'gelandet ist (schwarzer Strich). '...
            'Das Geld für die gesammelten '...
            'Kugeln bekommst du nach der Studie '...
            'ausgezahlt.\n\nViel Erfolg!'];
    end
end

strings = struct(fTxtPressEnter, txtPressEnter);
taskParam = struct('gParam', gParam, 'circle', circle, 'keys', keys,...
    'fieldNames', fieldNames, 'triggers', triggers,...
    'colors', colors, 'strings', strings, 'textures', textures,...
    'unitTest', unitTest);

if isequal(taskType, 'dresden')
    
    % ---------------------------------------------------------------------
    % Dresden version
    % ---------------------------------------------------------------------
    
    if Subject.cBal == 1
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        
    elseif Subject.cBal == 2
        
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        
    elseif Subject.cBal == 3
        
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        
    elseif Subject.cBal == 4
        
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        
    elseif Subject.cBal == 5
        
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        
    elseif Subject.cBal == 6
        
        DataFollowCannon = FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataFollowOutcome = FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain;
        DataMain = MainCondition;
        
    end
    
elseif isequal(taskType, 'oddball')
    
    % ---------------------------------------------------------------------
    % Oddball version
    % ---------------------------------------------------------------------
    
    if Subject.cBal == 1
        DataOddball = OddballCondition;
        DataMain = MainCondition;
    elseif Subject.cBal == 2
        DataMain = MainCondition;
        DataOddball = OddballCondition;
    end
    
elseif isequal(taskType, 'reversal')
    
    % ---------------------------------------------------------------------
    % Reversal version
    % ---------------------------------------------------------------------
    
    DataReversal = ReversalCondition;
    
elseif isequal(taskType, 'chinese')
    
    % ---------------------------------------------------------------------
    % Chinese restaurant version
    % ---------------------------------------------------------------------
    
    
end

% ---------------------------------------------------------------------
% Translate performance into monetary reward
% ---------------------------------------------------------------------
    
%if ~oddball
if isequal(taskType, 'dresden')
    totWin = DataFollowOutcome.accPerf(end) + DataMain.accPerf(end)...
        + DataFollowCannon.accPerf(end);
else
    totWin = DataOddball.accPerf(end) + DataMain.accPerf(end);
end

%if ~oddball
if isequal(taskType, 'dresden')
    Data.DataMain = DataMain;
    Data.DataFollowOutcome = DataFollowOutcome;
    Data.DataFollowCannon = DataFollowCannon;
else
    Data.DataMain = DataMain;
    Data.DataOddball = DataOddball;
end

% ---------------------------------------------------------------------
% End of task
% ---------------------------------------------------------------------

EndOfTask

ListenChar();
ShowCursor;
Screen('CloseAll');

    function DataOddball = OddballCondition
        
        if runIntro && ~unitTest
            if isequal(Subject.session, '1')
                
                Instructions(taskParam, 'oddballPractice', Subject);
                
            elseif isequal(Subject.session, '2') || isequal(Subject.session, '3')
                header = 'Oddball Task';
                txtStartTask = ['This is the beginning of the ODDBALL TASK. During '...
                    'this block you will earn real money for your performance. '...
                    'The trials will be exactly the same as those in the '...
                    'in the last session.\n\nOn each trial a cannon will aim '...
                    'at a location on the circle. On most trials the cannon will '...
                    'fire a ball somewhere near the point of aim. '...
                    'However, on a few trials a ball will be shot '...
                    'from a different cannon that is equally likely to '...
                    'hit any location on the circle. Like in the previous '...
                    'session you will not see the cannon, but still have to infer its '...
                    'aim in order to catch balls and earn money.'];
                feedback = false;
                BigScreen(taskParam, txtPressEnter, header, txtStartTask, feedback);
                
            end
            
        end
        [~, DataOddball] = Main(taskParam, haz(1), concentration(1), 'oddball', Subject);
        
    end

    function DataMain = MainCondition
        
        if runIntro && ~unitTest
            
            if isequal(Subject.session, '1')
                
                if ~oddball
                    if isequal(Subject.group, '1')
                        txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz '...
                            'zusammengefasst wehrst du also die meisten '...
                            'Kugeln ab, wenn du den orangenen Punkt auf die Stelle '...
                            'bewegst, auf die die Kanone zielt. Weil du die '...
                            'Kanone meistens nicht mehr sehen kannst, musst du diese '...
                            'Stelle aufgrund der Position der letzten Kugeln '...
                            'einschätzen. Das Geld für die abgewehrten '...
                            'Kugeln bekommst du nach der Studie '...
                            'ausgezahlt.\n\nViel Erfolg!'];
                    else
                        txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz '...
                            'zusammengefasst wehren Sie also die meisten '...
                            'Kugeln ab, wenn Sie den orangenen Punkt auf die Stelle '...
                            'bewegen, auf die die Kanone zielt. Weil Sie die '...
                            'Kanone meistens nicht mehr sehen können, müssen Sie diese '...
                            'Stelle aufgrund der Position der letzten Kugeln '...
                            'einschätzen. Das Geld für die abgewehrten '...
                            'Kugeln bekommen Sie nach der Studie '...
                            'ausgezahlt.\n\nViel Erfolg!'];
                    end
                end
                
                Instructions(taskParam, 'mainPractice', Subject);
                if ~oddball
                    Main(taskParam, haz(3), concentration(1), 'mainPractice', Subject);
                    feedback = false;
                    BigScreen(taskParam, txtPressEnter, header, txtStartTask, feedback);
                end
            else
                header = 'Change Point Task';
                txt = ['This is the beginning of the CHANGE POINT TASK. During '...
                    'this block you will earn real money for your performance. '...
                    'The trials will be exactly the same as those in the '...
                    'previous session.\n\nOn each trial a cannon will aim '...
                    'at a location on the circle. On all trials the cannon will '...
                    'fire a ball somewhere near the point of aim. '...
                    'Most of the time the cannon will remain aimed at '...
                    'the same location, but occasionally the cannon '...
                    'will be reaimed. Like in the previous '...
                    'session you will not see the cannon, but still '...
                    'have to infer its aim in order to catch balls and earn money.'];
                feedback = false;
                BigScreen(taskParam, txtPressEnter, header, txt, feedback);
            end
            
        elseif isequal(Subject.session, '2') || isequal(Subject.session, '3')
            
            Screen('TextSize', taskParam.gParam.window, 30);
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            VolaIndication(taskParam,txtStartTask, txtPressEnter)
            
        end
        [~, DataMain] = Main(taskParam, haz(1), concentration(1), 'main', Subject);
        
    end

    function DataFollowOutcome = FollowOutcomeCondition
        
        if runIntro && ~unitTest
            if isequal(Subject.group, '1')
                txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz '...
                    'zusammengefasst ist es deine Aufgabe Kanonenkugeln '...
                    'aufzusammeln, indem du deinen Korb '...
                    'an der Stelle platzierst, wo die letzte Kanonenkugel '...
                    'gelandet ist (schwarzer Strich). '...
                    'Das Geld für die gesammelten '...
                    'Kugeln bekommst du nach der Studie '...
                    'ausgezahlt.\n\nViel Erfolg!'];
            else
                txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz '...
                    'zusammengefasst ist es Ihre Aufgabe Kanonenkugeln '...
                    'aufzusammeln, indem Sie Ihren Korb '...
                    'an der Stelle platzieren, wo die letzte Kanonenkugel '...
                    'gelandet ist (schwarzer Strich). '...
                    'Das Geld für die gesammelten '...
                    'Kugeln bekommen Sie nach der Studie '...
                    'ausgezahlt.\n\nViel Erfolg!'];
            end
            Instructions(taskParam, 'followOutcomePractice', Subject)
            Main(taskParam, haz(3),concentration(1), 'followOutcomePractice', Subject);
            feedback = false;
            BigScreen(taskParam, txtPressEnter, header, txtStartTask, feedback);
        else
            Screen('TextSize', taskParam.gParam.window, 30);
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            VolaIndication(taskParam, IndicateFollowOutcome, txtPressEnter)
        end
        [~, DataFollowOutcome] = Main(taskParam, haz(1), concentration(1), 'followOutcome', Subject);
        
    end

    function DataFollowCannon = FollowCannonCondition
        
        if runIntro && ~unitTest
            if isequal(Subject.group, '1')
                txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz '...
                    'zusammengefasst wehrst du die meisten '...
                    'Kugeln ab, wenn du den orangenen Punkt auf die Stelle '...
                    'bewegst, auf die die Kanone zielt (schwarze Nadel). '...
                    'Dieses Mal kannst du die Kanone sehen.\n\nViel Erfolg!'];
            else
                txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz '...
                    'zusammengefasst wehren Sie die meisten '...
                    'Kugeln ab, wenn Sie den orangenen Punkt auf die Stelle '...
                    'bewegen, auf die die Kanone zielt (schwarze Nadel). '...
                    'Dieses Mal können Sie die Kanone sehen.\n\nViel Erfolg!'];
            end
            Instructions(taskParam, 'followCannonPractice', Subject)
            Main(taskParam, haz(3),concentration(1), 'followCannonPractice', Subject);
            feedback = false;
            BigScreen(taskParam, txtPressEnter, header, txtStartTask, feedback);
        else
            Screen('TextSize', taskParam.gParam.window, 30);
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            VolaIndication(taskParam, IndicateFollowCannon, txtPressEnter)
        end
        [~, DataFollowCannon] = Main(taskParam, haz(1), concentration(1), 'followCannon', Subject);
        
    end

    function DataReversal = ReversalCondition
        
        [~, DataReversal] = Main(taskParam, haz(1), concentration(1), 'reversal', Subject);
 
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
        [shieldPic, ~, alpha]  = imread('shield.png');
        shieldPic(:,:,4) = alpha(:,:);
        shieldTxt = Screen('MakeTexture', window, shieldPic);
        [basketPic, ~, alpha]  = imread('basket.png');
        basketPic(:,:,4) = alpha(:,:);
        basketTxt = Screen('MakeTexture', window, basketPic);
        textures = struct('cannonTxt', cannonTxt, 'shieldTxt', shieldTxt,...
            'basketTxt', basketTxt, 'dstRect', dstRect);
        
        %ListenChar(2);
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
            
            %if oddball
            if isequal(taskType, 'oddball')
                header = 'End of task!';
                txt = sprintf('Thank you for participating!\n\n\nYou earned $ %.2f', totWin);
            else
                header = 'Ende des Versuchs!';
                if isequal(Subject.group, '1')
                    txt = sprintf('Vielen Dank für deine Teilnahme!\n\n\nDu hast %.2f Euro verdient', totWin);
                else
                    txt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben %.2f Euro verdient', totWin);
                end
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
            Screen('TextSize', taskParam.gParam.window, textSize);
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

sprintf('total time: %s minutes', (GetSecs - startTime)/60)

end

