function [nParticlesCaught, xyExp] = al_supplies(taskParam, taskData, currTrial, background, timestamp)
%AL_SUPPLIES This function animates the supplies dropped by the helicopter
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       currTrial: Current trial number
%       background: Indicates if background for instructions should be printed
%       timestamp: Timestamp of current trial
%
%   Output
%       nParticlesCaught: Number of supply items caught
%       xyExp: Position matrix


nFrames = 80;
nParticles = 5;

% Determine random flying trajectories
% --------------------------------------

% Start coordinates
xExpStart = 0; 
yExpStart = 0;

% Initialize supply-item matrix that animates explosion
xyExp = zeros(2, nParticles);
xyExp(1,:) = xExpStart; 
xyExp(2,:) = yExpStart; 

% Random angle for each item (degrees) conditional on outcome and item standard deviation
spread_wide = normrnd(taskData.outcome(currTrial), taskParam.cannon.confettiStd, nParticles, 1); 

% Random item flight distance (radius) conditional on circle radius and some arbitrary standard deviation
spread_long = taskParam.circle.rotationRad + normrnd(taskParam.circle.rotationRad, 20, nParticles,1);

% End points of animation, both spread and distance combined
xExpEnd = spread_long .* sind(spread_wide);
yExpEnd = spread_long .* -cosd(spread_wide);

% When is it a catch?
% -------------------

% Determine threshold at which supply items stop moving when in shield
threshold = taskParam.circle.rotationRad + normrnd(-0.75*taskParam.circle.shieldOffset, taskParam.circle.shieldWidth/10, nParticles, 1);  % ensure that we only cover some part of the shield width
xThres = threshold .* sind(spread_wide);
yThres = threshold .* -cosd(spread_wide);
xyThres = [xThres yThres]';

% Compute distance between drugs and prediction to determine when it is a catch
dotPredDist = al_diff(spread_wide, taskData.pred(currTrial))'; 

% Determine which items will be caught using confetti function
[whichParticlesCaught, nParticlesCaught] = taskData.getParticlesCaught(dotPredDist, taskData.allShieldSize(currTrial));

% Store caught supplies is separate matrix for illustration below
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

% XX
tUpdate = GetSecs - timestamp;

% Cycle over number of frames to run the animation
for i = 1:nFrames
 
    % Print background, if desired
    if background == true
        al_lineAndBack(taskParam)
    end

    % Display task elements
    al_drawCircle(taskParam)
    al_predictionSpot(taskParam)
    al_shield(taskParam, taskData.allShieldSize(currTrial), taskData.pred(currTrial), taskData.shieldType(currTrial))
    al_showDoctor(taskParam, taskData.pred(currTrial))

    % Display drugs etc.
    cannonPosition = OffsetRect(taskParam.display.pillImageRect, xyExp(1,1), xyExp(2,1));
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.pill1Txt,[], cannonPosition, 0);
    cannonPosition = OffsetRect(taskParam.display.pillImageRect, xyExp(1,2), xyExp(2,2));
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.pill2Txt,[], cannonPosition, 0);
    cannonPosition = OffsetRect(taskParam.display.pillImageRect, xyExp(1,3), xyExp(2,3));
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.pill3Txt,[], cannonPosition, 0);
    cannonPosition = OffsetRect(taskParam.display.pillImageRect, xyExp(1,4), xyExp(2,4));
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.pill4Txt,[], cannonPosition, 0);
    cannonPosition = OffsetRect(taskParam.display.syringeImageRect, xyExp(1,5), xyExp(2,5));
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.syringeTxt,[], cannonPosition, 0);

    % Optionally, show helicopter
    if ~strcmp(taskParam.trialflow.cannon, 'hide cannon') || taskData.catchTrial(currTrial)
        al_showHelicopter(taskParam, taskData.distMean(currTrial))
    else
        al_drawCross(taskParam)
    end

    % Optionally, show threshold of dots when caught
    if taskParam.gParam.showConfettiThreshold
        Screen('DrawDots', taskParam.display.window.onScreen, round(xyThres), 5, [0 0 0], [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        Screen('DrawDots', taskParam.display.window.onScreen, round(xyThresCatch), 5, [255 255 255], [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
    end
    
    % Compute which items should stick to the shield when caught
    stopCrit = abs(round(xyExp)) > abs(round(xyThres)) & abs(dotPredDist) <= taskData.allShieldSize(currTrial)/2;
    
    % Update item position
    xyExp(1,stopCrit(1,:)==0) = xyExp(1,stopCrit(1,:)==0) + xExpSteps(i,stopCrit(1,:)==0);
    xyExp(2,stopCrit(2,:)==0) = xyExp(2,stopCrit(2,:)==0) + yExpSteps(i,stopCrit(2,:)==0);
    
    % Flip screen and present changes
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    tUpdate = tUpdate + taskParam.timingParam.cannonBallAnimation / nFrames;
    Screen('Flip', taskParam.display.window.onScreen, timestamp + tUpdate);
    
end
end
