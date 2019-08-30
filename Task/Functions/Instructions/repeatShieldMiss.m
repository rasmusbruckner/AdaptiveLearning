function [screenIndex, Data, t] = repeatShieldMiss(taskParam, screenIndex, Data, distMean)
%REPEATSHIELDMISS   This function repeats "miss" instruction if participants caugh cannonball
%
%   Input
%       taskParam: structure containing task parameters
%       screenIndex: indicates current sceen of instruction phase
%       Data: data from the previous trials 
%       distMean:  mean of the outcome-generating distribution
%
%   Output
%       screenIndex: updated screenIndex 
%       Data: data from the previous trials
%       t: current timestamp // maybe rename in the future


outcome = Data.outcome;
background = true;
al_cannonball(taskParam, distMean, outcome, background, 1, 0)

if abs(Data.predErr) <= 9
    while 1
        if isequal(taskParam.gParam.taskType, 'dresden')
            if isequal(subject.group, '1')
                
                txt = 'Du hast die Kanonenkugel abgewehrt. Versuche die Kanonenkugel diesmal zu verpassen!';
            else
                
                txt = 'Sie haben die Kanonenkugel abgewehrt. Versuchen Sie die Kanonenkugel diesmal bitte zu verpassen!';
            end
        elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC')
            txt = 'You caught the cannonball. Try to miss it!' ;
        elseif isequal(taskParam.gParam.taskType, 'chinese')
            txt = 'Du hast die Kanonenkugel abgewehrt! Versuche sie zu verfehlen!';
        end
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
        DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.gParam.screensize(4)*0.9, [255 255 255]);
        DrawFormattedText(taskParam.gParam.window.onScreen, txt, taskParam.gParam.screensize(3)*0.1, taskParam.gParam.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
        Screen('DrawingFinished', taskParam.gParam.window.onScreen);
        t = GetSecs;
        Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
        [ keyIsDown, ~, keyCode ] = KbCheck;
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
    if isequal(taskParam.gParam.taskType, 'dresden')
        if isequal(subject.group, '1')
            
            txt = 'Der schwarze Balken zeigt dir wie weit die Kanonenkugel von deinem Punkt entfernt war. Daraufhin siehst du dann...';
        else
            txt = 'Der schwarze Balken zeigt Ihnen wie weit die Kanonenkugel von Ihrem Punkt entfernt war. Daraufhin siehst du dann...';
        end
    elseif isequal(taskParam.gParam.taskType, 'oddball')
        txt = 'Der schwarze Balken zeigt dir wie weit die Kanonenkugel von deinem Punkt entfernt war. Daraufhin siehst du dann...';
    end
    al_lineAndBack(taskParam)
    al_drawCircle(taskParam);
    if isequal(taskParam.gParam.taskType, 'chinese')
        currentContext = 1;
        al_drawContext(taskParam, currentContext)
        al_drawCross(taskParam);
    end
    al_drawCross(taskParam);
    al_predictionSpot(taskParam);
    al_drawOutcome(taskParam, outcome);
    al_drawCannon(taskParam, distMean, 0)
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
    screenIndex = screenIndex + 1;
end

WaitSecs(0.1);

end