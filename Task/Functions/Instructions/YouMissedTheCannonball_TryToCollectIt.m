function [screenIndex, Data] =...
        YouMissedTheCannonball_TryToCollectIt(screenIndex, Data)

    background = true;
    Data.distMean = 160;
    Data.outcome = 160;
    al_cannonball(taskParam, Data.distMean, Data.outcome, background)
    if Data.memErr <= 9

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

            if isequal(subject.group, '1')
                if isequal(whichPractice, 'followOutcomePractice')
                    txt=sprintf(['Du hast die Kanonenkugel '...
                        'aufgesammelt, aber der Korb war %s. '...
                        'Daher hättest du nichts verdient.'],colNoRew);
                else
                    txt=sprintf(['Du hast die Kanonenkugel '...
                        'aufgesammelt, aber das Schild war %s. '...
                        'Daher hättest du nichts verdient.'],colNoRew);
                end
            else
                if isequal(whichPractice, 'followOutcomePractice')
                    txt=sprintf(['Sie haben die Kanonenkugel '...
                        'aufgesammelt, aber der Korb war %s. '...
                        'Daher hätten Sie nichts verdient.'],colNoRew);
                else
                    txt=sprintf(['Du hast die Kanonenkugel '...
                        'aufgesammelt, aber das Schild war %s. '...
                        'Daher hätten Sie nichts verdient.'],colNoRew); 
                end
            end
            al_lineAndBack(taskParam)
            al_drawCannon(taskParam, Data.distMean)
            al_drawCircle(taskParam)
            if subject.rew == 1
                al_shield(taskParam, 20, Data.pred, 0)
            elseif subject.rew == 2
                al_shield(taskParam, 20, Data.pred, 1)
            end
            al_drawOutcome(taskParam, Data.outcome)
            DrawFormattedText(taskParam.gParam.window.onScreen,txt,...
                taskParam.gParam.screensize(3)*0.1,...
                taskParam.gParam.screensize(4)*0.05,...
                [255 255 255], sentenceLength);
            DrawFormattedText(taskParam.gParam.window.onScreen,...
                taskParam.strings.txtPressEnter,'center',...
                taskParam.gParam.screensize(4)*0.9, [255 255 255]);
            Screen('DrawingFinished',...
                taskParam.gParam.window.onScreen, 1);
            Screen('Flip', taskParam.gParam.window.onScreen, t + 1.6);
            [ keyIsDown, ~, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(taskParam.keys.enter)
                    screenIndex = screenIndex + 1;
                    break
                elseif keyCode(taskParam.keys.delete)
                    screenIndex = screenIndex - 10;
                    break
                end
            end
        end
        WaitSecs(0.1);

    else

        while 1

            if isequal(subject.group, '1')

                txt=['Leider hast du die Kanonenkugel nicht '...
                    'aufgesammelt. Versuche es noch einmal!'];
            else
                txt=['Leider haben Sie die Kanonenkugel nicht '...
                    'aufgesammelt. Versuchen Sie es bitte '...
                    'noch einmal!'];
            end

            al_lineAndBack(taskParam)
            al_drawCircle(taskParam);
            al_drawCross(taskParam);
            al_predictionSpot(taskParam);
            al_drawOutcome(taskParam, Data.outcome);
            al_drawCannon(taskParam, Data.distMean)
            DrawFormattedText(taskParam.gParam.window.onScreen,...
                taskParam.strings.txtPressEnter,'center',...
                taskParam.gParam.screensize(4)*0.9, [255 255 255]);
            DrawFormattedText(taskParam.gParam.window.onScreen,txt,...
                taskParam.gParam.screensize(3)*0.1,...
                taskParam.gParam.screensize(4)*0.05,...
                [255 255 255], sentenceLength);
            Screen('DrawingFinished',taskParam.gParam.window.onScreen);
            t = GetSecs;
            Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
            [ keyIsDown, ~, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(taskParam.keys.enter)
                    screenIndex = screenIndex - 2;
                    break
                elseif keyCode(taskParam.keys.delete)
                    screenIndex = screenIndex - 9;
                    break
                end
            end
        end
        WaitSecs(0.1);

        screenIndex = screenIndex + 1;
    end
    WaitSecs(0.1);
end