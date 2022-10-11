function oddballPractice(taskParam, subject)
%ODDBALLPRACTICE   This function runs the practice session for the oddball condition
%
%   Input
%       ~
%
%   Output
%       ~


screenIndex = 1;

while 1
    
    switch(screenIndex)
        
        case 1
            
            header = 'First Practice';
            txt = ['In this block of trials you will try to '...
                'catch balls shot from a cannon. The aim of '...
                'the cannon will not be stationary but instead '...
                'move unpredictably.'];
            
            feedback = false;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            WaitSecs(0.1);
            
        case 2
            
            condition = 'practiceNoOddball';
            %LoadData = 'NoNoise';
            %LoadData = 'None';
            
            %                     [taskParam, practData] = practLoop(taskParam,...
            %                         subject, taskParam.gParam.haz(3),...
            %                         taskParam.gParam.concentration(3),...
            %                         cannon, condition, LoadData);
            % added this (02.01.17) to get rid of practLoop
            %[taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(3), taskParam.gParam.concentration(3));
            % ---------------
            trial = taskParam.gParam.trials;
            taskData = al_generateOutcomesMain(taskParam, taskParam.gParam.haz(3), taskParam.gParam.concentration(3), condition);
            % ---------------
            [~, practData] = al_mainLoop(taskParam, taskParam.gParam.haz(3), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
            %Data, taskParam, subject, condition, whichBlock
            [txt, header] = al_feedback(practData, taskParam, subject, condition);
            feedback = true;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt,feedback);
            sumCannonDev = sum(practData.cannonDev >= 10);
            if fw == 1
                if isequal(taskParam.gParam.taskType, 'oddball') && subject.cBal == 2
                    screenIndex = screenIndex + 1;
                else
                    screenIndex = screenIndex + 1;
                end
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            WaitSecs(0.1);
            
        case 3
            if sumCannonDev >= 4
                
                header = 'Try it again!';
                txt = ['In that block your shield was not '...
                    'always placed where the cannon was '...
                    'aiming. Remember: Placing your shield '...
                    'where the cannon is aimed will be the '...
                    'best way to catch cannonballs. Now try again. '];
                
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                if fw == 1
                    screenIndex = screenIndex - 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
            else

                header = 'Second Practice';
                
                txt = ['On some trials the ball will be fired '...
                    'from a different cannon that you cannot '...
                    'see. When this occurs the ball is equally '...
                    'likely to land at any location on the '...
                    'circle. However, these trials will be '...
                    'quite rare so your best strategy is still '...
                    'to place the shield where the cannon is '...
                    'aimed.\n\nPress Enter to see an example '...
                    'of this.'];
                %end
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header,txt, feedback);
                if fw == 1
                    screenIndex = screenIndex + 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
                
            end
            WaitSecs(0.1);
            
        case 4
            txt=['Move the orange spot to the part of the '...
                'circle, where the cannon is aimed and press '...
                'SPACE.'];
            
            distMean = 290;
            outcome = 170;
            cannon = true;
            button = 'arrow';
            tickInstruction = struct();
            tickInstruction.savedTickmark = nan;
            Data = struct();
            Data.distMean = distMean;
            Data.outcome = outcome; 
            Data.tickMark = false;
            [taskParam, fw, Data, savedTickmark] =  al_instrLoopTxt(taskParam, txt, cannon, button, distMean, tickInstruction);  
            %[taskParam, fw, Data, savedTickmark] = al_instrLoopTxt(taskParam, txt, cannon, button, distMean)
            %[taskParam, fw, bw, Data] = al_instrLoopTxt(taskParam, txt, cannon, 'space', distMean);
            al_lineAndBack(taskParam)
            al_drawCircle(taskParam);
            al_drawCross(taskParam);
            al_predictionSpot(taskParam);
            al_drawOutcome(taskParam, outcome);
            al_drawCannon(taskParam, distMean)

            
             
            Screen('DrawingFinished', taskParam.gParam.window.onScreen);
            t = GetSecs;
            Screen('Flip', taskParam.gParam.window.onScreen, t + 0.1);
            % Show baseline 1.
            al_lineAndBack(taskParam)
            al_drawCross(taskParam)
            al_drawCircle(taskParam)
            Screen('DrawingFinished', taskParam.gParam.window.onScreen, 1);
            Screen('Flip', taskParam.gParam.window.onScreen, t + 0.6, 1);
            while 1
                txt=['In this case the cannonball was shot '...
                    'from a different cannon that you cannot '...
                    'see. Keep in mind that these trials will '...
                    'be quite rare so your best strategy is to '...
                    'place your shield where the cannon that '...
                    'you can see is aimed. \nPress enter to '...
                    'start the practice block.'];
                al_lineAndBack(taskParam)
                al_drawCannon(taskParam, distMean)
                al_drawCircle(taskParam)
                if subject.rew == 1
                    al_shield(taskParam, 20, Data.pred, 1)
                elseif subject.rew == 2
                    al_shield(taskParam, 20, Data.pred, 0)
                end
                al_drawOutcome(taskParam, outcome)
                DrawFormattedText(taskParam.gParam.window.onScreen,txt, taskParam.gParam.screensize(3)*0.1, taskParam.gParam.screensize(4)*0.05, [255 255 255], taskParam.gParam.sentenceLength);
                DrawFormattedText(taskParam.gParam.window.onScreen, taskParam.strings.txtPressEnter,'center', taskParam.gParam.screensize(4)*0.9, [255 255 255]);
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
            %condition = 'practiceOddball';
            condition = 'oddballPractice_1';

            LoadData = 'NoNoise';
            %                     [taskParam, practData] = practLoop...
            %                         (taskParam, subject, taskParam.gParam.haz(3),...
            %                         taskParam.gParam.concentration(3), cannon,...
            %                         condition, LoadData);
            % added this (02.01.17) to get rid of practLoop
            %[taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(1), taskParam.gParam.concentration(3));
            % ----
            
            taskData = load('OddballNoNoise');
            taskData = taskData.practData;
            trial = taskParam.gParam.practTrials;
            taskData.cBal = nan(trial,1);
            taskData.rew = nan(trial,1);
            taskData.initiationRTs = nan(trial,1);
            taskData.initialTendency = nan(trial,1);
            taskData.actJitter = nan(trial,1);
            taskData.block = ones(trial,1);
            taskData.savedTickmark(1) = nan;
            taskData.reversal = nan(length(trial),1);
            taskData.currentContext = nan(length(trial),1);
            taskData.hiddenContext = nan(length(trial),1);
            taskData.contextTypes = nan(length(trial),1);
            taskData.latentState = nan(length(trial),1);
            taskData.RT = nan(length(trial),1);
            taskData.critical_trial = nan(length(trial),1);

            taskData.cBal = nan(trial,1);
            taskData.rew = nan(trial,1);
            taskData.initiationRTs = nan(trial,1);
            taskData.block = ones(trial,1);
            taskData.reversal = nan(length(trial),1);
            taskData.savedTickmark = nan(length(trial),1);
            taskData.initialTendency = nan(trial,1);
        % ----
            [~, practData] =  al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
            
            %[txt, header] = al_feedback(practData, taskParam, subject, condition);
            [txt, header] = al_feedback(practData, taskParam, subject, condition);
            feedback = true;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            
            WaitSecs(0.1);
            
        case 5
            sumCannonDev = sum(practData.cannonDev >= 10);
            if sumCannonDev >= 4
                
                header = 'Wiederholung der Übung';
                if isequal(taskParam.gParam.taskType, 'dresden')
                    txt = ['In der letzten Übung hast du dich '...
                        'zu häufig vom Ziel der Kanone '...
                        'wegbewegt. Du kannst mehr Kugeln '...
                        'fangen, wenn du immer auf dem Ziel '...
                        'der Kanone bleibst!\n\nIn der '...
                        'nächsten Runde kannst nochmal Üben. '...
                        'Wenn du noch Fragen hast, kannst du '...
                        'dich auch an den Versuchsleiter wenden.'];
                elseif isequal(taskParam.gParam.taskType,'oddball')
                    header = 'Try it again!';
                    txt = ['In that block your shield was not '...
                        'always placed where the cannon was '...
                        'aiming. Remember: Placing your shield '...
                        'where the cannon is aimed will be the '...
                        'best way to catch cannonballs. Now try '...
                        'again.'];
                end
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header,txt, feedback);
                if fw == 1
                    screenIndex = screenIndex - 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
            else
                screenIndex = screenIndex + 1;
            end
            
            WaitSecs(0.1);
        case 6
            
            header = 'Third Practice';
            
            txt = ['In this block you will encounter a cannon '...
                'that is not perfectly accurate. On some '...
                'trials it might shoot a bit above where it is '...
                'aimed and on other trials a bit below. '...
                'Your best strategy is still to place the '...
                'shield in the location where the cannon is '...
                'aimed.\n\nThe cannon will still move '...
                'unpredictably and balls will still '...
                'occasionally be shot by another randomly '...
                'aimed cannon.'];
            feedback = false;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 3;
            end
            
            WaitSecs(0.1);
        case 7
            
            if isequal(taskParam.gParam.taskType, 'dresden')
                %LoadOddballPracticeNoNoise = true;
                
                %                         [taskParam, practData] = practLoop(taskParam,...
                %                             subject, taskParam.gParam.haz(1),...
                %                             taskParam.gParam.concentration(1),...
                %                             cannon, condition, LoadOddballPracticeNoNoise);
                % added this (02.01.17) to get rid of practLoop
                [taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(1), taskParam.gParam.concentration(3));
                [taskParam, practData] =  al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
            elseif isequal(taskParam.gParam.taskType, 'oddball')
                %condition = 'practiceOddball';
                condition = 'oddballPractice_2';  %
                %LoadData = 'Noise';
                %                         [taskParam, practData] = practLoop...
                %                             (taskParam, subject,...
                %                             taskParam.gParam.haz(3),...
                %                             taskParam.gParam.concentration(1),...
                %                             cannon, condition, LoadData);
                % added this (02.01.17) to get rid of practLoop
                %[taskParam, practData] =  al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject);
                %[taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(1), taskParam.gParam.concentration(3));
                % ---
                taskData = load('OddballNoise');
                taskData = taskData.practData;
                trial = taskParam.gParam.practTrials;

                taskData.cBal = nan(trial,1);
                taskData.rew = nan(trial,1);
                taskData.initiationRTs = nan(trial,1);
                taskData.initialTendency = nan(trial,1);
                taskData.actJitter = nan(trial,1);
                taskData.block = ones(trial,1);
                taskData.savedTickmark(1) = nan;
                taskData.reversal = nan(length(trial),1);
                taskData.currentContext = nan(length(trial),1);
                taskData.hiddenContext = nan(length(trial),1);
                taskData.contextTypes = nan(length(trial),1);
                taskData.latentState = nan(length(trial),1);
                taskData.RT = nan(length(trial),1);
                taskData.critical_trial = nan(length(trial),1);
                % ---------------------
                [~, practData] =  al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
            end
            
            [txt, header] = al_feedback(practData, taskParam, subject, condition);
            
            
            feedback = true;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            WaitSecs(0.1);
        case 8
            sumCannonDev = sum(practData.cannonDev >= 10);
            if sumCannonDev >= 4
                
                header = 'Try it again!';
                txt = ['In that block your shield was not '...
                    'always placed where the cannon was '...
                    'aiming. Remember: Placing your shield '...
                    'where the cannon is aimed will be the '...
                    'best way to catch cannonballs. Now try again.'];
                
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header,txt, feedback);
                if fw == 1
                    screenIndex = screenIndex - 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
            else
                screenIndex = screenIndex + 1;
            end
            
            WaitSecs(0.1);
        case 9
            
            header = 'Fourth Practice';
            txt = ['In this block everything will be '...
                'exactly the same except that you will no '...
                'longer see the cannon. The cannon is still '...
                'aiming and shooting exactly as before. You '...
                'will be paid for catching balls exactly as '...
                'before. But now you must place your shield '...
                'at the position where you think the cannon '...
                'is aimed.\n\nSince you will still see each '...
                'ball shot from the cannon, you will be able '...
                'to use the locations of past shots to inform '...
                'your decision.'];
            
            % end
            feedback = false;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
                
            elseif bw == 1
                screenIndex = screenIndex - 3;
            end
            
            WaitSecs(0.1);
        case 10
            break
    end
end
end