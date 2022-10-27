function [xyExp, dotCol, dotSize] = al_confetti(taskParam, taskData, currTrial, background, timestamp, fadeOutEffect)
%AL_CONFETTI This function animates the confetti shot
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       currTrial: Current trial number
%       background: Indicates if background for instructions should be printed
%       timestamp: Timestamp of current trial
%       fadeOutEffect: Indicates if confetti should disappear towards the end
%                      of the trial
%
%   Output
%       exExp: Confetti-dots position

if ~exist('fadeOutEffect', 'var') ||  isempty(fadeOutEffect)
    fadeOutEffect = true;  
end

nFrames = 80; % 150;
fadeOutp = [zeros(1, round(nFrames/2)) linspace(0, 0.5, round(nFrames/2))];
nDots = 41;

% Explosion start coordinates
xExpStart = 0; 
yExpStart = 0;

% Initialize dot matrix that animates explosion
xyExp = zeros(2, nDots);
xyExp(1,:) = xExpStart; 
xyExp(2,:) = yExpStart; 

% Determine random end point of animation
spread_wide = normrnd(taskData.outcome(currTrial), 3, nDots, 1);
spread_long = taskParam.circle.rotationRad + normrnd(taskParam.circle.rotationRad, 20, nDots,1);
xExpEnd = spread_long .* sind(spread_wide);
yExpEnd = spread_long .* -cosd(spread_wide);

% When is it a catch?
threshold = taskParam.circle.rotationRad + normrnd(-7, 3, nDots,1);
xThres = threshold .* sind(spread_wide);
yThres = threshold .* -cosd(spread_wide);
xyThres = zeros(2, nDots);
xyThres(1,:) = xThres;
xyThres(2,:) = yThres;
dotPredDist = al_diff(spread_wide, taskData.pred(currTrial))';  

% Determine step size of the animation
% ------------------------------------

% Steps from beginning to end
x_vals = zeros(nFrames+1, nDots);
y_vals = zeros(nFrames+1, nDots);
for k = 1:nDots
  x_vals(:,k) = linspace(xExpStart,xExpEnd(k),nFrames+1);
  y_vals(:,k) = linspace(yExpStart,yExpEnd(k),nFrames+1);
end
xExpSteps = x_vals(2:end,:) - x_vals(1:end-1,:);
yExpSteps = y_vals(2:end,:) - y_vals(1:end-1,:);

% Multiply by weight so that step size decays
weight = linspace(2,0,nFrames);
xExpSteps = xExpSteps .* weight'; 
yExpSteps = yExpSteps .* weight';

% Dot color, size, and confetti cloud
dotCol = uint8(round(rand(3, nDots)*255));
dotSize = (1+rand(1, nDots))*3;
[xymatrix_ring, s_ring, colvect_ring] = al_staticConfettiCloud();

tUpdate = GetSecs - timestamp;

% Cycle over number of frames to run the animation
for i = 1:nFrames
 
    % Print background, if desired
    if background == true
        al_lineAndBack(taskParam)
    end
        
    % Draw circle, cannon, prediction spot
    al_drawCircle(taskParam)
    if ~strcmp(taskParam.trialflow.cannon, 'hide cannon') || taskData.catchTrial(currTrial)
        al_drawCannon(taskParam, taskData.distMean(currTrial), 0)
    else
        % If cannon is hidden, show confetti cloud
        Screen('DrawDots', taskParam.display.window.onScreen, xymatrix_ring, s_ring, colvect_ring, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1); 
        al_drawCross(taskParam)
    end

    % Show orange prediction spot
    al_predictionSpot(taskParam)
   
    % Show shield
    al_shield(taskParam, taskData.allASS(currTrial), taskData.pred(currTrial), taskData.shieldType(currTrial));

    % Draw updated dots to animate explosion
    Screen('DrawDots', taskParam.display.window.onScreen, round(xyExp), dotSize, dotCol, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    
    % Uncomment to see threshold of dots when caught
    % Screen('DrawDots', taskParam.display.window.onScreen, round(xyThres), 5, [0 0 0], [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);

    % Compute which dots should stick to the shield when caught
    stopCrit = abs(round(xyExp)) > abs(round(xyThres)) & abs(dotPredDist) <= taskData.allASS(currTrial)/2;
    
    % Update dot position
    xyExp(1,stopCrit(1,:)==0) = xyExp(1,stopCrit(1,:)==0) + xExpSteps(i,stopCrit(1,:)==0);
    xyExp(2,stopCrit(2,:)==0) = xyExp(2,stopCrit(2,:)==0) + yExpSteps(i,stopCrit(2,:)==0);
    
    if fadeOutEffect
        
        % Sample which dots disappear...
        fadeOut = binornd(1, fadeOutp(i), 1, nDots);
   
        % ...and delete them
        xyExp(1, fadeOut==1) = nan;
        xyExp(2, fadeOut==1) = nan;
        
    end    

    % Flip screen and present changes
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    tUpdate = tUpdate + taskParam.timingParam.cannonBallAnimation / nFrames;
    Screen('Flip', taskParam.display.window.onScreen, timestamp + tUpdate);
    
end
end
