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
        
    end
    
    % Methods of the colors object
    % ----------------------------
    
    methods
        
        function cannonobj = al_cannon()
            % COLORSOBJ This function creates a colors object of
            % class al_colors
          
            cannonobj.nParticles = 41;
            cannonobj.confettiStd = 3;
            
        end
    end
end



