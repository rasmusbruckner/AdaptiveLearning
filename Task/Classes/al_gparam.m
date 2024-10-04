classdef al_gparam
    %AL_GPARAM This class definition file specifies the 
    %   properties and methods of a gParam object
    %
    %   A general-parameter object contains general task parameters such as 
    %   number of trials and blocks, hazard rate, and concentration.
    
    % Properties of the subject object
    % --------------------------------
    
    properties

        taskType % task version (e.g., Hamburg)
        
        concentration % outcome variability expressed in concentration of van-Mises distribution
        driftConc % variability of the drift (if included)
        pushConcentration % push variability in push condition     
        
        haz % hazard rate determining probability of a changepoint
        hazVar % variability hazard rate
        safe % number of trials after changepoint during which no change point occurs
        safeVar % safe trials variability changepoint

        shieldMu % mean shield size        
        shieldMin % minimum angular shield size        
        shieldMax % maximium angular shield size         
                
        trials % number of trials
        practTrials
        practTrialsVis % number of practice trials visible cannon
        practTrialsHid % number of practice trials hidden cannon
        shieldTrials % number of shield-practice trials 
        controlTrials  % number of trials of the control versions (Dresden)
        passiveViewingPractTrials % practice passive viewing

        nBlocks % number of blocks
        blockIndices % trials AFTER which participants can take a break

        screensize % screensize 
        screenNumber % if using multiple screens

        practiceTrialCriterionNTrials % number of trials above estimation-error threshold determining when practice is repeated
        practiceTrialCriterionEstErr % estimation-error threshold in practice determining when practice is repeated
        cannonPractCriterion % minimum number of passes to continue
        cannonPractNumOutcomes % number of outcomes before prediction
        
        rewMag % reward magnitude when "hit"
        useCatchTrials % indicates if catch trials are used
        catchTrialProb % Catch-trial proability
        
        askSubjInfo % determines if subject information dialogue box is presented
        language % English or German instructions?
        debug % turns debug mode on or off
        showConfettiThreshold % plotting of random confetti threshold for validation
        printTiming % Whether or not trial timing is displayed for validation
        sendTrigger % indicates if EEG triggers are going to be sent      
        printTrigger % should triggers be printed out?
        runIntro % determines if practice phase will be completed before main task
        passiveViewing % version to validate pupil signals 
        showTickmark % turns tick mark in reversal version on and off
        dataDirectory % data directory to save data
        saveName % Name of output file
        
        scanner % indicates if experiment takes place in scanner        
        meg % indicates if experiment takes place with MEG
        eyeTracker % indicates if experiment takes place with eyeTracker
        onlineSaccades % indicates if we track saccades during task
        uke % indicates uke fMRI scanner
        joy % potentially temporary joystick variable
        useResponseThreshold % determine if we use threshold for max response time
        responseThreshold % response threshold value
        automaticBackgroundRGB % set background to average of stimuli?
        customInstructions % local instructions based on instruction-text class
        baselineArousal % turn on or off
        baselineArousalDuration % measurement in seconds

        duckMovementFrequency % duck movement frequency
        duckMovementRange % duck movement range

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
            self.concentration = nan;
            self.driftConc = 30;
            self.pushConcentration = nan;
            self.haz = 0.125; 
            self.hazVar = nan;
            self.safe = 3;
            self.safeVar = 10;
            self.shieldMu = 15;                   
            self.shieldMin = 10;
            self.shieldMax = 150;
            self.trials = nan; 
            self.practTrialsVis = nan; 
            self.practTrialsHid = nan; 
            self.shieldTrials = nan; 
            self.controlTrials = nan;
            self.passiveViewingPractTrials = 10;
            self.nBlocks = nan;
            self.blockIndices = nan; 
            self.screensize = nan; 
            self.screenNumber = 1;
            self.practiceTrialCriterionNTrials = nan; 
            self.practiceTrialCriterionEstErr = nan; 
            self.cannonPractCriterion = nan;
            self.cannonPractNumOutcomes = nan;
            self.rewMag = 0.1; 
            self.useCatchTrials = nan; 
            self.catchTrialProb = nan; 
            self.askSubjInfo = nan;
            self.language = 'German'; 
            self.debug = nan;
            self.showConfettiThreshold = false;
            self.printTiming = false;
            self.sendTrigger = false; 
            self.printTrigger = false;
            self.runIntro = nan;
            self.showTickmark = nan; 
            self.dataDirectory = nan;  
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
            self.baselineArousal = false;
            self.baselineArousalDuration = 180;
            self.duckMovementFrequency = 0.1;
            self.duckMovementRange = 5;

        end
    end
end





