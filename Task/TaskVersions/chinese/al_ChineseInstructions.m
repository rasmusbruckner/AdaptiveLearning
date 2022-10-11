function al_ChineseInstructions(taskParam, subject, cannon, whichPractice)
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
if taskParam.gParam.language == 1
    txt = ['Du bist die Weltraumpolizei und beschützt deinen Planeten.\nEin fremdes Raumschiff zielt mit seiner Kanone auf eine Stelle deines Planeten und feuert '...
        'Kanonenkugeln. Deine Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen Punkt kannst du angeben, wo du dein Schild platzieren möchtest, '...
        'um die Kanonenkugel abzuwehren. Du kannst den Punkt mit der Maus bewegen. Das kannst du jetzt ausprobieren.'];
elseif taskParam.gParam.language == 2
    txt = ['You are the space police and you must protect your planet.\n\nA foreign spaceship aims its cannon at a spot on your planet and fires '...
        'cannonballs. \nYour task is to fend off the cannonball with a shield. The orange dot lets you specify a point where you want to place your shield, '...
        'to ward off the cannonballs. \n\nYou can move the point with your mouse. Try it now.'];
end

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

% Run task-specific instructions for chinese condition
chinesePractice(taskParam, subject)


end