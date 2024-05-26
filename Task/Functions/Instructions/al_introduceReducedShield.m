function al_introduceReducedShield(taskParam, taskData, trial)
%AL_INTRODUCEREDUCEDSHIELD This function demonstrates the
%pupillometry-compatible shield
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       trial: Number of trials
%
%   Output
%       None

% Cycle over trials
% -----------------
for i = 1:trial

    Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    al_drawFixPoint(taskParam)
    al_drawCircle(taskParam)
    Screen('Flip', taskParam.display.window.onScreen);
    WaitSecs(1);

    % Full
    Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    al_drawFixPoint(taskParam)
    al_drawCircle(taskParam)
    taskParam.trialflow.shieldAppearance = 'full';
    al_shield(taskParam, taskData.allShieldSize(i), taskData.pred(i), 1)
    Screen('Flip', taskParam.display.window.onScreen);
    WaitSecs(1);

    % Reduced
    Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    al_drawFixPoint(taskParam)
    al_drawCircle(taskParam)
    taskParam.trialflow.shieldAppearance = 'lines';
    al_shield(taskParam, taskData.allShieldSize(i), taskData.pred(i), 1)
    Screen('Flip', taskParam.display.window.onScreen);
    WaitSecs(1);

end
end