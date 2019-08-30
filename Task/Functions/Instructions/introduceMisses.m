function [screenIndex, Data, taskParam] = introduceMisses(taskParam, screenIndex, Data, distMean, whichPractice)
%INTRODUCEMISSES   This function introduce misses of the cannonball to participants
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


outcome = distMean;
Data.outcome = distMean;
background = true;
al_cannonball(taskParam, distMean, outcome, background, 1, 0)
WaitSecs(taskParam.timingParam.outcomeLength);
if (isequal(whichPractice, 'mainPractice') && abs(Data.predErr) >= 9) || (isequal(whichPractice, 'followCannonPractice')...
        && abs(Data.predErr) >= 9) || (isequal(whichPractice, 'oddballPractice') && abs(Data.predErr) >= 9) || (isequal(whichPractice, 'reversal')...
        && abs(Data.predErr) >= 9) || (isequal(whichPractice, 'chinese') && abs(Data.predErr) >= 9)
    if isequal(taskParam.gParam.taskType, 'dresden')
        if isequal(subject.group, '1')
            txt = 'Leider hast du die Kanonenkugel vefehlt. Versuche es noch einmal!';
        else
            txt = 'Leider haben Sie die Kanonenkugel vefehlt. Versuchen Sie es bitte noch einmal!';
        end
    elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC') ||...
            (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 2)
        txt = 'You missed the cannonball. Try it again!';
    elseif isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 1
        txt = 'Du hast die Kanonenkugel verfehlt. Versuche es nochmal!';
    end
    
    al_lineAndBack(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        currentContext = 1;
        al_drawContext(taskParam, currentContext)
    end
    
    al_drawCircle(taskParam);
    al_drawCross(taskParam);
    al_predictionSpot(taskParam);
    al_drawOutcome(taskParam, outcome);
    al_drawCannon(taskParam, distMean, 0)
    
    DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.gParam.screensize(4)*0.9, [255 255 255]);
    DrawFormattedText(taskParam.gParam.window.onScreen,txt, taskParam.gParam.screensize(3)*0.1, taskParam.gParam.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
    while 1
        [ keyIsDown, ~, keyCode ] = KbCheck;
        if keyIsDown
            if keyCode(taskParam.keys.enter)
                screenIndex = screenIndex - 1;
                break
            elseif keyCode(taskParam.keys.delete)
                screenIndex = screenIndex - 2;
                break
            end
        end
    end
else
    screenIndex = screenIndex + 1;
end
WaitSecs(0.1);

end