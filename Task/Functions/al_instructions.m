function al_instructions(taskParam, whichPractice, subject)
%INSTRUCTIONS runs the instructions for the cannon task.
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
%   Output
%       ~


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
        sharedInstructions
    elseif isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'mainPractice') && subject.cBal == 4) || (isequal(whichPractice, 'mainPractice')...
            && subject.cBal == 5) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 6)
        MainJustInstructions
    elseif isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 1)...
            || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 2) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 3)
        FollowCannonJustInstructions
    elseif isequal(whichPractice, 'followOutcomePractice')
        FollowOutcomeInstructions
    end
    
elseif isequal(taskParam.gParam.taskType, 'oddball')
    % For the "oddball" task, we had a version with continuous and a
    % version with discrete changes
    
    if (isequal(whichPractice, 'oddballPractice') && subject.cBal == 1) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 2)
        sharedInstructions
    elseif (isequal(whichPractice, 'oddballPractice') && subject.cBal == 2)
        DisplayPartOfTask
        oddballPractice
    elseif (isequal(whichPractice, 'mainPractice') && subject.cBal == 1)
        MainAndFollowCannon_CannonVisibleNoNoise
        MainAndFollowCannon_CannonVisibleNoise
    end
    
elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'chinese') || isequal(taskParam.gParam.taskType, 'ARC')
    % For the "reversal", "chinese" and "ARC" version, we directly run
    % the general instructions file and run the task-specific instructions
    % afterwards
    % Rename: al_sharedInstructions
    sharedInstructions(taskParam, subject, true, whichPractice)
    
end

end
