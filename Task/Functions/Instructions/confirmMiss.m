function [screenIndex, Data, t] = confirmMiss(taskParam, subject, screenIndex, Data, t, distMean, win)
%CONFIRMMISS   Feedback that shield was indeed missed
%
%   Input
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%       screenIndex: indicates current sceen of instruction phase
%       Data: data from the previous trials // Check this in the future
%       t: previous timestamp // maybe rename in the future
%       distMean: mean of the outcome-generating distribution
%       win? 
%   Output
%       screenIndex: updated screenIndex 
%       Data: data from the previous trials // Check this in the future
%       t: current timestamp // maybe rename in the future


if isequal(taskParam.gParam.taskType, 'dresden')
    if isequal(subject.group, '1')
        txt = 'In diesem Fall hast du die Kanonenkugel verpasst.';
    else
        txt = 'In diesem Fall haben Sie die Kanonenkugel verpasst.';
    end
elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType,'reversal') ||isequal(taskParam.gParam.taskType,'ARC')
    txt = 'In this case you missed the cannonball.';
elseif isequal(taskParam.gParam.taskType, 'chinese')
    if taskParam.gParam.language == 1
        txt = 'In diesem Fall hast du die Kanonenkugel verfehlt.';
    elseif taskParam.gParam.language == 2
        txt = 'In this case you missed the cannonball.';
    end
end

outcome = distMean;
al_lineAndBack(taskParam)
if isequal(taskParam.gParam.taskType, 'chinese')
    currentContext = 1;
    al_drawContext(taskParam, currentContext)
    al_drawCross(taskParam);
end
al_drawCross(taskParam)
al_drawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6, 1);
while 1
    
    al_lineAndBack(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        currentContext = 1;
        al_drawContext(taskParam, currentContext)
        al_drawCross(taskParam);
    end
    al_drawCannon(taskParam, distMean, 0)
    al_drawCircle(taskParam)
    if (subject.rew == 1 && win) || (subject.rew == 2 && ~win)
        al_shield(taskParam, 20, Data.pred, 1)
    elseif (subject.rew == 2 && win) || (subject.rew == 1 && ~win)
        al_shield(taskParam, 20, Data.pred, 0)
    else
        al_shield(taskParam, 20, Data.pred, 1)
    end
    al_drawOutcome(taskParam, outcome)
    DrawFormattedText(taskParam.gParam.window.onScreen,txt, taskParam.gParam.screensize(3)*0.1, taskParam.gParam.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
    DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.gParam.screensize(4)*0.9, [255 255 255]);
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    Screen('Flip', taskParam.gParam.window.onScreen, t + 1.2);
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(taskParam.keys.enter)
            screenIndex = screenIndex + 1;
            break
        elseif keyCode(taskParam.keys.delete)
            screenIndex = screenIndex - 6;
            break
        end
    end
end
WaitSecs(0.1);
end