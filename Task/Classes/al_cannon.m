classdef al_cannon
    %AL_CANNON This class definition file specifies the
    % properties and methods of a cannon object
    %
    %   A cannon object contains parameters such as the number of
    %   confetti particles.

    % Properties of the cannon object
    % -------------------------------

    properties

        % Number of confetti particles
        nParticles

        % Standard deviation of confetti
        confettiStd

        % Standard deviation when confetti is animated
        confettiAnimationStd

        % Number of frames for shot animation
        nFrames

        % Average end point of confetti
        confettiEndMean

        % Standard deviation around aveage end point
        confettiEndStd

        % Size of the confetti particles
        particleSize
        
        % Static confetti cloud
        xCloud
        yCloud
        sCloud
        colvectCloud
        xyMatrixRing

    end

    % Methods of the colors object
    % ----------------------------

    methods

        function self = al_cannon()
            % This function creates an object of
            % class al_colors

            self.nParticles = 41;
            self.confettiStd = 3;
            self.confettiAnimationStd = 2;
            self.nFrames = 20;
            self.confettiEndMean = 150;
            self.confettiEndStd = 20;
            self.particleSize = 2;

        end

        function self = al_staticConfettiCloud(self, colors)
            % AL_STATICCONFETTICLOUD This function loads the data for a static
            % confetti cloud that "covers" the confetti cannon
            %
            % Input
            %   colors: Color type of confetti cloud

            % Check if unit test is requested
            if ~exist('colors', 'var') || isempty(colors)
                colors = 'isoluminant';
            end

            % Load particle data
            load('x_cloud.mat', 'x_cloud')
            load('y_cloud.mat', 'y_cloud')
            load('s_cloud.mat', 's_cloud')
            xymatrix_ring = [x_cloud y_cloud]';

            if isequal(colors, 'colorful')
                load('colvect_cloud.mat', 'colvect_cloud')
            elseif isequal(colors, 'dark')
                load('colvect_cloud_gray.mat', 'colvect_cloud')
            elseif isequal(colors, 'blackWhite')
                load('colvect_cloud_blackWhite.mat', 'colvect_cloud')
            else
                error('Color input not defined')
            end

            % Store values
            self.xCloud = x_cloud;
            self.yCloud = y_cloud;
            self.sCloud = s_cloud;
            self.colvectCloud = colvect_cloud;
            self.xyMatrixRing = xymatrix_ring;

        end
    end
end
