function taskParam = al_takeBreak(taskParam, taskData, currTrial)
%AL_TAKEBREAK This function manages the breaks in the cannon task
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       trial: Current trial
%
%   Output
%       taskParam: Task-parameter-object instance


if currTrial > 1 && ~(taskData.block(currTrial) == taskData.block(currTrial-1))

    % Present text indicating the break
    txt = sprintf('Kurze Pause!\n\nSie haben bereits %i von insgesamt %i Durchgänge geschafft.', currTrial, taskParam.gParam.trials);

    header = ' ';
    feedback = true;
    al_bigScreen(taskParam, header, txt, feedback);

    % Wait until keys released
    KbReleaseWait();

    % Set prediction spot to default after break
    taskParam.circle.rotAngle =  taskParam.circle.initialRotAngle;
end
end