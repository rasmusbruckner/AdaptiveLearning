function [taskData, trial] = al_loadTaskData(taskParam, condition, haz, concentration, trial)
% AL_LOADTASKDATA   This funciton loads pre-generated outcome data or
% generates outcomes for the current block
%
%   TODO: The organization of this function can be improved. At some point,
%   it should be reorganized together with the al_generateOutcomes function
%   in order to have a similar way to generate outcomes for all task
%   versions. 
%
%   Input
%       taskParam: structure containing task paramters
%       condition: current task condition of which data should be loaded
%       haz: hazard rate
%       concentration: noise in the environment
%   
%   Output
%       taskData: loaded task data
%       trial: number of trials

% NOTE: Deprecated: generateOutcomes and loaded data are now better
% integrated in the conditions functions


% data for unit tests
if taskParam.unitTest
    if isequal(condition, 'oddball')
        taskData = load('unitTest_TestDataOddball');
        taskData = taskData.taskData;
        clear taskData.cBal taskData.rew
        trial = taskParam.gParam.trials;
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
        taskData.accPerf = nan(trial,1);
        taskData.perf = zeros(trial,1);
    elseif isequal(taskParam.gParam.taskType, 'dresden') % isequal(condition, 'dresden')
        taskData = load('unitTest_TestData');
        taskData = taskData.taskData;
        clear taskData.cBal taskData.rew
        trial = taskParam.gParam.trials;
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
        if isequal(condition, 'main')
            taskData.pred = taskData.predMain;
        elseif isequal(condition, 'followOutcome')
            taskData.pred = taskData.predFollowOutcome;
        elseif isequal(condition, 'followCannon')
            taskData.pred = taskData.predFollowCannon;
        end
        taskData.reversal = nan;
        taskData.savedTickmark = nan;
        taskData.initialTendency = nan;
        taskData.RT = nan;
        taskData.currentContext = nan;
        taskData.latentState = nan;
        taskData.critical_trial = nan;

    elseif isequal(condition, 'reversal')
        taskData = load('unitTest_TestDataReversal');
        taskData = taskData.taskData;
        trial = taskParam.gParam.trials;
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
        taskData.accPerf = nan(trial,1);
        taskData.perf = zeros(trial,1);
        taskData.gParam.taskType = 'reversal';
    elseif isequal(condition, 'main')
        taskData = load('unitTest_TestDataARC');
        taskData = taskData.taskData;
        taskData.critical_trial = nan;
        trial = taskParam.gParam.trials;
    end
    % data for regular runs
elseif ~taskParam.unitTest
    

    if isequal(condition, 'oddballPractice_1')  % isequal(condition, 'practiceOddball') && isequal(LoadData, 'NoNoise')
        
        taskData = load('OddballNoNoise');
        taskData = taskData.practData;
        trial = taskParam.gParam.practTrials;
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.initialTendency = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
        taskData.savedTickmark(1) = nan;
        taskData.reversal = nan(length(trial),1);
        taskData.currentContext = nan(length(trial),1);
        taskData.hiddenContext = nan(length(trial),1);
        taskData.contextTypes = nan(length(trial),1);
        taskData.latentState = nan(length(trial),1);
        taskData.RT = nan(length(trial),1);
        taskData.critical_trial = nan(length(trial),1);
        
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.block = ones(trial,1);
        taskData.reversal = nan(length(trial),1);
        taskData.savedTickmark = nan(length(trial),1);
        taskData.initialTendency = nan(trial,1);
        
   elseif isequal(condition, 'oddballPractice_2')
      
        taskData = load('OddballNoise');
        taskData = taskData.practData;
        trial = taskParam.gParam.practTrials;
        
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.initialTendency = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
        taskData.savedTickmark(1) = nan;
        taskData.reversal = nan(length(trial),1);
        taskData.currentContext = nan(length(trial),1);
        taskData.hiddenContext = nan(length(trial),1);
        taskData.contextTypes = nan(length(trial),1);
        taskData.latentState = nan(length(trial),1);
        taskData.RT = nan(length(trial),1);
        taskData.critical_trial = nan(length(trial),1);
        
    elseif isequal(condition, 'oddballPractice')
        
        taskData = load('OddballInvisible');
        taskData = taskData.taskData;
        clear taskData.cBal taskData.rew
        
        trial = taskParam.gParam.practTrials;
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
    elseif isequal(condition, 'followOutcomePractice') || isequal(condition, 'followCannonPractice')
        taskData = load('CPInvisible');
        taskData = taskData.taskData;
        clear taskData.cBal taskData.rew
        trial = taskParam.gParam.practTrials;
        taskData.cBal = nan(trial,1);
        taskData.rew = nan(trial,1);
        taskData.initiationRTs = nan(trial,1);
        taskData.initialTendency = nan(trial,1);
        taskData.actJitter = nan(trial,1);
        taskData.block = ones(trial,1);
        taskData.savedTickmark(1) = nan;
        taskData.reversal = nan(length(trial),1);
        taskData.currentContext = nan(length(trial),1);
        taskData.hiddenContext = nan(length(trial),1);
        taskData.contextTypes = nan(length(trial),1);
        taskData.latentState = nan(length(trial),1);
        taskData.RT = nan(length(trial),1);
        taskData.critical_trial = nan(length(trial),1);


    elseif isequal(condition, 'mainPractice_1')
        if isequal(taskParam.gParam.taskType, 'ARC')
            taskData = load('pract1');
            taskData = taskData.taskData;
            trial = taskParam.gParam.practTrials;
        else
            taskData = load('CP_NoNoise');
            taskData = taskData.practData;
            taskData.latentState = zeros(20,1);
            taskData.currentContext = nan(20,1);
            taskData.savedTickmark = nan(20,1);
            trial = taskParam.gParam.practTrials;
            taskData.initialTendency = nan(trial,1);
            taskData.reversal = nan(20,1);
            taskData.currentContext = nan(20,1);
            taskData.hiddenContext = nan(20,1);
            taskData.contextTypes = nan(20,1);
            taskData.latentState = nan(20,1);
            taskData.shieldType = ones(20,1);
            taskData.RT = nan(length(trial),1);
            taskData.critical_trial = nan(length(trial),1);

        end
    elseif isequal(condition, 'mainPractice_2')
        if isequal(taskParam.gParam.taskType, 'ARC')
            taskData = load('pract2');
            taskData = taskData.taskData;
            taskData.critical_trial = nan;
            trial = taskParam.gParam.practTrials;
        else
            taskData = load('CP_Noise');
            taskData = taskData.practData;
            taskData.latentState = zeros(20,1);
            taskData.currentContext = nan(20,1);
            taskData.savedTickmark = nan(20,1);
            trial = taskParam.gParam.practTrials;
            taskData.initialTendency = nan(trial,1);
            taskData.reversal = nan(20,1);
            taskData.currentContext = nan(20,1);
            taskData.hiddenContext = nan(20,1);
            taskData.contextTypes = nan(20,1);
            taskData.latentState = nan(20,1);
            taskData.shieldType = ones(20,1);
            taskData.RT = nan(20,1);
            taskData.critical_trial = nan;
        end
    elseif isequal(condition, 'onlinePractice')
        taskData = load('onlinePractice');
        taskData = taskData.taskData;
        taskData.critical_trial = nan;
        trial = 2; %taskParam.gParam.onlinePractTrials;
    elseif isequal(condition, 'mainPractice_3')
        taskData = load('pract3');
        taskData = taskData.taskData;
        taskData.critical_trial = nan;
        trial = taskParam.gParam.practTrials;
    elseif isequal(condition, 'mainPractice_4')
        taskData = load('pract4');
        taskData = taskData.taskData;
        taskData.critical_trial = nan;
        trial = taskParam.gParam.practTrials;
    elseif isequal(condition, 'shield')
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
        taskParam.condition = condition;
        trial = taskData.trial;
        taskData.initialTendency = nan(trial,1);
    elseif isequal(condition, 'ARC_controlSpeed') || isequal(condition, 'ARC_controlAccuracy') || isequal(condition, 'ARC_controlPractice')
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
        taskParam.condition = condition;
        trial = taskData.trial;
        taskData.initialTendency = nan(trial,1);
    elseif isequal(condition, 'reversalPractice')
        taskData = load('reversalVisibleNoNoise');
        taskData = taskData.taskData;
        taskData.critical_trial = nan;
        taskParam.gParam.practTrials = taskParam.gParam.practTrials * 2;
        trial = taskParam.gParam.practTrials; 
        taskData.initialTendency = nan(trial,1);
            %taskData.reversal = nan(20,1);
        taskData.currentContext = nan(trial,1);
        taskData.hiddenContext = nan(trial,1);
        taskData.contextTypes = nan(trial,1);
        taskData.latentState = nan(trial,1);
        taskData.shieldType = ones(trial,1);
        taskData.RT = nan(trial,1);
        taskData.critical_trial = nan;
    elseif isequal(condition, 'reversalPracticeNoise')  
        taskData = load('reversalVisibleNoise');
        taskData = taskData.taskData;
        taskData.critical_trial = nan;
        taskParam.gParam.practTrials = taskParam.gParam.practTrials * 2;
        trial = taskParam.gParam.practTrials; 
        taskData.initialTendency = nan(trial,1);
            %taskData.reversal = nan(20,1);
        taskData.currentContext = nan(trial,1);
        taskData.hiddenContext = nan(trial,1);
        taskData.contextTypes = nan(trial,1);
        taskData.latentState = nan(trial,1);
        taskData.shieldType = ones(trial,1);
        taskData.RT = nan(trial,1);
        taskData.critical_trial = nan;
    elseif isequal(condition, 'reversal') || isequal(condition, 'reversalPracticeNoiseInv') || isequal(condition, 'reversalPracticeNoiseInv2') %|| isequal(condition, 'reversalPractice')
        warning('gucken dass hier alle bedingungen spezifiziert werden')
        % ok, hier wird noch garnichts geladen, sondern nur direkt
        % generiert.  
        if isequal(condition, 'reversalPractice')
            taskParam.gParam.practTrials = taskParam.gParam.practTrials; 
            trial = taskParam.gParam.practTrials; 
        else
            taskParam.gParam.practTrials = taskParam.gParam.practTrials;
        end
        %taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
    elseif isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3') || isequal(condition, 'chinesePractice_4')
        trial = taskParam.gParam.chinesePractTrials;
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
    elseif isequal(condition, 'chinese') %|| isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
        if isnan(taskParam.gParam.trials)
            trial = length(taskData.latentState);
        else
            trial = taskParam.gParam.trials;
        end

    elseif isequal(condition, 'main') || isequal(condition, 'oddball') || isequal(condition, 'practiceNoOddball')  
        trial = taskParam.gParam.trials;
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
    elseif isequal(condition, 'followCannon') || isequal(condition, 'followOutcome')
        trial = taskParam.gParam.controlTrials;
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
    end
end