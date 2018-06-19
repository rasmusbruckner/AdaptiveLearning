function [screenIndex, Data] = MoveSpotToLastOutcome...
        (screenIndex, Data, txt)
    t = GetSecs;
    al_lineAndBack(taskParam)
    al_drawCross(taskParam)
    al_drawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1, 1);
    WaitSecs(0.5);
    Data.tickMark = true;
    [taskParam, fw, Data] = al_instrLoopTxt(taskParam,...
        txt, cannon, 'space', Data.distMean, Data);

    if fw == 1
        screenIndex = screenIndex + 1;
    end
end
