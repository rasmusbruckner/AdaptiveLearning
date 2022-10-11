function al_reversalInstructions(taskParam, subject, cannon, whichPractice)
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

%while 1
%  switch(screenIndex)



% Introduce cannon
distMean = 300;
if isequal(taskParam.gParam.taskType, 'dresden')
    if isequal(taskParam.subject.group, '1')
        txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Deine Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen Punkt kannst du angeben, '...
            'wo du dein Schild platzieren möchtest, um die Kanonenkugel abzuwehren.\nDu kannst den Punkt mit den grünen und blauen Tasten steuern. Grün kannst du für schnelle '...
            'Bewegungen und blau für langsame Bewegungen benutzen.'];
    else
        txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Ihre Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen '...
            'Punkt können Sie angeben, wo Sie Ihr Schild platzieren möchten, um die Kanonenkugel abzuwehren.\nSie können den Punkt mit den '...
            'grünen und blauen Tasten steuern. Grün können Sie für schnelle Bewegungen und blau für langsame Bewegungen benutzen.'];
    end
elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC') || isequal(taskParam.gParam.taskType, 'oddball')   % für oddball am 30.09.21 hinzugefügt. verifizieren, ob das in ursprünglicher version auch so war
    txt = 'A cannon is aimed at the circle. Indicate where you would like to place your shield to catch cannonballs with the orange spot. You can move the orange spot using the mouse.';
elseif isequal(taskParam.gParam.taskType, 'chinese')
    if taskParam.gParam.language == 1
        txt = ['Du bist die Weltraumpolizei und beschützt deinen Planeten.\nEin fremdes Raumschiff zielt mit seiner Kanone auf eine Stelle deines Planeten und feuert '...
            'Kanonenkugeln. Deine Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen Punkt kannst du angeben, wo du dein Schild platzieren möchtest, '...
            'um die Kanonenkugel abzuwehren. Du kannst den Punkt mit der Maus bewegen. Das kannst du jetzt ausprobieren.'];
    elseif taskParam.gParam.language == 2
        txt = ['You are the space police and you must protect your planet.\n\nA foreign spaceship aims its cannon at a spot on your planet and fires '...
            'cannonballs. \nYour task is to fend off the cannonball with a shield. The orange dot lets you specify a point where you want to place your shield, '...
            'to ward off the cannonballs. \n\nYou can move the point with your mouse. Try it now.'];
    end
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



%reversalPractice(taskParam, subject)

screenIndex = 1;


while 1
    
    switch(screenIndex)
        
        case 1
            
            header = 'First Practice';
            txt = ['You will now need to catch '...
                'cannonballs shot from the cannon. '...
                'The cannon will usually remain aimed '...
                'at the same location. However, '...
                'occasionally the cannon will be '...
                'reaimed to a different '...'
                'part of the circle.\n\nIf the cannon '...
                'reaims its position, it will go back '...
                'to its previous aim. To earn most '...
                'money you should center your shield '...
                'on the location at which the cannon '...
                'is aimed.'];
            
            feedback = false;
            fw = al_bigScreen(taskParam, ...
                taskParam.strings.txtPressEnter, header,...
                txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1; % 1
            end
            WaitSecs(0.1);
            
        case 2
            
            condition = 'reversalPractice';
            LoadData = 'reversalVisibleNoNoise';
            
            %                     [taskParam, practData] = practLoop(taskParam,...
            %                         subject, taskParam.gParam.haz(1),...
            %                         taskParam.gParam.concentration(3), cannon,...
            %                         condition, LoadData);
            % added this (02.01.17) to get rid of practLoop
            [taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(1), taskParam.gParam.concentration(3)); % am 15.10.21 hier geändert, um das unabhängig zu machen.
            [~, practData] = al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
            
            [txt, header] = al_feedback(practData, taskParam, subject, condition);
            feedback = true;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            sumCannonDev = sum(abs(practData.cannonDev) >= 10);
            if fw == 1
                
                screenIndex = screenIndex + 1;
                
            end
            WaitSecs(0.1);
            
        case 3
            if sumCannonDev >= 4
                
                header = 'Try it again!';
                txt = ['In that block your shield was not '...
                    'always placed where the cannon was '...
                    'aiming. Remember: Placing your shield '...
                    'where the cannon is aimed will be the '...
                    'best way to catch cannonballs. Now try again.'];
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                if fw == 1
                    screenIndex = screenIndex - 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
            else
                
                header = 'Second Practice';
                txt = ['In this block you will encounter a '...
                    'cannon that is not perfectly accurate. '...
                    'On some trials it might shoot a bit '...
                    'above where it is aimed and on other '...
                    'trials a bit below. Your best strategy '...
                    'is still to place the shield in the '...
                    'location where the cannon is aimed. If '...
                    'the cannon reaims its position, it will '...
                    'still go back to its previous aim.'];
                
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                if fw == 1
                    screenIndex = screenIndex + 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
                
            end
            WaitSecs(0.1);
            
        case 4
            
            condition = 'reversalPracticeNoise';
            LoadData = 'reversalVisibleNoise';
            
            %                     [taskParam, practData] = practLoop(taskParam,...
            %                         subject, taskParam.gParam.haz(1),...
            %                         taskParam.gParam.concentration(1), cannon,...
            %                         condition, LoadData);
            % added this (02.01.17) to get rid of practLoop
            [taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(1), taskParam.gParam.concentration(3)); % am 15.10.21 hier geändert, um das unabhängig zu machen.
            [~, practData] =  al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
            
            [txt, header] = al_feedback(practData, taskParam, subject, condition);
            feedback = true;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt,feedback);
            sumCannonDev = sum(abs(practData.cannonDev) >= 10);
            if fw == 1
                
                screenIndex = screenIndex + 1;
                
            end
            WaitSecs(0.1);
            
        case 5
            if sumCannonDev >= 4
                
                header = 'Try it again!';
                txt = ['In that block your shield was not '...
                    'always placed where the cannon was '...
                    'aiming. Remember: Placing your shield '...
                    'where the cannon is aimed will be the '...
                    'best way to catch cannonballs. Now try again.' ];
                
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header,txt, feedback);
                if fw == 1
                    screenIndex = screenIndex - 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
            else
                
                header = 'Third Practice';
                
                txt = ['In the next block everything will be '...
                    'exactly the same except that you will no '...
                    'longer see the cannon. The cannon is '...
                    'still aiming and shooting exactly as '...
                    'before. You will be paid for catching '...
                    'balls exactly as before. But now you must '...
                    'place your shield at the position where '...
                    'you think the cannon is aimed.\n\nSince '...
                    'you will still see each ball shot from '...
                    'the cannon, you will be able to use the '...
                    'locations of past shots to inform your '...
                    'decision.\n\nTo help you remember the '...
                    'previous aim of the cannon you can place '...
                    'a tickmark at the position where you '...
                    'think the cannon aimed previously.'...
                    '\n\nPress Enter to see an example of this.'];
                
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header,txt, feedback);
                if fw == 1
                    screenIndex = screenIndex + 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
                
            end
            WaitSecs(0.1);
            
        case 6
            
            txt=['To place your tickmark, move the orange spot '...
                'to the part of the circle, where the cannon '...
                'is aiming and hit the right mouse button. '...
                'Take your time to try out how to set the '...
                'tickmark a couple of times. Then indicate '...
                'where you would like to place your shield to '...
                'catch the next cannonball.'];
            
            distMean = 290;
            outcome = 178;
            tickInstruction.savedTickmark = nan;
            tickInstruction.previousOutcome = nan;
            tickInstruction.previousPrediction = nan;
            cannon = true;
            [taskParam, fw, Data, savedTickmark] = al_instrLoopTxt(taskParam, txt, cannon, 'space', distMean, tickInstruction);
            al_lineAndBack(taskParam)
            al_drawCircle(taskParam);
            al_drawCross(taskParam);
            al_predictionSpot(taskParam);
            al_drawOutcome(taskParam, outcome);
            
            if abs(Data.tickCannonDev) > 3 || isnan(Data.tickCannonDev)
                
                header = 'Try it again!';
                
                if ~isnan(Data.tickCannonDev)
                    txt = ['In this case your tickmark was too '...
                        'far away from the cannon aim. '...
                        'Remember: Placing your '...
                        'tickmark where the cannon is aimed '...
                        'will be the best way to catch cannonballs. '...
                        'Now try again. '];
                elseif isnan(Data.tickCannonDev)
                    txt = ['In this case you did not save your '...
                        'tickmark. Remember: Placing your '...
                        'tickmark where the cannon is aimed '...
                        'will be the best way to catch cannonballs. '...
                        'Now try again.'];
                end
                
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header,txt, feedback);
                
            else
                
                Screen('DrawingFinished', taskParam.gParam.window.onScreen);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
                % Show baseline 1.
                al_drawCross(taskParam);
                al_lineAndBack(taskParam)
                al_drawCross(taskParam)
                al_drawCircle(taskParam)
                Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
                Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6, 1);
                
                % Show baseline 1.
                al_drawCross(taskParam);
                al_lineAndBack(taskParam)
                al_drawCross(taskParam)
                al_drawCircle(taskParam)
                if subject.rew == 1
                    al_shield(taskParam, 20, Data.pred, 1)
                elseif subject.rew == 2
                    al_shield(taskParam, 20, Data.pred, 0)
                end
                
                al_drawOutcome(taskParam, outcome)
                
                Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
                Screen('Flip', taskParam.gParam.window.onScreen, t + 1.6, 1);
                
                % Show baseline 1.
                al_drawCross(taskParam);
                al_lineAndBack(taskParam)
                al_drawCross(taskParam)
                al_drawCircle(taskParam)
                Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
                Screen('Flip', taskParam.gParam.window.onScreen, t + 2.1, 1);
                WaitSecs(1);
                
                while 1
                    txt=['In this case the cannon reaimed its '...
                        'postion. Your saved tickmark helps '...
                        'you to remember the previous aim of '...
                        'the cannon. When the cannon reaims '...
                        'again you should use your saved '...
                        'tickmark to quickly adapt your '...
                        'prediction. \nIn the next few trials '...
                        'you will not see the cannon anymore '...
                        'but you should still try to catch as '...
                        'many cannonballs as possible.'];
                    al_lineAndBack(taskParam)
                    al_drawCross(taskParam)
                    al_drawCircle(taskParam)
                    al_predictionSpot(taskParam);
                    al_tickMark(taskParam, savedTickmark, 'saved');
                    al_drawOutcome(taskParam, outcome)
                    DrawFormattedText(taskParam.gParam.window.onScreen,txt, taskParam.gParam.screensize(3)*0.1,...
                        taskParam.gParam.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
                    DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter, 'center', taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                    Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
                    Screen('Flip', taskParam.gParam.window.onScreen, t + 1.6);
                    [ keyIsDown, ~, keyCode ] = KbCheck;
                    if keyIsDown
                        if keyCode(taskParam.keys.enter)
                            screenIndex = screenIndex + 1;
                            break
                        elseif keyCode(taskParam.keys.delete)
                            screenIndex = screenIndex - 3;
                            break
                        end
                    end
                end
                
                condition = 'reversalPracticeNoiseInv';
                LoadData = 'None';
                cannon = 'true';
                reversalPackage = struct('savedTickmark', savedTickmark, 'pred', Data.pred, 'outcome', outcome);
                %                         [taskParam, practData, leaveLoop] = practLoop(taskParam,...
                %                             subject, taskParam.gParam.haz(3),...
                %                             taskParam.gParam.concentration(1),...
                %                             cannon, condition, LoadData, reversalPackage);
                % added this (02.01.17) to get rid of practLoop
                %[taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(1), taskParam.gParam.concentration(3));
                % ---------

                if isequal(condition, 'reversalPractice')
                    taskParam.gParam.practTrials = taskParam.gParam.practTrials; 
                    trial = taskParam.gParam.practTrials;
                else
                    taskParam.gParam.practTrials = taskParam.gParam.practTrials; 
                    trial = taskParam.gParam.practTrials; 
                    %trial = taskParam.gParam.trials;
                end
                
                %taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
                taskData = al_generateOutcomesReversal(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition);
                % -----------
                [~, practData] =  al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
                
                %                 if leaveLoop
                %
                %                     header = 'Try it one more time!';
                %                     txt = ['In this case you updated your tickmark '...
                %                         'although the cannon did not change its aim. '...
                %                         'In the next round try to hold off for '...
                %                         'the tickmark while the cannon does not change.'];
                %
                %                     feedback = false;
                %                     fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                %                     screenIndex = 5;
                %                     if fw == 1
                %                         screenIndex = screenIndex + 1;
                %                     elseif bw == 1
                %                         screenIndex = screenIndex - 2;
                %                     end
                %
                %                 else
                
                txt=['In this case the cannon reaimed to its '...
                    'previous position. You can use your saved '...
                    'tickmark to inform your prediction and to '...
                    'avoid recalibrating your shield again.\n'...
                    'Before you indicate your prediction you '...
                    'should update your tickmark. Move the '...
                    'mouse to your last prediction (orange '...
                    'tickmark) and hit the right mouse button. '...
                    'Then indicate your prediction.'];
                
                distMean = practData.distMean(end);
                outcome = practData.outcome(end);
                tickInstructions.savedTickmark = practData.savedTickmark(end);
                tickInstructions.previousOutcome = outcome;
                tickInstructions.previousPrediction = practData.pred(end);
                [taskParam, fw, Data, savedTickmark] = al_instrLoopTxt(taskParam, txt, cannon, 'space', distMean, tickInstructions);
                
                tickDev = abs(tickInstructions.savedTickmark - Data.pred);
                updatedTickDev = abs(practData.pred(end-1) - savedTickmark);
                al_drawCross(taskParam);
                al_lineAndBack(taskParam)
                al_drawCross(taskParam)
                al_drawCircle(taskParam)
                Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
                Screen('Flip', taskParam.gParam.window.onScreen, t + 2.1, 1);
                WaitSecs(1);
                
                al_drawCross(taskParam);
                al_lineAndBack(taskParam)
                al_drawCross(taskParam)
                al_drawCircle(taskParam)
                al_drawOutcome(taskParam, outcome)
                al_predictionSpot(taskParam);
                Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
                Screen('Flip', taskParam.gParam.window.onScreen, t + 3.1, 1);
                WaitSecs(0.5);
                
                al_drawCross(taskParam);
                al_lineAndBack(taskParam)
                al_drawCross(taskParam)
                al_drawCircle(taskParam)
                Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
                Screen('Flip', taskParam.gParam.window.onScreen, t + 2.1, 1);
                WaitSecs(1);
                
                al_drawCross(taskParam);
                al_lineAndBack(taskParam)
                al_drawCross(taskParam)
                al_drawCircle(taskParam)
                al_shield(taskParam, 20, Data.pred, 1)
                al_drawOutcome(taskParam, outcome)
                Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
                Screen('Flip', taskParam.gParam.window.onScreen, t + 3.1, 1);
                WaitSecs(1);
                
            end
            %end
            
        case 7
            
            %             if tickDev <= 10 && updatedTickDev <= 10 && ~isnan(updatedTickDev)
            %                 header = '';
            %                 txt = ['Well done! In this block you can practice '...
            %                     'the task with an invisible cannon. Keep in '...
            %                     'mind that the cannon occasionally reaims to '...
            %                     'its previous position. Use the red tickmark '...
            %                     'to mark the previous aim of the cannon.'];
            %
            %                 feedback = false;
            %                 fw = al_bigScreen(taskParam,...
            %                     taskParam.strings.txtPressEnter, header, txt, feedback);
            %                 if fw == 1
            %                     screenIndex = screenIndex + 1;
            %                 elseif bw == 1
            %                     screenIndex = screenIndex - 2;
            %                 end
            %             elseif tickDev > 10
            %
            %                 header = 'Try again!';
            %                 txt = ['In this case you did not use the information '...
            %                     'of the tickmark for your current prediction. '...
            %                     'Keep in mind to use the tickmark '...
            %                     'this time!.'];
            %
            %                 feedback = false;
            %                 fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            %
            %                 if fw == 1
            %                     screenIndex = screenIndex - 1;
            %
            %                 end
            %
            %             elseif updatedTickDev > 10 || isnan(updatedTickDev)
            %
            %                 header = 'Try again!';
            %                 txt = ['In this case you did not correctly update your '...
            %                     'tickmark after the cannon reaimed. Keep '...
            %                     'in mind to use the tickmark this time!'];
            %
            %                 feedback = false;
            %                 fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            %
            %                 if fw == 1
            %                     screenIndex = screenIndex - 1;
            %
            %                 end
            %
            %             end
            %
            screenIndex = screenIndex + 1; 
            WaitSecs(0.1);
            
        case 8
            
            condition = 'reversalPracticeNoiseInv2';
            LoadData = 'reversalNotVisibleNoise';
            
            cannon = false;
            savedTickmark = nan;
            
            %                     [taskParam, practData] = practLoop(taskParam,...
            %                         subject, taskParam.gParam.haz(1),...
            %                         taskParam.gParam.concentration(1),...
            %                         cannon, condition, LoadData);
            % added this (02.01.17) to get rid of practLoop
            %[taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(1), taskParam.gParam.concentration(3)); 
            % ----
            

            if isequal(condition, 'reversalPractice')
                taskParam.gParam.practTrials = taskParam.gParam.practTrials; 
                trial = taskParam.gParam.practTrials;
            else
                taskParam.gParam.practTrials = taskParam.gParam.practTrials; 
                trial = taskParam.gParam.practTrials;  
                %trial = taskParam.gParam.trials;
            end
            %taskData = al_generateOutcomes(taskParam, haz, concentration, condition);
            taskData = al_generateOutcomesReversal(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition);
            % --
            [~, practData] =  al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
            
            [txt, header] = al_feedback(practData, taskParam, subject, condition);
            feedback = true;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            sumCannonDev = sum(abs(practData.cannonDev) >= 10);
            
            
            if fw == 1
                screenIndex = screenIndex + 1;
            end
            WaitSecs(0.1);
            
        case 9

            %             if isnan(practData.savedTickmark)
            %
            %                 header = 'Try it again!';
            %                 txt = ['In that block you have never used '...
            %                     'your tickmark. Remember: Placing '...
            %                     'your tickmark where the cannon was '...
            %                     'previously aimed will be the '...
            %                     'best way to catch cannonballs. Now try again.' ];
            %
            %                 feedback = false;
            %                 fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header,txt, feedback);
            %                 if fw == 1
            %                     screenIndex = screenIndex - 1;
            %                 elseif bw == 1
            %                     screenIndex = screenIndex - 2;
            %                 end
            %             else
            header = 'Fourth Practice';
            txt = ['Now comes the last practice block. In this '...
                'block of trials the cannon will not always '...
                'reaim to its previous target, but will '...
                'occasionally aim at a new location on the '...
                'circle. You can still use the red tickmark to '...
                'mark the previous aim of the cannon. '...
                'That is, if you realize that the cannon '...
                'changed its aim you have to decide whether '...
                'it reaimed to the previous location or '...
                'whether it is aiming at a new location.'];
            
            feedback = false;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 2;
            end
            
            WaitSecs(0.1);
            %end
            
        case 10
            
            break
            
    end
end


end