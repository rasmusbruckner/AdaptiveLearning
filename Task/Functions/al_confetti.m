function [taskData, xyExp, dotSize] = al_confetti(taskParam, taskData, currTrial, background, timestamp, fadeOutEffect)
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
%       taskData: Task-data-object instance
%       xyExp: Confetti-position matrix
%       dotSize: Confetti-size matrix


if ~exist('fadeOutEffect', 'var') ||  isempty(fadeOutEffect)
    fadeOutEffect = true;  
end

nFrames = taskParam.cannon.nFrames;
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
spreadWide = normrnd(taskData.outcome(currTrial), taskParam.cannon.confettiAnimationStd, nParticles, 1); 

% Random confetti flight distance (radius) conditional on circle radius and some arbitrary standard deviation
spreadLong = taskParam.circle.rotationRad + normrnd(taskParam.cannon.confettiEndMean, taskParam.cannon.confettiEndStd, nParticles,1);

% End points of animation, both spread and distance combined
xExpEnd = spreadLong .* sind(spreadWide);
yExpEnd = spreadLong .* -cosd(spreadWide);

% When is it a catch?
% -------------------

% Determine threshold at which confetti stops moving when in shield
threshold = taskParam.circle.rotationRad + normrnd(-0.75*taskParam.circle.shieldOffset, taskParam.circle.shieldWidth/10, nParticles, 1);  % ensure that we only cover some part of the shield width
xThres = threshold .* sind(spreadWide);
yThres = threshold .* -cosd(spreadWide);
xyThres = [xThres yThres]';

% Compute distance between confetti and prediction to determine when it is a catch
dotPredDist = al_diff(spreadWide, taskData.pred(currTrial))'; 

% Determine which particles will be caught
[whichParticlesCaught, taskData.nParticlesCaught(currTrial)] = taskData.getParticlesCaught(dotPredDist, taskData.allShieldSize(currTrial));

% Dot color, size, and confetti cloud
dotCol = taskData.dotCol(currTrial).rgb;
dotSize = al_confettiSize(nParticles); %(1+rand(1, nParticles))*3;
 
% For asymmetric reward version, compute number of red and green particles
% caught in shield
if strcmp(taskParam.trialflow.reward, 'asymmetric')

    % Determine particle color
    greenParticles = unique(dotCol == taskParam.colors.green','rows');
    redParticles = unique(dotCol == taskParam.colors.red','rows');
    
    % Determine which of those were caught
    taskData.greenCaught(currTrial) = sum(whichParticlesCaught(greenParticles));
    taskData.redCaught(currTrial) = sum(whichParticlesCaught(redParticles));

else

    % For other versions, set to nan
    taskData.greenCaught(currTrial) = nan;
    taskData.redCaught(currTrial) = nan;
    
end

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
xExpSteps = xExpSteps .* repmat(weight', [1, size(xExpSteps, 2)]); 
yExpSteps = yExpSteps .* repmat(weight', [1, size(xExpSteps, 2)]);
% The above is included for backward compatibility. In future, when all
% labs have more recent Matlab versions, potentially change to: 
% xExpSteps = xExpSteps .* weight'; 
% yExpSteps = yExpSteps .* weight';

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
        al_drawCannon(taskParam, taskData.distMean(currTrial))
    else
        % If cannon is hidden, show confetti cloud
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawFixPoint(taskParam)
    end

    % Show orange prediction spot
    % al_predictionSpot(taskParam)
   
    % Show shield
    al_shield(taskParam, taskData.allShieldSize(currTrial), taskData.pred(currTrial), taskData.shieldType(currTrial));

    % Draw updated dots to animate explosion
    Screen('DrawDots', taskParam.display.window.onScreen, round(xyExp), dotSize, dotCol, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    
    % Checking for threshold
    % Uncomment to threshold of dots when caught
    if taskParam.gParam.showConfettiThreshold
        Screen('DrawDots', taskParam.display.window.onScreen, round(xyThres), 5, [0 0 0], [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        Screen('DrawDots', taskParam.display.window.onScreen, round(xyThresCatch), 5, [255 255 255], [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    end
    
    % Compute which dots should stick to the shield when caught
    stopCrit = abs(round(xyExp)) > abs(round(xyThres)) & repmat(abs(dotPredDist) <= taskData.allShieldSize(currTrial)/2, [2, 1]);
    % The above is included for backward compatibility. In future, when all
    % labs have more recent Matlab versions, potentially change to: 
    % stopCrit = abs(round(xyExp)) > abs(round(xyThres)) & abs(dotPredDist) <= taskData.allShieldSize(currTrial)/2;

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
    
    % Check for escape key 
    taskParam.keys.checkQuitTask(taskParam, taskData);
end
end
