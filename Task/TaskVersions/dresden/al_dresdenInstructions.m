function al_dresdenInstructions(taskParam, subject, cannon, whichPractice)
%AL_DRESDENINSTRUCTIONS This function runs the instructions for the "Dresden Version"
%
%   Input
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%       cannon: logical that indicates if cannon should be shown during instruction
%       whichPractice: indicates which practice condition should be presented
%
%   Output
%       ~


% Indicate that cannon will be displayed during instructions
taskParam.trialflow.cannon = 'show cannon';
taskParam.trialflow.currentTickmarks = 'hide';

% Adjust text settings
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('TextSize', taskParam.display.window.onScreen, 50);


if subject.rew == 1
    colRew = 'gold';
    colNoRew = 'grau';
elseif subject.rew == 2
    colRew = 'silber';
    colNoRew = 'gelb';
end


% Display first slide indicating the current task version
al_indicateCondition(taskParam, whichPractice)

% Todo ensure these are reasonable params
% Load taskData-object instance
nTrials = 4;
taskData = al_taskDataMain(nTrials);

% Generate practice-phase data
taskData.catchTrial(1:nTrials) = 0; % no catch trials
taskData.initiationRTs(1:nTrials) = nan;  % set initiation RT to nan to indicate that this is the first response
taskData.block(1:nTrials) = 1; % block number
taskData.allASS(1:nTrials) = rad2deg(2*sqrt(1/12)); % shield size todo: check if concentration is as desired (curr 12)
taskData.shieldType(1:nTrials) = 1; % shield color
taskData.distMean = [0, 300, 300, 65]; % aim of the cannon
taskData.outcome = taskData.distMean; % in practice phase, mean and outcome are the same

% Initialize to first screen
screenIndex = 1;

% oddball dinger müssten ja raus können...
if isequal(whichPractice, 'oddballPractice') || (isequal(whichPractice, 'mainPractice') && subject.cBal == 1) || (isequal(whichPractice, 'mainPractice')...
        && subject.cBal == 2) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 3) || (isequal(whichPractice, 'followCannonPractice')...
        && subject.cBal == 4) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5) || (isequal(whichPractice, 'followCannonPractice')...
        && subject.cBal == 6)
    
 %   while 1
       % switch(screenIndex)
           % case 1
                
                    txt = 'Kanonenkugeln Abwehren';
                    screenIndex = taskScreen(taskParam, screenIndex, txt);
             
                
            %case 2
                
                % Introduce cannon
              %  distMean = 300;
                    if isequal(taskParam.subject.group, '1')
                        txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Deine Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen Punkt kannst du angeben, '...
                            'wo du dein Schild platzieren möchtest, um die Kanonenkugel abzuwehren.\nDu kannst den Punkt mit den grünen und blauen Tasten steuern. Grün kannst du für schnelle '...
                            'Bewegungen und blau für langsame Bewegungen benutzen.'];
                    else
                        txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Ihre Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen '...
                            'Punkt können Sie angeben, wo Sie Ihr Schild platzieren möchten, um die Kanonenkugel abzuwehren.\nSie können den Punkt mit den '...
                            'grünen und blauen Tasten steuern. Grün können Sie für schnelle Bewegungen und blau für langsame Bewegungen benutzen.'];
                    end
                   
                 
                % todo: need to define task data as in other version, and
                % also trial

                % todo cannon centered as previously in dresden

                % before continuing, use trialflow in introduceCannon
                currTrial = 1;
                taskParam = al_introduceCannon(taskParam, taskData, currTrial, txt);
                
            %case 3
                
                % Introduce shot of the cannon
                %distMean = 240;
                currTrial = 2; % update trial number

                %[screenIndex, Data, taskParam] = introduceShot(taskParam, screenIndex, true, distMean, cannon);
                txt = 'Das Ziel der Kanone wird mit der schwarzen Linie angezeigt. Drücken Sie die Leertaste, damit die Kanone schießt.';
                [taskData, taskParam] = al_introduceShot(taskParam, taskData, currTrial, txt);
                %taskParam = al_introduceCannon(taskParam, taskData, currTrial, txt);

                WaitSecs(0.1);
                

                

            %case 4
                
                % Introduce orange spot
                % Todo: try to use either distMean or Data.distMean, not both...
%                 distMean = 300;
%                 Data.distMean = distMean;
%                 %if isequal(taskParam.gParam.taskType, 'dresden')
%                     if isequal(taskParam.subject.group, '1')
%                         txt=['Der schwarze Strich zeigt dir die Position der letzten Kugel. Der orangene Strich zeigt dir die '...
%                             'Position deines letzten Schildes. Steuere den orangenen Punkt jetzt auf das Ziel der Kanone und drücke LEERTASTE.'];
%                     else
%                         txt=['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. Der orangene Strich zeigt Ihnen die '...
%                             'Position Ihres letzten Schildes. Steuern Sie den orangenen Punkt jetzt bitte auf das Ziel der Kanone und drücken Sie LEERTASTE.'];
%                     end
%                 %elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC') || isequal(taskParam.gParam.taskType, 'oddball') || (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 2) % für oddball am 30.09.21 hinzugefügt. verifizieren, ob das in ursprünglicher version auch so war
%                 %    txt = 'Move the orange spot to the part of the circle, where the cannon is aimed and press the left mouse button.';
%                 %end
% 
               
            % 4. Introduce prediction spot and ask participant to catch cannonball
                % --------------------------------------------------------------------
            
                % Add tickmarks to introduce them to participant
                taskParam.trialflow.currentTickmarks = 'show';
                currTrial = 3; % update trial number
            
                % Repeat as long as subject misses cannonball
                while 1
            
                    txt=['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. Der violette Strich zeigt Ihnen die '...
                        'Position Ihres letzten Schildes. Steuern Sie den violetten Punkt jetzt bitte auf das Ziel der Kanone und drücken Sie LEERTASTE.'];
                    [taskData, taskParam] = al_introduceSpot(taskParam, taskData, currTrial, txt);
            
                    % If it is a miss, repeat instruction
                    if abs(taskData.predErr(currTrial)) >= taskParam.gParam.practiceTrialCriterionEstErr
                        header = 'Leider nicht gefangen!';
                        txt = 'Sie haben die Kanonenkugel verfehlt. Versuchen Sie es noch mal!';
                        feedback = false; % indicate that this is the instruction mode
                        al_bigScreen(taskParam, header, txt, feedback);
                    else
                        break
                    end
                end


                % todo noch nicht ganz
                win = 1
                 txt=['Das Schild erscheint nach dem '...
                                'Schuss. In diesem Fall haben Sie die '...
                                'Kanonenkugel abgewehrt. '...
                                'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, '...
                                'zählt es als Treffer.'];
                al_introduceShield(taskParam, taskData, win, currTrial, txt)

                % todo: look up sequence in old instructions


                
    % 6. Ask participant to miss cannonball
    % -------------------------------------

    % Update trial number
    currTrial = 4;

    % Repeat as long as subject catches cannonball
    while 1

        % todo add fixation cross in between 
        % Introduce miss with shield
        txt = 'Versuchen Sie nun Ihr Schild so zu positionieren, dass Sie die Kanonenkugel verfehlen. Drücken Sie dann die LEERTASTE.';
        [taskData, taskParam] = al_introduceShieldMiss(taskParam, taskData, currTrial, txt);

        % If it is a hit, repeat instruction
        if abs(taskData.predErr) <= taskParam.gParam.practiceTrialCriterionEstErr

            WaitSecs(0.5)
            header = 'Leider gefangen!';
            txt = 'Sie haben die Kanonenkugel gefangen. Versuchen Sie bitte, die Kugel nicht zu fangen!';
            feedback = false; % indicate that this is the instruction mode
            al_bigScreen(taskParam, header, txt, feedback);  % todo: code needs to be re-organized
        else
            break
        end

    end

    % 7. Confirm that cannonball was missed
    % -------------------------------------
    win = true;
    txt = 'In diesem Fall haben Sie die Kanonenkugel verfehlt.';
    al_confirmMiss(taskParam, taskData, win, currTrial, txt);




    % 8. Introduce variability of the cannon
    % --------------------------------------

    % Display instructions
    header = 'Das Schild';
    txt = sprintf(['Wenn Sie Kanonenkugeln abwehren, '...
                            'können Sie Geld verdienen. Wenn das Schild '...
                            '%s ist, verdienen Sie %s CENT wenn Sie die '...
                            'Kanonenkugel abwehren. Wenn das Schild %s '...
                            'ist, verdienen Sie nichts. Ebenso wie die '...
                            'Farbe, kann auch die Größe Ihres '...
                            'Schildes variieren. '...
                            'Die Farbe und die Größe des Schildes sehen '...
                            'Sie erst, nachdem die Kanone geschossen hat. '...
                            'Daher versuchen Sie am besten jede '...
                            'Kanonenkugel abzuwehren.\n\n'...
                            'Um einen Eindruck von der wechselnden Größe '...
                            'und Farbe des Schildes zu bekommen, '...
                            'kommt jetzt eine kurze Übung.\n\n'], colRew, num2str(100*taskParam.gParam.rewMag), colNoRew);
    feedback = false; % indicate that this is the instruction mode
    al_bigScreen(taskParam, header, txt, feedback);


    % hier kommt jetzt kurze shield practice

    % Generate outcomes using cannonData function
            taskData.trials = taskParam.gParam.shieldTrials;
            taskData = taskData.al_cannonData(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(2), taskParam.gParam.safe);

            % hier noch cannon zeigen
            taskParam.trialflow.cannon = "show cannon";
            %taskData = al_generateOutcomesMain(taskParam, condobj.haz(1), currentConcentration, 'main');
            [~, dataMain] = al_dresdenLoop(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(2), 'main', subject, taskData, taskParam.gParam.shieldTrials);


                  txt=['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. Der orangene Strich zeigt Ihnen die '...
                            'Position Ihres letzten Schildes. Steuern Sie den orangenen Punkt jetzt bitte auf das Ziel der Kanone und drücken Sie LEERTASTE.'];

                [taskData, taskParam] = al_introduceSpot(taskParam, taskData, currTrial, txt);
                            
            
                

                
%            % case 5
                whichPractice = "mainPractice";
                % Introduce miss of cannonball
                txt = "hallo"
                [taskData, taskParam] = introduceMisses(taskParam, taskData, whichPractice, txt);
                
           % case 6
                
                % Introduce shield
                win = true;
                [screenIndex, Data] = introduceShield(taskParam, subject, screenIndex, Data, distMean, win);
                
          %  case 7
                
                % Introduce miss with shield
                distMean = 65;
                [screenIndex, Data, taskParam] = introduceShieldMiss(taskParam, screenIndex, Data, distMean, cannon);
                
         %   case 8
                
                % Repeat shield miss if cannonball was caught
                Data.outcome = distMean;
                [screenIndex, Data, t] = repeatShieldMiss(taskParam, screenIndex, Data, distMean);
                
          %  case 9
                
                % Confirm that cannonball was missed
                win = true;
                [screenIndex, Data, t] = confirmMiss(taskParam, subject, screenIndex, Data, t, distMean, win);
                
%case 10
                
                % Introduce shield color
                [screenIndex, Data] = introduceShieldColor(taskParam, subject, screenIndex, Data, whichPractice);
                
         %   case 11
                
                % Run short practice block to illustrate shield size and color
                [screenIndex, Data] = ShieldPractice(taskParam, subject, screenIndex);
                
                % For chinese and ARC we immediately go to case 25 to run task-specific instructions
                %if isequal(taskParam.gParam.taskType, 'chinese') || isequal(taskParam.gParam.taskType, 'ARC')
                %    screenIndex = 25;
               % end
                
        %    case 12
                
                % Start to introduce all trial outcomes:
                % hit + win, hit + no win, miss + no win
                screenIndex = TrialOutcomes(taskParam, subject, screenIndex);
                
        %    case 13
        %        
                distMean = 290;
                %[screenIndex, Data] = MoveSpotToCannonAim(screenIndex, distMean, Data);
                [screenIndex, Data] = MoveSpotToCannonAim(taskParam, screenIndex, distMean, Data, cannon);
                
     %       case 14
                
                % [screenIndex, Data] = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
                [screenIndex, Data, taskParam] = introduceMisses(taskParam, screenIndex, Data, distMean, whichPractice);
                
      %      case 15
                
                win = true;
                %[screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, distMean, win);
                [screenIndex, Data] = introduceShield(taskParam, subject, screenIndex, Data,  distMean, win);
                
      %      case 16
                
                distMean = 35;
                %[screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, distMean);
                [screenIndex, Data, taskParam] = introduceShieldMiss(taskParam, screenIndex, Data, distMean, cannon);
                
     %       case 17
     %           
                Data.outcome = distMean;
                % [screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
                [screenIndex, Data, t] = repeatShieldMiss(taskParam, screenIndex, Data, distMean);
                
    %        case 18
                
                win = true;
                % [screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, distMean, win);
                [screenIndex, Data] = YouCollectedTheCannonball_TryToMissIt(taskParam, subject, screenIndex, Data, win);
                
    %        case 19
                
                distMean = 190;
                % [screenIndex, Data] = MoveSpotToCannonAim(screenIndex, distMean, Data);
                [screenIndex, Data, taskParam] = MoveSpotToCannonAim(taskParam, screenIndex, distMean, Data, cannon);
                
     %       case 20
                
                %screenIndex = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
                [screenIndex, Data, taskParam] = introduceMisses(taskParam, screenIndex, Data, distMean, whichPractice);
                
     %       case 21
                
                win = false;
                %[screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, distMean, win);
                [screenIndex, Data] = introduceShield(taskParam, subject, screenIndex, Data,  distMean, win);
                
      %      case 22
                
                Data.outcome = distMean;
                distMean = 160;
                %[screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, distMean);
                [screenIndex, Data, taskParam] = introduceShieldMiss(taskParam, screenIndex, Data, distMean, cannon);
                
    %        case 23
                
                distMean = 160;
                Data.outcome = distMean;
                %[screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
                [screenIndex, Data, t] = repeatShieldMiss(taskParam, screenIndex, Data, distMean);
                
      %      case 24
                
                %[screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, distMean, false);
                [screenIndex, Data] = YouCollectedTheCannonball_TryToMissIt(taskParam, subject, screenIndex, Data, win);
                
      %      case 25
                
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
                
               % break
        %end
   % end
    
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


