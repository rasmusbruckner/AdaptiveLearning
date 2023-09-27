function al_confettiOutcome(taskParam, taskData, currTrial)
%AL_CONFETTIOUTCOME This function displays the confetti for the EEG version
% of the conefetti-cannon task. 
%
%   In this case, the confetti doesn't fly and the particle distribution
%   is more narrow.
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       currTrial: Index of current trial
%
%   Output
%       ~



% Outcome coordinates
xPredS_mult = ((taskParam.circle.rotationRad-5) * sin(taskData.outcome(currTrial)*taskParam.circle.unit));
yPredS_mult = ((taskParam.circle.rotationRad-5) * (-cos(taskData.outcome(currTrial)*taskParam.circle.unit)));
OutcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS_mult, yPredS_mult);

% Number of particles
nParticles = taskData.nParticles(currTrial);

% Random angle for each particle (degrees) conditional on outcome and confetti standard deviation
spreadWide = repmat(taskData.outcome(currTrial), nParticles, 1);

% Random confetti flight distance (radius) conditional on circle radius and some arbitrary standard deviation
spreadLong = repmat(taskParam.circle.rotationRad-5, nParticles, 1);

% End points of animation, both spread and distance combined
xyExp = nan(2, nParticles);
xyExp(1,:) = spreadLong .* sind(spreadWide) + normrnd(0, 5, nParticles, 1);
xyExp(2,:) = spreadLong .* -cosd(spreadWide) + normrnd(0, 5, nParticles, 1);
dotCol = taskData.dotCol(currTrial).rgb;
dotSize = (1+rand(1, nParticles))*3;

% Display outcome
Screen('DrawDots', taskParam.display.window.onScreen,xyExp, dotSize, dotCol, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
Screen('FillOval', taskParam.display.window.onScreen, [0 0 0], OutcSpot);

end


