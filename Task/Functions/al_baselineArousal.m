function al_baselineArousal(taskParam)
%AL_BASELINEAROUSAL This function presents the screens to measure baseline
% arousal
%
%   It's implemented with a while condition so that we can break out of the
%   loop any time using the escape button.
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None

% Define color and random color order
arousalColors = [taskParam.colors.black; taskParam.colors.white; (taskParam.colors.black + taskParam.colors.white) / 2];
arousalColorsNames = {'black', 'white', 'gray'};
colorOrder = randperm(size(arousalColors,1));

for i = 1:size(arousalColors,1)
    
    % Only send trigger on first interation
    firstIteration = true;

    % Beginning of current color
    blockStartTime = GetSecs();

    while 1

        % Present current color
        Screen('FillRect', taskParam.display.window.onScreen, arousalColors(colorOrder(i), :));
        al_drawFixPoint(taskParam, taskParam.colors.gray, true)
        Screen('Flip', taskParam.display.window.onScreen);
        
        % Send trigger after first flip
        if firstIteration
            al_sendTrigger(taskParam, nan, 'baselineArousal', i, arousalColorsNames{colorOrder(i)});
            firstIteration = false;
        end

        % Check timing
        if (GetSecs() - blockStartTime) >= taskParam.gParam.baselineArousalDuration/3
            break
        end

        % Check for escape key
        taskParam.keys.checkQuitTask();
    end

end
