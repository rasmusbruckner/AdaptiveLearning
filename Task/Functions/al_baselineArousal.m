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
colorOrder = randperm(size(arousalColors,1));

for i = 1:size(arousalColors,1)

    % Beginning of current color
    blockStartTime = GetSecs();

    while 1

        % Present current color
        Screen('FillRect', taskParam.display.window.onScreen, arousalColors(colorOrder(i), :));
        al_drawFixPoint(taskParam, taskParam.colors.gray)
        Screen('Flip', taskParam.display.window.onScreen);
        
        % todo: send trigger after each first flip when new color comes up
        % Eyelink('message', num2str(trigger_enc.bw_block_offset(rand_bw(1))));
        
        % Check timing
        if (GetSecs() - blockStartTime) >= taskParam.gParam.baselineArousalDuration/3
            break
        end

        % Check for escape key
        taskParam.keys.checkQuitTask();
    end

end
