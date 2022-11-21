function [screenIndex] = YouDidNotCollectTheCannonBall_TryAgain(taskParam, screenIndex, Data, ~, txt)
%YOUDIDNoTCOLLECTTHECANNONBALL_TRYAGAIN   This function tells participants
%that cannon ball was not caught and that he/she should try again
%
%   Input
%       screenIndex: indicates current screen of instruction phase
%       Data: data from the previous trials
%       distMean: not used anymore, delete in future versions
%       txt: instruction text
%
%   Output
%       screenIndex: updated screenIndex


background = true;
latentState = 0;
currentContext = 0;
%al_cannonball(taskParam, Data.distMean, Data.outcome, background, latentState)
al_cannonball(taskParam, Data.distMean, Data.outcome, background, currentContext, latentState)
if Data.memErr >=9
    
    al_lineAndBack(taskParam)
    al_drawCross(taskParam)
    al_drawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.5, 1);
    
    while 1
        if isequal(taskParam.subject.group, '1')
            txt=['Du hast die Kanonenkugel leider nicht '...
                'aufgesammelt. Versuche es nochmal!'];
        else
            txt=['Sie haben die Kanonenkugel leider nicht '...
                'aufgesammelt. Versuchen Sie es bitte nochmal!'];
        end
        
        al_lineAndBack(taskParam)
        al_drawCircle(taskParam);
        al_drawCross(taskParam);
        al_predictionSpot(taskParam);
        al_drawOutcome(taskParam, Data.outcome);
        al_drawCannon(taskParam, Data.distMean)
        al_tickMark(taskParam, Data.outcome, 'outc')
        al_tickMark(taskParam, Data.pred, 'pred')
        DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.gParam.screensize(4)*0.9, [255 255 255]);
        DrawFormattedText(taskParam.gParam.window.onScreen,txt, taskParam.gParam.screensize(3)*0.1, taskParam.gParam.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
        Screen('DrawingFinished',taskParam.gParam.window.onScreen);
        Screen('Flip', taskParam.gParam.window.onScreen, t + 1.5);
        [ keyIsDown, ~, keyCode ] = KbCheck( taskParam.keys.kbDev );
        if keyIsDown
            if keyCode(taskParam.keys.enter)
                screenIndex = screenIndex - 1 ;
                break
            elseif keyCode(taskParam.keys.delete)
                screenIndex = screenIndex - 5;
                break
            end
        end
    end
else
    al_lineAndBack(taskParam)
    al_drawCircle(taskParam);
    al_drawCross(taskParam);
    al_predictionSpot(taskParam);
    al_drawOutcome(taskParam, Data.outcome);
    al_drawCannon(taskParam, Data.distMean)
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
    al_lineAndBack(taskParam)
    al_drawCross(taskParam)
    al_drawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6, 1);
    while 1
        
        al_lineAndBack(taskParam)
        al_drawCannon(taskParam, Data.distMean)
        al_drawCircle(taskParam)
        
        if taskParam.subject.rew == 1
            al_shield(taskParam, 20, Data.pred, 1)
        elseif taskParam.subject.rew == 2
            al_shield(taskParam, 20, Data.pred, 0)
            
        end
        al_drawOutcome(taskParam, Data.outcome)
        DrawFormattedText(taskParam.gParam.window.onScreen,txt, taskParam.gParam.screensize(3)*0.1, taskParam.gParam.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
        DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.gParam.screensize(4)*0.9, [255 255 255]);
        Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
        Screen('Flip', taskParam.gParam.window.onScreen, t + 1.6);
        [ keyIsDown, ~, keyCode ] = KbCheck( taskParam.keys.kbDev );
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
end

WaitSecs(0.1);

end
