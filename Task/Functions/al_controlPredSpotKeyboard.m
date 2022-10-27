function [breakLoop, taskParam, taskData] = al_controlPredSpotKeyboard(taskParam, taskData, trial, initRT_Timestamp, breakKey)
% AL_CONTROLPREDSPOTKEYBOARD This function manages the interaction between
% participants and task if the keyboard is used.
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       trial: Current trial number
%       initRT_Timestamp: Onset of prediction phase for computing initRT
%       breakKey: Key code to lock prediction
%   Ouptut
%       breakLoop: Index response loop should be terminated
%       taskData: Task-parameter-object instance
%       taskParam: Task-data-object instance

% Initialize variable indicating if response loop is terminated or not
breakLoop = false;

% Get initiation RT
% -----------------
% initationRT is nan before first button press. When button is
% pressed for the first time, store time. Thereafter variable is
% not nan anymore and not saved again.

% Todo: This can potentially become a separate function -- check when
% getting back to unit tests

% For unit test: simulate keyIsDown, keyCode, and record RT
if ~taskParam.unitTest
    [keyIsDown, ~, keyCode] = KbCheck;
else
    WaitSecs(0.5);  % simulate RT = 0.5
    keyIsDown = 1;
    keyCode = zeros(1, 256);
    keyCode(taskParam.keys.space) = 1;
end

if keyIsDown && isnan(taskData.initiationRTs(trial))

    if keyCode(taskParam.keys.rightKey) || keyCode(taskParam.keys.leftKey) || keyCode(taskParam.keys.rightSlowKey) || keyCode(taskParam.keys.leftSlowKey) || keyCode(taskParam.keys.space)
       
        % todo: add explanation
        RT_Timestamp = GetSecs();
        taskData.initiationRTs(trial) = RT_Timestamp - initRT_Timestamp;
    end

    % When space is pressed and orange dot has not been moved (perseveration),
    % record prediction, RT, prediction timestamp, and indicate that the
    % keyboard loop should be terminated
    if keyCode(taskParam.keys.space)

        if taskParam.unitTest
            taskParam.circle.rotAngle = deg2rad(taskData.pred(trial));
        end
        
        % Record prediction (todo: can in principle done with rad2deg)
        taskData.pred(trial) = (taskParam.circle.rotAngle / taskParam.circle.unit);

        % RT is equal to initiation RT in this case
        taskData.RT(trial) = taskData.initiationRTs(trial); 
        
        % Record prediction timestamp
        taskData.timestampPrediction(trial) = RT_Timestamp - taskParam.timingParam.ref;
       
        % Indicate that loop should be terminated
        breakLoop = true;
    end
end

% 10.06.22. Separated both conditions for initRT and prediction control
% to make sure that both would be completed even if button press was
% extremely fast (which practically does not happen bc button press is
% longer than one cyle in while loop).
% Todo: Check in this in mouse version too

% When other keys are pressed before space, update orange spot until space 
% is pressed

if keyIsDown && ~breakLoop

    % Fast right movement
    if keyCode(taskParam.keys.rightKey)
        if taskParam.circle.rotAngle < 360*taskParam.circle.unit
            taskParam.circle.rotAngle = taskParam.circle.rotAngle + taskParam.keys.keySpeed*taskParam.circle.unit;
        else
            taskParam.circle.rotAngle = 0;
        end

    % Slow right movement
    elseif keyCode(taskParam.keys.rightSlowKey)

        if taskParam.circle.rotAngle < 360*taskParam.circle.unit
            taskParam.circle.rotAngle = taskParam.circle.rotAngle + taskParam.keys.slowKeySpeed*taskParam.circle.unit;
        else
            taskParam.circle.rotAngle = 0;
        end

    % Fast left movement
    elseif keyCode(taskParam.keys.leftKey)

        if taskParam.circle.rotAngle > 0*taskParam.circle.unit
            taskParam.circle.rotAngle = taskParam.circle.rotAngle - taskParam.keys.keySpeed*taskParam.circle.unit;
        else
            taskParam.circle.rotAngle = 360*taskParam.circle.unit;
        end

    % Slow left movement
    elseif keyCode(taskParam.keys.leftSlowKey)

        if taskParam.circle.rotAngle > 0*taskParam.circle.unit
            taskParam.circle.rotAngle = taskParam.circle.rotAngle - taskParam.keys.slowKeySpeed*taskParam.circle.unit;
        else
            taskParam.circle.rotAngle = 360*taskParam.circle.unit;
        end

    % Commit to prediction and terminate response loop
    elseif keyCode(breakKey)
        
        % Record prediction (todo: can in principle done with rad2deg)
        taskData.pred(trial) = (taskParam.circle.rotAngle / taskParam.circle.unit);
        
        % Add comment
        RT_Timestamp = GetSecs;
        taskData.timestampPrediction(trial) = RT_Timestamp - taskParam.timingParam.ref;
        taskData.RT(trial) = RT_Timestamp - initRT_Timestamp;
        breakLoop = true;
    end

end
end
