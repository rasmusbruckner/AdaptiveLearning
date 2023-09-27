function taskData = al_confirmHelicopterMiss(taskParam, taskData, trial, txt, xyExp)
%AL_CONFIRMHELICOPTERMISS This function shows feedback that the outcome was
%missed in helicopter task
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       win: Determines color of shield
%       trial: Current trial number
%       txt: Presented text
%       xyExp: Position of drug icons
%
%   Output
%       taskData: Task-data-object instance


% Initialize timing variable
tUpdated = GetSecs;

% Repeat until participant presses Enter
while 1
    
    % Present task screen
    al_lineAndBack(taskParam)
    al_showHelicopter(taskParam, taskData.distMean(trial))
    al_drawCircle(taskParam)
    al_shield(taskParam, taskData.allASS(trial), taskData.pred(trial), 1)
    al_showDoctor(taskParam, taskData.pred(trial))
   
    % Present textures
    cannonPosition = OffsetRect(taskParam.display.pillImageRect, xyExp(1,1), xyExp(2,1));
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.pill1Txt,[], cannonPosition, 0); 
    cannonPosition = OffsetRect(taskParam.display.pillImageRect, xyExp(1,2), xyExp(2,2));
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.pill2Txt,[], cannonPosition, 0); 
    cannonPosition = OffsetRect(taskParam.display.pillImageRect, xyExp(1,3), xyExp(2,3));
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.pill3Txt,[], cannonPosition, 0); 
    cannonPosition = OffsetRect(taskParam.display.pillImageRect, xyExp(1,4), xyExp(2,4));
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.pill4Txt,[], cannonPosition, 0); 
    cannonPosition = OffsetRect(taskParam.display.syringeImageRect, xyExp(1,5), xyExp(2,5));
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.syringeTxt,[], cannonPosition, 0);
    
    % Present instructions
    DrawFormattedText(taskParam.display.window.onScreen,txt, taskParam.display.screensize(3)*0.1, taskParam.display.screensize(4)*0.05, [255 255 255], taskParam.strings.sentenceLength);
    DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.display.screensize(4)*0.9, [255 255 255]);
    
    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
    Screen('Flip', taskParam.display.window.onScreen, tUpdated + 1.2);
    
    % Terminate when subject presses enter
    [keyIsDown, ~, keyCode] = KbCheck( taskParam.keys.kbDev );
    if keyIsDown
        if keyCode(taskParam.keys.enter)
            break
        end
    end
end

WaitSecs(0.1);
end