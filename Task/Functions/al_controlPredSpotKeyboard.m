function [breakLoop, taskParam, taskData, keyCode] = al_controlPredSpotKeyboard(taskParam, taskData, trial, startTimestamp, breakKey, keyCode, disableResponseThreshold)
% AL_CONTROLPREDSPOTKEYBOARD This function manages the interaction between
% participants and task if the keyboard is used.
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       trial: Current trial number
%       startTimestamp: Onset of prediction phase for computing RTs
%       breakKey: Key code to lock prediction
%       keyCode: Array of current key press
%       disableResponseThreshold: Optionally activate response time
%                                 limit (if additionally specified in trialflow)
%
%   Ouptut
%       breakLoop: Index response loop should be terminated
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       keyCode: Array of current key press

% Check for optional response-threshold input:
% By default, threshold not active, independent of trialflow
% That way, instructions are without time limit
if ~exist('disableResponseThreshold', 'var') || isempty(disableResponseThreshold)
    disableResponseThreshold = true;
end

% Initialize variable indicating if response loop is terminated or not
breakLoop = false;

% For unit test: simulate keyIsDown, keyCode, and record RT
if ~taskParam.unitTest.run

    if taskParam.gParam.scanner
        
        % MD scanner settings
        % 50 = left key pressed and 54 = released
        % 51 = right key pressed and 55 = released
        [keyIsDown, firstPress, ~, ~, ~] = KbQueueCheck();
        if keyIsDown
            keyCode = zeros(1, 256);
            keyCode(find(firstPress, 1)) = 1;
        end
    else
        [keyIsDown, ~, keyCode] = KbCheck(taskParam.keys.kbDev);
    end

else
    WaitSecs(0.5); % simulate RT = 0.5
    keyIsDown = 1;
    keyCode = zeros(1, 256);
    keyCode(taskParam.keys.space) = 1;
end

% Get initiation RT
% -----------------
% initationRT is nan before first button press. When button is
% pressed for the first time, store time. Thereafter variable is
% not nan anymore and not saved again.

% First case: First keypress (when initiation RT should be recorded)
if keyIsDown && isnan(taskData.initiationRTs(trial))

    % Record initiation RT when any of the allowed keys is pressed
    if keyCode(taskParam.keys.rightKey) || keyCode(taskParam.keys.leftKey) || keyCode(taskParam.keys.rightSlowKey) || keyCode(taskParam.keys.leftSlowKey) || keyCode(taskParam.keys.space)

        % Record the difference between now (RT_Timestamp) and
        % beginning of trial (startTimestamp)
        RT_Timestamp = GetSecs();
        taskData.initiationRTs(trial) = RT_Timestamp - startTimestamp;
    end

    % When space is pressed and prediction spot has not been moved (perseveration),
    % record prediction, RT, prediction timestamp, and indicate that the
    % keyboard loop should be terminated
    if keyCode(taskParam.keys.space)

        if taskParam.unitTest.run
            taskParam.circle.rotAngle = deg2rad(taskData.pred(trial));
        end

        % Record prediction
        taskData.pred(trial) = rad2deg(taskParam.circle.rotAngle);
        %(taskParam.circle.rotAngle / taskParam.circle.unit);

        % RT is equal to initiation RT in this case
        taskData.RT(trial) = taskData.initiationRTs(trial);

        % Record prediction timestamp
        taskData.timestampPrediction(trial) = RT_Timestamp - taskParam.timingParam.ref;

        % Indicate that loop should be terminated
        breakLoop = true;
    end
end


% Here, we separated both conditions for initRT and prediction control
% to make sure that both would be completed even if button press was
% extremely fast (which practically does not happen bc button press is
% longer than one cyle in while loop).

% Second case: When other keys are pressed before space, update orange spot until space
% is pressed

% This is for behavioral cases
if ~taskParam.gParam.scanner

    if keyIsDown && ~breakLoop

        % Fast right movement
        if keyCode(taskParam.keys.rightKey)

            taskParam.circle = rightMovement(taskParam.circle, taskParam.keys.keySpeed);

            % Slow right movement
        elseif keyCode(taskParam.keys.rightSlowKey)

            taskParam.circle = rightMovement(taskParam.circle, taskParam.keys.slowKeySpeed);

            % Fast left movement
        elseif keyCode(taskParam.keys.leftKey)

            taskParam.circle = leftMovement(taskParam.circle, taskParam.keys.keySpeed);


            % Slow left movement
        elseif keyCode(taskParam.keys.leftSlowKey)

            taskParam.circle = leftMovement(taskParam.circle, taskParam.keys.slowKeySpeed);

            % Commit to prediction and terminate response loop
        elseif keyCode(breakKey)

            % Record prediction
            taskData.pred(trial) = rad2deg(taskParam.circle.rotAngle);

            % Record the difference between now (RT_Timestamp) and
            % beginning of trial (startTimestamp)
            RT_Timestamp = GetSecs;
            taskData.timestampPrediction(trial) = RT_Timestamp - taskParam.timingParam.ref;
            taskData.RT(trial) = RT_Timestamp - startTimestamp;
            breakLoop = true;
        end
    end

else

    % This is for scanner and scanner dummy with different keyboard
    % properties
    if ~breakLoop

        % Fast right movement
        if keyCode(taskParam.keys.rightKey)

            taskParam.circle = rightMovement(taskParam.circle, taskParam.keys.keySpeed);

            % Fast left movement
        elseif keyCode(taskParam.keys.leftKey)

            taskParam.circle = leftMovement(taskParam.circle, taskParam.keys.keySpeed);

            % Commit to prediction and terminate response loop
        elseif keyCode(breakKey)

            % Record prediction
            taskData.pred(trial) = rad2deg(taskParam.circle.rotAngle);

            % Record the difference between now (RT_Timestamp) and
            % beginning of trial (startTimestamp)
            RT_Timestamp = GetSecs;
            taskData.timestampPrediction(trial) = RT_Timestamp - taskParam.timingParam.ref;
            taskData.RT(trial) = RT_Timestamp - startTimestamp;
            breakLoop = true;
        end
    end
end

% Third case: Response threshold reached (only if activated)
if disableResponseThreshold == false && taskParam.gParam.useResponseThreshold

timeFromOnset = GetSecs() - startTimestamp;

    if timeFromOnset >= taskParam.gParam.responseThreshold
        breakLoop = true;
    end
end

end
