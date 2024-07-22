function [samplesInAOI, duckSpot] = al_infantAOI(taskParam, duckPosition, AOIRad, gazeX, gazeY, samplesInAOI)
%AL_INFANTAOI This function defines a dynamic area of interest (AOI) for
% the infant task
%
%   The AOI is gaze contingent and contingent on the duck position
%
%   Input
%       taskParam: Task-parameter-object instance
%       duckPosition: Center of duck position (outcomde)
%       AOIRad: Area of interest radius
%       gazeX: Current gaze sampe x-position
%       gazeY: Current gaze sampe y-position
%       samplesInAOI: Samples in AOI
%
%   Output
%       samplesInAOI: Samples in AOI
%       duckSpot: Center of AOI

% Compute duck center on circle
xDuck = ((taskParam.circle.rotationRad-5) * sin(duckPosition*taskParam.circle.unit));
yDuck = ((taskParam.circle.rotationRad-5) * (-cos(duckPosition*taskParam.circle.unit)));
duckSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xDuck, yDuck);

% Take average to have one pixel
% Todo: potentially define separate duckCentSpotRect
duckSpot = round([(duckSpot(1) + duckSpot(3))/2 (duckSpot(2) + duckSpot(4))/2]);

% Size of PTB screen in which we check gaze positions:
% Note: The meshgrid function used below is defined in terms of height,
% width. Therefore, we use screensizePart(2) first (y=height) and
% screensizePart(1) second (x=width)
imageSize = [taskParam.display.screensizePart(2), taskParam.display.screensizePart(1)];

% Create a grid of pixel coordinates
[xGrid, yGrid] = meshgrid(1:imageSize(2), 1:imageSize(1));

% Compute the distance from each pixel to the circle center
distanceFromCenter = sqrt((xGrid - duckSpot(1)).^2 + (yGrid - duckSpot(2)).^2);

% Compute distance from center for current gaze position
gazeDistanceFromCenter = distanceFromCenter(gazeY, gazeX);

% Check if current samples are in AOI or not
inAOI = gazeDistanceFromCenter <= AOIRad;
samplesInAOI = samplesInAOI + inAOI;

end