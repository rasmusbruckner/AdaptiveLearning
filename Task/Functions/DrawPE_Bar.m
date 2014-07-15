function DrawPE_Bar(taskParam, taskData, trial)
% This function draws the prediction error bar.

rotRad = taskParam.circle.rotationRad-1;
zero = taskParam.gParam.zero;
if taskData.rawPredErr(trial) >= 0 && taskData.rawPredErr(trial) <= 180
    Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],taskData.pred(trial), taskData.predErr(trial), 8, [], []) %115
elseif taskData.rawPredErr(trial) > 180 && taskData.rawPredErr(trial)
    Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],taskData.outcome(trial), taskData.predErr(trial), 8, [], []) %115
elseif taskData.rawPredErr(trial) <= 0 && taskData.rawPredErr(trial) >= -180
    Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],taskData.outcome(trial), taskData.predErr(trial), 8, [], []) %115
elseif taskData.rawPredErr(trial) < -180
    Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],taskData.pred(trial), taskData.predErr(trial), 8, [], []) %115
end

end

