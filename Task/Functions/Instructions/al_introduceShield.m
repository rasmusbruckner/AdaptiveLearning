function taskData = al_introduceShield(taskParam, taskData, win, trial, txt, xyExp, dotCol, dotSize)
%AL_INTRODUCESHIELD This function introduces the shield to participants
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       win: Determines color of shield
%       trial: Current trial number
%       txt: Presented text
%       xyExp: Optional confetti-particles (location)
%       dotCol: Optional confetti-particles (color)
%       dotSize: Optional confetti-particles (size)
%
%   Output
%       taskData: Task-data-object instance


% If shield and shot presented separately, show fixation cross first
if isequal(taskParam.trialflow.shotAndShield, 'separately')
    al_lineAndBack(taskParam)
    al_drawCircle(taskParam)
    al_drawCross(taskParam)

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
    tUpdated = GetSecs;
    Screen('Flip', taskParam.display.window.onScreen, tUpdated +0.5);
end

% Time stamp
tUpdated = GetSecs();

% Repeat until participant presses Enter
while 1

    % Print background, cannon, and circle
    al_lineAndBack(taskParam)
    al_drawCannon(taskParam, taskData.distMean(trial))
    al_drawCircle(taskParam)

    % Present different shield types
    if (taskParam.subject.rew == 1 && win) || (taskParam.subject.rew == 2 && ~win)
        al_shield(taskParam, 20, taskData.pred(trial), 1)
    elseif (taskParam.subject.rew == 2 && win) || (taskParam.subject.rew == 1 && ~win)
        al_shield(taskParam, 20, taskData.pred(trial), 0)
    else
        al_shield(taskParam, taskData.allASS(trial), taskData.pred(trial), 1)
    end

    if ~exist('xyExp', 'var') && ~exist('dotCol', 'var') && ~exist('dotSize', 'var')
        
        % Present outcome 
        outcome = taskData.distMean(trial);
        al_drawOutcome(taskParam, outcome)

    elseif exist('xyExp', 'var') && exist('dotCol', 'var') && exist('dotSize', 'var')

        % Show confetti dots
        Screen('DrawDots', taskParam.display.window.onScreen, round(xyExp), dotSize, dotCol, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    end

    % Show text
    DrawFormattedText(taskParam.display.window.onScreen, txt, taskParam.display.screensize(3)*0.1, taskParam.display.screensize(4)*0.05, [255 255 255], taskParam.strings.sentenceLength);
    DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.display.screensize(4)*0.9, [255 255 255]);

    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
    Screen('Flip', taskParam.display.window.onScreen, tUpdated +0.5);% 1.6

    % Terminate when subject presses enter
    [keyIsDown, ~, keyCode ] = KbCheck( taskParam.keys.kbDev );
    if keyIsDown
        if keyCode(taskParam.keys.enter)
            break
        end
    end
end

WaitSecs(0.1);

end