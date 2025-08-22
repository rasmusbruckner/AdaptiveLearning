function al_showTickMarkSeries(taskData, taskParam, trial)
% AL_SHOWTICKMARKSERIES This function presents tickmarks for the last N
% outcomes
%
%   In working memory version, last five trials, in cannon practice,
%   current + last N outcomes
%
%   Input
%       taskData: Task-data-object instance
%       taskParam: Task-parameter-object instance
%       trial: Current trial number
%
%   Output
%       None

% Working memory version (todo: use same logic as in cannon practice)
if isequal(taskParam.trialflow.currentTickmarks, 'workingMemory')
    if trial > 5 && (taskData.block(trial) == taskData.block(trial-5))
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outc');
        al_tickMark(taskParam, taskData.outcome(trial-2), 'outc');
        al_tickMark(taskParam, taskData.outcome(trial-3), 'outc');
        al_tickMark(taskParam, taskData.outcome(trial-4), 'outc');
        al_tickMark(taskParam, taskData.outcome(trial-5), 'outc');
    elseif trial > 4 && (taskData.block(trial) == taskData.block(trial-4))
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outc');
        al_tickMark(taskParam, taskData.outcome(trial-2), 'outc');
        al_tickMark(taskParam, taskData.outcome(trial-3), 'outc');
        al_tickMark(taskParam, taskData.outcome(trial-4), 'outc');
    elseif trial > 3 && (taskData.block(trial) == taskData.block(trial-3))
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outc');
        al_tickMark(taskParam, taskData.outcome(trial-2), 'outc');
        al_tickMark(taskParam, taskData.outcome(trial-3), 'outc');
    elseif trial > 2 && (taskData.block(trial) == taskData.block(trial-2))
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outc');
        al_tickMark(taskParam, taskData.outcome(trial-2), 'outc');
    elseif trial > 1 && (taskData.block(trial) == taskData.block(trial-1))
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outc');
    end

else
    
    % Loop over outcomes we want to show
    for m = 0:taskParam.gParam.cannonPractNumOutcomes-1
        if (trial - m > 0) && (taskData.block(trial) == taskData.block(trial-m))
            al_tickMark(taskParam, taskData.outcome(trial-m), 'outcomeSeries');
        end
    end
end