function al_drugstudyInstructions(taskParam, subject, cannon, whichPractice)
%SHAREDINSTRUCTIONS   This function runs the general instructions that are the same for each condtion
%
%   Input
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%       cannon: logical that indicates if cannon should be shown during instruction
%       whichPractice: indicates which practice condition should be presented
%
%   Output
%       ~


% Initialize to first screen
screenIndex = 1;

% Adjust text settings
Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');
Screen('TextSize', taskParam.gParam.window.onScreen, 50);

% Display first slide indicating the current task version
al_indicateCondition(taskParam, subject, whichPractice)

% Introduce cannon
distMean = 300;

txt = 'A cannon is aimed at the circle. Indicate where you would like to place your shield to catch cannonballs with the orange spot. You can move the orange spot using the mouse.';

screenIndex = introduceCannon(screenIndex, taskParam, distMean, cannon, whichPractice, txt);

% Introduce shot of the cannon
distMean = 240;
[screenIndex, Data, taskParam] = introduceShot(taskParam, screenIndex, true, distMean, cannon);
WaitSecs(0.1);

% Introduce orange spot
% Todo: try to use either distMean or Data.distMean, not both...
distMean = 300;
Data.distMean = distMean;
txt = 'Move the orange spot to the part of the circle, where the cannon is aimed and press the left mouse button.';

[screenIndex, Data, taskParam] = introduceSpot(taskParam, screenIndex, distMean, Data, cannon, txt);

% Introduce miss of cannonball
[screenIndex, Data, taskParam] = introduceMisses(taskParam, screenIndex, Data, distMean, whichPractice);

% Introduce shield
win = true;
[screenIndex, Data] = introduceShield(taskParam, subject, screenIndex, Data, distMean, win);

% Introduce miss with shield
distMean = 65;
[screenIndex, Data, taskParam] = introduceShieldMiss(taskParam, screenIndex, Data, distMean, cannon);

% Repeat shield miss if cannonball was caught
Data.outcome = distMean;
[screenIndex, Data, t] = repeatShieldMiss(taskParam, screenIndex, Data, distMean);

% Confirm that cannonball was missed
win = true;
[screenIndex, Data, t] = confirmMiss(taskParam, subject, screenIndex, Data, t, distMean, win);

% Introduce shield color
[screenIndex, Data] = introduceShieldColor(taskParam, subject, screenIndex, Data, whichPractice);

% Run short practice block to illustrate shield size and color
[screenIndex, Data] = ShieldPractice(taskParam, subject, screenIndex);

% Start to introduce all trial outcomes:
% hit + win, hit + no win, miss + no win
screenIndex = TrialOutcomes(taskParam, subject, screenIndex);

distMean = 290;
%[screenIndex, Data] = MoveSpotToCannonAim(screenIndex, distMean, Data);
[screenIndex, Data] = MoveSpotToCannonAim(taskParam, screenIndex, distMean, Data, cannon);

% [screenIndex, Data] = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
[screenIndex, Data, taskParam] = introduceMisses(taskParam, screenIndex, Data, distMean, whichPractice);

win = true;
%[screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, distMean, win);
[screenIndex, Data] = introduceShield(taskParam, subject, screenIndex, Data,  distMean, win);

distMean = 35;
%[screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, distMean);
[screenIndex, Data, taskParam] = introduceShieldMiss(taskParam, screenIndex, Data, distMean, cannon);

Data.outcome = distMean;
% [screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
[screenIndex, Data, t] = repeatShieldMiss(taskParam, screenIndex, Data, distMean);

win = true;
% [screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, distMean, win);
[screenIndex, Data] = YouCollectedTheCannonball_TryToMissIt(taskParam, subject, screenIndex, Data, win);

distMean = 190;
% [screenIndex, Data] = MoveSpotToCannonAim(screenIndex, distMean, Data);
[screenIndex, Data, taskParam] = MoveSpotToCannonAim(taskParam, screenIndex, distMean, Data, cannon);

%screenIndex = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
[screenIndex, Data, taskParam] = introduceMisses(taskParam, screenIndex, Data, distMean, whichPractice);

win = false;
%[screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, distMean, win);
[screenIndex, Data] = introduceShield(taskParam, subject, screenIndex, Data,  distMean, win);

Data.outcome = distMean;
distMean = 160;
%[screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, distMean);
[screenIndex, Data, taskParam] = introduceShieldMiss(taskParam, screenIndex, Data, distMean, cannon);

distMean = 160;
Data.outcome = distMean;
%[screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
[screenIndex, Data, t] = repeatShieldMiss(taskParam, screenIndex, Data, distMean);

%[screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, distMean, false);
[screenIndex, Data] = YouCollectedTheCannonball_TryToMissIt(taskParam, subject, screenIndex, Data, win);

oddballPractice(taskParam, subject)

end
