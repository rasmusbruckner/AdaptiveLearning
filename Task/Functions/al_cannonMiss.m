function al_cannonMiss(taskParam, taskData, currTrial, background, timestamp)
%AL_CANNONMISS This function animates the cannonball explosion when it is a miss
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       currTrial: Current trial number
%       background: Indicates if background for instructions should be printed
%       timestamp: Timestamp of current trial
%
%   Output
%        ~


% Number of times that cannonball is printed while flying from cannon to aim
nFrames = 60;
fadeOutp = [zeros(1, round(nFrames/2)) linspace(0, 0.5, round(nFrames/2))];
nDots=41;

% Explosion start coordinates
xExpStart = ((taskParam.circle.rotationRad+0) * sind(taskData.outcome(currTrial)));
yExpStart = ((taskParam.circle.rotationRad+0) * (-cosd(taskData.outcome(currTrial))));

% Initialize dot matrix that animates explosion
xyExp = zeros(2, nDots);
xyExp(1,:) = xExpStart; 
xyExp(2,:) = yExpStart; 

% Determine random end point of animation
spread_wide = normrnd(taskData.outcome(currTrial), 3, nDots, 1);
spread_long = taskParam.circle.rotationRad + normrnd(taskParam.circle.rotationRad, 20, nDots,1);
xExpEnd = spread_long .* sind(spread_wide);
yExpEnd = spread_long .* -cosd(spread_wide);

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

% Initialize timing variable for updates for accurate timing
tUpdate = GetSecs - timestamp;

% Cycle over number of frames to run the animation
for i = 1:nFrames

    % Draw background texture
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.backgroundTxt,[], [taskParam.display.backgroundCoords], []);

    % Print background, if desired
    if background == true
        al_lineAndBack(taskParam)
    end

    % Draw circle, cannon, prediction spot, and shield
    al_drawCircle(taskParam)
    if isequal(taskParam.trialflow.cannon, 'show cannon')  || taskData.catchTrial(currTrial)
        al_drawCannon(taskParam, taskData.distMean(currTrial), 0)
    else
        al_drawCross(taskParam)
    end
    al_shield(taskParam, taskData.allASS(currTrial), taskData.pred(currTrial), taskData.shieldType(currTrial));

    % Show animation when it is a miss
    if taskData.hit(currTrial) == 0
                   
        % Draw updated dots to animate explosion
        Screen('DrawDots', taskParam.display.window.onScreen, round(xyExp), 3.5, taskParam.colors.black, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);

        % Update dot position
        xyExp(1,:) = xyExp(1,:) + xExpSteps(i,:);
        xyExp(2,:) = xyExp(2,:) + yExpSteps(i,:);
        
        % Sample which dots disappear...
        fadeOut = binornd(1, fadeOutp(i), 1, nDots);
   
        % ...and delete them
        xyExp(1, fadeOut==1) = nan;
        xyExp(2, fadeOut==1) = nan;

    end

    % Constantly display outcome
    al_drawOutcome(taskParam, taskData.outcome(currTrial))

    % Flip screen and present changes
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    tUpdate = tUpdate + taskParam.timingParam.cannonMissAnimation / nFrames;
    Screen('Flip', taskParam.display.window.onScreen, timestamp + tUpdate);
    
end
end




