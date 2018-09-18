function [screenIndex, Data] = shieldPractice(taskParam, subject, screenIndex)
%SHIELDPRACTICE   Practice block to illustrate shield size and color
% 
%   Input
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%       screenIndex: indicates current sceen of instruction phase
%   Output
%       screenIndex: updated screenIndex 
%       Data: data from the previous trials // Check this in the future


    condition = 'shield';
    [~, Data] =  al_mainLoop(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition, subject);
    screenIndex = screenIndex + 1;
    WaitSecs(0.1);
    
end