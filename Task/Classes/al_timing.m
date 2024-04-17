classdef al_timing
    %AL_TIMING This class definition file specifies the 
    % properties and methods of a timing object
    %
    %   A timing object determines all timing parameters such as 
    %   ITI and presentation duration of the outcome.
    
    % Properties of the timing object
    % -------------------------------
    
    properties
        
        % Fixation cross before outcome timing
        fixCrossOutcome
        
        % Fixation cross before shield timing
        fixCrossShield

        % Duration of cannonball animation
        cannonBallAnimation

        % Duration of miss animation
        cannonMissAnimation

        % Presentation of outcome 
        outcomeLength

        % Presentation of shield
        shieldLength        

        % Presentation of reward feedback
        rewardLength
        
        % Length of jitter before outcome
        jitterOutcome
        
        % Length of jitter before shield
        jitterShield

        % Length of jitter for ITI
        jitterITI

        % Fixed inter-trial interval
        fixedITI

        % Reference for timing; timestamp recorded at beginning of study
        ref
        
    end
    
    % Methods of the timing object
    % ----------------------------

    methods
        
        function self = al_timing()
            % AL_TIMING This function creates a timing object of
            % class al_timing
            
            self.fixCrossOutcome = 0.5;
            self.fixCrossShield = 0.5;
            self.cannonBallAnimation = 0.5;
            self.cannonMissAnimation = 1.0;
            self.outcomeLength = 0.0;
            self.shieldLength = 0.0;
            self.rewardLength = 1.0;
            self.jitterOutcome = 2;        
            self.jitterITI = 0.2;  
            self.jitterShield = 0.6;
            self.fixedITI = 0.9;
            self.ref = nan;
        end
    end
end





