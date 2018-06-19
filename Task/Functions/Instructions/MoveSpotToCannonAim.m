function [screenIndex, Data, taskParam] =...
        MoveSpotToCannonAim(taskParam, screenIndex, txt, distMean, Data, cannon)

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
