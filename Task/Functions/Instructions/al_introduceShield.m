function taskData = al_introduceShield(taskParam, taskData, win, trial, txt)
%AL_INTRODUCESHIELD This function introduces the shield to participants
%
%   Input 
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       win: Determines color of shield
%       trial: Current trial number
%       txt: Presented text
%
%   Output
%       taskData: Task-data-object instance


% todo: check what can be deleted for other verisions. for sleep
% not necessary anymore

% if isequal(taskParam.trialflow.shotAndShield, 'sequential')
%     outcome = taskData.distMean(trial);
%     al_lineAndBack(taskParam)
%     al_drawCircle(taskParam);
%     if isequal(taskParam.gParam.taskType, 'chinese')
%         currentContext = 1;
%         al_drawContext(taskParam, currentContext)
%     end
%     al_drawCross(taskParam);
%     al_predictionSpot(taskParam);
%     al_drawOutcome(taskParam, outcome);
%     al_drawCannon(taskParam, taskData.distMean(trial), 0)
%     Screen('DrawingFinished', taskParam.display.window.onScreen);
%     t = GetSecs;
%     Screen('Flip', taskParam.display.window.onScreen, t + 0.1);
% else
     tUpdated = GetSecs;
%     outcome = taskData.distMean(trial);
% end
% 
% if isequal(taskParam.trialflow.shotAndShield, 'sequential')
% 
% al_lineAndBack(taskParam)
% if isequal(taskParam.gParam.taskType, 'chinese')
%     currentContext = 1;
%     al_drawContext(taskParam, currentContext)
% end
% al_drawCross(taskParam)
% al_drawCircle(taskParam)
% Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
% Screen('Flip', taskParam.display.window.onScreen, t + 0.6, 1);
% end 

% Repeat until participant presses Enter
while 1
    
    % Print background, cannon, and circle
    al_lineAndBack(taskParam)
    al_drawCannon(taskParam, taskData.distMean(trial), 0)
    al_drawCircle(taskParam)
    % todo: use trialflow
    if isequal(taskParam.gParam.taskType, 'chinese')
        currentContext = 1;
        al_drawContext(taskParam, currentContext)
        al_drawCross(taskParam);
    end

    % XX
    if (taskParam.subject.rew == 1 && win) || (taskParam.subject.rew == 2 && ~win)
        al_shield(taskParam, 20, taskData.pred(trial), 1)
    elseif (taskParam.subject.rew == 2 && win) || (taskParam.subject.rew == 1 && ~win)
        al_shield(taskParam, 20, taskData.pred(trial), 0)
    else
        al_shield(taskParam, taskData.allASS(trial), taskData.pred(trial), 1)
    end

    % Added this 21.06.22
    outcome = taskData.distMean(trial);  
    al_drawOutcome(taskParam, outcome) 
    
    % Present instructions
    DrawFormattedText(taskParam.display.window.onScreen, txt, taskParam.display.screensize(3)*0.1, taskParam.display.screensize(4)*0.05, [255 255 255], taskParam.strings.sentenceLength);
    DrawFormattedText(taskParam.display.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.display.screensize(4)*0.9, [255 255 255]);
    
    % Tell PTB that everything has been drawn and flip screen
    Screen('DrawingFinished', taskParam.display.window.onScreen, 1);
    Screen('Flip', taskParam.display.window.onScreen, tUpdated + 1.6);
    
    % Terminate when subject presses enter
    [keyIsDown, ~, keyCode ] = KbCheck;
    if keyIsDown
        if keyCode(taskParam.keys.enter)
            break    
        end
    end
end

WaitSecs(0.1);

end