classdef al_trialflow
    %AL_TRIALFLOW This class definition file specifies the 
    % properties and methods of a trialflow object
    %
    %   A trialflow object determines the components of a trial
    %   such as whether the cannon is shown or hidden, and whether we
    %   present confetti or cannonballs.
    
    properties
        
        % Task condition
        condition

        % Experiment vs. practice session
        exp

        % Cannonball animation
        shot

        % Confetti instead of ball
        confetti
        
        % Starting location of cannonball
        cannonball_start
       
        % Whether or not cannon is shown
        cannon
        
        % Which cannon type will be shown
        cannonType 

        % How rewards are delivered (e.g., standard, asymmetric)
        reward

        % Whether or not saved tickmarks are used
        savedTickmark
        
        % Whether or not tickmarks for current trial are used
        currentTickmarks
        
        % If more entertaining background is displayed
        background
        
        % Whether or not shot and shield are presented simultaneously
        shotAndShield

        % Whether or not initial shield location varies randomly
        push

        % Cannon position 
        cannonPosition

        % Shield type (contant vs. reward)
        shieldType

        % Shield variable vs. fixed
        shield

        % Style (full, reduced, lines)
        shieldAppearance

        % Input device
        input

        % Mean of distribution
        distMean 

         % Noise conditions (stable vs. changepoints)
        variability

        % Color type (colorful vs. isoluminant)
        colors
        
    end
    
    methods
        
        function self = al_trialflow()
            %AL_TRIALFLOW This function creates a trialflow object
            % of classs al_trialflow
            %
            %   The initial values correspond to useful defaults that
            %   are often used across tasks.
            
            self.condition = 'main';
            self.exp = 'exp';
            self.shot = 'animate cannonball';
            self.confetti = 'show confetti cloud';
            self.cannonball_start = 'cannon';
            self.cannon = 'show cannon';
            self.cannonType = 'standard';
            self.reward = 'standard';
            self.savedTickmark = 'no previous tickmark';
            self.currentTickmarks = 'show';
            self.background = 'picture';
            self.shotAndShield = 'simultaneously';
            self.push = 'noPush';
            self.cannonPosition = 'inside';
            self.shieldType = 'contant';
            self.shield = 'fixed';
            self.shieldAppearance = 'full';
            self.input = 'mouse';
            self.distMean = 'fixed';
            self.variability = 'stable';
            self.currentTickmarks = 'standard';
            self.colors = 'colorful';
        end
    end
    
end

