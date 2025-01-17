classdef al_cannon
    %AL_CANNON This class-definition file specifies the
    % properties and methods of a cannon object
    %
    %   A cannon object contains parameters such as the number of
    %   confetti particles.

    % Properties of the cannon object
    % -------------------------------

    properties
        
        defaultParticles % take default particles or not
        nParticles % number of confetti particles
        confettiStd  % standard deviation of confetti
        confettiAnimationStd % standard deviation when confetti is animated
        nFrames % number of frames for shot animation
        confettiEndMean % average end point of confetti
        confettiEndStd % standard deviation around aveage end point
        particleSize % size of the confetti particles
        
        % Static confetti cloud
        xCloud
        yCloud
        sCloud
        colvectCloud
        xyMatrixRing
        
        % Confetti outcome
        xyExp % position x-y-coordinates
        dotCol % color
        dotSize % size
        
    end

    % Methods of the colors object
    % ----------------------------

    methods

        function self = al_cannon(defaultParticles)
            % This function creates an object of
            % class al_colors
            
            self.defaultParticles = defaultParticles;
            self.nParticles = 40;
            self.confettiStd = 3;
            self.confettiAnimationStd = 2;
            self.nFrames = 20;
            self.confettiEndMean = 150;
            self.confettiEndStd = 20;
            self.particleSize = 2;
            
            % Confetti outcome properties
            self.xyExp = nan; % x-y-position
            self.particleSize = nan;
            self.dotSize = nan; 
            if self.defaultParticles == false
                self.dotCol = nan;
            else
                self.dotCol = load('dotColDefault.mat').dotColDefault;
            end

        end

        function self = al_staticConfettiCloud(self, colors, display)
            % AL_STATICCONFETTICLOUD This function loads the data for a static
            % confetti cloud that "covers" the confetti cannon
            %
            % Input
            %   colors: Color type of confetti cloud
            %   display: Display-object instance
            %
            % Output
            %   self: Cannon object instance

            % Check if unit test is requested
            if ~exist('colors', 'var') || isempty(colors)
                colors = 'isoluminant';
            end

            % When display-object instance is not provided, 
            % don't use degrees visual angle. When provided, 
            % check if we want to use it.
            if ~exist('display', 'var') || isempty(display)
                useDegreesVisualAngle = false;
            else
                useDegreesVisualAngle = display.useDegreesVisualAngle;
            end

            % Load particle data
            load('x_cloud.mat', 'x_cloud')
            load('y_cloud.mat', 'y_cloud')
            load('s_cloud.mat', 's_cloud')
            xymatrix_ring = [x_cloud y_cloud]';
            load('xymatrix_ringDeg.mat', 'xymatrix_ringDeg')
            load('s_cloudDeg.mat')

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

            if useDegreesVisualAngle
 
                % Size of the cloud
                % -----------------
                
                % This code can be used to create a stored file for the 
                % size vector
                sCloudDeg = 0.06; %0.1;
                sCloudOrig = mean(display.pix2deg(self.sCloud));            
                sCloudFactor = sCloudDeg / sCloudOrig;
                sCloudAdjDeg = display.pix2deg(self.sCloud)*sCloudFactor;
            
                % In actual task, we use the pregenerated file based on 
                % degrees visual angle and translate it to pixels
                self.sCloud = 1+display.deg2pix(sCloudAdjDeg); % note that 
                % we add one pixel to ensure that every particles is
                % visible

                % x-y position
                % ------------
                % This is code for creating the xymatrix_ringDeg file
                % In actual task, we load a pregenerated file in degrees
                % visual angle that is translated to pixel

                % multFactor = 1.5;
                % self.xyMatrixRing(1,:) = xymatrix_ring(1,:) * multFactor; 
                % self.xyMatrixRing(2,:) = xymatrix_ring(2,:) * multFactor;
                % xymatrix_ringDeg = display.pix2deg(self.xyMatrixRing);
                
                % Translated degrees visual angle to pixel
                self.xyMatrixRing = display.deg2pix(xymatrix_ringDeg);

            end
        end
    end
end
