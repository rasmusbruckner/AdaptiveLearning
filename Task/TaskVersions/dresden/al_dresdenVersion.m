function Data = al_dresdenVersion(taskParam, unitTest)
%AL_DRESDENVERSION
%
% XX
% Also refer to unit and integration tests
% Contributors

% Initialize task
% ----------------

if ~unitTest
    clear vars
    unitTest = false;
end

trials = taskParam.gParam.trials;
askSubjInfo = taskParam.gParam.askSubjInfo;
%randomize = taskParam.gParam.randomize;
randomize = false;
taskType = taskParam.gParam.taskType;
screenNumber = taskParam.gParam.screenNumber;
debug = taskParam.gParam.debug;

% Check number of trials
if  (trials > 1 && mod(trials, 2)) == 1
    msgbox('All trials must be even or equal to 1!');
    return
end

% Check number of trials
% if  (trials > 1 && mod(trials, 2)) == 1
%     msgbox('All trials must be even or equal to 1!');
%     return
% end

% Save directory for different computers that were used in the past
cd('~/Dropbox/AdaptiveLearning/DataDirectory');

% Reset clock
%a = clock;
%rand('twister', a(6).*10000);

% % User Input
% % ----------
% % If no user input requested
% if askSubjInfo == false
%     
%     ID = '99999';
%     age = '99';
%     sex = 'm/w';
%     cBal = 1;
%     reward = 1;
%     
%     
%     group = '1';
%     subject = struct('ID', ID, 'age', age, 'sex', sex, 'group', group, 'cBal', cBal, 'rew', reward, 'date', date, 'session', '1');
%     
%     
%     % If user input requested
% elseif askSubjInfo == true
%    
%     
%     prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal:', 'Reward:'};
%     
%     
%     name = 'SubjInfo';
%     numlines = 1;
%     
%     % You can choose to randomize input, i.e., random cBal
%     if randomize
%             
%         cBal = num2str(randi(6));
%         reward = num2str(randi(2));
% 
%     else
%         cBal = '1';
%         reward = '1';
%         
%     end
%     
%     % Specify default that is shown on screen
%     defaultanswer = {'99999','99', '1', 'm', cBal, reward};
%         
%     
%     % Add information that is not specified by user
%     subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
%         
%     subjInfo{7} = date;
%         
%     
%     % Check if user input makes sense
%     % -------------------------------
%     % Check ID
%     if numel(subjInfo{1}) < 5 ...
%             || numel(subjInfo{1}) > 5
%         msgbox('ID: must consist of five numbers!');
%         return
%     end
%     
%     % Check group and session 
%     if subjInfo{3} ~= '1' && subjInfo{3} ~= '2'
%         msgbox('Group: "1" or "2"?');
%         return
%     end
%            
%     % Check sex
%     if subjInfo{4} ~= 'm' && subjInfo{4} ~= 'f'
%         msgbox('Sex: "m" or "f"?');
%         return
% 
%     end
% 
%     % Check cBal   
%     if subjInfo{5} ~= '1' && subjInfo{5} ~= '2' && subjInfo{5} ~= '3' && subjInfo{5} ~= '4' && subjInfo{5} ~= '5' && subjInfo{5} ~= '6'
%         msgbox('cBal: 1, 2, 3, 4, 5 or 6?');
%         return
%     end
% 
% 
%     % Check reward
%     if subjInfo{6} ~= '1' && subjInfo{6} ~= '2'
%         msgbox('Reward: 1 or 2?');
%         return
%     end
%     
%     
%     % Put all relevant subject info in structure
%     % ------------------------------------------
%     subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(4), 'group', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))), 'rew',...
%         str2double(cell2mat(subjInfo(6))), 'date', subjInfo(7), 'session', '1');
% 
%     
%     % Check if ID exists in save folder
%     checkIdInData = dir(sprintf('*%s*', num2str(cell2mat((subjInfo(1))))));
% 
%     
%     fileNames = {checkIdInData.name};
%     
%     if  ~isempty(fileNames)
%         msgbox('Diese ID wird bereits verwendet!');
%         return
%     end
% end
%     
    
%     % Deal with psychtoolbox warnings
%     Screen('Preference', 'VisualDebugLevel', 3);
%     Screen('Preference', 'SuppressAllWarnings', 1);
%     Screen('Preference', 'SkipSyncTests', 2);
%     
%     % Get screen properties
%     screensize = get(0,'MonitorPositions');
%     screensize = screensize(screenNumber, :);
%     screensizePart = screensize(3:4);
%     zero = screensizePart / 2;
%     [window.onScreen, windowRect, textures] = OpenWindow(debug, screenNumber);
%     [window.screenX, window.screenY] = Screen('WindowSize', window.onScreen);
%     window.centerX = window.screenX * 0.5; % center of screen in X direction
%     window.centerY = window.screenY * 0.5; % center of screen in Y direction
%     window.centerXL = floor(mean([0 window.centerX])); % center of left half of screen in X direction
%     window.centerXR = floor(mean([window.centerX window.screenX])); % center of right half of screen in X direction
%     
% 
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
    
    % Start time for triggers etc.
    ref = GetSecs;
    
        %taskParam.timing.ref = ref;
        % ---------------------------------------------
    % Create object instance with timing parameters
    % ---------------------------------------------
    
    timingParam = al_timing();
    timingParam.cannonBallAnimation = 1.5;
    
    % This is a reference timestamp at the start of the experiment.
    % This is not equal to the first trial or so. So be carful when using
    % EEG or pupillometry and make sure the reference is specified as desired.
    timingParam.ref = GetSecs();

%    taskParam.gParam.screensize = screensize;
%    taskParam.display.zero = zero;
 %   taskParam.gParam.window = window;
  %  taskParam.gParam.windowRect = windowRect;
    % taskParam.gParam.showTickmark = showTickmark;
    taskParam.circle.cannonEndRect = [0 0 taskParam.circle.cannonEndDiam taskParam.circle.cannonEndDiam];
    
    
    % Circle XX
%     taskParam.circle.centBoatRect = CenterRect(taskParam.circle.boatRect, windowRect);
%     taskParam.circle.predCentSpotRect = CenterRect(taskParam.circle.predSpotRect, windowRect);
%     taskParam.circle.outcCentRect = CenterRect(taskParam.circle.outcRect, windowRect);
%     taskParam.circle.outcCentSpotRect = CenterRect(taskParam.circle.outcRect, windowRect);
%     taskParam.circle.cannonEndCent = CenterRect(taskParam.circle.cannonEndRect, windowRect);
%     taskParam.circle.centSpotRectMean = CenterRect(taskParam.circle.spotRectMean,windowRect);
    
    
    % Parameters related to keyboard
    % ------------------------------
    KbName('UnifyKeyNames')
    taskParam.fieldNames = fieldNames;  
%    taskParam.textures = textures;  
    %taskParam.unitTest = unitTest; 
    
    % class(taskParam)
    taskParam.subject = subject;
    
    % Condition-object initialization
    % -------------------------------
    cond_init.txtPressEnter = taskParam.strings.txtPressEnter;
    cond_init.runIntro = taskParam.gParam.runIntro;
    cond_init.unitTest = unitTest;
    cond_init.taskType = taskType;
    cond_init.cBal = cBal;
    cond_init.concentration = taskParam.gParam.concentration; 
    cond_init.haz = taskParam.gParam.haz;
    %cond_init.testDay = testDay;
    cond_init.showTickmark = taskParam.gParam.showTickmark;
    
    % Condition-object instance
    % --------------------------
    
    
      % todo: init anpassen dass für arc spezifisch ist. 
    cond = al_dresden_conditions(cond_init);
    
    % hier noch comments!
    
    if subject.cBal == 1
        %DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
         %  header, testDay, cBal, showTickmark);
        cond = cond.MainCondition(taskParam, subject);
        DataMain = cond.DataMain;
        %taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam,
        %debug, unitTest);
        cond = cond.FollowOutcomeCondition(taskParam, subject);
        DataFollowOutcome = cond.DataFollowOutcome;
        %taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        cond = cond.FollowCannonCondition(taskParam, subject);
        DataFollowCannon = cond.DataFollowCannon;
        
    elseif subject.cBal == 2
        
        DataMain = cond.MainCondition(runIntro, unitTest, taskType,subject, taskParam, haz, concentration, txtPressEnter,...
            header, testDay, cBal, showTickmark);
        taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        DataFollowCannon = cond.FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        DataFollowOutcome = cond.FollowOutcomeCondition;
        
    elseif subject.cBal == 3
        
        DataFollowOutcome = cond.FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
            header, testDay, cBal, showTickmark);
        taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        DataFollowCannon = cond.FollowCannonCondition;
        
    elseif subject.cBal == 4
        
        DataFollowCannon = cond.FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
            header, testDay, cBal, showTickmark);
        taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        DataFollowOutcome = cond.FollowOutcomeCondition;
        
    elseif subject.cBal == 5
        
        DataFollowOutcome = cond.FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        DataFollowCannon = cond.FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
            header, testDay, cBal, showTickmark);
        
    elseif subject.cBal == 6
        
        DataFollowCannon = cond.FollowCannonCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        DataFollowOutcome = cond.FollowOutcomeCondition;
        taskParam.gParam.window = CloseScreenAndOpenAgain(taskParam, debug, unitTest);
        DataMain = cond.MainCondition(runIntro, unitTest, taskType, subject, taskParam, haz, concentration, txtPressEnter,...
            header, testDay, cBal, showTickmark);
        
    end
    
    % Translate performance into monetary reward
    % ------------------------------------------
    
    totWin = DataFollowOutcome.accPerf(end) + DataMain.accPerf(end) + DataFollowCannon.accPerf(end);
    
    % Combine data in one structure
    % -----------------------------

    Data.DataMain = DataMain;
    Data.DataFollowOutcome = DataFollowOutcome;
    Data.DataFollowCannon = DataFollowCannon;

    % End of task
    % -----------
    al_endTask(taskType, taskParam, taskParam.strings.textSize, totWin, subject)
    ListenChar();
    ShowCursor;
    Screen('CloseAll');
    
    % Inform user about timing
    sprintf('total time: %.1f minutes', str2mat((GetSecs - ref)/60))
    
end






