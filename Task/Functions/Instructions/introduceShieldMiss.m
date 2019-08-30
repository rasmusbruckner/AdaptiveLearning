function [screenIndex, Data, taskParam] = introduceShieldMiss(taskParam, screenIndex, Data, distMean, cannon)
%INTRODUCESHIELDMISS   This function introduces cannonball misses while showing shield to participant
%
%   Input
%       taskParam:  structure containing task parameters
%       screenIndex: indicates current sceen of instruction phase
%       Data: data from the previous trials // Check this in the future
%       distMean: mean of the outcome-generating distribution
%       cannon: logical that indicates if cannon should be shown during instruction
%
%   Output
%       screenIndex: updated screenIndex 
%       Data: data from the previous trials // Check this in the future
%       taskParam: structure containing task parameters


if isequal(taskParam.gParam.taskType, 'dresden')
    if isequal(subject.group, '1')
        txt = 'Steuere den orangenen Punkt jetzt neben das Ziel der Kanone, so dass du die Kanonenkugel verfehlst und drücke LEERTASTE.';
    else
        txt = 'Steuern Sie den orangenen Punkt jetzt bitte neben das Ziel der Kanone, so dass Sie die Kanonenkugel verfehlen und drücken Sie LEERTASTE.';
    end
    
elseif isequal(taskParam.gParam.taskType, 'oddball')
    txt = 'Now try to place the shield so that you miss the cannonball. Then hit SPACE. ';
elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC')
    txt = 'Now try to place the shield so that you miss the cannonball. Then hit the left mouse button. ';
elseif isequal(taskParam.gParam.taskType, 'chinese')
    if taskParam.gParam.language == 1
        txt = 'Versuche nun dein Schild so zu positionieren, dass du die Kanonenkugel verfehlst. Drücke dann die linke Maustaste.';
    elseif taskParam.gParam.language == 2
        txt = 'Now try to position your shield so that you miss the cannonball. \n\nThen press the left mouse button.';    
    end
end

t = GetSecs;
al_lineAndBack(taskParam)
if isequal(taskParam.gParam.taskType, 'chinese')
    currentContext = 1;
    al_drawContext(taskParam, currentContext)
    al_drawCross(taskParam);
end
al_drawCross(taskParam)
al_drawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1, 1);
WaitSecs(0.5);
Data.tickMark = true;
Data.distMean = distMean;
%outcome = distMean;
Data.tickMark = true;
tickInstruction.savedTickmark = nan;
tickInstruction.previousOutcome = nan;
[taskParam, fw, Data] = al_instrLoopTxt(taskParam, txt,...
    cannon, 'space', distMean, tickInstruction, Data);
if fw == 1
    screenIndex = screenIndex + 1;
end

WaitSecs(0.1);
end