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
nFrames = 30; %50;

% Outcome coordinates
xOut = ((taskParam.circle.rotationRad-5) * sind(taskData.outcome(trial)));
yOut = ((taskParam.circle.rotationRad-5) * (-cosd(taskData.outcome(trial))));
OutcSpot = OffsetRect(taskParam.circle.outcCentSpotRect, xOut, yOut);

% Target (mean) coordinates
xTarget = ((taskParam.circle.rotationRad-5) * sind(taskData.distMean(trial)));
yTarget = ((taskParam.circle.rotationRad-5) * -cosd(taskData.distMean(trial)));

if ~isequal(taskParam.gParam.taskType, 'chinese')
    % In all conditions, except "chinese" needle goes from the center of the screen to the circle
    TargetSpotEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xTarget, yTarget);
    TargetSpotStart = taskParam.circle.outcCentSpotRect;
else 
    % In "chinese" condition, cannon and needle start outside of the circle
    xCannon = (300 * sind(taskData.distMean(trial)));
    yCannon = (300 * -cosd(taskData.distMean(trial)));
    TargetSpotEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xTarget, yTarget);
    TargetSpotStart = OffsetRect(taskParam.circle.outcCentSpotRect, xCannon, yCannon);
end
TargetDist = TargetSpotEnd - TargetSpotStart;

% Position at which cannonball starts to fly
if isequal(taskParam.trialflow.cannonball_start, 'center')
     BallStart = TargetSpotStart;
elseif isequal(taskParam.trialflow.cannonball_start, 'cannon')
    BallStart = TargetSpotStart + TargetDist / 4;
end

% Difference between start and end point
OutcSpotDiff = OutcSpot - BallStart;

% Stepsize
Step = OutcSpotDiff / nFrames;

% Actual cannonball position
OutcSpotAct = BallStart;

% tstart = GetSecs;
% tZero = GetSecs;
tUpdate = GetSecs - timestamp;

% Cycle over number of frames to run the animation
for i = 1:nFrames
    
    % Todo: only for sleep condition. Add if condition for other versions
    Screen('DrawTexture', taskParam.display.window.onScreen, taskParam.display.backgroundTxt, [], [taskParam.display.backgroundCoords], []);  %[],[]
    
    % Print background, if desired
    if lineAndBack
        al_lineAndBack(taskParam)
    end
    
    % Print planet color in chinese version
    OutcSpotAct = OutcSpotAct + Step;
    
    % Draw circle, cannon, prediction spot
    al_drawCircle(taskParam)
    if isequal(taskParam.trialflow.cannon, 'show cannon') || taskData.catchTrial(trial)
        % Todo: when working on chinese, use trialFlow for latent
        % state -- for sleepVersion currently not used
        % al_drawCannon(taskParam, taskData.distMean(currentTrial), latentState)
        al_drawCannon(taskParam, taskData.distMean(trial))
    else
       al_drawCross(taskParam)
    end
    
    if isequal(taskParam.trialflow.shot, 'animate cannonball')
        al_shield(taskParam, taskData.allASS(trial), taskData.pred(trial), taskData.shieldType(trial))
    else
        al_predictionSpot(taskParam)
    end
    
    % todo: check if this has to be re-activeted for other versions
    % al_predictionSpot(taskParam)
    if isequal(taskParam.gParam.taskType, 'chinese')
        Screen('FillOval', taskParam.gParam.window.onScreen, [165 42 42],...
            OutcSpotAct);
    else
         Screen('FillOval', taskParam.display.window.onScreen, [0 0 0],...
            OutcSpotAct);
    end
    
    % Flip screen and present changes
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    tUpdatePrev = GetSecs;
    tUpdate = tUpdate + taskParam.timingParam.cannonBallAnimation / nFrames;
    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', taskParam.display.window.onScreen, timestamp + tUpdate);
    
end
end



