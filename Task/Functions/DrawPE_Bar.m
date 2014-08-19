function DrawPE_Bar(taskParam, Data, trial)
%function DrawPE_Bar(taskParam, rawPredErr, outcome, pred, predErr)
% This function draws the prediction error bar.

if taskParam.gParam.PE_Bar == true
    rotRad = taskParam.circle.rotationRad-1;
    zero = taskParam.gParam.zero;
    if Data.rawPredErr(trial) >= 0 && Data.rawPredErr(trial) <= 180
        Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],Data.pred(trial), Data.predErr(trial), 8, [], []) %115
    elseif Data.rawPredErr(trial) > 180 && Data.rawPredErr(trial)
        Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],Data.outcome(trial), Data.predErr(trial), 8, [], []) %115
    elseif Data.rawPredErr(trial) <= 0 && Data.rawPredErr(trial) >= -180
        Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],Data.outcome(trial), Data.predErr(trial), 8, [], []) %115
    elseif Data.rawPredErr(trial) < -180
        Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],Data.pred(trial), Data.predErr(trial), 8, [], []) %115
    end
    
end
end

% rotRad = taskParam.circle.rotationRad-1;
% zero = taskParam.gParam.zero;
% if rawPredErr >= 0 && rawPredErr <= 180
%     Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],pred, predErr, 8, [], []) %115
% elseif rawPredErr > 180 && rawPredErr
%     Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],outcome, predErr, 8, [], []) %115
% elseif rawPredErr <= 0 && rawPredErr >= -180
%     Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad],outcome, predErr, 8, [], []) %115
% elseif rawPredErr < -180
%     Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - rotRad, zero(2) - rotRad, zero(1) + rotRad, zero(2) + rotRad], pred, predErr, 8, [], []) %115
% end
%
% end