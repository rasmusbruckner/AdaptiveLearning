classdef al_keys
    %AL_KEYS This class definition file specifies the 
    % properties and methods of a keys object
    %
    %   A keys object contains the key codes.
    
    % Properties of the subject object
    % --------------------------------
    
    properties
        
        delete
        rightKey
        keySpeed
        rightArrow
        leftArrow
        rightSlowKey
        slowKeySpeed
        leftKey
        leftSlowKey
        space
        enter        
        s
        five
        esc
        kbDev
        leftRelease
        rightRelease

    end
    
    % Methods of the conditions object
    % --------------------------------
    
    methods
        
        function self = al_keys()
            %AL_KEYS This function creates a keys object of
            % class keys
            
            KbName('UnifyKeyNames')
            self.delete = KbName('DELETE');
            self.rightKey = KbName('j');
            self.keySpeed = 0.75;
            self.rightArrow = KbName('RightArrow');
            self.leftArrow = KbName('LeftArrow');
            self.rightSlowKey = KbName('h');
            self.slowKeySpeed = 0.1;
            self.leftKey = KbName('f');
            self.leftSlowKey = KbName('g');
            self.space = KbName('Space');
            self.enter = 37;
            self.s = 40;
            self.five = 15; %'5';
            self.esc = KbName('ESCAPE');
            self.leftRelease = 43;
            self.rightRelease = 44; 
                      
        end

        function self = al_kbdev(self)
            % This function detects the keyboard device, necessary on 
            % some Macs

            kbdevs = [];
            devs = PsychHID('Devices');
            for d = 1:numel( devs )
                if strcmp(devs(d).usageName,'Keyboard')
                    kbdevs(end+1) = devs(d).index;
                end
            end
            
            if numel(kbdevs > 1)
              self.kbDev = -1; % "merge" all keyboard in KbCheck
            else
              self.kbDev = kbdevs;
            end
        end


        function self = checkQuitTask(self, taskParam, taskData)
            % CHECKQUITTASK This function checks if esc was pressed to
            % quit task
            %
            %   Input
            %       taskParam: Task-parameter-object instance
            %       taskData: Task-data-object instance
            %
            %   Output
            %       None
            
            % Extract variables
            eyeTracker = taskParam.gParam.eyeTracker;

            % Check for quit
            [ ~, ~, keyCode] = KbCheck(self.kbDev);
            if keyCode(self.esc)
                
                % Save data when quitting task early
                % ----------------------------------

                % Eye-tracker
                if eyeTracker && isequal(taskParam.trialflow.saveEtData, 'true')

                    et_file_name = taskParam.eyeTracker.et_file_name;

                    et_path = pwd;
                    et_file_name = [et_file_name, '.edf'];

                    if isequal(taskParam.gParam.trackerVersion, 'eyelink')

                        al_saveEyelinkData(et_path, et_file_name)
                        Eyelink('StopRecording');

                    elseif isequal(taskParam.gParam.trackerVersion, 'SMI')
        
                        al_saveSMIData(taskParam.eyeTracker.el, et_path, et_file_name) 
                        taskParam.eyeTracker.el.stopRecording();
                    end
                    
                end
                
                
                % Behavioral
                if isequal(taskParam.trialflow.saveData, 'true') && exist('taskData', 'var') == true
                    al_saveData(taskData)
                end

                ListenChar();
                ShowCursor;
                Screen('CloseAll');
                error('User pressed Escape to quit task')
            end
        end
    end
end





