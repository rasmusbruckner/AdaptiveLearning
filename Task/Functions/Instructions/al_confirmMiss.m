function taskData = al_confirmMiss(taskParam, taskData, win, trial, txt, xyExp, dotCol, dotSize)
%AL_CONFIRMMISS This function shows feedback that shield was missed
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       win: Determines color of shield
%       trial: Current trial number
%       txt: Presented text
%       xyExp: Coordinates of confetti particles
%       dotCol: Confetti colors
%       dotSize: Confetti size
%
%   Output
%       taskData: Task-data-object instance

if ~isequal(taskParam.trialflow.shotAndShield, 'sequential') && isequal(taskParam.trialflow.cannonType, 'standard')
    tUpdated = GetSecs + 0.001;
    background = true;
    taskData.hit(trial) = 0;
    al_cannonMiss(taskParam, taskData, trial, background, tUpdated)
end

% Initialize timing variable
tUpdated = GetSecs;

% Repeat until participant presses Enter
while 1
    
    % Present background, cross, and circle
    al_lineAndBack(taskParam)
    
    al_drawCannon(taskParam, taskData.distMean(trial))
    al_drawCircle(taskParam)
    
    if (taskParam.subject.rew == 1 && win) || (taskParam.subject.rew == 2 && ~win)
        al_shield(taskParam, 20, taskData.pred(trial), 1)
    elseif (taskParam.subject.rew == 2 && win) || (taskParam.subject.rew == 1 && ~win)
        al_shield(taskParam, 20, taskData.pred(trial), 0)
    else
        al_shield(taskParam, taskData.allShieldSize(trial), taskData.pred(trial), 1)
    end

    % Show outcome
    if isequal(taskParam.trialflow.cannonType, 'standard')
    
        al_drawOutcome(taskParam, taskData.distMean(trial))
    
    elseif exist('xyExp', 'var') && exist('dotCol', 'var') && exist('dotSize', 'var')

        % Draw updated dots to animate explosion
        Screen('DrawDots', taskParam.display.window.onScreen, round(xyExp), dotSize, dotCol, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);

    end
    
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
        elseif keyCode(taskParam.keys.esc)
            ListenChar();
            ShowCursor;
            Screen('CloseAll');
            error('User pressed Escape to finish task')
        end
    elseif taskParam.unitTest.run
        WaitSecs(1);
        break
    end
end

WaitSecs(0.1);
end