function taskData = al_passiveViewingSpot(taskParam, taskData, currTrial, startTimestamp)
%AL_PASSIVEVIEWINGSPOT This function animates the prediction spot for the
%passive viewing condition
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       currTrial: Current trial
%       startTimestamp: Onset of prediction phase for computing RTs
%
%   Output
%       taskData: Task-data-object instance

% Number of frames for animation
nFrames = 30;

% Determine movement trajectory
% -----------------------------

% Start coordinates
xExpStart = 0;
yExpStart = 0;

% Initialize vectors that animate movement
xyExp = zeros(2, 1);
xyExp(1) = xExpStart;
xyExp(2) = yExpStart;

if taskParam.unitTest.run == false
    % Generate random prediction
    randPred = randi([1, 359]);
else
    randPred = taskParam.unitTest.pred(currTrial);
end

% End points of animation
xExpEnd = taskParam.circle.rotationRad .* sind(randPred);
yExpEnd = taskParam.circle.rotationRad .* -cosd(randPred)*-1;

% Determine step size of the animation
% ------------------------------------

% Steps from beginning to end
x_vals = linspace(xExpStart,xExpEnd,nFrames+1);
y_vals = linspace(yExpStart,yExpEnd,nFrames+1);

% Step size
xExpSteps = x_vals(2:end) - x_vals(1:end-1);
yExpSteps = y_vals(2:end) - y_vals(1:end-1);

% Multiply by weight so that step size decays
weight = linspace(2,0,nFrames);
xExpSteps = xExpSteps .* weight;
yExpSteps = yExpSteps .* weight;

% Initiation RT
taskData.initiationRTs(currTrial,:) = GetSecs() - startTimestamp;

% Movement-onset trigger
taskData.triggers(currTrial,2) = al_sendTrigger(taskParam, taskData, 'main', currTrial, 'responseOnset');

% Initialize update timer
tUpdate = GetSecs - startTimestamp;

% Sample simulated RT
if taskParam.unitTest.run == false
    passiveViewingAnimation = normrnd(taskParam.timingParam.passiveViewingAnimationMean, taskParam.timingParam.passiveViewingAnimationSD);
    if passiveViewingAnimation <= 0.2
        passiveViewingAnimation = 0.2;
    end
else
    passiveViewingAnimation = 0.5;
end

% Cycle over number of frames to run the animation
for i = 1:nFrames

    % Draw circle, cannon, prediction spot
    al_drawCircle(taskParam)
    if ~strcmp(taskParam.trialflow.cannon, 'hide cannon') || taskData.catchTrial(currTrial)
        al_drawCannon(taskParam, taskData.distMean(currTrial))
    else
        % If cannon is hidden, show confetti cloud
        Screen('DrawDots', taskParam.display.window.onScreen, taskParam.cannon.xyMatrixRing, taskParam.cannon.sCloud, taskParam.cannon.colvectCloud, [taskParam.display.window.centerX, taskParam.display.window.centerY], 1);
        al_drawFixPoint(taskParam)
    end
   
    % Translate degrees to rotation angle
    taskParam.circle.rotAngle = deg2rad(randPred);

    % Display prediction spot
    al_predictionSpotSticky(taskParam, xyExp(1) ,xyExp(2)*-1)
    
    % Update dot position
    xyExp(1) = xyExp(1) + xExpSteps(i);
    xyExp(2) = xyExp(2) + yExpSteps(i);

    % Optionally, present tick marks
    if isequal(taskParam.trialflow.currentTickmarks, 'show') && currTrial > 1 && (taskData.block(currTrial) == taskData.block(currTrial-1))
        al_tickMark(taskParam, taskData.outcome(currTrial-1), 'outc');
        al_tickMark(taskParam, taskData.pred(currTrial-1), 'pred');
    end

    % Flip screen and present changes
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    tUpdate = tUpdate + passiveViewingAnimation  / nFrames;
    Screen('Flip', taskParam.display.window.onScreen, startTimestamp + tUpdate);

    % Check for escape key
    taskParam.keys.checkQuitTask(taskParam, taskData);
end

% Response trigger
taskData.triggers(currTrial,3) = al_sendTrigger(taskParam, taskData, 'main', currTrial, 'responseLogged');
taskData.RT(currTrial) = GetSecs() - startTimestamp;

% Record prediction
taskData.pred(currTrial) = rad2deg(taskParam.circle.rotAngle);

end