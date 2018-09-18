function [screenIndex, Data, taskParam] = MoveSpotToCannonAim(taskParam, screenIndex, distMean, Data, cannon)

if isequal(taskParam.gParam.taskType, 'dresden')
    if isequal(subject.group, '1')
        
        txt = 'Versuche die Kanonenkugel jetzt wieder zu abzuwehren.';
    else
        txt = 'Versuchen Sie bitte die Kanonenkugel wieder zu abzuwehren.';
        
    end
elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType,'reversal')
    txt = 'Now try to catch the ball.';
end
if isequal(taskParam.gParam.taskType, 'dresden')
    if isequal(subject.group, '1')
        txt = 'Versuche die Kanonenkugel jetzt wieder zu abzuwehren.';
    else
        txt = 'Versuchen Sie die Kanonenkugel jetzt wieder zu abzuwehren.';
    end
elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType, 'reversal')
    txt = 'Now try to catch the ball.';
end

if isequal(taskParam.gParam.taskType, 'dresden')
    if isequal(subject.group, '1')
        txt = ['Der schwarze Strich zeigt dir die Position der letzten Kugel. Der orangene Strich zeigt dir die '...
            'Position deines letzten Schildes. Steuere den orangenen Punkt jetzt auf das Ziel der Kanone und drücke LEERTASTE.'];
    else
        txt = ['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. Der orangene Strich zeigt Ihnen die Position Ihres letzten Schildes. '...
            'Steuern Sie den orangenen Punkt jetzt bitte auf das Ziel der Kanone und drücken Sie LEERTASTE.'];
    end
elseif isequal(taskParam.gParam.taskType, 'oddball')
    txt = 'Move the orange spot to the part of the circle, where the cannon is aimed and press SPACE.';
elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC')|| (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 2)
    txt = 'Move the orange spot to the part of the circle, where the cannon is aimed and press the left mouse button.';
elseif isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 1
    txt = 'Bewege den orangenen Punkt zu der Stelle auf dem Planeten auf die die Kanone zielt und drücke die linke Maustaste.';
end
t = GetSecs;
al_lineAndBack(taskParam)
if isequal(taskParam.gParam.taskType, 'chinese')
    currentContext = 1;
    al_drawContext(taskParam, currentContext)
end
al_drawCross(taskParam)
al_drawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1, 1);
WaitSecs(0.5);

Data.tickMark = true;
Data.distMean = distMean;
tickInstruction.savedTickmark = nan;
tickInstruction.previousOutcome = nan;
[taskParam, fw, Data, savedTickmark] = al_instrLoopTxt(taskParam,...
    txt, cannon, 'space', distMean, tickInstruction, Data);
if fw == 1
    screenIndex = screenIndex + 1;
end
WaitSecs(0.1);
end
