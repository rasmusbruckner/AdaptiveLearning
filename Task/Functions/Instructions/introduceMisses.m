function [taskData, taskParam] = introduceMisses(taskParam, taskData, whichPractice, txt)
%INTRODUCEMISSES This function introduce misses of the cannonball to participants
%
%   Input
%       taskParam: structure containing task parameters
%       screenIndex: indicates current sceen of instruction phase
%       Data: data from the previous trials // Check this in the future
%       distMean: mean of the outcome-generating distribution
%       whichPractice: indicates current practice condition
%
%   Output
%       screenIndex: updated screenIndex
%       Data: data from the previous trials // Check this in the future
%       taskParam: structure containing task parameters


outcome = taskData.distMean;
taskData.outcome = taskData.distMean;
background = true;
% al_cannonball(taskParam, distMean, outcome, background, 1, 0)
% absTrialStartTime = GetSecs;
if ~ isequal(taskParam.trialflow.shotAndShield, 'sequential')
%al_cannonball(taskParam, outcome, outcome, background, 1, 0, 1, Data, absTrialStartTime)
    i = 1;
    tUpdated = GetSecs + 0.001;
        taskData.hit = 0; 
%    al_cannonMiss(taskParam, Data.distMean(i), Data.outcome(i), background, 1, 0, Data.allASS(i), Data.pred(i), Data.shieldType(i), Data.hit(i), tUpdated)
    al_cannonMiss(taskParam, taskData, i, background, tUpdated)

end
WaitSecs(taskParam.timingParam.outcomeLength);
if (isequal(whichPractice, 'mainPractice') && abs(taskData.predErr) >= 9) || (isequal(whichPractice, 'followCannonPractice')...
        && abs(taskData.predErr) >= 9) || (isequal(whichPractice, 'oddballPractice') && abs(taskData.predErr) >= 9) || (isequal(whichPractice, 'reversal')...
        && abs(taskData.predErr) >= 9) || (isequal(whichPractice, 'chinese') && abs(taskData.predErr) >= 9)

    al_lineAndBack(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        currentContext = 1;
        al_drawContext(taskParam, currentContext)
    end
    
    al_drawCircle(taskParam);
    %al_drawCross(taskParam);
    al_predictionSpot(taskParam);
    al_drawOutcome(taskParam, outcome);
    al_drawCannon(taskParam, taskData.distMean, 0)
    
    DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.display.screensize(4)*0.9, [255 255 255]);
    DrawFormattedText(taskParam.display.window.onScreen,txt, taskParam.display.screensize(3)*0.1, taskParam.display.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    t = GetSecs;
    Screen('Flip', taskParam.display.window.onScreen, t + 0.1);
    while 1
        [ keyIsDown, ~, keyCode ] = KbCheck( taskParam.keys.kbDev );
        if keyIsDown
            if keyCode(taskParam.keys.enter)
                %screenIndex = screenIndex - 1;
                break
            elseif keyCode(taskParam.keys.delete)
                %screenIndex = screenIndex - 2;
                break
            end
        end
    end
else
    screenIndex = screenIndex + 1;
end
WaitSecs(0.1);

end