function [taskData, trial] = al_loadTaskData(taskParam, condition, haz, concentration)
% Add comments!


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
    elseif isequal(condition, 'dresden')
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
        trial = taskParam.gParam.trials;
    end
    % data for regular runs
elseif ~taskParam.unitTest
    if isequal(condition, 'oddballPractice')
        
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
        end
    elseif isequal(condition, 'mainPractice_2')
        if isequal(taskParam.gParam.taskType, 'ARC')
            taskData = load('pract2');
            taskData = taskData.taskData;
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
        end
    elseif isequal(condition, 'onlinePractice')
        taskData = load('onlinePractice');
        taskData = taskData.taskData;
        trial = taskParam.gParam.onlinePractTrials;
    elseif isequal(condition, 'mainPractice_3')
        taskData = load('pract3');
        taskData = taskData.taskData;
        trial = taskParam.gParam.practTrials;
    elseif isequal(condition, 'mainPractice_4')
        taskData = load('pract4');
        taskData = taskData.taskData;
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
    elseif isequal(condition, 'reversal') || isequal(condition, 'reversalPractice')
        warning('gucken dass hier alle bedingungen spezifiziert werden')
        if isequal(condition, 'reversalPractice')
            taskParam.gParam.practTrials = taskParam.gParam.practTrials * 2;
            trial = taskParam.gParam.practTrials; 
        else
            trial = taskParam.gParam.trials;
        end
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
    elseif isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3') || isequal(condition, 'chinesePractice_4')
        trial = taskParam.gParam.chinesePractTrials;
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
    elseif isequal(condition, 'chinese') %|| isequal(condition, 'chinesePractice_1') || isequal(condition, 'chinesePractice_2') || isequal(condition, 'chinesePractice_3')
        trial = taskParam.gParam.trials;
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
    elseif isequal(condition, 'main')
        trial = taskParam.gParam.trials;
        taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
    end
end