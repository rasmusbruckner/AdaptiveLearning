classdef al_dresden_conditions
    
    % This class definition file specifies the properties and methods of an
    % object for the cannon task conditions
    
    % Properties of the conditions object
    % -----------------------------------
    properties
        
        runIntro
        unitTest
        taskType
        cBal
        concentration
        haz
        testDay
        txtPressEnter
        showTickmark
        DataMain
        DataFollowOutcome
        DataFollowCannon
        Data
        DataChineseCued
        DataChineseMain
        perfMain
        perfCued
        
    end
    
    % Methods of the conditions object
    % --------------------------------
    methods
        
        function condobj = al_dresden_conditions(cond_init)
            % AL_CONDITIONS creates a conditions object of class condobj
            % This is based on the initialization input structure
            %
            %   Input
            %       cond_init: structure with condition initialization
            %
            %   Output
            %       condobj: task object with initialized values
            
            % Set variable task properties based on input structure
            condobj.runIntro = cond_init.runIntro;
            condobj.unitTest = cond_init.unitTest;
            condobj.taskType = cond_init.taskType;
            condobj.cBal = cond_init.cBal;
            condobj.concentration = cond_init.concentration;
            condobj.haz = cond_init.haz;
            %condobj.testDay = cond_init.testDay;
            condobj.txtPressEnter = cond_init.txtPressEnter;
            condobj.showTickmark = cond_init.showTickmark;
            condobj.perfMain = 0;
            condobj.perfCued = 0;
        end
        
        
        function condobj = MainCondition(condobj, taskParam, subject)
            %MAINCONDITION   Runs the change point condition of the cannon task
            %
            %   Input
            %       condobj: task object with initialized values
            %       taskParam: structure containing task paramters
            %       subject: structure containing subject information
            %
            %   Output
            %       condobj: task object with initialized values
            
            % Display instructions after practice session
            if condobj.runIntro && ~condobj.unitTest
                
               % switch condobj.taskType
                    
                   % case 'dresden'
                        % This has not been adjusted in a long time
                        % and has to be slightly updated
                        
                        % "Du" for younger adults
                        if isequal(subject.group, '1')
                            txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz zusammengefasst wehrst du also die meisten Kugeln ab, '...
                                'wenn du den orangenen Punkt auf die Stelle bewegst, auf die die Kanone zielt. Weil du die Kanone meistens nicht mehr '...
                                'sehen kannst, musst du diese Stelle aufgrund der Position der letzten Kugeln einschätzen. Das Geld für die abgewehrten '...
                                'Kugeln bekommst du nach der Studie ausgezahlt.\n\nViel Erfolg!'];
                            
                            % "Sie" for older adults
                        else
                            txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst wehren Sie also die meisten Kugeln ab, '...
                                'wenn Sie den orangenen Punkt auf die Stelle bewegen, auf die die Kanone zielt. Weil Sie die Kanone meistens nicht mehr '...
                                'sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Kugeln einschätzen. Das Geld für die abgewehrten '...
                                'Kugeln bekommen Sie nach der Studie ausgezahlt.\n\nViel Erfolg!'];
                        end
                        
                        % Indicate beginning of main task
                        %al_instructions(taskParam, 'mainPractice', subject);
                        whichPractice = 'mainPractice';
                        al_dresdenInstructions(taskParam, subject, true, whichPractice);

                        
                       
                        %[taskData, trial] = al_loadTaskData(taskParam, 'mainPractice_3', condobj.haz(3), condobj.concentration(1)); 
                        % ------------------------
                        taskData = load('pract3');
                        taskData = taskData.taskData;
                        taskData.critical_trial = nan;
                        trial = taskParam.gParam.practTrials;
                        % ------------------------------------
                        al_mainLoop(taskParam, condobj.haz(3), condobj.concentration(1), 'mainPractice_3', subject, taskData, trial);
                        feedback = false;
                        %al_bigScreen(taskParam, condobj.txtPressEnter, condobj.header, txtStartTask, feedback);
                        al_bigScreen(taskParam, condobj.txtPressEnter, 'Erste Aufgabe...', txtStartTask, feedback);
                        

%                     case 'oddball'
%                         % This has not been adjusted for a long time
%                         % and has to be slightly updated
%                         
%                         if isequal(subject.session, '1')
%                             header = 'Change Point Task';
%                             txt = ['This is the beginning of the CHANGE POINT TASK. During this block you will earn real money for your performance. The trials will be exactly '...
%                                 'the same as those in the previous session.\n\n On each trial a cannon will aim at a location on the circle. On all trials the cannon will '...
%                                 'fire a ball somewhere near the point of aim. Most of the time the cannon will remain aimed at the same location, but occasionally the cannon '...
%                                 'will be reaimed. Like in the previous session you will not see the cannon, but still have to infer its aim in order to catch balls and '...
%                                 'earn money.'];
%                             feedback = false;
%                             al_bigScreen(taskParam, condobj.txtPressEnter, header, txt, feedback);
%                             
%                         elseif isequal(subject.session, '2') ||...
%                                 isequal(subject.session, '3')
%                             
%                             Screen('TextSize', taskParam.gParam.window, 30);
%                             Screen('TextFont', taskParam.gParam.window, 'Arial');
%                             VolaIndication(taskParam, condobj.txtStartTask, condobj.txtPressEnter)
%                             
%                         end
%                         
%                     case 'ARC'
%                         
%                         if strcmp(subject.session,'1')
%                             
%                             if condobj.testDay == 1
%                                 al_instructions(taskParam, 'mainPractice', subject)
%                             elseif condobj.testDay == 2
%                                 
%                                 % Text settings
%                                 Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');
%                                 Screen('TextSize', taskParam.gParam.window.onScreen, 50);
%                                 header = 'Day 2: Practice Session';
%                                 if ~condobj.showTickmark
%                                     txtStartTask = ['Welcome to the second part of the experiment. As yesterday, you will start with a practice session. On each '...
%                                         'trial a cannon will aim at a location on the circle. On all trials the cannon will fire a ball somewhere near the point of '...
%                                         'aim. Most of the time the cannon will remain aimed at the same location, but occasionally the cannon will be reaimed. '...
%                                         'You will not see the cannon, but have to infer its aim in order to catch balls and earn money.\n\nHowever, this time you '...
%                                         'will no longer see the orange and the black line that marked the location of the previous orange spot and the previous position of the ball.'];
%                                 elseif condobj.showTickmark
%                                     txtStartTask = ['Welcome to the second part of the experiment. As yesterday, you will start with a practice session. On each '...
%                                         'trial a cannon will aim at a location on the circle. On all trials the cannon will fire a ball somewhere near the point of '...
%                                         'aim. Most of the time the cannon will remain aimed at the same location, but occasionally the cannon will be reaimed. '...
%                                         'You will not see the cannon, but have to infer its aim in order to catch balls and earn money.\n\nHowever, this time the '...
%                                         'location of the ball fired on the previous trial will be marked with a black line.\n\nMoreover, the location of the orange spot from the '...
%                                         'previous trial will be marked with an orange line.'];
%                                 end
%                                 
%                                 feedback = false;
%                                 al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%                             end
%                             
%                             if condobj.cBal == 1 || condobj.cBal == 3
%                                 
%                                 % Experimental blocks
%                                 header = 'Third Practice';
%                                 txtStartTask = ['This is the last practice session. Here you will less frequently see the cannon. \n\n'...
%                                     'Like in the previous session you should try to place your shield at the (hidden) aim of the cannon. '];
%                                 
%                                 feedback = false;
%                                 al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%                                 ARC_indicateCondition('lowNoise', taskParam, condobj.txtPressEnter)
%                                 al_mainLoop(taskParam, condobj.haz(3), condobj.concentration(1), 'mainPractice_3', subject);
%                                 
%                                 ARC_indicateCondition('highNoise', taskParam, condobj.txtPressEnter)
%                                 al_mainLoop(taskParam, condobj.haz(3), condobj.concentration(2), 'mainPractice_4', subject);
%                                 
%                             elseif condobj.cBal == 2 || condobj.cBal == 4
%                                 
%                                 ARC_indicateCondition('highNoise', taskParam, condobj.txtPressEnter)
%                                 al_mainLoop(taskParam, condobj.haz(3), Zconcentration(2), 'mainPractice_4', subject);
%                                 
%                                 ARC_indicateCondition('lowNoise', taskParam, condobj.txtPressEnter)
%                                 al_mainLoop(taskParam, condobj.haz(3), condobj.concentration(1), 'mainPractice_3', subject);
%                             end
%                             
%                             % Experimental blocks
%                             header = 'Beginning of the experiment';
%                             txtStartTask = ['This is the beginning of the experiment. The trials will be exactly '...
%                                 'the same as those in the previous session.\n\n On each trial a cannon will aim at a location on '...
%                                 'the circle. On all trials the cannon will fire a ball somewhere near the point of aim. '...
%                                 'Most of the time the cannon will remain aimed at the same location, but occasionally the cannon '...
%                                 'will be reaimed. Like in the previous session you will only rarely see the cannon and '...
%                                 'you should still try to infer its aim in order to catch the cannonballs.'];
%                             
%                             feedback = false;
%                             al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%                             
%                             if condobj.cBal == 1 || condobj.cBal == 3
%                                 
%                                 ARC_indicateCondition('lowNoise', taskParam, condobj.txtPressEnter)
%                                 
%                             elseif condobj.cBal == 2 || condobj.cBal == 4
%                                 
%                                 ARC_indicateCondition('highNoise', taskParam, condobj.txtPressEnter)
%                                 
%                             end
%                             
%                         elseif strcmp(subject.session,'2')
%                             
%                             if  condobj.cBal == 1 || condobj.cBal == 3
%                                 
%                                 ARC_indicateCondition('highNoise', taskParam, condobj.txtPressEnter)
%                                 
%                             elseif condobj.cBal == 2 || condobj.cBal == 4
%                                 
%                                 ARC_indicateCondition('lowNoise', taskParam, condobj.txtPressEnter)
%                                 
%                             end
%                         end
                %end
            end
            
%             if (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 1 && strcmp(subject.session, '1'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 3 && strcmp(subject.session, '1'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 2 && strcmp(subject.session, '2'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 4 && strcmp(subject.session, '2'))...
%                     || (strcmp(condobj.taskType, 'dresden'))
                
                currentConcentration = condobj.concentration(1);
                
%             elseif (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 1 && strcmp(subject.session, '2'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 3 && strcmp(subject.session, '2'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 2 && strcmp(subject.session, '1'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 4 && strcmp(subject.session, '1'))
%                 
%                 currentConcentration = condobj.concentration(2);
%             end
                        %[taskData, trial] = al_loadTaskData(taskParam, 'main', condobj.haz(1), currentConcentration);
            trial = taskParam.gParam.trials;
            taskData = al_generateOutcomesMain(taskParam, condobj.haz(1), currentConcentration, 'main');
            [~, condobj.DataMain] = al_mainLoop(taskParam, condobj.haz(1), currentConcentration, 'main', subject, taskData, trial);
            
%             function ARC_indicateCondition(condition, taskParam, txtPressEnter)
%                 % ARC_CONTROLCONDITION
%                 %
%                 %   Input
%                 %       condition: noise condition type
%                 %       taskParam: structure containing task paramters
%                 %       txtPressEnter: text that is presented to indicate that subject should press "Enter"
%                 %
%                 %   Output
%                 %       ~
%                 
%                 if strcmp(condition, 'lowNoise')
%                     header_ind = 'More accurate cannon';
%                     txtStartTask_ind = 'In this block of trials the cannon will be relatively accurate.';
%                     
%                 elseif strcmp(condition, 'highNoise')
%                     header_ind = 'Less accurate cannon';
%                     txtStartTask_ind = 'In this block of trials the cannon will be less accurate.';
%                 end
%                 
%                 al_bigScreen(taskParam, txtPressEnter, header_ind, txtStartTask_ind, false);
%                 
%             end
        end
%         
%         function condobj = ARC_ControlCondition(condobj, c_condition, taskParam, subject, ~)
%             % ARC_CONTROLCONDITION
%             %
%             %   Input
%             %       condobj: task object with initialized values
%             %       c_condition: control condition type
%             %       taskParam: structure containing task paramters
%             %       subject: structure containing information about subject
%             %   Output
%             %       condobj: task object with initialized values
%             
%             if condobj.testDay == 1
%                 daySpecificInstruction = 'Before you start the real experiment,';
%             elseif condobj.testDay == 2
%                 daySpecificInstruction = 'As yesterday,';
%             end
%             
%             if isequal(c_condition, 'ARC_controlSpeed')
%                 header = 'Speed Task';
%                 controlInstructions = '......Owen, please fill in the "speed instructions"';
%             elseif isequal(c_condition, 'ARC_controlAccuracy')
%                 header = 'Accuracy Task';
%                 controlInstructions = '......Owen, please fill in the "accuracy instructions"';
%             end
%             
%             txtStartTask = sprintf('%s we ask you to %s', daySpecificInstruction, controlInstructions);
%             
%             feedback = false;
%             al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%             
%             condition = 'ARC_controlPractice';
%             taskParam.gParam.showTickmark = false;
%             [~, ~] =  al_mainLoop(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition, subject);
%             
%             condition = c_condition;
%             if isequal(condition, 'ARC_controlSpeed')
%                 txtStartTask = 'This is the beginning of the Speed task. AGAIN, MAYBE SOME MORE INSTRUCTIONS';
%             elseif isequal(condition, 'ARC_controlAccuracy')
%                 txtStartTask = 'This is the beginning of the Accuracy task. AGAIN, MAYBE SOME MORE INSTRUCTIONS';
%             end
%             
%             feedback = false;
%             al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%             
%             taskParam.gParam.showTickmark = false;
%             [~, condobj.Data] =  al_mainLoop(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition, subject);
%             
%             if isequal(condition, 'ARC_controlSpeed')
%                 
%                 taskIndex = 'speed task';
%                 
%             elseif isequal(condition, 'ARC_controlAccuracy')
%                 
%                 taskIndex = 'accuracy task';
%                 
%             end
%             feedback = false;
%             txtStartTask = sprintf('This is the end of the %s.', taskIndex);
%             al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%             
%             % Depending on cbal, turn tickmark on again
%             taskParam.gParam.showTickmark = condobj.showTickmark;
%             
%         end
%         
%         function condobj = ChineseCondition(condobj, taskParam, subject)
%             %CHINESECONDITION   Runs the chinese condition of the cannon task
%             %
%             %   Input
%             %       condobj: task object with initialized values
%             %       taskParam: structure containing task paramters
%             %       subject: structure containing information about subject
%             %   Output
%             %       condobj: task object with initialized values
%             
%             if condobj.runIntro && ~condobj.unitTest
%                 
%                 al_instructions(taskParam, 'chinese', subject);
%                 taskParam.gParam.showCue = false;
%                 condobj.Data = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'chinesePractice_4', subject);
%                 if taskParam.gParam.language == 1
%                     header = 'Anfang der Aufgabe';
%                     txtStartTask = ['Du hast die Übungsphase abgeschlossen. Du kannst jetzt echtes Geld in Abhängigkeit von deiner Leistung verdienen. Jeder Aufgabendurchgang läuft genau '...
%                         'so ab, wie du es vorher in der Übung gelernt hast.\n\nDeine Aufgabe ist es, deine Planeten vor den Kanongenkugeln zweier Gegner zu beschützen, indem du sie mit deinem Schild '...
%                         'abwehrst. Dabei hat jeder Gegner auf jeden deiner Planeten genau eine Kanone gerichtet. Die Positionen der Kanonen bleiben während eines Aufgabenblocks gleich. '...
%                         'Die Planeten werden immer nur von einem Gegner zurzeit beschossen.\n\nDie Kanonen sind unsichtbar. Deshalb solltest du dir merken auf welche Stelle der jeweilige '...
%                         'Gegner auf dem jeweiligen Planeten seine Kanone gerichtet hat. Du kannst dann bei einem Wechsel des Gegners oder des Planeten dein Schild direkt '...
%                         'an dieser Stelle positionieren.\n\nWenn du noch Fragen hast, wende dich bitte jetzt an den Versuchsleiter.'];
%                 elseif taskParam.gParam.language == 2
%                     header = 'Beginning of the Task';
%                     txtStartTask = ['You have finished the practice trials!\n\n'...
%                         'You can now earn real money, depending on your performance on the task.\n\n'...
%                         'Each trial will be exactly the same as you have just learned.\n\n'...
%                         'Your task is to shield your planet from the cannons of two enemies, by catching their cannonballs.\n\n'...
%                         'Each enemy will have one cannon targeting each of your planets.\n\n'...
%                         'The position of the cannons will stay the same within a trial block.\n\n'...
%                         'Each planet will only be shot by one enemy at a time.\n\n'...
%                         'The cannons are invisible, so you should try to remember each spot that each enemy is targeting on each planet.\n\n'...
%                         'If the planet or enemy changes, try to position your shield on the right spot.\n\n'...
%                         'In this block of trials, the enemy which is currently firing will be shown above your planet.'...
%                         'If you have any questions, please ask the experimenter.'];
%                 end
%                 feedback = false;
%                 al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%             end
%             
%             % todo: check if data are saved after each block
%             % for b = 1:taskParam.gParam.nb
%             
%             % Add block number to subject info to indicate that blocks
%             % > 1 should use outcome contingenices of first block (if useSameMapping = True)
%             %subject.blockNumber = b;
%             
%             if condobj.cBal == 1
%                 
%                 % todo: check if data are saved after each block
%                 for b = 1:taskParam.gParam.nb
%                     
%                     % Run "cued" condition
%                     taskParam.gParam.showCue = true;
%                     if b == 1 || ~isequal(taskParam.gParam.useTrialConstraints, 'aging') % taskParam.gParam.useSameMapping == false
%                         [taskDataCued, condobj.DataChineseCued] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'chinese', subject);
%                     else
%                         % Update block number in taskData
%                         taskDataCued.block(:) = b;
%                         [~, condobj.DataChineseCued] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'chinese', subject, taskDataCued);
%                     end
%                     condobj.perfCued = condobj.perfCued + condobj.DataChineseCued.accPerf(end);
% 
%                 end
%                 if taskParam.gParam.language == 1
%                     header = 'Anfang der Aufgabe';
%                     txtStartTask = 'Deutsch';
%                 elseif taskParam.gParam.language == 2
%                     header = 'Next round';
%                     txtStartTask = ['In this block of trials, you will no longer see which enemy is firing! '...
%                         'Everything else will be exactly the same. If you have any questions, please ask the experimenter.'];
%                 end
%                 
%                 feedback = false;
%                 al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%                 
%                 % todo: check if data are saved after each block
%                 for b = 1:taskParam.gParam.nb
%                     % Run "uncued" condition
%                     taskParam.gParam.showCue = false;
%                     if b == 1 || ~isequal(taskParam.gParam.useTrialConstraints, 'aging') %taskParam.gParam.useSameMapping == false
%                         [taskDataUncued, condobj.DataChineseMain] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'chinese', subject);
%                     else
%                         % Update block number in taskData
%                         taskDataUncued.block(:) = b;
%                         [~, condobj.DataChineseMain] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'chinese', subject, taskDataUncued);
%                     end
%                     condobj.perfMain = condobj.perfMain + condobj.DataChineseMain.accPerf(end);
% 
%                 end
%             elseif condobj.cBal == 2
%                 
%                 % todo: check if data are saved after each block
%                 for b = 1:taskParam.gParam.nb
%                     % Run "uncued" condition
%                     taskParam.gParam.showCue = false;
%                     if b == 1 || ~isequal(taskParam.gParam.useTrialConstraints, 'aging')
%                         [taskDataUncued, condobj.DataChineseMain] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'chinese', subject);
%                     else
%                         % Update block number in taskData
%                         taskDataUncued.block(:) = b;
%                         [~, condobj.DataChineseMain] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'chinese', subject, taskDataUncued);
%                     end
%                     condobj.perfMain = condobj.perfMain + condobj.DataChineseMain.accPerf(end);
% 
%                 end
%                 
%                 if taskParam.gParam.language == 1
%                     header = 'Anfang der Aufgabe';
%                     txtStartTask = 'Deutsch';
%                 elseif taskParam.gParam.language == 2
%                     header = 'Next round';
%                     txtStartTask = ['In this block of trials, you will see which enemy is firing! '...
%                         'Everything else will be exactly the same. If you have any questions, please ask the experimenter.'];
%                 end
%                 feedback = false;
%                 al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%                 
%                 % todo: check if data are saved after each block
%                 for b = 1:taskParam.gParam.nb
%                     % Run "cued" condition
%                     taskParam.gParam.showCue = true;
%                     if b == 1 || ~isequal(taskParam.gParam.useTrialConstraints, 'aging')
%                         [taskDataCued, condobj.DataChineseCued] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'chinese', subject);
%                     else
%                         % Update block number in taskData
%                         taskDataCued.block(:) = b;
%                         [~, condobj.DataChineseCued] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'chinese', subject, taskDataCued);
%                     end
%                     condobj.perfCued = condobj.perfCued + condobj.DataChineseCued.accPerf(end);
%                 end
%             end
%         end
        
        %function DataFollowOutcome = FollowOutcomeCondition(runIntro, unitTest, haz, concentration, txtPressEnter)
        function condobj = FollowOutcomeCondition(condobj, taskParam, subject)
            %FOLLOWOUTCOMECONDITION   Runs the follow-outcome condition of the cannon task
            %
            %   Input
            %       runIntro: indicate if practice session should be conducted
            %       unitTest: indicate if unit test should be conducted
            %       haz: hazard rate
            %       concentration: noise in the environment
            %       txtPressEnter: text that is presented to indicate that subject should press "Enter"
            %   Output
            %       DataFollowOutcome: Participant data
            
            if condobj.runIntro && ~condobj.unitTest
                
                if isequal(subject.group, '1')
                    
                    txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz zusammengefasst ist es deine Aufgabe Kanonenkugeln aufzusammeln, indem du '...
                        'deinen Korb an der Stelle platzierst, wo die letzte Kanonenkugel gelandet ist (schwarzer Strich). Das Geld für die gesammelten '...
                        'Kugeln bekommst du nach der Studie ausgezahlt.\n\nViel Erfolg!'];
                    
                else
                    
                    txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst ist es Ihre Aufgabe Kanonenkugeln aufzusammeln, indem Sie '...
                        'Ihren Korb an der Stelle platzieren, wo die letzte Kanonenkugel gelandet ist (schwarzer Strich). Das Geld für die gesammelten '...
                        'Kugeln bekommen Sie nach der Studie ausgezahlt.\n\nViel Erfolg!'];
                    
                end
                
                al_instructions(taskParam, 'followOutcomePractice', subject)
                %[taskData, trial] = al_loadTaskData(taskParam, 'followOutcomePractice', condobj.haz(3), condobj.concentration(1));
                % ----------------------------
               
                taskData = load('CPInvisible');
                taskData = taskData.taskData;
                clear taskData.cBal taskData.rew
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
                 % ---------------------------------------------
                al_mainLoop(taskParam, condobj.haz(3), condobj.concentration(1), 'followOutcomePractice', subject, taskData, trial);
                feedback = false;
                header = 'Anfang der Aufgabe'; 
                al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
                
            else
                
                Screen('TextSize', taskParam.gParam.window.onScreen, 30);
                Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');
                % IndicateFollowCannon = 'Follow Cannon Task';
                % IndicateFollowOutcome = 'Follow Outcome Task';
                al_conditionIndication(taskParam, 'Follow Outcome Task', condobj.txtPressEnter)
                
            end
            
            %[taskData, trial] = al_loadTaskData(taskParam, 'followOutcome', condobj.haz(1), condobj.concentration(1)); 
            % --------------------------------------
          
            trial = taskParam.gParam.controlTrials;
            taskData = al_generateOutcomesMain(taskParam, condobj.haz(1), condobj.concentration(1), 'followOutcome');
            % -----------------------------------------------------------------------
            [~, condobj.DataFollowOutcome] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'followOutcome', subject, taskData, trial);
            
        end
        
        % function DataFollowCannon = FollowCannonCondition(runIntro, unitTest, haz, concentration, txtPressEnter)
        function condobj = FollowCannonCondition(condobj, taskParam, subject)

            %FOLLOWCANNONCONDITION   Runs the follow-the-cannon condition of the cannon task
            %
            %   Input
            %       runIntro: indicate if practice session should be conducted
            %       unitTest: indicate if unit test should be conducted
            %       haz: hazard rates
            %       concentration: noise in the environment
            %       txtPressEnter: text that is presented to indicate that subject should press "Enter"
            %   Output
            %       DataFollowCannon: Participant data
            
            if condobj.runIntro && ~condobj.unitTest
                
                if isequal(subject.group, '1')
                    txtStartTask = ['Du hast die Übungsphase abgeschlossen. Kurz zusammengefasst wehrst du die meisten Kugeln ab, wenn du den orangenen Punkt auf die Stelle bewegst, auf die die Kanone '...
                        'zielt (schwarze Nadel). Dieses Mal kannst du die Kanone sehen.\n\nViel Erfolg!'];
                else
                    txtStartTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst wehren Sie die meisten Kugeln ab, wenn Sie den orangenen Punkt auf die Stelle bewegen, auf die die Kanone '...
                        'zielt (schwarze Nadel). Dieses Mal können Sie die Kanone sehen.\n\nViel Erfolg!'];
                end
                
                al_instructions(taskParam, 'followCannonPractice', subject)
                %[taskData, trial] = al_loadTaskData(taskParam, 'followCannonPractice', condobj.haz(3), condobj.concentration(1)); % am 15.10.21 hier geändert, um das unabhängig zu machen.
                % ----
                taskData = load('CPInvisible');
                taskData = taskData.taskData;
                clear taskData.cBal taskData.rew
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
                % ----
                al_mainLoop(taskParam, condobj.haz(3), condobj.concentration(1), 'followCannonPractice', subject, taskData, trial);
                feedback = false;
                header = 'Anfang der Aufgabe'; 
                al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
            else
                Screen('TextSize', taskParam.gParam.window.onScreen, 30);
                Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');
                al_conditionIndication(taskParam, 'Follow Cannon Task', condobj.txtPressEnter)
            end
            %[taskData, trial] = al_loadTaskData(taskParam, 'followOutcome', condobj.haz(1), condobj.concentration(1));
            % ----
            trial = taskParam.gParam.controlTrials;
            taskData = al_generateOutcomesMain(taskParam, condobj.haz(1), condobj.concentration(1), 'followOutcome');
            % -----
            [~, condobj.DataFollowCannon] = al_mainLoop(taskParam, condobj.haz(1), condobj.concentration(1), 'followOutcome', subject, taskData, trial);
        end
        
    end
end


