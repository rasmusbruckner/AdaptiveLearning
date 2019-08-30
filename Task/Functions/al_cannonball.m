function al_cannonball(taskParam, distMean, outcome, background, currentContext, latentState)
%AL_CANNONBALL   This function animates the cannonball shot
%
%   Input
%       taskParam: structure containing task parameters
%       distMean: current mean of distribution
%       outcome: current outcome
%       background: indicates if background should be printed
%       currentContext: current planet
%       latentState: current enemy
%
%   Output
%        ~


% Number of times that cannonball is printed while flying from cannon to aim
nFrames = 50;

% Outcome coordinates
xOut = ((taskParam.circle.rotationRad-5) * sind(outcome));
yOut = ((taskParam.circle.rotationRad-5) * (-cosd(outcome)));
OutcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xOut, yOut);

% Target (mean) coordinates
xTarget = ((taskParam.circle.rotationRad-5) * sind(distMean));
yTarget = ((taskParam.circle.rotationRad-5) * -cosd(distMean));

if ~isequal(taskParam.gParam.taskType, 'chinese')
    % In all conditions, except "chinese" needle goes from the center of the screen to the circle
    TargetSpotEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xTarget, yTarget);
    TargetSpotStart = taskParam.circle.outcCentSpotRect;
else 
    % In "chinese" condition, cannon and needle start outside of the circle
    xCannon = (300 * sind(distMean));
    yCannon = (300 * -cosd(distMean));
    TargetSpotEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xTarget, yTarget);
    TargetSpotStart = OffsetRect(taskParam.circle.outcCentSpotRect, xCannon, yCannon);
end
TargetDist = TargetSpotEnd - TargetSpotStart;

% Position at which cannonball starts to fly
BallStart = TargetSpotStart + TargetDist/4;

% Difference between start and end point
OutcSpotDiff = OutcSpot - BallStart;

% Stepsize
Step = OutcSpotDiff / nFrames;

% Actual cannonball position
OutcSpotAct = BallStart;

% Cycle over number of frames to run the animation
for i = 1:nFrames
    
    % Print background, if desired
    if background == true
        al_lineAndBack(taskParam)
    end
    
    % Print plante color in chinese version
    OutcSpotAct = OutcSpotAct + Step;
    if isequal(taskParam.gParam.taskType, 'chinese')
            al_drawContext(taskParam, currentContext)
            al_drawCross(taskParam)
    end
    
    % Draw circle, cannon, prediction spot
    al_drawCircle(taskParam)
    al_drawCannon(taskParam, distMean, latentState)
    al_predictionSpot(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        Screen('FillOval', taskParam.gParam.window.onScreen, [165 42 42],...
            OutcSpotAct);
    else
         Screen('FillOval', taskParam.gParam.window.onScreen, [0 0 0],...
            OutcSpotAct);
    end
    
    % Flip screen and present changes
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.01);
    
end



