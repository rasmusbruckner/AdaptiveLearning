function [nParticlesCaught, xyExp, dotCol, dotSize] = al_confetti(taskParam, taskData, currTrial, background, timestamp, fadeOutEffect)
%AL_CONFETTI This function animates the confetti shot
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       currTrial: Current trial number
%       background: Indicates if background for instructions should be printed
%       timestamp: Timestamp of current trial
%       fadeOutEffect: Indicates if confetti should disappear towards the end of the trial
%
%   Output
%       nParticlesCaught: Number of particles caught
%       xyExp: Confetti-position matrix
%       dotCol: Confetti-color matrix
%       dotSize: Confetti-size matrix

if ~exist('fadeOutEffect', 'var') ||  isempty(fadeOutEffect)
    fadeOutEffect = true;  
end

nFrames = 80;
fadeOutp = [zeros(1, round(nFrames/2)) linspace(0, 0.5, round(nFrames/2))];
nParticles = taskData.nParticles(currTrial);

% Determine random confetti trajectories
% --------------------------------------

% Start coordinates
xExpStart = 0; 
yExpStart = 0;

% Initialize confetti matrix that animates explosion
xyExp = zeros(2, nParticles);
xyExp(1,:) = xExpStart; 
xyExp(2,:) = yExpStart; 

% Random angle for each particle (degrees) conditional on outcome and confetti standard deviation
spread_wide = normrnd(taskData.outcome(currTrial), taskParam.cannon.confettiStd, nParticles, 1); 

% Random confetti flight distance (radius) conditional on circle radius and some arbitrary standard deviation
spread_long = taskParam.circle.rotationRad + normrnd(taskParam.circle.rotationRad, 20, nParticles,1);

% End points of animation, both spread and distance combined
xExpEnd = spread_long .* sind(spread_wide);
yExpEnd = spread_long .* -cosd(spread_wide);

% When is it a catch?
% -------------------

% Determine threshold at which confetti stops moving when in shield
threshold = taskParam.circle.rotationRad + normrnd(-0.75*taskParam.circle.shieldOffset, taskParam.circle.shieldWidth/10, nParticles, 1);  % ensure that we only cover some part of the shield width
xThres = threshold .* sind(spread_wide);
yThres = threshold .* -cosd(spread_wide);
xyThres = [xThres yThres]';

% Compute distance between confetti and prediction to determine when it is a catch
dotPredDist = al_diff(spread_wide, taskData.pred(currTrial))'; 

% Determine which particles will be caught
[whichParticlesCaught, nParticlesCaught] = al_getParticlesCaught(dotPredDist, taskData.allASS(currTrial));

% Store caught particles is separate matrix for illustration below
xyThresCatch = xyThres;
xyThresCatch(:, whichParticlesCaught==0) = nan;


% Determine step size of the animation
% ------------------------------------

% Steps from beginning to end
x_vals = zeros(nFrames+1, nParticles);
y_vals = zeros(nFrames+1, nParticles);
for k = 1:nParticles
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
dotCol = uint8(round(rand(3, nParticles)*255));
dotSize = (1+rand(1, nParticles))*3;
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
    if taskParam.gParam.showConfettiThreshold
        Screen('DrawDots', taskParam.display.window.onScreen, round(xyThres), 5, [0 0 0], [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        Screen('DrawDots', taskParam.display.window.onScreen, round(xyThresCatch), 5, [255 255 255], [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    end
    
    % Compute which dots should stick to the shield when caught
    stopCrit = abs(round(xyExp)) > abs(round(xyThres)) & abs(dotPredDist) <= taskData.allASS(currTrial)/2;
    
    % Update dot position
    xyExp(1,stopCrit(1,:)==0) = xyExp(1,stopCrit(1,:)==0) + xExpSteps(i,stopCrit(1,:)==0);
    xyExp(2,stopCrit(2,:)==0) = xyExp(2,stopCrit(2,:)==0) + yExpSteps(i,stopCrit(2,:)==0);
    
    if fadeOutEffect
        
        % Sample which dots disappear...
        fadeOut = binornd(1, fadeOutp(i), 1, nParticles);
   
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
