function [screenIndex, Data] = introduceShield(taskParam, subject, screenIndex, Data,  distMean, win)
%INTRODUCESHIELD   Introduces shield to participant
%
%   Input 
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%       screenIndex: indicates current sceen of instruction phase
%       Data: data from the previous trials // Check this in the future
%       distMean: mean of the outcome-generating distribution
%       win: ?
%   Output
%       screenIndex: updated screenIndex 
%       Data: data from the previous trials // Check this in the future
%


if isequal(taskParam.gParam.taskType, 'dresden')
    if isequal(subject.group, '1')
        txt = ['Das Schild erscheint nach dem Schuss. In diesem Fall hast du die Kanonenkugel abgewehrt. '...
            'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, zählt es als Treffer.'];
    else
        txt = ['Das Schild erscheint nach dem Schuss. In diesem Fall haben Sie die Kanonenkugel abgewehrt. '...
            'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, zählt es als Treffer.'];
    end
elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType,'reversal') || isequal(taskParam.gParam.taskType,'ARC')
    txt = ['After the cannon is shot you will see the shield. In this case you caught the '...
        'ball. If at least half of the ball overlaps with the shield then it is a "catch".'];
elseif isequal(taskParam.gParam.taskType, 'chinese')
    if taskParam.gParam.language == 1
        txt = ['Dein Schild erscheint nach dem Schuss des Raumschiffs. In diesem Fall hast du die Kanonenkugel abgewehrt. Wenn mindestens '...
            'die Hälfte der Kugel auf dem Schild ist, hast du sie erfolgreich abgewehrt.'];
    elseif taskParam.gParam.language == 2
        txt = ['After the cannon is shot you will see the shield. \n\nIn this case you caught the '...
        'ball. \n\nIf at least half of the ball overlaps with the shield then it is a "catch".'];   
    end
end

outcome = distMean;
al_lineAndBack(taskParam)
al_drawCircle(taskParam);
if isequal(taskParam.gParam.taskType, 'chinese')
    currentContext = 1;
    al_drawContext(taskParam, currentContext)
end
al_drawCross(taskParam);
al_predictionSpot(taskParam);
al_drawOutcome(taskParam, outcome);
al_drawCannon(taskParam, distMean, 0)
Screen('DrawingFinished', taskParam.gParam.window.onScreen);
t = GetSecs;
Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
al_lineAndBack(taskParam)
if isequal(taskParam.gParam.taskType, 'chinese')
    currentContext = 1;
    al_drawContext(taskParam, currentContext)
end
al_drawCross(taskParam)
al_drawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6, 1);

while 1
    al_lineAndBack(taskParam)
    al_drawCannon(taskParam, distMean, 0)
    al_drawCircle(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        currentContext = 1;
        al_drawContext(taskParam, currentContext)
        al_drawCross(taskParam);
    end
    if (subject.rew == 1 && win) || (subject.rew == 2 && ~win)
        al_shield(taskParam, 20, Data.pred, 1)
    elseif (subject.rew == 2 && win) || (subject.rew == 1 && ~win)
        al_shield(taskParam, 20, Data.pred, 0)
    else
        al_shield(taskParam, 20, Data.pred, 1)
    end
    al_drawOutcome(taskParam, outcome)
    DrawFormattedText(taskParam.gParam.window.onScreen, txt, taskParam.gParam.screensize(3)*0.1, taskParam.gParam.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
    DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.gParam.screensize(4)*0.9, [255 255 255]);
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    Screen('Flip', taskParam.gParam.window.onScreen, t + 1.6);
    
    [ keyIsDown, ~, keyCode ] = KbCheck;
    if keyIsDown
        if keyCode(taskParam.keys.enter)
            screenIndex = screenIndex + 1;
            break
        elseif keyCode(taskParam.keys.delete)
            screenIndex = screenIndex - 3;
            break
        end
    end
end

WaitSecs(0.1);

end