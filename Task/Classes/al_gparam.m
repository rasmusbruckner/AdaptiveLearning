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
        mu                         
        
        % Minimum angular shield size
        minASS 
        
        % Maximium angular shield size 
        maxASS
        
        % Indicates if EEG triggers are going to be sent
        sendTrigger
      
        % Number of trials
        trials
        
        % Trials session 1 in drug version
        trialsS1
        
        % Trials session 2 & 3 in drug version
        trialsS2S3
        
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

        % Determines if practice phase will be completed before main task
        runIntro

        % Data directory to save data
        dataDirectory

        % Indicates if experiment takes place in scanner
        scanner
        
        % Name of output file
        saveName 

        % Critical distance between enemies in chinese version
       % critDist

         % Number of practice trials of chinese version
        % (todo: when versions are independent, this should work with "trials")
       % chinesePractTrials

        % Number of planets of chinese version
       % nPlanets

        % Number of enemies of chinese version
        %nEnemies

        % Hazard rate determining switches between plantes in chinese version
        %planetHaz

        % Hazard rate determining switches between enemies in chinese version        
        %enemyHaz

        % Equivalent to safe but for planets and enemies in chinese version
        %safePlanet
        %safeEnemy

        % In chinese version: if true, outcomes are generated in a more
        % balanced way, based on some constraints
        %useTrialConstraints

        % Number of blocks in chinese version
        %nb

        % Hidden or observalbe enemy in chinese version
       % cueAllTrials

               
    end
    
    % Methods of the gparam object
    % ----------------------------
    methods
        
        function gparamobj = al_gparam()
            %AL_GPARAM This function creates a gParam object of
            % class al_gparam
            %
            %   The initial values correspond to useful defaults that
            %   are often used across tasks.
            
            gparamobj.taskType = nan; 
            gparamobj.blockIndices = nan; 
            gparamobj.driftConc = 30;
            gparamobj.oddballProb = [.25 0];
            gparamobj.reversalProb = [.5 1]; 
            gparamobj.concentration = nan;
            gparamobj.pushConcentration = nan;
            gparamobj.haz = 0.125; 
            gparamobj.mu = 15;                   
            gparamobj.minASS = 10;
            gparamobj.maxASS = 180;
            gparamobj.sendTrigger = false; 
            gparamobj.trials = nan; 
            gparamobj.trialsS1 = nan; 
            gparamobj.trialsS2S3 = nan;
            gparamobj.shieldTrials = nan; 
            gparamobj.practTrials = nan; 
            gparamobj.controlTrials = nan;
            gparamobj.safe = 3;
            gparamobj.safeVar = 10;
            gparamobj.rewMag = 0.1; 
            gparamobj.screensize = nan; 
            gparamobj.practiceTrialCriterionNTrials = nan; 
            gparamobj.practiceTrialCriterionEstErr = nan; 
            gparamobj.askSubjInfo = nan;
            gparamobj.showTickmark = nan; 
            gparamobj.useCatchTrials = nan; 
            gparamobj.catchTrialProb = nan; 
            gparamobj.screenNumber = 1;
            gparamobj.language = 2; 
            gparamobj.debug = nan;
            gparamobj.showConfettiThreshold = false;
            gparamobj.printTiming = false;
            gparamobj.runIntro = nan;
            gparamobj.dataDirectory = nan;  
            gparamobj.scanner = false;
            gparamobj.saveName = 'standard';
            %gparamobj.critDist = nan; 
            %gparamobj.chinesePractTrials = nan; 
            %gparamobj.nPlanets = 1;
            %gparamobj.nEnemies = nan; 
            %gparamobj.planetHaz = nan; 
            %gparamobj.enemyHaz = nan;
            %gparamobj.safePlanet = nan; 
            %gparamobj.safeEnemy = nan;
            %gparamobj.useTrialConstraints = false; 
            %gparamobj.nb = nan; 
            %gparamobj.cueAllTrials = nan; 

        end
    end
end





