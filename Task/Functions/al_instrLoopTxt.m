function [taskParam, Data, savedTickmark] = al_instrLoopTxt(taskParam, txt, button, tickInstruction, Data, break_key)
%AL_INSTRLOOPTXT This function manages task instructions while participants interact with the tak
%
%   Input
%       taskParam: structure containing task paramters
%       txt: instruction text
%       cannon: indicates if cannon should be depicted
%       button: indicates which button has to be pressed to continue to next screen
%       distMean: mean of the current outcome distribution (cannon)
%       tickInstruction: instructions if additional tick mark is displayed 
%       Data: practice session data structure
%
%   Output
%       taskParam: structure containing task paramters
%       fw: indicates if participant has indicated to go "forward"
%       Data: practice session data structure
%       savedTickmark: position where participants has set tick mark (optionally)

% Todo: some of the mouse code should be put in function that is reused
% across scripts. For keyboard, this has already been implemented. Also
% needs to be cleaned and commented. Is it possible to get rid of this
% function if mouse loop is properly updated?


if nargin < 6
    break_key = taskParam.keys.space;
end
savedTickmark(1) = nan;
previousTickmark = nan;

if ~isnan(tickInstruction.savedTickmark)
    previousTickmark = tickInstruction.savedTickmark;
    press = 1;
else
    savedTickmark(1) = nan;
    press = 0;
end

Data.initiationRTs = nan; 


% todo: use trialflow solution instead of taskType
if ~isequal(taskParam.gParam.taskType, 'reversal') && ~isequal(taskParam.gParam.taskType, 'chinese') && ~isequal(taskParam.gParam.taskType, 'ARC')
   
    while 1    
        al_lineAndBack(taskParam)
        sentenceLength = taskParam.gParam.sentenceLength;
        DrawFormattedText(taskParam.display.window.onScreen,txt, taskParam.display.screensize(3)*0.1,...
            taskParam.display.screensize(4)*0.05, [255 255 255], sentenceLength);
        if isequal(taskParam.trialflow.cannon, 'show cannon') 
            al_drawCannon(taskParam, Data.distMean);
        end
        
         % Presentfixation cross, and circle
        al_drawCircle(taskParam)
        al_predictionSpot(taskParam)

        if tickInstruction.tickMark == true
            
            al_tickMark(taskParam, Data.outcome(end), 'outc')
            al_tickMark(taskParam, Data.pred(end), 'pred')
        end
        
        al_aim(taskParam, Data.distMean)
        
       % if isequal(button, 'arrow')
        %    txtPressEnter='Zurück mit Löschen - Weiter mit Enter';
            DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter ,'center', taskParam.display.screensize(4)*0.9);
        %end
        
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        t = GetSecs;
        Screen('Flip', taskParam.display.window.onScreen, t + 0.001);
        
        trial = 1;
        initRT_Timestamp = 1;
        [break_loop, taskParam, Data] = al_controlPredSpotKeyboard(Data, trial, taskParam, initRT_Timestamp, break_key);
    
        if break_loop == true
            break
        end

        
    end
else
    
    SetMouse(720, 450, taskParam.display.window.onScreen)
    
    while 1
        [x,y,buttons] = GetMouse(taskParam.display.window.onScreen);
        
        x = x-720;
        y = (y-450)*-1 ;
        
        % todo: this should be put in a function that is reused in other
        % functions too
        currentDegree = mod(atan2(y,x) .* -180./-pi, -360 )*-1 + 90;
        if currentDegree > 360 
            degree = currentDegree - 360;
        else
            degree = currentDegree;
        end
        
        taskParam.circle.rotAngle = degree * taskParam.circle.unit;
        
        al_lineAndBack(taskParam)
        sentenceLength = taskParam.gParam.sentenceLength;
        DrawFormattedText(taskParam.display.window.onScreen,txt, taskParam.display.screensize(3)*0.1, taskParam.display.screensize(4)*0.05, [255 255 255], sentenceLength);

        if isequal(taskParam.gParam.taskType, 'chinese')
            currentContext = 1;
            taskParam.gParam.showCue = false;
            al_drawContext(taskParam, currentContext)
        end
        
        al_drawCircle(taskParam)
       
        if isnan(tickInstruction.savedTickmark)
            al_aim(taskParam, Data.distMean)
        end
        
        if isequal(taskParam.trialflow.cannon, 'show cannon')
            al_drawCannon(taskParam, Data.distMean, 0)
        end
        
        if isequal(button, 'arrow')
            DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter ,'center', taskParam.display.screensize(4)*0.9);
        end
        
        % todo: also check if this can be done more efficiently 
        hyp = sqrt(x^2 + y^2);
        if hyp <= 150
            al_predictionSpotReversal(taskParam, x ,y*-1)
        else
            al_predictionSpot(taskParam)
        end
        
        if buttons(2) == 1 
            
            savedTickmark(i) = ((taskParam.circle.rotAngle) / taskParam.circle.unit);
            Data.tickCannonDev = al_diff(Data.distMean, savedTickmark);
            
            WaitSecs(0.2);
            press = 1;
            
        end
        
        if press == 1
            al_tickMark(taskParam, tickInstruction.previousOutcome, 'outc');
            al_tickMark(taskParam, tickInstruction.previousPrediction, 'pred');
            al_tickMark(taskParam, savedTickmark(i), 'saved');
            al_tickMark(taskParam, previousTickmark, 'saved');  
        end
        
        Screen('DrawingFinished', taskParam.display.window.onScreen);
        t = GetSecs;
        
        Screen('Flip', taskParam.display.window.onScreen, t + 0.001);
        
        [ keyIsDown, ~, keyCode ] = KbCheck;
        
        if (keyIsDown && (isequal(button, 'arrow') && keyCode(taskParam.keys.enter))) || (isequal(button, 'space') &&  buttons(1) == 1)
            
            Data.pred = (taskParam.circle.rotAngle / taskParam.circle.unit);
            break;
            
        end
    end
end

% todo: wrong names -- update and make sure it does not disrupt anything 
Data.predErr = al_diff(Data.distMean, Data.pred);
Data.memErr = al_diff(Data.outcome, Data.pred);
end