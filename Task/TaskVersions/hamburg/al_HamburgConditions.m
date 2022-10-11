%classdef al_Hamburg_conditions
    
    
    % This class definition file specifies the properties and methods of an
    % object for the cannon task conditions
    
    % Properties of the conditions object
    % -----------------------------------
   % properties
%         
%         runIntro
%         unitTest
%         taskType
%         cBal
%         concentration
%         haz
%         testDay
%         txtPressEnter
%         showTickmark
%         DataMain
%         DataFollowOutcome
%         DataFollowCannon
%         Data
%         DataChineseCued
%         DataChineseMain
%         perfMain
%         perfCued
%         
%     end
%     

    % Methods of the conditions object
    % --------------------------------
   % methods
%         
%         function condobj = al_Hamburg_conditions(cond_init)
%             % AL_CONDITIONS creates a conditions object of class condobj
%             % This is based on the initialization input structure
%             %
%             %   Input
%             %       cond_init: structure with condition initialization
%             %
%             %   Output
%             %       condobj: task object with initialized values
%             
%             % Set variable task properties based on input structure
%             condobj.runIntro = cond_init.runIntro;
%             condobj.unitTest = cond_init.unitTest;
%             condobj.taskType = cond_init.taskType;
%             condobj.cBal = cond_init.cBal;
%             condobj.concentration = cond_init.concentration;
%             condobj.haz = cond_init.haz;
%             condobj.testDay = cond_init.testDay;
%             condobj.txtPressEnter = cond_init.txtPressEnter;
%             condobj.showTickmark = cond_init.showTickmark;
%             condobj.perfMain = 0;
%             condobj.perfCued = 0;
%         end
%         
        
        function al_HamburgConditions(taskParam)
            %MAINCONDITION   Runs the change point condition of the cannon task
            %
            %   Input
            %       condobj: task object with initialized values
            %       taskParam: structure containing task paramters
            %       subject: structure containing subject information
            %
            %   Output
            %       condobj: task object with initialized values
            

            runIntro = taskParam.gParam.runIntro;
            unitTest = taskParam.unitTest;
            concentration = taskParam.gParam.concentration;
            haz = taskParam.gParam.haz;
            testDay = taskParam.subject.testDay;
            cBal = taskParam.subject.cBal;

%             % Display instructions after practice session
%             if runIntro && ~unitTest
%                 
%               %  if strcmp(subject.session,'1')
%                     
%                     if condobj.testDay == 1
%                         %al_instructions(taskParam, 'mainPractice', subject)
%                         whichPractice = 'mainPractice';
%                         al_ARC_Instructions(taskParam, subject, true, whichPractice)
% 
%                     elseif condobj.testDay == 2
%                         
%                         % Text settings
%                         Screen('TextFont', taskParam.gParam.window.onScreen, 'Arial');
%                         Screen('TextSize', taskParam.gParam.window.onScreen, 50);
%                         header = 'Day 2: Practice Session';
%                         if ~condobj.showTickmark
%                             txtStartTask = ['Welcome to the second part of the experiment. As yesterday, you will start with a practice session. On each '...
%                                 'trial a cannon will aim at a location on the circle. On all trials the cannon will fire a ball somewhere near the point of '...
%                                 'aim. Most of the time the cannon will remain aimed at the same location, but occasionally the cannon will be reaimed. '...
%                                 'You will not see the cannon, but have to infer its aim in order to catch balls and earn money.\n\nHowever, this time you '...
%                                 'will no longer see the orange and the black line that marked the location of the previous orange spot and the previous position of the ball.'];
%                         elseif condobj.showTickmark
%                             txtStartTask = ['Welcome to the second part of the experiment. As yesterday, you will start with a practice session. On each '...
%                                 'trial a cannon will aim at a location on the circle. On all trials the cannon will fire a ball somewhere near the point of '...
%                                 'aim. Most of the time the cannon will remain aimed at the same location, but occasionally the cannon will be reaimed. '...
%                                 'You will not see the cannon, but have to infer its aim in order to catch balls and earn money.\n\nHowever, this time the '...
%                                 'location of the ball fired on the previous trial will be marked with a black line.\n\nMoreover, the location of the orange spot from the '...
%                                 'previous trial will be marked with an orange line.'];
%                         end
%                         
%                         feedback = false;
%                         al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%                     end
%                     
%                     if condobj.cBal == 1 || condobj.cBal == 3
%                         
%                         % Experimental blocks
%                         header = 'Third Practice';
%                         txtStartTask = ['This is the last practice session. Here you will less frequently see the cannon. \n\n'...
%                             'Like in the previous session you should try to place your shield at the (hidden) aim of the cannon. '];
%                         
%                         feedback = false;
%                         al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%                         ARC_indicateCondition('lowNoise', taskParam, condobj.txtPressEnter)
%                         %[taskData, trial] = al_loadTaskData(taskParam, 'mainPractice_3', condobj.haz(3), condobj.concentration(1)); % am 15.10.21 hier geändert, um das unabhängig zu machen.
%                         % ------------------------
%                         taskData = load('pract3');
%                         taskData = taskData.taskData;
%                         taskData.critical_trial = nan; % das hab ich in mainLoop angepasst
%                         trial = taskParam.gParam.practTrials;
%                         % ------------------------------------
%                         al_mainLoop(taskParam, condobj.haz(3), condobj.concentration(1), 'mainPractice_3', subject, taskData, trial);
%                         
%                         ARC_indicateCondition('highNoise', taskParam, condobj.txtPressEnter)
%                         % ------------------------
%                         taskData = load('pract4');
%                         taskData = taskData.taskData;
%                         taskData.critical_trial = nan; % das hab ich in mainLoop angepasst
%                         trial = taskParam.gParam.practTrials;
%                         % ------------------------------------
%                         %[taskData, trial] = al_loadTaskData(taskParam, 'mainPractice_4', condobj.haz(3), condobj.concentration(2)); % am 15.10.21 hier geändert, um das unabhängig zu machen.
%                         al_mainLoop(taskParam, condobj.haz(3), condobj.concentration(2), 'mainPractice_4', subject, taskData, trial);
%                         
%                     elseif condobj.cBal == 2 || condobj.cBal == 4
%                         
%                         ARC_indicateCondition('highNoise', taskParam, condobj.txtPressEnter)
%                         al_mainLoop(taskParam, condobj.haz(3), condobj.concentration(2), 'mainPractice_4', subject);
%                         
%                         ARC_indicateCondition('lowNoise', taskParam, condobj.txtPressEnter)
%                         al_mainLoop(taskParam, condobj.haz(3), condobj.concentration(1), 'mainPractice_3', subject);
%                     end
%                     
%                     % Experimental blocks
%                     header = 'Beginning of the experiment';
%                     txtStartTask = ['This is the beginning of the experiment. The trials will be exactly '...
%                         'the same as those in the previous session.\n\n On each trial a cannon will aim at a location on '...
%                         'the circle. On all trials the cannon will fire a ball somewhere near the point of aim. '...
%                         'Most of the time the cannon will remain aimed at the same location, but occasionally the cannon '...
%                         'will be reaimed. Like in the previous session you will only rarely see the cannon and '...
%                         'you should still try to infer its aim in order to catch the cannonballs.'];
%                     
%                     feedback = false;
%                     al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%                     
%                     if condobj.cBal == 1 || condobj.cBal == 3
%                         
%                         ARC_indicateCondition('lowNoise', taskParam, condobj.txtPressEnter)
%                         
%                     elseif condobj.cBal == 2 || condobj.cBal == 4
%                         
%                         ARC_indicateCondition('highNoise', taskParam, condobj.txtPressEnter)
%                         
%                     end
%                     
%                 elseif strcmp(subject.session,'2')
%                     
%                     if  condobj.cBal == 1 || condobj.cBal == 3
%                         
%                         ARC_indicateCondition('highNoise', taskParam, condobj.txtPressEnter)
%                         
%                     elseif condobj.cBal == 2 || condobj.cBal == 4
%                         
%                         ARC_indicateCondition('lowNoise', taskParam, condobj.txtPressEnter)
%                         
%                     end
%                 end
%                
%             end
%             
%             if (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 1 && strcmp(subject.session, '1'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 3 && strcmp(subject.session, '1'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 2 && strcmp(subject.session, '2'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 4 && strcmp(subject.session, '2'))...
%                     || (strcmp(condobj.taskType, 'dresden'))
                
                currentConcentration = concentration(1);
                
%             elseif (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 1 && strcmp(subject.session, '2'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 3 && strcmp(subject.session, '2'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 2 && strcmp(subject.session, '1'))...
%                     || (strcmp(condobj.taskType, 'ARC') && condobj.cBal == 4 && strcmp(subject.session, '1'))
%                 
%                 currentConcentration = condobj.concentration(2);
%             end
            
            trial = taskParam.gParam.trials;
            % taskData = al_generateOutcomes(taskParam, condobj.haz(1), currentConcentration, 'main');
            % taskData = al_generateOutcomesMain(taskParam, condobj.haz(1), currentConcentration, 'main');
            taskData = al_generateOutcomesMain(taskParam, haz, concentration, 'main');
            [~, condobj.DataMain, subject] = al_confettiLoop(taskParam, haz(1), currentConcentration, 'main', taskParam.subject, taskData, trial);
            
            % savename = sprintf('Drugstudy_%s_%s_session%s_%s', rewName, subject.ID, subject.session, condition);
            %save(savename, 'Data')
            
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
        %end
        
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
%             

%             %[taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(2), taskParam.gParam.concentration(3));
%             % -----
%             taskData = al_generateOutcomesMain(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition);
%             taskParam.condition = condition;
%             trial = taskData.trial;
%             taskData.initialTendency = nan(trial,1); 
%             % ----
%             [~, ~] =  al_confettiLoop(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
%              % savename = sprintf('Drugstudy_%s_%s_session%s_%s', rewName, subject.ID, subject.session, condition);
%             %save(savename, 'Data')
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

%             %[taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(2), taskParam.gParam.concentration(3));
%             % ------
%             taskData = al_generateOutcomesMain(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition);
%             taskParam.condition = condition;
%             trial = taskData.trial;
%             taskData.initialTendency = nan(trial,1); % das hab ich in mainLoop angepasst
%             % ----
%             [~, condobj.Data] =  al_confettiLoop(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
%             % savename = sprintf('Drugstudy_%s_%s_session%s_%s', rewName, subject.ID, subject.session, condition);
%             %save(savename, 'Data')
% %             if isequal(condition, 'ARC_controlSpeed')
% %                 
% %                 taskIndex = 'speed task';
% %                 
% %             elseif isequal(condition, 'ARC_controlAccuracy')
% %                 
% %                 taskIndex = 'accuracy task';
% %                 
% %             end
%             feedback = false;
%             txtStartTask = sprintf('This is the end of the %s.', taskIndex);
%             al_bigScreen(taskParam, condobj.txtPressEnter, header, txtStartTask, feedback);
%             
%             % Depending on cbal, turn tickmark on again
%             %taskParam.gParam.showTickmark = condobj.showTickmark;
%             
%         end
        
    %end
%end


