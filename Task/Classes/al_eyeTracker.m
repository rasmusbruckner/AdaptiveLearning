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


            self.et_file_name = sprintf('%s_%s', taskParam.subject.ID, et_file_name_suffix);
            self.et_file_name = [self.et_file_name]; % todo: check if this is really necessary

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


            o = tan(0.5*pi/180)*self.dist; % self.dist = distance from screen (cm)
            self.ppd = 2*o*self.resolutionX/self.width; % options.resolution(1) = x resolution (in pixels); self.width = width of screen (cm)

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


            Eyelink('StartRecording');
            WaitSecs(0.1);
            Eyelink('message', 'Start recording Eyelink');

            % Reference time stamp
            taskParam.timingParam.ref = GetSecs();
        end
    end
end
