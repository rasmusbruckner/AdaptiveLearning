function [taskParam] = ControlLoop(taskParam, distMean, outcome, boatType)
% This function is called when participants move their spot in the
% instructions.

while 1
    DrawCircle(taskParam);
    DrawCross(taskParam);
    DrawNeedle(taskParam, distMean);
    PredictionSpot(taskParam);
    Screen('Flip', taskParam.gParam.window);
    
    [ keyIsDown, ~, keyCode ] = KbCheck;
    
    if keyIsDown
        if keyCode(taskParam.keys.rightKey)
            if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle + 1*taskParam.circle.unit; %0.02
            else
                taskParam.circle.rotAngle = 0;
            end
        elseif keyCode(taskParam.keys.leftKey)
            if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle - 1*taskParam.circle.unit;
            else
                taskParam.circle.rotAngle = 360*taskParam.circle.unit;
            end
        elseif keyCode(taskParam.keys.space)
            
            break
        end
    end
end

DrawCircle(taskParam);
DrawCross(taskParam);
Screen('Flip', taskParam.gParam.window);
WaitSecs(1);

DrawCircle(taskParam);
DrawOutcome(taskParam, outcome);
DrawCross(taskParam);
PredictionSpot(taskParam);
Screen('Flip', taskParam.gParam.window);
WaitSecs(1);

DrawCircle(taskParam);
DrawCross(taskParam);
Screen('Flip', taskParam.gParam.window);
WaitSecs(1);

if boatType == 1
    DrawBoat(taskParam, taskParam.colors.gold)
else
    DrawBoat(taskParam, taskParam.colors.silver)
end

DrawCircle(taskParam)
Screen('Flip', taskParam.gParam.window);
WaitSecs(1);

DrawCircle(taskParam)
DrawCross(taskParam)
Screen('Flip', taskParam.gParam.window);
WaitSecs(1)

KbReleaseWait();
end