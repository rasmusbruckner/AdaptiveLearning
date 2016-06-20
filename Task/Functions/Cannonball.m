function Cannonball(taskParam, distMean, outcome, background)
% This function animates the cannonball shot.
%   Detailed explanation goes here


% ------------------------
% Barrel Punkt
% ------------------------
nFrames = 50;

% Outcome coordinates.
xOut = ((taskParam.circle.rotationRad-5) * sind(outcome));
yOut = ((taskParam.circle.rotationRad-5) * (-cosd(outcome)));
OutcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xOut, yOut);

% target (mean) coordinates.
xTarget = ((taskParam.circle.rotationRad-5) * sind(distMean));
yTarget = ((taskParam.circle.rotationRad-5) * -cosd(distMean));
TargetSpotEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xTarget, yTarget);
TargetSpotStart = taskParam.circle.outcCentSpotRect;
TargetDist = TargetSpotEnd - TargetSpotStart;

% Position at which cannonball starts to fly.
BallStart = TargetSpotStart + TargetDist/4;

% Difference between start and end point.
OutcSpotDiff = OutcSpot - BallStart;

% Number of steps.
Step = OutcSpotDiff / nFrames;

% Actual cannonballposition.
OutcSpotAct = BallStart;

for i = 1:nFrames
    if background == true
        LineAndBack(taskParam)
    end
    OutcSpotAct = OutcSpotAct + Step;
    DrawCircle(taskParam)
    Cannon(taskParam, distMean)
    PredictionSpot(taskParam)
    Screen('FillOval', taskParam.gParam.window.onScreen, [0 0 0], OutcSpotAct);
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, t + 0.01);
end



