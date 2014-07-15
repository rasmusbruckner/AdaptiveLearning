function DrawPE_Bar(taskParam, taskData, trial)
% This function draws the prediction error bar.


zero = taskParam.gParam.zero;
if taskData.rawPredErr(trial) >= 0 && taskData.rawPredErr(trial) <= 180
    Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - 104, zero(2) - 104, zero(1) + 104, zero(2) + 104],taskData.pred(trial), taskData.predErr(trial), 8, [], []) %115
elseif taskData.rawPredErr(trial) > 180 && taskData.rawPredErr(trial)
    Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - 104, zero(2) - 104, zero(1) + 104, zero(2) + 104],taskData.outcome(trial), taskData.predErr(trial), 8, [], []) %115
elseif taskData.rawPredErr(trial) <= 0 && taskData.rawPredErr(trial) >= -180
    Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - 104, zero(2) - 104, zero(1) + 104, zero(2) + 104],taskData.outcome(trial), taskData.predErr(trial), 8, [], []) %115
elseif taskData.rawPredErr(trial) < -180
    Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - 104, zero(2) - 104, zero(1) + 104, zero(2) + 104],taskData.pred(trial), taskData.predErr(trial), 8, [], []) %115
end

end

