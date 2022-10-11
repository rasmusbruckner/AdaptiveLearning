function al_instructions(taskParam, whichPractice, subject)
%AL_INSTRUCTIONS This function runs the instructions for the cannon task.
%   As we recently re-organized the instructions scripts,
%   instructions are currently only working for the "chinese" and
%   the "ARC" version. In particular, we divided the instructions
%   for each task in separate functions. Thus, if instructions for
%   "Dresden", "Oddball" or "Reversal" are required, they have to
%   be adjusted in the respective functions.
%
%   Input
%       taskParam
%       whichPractice
%       subject
%
%   Output
%       ~

% todo: build integration test that run through instructions as well
% otherwise, we have to manually test the different versions constantly

% Note: Deprecated. We use specific instruction functions for each version.

% Adjust text settings
Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');
Screen('TextSize', taskParam.gParam.window.onScreen, 50);

% Display first slide indicating the current task version
al_indicateCondition(taskParam, subject, whichPractice)

% Version-specific instructions 
% -----------------------------

if isequal(taskParam.gParam.taskType, 'dresden')
    % For the "dresden" version, we used six different sequences for the
    % three conditions
    
    if isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'mainPractice') && subject.cBal == 1) || (isequal(whichPractice, 'mainPractice')...
            && subject.cBal == 2) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 3) || (isequal(whichPractice, 'followCannonPractice')...
            && subject.cBal == 4) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5) || (isequal(whichPractice, 'followCannonPractice')...
            && subject.cBal == 6)
        % Rename
        %sharedInstructions
        sharedInstructions(taskParam, subject, true, whichPractice)
    elseif isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'mainPractice') && subject.cBal == 4) || (isequal(whichPractice, 'mainPractice')...
            && subject.cBal == 5) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 6)
        MainJustInstructions
    elseif isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 1)...
            || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 2) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 3)
        FollowCannonJustInstructions(taskParam)
    elseif isequal(whichPractice, 'followOutcomePractice')
        FollowOutcomeInstructions(taskParam, subject, true, whichPractice)
    end
    
elseif isequal(taskParam.gParam.taskType, 'oddball')
    % For the "oddball" task, we had a version with continuous and a
    % version with discrete changes
    
    if (isequal(whichPractice, 'oddballPractice') && subject.cBal == 1) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 2)
        sharedInstructions(taskParam, subject, true, whichPractice)
    elseif (isequal(whichPractice, 'oddballPractice') && subject.cBal == 2)
        DisplayPartOfTask
        oddballPractice
    elseif (isequal(whichPractice, 'mainPractice') && subject.cBal == 1)
        MainAndFollowCannon_CannonVisibleNoNoise(whichPractice, taskParam, subject)
        MainAndFollowCannon_CannonVisibleNoise(whichPractice, taskParam, subject)
    end
    
elseif isequal(taskParam.gParam.taskType, 'reversal') 
    % For the "reversal", "chinese" and "ARC" version, we directly run
    % the general instructions file and run the task-specific instructions
    % afterwards
    % Rename: al_sharedInstructions
    sharedInstructions(taskParam, subject, true, whichPractice)
elseif isequal(taskParam.gParam.taskType, 'chinese')
    al_ChineseInstructions(taskParam, subject, true, whichPractice)
elseif isequal(taskParam.gParam.taskType, 'ARC')
    al_ARC_Instructions(taskParam, subject, true, whichPractice)
end

end
