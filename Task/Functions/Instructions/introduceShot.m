function [screenIndex, Data, taskParam] = introduceShot(taskParam, screenIndex, introduceNeedle, distMean, cannon)
%INTRODUCESHOT   Introduce shot of the cannon
%
%   Input
%       taskParam: structure containing task parameters
%       screenIndex: indicates current sceen of instruction phase
%       introduceNeedle: indicates if needle that points to cannon aim should be introduced
%       cannon: logical that indicates if cannon should be shown during instruction
%   Output
%       screenIndex: updated screenIndex
%       Data: data from the trials
%       taskParam: structure containing task parameters


if introduceNeedle
    if isequal(taskParam.gParam.taskType, 'dresden')
        if isequal(subject.group, '1')
            txt = 'Das Ziel der Kanone wird mit der schwarzen Nadel angezeigt. Drücke LEERTASTE, damit die Kanone schießt.';
        else
            txt = 'Das Ziel der Kanone wird mit der schwarzen Nadel angezeigt. Drücke Sie bitte LEERTASTE, damit die Kanone schießt.';
        end
    elseif isequal(taskParam.gParam.taskType, 'oddball')
        txt = 'The aim of the cannon is indicated with the black line. Hit SPACE to initiate a cannon shot.';
    elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC') ||(isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 2)
        %txt = 'The aim of the cannon is indicated with the black line. Hit the left mouse button to initiate a cannon shot.';
        txt = 'The aim of the cannon is indicated by the black line. \n\nHit the left mouse button to initiate a cannon shot.';
    elseif (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 1)
        txt = 'Das Ziel der Kanone wird mit der schwarzen Linie angezeigt. Drücke die linke Maustaste, damit die Kanone schießt.';
    end
else
    if isequal(subject.group, '1')
        txt = 'Drücke LEERTASTE, damit die Kanone schießt.';
    else
        txt = 'Drücken Sie bitte LEERTASTE, damit die Kanone schießt.';
    end
end

tickInstruction.savedTickmark = nan;
tickInstruction.previousOutcome = nan;
[taskParam, fw, Data] = al_instrLoopTxt(taskParam, txt, cannon, 'space', distMean, tickInstruction);

if fw == 1
    outcome = distMean;
    background = true;
    al_cannonball(taskParam, distMean, outcome, background, 1, 0)
    screenIndex = screenIndex + 1;
    WaitSecs(taskParam.timingParam.outcomeLength);
    return
end

WaitSecs(0.1);

end