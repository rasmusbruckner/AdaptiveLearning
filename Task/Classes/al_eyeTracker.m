classdef al_eyeTracker
    %AL_EYETRACKER This class-definition file specifies the
    % properties and methods of an eye-tracker object
    %
    %   An eye-tracker object stores relevant device parameters

    % Properties of the eye-tracker object
    % ------------------------------------

    properties

        dist % viewing distance in cm
        width % physical width of the screen in cm
        height % physical height of the screen in cm
        frameDur % duration of one frame
        frameRate % in Hz
        et_file_name % current file name
        ppd % estimated pixels per degree
        resolutionX % x resolution (in pixels)
        saccThres % threshold value
        el %eyetracker instance
            
    end

    % Methods of the eye-tracker object
    % ---------------------------------

    methods

        function self = al_eyeTracker(display)
            % This function creates an object of
            % class al_eyeTracker
            %
            %   Input
            %       display: display-object instance
            %
            %   Output
            %       None


            self.dist = 40;
            self.width = 30;
            self.height = 21;
            self.frameDur = Screen('GetFlipInterval', display.window.onScreen);
            self.frameRate = Screen('NominalFrameRate', display.window.onScreen);
            self.saccThres = 1;
        end

function self = initializeEyeLink(self, taskParam, et_file_name_suffix)
            % INITIALIZEEYELINK This function initialzes the eye-tracker
            %
            %   Input
            %       taskParam: Task-parameter-object instance
            %       et_file_name_suffix: Suffix of file name
            %
            %   Output:
            %       el: Eye-link object

            self.et_file_name = sprintf('%s%s', taskParam.subject.ID, et_file_name_suffix);
            self.et_file_name = [self.et_file_name]; % todo: check if this is really necessary

            if isequal(taskParam.gParam.trackerVersion, 'eyelink')
                % Todo test if we can also pass object instead instead of new structure
                options.dist = self.dist;
                options.width = self.width;
                options.height = self.height;
                options.window_rect = taskParam.display.windowRect;
                options.frameDur = self.frameDur;
                options.frameRate = self.frameRate;
                [el, ~] = ELconfig(taskParam.display.window.onScreen, self.et_file_name, options);
    
                % Calibrate the eye tracker
                EyelinkDoTrackerSetup(el);

            elseif isequal(taskParam.gParam.trackerVersion, 'SMI')    
                settings = SMITE.getDefaults('HiSpeed');
                settings.connectInfo    = {'192.168.1.1',4444,'192.168.1.2',5555};
                settings.doAverageEyes  = false;
                settings.cal.bgColor    = taskParam.colors.background;
                settings.freq           = 500;
                %settings.trackMode      = 'MONOCULAR';
                settings.trackEye       = 'EYE_RIGHT';
                settings.logFileName    = 'test_log.txt';
                settings.save.allowFileTransfer = false;

                % initialize SMI
                self.el         = SMITE(settings);
                %self.el         = self.el.setDummyMode();
                %try a few times in case connection breaks
                tries = 0;
                while tries <= 6 
                    try
                        self.el.init();
                        tries
                        self.el.calibrate(taskParam.display.window.onScreen, false); % was calibrate(taskParam.display.window.onScreen, false)
                        break
                    catch ME
                        WaitSecs(7);
                        tries = tries + 1;
                        if tries <= 6
                            continue
                        else
                            rethrow(ME);
                        end
                    end
                end
            else
                
                error('Please specifiy tracker version as eyelink or SMI')
            end
        end


        function self = estimatePixelsPerDegree(self)
            % ESTIMATEPIXELSPERDEGREE This function estimates the number of
            % pixels per degree for online saccade detection
            %
            %   Input
            %       self: eye-tracker-object instance
            %
            %   Output
            %       self: eye-tracker-object instance
            %
            % Credit: Donner lab


            o = tan(0.5*pi/180)*self.dist; % self.dist = distance from screen (cm)
            self.ppd = 2*o*self.resolutionX/self.width; % options.resolution(1) = x resolution (in pixels); self.width = width of screen (cm)

        end

        function sacc = checkSaccade(self, eye, zero)
            % CHECKSACCADE This function detects saccades online
            %
            %   Input
            %       eye: Tracked eye
            %       zero: central fixation position
            %
            %   Output
            %       sacc: Detected saccades
            %
            %   Credit: Donner lab
            
            if isequal(taskParam.gParam.trackerVersion, 'eyelink')
            
                % Short break
                pause(0.002)
    
                % Extract samples from eye-link
                [samples, ~, ~] = Eyelink('GetQueuedData');
                
                % Extract relevant samples depending on tracked eye
                if eye==0
                    x = (samples(14,:)-zero(1))/self.ppd;
                    y = (samples(16,:)-zero(2))/self.ppd;
                else
                    x = (samples(15,:)-zero(1))/self.ppd;
                    y = (samples(17,:)-zero(2))/self.ppd;
                end
                
                % Compute deviation from fixation spot and categorize saccades
                d = (x.^2 + y.^2).^.5;
                a = d(2:length(d));
                if any(a>self.saccThres)
                    sacc = 1;
                else 
                    sacc = 0;
                end

            else
                error('online saccades only implemented for eyelink')
            end
        end
    end

    methods(Static)

        function taskParam = startRecording(taskParam)
            % STARTRECORDING This function starts the eyeLink eye-tracker
            %
            %   Input
            %       taskParam: Task-parameter-object instance
            %
            %   Output
            %       taskParam: Task-parameter-object instance
            if isequal(taskParam.gParam.trackerVersion, 'eyelink')
                Eyelink('StartRecording');
                WaitSecs(0.1);
                Eyelink('message', 'Start recording Eyelink');
    
                % Reference time stamp
                taskParam.timingParam.ref = GetSecs();

            elseif isequal(taskParam.gParam.trackerVersion, 'SMI')
                taskParam.eyeTracker.el.startRecording()
                WaitSecs(0.1);
                taskParam.eyeTracker.el.sendMessage('Start recording SMI');
                
                % Reference time stamp
                taskParam.timingParam.ref = GetSecs();
            end
        end

    end
end
