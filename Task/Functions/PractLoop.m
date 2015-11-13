function [taskParam, practData] = PractLoop(taskParam, subject, vola, sigma, cannon, condition, LoadData)
%keyboard
if nargin == 7 && isequal(LoadData, 'NoNoise')
    practData = load('OddballNoNoise');
    practData = practData.practData;
    trials = taskParam.gParam.practTrials;
elseif nargin == 7 && isequal(LoadData, 'Noise')
    practData = load('OddballNoise');
    practData = practData.practData;
    trials = taskParam.gParam.practTrials;
elseif nargin == 7 && isequal(LoadData, 'CP_NoNoise')
    practData = load('CP_NoNoise');
    practData = practData.practData;
    trials = taskParam.gParam.practTrials;
elseif nargin == 7 && isequal(LoadData, 'CP_Noise')
    practData = load('CP_Noise');
    practData = practData.practData;
    trials = taskParam.gParam.practTrials;
% elseif nargin == 7 && isequal(LoadData, 'Control_Practice')
%     practData = load('Control_Practice');
%     practData = practData.practData;
%     trials = taskParam.gParam.practTrials;
else
    practData = GenerateOutcomes(taskParam, vola, sigma, condition);
    trials = practData.trial;
end

for i = 1:trials
    
    WaitSecs(rand*taskParam.gParam.jitter);
    
    while 1
        
        if subject.rew == 1 && practData.boatType(i) == 1
            practData.actRew(i) = 1;
        elseif subject.rew == 1 && practData.boatType(i) == 0
            practData.actRew(i) = 2;
        elseif subject.rew == 2 && practData.boatType(i) == 1
            practData.actRew(i) = 2;
        elseif subject.rew == 2 && practData.boatType(i) == 0
            practData.actRew(i) = 1;
        end
        
        if cannon == true
            Cannon(taskParam, practData.distMean(i))
        end
        DrawCircle(taskParam);
        PredictionSpot(taskParam);
        if i > 1
            TickMark(taskParam, practData.outcome(i-1), 'outc')
            TickMark(taskParam, practData.pred(i-1), 'pred')
        end
        DrawCross(taskParam);
        Aim(taskParam, practData.distMean(i))
        
        
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
    
    practData.predErr(i) = Diff(practData.outcome(i), practData.pred(i));
    practData.cannonDev(i) = Diff(practData.distMean(i), practData.pred(i));
    
    if i==1
        practData.controlDev(i) = nan;
    else
        practData.controlDev(i) = Diff(practData.outcome(i-1), practData.pred(i));
    end
    
    background = false;
    %Cannonball(taskParam, practData.distMean(i), practData.distMean(i), background)
    if (isequal(condition, 'oddballPractice') && practData.oddBall(i) == true)
        WaitSecs(0.5)
    elseif isequal(condition, 'shield') || isequal(condition, 'followOutcomePractice') || isequal(condition, 'oddballPractice') || isequal(condition, 'practiceNoOddball') || isequal(condition, 'practiceOddball') || isequal(condition, 'mainPractice') || isequal(condition, 'followCannonPractice')
        Cannonball(taskParam, practData.distMean(i), practData.outcome(i), background)
    end
    
    t = GetSecs;
    
    % Show outcome
    DrawCircle(taskParam);
    if cannon == true
        Cannon(taskParam, practData.distMean(i))
    end
    PredictionSpot(taskParam);
    DrawOutcome(taskParam, practData.outcome(i));
    
    Screen('DrawingFinished', taskParam.gParam.window);
    if isequal(condition, 'mainPractice') || isequal(condition, 'followCannonPractice')
        if practData.predErr(i) <= practData.allASS(i)/2
            practData.hit(i) = 1;
        end
    elseif isequal(condition, 'followOutcomePractice')
        
        if practData.controlDev(i) <= practData.allASS(i)/2
            practData.hit(i) = 1;
        end
    end
    
    if practData.oddBall(i) == false
        Screen('Flip', taskParam.gParam.window, t + 0.1);
    else
        Screen('Flip', taskParam.gParam.window, t + 0.6);
    end
    
    DrawCircle(taskParam);
    DrawCross(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window);
    
    if practData.oddBall(i) == false
        Screen('Flip', taskParam.gParam.window, t + 0.6);
    else
        Screen('Flip', taskParam.gParam.window, t + 1.1);
    end
    
    DrawCircle(taskParam)
    Shield(taskParam, practData.allASS(i), practData.pred(i), practData.boatType(i))
    Cannon(taskParam, practData.distMean(i))
    DrawOutcome(taskParam, practData.outcome(i))
    
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    
    
    if practData.oddBall(i) == false
        Screen('Flip', taskParam.gParam.window, t + 1.6);
    else
        Screen('Flip', taskParam.gParam.window, t + 2.1);
    end
    
    % Show baseline 3
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window);
    if practData.oddBall(i) == false
        Screen('Flip', taskParam.gParam.window, t + 2.1);
    else
        Screen('Flip', taskParam.gParam.window, t + 2.6);
    end
    
    if practData.actRew(i) == 1 && practData.hit(i) == 1
        practData.perf(i) = taskParam.gParam.rewMag;
    end
    
    % Calculate accumulated performance.
    practData.accPerf(i) = sum(practData.perf);% + taskData.perf(i);
    WaitSecs(1);
    
    %Priority(0);
    
end
