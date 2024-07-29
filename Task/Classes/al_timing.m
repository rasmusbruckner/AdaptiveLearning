classdef al_timing
    %AL_TIMING This class definition file specifies the 
    % properties and methods of a timing object
    %
    %   A timing object determines all timing parameters such as 
    %   ITI and presentation duration of the outcome.
    
    % Properties of the timing object
    % -------------------------------
    
    properties
        
        fixCrossOutcome % fixation cross before outcome timing        
        fixCrossShield % fixation cross before shield timing
        cannonBallAnimation % duration of cannonball animation
        cannonMissAnimation % duration of miss animation
        outcomeLength % presentation of outcome 
        shieldLength % presentation of shield
        rewardLength % presentation of reward feedback        
        jitterFixCrossOutcome % length of jitter before outcome
        jitterOutcome % jitter outcome itself      
        jitterFixCrossShield % length of jitter before shield
        jitterShield % jitter shield itself
        jitterITI % length of jitter for ITI
        fixedITI % fixed inter-trial interval
        ref % reference for timing; timestamp recorded at beginning of study
        baselineFixLength % baseline before prediction
        passiveViewingAnimationMean % for pupillometry control task: average time
        passiveViewingAnimationSD % for pupillometry control task: SD
        staticDuck
        movingDuck
        staticOutcome
        movingOutcome
        
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
            self.jitterFixCrossOutcome = 2;
            self.jitterOutcome = 0.15;        
            self.jitterITI = 0.2;  
            self.jitterFixCrossShield = 0.6;
            self.jitterShield = 0.15;
            self.fixedITI = 0.9;
            self.ref = nan;
            self.baselineFixLength = 0.25;
            self.passiveViewingAnimationMean = 0.8;
            self.passiveViewingAnimationSD = 0.2;
            
            % Infant
            self.staticDuck = 1.0;
            self.movingDuck = 1.0;
            self.staticOutcome = 1.0;
            self.movingOutcome = 1.0;
        end
    end
end





