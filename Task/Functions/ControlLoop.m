function [taskParam] = ControlLoop(taskParam, distMean, outcome, boatType)
% This function is called when participants move their spot in the
% instructions.

%Priority(9);
while 1
    DrawCircle(taskParam);
    DrawCross(taskParam);
    DrawNeedle(taskParam, distMean);
    PredictionSpot(taskParam);
    t = GetSecs;
    Screen('DrawingFinished', taskParam.gParam.window);
    Screen('Flip', taskParam.gParam.window, t + 0.01);
    
    
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
t = GetSecs;

% Show baseline 1. 
DrawCircle(taskParam);
DrawCross(taskParam);
Screen('DrawingFinished', taskParam.gParam.window, 1);
Screen('Flip', taskParam.gParam.window, t + 0.1, 1);

% Show outcome.
DrawCircle(taskParam);
DrawOutcome(taskParam, outcome);
DrawCross(taskParam);
PredictionSpot(taskParam);
Screen('DrawingFinished', taskParam.gParam.window, 1);
Screen('Flip', taskParam.gParam.window, t + 1);

% Show baseline 2. 
DrawCircle(taskParam);
DrawCross(taskParam);
Screen('DrawingFinished', taskParam.gParam.window, 1);
Screen('Flip', taskParam.gParam.window, t + 2, 1);

% Show boat. 
if boatType == 1
    ShipTxt = DrawBoat(taskParam, taskParam.colors.gold);
else
    ShipTxt = DrawBoat(taskParam, taskParam.colors.silver);
end

DrawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window);
Screen('Flip', taskParam.gParam.window, t + 3);
Screen('Close', ShipTxt);

% Show baseline 3.
DrawCircle(taskParam)
DrawCross(taskParam)
Screen('DrawingFinished', taskParam.gParam.window);
Screen('Flip', taskParam.gParam.window, t + 4);
WaitSecs(1);

KbReleaseWait();
%Priority(0);
end
