function [taskParam] = ControlLoop(taskParam, distMean, outcome, boatType)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


while 1
    DrawCircle(taskParam.gParam.window);
    DrawCross(taskParam.gParam.window);
    DrawHand(taskParam, distMean);
    PredictionSpot(taskParam);
    Screen('Flip', taskParam.gParam.window);
    
    [ keyIsDown, ~, keyCode ] = KbCheck;
    
    if keyIsDown
        if keyCode(taskParam.keys.rightKey)
            if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle + 1*taskParam.circle.unit; %0.02
            else
                taskParam.cirlce.rotAngle = 0;
            end
        elseif keyCode(taskParam.keys.leftKey)
            if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle - 1*taskParam.circle.unit;
            else
                taskParam.circle.rotAngle = 360*taskParam.circle.unit;
            end
        elseif keyCode(taskParam.keys.space)
            break;
        end
    end
end

DrawCircle(taskParam.gParam.window);
DrawCross(taskParam.gParam.window);
Screen('Flip', taskParam.gParam.window);
WaitSecs(1);

DrawCircle(taskParam.gParam.window);
DrawOutcome(taskParam, outcome);
DrawCross(taskParam.gParam.window);
PredictionSpot(taskParam);
Screen('Flip', taskParam.gParam.window);
WaitSecs(1);

DrawCircle(taskParam.gParam.window);
DrawCross(taskParam.gParam.window);
Screen('Flip', taskParam.gParam.window);
WaitSecs(1);

%imageRect = [0 0 100 100];
%winRect = taskParam.gParam.windowRect;
%dstRect = CenterRect(imageRect, winRect);

if boatType == 1
    DrawBoat(taskParam, taskParam.colors.gold)
else
    DrawBoat(taskParam, taskParam.colors.silver)
end

DrawCircle(taskParam.gParam.window)
Screen('Flip', taskParam.gParam.window);
WaitSecs(1);

DrawCircle(taskParam.gParam.window)
DrawCross(taskParam.gParam.window)
Screen('Flip', taskParam.gParam.window);
WaitSecs(1)

KbReleaseWait();
end