%%% adaptiveLearning EEG Task: BattleShips %%%

% BattleShips in an adaptive learning EEG task for investigating belief
% updating in dynamical environments with systematic (hazardRate)
% and random changes (sigma).

% Outcomes are presented on a circle which is expressed in 360 degrees.

% The function GenerateOutcomes generates outcomes that are centerend
% around the mean of a normal distribution (distMean) with
% standard deviation = sigma.

clear all

%% Set parameters.

runIntro = false;   % Run the intro with practice trials?
askSubjInfo = true; % Do you want some basic demographic subject variables?
fSendTrigger = 'sendTrigger'; sendTrigger = false; % Do you want to send triggers?
fComputer = 'computer'; computer = 'Macbook'; % On which computer do you run the task? Macbook or Humboldt?
fTrials = 'trials'; trials = 5; % Number of trials per (sigma-)condition.
fPractTrials = 'practTrials'; practTrials = 20; % Number of practice trials per condition.
fContTrials = 'contTrials'; contTrials = 1; % Number of control trials.
fHazardRate = 'hazardRate'; hazardRate = .4; % Rate of change-points.
sigma = [25 35]; % SD's of distribution.
fSafe = 'safe'; safe = 3; % How many guaranteed trials without change-point.

if isequal(computer, 'Macbook')

    savdir = '/Users/Bruckner/Documents/MATLAB/AdaptiveLearning/DataDirectory';

elseif isequal(computer, 'Humboldt')

    savdir = 'D:\!EXP\AdaptiveLearning\DataDirectory';

end
%% User Input.

if askSubjInfo == true
    prompt = {'ID:','Alter:', 'Geschlecht:', 'cBal'};
    name = 'SubjInfo';
    numlines = 1;
    defaultanswer = {'9999','99', 'M', '1'};
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
    subjInfo{5} = datestr(today);
    
    % Filenames.
    fname = sprintf('BattleShips_%s.mat', num2str(cell2mat((subjInfo(1)))));
    fNameDataLS = sprintf('DataLS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataHS = sprintf('DataHS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataPracticeLS = sprintf('DataPracticeLS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataPracticeHS = sprintf('DataPracticeHS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControlLS = sprintf('DataControlLS_%s', num2str(cell2mat((subjInfo(1)))));
    fNameDataControlHS = sprintf('DataControlHS_%s', num2str(cell2mat((subjInfo(1)))));

    fID = 'ID';
    fAge = 'age';
    fSex = 'sex';
    fCBal = 'cBal';
    fDate = 'date';
    
    % Struct with demographic subject variables.
    Subject = struct(fID, subjInfo(1), fAge, subjInfo(2), fSex, subjInfo(3), fCBal, subjInfo(4), fDate, subjInfo(5));
    
    % Make sure that no ID is used twice.
    if exist(fname, 'file') == 2
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

% Get screensize.
screensize = get(0,'MonitorPositions');

% Open a new window.
[ window, windowRect ] = Screen('OpenWindow', 0, [], []);

%% Task parameters.

fWindow = 'window';
fWindowRect = 'windowRect';

%Radius of the spots.
fPredSpotRad =  'predSpotRad'; predSpotRad = 15; % Prediction spot (red).
fOutcRad = 'outcRad'; outcRad = 30; % Outcome spot (green).
fMeanPoint = 'meanRad'; meanPoint = 1; % Point for radar hand.
fRotationRad = 'rotationRad'; rotationRad = 100; % Rotation Radius.

%Diameter of the spots.
fPredSpotDiam = 'predSpotDiam'; predSpotDiam = predSpotRad * 2; % Diameter of prediction spot.
fOutcSpotDiam = 'outcDiam'; outcDiam = outcRad * 2; % Diameter of outcome.
fSpotDiamMean = 'spotDiamMean'; spotDiamMean = meanPoint * 2; % Size of Radar hand.

%Position of the spots and the boats.
fPredSpotRect = 'predSpotRect'; predSpotRect = [0 0 predSpotDiam predSpotDiam]; % Prediction spot position.
fOuctcRect = 'outcRect'; outcRect = [0 0 outcDiam outcDiam]; % Outcome position.
fSpotRectMean = 'spotRectMean'; spotRectMean =[0 0 spotDiamMean spotDiamMean]; % Radar Hand position.
fBoatRect = 'boatRect'; boatRect = [0 0 60 60]; % Boat position.

% Center the objects.
fCentBoatRect = 'centBoatRect'; centBoatRect = CenterRect(boatRect, windowRect); % Center boat
fPredCentSpotRect = 'predCentSpotRect'; predCentSpotRect = CenterRect(predSpotRect, windowRect);% Center the prediction spot.
fOutcCentRect = 'outcCentRect'; outcCentRect = CenterRect(outcRect, windowRect); % Center the outcome.
fCentSpotRectMean = 'centSpotRectMean'; centSpotRectMean = CenterRect(spotRectMean,windowRect); % Center radar hand.

% Rotation angle of prediction spot.
fUnit = 'unit'; unit = 2*pi/360; % This expresses the circle (2*pi) as a fraction of 360 degrees.
fInitialRotAngle = 'initialRotAngle'; initialRotAngle = 270*unit; % The initial rotation angle (on top of circle).
fRotAngle = 'rotAngle'; rotAngle = initialRotAngle; % Rotation angle when prediction spot is moved.

% Set key names.
KbName('UnifyKeyNames');
fRightKey = 'rightKey'; rightKey = KbName('RightArrow');
fLeftKey = 'leftKey'; leftKey = KbName('LeftArrow');
fSpace = 'space'; space = KbName('Space');

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
fBlockLSTrigger = 'blockLSTrigger'; blockLSTrigger = 10; % Block with low sigma.
fBlockHSTrigger = 'blockHSTrigger'; blockHSTrigger = 11; % Block with high sigma.
fBlockControlTrigger = 'blockControlTrigger'; blockControlTrigger = 12; % Control block.


% Save task parameters in structure
taskParam = struct(fSendTrigger, sendTrigger, fComputer, computer, fTrials, trials, fPractTrials, practTrials, fContTrials, contTrials,...
    fHazardRate, hazardRate, fSafe, safe, fWindow, window, fWindowRect, windowRect, fPredSpotRad, predSpotRad,...
    fOutcRad, outcRad, fMeanPoint, meanPoint, fRotationRad, rotationRad, fPredSpotDiam, predSpotDiam, fOutcSpotDiam,...
    outcDiam, fSpotDiamMean, spotDiamMean, fPredSpotRect, predSpotRect, fOuctcRect, outcRect, fSpotRectMean, spotRectMean,...
    fBoatRect, boatRect, fCentBoatRect, centBoatRect, fPredCentSpotRect, predCentSpotRect, fOutcCentRect, outcCentRect, fCentSpotRectMean,...
    centSpotRectMean, fUnit, unit, fInitialRotAngle, initialRotAngle, fRotAngle, rotAngle, fRightKey, rightKey, fLeftKey, leftKey,...
    fSpace, space, fSampleRate, sampleRate, fPort, port, fStartTrigger, startTrigger, fTrialOnset, trialOnsetTrigger,...
    fPredTrigger, predTrigger, fBaseline1Trigger, baseline1Trigger, fOutcomeTrigger, outcomeTrigger, fBaseline2Trigger, baseline2Trigger,...
    fBoatTrigger, boatTrigger, fBaseline3Trigger, baseline3Trigger, fBlockLSTrigger, blockLSTrigger, fBlockHSTrigger, blockHSTrigger,...
    fBlockControlTrigger, blockControlTrigger);


if isequal(taskParam.computer,'Humboldt')
    enter = 13;
    s = 83;
else
    enter = 40;
     s = 22;
end



%% Run task.

if taskParam.sendTrigger == true
    lptwrite(taskParam.port,0); % Set port to 0.
end

% Set text parameters.
Screen('TextFont', taskParam.window, 'Arial');
Screen('TextSize', taskParam.window, 30);

KbReleaseWait()


% cBal 1 first.
if Subject.cBal == '1'
    
    % Run intro with practice trials if true.
    if runIntro == true
        
        BattleShipsInstructions(taskParam, sigma(1), Subject.cBal); % Function for instructions.
        
        while 1
            txtLowNoise = 'Leichter Seegang';
            txtPressEnter = 'Weiter mit Enter';
            DrawFormattedText(taskParam.window, txtLowNoise, 'center', 'center');
            DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if find(keyCode)==enter
                    break
                end
            end
        end
        
        % Function for main task that is used for practice.
        condition = 'practice';
        [taskDataPracticeLS, DataPracticeLS] = BattleShipsMain(taskParam, sigma(1), condition, Subject);
        
        while 1
            txtHighNoise = 'Starker Seegang';
            txtPressEnter = 'Weiter mit Enter';
            DrawFormattedText(taskParam.window, txtHighNoise, 'center', 'center');
            DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
            Screen('Flip', taskParam.window);
            
            
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if find(keyCode)==enter
                    break
                end
            end
        end
        
        % Function for main task that is used for practice.
        [taskDataPracticeHS, DataPracticeHS] = BattleShipsMain(taskParam, sigma(2), condition, Subject);
        
        
        % End of practice blocks. This part makes sure that you start your EEG setup!
        while 1
            
            if isequal(taskParam.computer, 'Humboldt')
                txtScreen23 = 'Du hast die ‹bungsphase erfolgreich abgeschlossen.\n\n\nJetzt geht es mit dem Hauptteil weiter. Die Aufgabe ist die gleiche\n\nwie in der letzten ‹bung. Zur Erinnerung: In den meisten F‰llen\n\nmusst du die Schiffsposition selber herausfinden. Nur in wenigen\n\nF‰llen zeigt dir die Radarnadel wo sich das Schiff ungef‰hr aufh‰lt,\n\ndies hilft dir das Schiff zu treffen.\n\n\nWenn du ein goldenes Schiff triffst verdienst du 20 CENT.\n\nWenn du ein bronzenes Schiff abschieﬂt verdienst du 10 CENT.\n\nBei einem Schiff mit Steinen an Board verdienst du NICHTS.\n\n\nViel Erfolg!';
            else
                txtScreen23 = 'Du hast die ‹bungsphase erfolgreich abgeschlossen.\n\n\nJetzt geht es mit dem Hauptteil weiter. Die Aufgabe ist die gleiche wie in der\n\nletzten ‹bung. Zur Erinnerung: In den meisten F‰llen musst du die\n\nSchiffsposition selber herausfinden. Nur in wenigen F‰llen zeigt dir die\n\nRadarnadel wo sich das Schiff ungef‰hr aufh‰lt, dies hilft dir das Schiff zu treffen.\n\n\nWenn du ein goldenes Schiff triffst verdienst du 20 CENT.\n\nWenn du ein bronzenes Schiff abschieﬂt verdienst du 10 CENT.\n\nBei einem Schiff mit Steinen an Bord verdienst du NICHTS.\n\n\nViel Erfolg!';
            end
            
            txtStartMain = 'Der Versuchsleiter startet jetzt die EEG-Aufzeichnung und die Aufgabe';
            Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/11, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 5)] ) %(screensize(4) / 4)
            DrawFormattedText(taskParam.window,txtScreen23, 200, 100);
            DrawFormattedText(taskParam.window,txtStartMain,'center',screensize(4)*0.9);
            Screen('Flip', taskParam.window);
            
           
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if find(keyCode)==s
                    break
                end
            end
        end
        
    end
    
    
    % Run main task with different noise conditions
    while 1
        txtLowNoise = 'Leichter Seegang';
        txtPressEnter = 'Weiter mit Enter';
        DrawFormattedText(taskParam.window, txtLowNoise, 'center', 'center');
        DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    
    % Trigger: block 1.
    if taskParam.sendTrigger == true
        lptwrite(taskParam.port, taskParam.blockLSTrigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    % This functions runs the main task.
    condition = 'main';
    [taskDataLS, DataLS] = BattleShipsMain(taskParam, sigma(1), condition, Subject);
    
    while 1
        txtHighNoise = 'Starker Seegang';
        DrawFormattedText(taskParam.window, txtHighNoise, 'center', 'center');
        DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    
    
    % Trigger: block 2.
    if taskParam.sendTrigger == true
        lptwrite(taskParam.port, taskParam.blockHSTrigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    % This functions runs the main task.
    [taskDataHS, DataHS] = BattleShipsMain(taskParam, sigma(2), condition, Subject);
    
    
    % Control trials: this task requires a learning rate = 1
    BattleShipsControlInstructions(taskParam) % Run instructions.
    
    % Trigger: control block.
    if taskParam.sendTrigger
        lptwrite(taskParam.port, taskParam.blockControlTrigger);
        WaitSecs(1/taskParam.sampleRate);
        lptwrite(taskParam.port,0) % Set port to 0.
    end
    
    % This function runs the control trials
    condition = 'control';
    [taskDataControlLS, DataControlLS] = BattleShipsControl(taskParam, sigma(1), condition, Subject);
    
    while 1
        txtBreak = 'Kurze Pause';
        DrawFormattedText(taskParam.window, txtBreak, 'center', 'center');
        DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    
    [taskDataControlHS, DataControlHS] = BattleShipsControl(taskParam, sigma(2), condition, Subject);
    while 1
        txtEnd = 'Ende';
        DrawFormattedText(taskParam.window, txtEnd, 'center', 'center');
        %DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==s
                break
            end
        end
    end
    
    
    % cBal 2 first.
elseif Subject.cBal == '2'
    
    % Run the task with different noise conditions
    while 1
        txtLowNoise = 'Starker Seegang';
        txtPressEnter = 'Weiter mit Enter';
        DrawFormattedText(taskParam.window, txtLowNoise, 'center', 'center');
        DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    
    % Trigger: block 1.
    %   lptwrite(taskParam.port, taskParam.blockHSTrigger);
    %   WaitSecs(1/taskParam.sampleRate);
    %   lptwrite(taskParam.port,0) % Port wieder auf null stellen
    
    [taskDataLS, DataLS] = BattleShipsMain(taskParam, sigma(2), Subject);
    
    
    
    while 1
        txtHighNoise = 'Schwacher Seegang';
        DrawFormattedText(taskParam.window, txtHighNoise, 'center', 'center');
        DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    
    % Trigger: block 2.
    %   lptwrite(taskParam.port, taskParam.blockLSTrigger);
    %   WaitSecs(1/taskParam.sampleRate);
    %   lptwrite(taskParam.port,0) % Port wieder auf null stellen
    
    [taskDataHS, DataHS] = BattleShipsMain(taskParam, sigma(1), Subject);
    
    while 1
        txtControl = 'Zum Abschluss kommt jetzt eine kurze Ged‰chtnisaufgabe. Deine Aufgabe ist es,\n\ndir die Position des Bootes, also des schwarzen Balken, zu merken und den blauen\n\nPunkt daraufhin genau auf diese Position zu steuern.\n\n\n\nBezahlung:\n\n\nGoldenes Boot: Wenn du dir die Position richtig gemerkt hast, bekommst du 20 CENT.\n\n\nBronzenes Boot: Wenn du dir die Postion richtig gemerkt hast, bekommst du 10 CENT.\n\n\nSteine: Wenn du dir die Position richtig gemerkt hast, bekommst du leider nichts.';
        DrawFormattedText(taskParam.window, txtControl, 200, 100);
        DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==40
                break
            end
        end
    end
    
    % Trigger: control block.
    %   lptwrite(taskParam.port, taskParam.blockControlTrigger);
    %   WaitSecs(1/taskParam.sampleRate);
    %   lptwrite(taskParam.port,0) % Port wieder auf null stellen
    
    [taskDataControl, DataControl] = BattleShipsControl(taskParam, sigma(1), Subject);
    
    
    while 1
        txtEnd = 'Ende';
        DrawFormattedText(taskParam.window, txtEnd, 'center', 'center');
        %DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==40
                break
            end
        end
    end
    
end

%% Save data.


if askSubjInfo == true && runIntro == true
    
    DataPracticeLS = catstruct(Subject, DataPracticeLS);
    DataPracticeHS = catstruct(Subject, DataPracticeHS);
    DataLS = catstruct(Subject, DataLS);
    DataHS = catstruct(Subject, DataHS);
    DataControlLS = catstruct(Subject, DataControlLS);
    DataControlHS = catstruct(Subject, DataControlHS);
    
    assignin('base',['DataPracticeLS_' num2str(cell2mat((subjInfo(1))))],DataPracticeLS)
    assignin('base',['DataPracticeHS_' num2str(cell2mat((subjInfo(1))))],DataPracticeHS)
    assignin('base',['DataLS_' num2str(cell2mat((subjInfo(1))))],DataLS)
    assignin('base',['DataHS_' num2str(cell2mat((subjInfo(1))))],DataHS)
    assignin('base', ['DataControlLS_' num2str(cell2mat((subjInfo(1))))], DataControlLS)
    assignin('base', ['DataControlHS_' num2str(cell2mat((subjInfo(1))))], DataControlHS)
    save(fullfile(savdir,fname),fNameDataPracticeLS, fNameDataPracticeHS, fNameDataLS, fNameDataHS, fNameDataControlLS, fNameDataControlHS);
    
elseif askSubjInfo == true && runIntro == false
    
    DataLS = catstruct(Subject, DataLS);
    DataHS = catstruct(Subject, DataHS);
    DataControlLS = catstruct(Subject, DataControlLS);
    DataControlHS = catstruct(Subject, DataControlHS);
    assignin('base',['DataLS_' num2str(cell2mat((subjInfo(1))))],DataLS)
    assignin('base',['DataHS_' num2str(cell2mat((subjInfo(1))))],DataHS)
    assignin('base', ['DataControlLS_' num2str(cell2mat((subjInfo(1))))], DataControlLS)
    assignin('base', ['DataControlHS_' num2str(cell2mat((subjInfo(1))))], DataControlHS)
    save(fullfile(savdir,fname), fNameDataLS, fNameDataHS, fNameDataControlLS, fNameDataControlHS);
    
end

%% End of task.

%allow input again.
ListenChar();
ShowCursor;

% Close screen.
Screen('CloseAll');
