classdef al_trialflow
    %AL_TRIALFLOW This class definition file specifies the 
    % properties and methods of a trialflow object
    %
    %   A trialflow object determines the components of a trial
    %   such as whether the cannon is shown or hidden, and whether we
    %   present confetti or cannonballs.
    
    properties
        
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
    end
    
    methods
        
        function trialflowobj = al_trialflow()
            %AL_TRIALFLOW This function creates a trialflow object
            % of classs al_trialflow
            %
            %   The initial values correspond to useful defaults that
            %   are often used across tasks.
            
            trialflowobj.shot = 'animate cannonball';
            trialflowobj.confetti = 'show confetti cloud';
            trialflowobj.cannonball_start = 'cannon';
            trialflowobj.cannon = "show cannon";
            trialflowobj.cannonType = "standard";
            trialflowobj.reward = "standard";
            trialflowobj.savedTickmark = "no previous tickmark";
            trialflowobj.currentTickmarks = "show";
            trialflowobj.background = "picture";
            trialflowobj.shotAndShield = "simultaneously";
            trialflowobj.push = 'noPush';
            trialflowobj.cannonPosition = 'inside';
            
        end
    end
    
end

