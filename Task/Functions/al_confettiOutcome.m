function taskParam = al_confettiOutcome(taskParam, taskData, currTrial, regenerateParticles)
%AL_CONFETTIOUTCOME This function displays the confetti for the EEG and pupil version
% of the conefetti-cannon task
%
%   In this case, the confetti doesn't fly and the particle distribution
%   is more narrow.
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       currTrial: Index of current trial
%       regenerateParticles: Optional input controlling if new particles
%       should be generated
%
%   Output
%       taskParam: Optional task-parameter-object instance


% Check if optional input is provided
if ~exist('regenerateParticles', 'var') || isempty(regenerateParticles)
    regenerateParticles = true;
end


% Check if particles should be regenerated or not
% Shouldn't be regenerated when outcome is shown twice within a trial
if regenerateParticles || any(any(isnan(taskParam.cannon.xyExp))) || any(any(isnan(taskParam.cannon.dotCol))) || any(any(isnan(taskParam.cannon.dotSize)))

    % Number of particles
    nParticles = taskData.nParticles(currTrial);

    % Random angle for each particle (degrees) conditional on outcome and confetti standard deviation
    spreadWide = repmat(taskData.outcome(currTrial), nParticles, 1);

    % Random confetti flight distance (radius) conditional on circle radius and some arbitrary standard deviation
    longCentering = taskParam.circle.circleWidth/2;
    spreadLong = repmat(taskParam.circle.rotationRad-longCentering, nParticles, 1);

    % Confetti position, both spread and distance combined
    taskParam.cannon.xyExp = nan(2, nParticles);
    taskParam.cannon.xyExp(1,:) = spreadLong .* sind(spreadWide) + normrnd(0, taskParam.cannon.confettiStd, nParticles, 1);
    taskParam.cannon.xyExp(2,:) = spreadLong .* -cosd(spreadWide) + normrnd(0, taskParam.cannon.confettiStd, nParticles, 1);

    % Color and size
    if taskParam.cannon.defaultParticles == false
        taskParam.cannon.dotCol = taskData.dotCol(currTrial).rgb;
    end
    taskParam.cannon.dotSize = 1+(rand(1, nParticles))*taskParam.cannon.particleSize; % note: particle size is at least one pixel
    % the rest can be defined in terms of degrees visual angle
end

% Display confetti outcome
Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyExp, taskParam.cannon.dotSize, taskParam.cannon.dotCol, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);

end


