function [screenIndex, Data] = YouCollectedTheCannonball_TryToMissIt(taskParam, subject, screenIndex, Data, win)
%YOUCOLLECTEDTHECANNONBALL_TRYTOMISSIT   This function tells participants that they caught the
% cannonball although they were instructed to miss it.
%
%   Input
%       screenIndex: indicates current screen of instruction phase
%       Data: data from the previous trials
%       win: indicates reward condition
%
%   Output
%       screenIndex: updated screenIndex
%       Data: updated Data structure


background = true;
%al_cannonball(taskParam, Data.distMean, Data.outcome, background)
al_cannonball(taskParam, Data.distMean, Data.outcome, background, Data.currentContext, Data.latentState)

if Data.memErr <= 9
    
    while 1
        
        if ~strcmp(taskParam.gParam.taskType, 'oddball') && ~strcmp(taskParam.gParam.taskType, 'reversal')

            if isequal(subject.group, '1')

                txt = 'Du hast die Kanonenkugel aufgesammelt. Versuche die Kanonenkugel diesmal extra nicht aufzusammeln!';
            else
                txt = 'Sie haben die Kanonenkugel aufgesammelt. Versuchen Sie sie bitte extra nicht aufzusammeln!';
            end
        elseif strcmp(taskParam.gParam.taskType, 'oddball') || strcmp(taskParam.gParam.taskType, 'reversal')
            txt = 'You caught the cannonball. Try to miss it!';
        end
        
        al_lineAndBack(taskParam)
        al_drawCircle(taskParam);
        al_drawCross(taskParam);
        al_predictionSpot(taskParam);
        al_drawOutcome(taskParam, Data.outcome);
        al_drawCannon(taskParam, Data.distMean)
        DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.gParam.screensize(4)*0.9, [255 255 255]);
        DrawFormattedText(taskParam.gParam.window.onScreen,txt, taskParam.gParam.screensize(3)*0.1, taskParam.gParam.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
        Screen('DrawingFinished', taskParam.gParam.window.onScreen);
        t = GetSecs;
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
        [ keyIsDown, ~, keyCode ] = KbCheck;
        if keyIsDown
            if keyCode(taskParam.keys.enter)
                screenIndex = screenIndex + 1;
                break
            elseif keyCode(taskParam.keys.delete)
                screenIndex = screenIndex - 5;
                break
            end
        end
    end
    WaitSecs(0.1);
    
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
        if ~strcmp(taskParam.gParam.taskType, 'oddball') && ~strcmp(taskParam.gParam.taskType, 'reversal')

            if isequal(subject.group, '1')

                txt='Weil du die Kanonenkugel nicht aufgesammelt hast, hättest du nichts verdient.';
            else
                txt='Weil Sie die Kanonenkugel nicht aufgesammelt haben, hätten Sie nichts verdient.';

            end
        
        elseif strcmp(taskParam.gParam.taskType, 'oddball') || strcmp(taskParam.gParam.taskType, 'reversal')
            txt = 'You missed the ball so you would earn nothing.';
        end
        
        al_lineAndBack(taskParam)
        al_drawCannon(taskParam, Data.distMean)
        al_drawCircle(taskParam)
        if (subject.rew == 1 && win) || (subject.rew == 2 && ~win)
            al_shield(taskParam, 20, Data.pred, 1)
        elseif (subject.rew == 2 && win) || (subject.rew == 1 && ~win)
            al_shield(taskParam, 20, Data.pred, 0)
        end
        al_drawOutcome(taskParam, Data.outcome)
        DrawFormattedText(taskParam.gParam.window.onScreen,txt, taskParam.gParam.screensize(3)*0.1, taskParam.gParam.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
        DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.gParam.screensize(4)*0.9, [255 255 255]);
        Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
        Screen('Flip', taskParam.gParam.window.onScreen, t + 1.6);
        [ keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(taskParam.keys.enter)
                screenIndex = screenIndex + 1;
                break
            elseif keyCode(taskParam.keys.delete)
                screenIndex = screenIndex - 6;
                break
            end
        end
    end
    WaitSecs(0.1);
    
end
WaitSecs(0.1);
end