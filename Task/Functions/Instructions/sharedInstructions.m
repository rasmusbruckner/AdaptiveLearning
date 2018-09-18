function sharedInstructions(taskParam, subject, cannon, whichPractice)
%SHAREDINSTRUCTIONS   Runs general instructions that are the same for each condtion
%
%   Input
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%       cannon: logical that indicates if cannon should be shown during instruction
%       whichPractice: indicates which practice condition should be presented
%   Output
%       ~ 


% Initialize to first screen
screenIndex = 1;

while 1
    switch(screenIndex)
        case 1
            
            % For "Dresden" version, show slide that indicates the current condition
            if isequal(taskParam.gParam.taskType, 'dresden')
                screenIndex = taskScreen(taskParam.textures.shieldTxt, screenIndex);
            else
                screenIndex = screenIndex + 1;
            end
            
        case 2
            
            % Introduce cannon
            distMean = 300;
            screenIndex = introduceCannon(screenIndex, taskParam, distMean, cannon);
            
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
            [screenIndex, Data, taskParam] = introduceSpot(taskParam, screenIndex, distMean, Data, cannon);
            
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
            [screenIndex, Data] = introduceShieldColor(taskParam, subject, screenIndex, Data);
            
        case 11
            
            % Run short practice block to illustrate shield size and color
            [screenIndex, Data] = shieldPractice(taskParam, subject, screenIndex);
            
            % For chinese and ARC we immediately go to case 25 to run task-specific instructions
            if isequal(taskParam.gParam.taskType, 'chinese') || isequal(taskParam.gParam.taskType, 'ARC')
                screenIndex = 25;
            end
            
        case 12
            
            % Start to introduce all trial outcomes:
            % hit + win, hit + no win, miss + no win
            screenIndex = trialOutcomes(screenIndex);
            
        case 13
            
            %
            distMean = 290;
            [screenIndex, Data] = MoveSpotToCannonAim(screenIndex, distMean, Data);
            
        case 14
            
            % XX
            [screenIndex, Data] = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
            
        case 15
            
            % XX
            win = true;
            [screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, distMean, win);
            
        case 16
            
            % XX
            distMean = 35;
            [screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, distMean);
            
        case 17
            
            % XX
            Data.outcome = distMean;
            [screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
            
        case 18
            
            % XX
            win = true;
            [screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, distMean, win);
            
        case 19
            
            % XX
            distMean = 190;
            [screenIndex, Data] = MoveSpotToCannonAim(screenIndex, distMean, Data);
            
        case 20
            
            % XX
            screenIndex = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
            
        case 21
            
            % XX
            win = false;
            [screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, distMean, win);
            
        case 22
            
            %XX
            Data.outcome = distMean;
            distMean = 160;
            [screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, distMean);
            
        case 23
            
            % XX
            distMean = 160;
            Data.outcome = distMean;
            [screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
            
        case 24
            
            % XX
            [screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, distMean, false);
            
        case 25
            
            % XX
            if isequal(whichPractice, 'mainPractice') || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 4) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 6)
                
                warning('turned first practice off')
                %MainAndFollowCannon_CannonVisibleNoNoise
                % warning('turned second practice off')
                MainAndFollowCannon_CannonVisibleNoise(whichPractice, taskParam, subject)
                
                %LoadData = 'CP_Noise';
                %condition = 'mainPractice_2';
                condition = 'onlinePractice';
                al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject);
                
            elseif isequal(whichPractice, 'oddballPractice')
                
                % XX
                oddballPractice
                
            elseif isequal(taskParam.gParam.taskType, 'reversal')
                
                % XX
                reversalPractice
                
            elseif isequal(taskParam.gParam.taskType, 'dresden')
                
                % XX
                FollowCannonJustInstructions
                
            elseif (isequal(whichPractice, 'chinese'))
                
                % Run task specific instructions for chinese condition
                chinesePractice(taskParam, subject)
                
            end
            
            break
    end
end
end