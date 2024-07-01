classdef al_trialflow
    %AL_TRIALFLOW This class definition file specifies the 
    % properties and methods of a trialflow object
    %
    %   A trialflow object determines the components of a trial
    %   such as whether the cannon is shown or hidden, and whether we
    %   present confetti or cannon balls.
    
    properties
        
        % Task condition
        condition
            % main: change-point task
            % followOutcome: control task Dresden
            % followCannon: control task Dresden
            % shield: shield practice

        % Experiment vs. practice session: used for save string
        exp 
            % exp: experimental session
            % pract: practice session
            % practVis: practice visual cannon
            % practHid: practice hidden cannon
            % practHidPush: practice hidden cannon push condition
            % practHidcolor: practice hidden cannon color block
            % practHidAsym: practice hidden cannon asymmetric reward
            % run1: fMRI run 1
            % run2: fMRI run 2
            % run3: fMRI run 3
            % block1: infant
            % block2: infant 

        % Cannonball animation
        shot
            % animate cannonball: with animations 
            % static: no animations

        % Whether or not shot and shield are presented simultaneously
        shotAndShield
            % simultaneously: togehter
            % sequential: separately  
        
        % Confetti instead of ball
        confetti
            % show confetti cloud: with confetti stimuli
            % none: no confetti
        
        % Starting location of cannonball
        cannonball_start
            % center: right in the middle 
            % cannon: in front of cannon

        % Whether or not cannon is shown
        cannon
            % show cannon
            % hide cannon
        
        % Which cannon type will be shown
        cannonType 
            % standard: eLife style cannon
            % confetti: confetti-cannon style
            % helicopter: for Leipzig version

        % How rewards are delivered (e.g., standard, asymmetric)
        reward
            % standad: points for catching
            % asymmetric: Jan Gläscher's asymmetric-reward version
            % monetary
            % social
        
        % Whether or not tickmarks for current trial are used
        currentTickmarks
            % show: standard tick makrs
            % workingMemory: 5 last outcomes
            % hide: no tick marks
        
        % If more entertaining background is displayed
        background
            % picture: for sleep version with arena
            % no picture: for other versions with gray background

        % Whether or not initial shield location varies randomly
        push
            % push: push condition sleep
            % noPush: no-push condition
            % practiceNoPush: special case for practice

        % Cannon position 
        cannonPosition
            % inside: currently used on all conditions
            % outside: previously used for chinese version

        % Shield type (contant vs. reward)
        shieldType
            % constant: always same reward type
            % reward: rewarding and neutral shields

        % Shield variable vs. fixed
        shield
            % variable: variable shield size
            % constant: constant shield size
            % variableWithSD: variable with different standard deviations
            %   of outcome generating distribution

        % Style (full, reduced, lines)
        shieldAppearance
            % full: standard shield
            % reduced: only frame
            % lines: for pupillometry

        % Input device
        input
            % mouse
            % keyboard

        % Mean of distribution
        distMean 
            % fixed: standard change-point task
            % drift: drifting mean

         % Noise conditions
        variability
            % stable: constant variability
            % changepoint: changing variability levels

        % Color type (colorful vs. isoluminant)
        colors
            % colorful: standard
            % isoluminant: pupillometry
            % blackwhite: alternative version for pupillometry
        
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
            self.shotAndShield = 'simultaneously';
            self.confetti = 'show confetti cloud';
            self.cannonball_start = 'cannon';
            self.cannon = 'show cannon';
            self.cannonType = 'standard';
            self.reward = 'standard';
            self.currentTickmarks = 'show';
            self.background = 'picture';
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

