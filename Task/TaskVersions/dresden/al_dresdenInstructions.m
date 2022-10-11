function al_dresdenInstructions(taskParam, subject, cannon, whichPractice)
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

% Adjust text settings
Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');
Screen('TextSize', taskParam.gParam.window.onScreen, 50);

% Display first slide indicating the current task version
al_indicateCondition(taskParam, subject, whichPractice)

% Initialize to first screen
screenIndex = 1;

% oddball dinger müssten ja raus können...
if isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'mainPractice') && subject.cBal == 1) || (isequal(whichPractice, 'mainPractice')...
        && subject.cBal == 2) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 3) || (isequal(whichPractice, 'followCannonPractice')...
        && subject.cBal == 4) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5) || (isequal(whichPractice, 'followCannonPractice')...
        && subject.cBal == 6)
    
    while 1
        switch(screenIndex)
            case 1
                
                    txt = 'Kanonenkugeln Abwehren';
                    screenIndex = taskScreen(taskParam, taskParam.textures.shieldTxt, screenIndex, txt);
             
                
            case 2
                
                % Introduce cannon
                distMean = 300;
                    if isequal(taskParam.subject.group, '1')
                        txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Deine Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen Punkt kannst du angeben, '...
                            'wo du dein Schild platzieren möchtest, um die Kanonenkugel abzuwehren.\nDu kannst den Punkt mit den grünen und blauen Tasten steuern. Grün kannst du für schnelle '...
                            'Bewegungen und blau für langsame Bewegungen benutzen.'];
                    else
                        txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Ihre Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen '...
                            'Punkt können Sie angeben, wo Sie Ihr Schild platzieren möchten, um die Kanonenkugel abzuwehren.\nSie können den Punkt mit den '...
                            'grünen und blauen Tasten steuern. Grün können Sie für schnelle Bewegungen und blau für langsame Bewegungen benutzen.'];
                    end

                
                screenIndex = introduceCannon(screenIndex, taskParam, distMean, cannon, whichPractice, txt);
                
            case 3
                
                % Introduce shot of the cannon
                distMean = 240;
                [screenIndex, Data, taskParam] = introduceShot(taskParam, screenIndex, true, distMean, cannon);
                WaitSecs(0.1);
                
            case 4
                
                % Introduce orange spot
                % Todo: try to use either distMean or Data.distMean, not both...
                distMean = 300;
                Data.distMean = distMean;
                %if isequal(taskParam.gParam.taskType, 'dresden')
                    if isequal(taskParam.subject.group, '1')
                        txt=['Der schwarze Strich zeigt dir die Position der letzten Kugel. Der orangene Strich zeigt dir die '...
                            'Position deines letzten Schildes. Steuere den orangenen Punkt jetzt auf das Ziel der Kanone und drücke LEERTASTE.'];
                    else
                        txt=['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. Der orangene Strich zeigt Ihnen die '...
                            'Position Ihres letzten Schildes. Steuern Sie den orangenen Punkt jetzt bitte auf das Ziel der Kanone und drücken Sie LEERTASTE.'];
                    end
                %elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC') || isequal(taskParam.gParam.taskType, 'oddball') || (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 2) % für oddball am 30.09.21 hinzugefügt. verifizieren, ob das in ursprünglicher version auch so war
                %    txt = 'Move the orange spot to the part of the circle, where the cannon is aimed and press the left mouse button.';
                %end
                [screenIndex, Data, taskParam] = introduceSpot(taskParam, screenIndex, distMean, Data, cannon, txt);
                
            case 5
                
                % Introduce miss of cannonball
                [screenIndex, Data, taskParam] = introduceMisses(taskParam, screenIndex, Data, distMean, whichPractice);
                
            case 6
                
                % Introduce shield
                win = true;
                [screenIndex, Data] = introduceShield(taskParam, subject, screenIndex, Data, distMean, win);
                
            case 7
                
                % Introduce miss with shield
                distMean = 65;
                [screenIndex, Data, taskParam] = introduceShieldMiss(taskParam, screenIndex, Data, distMean, cannon);
                
            case 8
                
                % Repeat shield miss if cannonball was caught
                Data.outcome = distMean;
                [screenIndex, Data, t] = repeatShieldMiss(taskParam, screenIndex, Data, distMean);
                
            case 9
                
                % Confirm that cannonball was missed
                win = true;
                [screenIndex, Data, t] = confirmMiss(taskParam, subject, screenIndex, Data, t, distMean, win);
                
            case 10
                
                % Introduce shield color
                [screenIndex, Data] = introduceShieldColor(taskParam, subject, screenIndex, Data, whichPractice);
                
            case 11
                
                % Run short practice block to illustrate shield size and color
                [screenIndex, Data] = ShieldPractice(taskParam, subject, screenIndex);
                
                % For chinese and ARC we immediately go to case 25 to run task-specific instructions
                %if isequal(taskParam.gParam.taskType, 'chinese') || isequal(taskParam.gParam.taskType, 'ARC')
                %    screenIndex = 25;
               % end
                
            case 12
                
                % Start to introduce all trial outcomes:
                % hit + win, hit + no win, miss + no win
                screenIndex = TrialOutcomes(taskParam, subject, screenIndex);
                
            case 13
                
                distMean = 290;
                %[screenIndex, Data] = MoveSpotToCannonAim(screenIndex, distMean, Data);
                [screenIndex, Data] = MoveSpotToCannonAim(taskParam, screenIndex, distMean, Data, cannon);
                
            case 14
                
                % [screenIndex, Data] = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
                [screenIndex, Data, taskParam] = introduceMisses(taskParam, screenIndex, Data, distMean, whichPractice);
                
            case 15
                
                win = true;
                %[screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, distMean, win);
                [screenIndex, Data] = introduceShield(taskParam, subject, screenIndex, Data,  distMean, win);
                
            case 16
                
                distMean = 35;
                %[screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, distMean);
                [screenIndex, Data, taskParam] = introduceShieldMiss(taskParam, screenIndex, Data, distMean, cannon);
                
            case 17
                
                Data.outcome = distMean;
                % [screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
                [screenIndex, Data, t] = repeatShieldMiss(taskParam, screenIndex, Data, distMean);
                
            case 18
                
                win = true;
                % [screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, distMean, win);
                [screenIndex, Data] = YouCollectedTheCannonball_TryToMissIt(taskParam, subject, screenIndex, Data, win);
                
            case 19
                
                distMean = 190;
                % [screenIndex, Data] = MoveSpotToCannonAim(screenIndex, distMean, Data);
                [screenIndex, Data, taskParam] = MoveSpotToCannonAim(taskParam, screenIndex, distMean, Data, cannon);
                
            case 20
                
                %screenIndex = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
                [screenIndex, Data, taskParam] = introduceMisses(taskParam, screenIndex, Data, distMean, whichPractice);
                
            case 21
                
                win = false;
                %[screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, distMean, win);
                [screenIndex, Data] = introduceShield(taskParam, subject, screenIndex, Data,  distMean, win);
                
            case 22
                
                Data.outcome = distMean;
                distMean = 160;
                %[screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, distMean);
                [screenIndex, Data, taskParam] = introduceShieldMiss(taskParam, screenIndex, Data, distMean, cannon);
                
            case 23
                
                distMean = 160;
                Data.outcome = distMean;
                %[screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
                [screenIndex, Data, t] = repeatShieldMiss(taskParam, screenIndex, Data, distMean);
                
            case 24
                
                %[screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, distMean, false);
                [screenIndex, Data] = YouCollectedTheCannonball_TryToMissIt(taskParam, subject, screenIndex, Data, win);
                
            case 25
                
                if isequal(whichPractice, 'mainPractice') || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 4) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 6)
                    
                    warning('turned first practice off')
                    %MainAndFollowCannon_CannonVisibleNoNoise
                    % warning('turned second practice off')
                    MainAndFollowCannon_CannonVisibleNoise(whichPractice, taskParam, subject)
                    
                    %LoadData = 'CP_Noise';
                    %condition = 'mainPractice_2';
                    condition = 'onlinePractice';
                    [taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(1), taskParam.gParam.concentration(3)); 
                    al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
                    
                %elseif isequal(whichPractice, 'oddballPractice')
                    
                   % oddballPractice(taskParam, subject)
                    
              %  elseif isequal(taskParam.gParam.taskType, 'reversal')
                    
                 %   reversalPractice(taskParam, subject)
          
                elseif isequal(taskParam.gParam.taskType, 'dresden')
                    
                    FollowCannonJustInstructions
                    
               % elseif (isequal(whichPractice, 'chinese'))
                    
                    % Run task-specific instructions for chinese condition
                   % chinesePractice(taskParam, subject)
                    
                end
                
                break
        end
    end
    
elseif isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'mainPractice') && subject.cBal == 4) || (isequal(whichPractice, 'mainPractice')...
        && subject.cBal == 5) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 6)
    MainJustInstructions
elseif isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 1)...
        || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 2) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 3)
    FollowCannonJustInstructions(taskParam)
elseif isequal(whichPractice, 'followOutcomePractice')
    FollowOutcomeInstructions(taskParam, subject, true, whichPractice)
end
end


