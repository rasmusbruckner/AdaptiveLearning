classdef al_gparam
    %AL_GPARAM This class definition file specifies the 
    %   properties and methods of a gParam object
    %
    %   A gParam object contains general task parameters such as 
    %   number of trials and blocks, hazard rate, and concentration.
    

    % Todo: finish comments and delete unnecessary parameters when
    % versions are fully independent

    % Properties of the subject object
    % --------------------------------
    
    properties
        
        % Task version (ARC, chinese, dresden, drugstudy, eLife, hamburg, reversal, sleep)
        taskType 
         
        % Trials on which participants can take a break
        blockIndices

        % Variability of the drift in the "oddball" versions (drugstudy, eLife)
        driftConc

        % Probability of an oddball in the "oddball" versions (drugstudy, eLife)
        oddballProb

        % Probability of a reversal in the "reversal" version
        reversalProb

        % Outcome variability expressed in concentration of van-Mises distribution
        concentration

        % Push variability in push condition
        pushConcentration
                 
        % Hazard rate determining probability of a changepoint
        haz
        
        % Variability hazard rate
        hazVar

        % Mean shield size
        shieldMu                     
        
        % Minimum angular shield size
        shieldMin
        
        % Maximium angular shield size 
        shieldMax
        
        % Indicates if EEG triggers are going to be sent
        sendTrigger
      
        % Number of trials
        trials
        
        % Trials session 1 in drug version
        trialsS1
        
        % Trials session 2 & 3 in drug version
        trialsS2S3

        % Number of blocks
        nBlocks
        
        % Number of shield-practice trials 
        shieldTrials
        
        % Number of practice trials
        practTrials

        % Number of trials of the control versions (Dresden)
        controlTrials

        % Number of trials after changepoint during which no change point
        % occurs
        safe

        % Safe trials variability changepoint
        safeVar

        % Reward magnitude when "hit"
        rewMag

        % Screensize 
        screensize

        % Number of trials above estimation-error threshold determining
        % when practice is repeated
        practiceTrialCriterionNTrials

        % Estimation-error threshold in practice determining when practice
        % is repeated
        practiceTrialCriterionEstErr

        % Determines if subject information dialogue box is presented
        askSubjInfo
        
        % Turns tick mark in reversal version on and off
        showTickmark

        % Indicates if catch trials are used
        useCatchTrials

        % Catch-trial proability
        catchTrialProb

        % If using multiple screens (on Ubunty currently not used)
        screenNumber

        % Englisch or German instructions?
        language

        % Turns debug mode on or off
        debug

        % Plotting of random confetti threshold for validation
        showConfettiThreshold

        % Whether or not trial timing is displayed for debugging
        printTiming

        % Should triggers be printed out?
        printTrigger

        % Determines if practice phase will be completed before main task
        runIntro

        % Data directory to save data
        dataDirectory

        % Indicates if experiment takes place in Magdeburg scanner
        scanner
        
        % Name of output file
        saveName 

        % Indicates if experiment takes place with MEG
        meg

        % Indicates if experiment takes place with eyeTracker
        eyeTracker

        % Indicates uke fMRI scanner
        uke

        % Potentially temporary joystick variable
        joy

        % Determine if we use threshold for max response time
        useResponseThreshold

        % Response threshold value
        responseThreshold

        % Set background to average of stimuli?
        automaticBackgroundRGB
        
        % Local instructions based on instruction-text class
        customInstructions
               
    end
    
    % Methods of the gparam object
    % ----------------------------
    methods
        
        function self = al_gparam()
            %AL_GPARAM This function creates a gParam object of
            % class al_gparam
            %
            %   The initial values correspond to useful defaults that
            %   are often used across tasks.
            
            self.taskType = nan; 
            self.blockIndices = nan; 
            self.driftConc = 30;
            self.oddballProb = [.25 0];
            self.reversalProb = [.5 1]; 
            self.concentration = nan;
            self.pushConcentration = nan;
            self.haz = 0.125; 
            self.shieldMu = 15;                   
            self.shieldMin = 10;
            self.shieldMax = 150;
            self.sendTrigger = false; 
            self.trials = nan; 
            self.trialsS1 = nan; 
            self.trialsS2S3 = nan;
            self.shieldTrials = nan; 
            self.practTrials = nan; 
            self.controlTrials = nan;
            self.nBlocks = nan;
            self.safe = 3;
            self.safeVar = 10;
            self.rewMag = 0.1; 
            self.screensize = nan; 
            self.practiceTrialCriterionNTrials = nan; 
            self.practiceTrialCriterionEstErr = nan; 
            self.askSubjInfo = nan;
            self.showTickmark = nan; 
            self.useCatchTrials = nan; 
            self.catchTrialProb = nan; 
            self.screenNumber = 1; %1 2
            self.language = 2; 
            self.debug = nan;
            self.showConfettiThreshold = false;
            self.printTiming = false;
            self.printTrigger = false;
            self.runIntro = nan;
            self.dataDirectory = nan;  
            self.scanner = false;
            self.saveName = 'standard';
            self.scanner = false;
            self.meg = false;
            self.eyeTracker = false;
            self.uke = false;
            self.joy = nan;
            self.useResponseThreshold = false;
            self.responseThreshold = 6;
            self.automaticBackgroundRGB = false;
            self.customInstructions = nan;
        end
    end
end





