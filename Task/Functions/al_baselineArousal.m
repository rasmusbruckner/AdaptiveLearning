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

% Define color and random color order (black and white)
arousalColors = [taskParam.colors.black; taskParam.colors.white];
arousalColorsNames = {'black', 'white'};
colorOrder = randperm(size(arousalColors,1));

% Add gray so that it appears last
arousalColorsNames{3} = 'gray';
arousalColors(3,:) = (taskParam.colors.black + taskParam.colors.white) / 2;
colorOrder(3) = 3;

% Cycle over colors
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
