function DataMain = al_HamburgVersion(taskParam, unitTest)
%AL_ARCVERSION
%
% XX

% Initialize task
% ----------------

if ~unitTest
    clear vars
    unitTest = false;
end

% Check number of trials
if  (taskParam.gParam.trials > 1 && mod(taskParam.gParam.trials, 2)) == 1
    msgbox('All trials must be even or equal to 1!');
    return
end

% Save directory
cd('~/Dropbox/AdaptiveLearning/DataDirectory');
%cd('\\vboxsvr\dropbox\AdaptiveLearning\DataDirectory');

% Reset clock
a = clock;
rand('twister', a(6).*10000);

% User Input
% ----------

% If no user input requested
if taskParam.gParam.askSubjInfo == false
    
    ID = '99999';
    age = '99';
    sex = 'm/w';
    cBal = 1;
    reward = 1;
    
    group = '1';
    subject = struct('ID', ID, 'age', age, 'sex', sex, 'group', group, 'cBal', cBal, 'rew', reward, 'date', date, 'session', '1');

    
    % If user input requested
else
    
    prompt = {'ID:','Age:', 'Group:', 'Sex:', 'cBal:', 'day:'};
    
    name = 'SubjInfo';
    numlines = 1;
    
    % You can choose to randomize input, i.e., random cBal
%    if taskParam.gParam.randomize
 %       
  %      cBal = num2str(randi(4));
   %     reward = '1';
    %    testDay = num2str(randi(2));
        % end
        
    %else
        cBal = '1';
        reward = '1';
        testDay = '1';
    %end
    
    defaultanswer = {'99999','99', '1', 'm', cBal, testDay};
    
    % Add information that is not specified by user
    subjInfo = inputdlg(prompt,name,numlines,defaultanswer);
    subjInfo{7} = reward;
    subjInfo{8} = date;
    
    % Put all relevant subject info in structure
    % ------------------------------------------
    subject = struct('ID', subjInfo(1), 'age', subjInfo(2), 'sex', subjInfo(4), 'group', subjInfo(3), 'cBal', str2double(cell2mat(subjInfo(5))),...
        'rew', str2double(cell2mat(subjInfo(7))), 'testDay',str2double(cell2mat(subjInfo(6))), 'date', subjInfo(8), 'session', '1');
    testDay = subject.testDay;
    
    sub_init = al_subinit();
    subobj = al_subject(sub_init);
    subobj.ID = subjInfo{1}; %str2double(cell2mat(subjInfo(1)));
    subobj.age = subjInfo{2};%str2double(cell2mat(subjInfo(2)));
    subobj.sex = subjInfo{4};
    subobj.group = subjInfo{3};%str2double(cell2mat(subjInfo(3)));
    subobj.cBal = str2double(cell2mat(subjInfo(5)));
    subobj.rew = str2double(cell2mat(subjInfo(7)));
    subobj.testDay = str2double(cell2mat(subjInfo(6)));
    subobj.date = (cell2mat(subjInfo(8)));
    subobj.session = '1';
    
    al_subject.checkID(subobj)
    al_subject.checkGroup(subobj)
    al_subject.checkSex(subobj)
    al_subject.checkCBal(subobj)
    al_subject.checkTestDay(subobj)
    
    %subject = subobj;
    
    % For ARC: check if tickmark on or off
    % cbal = 1,2: day1 - tickmark on, day2 - tickmark off
    % cbal = 3,4: day1 - tickmark off, day2 - tickmark on
    cBal = subject.cBal;
    %if (isequal(taskParam.gParam.taskType, 'ARC') && cBal == 1 && testDay == 1) || (isequal(taskParam.gParam.taskType, 'ARC') && cBal == 2 && testDay == 1) ||...
     %       (isequal(taskParam.gParam.taskType, 'ARC') && cBal == 3 && testDay == 2) || (isequal(taskParam.gParam.taskType, 'ARC') && cBal == 4 && testDay == 2)
    showTickmark = true;
    %elseif (isequal(taskParam.gParam.taskType, 'ARC') && cBal == 1 && testDay == 2) || (isequal(taskParam.gParam.taskType, 'ARC') && cBal == 2 && testDay == 2) ||...
     %       (isequal(taskParam.gParam.taskType, 'ARC') && cBal == 3 && testDay == 1) || (isequal(taskParam.gParam.taskType, 'ARC') && cBal == 4 && testDay == 1)
      %  showTickmark = false;
    %end
    
    % Check if ID exists in save folder
    
    %if showTickmark
        checkIdInData = dir(sprintf('*%s_TM*', num2str(cell2mat((subjInfo(1))))));
    %elseif ~showTickmark
     %   checkIdInData = dir(sprintf('*%s_NTM*', num2str(cell2mat((subjInfo(1))))));
    %end
    
    fileNames = {checkIdInData.name};
    
    if  ~isempty(fileNames)
        msgbox('ID and day have already been used!');
        return
    end
    
    
    
    % Deal with psychtoolbox warnings
    Screen('Preference', 'VisualDebugLevel', 3);
    Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference', 'SkipSyncTests', 2);
    
    % Get screen properties
    set(0,'units','pixels') 
    screensize = get(0,'MonitorPositions');%[1    1    2560    1440]; %get(0,'MonitorPositions'); %[1    1    2560    1440]%
    
    screensize = screensize(taskParam.gParam.screenNumber, :);
    screensizePart = screensize(3:4);
    zero = screensizePart / 2;
    %[window.onScreen, windowRect, textures] = OpenWindow(taskParam.gParam.debug, taskParam.gParam.screenNumber);
    % Open psychtoolbox window
    if taskParam.gParam.debug == true
        [window.onScreen, windowRect] = Screen('OpenWindow', taskParam.gParam.screenNumber-1, [66 66 66], [420 250 1020 650]);
        %[window, windowRect] = Screen('OpenWindow', screenNumber-1, [66 66 66], [0 0 1 1]);
    else
        %[window, windowRect] = Screen('OpenWindow', screenNumber-1, [66 66 66], []);
        [window.onScreen, windowRect] = Screen('OpenWindow', taskParam.gParam.screenNumber-1, [66 66 66], []); % 1    1    2560 1440 1707.6    9602560x1440

    end

    % ??
    %imageRect = [0 0 120 120];
    % imageRect = [0 0 175 300];
    imageRect = [0 0 60 180];
    dstRect = CenterRect(imageRect, windowRect);

    % Load images
    %[cannonPic, ~, alpha]  = imread('cannon.png');
    [cannonPic, ~, alpha]  = imread('confetti_cannon.png');

    % Create pictures based on images
    cannonPic(:,:,4) = alpha(:,:);

    % ??
    Screen('BlendFunction', window.onScreen, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    % Create textures
    cannonTxt = Screen('MakeTexture', window.onScreen, cannonPic);
    
    % Create structure that contains all textures
    % todo: kann dann auch weg
    textures = struct('cannonTxt', cannonTxt, 'dstRect', dstRect);
    %ListenChar(2);
    HideCursor;
    
    
    [window.screenX, window.screenY] = Screen('WindowSize', window.onScreen);
    window.centerX = window.screenX * 0.5; % center of screen in X direction
    window.centerY = window.screenY * 0.5; % center of screen in Y direction
    window.centerXL = floor(mean([0 window.centerX])); % center of left half of screen in X direction
    window.centerXR = floor(mean([window.centerX window.screenX])); % center of right half of screen in X direction
    
   
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
    taskParam.gParam.showTickmark = showTickmark;
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
    cond_init.taskType = taskParam.gParam.taskType; %taskType;
    cond_init.cBal = cBal;
    cond_init.concentration = taskParam.gParam.concentration;
    cond_init.haz = taskParam.gParam.haz;
    cond_init.testDay = testDay;
    cond_init.showTickmark = showTickmark;
    
    % Condition-object instance
    % --------------------------
    
    cond = al_Hamburg_conditions(cond_init);
    
    % hier noch comments!
    
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
    
%     % Control condition
%     if ~unitTest && testDay == 1
%         cond = cond.ARC_ControlCondition('ARC_controlSpeed', taskParam, subject);
%         Data = cond.Data;
%     elseif ~unitTest && testDay == 2
%         cond.ARC_ControlCondition('ARC_controlAccuracy', taskParam, subject);
%     end
%     
%     % Control condition
%     if ~unitTest && testDay == 1
%         cond = cond.ARC_ControlCondition('ARC_controlAccuracy', taskParam, subject);
%         Data = cond.Data;
%     elseif ~unitTest && testDay == 2
%         cond.ARC_ControlCondition('ARC_controlSpeed', taskParam, subject);
%     end
%     
    % Translate performance into monetary reward
    % ------------------------------------------
    
    totWin = sum(blockWin);
    
    % End of task
    % -----------
    al_endTask(taskParam.gParam.taskType, taskParam, taskParam.strings.textSize, totWin, subject)
    ListenChar();
    ShowCursor;
    Screen('CloseAll');
    
    % Inform user about timing
    sprintf('total time: %.1f minutes', char((GetSecs - ref)/60))
    
end


end



