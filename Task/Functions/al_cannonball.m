function al_cannonball(taskParam, taskData, lineAndBack, trial, timestamp)
%AL_CANNONBALL This function animates the cannonball shot
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       lineAndBack: Indicates if frame should be shown
%       trial: Current trial number
%       timestamp: Timestamp start of trial for timing
%
%   Output
%        ~


% Number of times that cannonball is printed while flying from cannon to aim
nFrames = 30;

% Outcome coordinates
xOut = ((taskParam.circle.rotationRad-5) * sind(taskData.outcome(trial)));
yOut = ((taskParam.circle.rotationRad-5) * (-cosd(taskData.outcome(trial))));
outcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xOut, yOut);

% Target (mean) coordinates
xTarget = ((taskParam.circle.rotationRad-5) * sind(taskData.distMean(trial)));
yTarget = ((taskParam.circle.rotationRad-5) * -cosd(taskData.distMean(trial)));

% Cannon inside
if isequal(taskParam.trialflow.cannonPosition, 'inside')

    targetSpotEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xTarget, yTarget);
    targetSpotStart = taskParam.circle.outcCentSpotRect;

    % Cannon outside
else

    xCannon = (300 * sind(taskData.distMean(trial)));
    yCannon = (300 * -cosd(taskData.distMean(trial)));
    targetSpotEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xTarget, yTarget);
    targetSpotStart = OffsetRect(taskParam.circle.outcCentSpotRect, xCannon, yCannon);

end

% Total cannon ball distance 
targetDist = targetSpotEnd - targetSpotStart;

% Position at which cannonball starts to fly
if isequal(taskParam.trialflow.cannonball_start, 'center')
    ballStart = targetSpotStart;
elseif isequal(taskParam.trialflow.cannonball_start, 'cannon')
    ballStart = targetSpotStart + targetDist / 4;
end

% Difference between start and end point
outcSpotDiff = outcSpot - ballStart;

% Stepsize
step = outcSpotDiff / nFrames;

% Actual cannonball position
outcSpotAct = ballStart;

% Constantly updated timestamp for stimulus presentation
tUpdate = GetSecs - timestamp;

% Cycle over number of frames to run the animation
for i = 1:nFrames

    % Optionally present background image
    if isequal(taskParam.trialflow.background, "picture")
        Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.backgroundTxt, [], [taskParam.display.backgroundCoords], []);
    end
    % Print background, if desired
    if lineAndBack
        al_lineAndBack(taskParam)
    end

    % Update outcome spot
    outcSpotAct = outcSpotAct + step;

    % Draw circle, cannon, prediction spot
    al_drawCircle(taskParam)
    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(trial)
        al_drawCannon(taskParam, taskData.distMean(trial))
    else
        al_drawCross(taskParam)
    end

    if isequal(taskParam.trialflow.shot, 'animate cannonball') && isequal(taskParam.trialflow.shotAndShield, 'simultaneously')
        al_shield(taskParam, taskData.allASS(trial), taskData.pred(trial), taskData.shieldType(trial))
    else
        al_predictionSpot(taskParam)
    end

    % Show outcome
    Screen('FillOval', taskParam.display.window.onScreen, [0 0 0], outcSpotAct);

    % Flip screen and present changes
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    tUpdate = tUpdate + taskParam.timingParam.cannonBallAnimation / nFrames;
    Screen('Flip', taskParam.display.window.onScreen, timestamp + tUpdate);

end
end