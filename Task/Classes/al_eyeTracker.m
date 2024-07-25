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
        el % EyeLink object

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
            self.el = nan;

        end
    end
end
