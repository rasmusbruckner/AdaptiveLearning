function [screenIndex, Data, taskParam] = introduceSpot(taskParam, screenIndex, distMean, Data, cannon)
%INTRODUCESPOT   Introduces orange spot to participant
%
%   Input
%       taskParam: structure containing task parameters
%       screenIndex: indicates current sceen of instruction phase
%       distMean: mean of the outcome-generating distribution
%       Data: data from the previous trials // Check this in the future
%       cannon: logical that indicates if cannon should be shown during instruction
%   Output
%       screenIndex: updated screenIndex
%       Data: data from the trials
%       taskParam: structure containing task parameters

if isequal(taskParam.gParam.taskType, 'dresden')
    if isequal(subject.group, '1')
        txt=['Der schwarze Strich zeigt dir die Position der letzten Kugel. Der orangene Strich zeigt dir die '...
            'Position deines letzten Schildes. Steuere den orangenen Punkt jetzt auf das Ziel der Kanone und drücke LEERTASTE.'];
    else
        txt=['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. Der orangene Strich zeigt Ihnen die '...
            'Position Ihres letzten Schildes. Steuern Sie den orangenen Punkt jetzt bitte auf das Ziel der Kanone und drücken Sie LEERTASTE.'];
    end
elseif isequal(taskParam.gParam.taskType, 'oddball')
    txt = 'Move the orange spot to the part of the circle, where the cannon is aimed and press SPACE.';
elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC') || (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 2)
    txt = 'Move the orange spot to the part of the circle, where the cannon is aimed and press the left mouse button.';
elseif (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 1)
    txt = 'Bewege den orangenen Punkt zu der Stelle auf dem Planeten auf die die Kanone zielt und drücke die linke Maustaste.';
end
t = GetSecs;
al_lineAndBack(taskParam)
al_drawCross(taskParam)
al_drawCircle(taskParam)
if isequal(taskParam.gParam.taskType, 'chinese')
    currentContext = 1;
    al_drawContext(taskParam, currentContext)
end
Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1, 1);
WaitSecs(0.5);
Data.tickMark = true;
tickInstruction.savedTickmark = nan;
[taskParam, fw, Data] = al_instrLoopTxt(taskParam, txt, cannon, 'space', distMean, tickInstruction, Data); % Data.distMean

if fw == 1
    screenIndex = screenIndex + 1;
end
end
