function al_baselineArousal(taskParam, file_name_suffix)
%AL_BASELINEAROUSAL This function presents the screens to measure baseline
% arousal
%
%   It's implemented with a while condition so that we can break out of the
%   loop any time using the escape button.
%
%   Input
%       taskParam: Task-parameter-object instance
%       file_name_suffix: 1st or 2nd baseline session
%
%   Output
%       None

% Initialize and start eye-tracker
if taskParam.gParam.eyeTracker
    taskParam.eyeTracker = taskParam.eyeTracker.initializeEyeLink(taskParam, file_name_suffix);
    taskParam = taskParam.eyeTracker.startRecording(taskParam);
end

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

    % Presenting trial number at the bottom of the eyetracker display - optional
    if taskParam.gParam.eyeTracker && isequal(taskParam.trialflow.exp, 'exp')
        if isequal(taskParam.gparam.trackerVersion, 'eyelink')
            Eyelink('command', 'record_status_message "TRIAL %d/%d"', i, 3);
            Eyelink('message', 'TRIALID %d', i);
        elseif isequal(taskParam.gparam.trackerVersion, 'SMI')
            taskParam.eyeTracker.el.sendMessage(sprintf('TRIALID BaseAr %d', i));
        end
    end

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
        taskParam.keys.checkQuitTask(taskParam);
    end

end

% Save Eyelink data
% -----------------

if taskParam.gParam.eyeTracker% && isequal(taskParam.trialflow.saveEtData, 'true')
    if isequal(taskParam.gparam.trackerVersion, 'eyelink')
        et_path = pwd;
        et_file_name=[taskParam.eyeTracker.et_file_name, '.edf'];
        al_saveEyelinkData(et_path, et_file_name)
        Eyelink('StopRecording');

    elseif isequal(taskParam.gparam.trackerVersion, 'SMI')
        et_path = pwd;
        et_file_name=[taskParam.eyeTracker.et_file_name, '.edf'];
        al_saveEyelinkData(et_path, et_file_name) 
        taskParam.eyeTracker.el.stopRecording();
    end
end

% if taskParam.gParam.eyeTracker
%     et_path = pwd;
%     et_file_name=[et_file_name, '.edf'];
%     al_saveEyelinkData(et_path, et_file_name)
%     Eyelink('StopRecording');
% end
