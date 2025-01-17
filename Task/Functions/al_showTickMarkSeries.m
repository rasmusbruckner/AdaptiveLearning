function al_showTickMarkSeries(taskData, taskParam, trial)
% AL_SHOWTICKMARKSERIES This function presents tickmarks for the last five
% outcomes
%
%   In working-memory version, last five trials, in cannon practice,
%   current + last 4 outcomes
%
%   Input
%       taskData:
%       taskParam:
%       trial:
%
%   Output
%       None

% Working-memory version
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
    if trial > 5 && (taskData.block(trial) == taskData.block(trial-5))
        al_tickMark(taskParam, taskData.outcome(trial), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-2), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-3), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-4), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-5), 'outcomeSeries');
    elseif trial > 4 && (taskData.block(trial) == taskData.block(trial-4))
        al_tickMark(taskParam, taskData.outcome(trial), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-2), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-3), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-4), 'outcomeSeries');
    elseif trial > 3 && (taskData.block(trial) == taskData.block(trial-3))
        al_tickMark(taskParam, taskData.outcome(trial), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-2), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-3), 'outcomeSeries');
    elseif trial > 2 && (taskData.block(trial) == taskData.block(trial-2))
        al_tickMark(taskParam, taskData.outcome(trial), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-2), 'outcomeSeries');
    elseif trial > 1 && (taskData.block(trial) == taskData.block(trial-1))
        al_tickMark(taskParam, taskData.outcome(trial), 'outcomeSeries');
        al_tickMark(taskParam, taskData.outcome(trial-1), 'outcomeSeries');
    elseif trial && (taskData.block(trial) == taskData.block(trial))
        al_tickMark(taskParam, taskData.outcome(trial), 'outcomeSeries');
    end
end