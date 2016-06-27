function [taskParam, practData] = PractLoop(taskParam, subject, vola,...
    sigma, cannon, condition, LoadData, reversalPackage)
%PRACTLOOP Runs the practice blocks. Depending on the condition, the
%cannon is visible.

if nargin == 7 && isequal(LoadData, 'NoNoise')
    practData = load('OddballNoNoise');
    practData = practData.practData;
    trials = taskParam.gParam.practTrials;
elseif nargin == 7 && isequal(LoadData, 'Noise')
    practData = load('OddballNoise');
    practData = practData.practData;
    trials = taskParam.gParam.practTrials;
elseif nargin == 7 && isequal(LoadData, 'CP_NoNoise')
    if ~taskParam.gParam.oddball
        practData = load('CP_NoNoise');
    elseif taskParam.gParam.oddball
        practData = load('CP_NoNoise_drugstudy');
    end
    practData = practData.practData;
    trials = taskParam.gParam.practTrials;
elseif nargin == 7 && isequal(LoadData, 'CP_Noise')
    if ~taskParam.gParam.oddball
        practData = load('CP_Noise');
    elseif taskParam.gParam.oddball
        practData = load('CP_Noise_drugstudy');
    end
    practData = practData.practData;
    trials = taskParam.gParam.practTrials;
    
elseif isequal(condition, 'reversalPracticeNoiseInv')
    
    practData.outcome = [170 190 195 320];
    practData.distMean = [187 187 187 290];
    practData.shieldType = [1 0 0 1];
    practData.oddBall = [false false false false];
    practData.allASS = [30 20 10 40];
    practData.hit = [0 0 0 0];
    practData.perf = [0 0 0 0];
    
    trials = 4;
    if nargin == 7
        savedTickmark(1) = nan;
        savedTickmarkPrevious(1) = nan;
    else
        savedTickmark = reversalPackage.savedTickmark;
        practData.pred = reversalPackage.pred;
        
    end
else
    practData = GenerateOutcomes(taskParam, vola, sigma, condition);
    trials = practData.trial;
    savedTickmark(1) = nan;
    savedTickmarkPrevious(1) = nan;
end

for i = 1:trials
    
    WaitSecs(rand*taskParam.gParam.jitter);
    
    if subject.rew == 1 && practData.shieldType(i) == 1
        practData.actRew(i) = 1;
    elseif subject.rew == 1 && practData.shieldType(i) == 0
        practData.actRew(i) = 2;
    elseif subject.rew == 2 && practData.shieldType(i) == 1
        practData.actRew(i) = 2;
    elseif subject.rew == 2 && practData.shieldType(i) == 0
        practData.actRew(i) = 1;
    end
    
    if ~isequal(taskParam.gParam.taskType, 'reversal')
        
        while 1
            
            if cannon == true
                
                Cannon(taskParam, practData.distMean(i))
            end
            DrawCircle(taskParam);
            PredictionSpot(taskParam);
            if i > 1
                TickMark(taskParam, practData.pred(i-1), 'pred')
                TickMark(taskParam, practData.outcome(i-1), 'outc')
            end
            DrawCross(taskParam);
            Aim(taskParam, practData.distMean(i))
            
            
            t = GetSecs;
            Screen('DrawingFinished', taskParam.gParam.window.onScreen);
            Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
            
            
            [ keyIsDown, ~, keyCode ] = KbCheck;
            
            if keyIsDown
                if keyCode(taskParam.keys.rightKey)
                    if taskParam.circle.rotAngle <...
                            360*taskParam.circle.unit
                        taskParam.circle.rotAngle =...
                            taskParam.circle.rotAngle +...
                            1*taskParam.circle.unit;
                    else
                        taskParam.circle.rotAngle = 0;
                    end
                elseif keyCode(taskParam.keys.rightSlowKey)
                    if taskParam.circle.rotAngle <...
                            360*taskParam.circle.unit
                        taskParam.circle.rotAngle = ...
                            taskParam.circle.rotAngle +...
                            0.1*taskParam.circle.unit; %0.02
                    else
                        taskParam.circle.rotAngle = 0;
                    end
                elseif keyCode(taskParam.keys.leftKey)
                    if taskParam.circle.rotAngle >...
                            0*taskParam.circle.unit
                        taskParam.circle.rotAngle =...
                            taskParam.circle.rotAngle -...
                            1*taskParam.circle.unit;
                    else
                        taskParam.circle.rotAngle =...
                            360*taskParam.circle.unit;
                    end
                elseif keyCode(taskParam.keys.leftSlowKey)
                    if taskParam.circle.rotAngle >...
                            0*taskParam.circle.unit
                        taskParam.circle.rotAngle =...
                            taskParam.circle.rotAngle -...
                            0.1*taskParam.circle.unit;
                    else
                        taskParam.circle.rotAngle =...
                            360*taskParam.circle.unit;
                    end
                elseif keyCode(taskParam.keys.space)
                    practData.pred(i) =...
                        (taskParam.circle.rotAngle /...
                        taskParam.circle.unit);
                    
                    break
                end
            end
        end
    else
        
        SetMouse(720, 450, taskParam.gParam.window.onScreen)
        press = 0;
        while 1
            [x,y,buttons,focus,valuators,valinfo] =...
                GetMouse(taskParam.gParam.window.onScreen);
            
            x = x-720;
            y = (y-450)*-1 ;
            
            currentDegree = mod( atan2(y,x) .* -180./-pi, -360 )*-1 + 90;
            if currentDegree > 360
                degree = currentDegree - 360;
            else
                degree = currentDegree;
            end
            
            taskParam.circle.rotAngle = degree * taskParam.circle.unit;
            
            % sentenceLength = taskParam.gParam.sentenceLength;
            
            DrawCircle(taskParam)
            DrawCross(taskParam)
            if ~isequal(condition, 'reversalPracticeNoiseInv') &&...
                    ~isequal(condition, 'reversalPracticeNoiseInv2') &&...
                    ~isequal(condition, 'reversalPracticeNoiseInv3')
                Aim(taskParam, practData.distMean(i))
            end
            
            if cannon == true
                Cannon(taskParam, practData.distMean(i))
            else
                DrawCross(taskParam)
            end
            
            hyp = sqrt(x^2 + y^2);
            
            if hyp <= 150
                PredictionSpotReversal(taskParam, x ,y*-1)
            else
                PredictionSpot(taskParam)
            end
            
            if ~isequal(condition, 'reversalPracticeNoiseInv')
                if buttons(2) == 1 &&...
                        i ~= taskParam.gParam.blockIndices(1) &&...
                        i ~= taskParam.gParam.blockIndices(2) + 1 &&...
                        i ~= taskParam.gParam.blockIndices(3) + 1 &&...
                        i ~= taskParam.gParam.blockIndices(4) + 1
                    
                    savedTickmark(i) =...
                        ((taskParam.circle.rotAngle) /...
                        taskParam.circle.unit);
                    WaitSecs(0.2);
                    press = 1;
                elseif i > 1 && press == 0
                    savedTickmarkPrevious(i) = ...
                        savedTickmarkPrevious(i - 1);
                    savedTickmark(i) = savedTickmark(i - 1);
                elseif i == 1
                    savedTickmarPrevious(i) = 0;
                end
                
                if press == 1
                    savedTickmarkPrevious(i) = savedTickmark(i-1);
                end
                
                if i ~= taskParam.gParam.blockIndices(1) &&...
                        i ~= taskParam.gParam.blockIndices(2) + 1 &&...
                        i ~= taskParam.gParam.blockIndices(3) + 1 &&...
                        i ~= taskParam.gParam.blockIndices(4) + 1
                    TickMark(taskParam, practData.pred(i-1), 'pred');
                    TickMark(taskParam, practData.outcome(i-1), 'outc');
                    if press == 1
                        TickMark(taskParam,...
                            savedTickmarkPrevious(i), 'update');
                    end
                    TickMark(taskParam, savedTickmark(i), 'saved');
                end
                
            else
                
                if i == 1
                    TickMark(taskParam, practData.pred(i), 'pred');
                    TickMark(taskParam, reversalPackage.outcome, 'outc');
                    
                else
                    TickMark(taskParam, practData.pred(i-1), 'pred');
                    TickMark(taskParam, practData.outcome(i-1), 'outc');
                end
                TickMark(taskParam, savedTickmark, 'saved');
                
            end
            Screen('DrawingFinished', taskParam.gParam.window.onScreen);
            t = GetSecs;
            
            Screen('Flip', taskParam.gParam.window.onScreen, t + 0.001);
            
            [ keyIsDown, ~, keyCode ] = KbCheck;
            
            if buttons(1) == 1
                
                practData.pred(i) =...
                    (taskParam.circle.rotAngle / taskParam.circle.unit);
                break;
                
            end
            
        end
        
    end
    
    practData.predErr(i) =...
        Diff(practData.outcome(i), practData.pred(i));
    practData.cannonDev(i) =...
        Diff(practData.distMean(i), practData.pred(i));
    
    if i==1
        practData.controlDev(i) = nan;
    else
        practData.controlDev(i) = ...
            Diff(practData.outcome(i-1), practData.pred(i));
    end
    
    background = false;
    if (isequal(condition, 'oddballPractice')...
            && practData.oddBall(i) == true)...
            || (isequal(condition, 'practiceOddball')...
            && practData.oddBall(i) == true)
        WaitSecs(0.5);
    elseif isequal(condition, 'shield')...
            || isequal(condition, 'followOutcomePractice')...
            || isequal(condition, 'oddballPractice')....
            || isequal(condition, 'practiceNoOddball')...
            || isequal(condition, 'practiceOddball')...
            || isequal(condition, 'mainPractice')...
            || isequal(condition, 'followCannonPractice')...
            || isequal(condition, 'reversalPractice')...
            || isequal(condition, 'reversalPracticeNoise')
        Cannonball(taskParam, practData.distMean(i),...
            practData.outcome(i), background)
    end
    
    t = GetSecs;
    
    % Show outcome
    DrawCircle(taskParam);
    if cannon == true
        Cannon(taskParam, practData.distMean(i))
    else
        DrawCross(taskParam)
        
    end
    PredictionSpot(taskParam);
    DrawOutcome(taskParam, practData.outcome(i));
    
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    if isequal(condition, 'mainPractice')...
            || isequal(condition, 'followCannonPractice')...
            || isequal(condition, 'practiceNoOddball')...
            || isequal(condition, 'practiceOddball')...
            || isequal(condition, 'reversalPractice')...
            || isequal(condition, 'reversalPracticeNoise')...
            || isequal(condition, 'reversalPracticeNoiseInv')
        if abs(practData.predErr(i)) <= practData.allASS(i)/2
            practData.hit(i) = 1;
        end
    elseif isequal(condition, 'followOutcomePractice')
        
        if practData.controlDev(i) <= practData.allASS(i)/2
            practData.hit(i) = 1;
        end
    end
    
    if practData.oddBall(i) == false
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
    else
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6);
    end
    
    DrawCircle(taskParam);
    DrawCross(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    
    if practData.oddBall(i) == false
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6);
    else
        Screen('Flip', taskParam.gParam.window.onScreen, t + 1.1);
    end
    
    DrawCircle(taskParam)
    Shield(taskParam, practData.allASS(i),...
        practData.pred(i), practData.shieldType(i))
    
    if cannon == true
        Cannon(taskParam, practData.distMean(i))
    else
        DrawCross(taskParam)
        
    end
    
    DrawOutcome(taskParam, practData.outcome(i))
    
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    
    
    if practData.oddBall(i) == false
        Screen('Flip', taskParam.gParam.window.onScreen, t + 1.6);
    else
        Screen('Flip', taskParam.gParam.window.onScreen, t + 2.1);
    end
    
    % Show baseline 3
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    if practData.oddBall(i) == false
        Screen('Flip', taskParam.gParam.window.onScreen, t + 2.1);
    else
        Screen('Flip', taskParam.gParam.window.onScreen, t + 2.6);
    end
    
    if practData.actRew(i) == 1 && practData.hit(i) == 1
        practData.perf(i) = taskParam.gParam.rewMag;
    end
    
    % Calculate accumulated performance.
    practData.accPerf(i) = sum(practData.perf);
    WaitSecs(1);
    
end

end