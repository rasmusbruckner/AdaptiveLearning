function [taskParam, practData] = PractLoop(taskParam, subject, vola, sigma, cannon)

% This function is called when participants move their spot in the
% instructions.

condition = 'practice';
practData = GenerateOutcomes(taskParam, vola, sigma, condition);

%Priority(9);
for i = 1:practData.trial
    
    
while 1
    
     if isequal(practData.rew{i}, '1') && practData.boatType(i) == 1
        practData.actRew(i) = 1;
    elseif isequal(practData.rew{i}, '1') && practData.boatType(i) == 0
        practData.actRew(i) = 2;
    elseif isequal(practData.rew{i}, '2') && practData.boatType(i) == 1
        practData.actRew(i) = 2;    
    elseif isequal(practData.rew{i}, '2') && practData.boatType(i) == 0
        practData.actRew(i) = 1;
    end   
    if cannon == true
        Cannon(taskParam, practData.distMean(i))
    end
    DrawCircle(taskParam);
    PredictionSpot(taskParam);
    if i > 1 && taskParam.gParam.PE_Bar == true
        DrawPE_Bar(taskParam, practData, i-1) 
    end
    DrawCross(taskParam);
    
    t = GetSecs;
    Screen('DrawingFinished', taskParam.gParam.window);
    Screen('Flip', taskParam.gParam.window, t + 0.001);
    
    
    [ keyIsDown, ~, keyCode ] = KbCheck;
    
    if keyIsDown
        if keyCode(taskParam.keys.rightKey)
            if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle + 1*taskParam.circle.unit; %0.02
            else
                taskParam.circle.rotAngle = 0;
            end
        elseif keyCode(taskParam.keys.rightSlowKey)
            if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle + 0.1*taskParam.circle.unit; %0.02
            else
                taskParam.circle.rotAngle = 0;
            end
        elseif keyCode(taskParam.keys.leftKey)
            if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle - 1*taskParam.circle.unit;
            else
                taskParam.circle.rotAngle = 360*taskParam.circle.unit;
            end
        elseif keyCode(taskParam.keys.leftSlowKey)
            if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                taskParam.circle.rotAngle = taskParam.circle.rotAngle - 0.1*taskParam.circle.unit;
            else
                taskParam.circle.rotAngle = 360*taskParam.circle.unit;
            end
        elseif keyCode(taskParam.keys.space)
            practData.pred(i) = (taskParam.circle.rotAngle / taskParam.circle.unit);
            
            break
        end
    end
end
[practData.predErr(i), ~, ~, ~, practData.rawPredErr(i)] = Diff(practData.outcome(i), practData.pred(i));
[practData.cannonDev(i), ~, ~, ~, ~] = Diff(practData.distMean(i), practData.pred(i));


background = false;
Cannonball(taskParam, practData.distMean(i), practData.outcome(i), background)
t = GetSecs;
% % Show baseline 1.
% DrawCircle(taskParam);
% DrawCross(taskParam);
% Screen('DrawingFinished', taskParam.gParam.window, 1);
% Screen('Flip', taskParam.gParam.window, t + 0.1, 1);
%
% Show outcome.
DrawCircle(taskParam);
if cannon == true
    Cannon(taskParam, practData.distMean(i))
end
PredictionSpot(taskParam);
DrawOutcome(taskParam, practData.outcome(i));
%(taskParam, practData.rawPredErr(i), practData.outcome(i), practData.pred(i), practData.predErr(i))
DrawPE_Bar(taskParam, practData, i)
Screen('DrawingFinished', taskParam.gParam.window);
if practData.predErr(i) <= 9
     practData.hit(i) = 1;
end

Screen('Flip', taskParam.gParam.window, t + 0.01);

% Show baseline 2.
DrawCircle(taskParam);
if cannon == true
    Cannon(taskParam, practData.distMean(i))
end
Screen('DrawingFinished', taskParam.gParam.window);
Screen('Flip', taskParam.gParam.window, t + 0.51);

% Show boat.
if practData.boatType(i) == 1
    RewardTxt = Reward(taskParam, 'gold');
    if subject.rew == '1' && practData.hit(i) == 1
         practData.perf(i) = taskParam.gParam.rewMag;  
    end
elseif practData.boatType(i) == 0
    RewardTxt = Reward(taskParam, 'silver');
   if subject.rew == '2' && practData.hit(i) == 1
         practData.perf(i) = taskParam.gParam.rewMag;  
    end
end

% Calculate accumulated performance.
practData.accPerf(i) = sum(practData.perf);% + taskData.perf(i);

DrawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window);
Screen('Flip', taskParam.gParam.window, t + 1.51);
Screen('Close', RewardTxt);

% Show baseline 3.
DrawCircle(taskParam)
DrawCross(taskParam)
Screen('DrawingFinished', taskParam.gParam.window);
Screen('Flip', taskParam.gParam.window, t + 2.01);
WaitSecs(1);

KbReleaseWait();
%Priority(0);

%fieldNames = taskParam.fieldNames;
%Data = struct(fieldNames.pred, taskData.pred, fieldNames.predErr, taskData.predErr, fieldNames.rawPredErr, taskData.rawPredErr);

end
