function [screenIndex, Data] = ShieldPractice(taskParam, subject, screenIndex)
%SHIELDPRACTICE   This function runs a practice block to illustrate shield size and color
% 
%   Input
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%       screenIndex: indicates current sceen of instruction phase
%
%   Output
%       screenIndex: updated screenIndex 
%       Data: data from the previous trials


    condition = 'shield';
    %[taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(2), taskParam.gParam.concentration(3)); 
    taskData = al_generateOutcomesMain(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition);
    taskParam.condition = condition;
    trial = taskData.trial;
    taskData.initialTendency = nan(trial,1);
    %[~, Data] =  al_mainLoop(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
    Data =  al_sleepLoop(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition, subject, taskData, trial);

    screenIndex = screenIndex + 1;
    WaitSecs(0.1);
    
end