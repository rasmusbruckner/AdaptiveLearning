classdef al_timing
    %AL_TIMING This class definition file specifies the 
    % properties and methods of a timing object
    %
    %   A timing object determines all timing parameters such as 
    %   ITI and presentation duration of the outcome.
    
    % Properties of the timing object
    % -------------------------------
    
    properties
        
        % Fixation cross timing
        fixCrossLength

        % Duration of cannonball animation
        cannonBallAnimation

        % Duration of miss animation
        cannonMissAnimation

        % Presentation of outcome 
        outcomeLength

        % Presentation of reward feedback
        rewardLength

        % Length of jitter
        jitter

        % Fixed inter-trial interval
        fixedITI

        % Reference for timing; timestamp recorded at beginning of study
        ref
        
    end
    
    % Methods of the timing object
    % ----------------------------

    methods
        
        function timingobj = al_timing()
            % AL_TIMING This function creates a timing object of
            % class al_timing
            
            timingobj.fixCrossLength = 0.5;
            timingobj.cannonBallAnimation = 0.5;
            timingobj.cannonMissAnimation = 1.0;
            timingobj.outcomeLength = 0.0;
            timingobj.rewardLength = 1.0;
            timingobj.jitter = 0.2;        
            timingobj.fixedITI = 0.9;
            timingobj.ref = nan;
        end
    end
end





