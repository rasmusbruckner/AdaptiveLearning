function DataMain = al_ChineseVersion(taskParam, unitTest)
%AL_ARCVERSION
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
randomize = taskParam.gParam.randomize;
taskType = taskParam.gParam.taskType;
screenNumber = taskParam.gParam.screenNumber;
debug = taskParam.gParam.debug;

% Check number of trials
if  (trials > 1 && mod(trials, 2)) == 1
    msgbox('All trials must be even or equal to 1!');
    return
end

% % Check number of trials
% if  (trials > 1 && mod(trials, 2)) == 1
%     msgbox('All trials must be even or equal to 1!');
%     return
% end

% Save directory for different computers that were used in the past
cd('~/Dropbox/AdaptiveLearning/DataDirectory');

% Reset clock
a = clock;
rand('twister', a(6).*10000);

% User Input
% ----------
% If no user input requested
if askSubjInfo == false
    
    ID = '99999';
    age = '99';
    sex = 'm/w';
    cBal = 1;
    reward = 1;
    
    %if strcmp(taskType, 'dresden') || strcmp(taskType, 'chinese') || strcmp(taskType, 'ARC')
        group = '1';
        subject = struct('ID', ID, 'age', age, 'sex', sex, 'group', group, 'cBal', cBal, 'rew', reward, 'date', date, 'session', '1');
%     elseif strcmp(taskType, 'oddball')
%         session = '1';
%         subject = struct('ID', ID, 'age', age, 'sex', sex, 'session', session, 'cBal', cBal, 'rew', reward, 'date', date);
%     end
%     
    % If user input requested
elseif askSubjInfo == true
    
%     if strcmp(taskType, 'dresden')
%         prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal:', 'Reward:'};
%     elseif strcmp(taskType, 'oddball')
%         prompt = {'ID:','Age:', 'Session:', 'Sex:', 'cBal:', 'Reward:'};
%     elseif isequal(taskType, 'reversal')
%         prompt = {'ID:','Age:', 'Sex:','Reward:'};
%     elseif isequal(taskType, 'chinese')
        prompt = {'ID:','Age:', 'Sex:', 'cBal:'};
%     elseif strcmp(taskType, 'ARC')
%         prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal:', 'day:'}; 
%     end
%     
    name = 'SubjInfo';
    numlines = 1;
    
%     % You can choose to randomize input, i.e., random cBal
%     if randomize
%         
%         switch taskType
%             
%             case 'dresden'
%                 cBal = num2str(randi(6));
%                 reward = num2str(randi(2));
%             case 'oddball'
%                 cBal = num2str(randi(2));
%                 reward = num2str(randi(2));
%             case'reversal'
%                 cBal = nan;
%                 reward = num2str(randi(2));
%             case 'ARC'
%                 cBal = num2str(randi(4));
%                 reward = '1';
%                 testDay = num2str(randi(2));
%         end
%         
%     else
        cBal = '1';
        reward = '1';
        testDay = '1';
   % end
    
    % Specify default that is shown on screen
%     switch taskType
%     
%         case 'dresden'
%             defaultanswer = {'99999','99', '1', 'm', cBal, reward};
%         case 'oddball'
%             defaultanswer = {'99999','99', '1', 'm', cBal, reward};
%         case 'reversal'
%             defaultanswer = {'99999','99', 'm', reward};
%         case 'chinese'
            defaultanswer = {'99999','99', 'm', cBal};
%         case 'ARC'
%             defaultanswer = {'99999','99', '1', 'm', cBal, testDay};
%     end
    
    % Add information that is not specified by user
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
%     switch taskType
%         case'dresden' 
%             subjInfo{7} = date;
%         case'oddball'
%             subjInfo{7} = date;
%         case 'reversal' 
%             subjInfo{5} = date;
%         case 'chinese'
            subjInfo{5} = 1; % reward
            subjInfo{6} = '1'; % group
            subjInfo{7} = date;
%         case 'ARC' 
%             subjInfo{7} = reward;
%             subjInfo{8} = date;
%     end
    
    % Check if user input makes sense
    % -------------------------------
    % Check ID
    if numel(subjInfo{1}) < 5 ...
            || numel(subjInfo{1}) > 5
        msgbox('ID: must consist of five numbers!');
        return
    end
    
%     % Check group and session
%     switch taskType 
%         case 'dresden'
%             if subjInfo{3} ~= '1' && subjInfo{3} ~= '2'
%                 msgbox('Group: "1" or "2"?');
%                 return
%             end
%         case 'oddball'
%             if subjInfo{3} ~= '1' && subjInfo{3} ~= '2' && subjInfo{3} ~= '3'
%                 msgbox('Session: "1", "2" or "3"?');
%                 return
%             end
%         case 'ARC'
%             if subjInfo{3} ~= '0' && subjInfo{3} ~= '1'
%                 msgbox('Group: "0" or "1"?');
%                 return
%             end
%     end
    
%     % Check sex
%     if strcmp(taskType, 'dresden') || strcmp(taskType, 'oddball') || strcmp(taskType, 'ARC')
%         if subjInfo{4} ~= 'm' && subjInfo{4} ~= 'f'
%             msgbox('Sex: "m" or "f"?');
%             return
%             
%         end
%     else
%         if subjInfo{3} ~= 'm' && subjInfo{3} ~= 'f'
%             msgbox('Sex: "m" or "f"?');
%             return
%             
%         end
%     end
    
%     % Check cBal
%     switch taskType 
%         case 'dresden'
%             if subjInfo{5} ~= '1' && subjInfo{5} ~= '2' && subjInfo{5} ~= '3' && subjInfo{5} ~= '4' && subjInfo{5} ~= '5' && subjInfo{5} ~= '6'
%                 msgbox('cBal: 1, 2, 3, 4, 5 or 6?');
%                 return
%             end
%         case 'oddball'
%             if subjInfo{5} ~= '1' && subjInfo{5} ~= '2'
%                 msgbox('cBal: 1 or 2?');
%                 return
%             end
%         case 'ARC'
%             if subjInfo{5} ~= '1' && subjInfo{5} ~= '2' && subjInfo{5} ~= '3' && subjInfo{5} ~= '4'
%                 msgbox('cBal: 1,2,3 or 4?');
%                 return
%             end
%         case 'chinese'
            if subjInfo{4} ~= '1' && subjInfo{4} ~= '2'
                msgbox('cBal: 1 or 2?');
                return
            end
%     %end
%     
%     % Check reward
%     if strcmp(taskType, 'dresden') || strcmp(taskType, 'oddball')
%         if subjInfo{6} ~= '1' && subjInfo{6} ~= '2'
%             msgbox('Reward: 1 or 2?');
%             return
%         end
%     elseif strcmp(taskType, 'reversal')
%         if subjInfo{4} ~= '1' && subjInfo{4} ~= '2'
%             msgbox('Reward: 1 or 2?');
%             return
%         end
%     end
%     
%     % Check test day for ARC
%     if strcmp(taskType, 'ARC')
%         if subjInfo{6} ~= '1' && subjInfo{6} ~= '2'
%             msgbox('Day: 1 or 2?')
%             return
%         end
%     end
%     
    % Put all relevant subject info in structure
    % ------------------------------------------
%     switch taskType 
%         case 'dresden'
%             subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(4), 'group', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))), 'rew',...
%                 str2double(cell2mat(subjInfo(6))), 'date', subjInfo(7), 'session', '1');
%         case 'oddball'
%         
%             subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(4), 'session', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))), 'rew',...
%                 str2double(cell2mat(subjInfo(6))), 'date', subjInfo(7));
%         case 'reversal'
%         
%             subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(3), 'rew', str2double(cell2mat(subjInfo(4))), 'date',subjInfo(5), 'session', '1', 'cBal', nan);
%         case 'chinese'
            subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(4))), 'rew', subjInfo(5), 'group', subjInfo(6), 'date',subjInfo(7), 'session', '1');
%         case 'ARC'       
%             subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(4), 'group', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))),...
%                 'rew', str2double(cell2mat(subjInfo(7))), 'testDay',str2double(cell2mat(subjInfo(6))), 'date', subjInfo(8), 'session', '1');
%             testDay = subject.testDay;  
   % end
    
%     % For ARC: check if tickmark on or off
%     % cbal = 1,2: day1 - tickmark on, day2 - tickmark off
%     % cbal = 3,4: day1 - tickmark off, day2 - tickmark on
%     cBal = subject.cBal;
%     if (isequal(taskType, 'ARC') && cBal == 1 && testDay == 1) || (isequal(taskType, 'ARC') && cBal == 2 && testDay == 1) ||...
%             (isequal(taskType, 'ARC') && cBal == 3 && testDay == 2) || (isequal(taskType, 'ARC') && cBal == 4 && testDay == 2)
%         showTickmark = true;
%     elseif (isequal(taskType, 'ARC') && cBal == 1 && testDay == 2) || (isequal(taskType, 'ARC') && cBal == 2 && testDay == 2) ||...
%             (isequal(taskType, 'ARC') && cBal == 3 && testDay == 1) || (isequal(taskType, 'ARC') && cBal == 4 && testDay == 1)
%         showTickmark = false;
%     end
%     
%     % Check if ID exists in save folder
%     if strcmp(taskType, 'dresden') || strcmp(taskType, 'reversal') || strcmp(taskType, 'chinese')
        checkIdInData = dir(sprintf('*%s*', num2str(cell2mat((subjInfo(1))))));
%     elseif strcmp(taskType, 'oddball')
%         checkIdInData = dir(sprintf('*%s_session%s*', num2str(cell2mat((subjInfo(1)))), num2str(cell2mat((subjInfo(3))))));
%     elseif strcmp(taskType, 'ARC')
%         
%         if showTickmark
%             checkIdInData = dir(sprintf('*%s_TM*', num2str(cell2mat((subjInfo(1))))));
%         elseif ~showTickmark
%             checkIdInData = dir(sprintf('*%s_NTM*', num2str(cell2mat((subjInfo(1))))));
%         end
%     end
%     
    fileNames = {checkIdInData.name};
    
     if  ~isempty(fileNames)
%         if strcmp(taskType, 'dresden')
%             msgbox('Diese ID wird bereits verwendet!');
%         elseif strcmp(taskType, 'oddball') || strcmp(taskType, 'reversal') || strcmp(taskType, 'chinese') || strcmp(taskType, 'ARC')
            msgbox('ID and day have already been used!');
        %end
        return
    end
end

% For oddball: check how many trials should be selected
if isequal(taskType, 'oddball') && isequal(subject.session, '1')
    trials = trialsS1;
elseif (isequal(taskType, 'oddball') && isequal(subject.session, '2')) || (isequal(taskType, 'oddball') && isequal(subject.session, '3'))
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
    
    % Start time for triggers etc.
    ref = GetSecs;
    
    taskParam.gParam.ref = ref;
    taskParam.gParam.screensize = screensize;
    taskParam.gParam.zero = zero;
    taskParam.gParam.window = window;
    taskParam.gParam.windowRect = windowRect;
%    taskParam.gParam.showTickmark = showTickmark;
    taskParam.circle.cannonEndRect = [0 0 taskParam.circle.cannonEndDiam taskParam.circle.cannonEndDiam];
    
    
    % Circle XX
    taskParam.circle.centBoatRect = CenterRect(taskParam.circle.boatRect, windowRect);
    taskParam.circle.predCentSpotRect = CenterRect(taskParam.circle.predSpotRect, windowRect);
    taskParam.circle.outcCentRect = CenterRect(taskParam.circle.outcRect, windowRect);
    taskParam.circle.outcCentSpotRect = CenterRect(taskParam.circle.outcRect, windowRect);
    taskParam.circle.cannonEndCent = CenterRect(taskParam.circle.cannonEndRect, windowRect);
    taskParam.circle.centSpotRectMean = CenterRect(taskParam.circle.spotRectMean,windowRect);
    
    
    % Parameters related to keyboard
    % ------------------------------
    KbName('UnifyKeyNames')
    taskParam.fieldNames = fieldNames; 
    taskParam.textures = textures;  
    taskParam.unitTest = unitTest; 
    
    % class(taskParam)
    taskParam.subject = subject;
    
    % Condition-object initialization
    % -------------------------------
    cond_init.txtPressEnter = taskParam.strings.txtPressEnter;
    cond_init.runIntro = taskParam.gParam.runIntro;
    cond_init.unitTest = unitTest;
    cond_init.taskType = taskType;
    cond_init.cBal = subject.cBal;
    cond_init.concentration = taskParam.gParam.concentration;
    cond_init.haz = taskParam.gParam.haz;
    cond_init.testDay = testDay;
%    cond_init.showTickmark = showTickmark;
    
    % Condition-object instance
    % --------------------------
    
    
   
    cond = al_chinese_conditions(cond_init);
    
    cond = cond.ChineseCondition(taskParam, subject);
      %  cond = cond.ChineseCondition(taskParam, subject);

    perfCued = cond.perfCued;
    perfMain = cond.perfMain;
    
    % Translate performance into monetary reward
    % ------------------------------------------
    
    totWin = perfCued + perfMain;
    
    % End of task
    % -----------
    al_endTask(taskType, taskParam, taskParam.strings.textSize, totWin, subject)
    ListenChar();
    ShowCursor;
    Screen('CloseAll');
    
    % Inform user about timing
    sprintf('total time: %.1f minutes', str2mat((GetSecs - ref)/60))
    
end





