classdef al_taskDataMain
    %AL_TASKDATAMAIN This class definition file specifies the
    % properties of a taskDataMain object
    %
    %   The class generates task data and stores participant data

    properties

        trials % number of trials
        taskType % Version

        % Participant
        % -----------

        ID % participant ID
        age % participant age
        gender % participant gender
        date % test date
        testDay % test day
        group % subject group

        % Stable parameters
        % -----------------

        cond % current condition
        concentration % concentration of the outcome-generating distribution
        haz % hazard rate
        hazVar % variance hazard rate
        rew % reward condition
        cBal % counterbalancing condition
        safe % number of safe trials without changepoints
        safeVar % number of safe trials without variability changepoints
        nParticles % number of confetti particles in Hamburg version
        confettiStd % standard deviation of confetti particles
        pushConcentration % concentration of push manipulation
        startingBudget % start-up budget for conditions with losses
        driftConc % drift standard deviation of cannon

        % Task-generated data
        % -------------------

        currTrial % trial number
        block % block number
        allShieldSize% all angular shield size
        actJitterOnset % actual onset jitter on each trial
        actJitterOutcome % actual outcome jitter on each trial
        actJitterShield % actual shield jitter on each trial
        cp % changepoint index
        cpVar % variance changepoint index
        cpRew % reward-distribution-changepoint index
        outcome % current outcome
        distMean % mean of outcome-generating distribution
        TAC % trials after changepoint
        TACVar % trials after variability changepoint
        catchTrial % catch-trial index
        shieldType % Current shield type
        z % default shield location
        y % push magnitude
        asymRewardSign % reward sign in asymReward version
        nGreenParticles % number of green particles
        dotCol % color of confetti particles

        % Task-participant interaction
        % ----------------------------

        pred % predictoin
        predErr % prediction error
        estErr % estimation error
        diffLastOutcPred % difference last outcome and prediction for Dresden version
        UP % update
        hit % hit vs. miss
        perf % trial-by-trial performance
        accPerf % accumulated performance
        actRew % actual reward
        RT % reaction time
        initiationRTs % initiation reaction time
        initialTendency % initial movement direction
        nParticlesCaught % number of confetti particles caught
        greenCaught % asymmetric-reward-version number of green particles caught
        redCaught % asymmetric-reward-version number of green particles caught
        RPE % reward prediction error

        % EEG and pupillometry
        % --------------------
        timestampOnset
        timestampPrediction
        timestampFixCross1
        timestampFixCross2
        timestampFixCross3
        timestampOutcome
        timestampShield
        timestampReward
        timestampOffset
        triggers

        % Stimulus size
        % -------------
        rotationRad

    end

    % Methods of the taskDataMain object
    % ----------------------------------

    methods

        function self = al_taskDataMain(trials, taskType)
            % AL_TASKDATAMAIN This function creates a data object of
            % class al_taskDataMain
            %
            %   Input
            %       trials: Number of trials of current condition
            %
            %   Output
            %       self: Data-object instance


            % Initialize variables
            % --------------------

            self.taskType = taskType ;

            % Participant
            self.ID = cell(trials, 1);
            self.age = nan(trials, 1);
            self.gender = cell(trials, 1);
            self.date = cell(trials, 1);
            self.testDay = nan(trials, 1);
            self.group = nan(trials, 1);

            % Stable parameters
            self.trials = trials;
            self.cond = cell(trials, 1);
            self.concentration = nan(trials, 1);
            self.haz = nan(trials, 1);
            self.hazVar = nan(trials, 1);
            self.rew = nan(trials, 1);
            self.cBal = nan(trials, 1);
            self.safe = nan(trials, 1);
            self.nParticles = nan(trials, 1);
            self.confettiStd = nan(trials, 1);
            self.pushConcentration = nan(trials, 1);
            self.startingBudget = nan(trials, 1);
            self.driftConc = nan(trials, 1);

            % Task-generated data
            self.currTrial = nan(trials, 1);
            self.block = nan(trials, 1);
            self.allShieldSize = nan(trials, 1);
            self.actJitterOnset = nan(trials, 1);
            self.actJitterOutcome = nan(trials, 1);
            self.actJitterShield = nan(trials, 1);
            self.cp = nan(trials, 1);
            self.cpVar = nan(trials, 1);
            self.cpRew = nan(trials, 1);
            self.outcome = nan(trials, 1);
            self.distMean = nan(trials, 1);
            self.TAC = nan(trials, 1);
            self.TACVar = nan(trials, 1);
            self.catchTrial = zeros(trials, 1);
            self.shieldType = nan(trials, 1);
            self.z = nan(trials, 1);
            self.y = nan(trials, 1);
            self.asymRewardSign = nan(trials, 1);
            self.nGreenParticles = nan(trials, 1);
            self.dotCol = struct;

            % Task-participant interaction
            self.pred = nan(trials, 1);
            self.predErr = nan(trials, 1);
            self.estErr = nan(trials, 1);
            self.diffLastOutcPred = nan(trials, 1);
            self.UP = nan(trials, 1);
            self.hit = nan(trials, 1);
            self.perf = nan(trials, 1);
            self.accPerf = nan(trials, 1);
            self.actRew = nan(trials, 1);
            self.RT = nan(trials, 1);
            self.initiationRTs = nan(trials, 1);
            self.initialTendency = nan(trials, 1);
            self.nParticlesCaught = nan(trials, 1);
            self.greenCaught = nan(trials, 1);
            self.redCaught = nan(trials, 1);
            self.RPE = nan(trials, 1);

            % EEG and pupillometry
            self.timestampOnset = nan(trials, 1);
            self.timestampPrediction = nan(trials, 1);
            self.timestampFixCross1 = nan(trials, 1);
            self.timestampFixCross2 = nan(trials, 1);
            self.timestampFixCross3 = nan(trials, 1);
            self.timestampOutcome = nan(trials, 1);
            self.timestampShield = nan(trials, 1);
            self.timestampReward = nan(trials, 1);
            self.timestampOffset = nan(trials, 1);
            self.triggers = zeros(trials, 8);

            % Stimuli
            self.rotationRad = nan;

        end

        function self = al_cannonData(self, taskParam, haz, concentration, safe)
            % AL_CANNONDATA This function generates the cannon outcomes
            %
            %   Input
            %       self: Data-object instance
            %       taskParam: Task-parameter-object instance
            %       haz: Current hazard rate
            %       concentration: Current concentration
            %       safe: Number of safe trials
            %
            %   Output
            %       self: Data-object instance


            % Provide warning when more than one concentration but not in
            % variability condition with concentration change points
            if length(concentration) > 1 && ~isequal(taskParam.trialflow.variability, 'changepoint')
                error('Too many concentration parameters');
            end

            % Initialize safe variable
            s = safe;

            % If variability condition "concentration change points",
            % extract s variable and determine which conentration comes first
            if isequal(taskParam.trialflow.variability, 'changepoint')
                sVar = taskParam.gParam.safeVar;
                concIndex = randi([1,2]);
            end

            % Generate outcomes
            % -----------------

            % Cycle over trials
            for i = 1:self.trials

                % Extract current block
                self.block(i) = indicateBlock(self, taskParam, i);

                % Sample change points
                [self, s] = generateCP(self, taskParam, haz, s, safe, i);

                % Sample variance change points when in the variability
                % change-point condition
                if isequal(taskParam.trialflow.variability, 'changepoint')
                    [self, concIndex, sVar] = generateVarCP(self, taskParam, concIndex, sVar, i);
                    self.concentration(i) = concentration(concIndex); % store current concentration
                else

                    % Otherwise, just add single concentration to data
                    self.concentration(i) = concentration;
                end

                % Draw outcome
                self.outcome(i) = self.sampleOutcome(self.distMean(i), self.concentration(i));

                % Generate catch trials
                if taskParam.gParam.useCatchTrials
                    self.catchTrial(i) = self.generateCatchTrial(taskParam.gParam.catchTrialProb, self.cp(i));
                end

                % Generate angular shield size
                if isequal(taskParam.trialflow.shield, 'variable')
                    self.allShieldSize(i) = self.getShieldSize(taskParam.gParam.shieldMin, taskParam.gParam.shieldMax, taskParam.gParam.shieldMu);
                elseif isequal(taskParam.trialflow.shield, 'variableWithSD')
                    self.allShieldSize(i) = self.getShieldSize(taskParam.gParam.shieldMin, taskParam.gParam.shieldMax, rad2deg(taskParam.circle.shieldFixedSizeFactor*sqrt(1/self.concentration(i))));
                else
                    self.allShieldSize(i) = rad2deg(taskParam.circle.shieldFixedSizeFactor*sqrt(1/self.concentration(i)));
                end

            end

            % Add hazard rate and safe variable to data
            % self.haz = repmat(haz, length(self.trials), 1);
            % self.hazVar = repmat(self.hazVar, length(self.trials), 1);
            % self.safe = repmat(safe, length(self.trials), 1);
            % self.safeVar = repmat(self.safeVar, length(self.trials), 1);
            
            self.haz = repmat(haz, self.trials, 1);
            self.hazVar = repmat(taskParam.gParam.hazVar, self.trials, 1);
            self.safe = repmat(safe, self.trials, 1);
            self.safeVar = repmat(taskParam.gParam.safeVar, self.trials, 1);

            %% Todo test this properly
            % Generate shield types
            if isequal(taskParam.trialflow.shieldType, 'constant')

                % Here all shields have the same color
                self.shieldType = ones(self.trials,1);
            else

                % If no remainder, sample sign randomly
                if mod(self.trials, 2) == 0

                    self.shieldType = Shuffle([zeros((self.trials/2),1); ones((self.trials/2),1)]);
                else

                    % Compute number of trials for each shield
                    nShield = floor(self.trials/2);

                    % Sample shield types add samples binary distribution for remainder
                    self.shieldType = Shuffle([zeros(nShield, 1); ones(nShield, 1); randsample([0, 1], 1)]);

                end
            end
        end


        function [self, s] = generateCP(self, taskParam, haz, s, safe, currTrial)
            % GENERATECP This function generates change points and
            % determines the mean of the outcome-generating distribution
            %
            %   Input
            %       self: Data-object instance
            %       taskParam: Task-parameter-object instance
            %       haz: Hazard rate
            %       s: Current safe counter (if s == 0, cps are allowed)
            %       safe: Safe criterion
            %       currTrial: Current trial
            %
            %   Output
            %       s: Update safe counter
            %

            % Sampled change points and new blocks count as change points
            if (self.sampleRand('rand') < haz && s == 0) || ismember(currTrial, taskParam.gParam.blockIndices)

                % Indicate current change point
                self.cp(currTrial) = 1;

                % Draw mean of current distribution
                self.distMean(currTrial) = round(self.sampleRand('rand').*359);

                % Take into account that in some conditions, change points can only occur after a few trials
                s = safe;

                % Reset trials after change point
                self.TAC(currTrial) = 0;
            else

                % Increase trials after change point
                self.TAC(currTrial) = self.TAC(currTrial-1) + 1;

                % Update safe criterion
                s = max([s-1, 0]);

                % Set change-point to false
                self.cp(currTrial) = 0;

                % Mean of outcome-generating distribution
                if isequal(taskParam.trialflow.distMean, 'drift')

                    % Add von Mises drift if required:
                    % We use the same function as for outcome generation
                    self.distMean(currTrial) = self.sampleOutcome(self.distMean(currTrial-1), taskParam.gParam.driftConc);

                else

                    self.distMean(currTrial) = self.distMean(currTrial-1);

                end
            end
        end


        function self = al_confettiData(self, taskParam, haz, concentration, safe)
            % AL_CONFETTI This function generates the confetti shots
            %
            %   Input
            %       self: Data-object instance
            %       taskParam: Task-parameter-object instance
            %
            %   Output
            %       self: Data-object instance


            % Check if input for asymmetric version has been provided
            if (~exist('haz', 'var') || isempty(haz)) && isequal(taskParam.trialflow.reward, 'asymmetric')
                error('haz for asymmetric version required')
            end

            if (~exist('concentration', 'var') || isempty(concentration)) && isequal(taskParam.trialflow.reward, 'asymmetric')
                error('concentration for asymmetric version required')
            end

            if (~exist('safe', 'var') || isempty(safe)) && isequal(taskParam.trialflow.reward, 'asymmetric')
                error('safe for asymmetric version required')
            elseif isequal(taskParam.trialflow.reward, 'asymmetric')

                % Initialize safe variable
                s = safe;

            end

            % Cycle over trials
            for i = 1:self.trials

                % Take common number of particles...
                self.nParticles(i) = taskParam.cannon.nParticles;

                % For asymmetric reward condition
                if isequal(taskParam.trialflow.reward, 'asymmetric')

                    % Generate reward-distribution changepoints
                    if (self.sampleRand('rand') < haz && s == 0) || i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) || i == taskParam.gParam.blockIndices(3) || i == taskParam.gParam.blockIndices(4)

                        % Indicate current reward-distribution changepoint
                        self.cpRew(i) = 1;

                        % Change reward distribution
                        if i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) || i == taskParam.gParam.blockIndices(3) || i == taskParam.gParam.blockIndices(4)

                            % At beginning of new block, randomly sample sign of distribution
                            self.asymRewardSign(i) = (-1)^randi([1,2]);

                        else
                            % Otherwise, flip sign deterministically
                            self.asymRewardSign(i) = -self.asymRewardSign(i-1);

                        end

                        % Reset safe variable for reward distribution
                        s = safe;

                    else

                        % Update "safe criterion"
                        s = max([s-1, 0]);

                        % Set reward-distribution changepoint to false...
                        self.cpRew(i) = 0;

                        % ... and take same distribution
                        self.asymRewardSign(i) = self.asymRewardSign(i-1);

                    end

                    % Confetti-particle colors
                    outcomeDeviation = al_diff(self.outcome(i), self.distMean(i));
                    self.nGreenParticles(i) = self.getParticleColor(taskParam.cannon.nParticles, outcomeDeviation, concentration, self.asymRewardSign(i));
                    self.dotCol(i).rgb = [repmat(taskParam.colors.green', 1, self.nGreenParticles(i)), repmat(taskParam.colors.red', 1, taskParam.cannon.nParticles-self.nGreenParticles(i))];

                    % For other conditions
                else

                    % ... and random colors
                    if isequal(taskParam.trialflow.colors, 'colorful')
                        self.dotCol(i).rgb = uint8(round(rand(3, taskParam.cannon.nParticles)*255));
                    elseif isequal(taskParam.trialflow.colors, 'dark')                        
                        self.dotCol(i).rgb = taskParam.colors.colorsDark;
                    elseif isequal(taskParam.trialflow.colors, 'blackWhite')
                        self.dotCol(i).rgb = taskParam.colors.colorsBlackWhite;
                    else
                        error('Color input not defined')
                    end
                end
            end
        end

        function sample = sampleRand(~, type, currMean, currConcentration)
            % SAMPLERAND This function calls functions that we use to
            % generate outcomes
            %
            %    We have a separate function for this to be able to
            %    to mock out these functions for unit testing.
            %    Currently, it does not seem to be possible to mock out
            %    functions directly:
            %    https://de.mathworks.com/matlabcentral/answers/466778-how-to-create-a-unit-testing-mocking-framework-for-function-files
            %
            %    Therefore, we create this method of the taskDataMain object,
            %    which we can mock out in Matlab.
            %
            %    Input
            %        type: Distribution from which we sample
            %        currMean: Mean of the distribution
            %        currConcentration: Concentration of the distribution
            %
            %    Output
            %        sample: Sampled value

            % Uniform distribution
            if isequal(type, 'rand')
                sample = rand;

                % Circular von Mises with adjustments to ensure samples in [0, 359]
            elseif isequal(type, 'circ_vmrnd')

                sample = circ_vmrnd(deg2rad(currMean - 180), currConcentration, 1);

                % Normal cumulative distiribution function
            elseif isequal(type, 'normcdf')

                % Concentration expressed as variance (approximation)
                GaussStd = rad2deg((1/currConcentration)^.5);
                sample = normcdf(currMean,0,GaussStd);
                
                % Exponential
            elseif isequal(type, 'exprnd')
                
                sample = exprnd(currMean);

            end
        end

        function outcome = sampleOutcome(self, currMean, currConcentration)
            % SAMPLEOUTCOME This function is used to sample an outcome given the
            % mean and concentration of a van Mises distribution
            %
            %   Input
            %       self: Data-object instance
            %       currMean: Mean of distribution
            %       currConcentration: Concentration of distribution
            %
            %   Output
            %       outcome: Sampled outcome


            % We subtract (in sampleRand function) and add 180 (here)
            % to ensure that outcomes are in range [0, 359]. The circ_vmrnd
            % function would otherwise generate negative outcomes as well
            outcome = round(180 + rad2deg(self.sampleRand('circ_vmrnd', currMean, currConcentration)));

        end

        function catchTrial = generateCatchTrial(self,catchTrialProb, cp)
            %GENERATECATCHTRIAL This function samples catch trials
            %
            %   Input
            %       self: Data-object instance
            %       catchTrialProb: Probability of a catch trial
            %       cp: Change-point index
            %
            %   Output
            %       catchTrial: Sampled catch trial

            if self.sampleRand('rand') <= catchTrialProb && cp == 0
                catchTrial = 1;
            else
                catchTrial = 0;
            end
        end

        function nGreenParticles = getParticleColor(self, currNParticles, cannonDev, currConcentration, sign)
            % GETPARTICLECOLOR This function determines the colors (red vs. green) of confetti particles
            % in the asymRewardVersion of the confetti-cannon task
            %
            %   The ratio between red and green depends on the difference between
            %   outcome and cannon aim, the concentration parameter, and the sign
            %   of the function, which can change on a changepoint.
            %
            %   The exact settings may be updated in the future. We currently use a
            %   Gaussian CDF.
            %
            %   Input
            %       self: Data-object instance
            %       currNParticles: Number of particles
            %       cannonDev: Difference cannon aim and outcome
            %       currConcentration: Current concentration
            %       sign: Sign of the reward function
            %
            %   Output
            %       nGreenParticles: Number of green particles


            % Proportion of green particles
            p = self.sampleRand('normcdf', sign*cannonDev, currConcentration);

            % Translate into number of green particles
            nGreenParticles = round(p * currNParticles);

        end


        function [self, concIndex, sVar] = generateVarCP(self, taskParam, concIndex, sVar, currTrial)
            % GENERATEVARCP This function generates variance change points
            %
            %   Input
            %       self: Data-object instance
            %       taskParam: Task-parameter-object instance
            %       concIndex: Current concentration index
            %       sVar: Safe variable for variance change point
            %       currTrial: Current trial
            %
            %   Output
            %       concIndex: Updated concentration index
            %       sVar: Updated safe variable

            if (self.sampleRand('rand') < taskParam.gParam.hazVar && sVar == 0) || currTrial == taskParam.gParam.blockIndices(1) || currTrial == taskParam.gParam.blockIndices(2) || currTrial == taskParam.gParam.blockIndices(3) || currTrial == taskParam.gParam.blockIndices(4)

                % Indicate current change point
                self.cpVar(currTrial) = 1;

                % On a change point, we take the other concentration
                concIndex = 1 + mod(concIndex, 2);

                % Take into account that change points can only occur after a few trials
                sVar = taskParam.gParam.safeVar;

                % Reset trials after variance change point
                self.TACVar(currTrial) = 0;
            else

                % Increase trials after variance change point
                self.TACVar(currTrial) = self.TACVar(currTrial-1) + 1;

                % Update safe criterion
                sVar = max([sVar-1, 0]);

                % Set changepoint to false
                self.cpVar(currTrial) = 0;

            end
        end


        function block = indicateBlock(self, taskParam, currTrial)
            %INDICATEBLOCK This function codes the current block of in the cannon task
            %
            %   Input
            %       self: Data-object instance
            %       taskParam: Task-parameter-object instance
            %       currTrial: Current trial
            %
            %   Output
            %       block: Block number

            % Compute number of blocks
            nBlocks = length(taskParam.gParam.blockIndices);

            % Compute block counter, starting from previous block
            if currTrial == 1
                blockCounter = 1;
            else
                blockCounter = self.block(currTrial-1);
            end

            % Find current block
            while true

                % First blocks
                if blockCounter <= nBlocks(end)-1 && currTrial >= taskParam.gParam.blockIndices(blockCounter) && currTrial < taskParam.gParam.blockIndices(blockCounter+1)
                    block = blockCounter;
                    break

                    % Very last block
                elseif currTrial >= taskParam.gParam.blockIndices(end)
                    block = nBlocks;
                    break
                end

                % Update block counter
                blockCounter = blockCounter+1;

            end
        end

        function angShieldSize = getShieldSize(self, minAngShieldSize, maxAngShieldSize, shieldMu)
            %GETSHIELDSIZE This function samples the current size of the shield
            % from an exponential distribution given mean and minimum and maximum
            % shield size
            %
            %   Input
            %       minAngShieldSize: Minimum angular shield size
            %       maxAngShieldSize: Maximum angular shield size
            %       shieldMu: Mean of shield size
            %
            %   Output
            %       angShieldSize: Sampled angular shield size

            % Initialize angular shield size
            angShieldSize = nan;

            % Sample shield size from exponential distribution
            while ~isfinite(angShieldSize) || angShieldSize < minAngShieldSize || angShieldSize > maxAngShieldSize
                angShieldSize = self.sampleRand('exprnd', shieldMu);
            end
        end

        function s = saveobj(self)
            % SAVEOBJ This function tranlates data that we want to save
            % into a structure
            %
            %   Background:
            %       https://www.mathworks.com/help/matlab/ref/saveobj.html

            % General variables
            s.ID = self.ID;
            s.age = self.age;
            s.gender = self.gender;
            s.date = self.date;
            s.cond = self.cond;
            s.concentration = self.concentration;
            s.haz = self.haz;
            s.cBal = self.cBal;
            s.safe = self.safe;
            s.rew = self.rew;
            s.currTrial = self.currTrial;
            s.block = self.block;
            s.allShieldSize = self.allShieldSize;
            s.actJitterOnset = self.actJitterOnset;
            s.cp = self.cp;
            s.outcome = self.outcome;
            s.distMean = self.distMean;
            s.TAC = self.TAC;
            s.catchTrial = self.catchTrial;
            s.shieldType = self.shieldType;
            s.pred = self.pred;
            s.predErr = self.predErr;
            s.estErr = self.estErr;
            %s.cannonDev = self.cannonDev;
            s.UP = self.UP;
            s.hit = self.hit;
            s.perf = self.perf;
            s.accPerf = self.accPerf;
            s.RT = self.RT;
            s.initiationRTs = self.initiationRTs;

            % Task specific
            if isequal(self.taskType, 'dresden')

               % s.rew = self.rew;
                s.group = self.group;
                s.diffLastOutcPred = self.diffLastOutcPred;
                s.actRew = self.actRew;
                s.z = self.z;
                s.y = self.y;

                s.timestampOnset = self.timestampOnset;
                s.timestampPrediction = self.timestampPrediction;
                s.timestampFixCross1 = self.timestampFixCross1;
                s.timestampFixCross2 = self.timestampFixCross2;
                s.timestampOutcome = self.timestampOutcome;
                s.timestampShield = self.timestampShield;
                s.timestampOffset = self.timestampOffset;
                s.triggers = self.triggers;

            elseif isequal(self.taskType, 'MagdeburgFMRI')

                s.z = self.z;
                s.y = self.y;

                s.timestampOnset = self.timestampOnset;
                s.timestampPrediction = self.timestampPrediction;
                s.timestampFixCross2 = self.timestampFixCross2;
                s.timestampFixCross3 = self.timestampFixCross3;
                s.timestampOutcome = self.timestampOutcome;
                s.timestampShield = self.timestampShield;
                s.timestampOffset = self.timestampOffset;

            elseif isequal(self.taskType, 'sleep')

                s.testDay = self.testDay;
                s.group = self.group;
                s.pushConcentration = self.pushConcentration;
                s.z = self.z;
                s.y = self.y;
                s.actRew = self.actRew;
                s.initialTendency = self.initialTendency;
                
                s.triggers = self.triggers;
                s.timestampOnset = self.timestampOnset;
                s.timestampPrediction = self.timestampPrediction;
                s.timestampFixCross2 = self.timestampFixCross2;
                s.timestampFixCross3 = self.timestampFixCross3;
                s.timestampOutcome = self.timestampOutcome;
                s.timestampShield = self.timestampShield;
                s.timestampOffset = self.timestampOffset;

            elseif isequal(self.taskType, 'Hamburg')

                s.group = self.group;
                s.nParticles = self.nParticles;
                s.confettiStd = self.confettiStd;
                s.dotCol = self.dotCol;
                s.initialTendency = self.initialTendency;
                s.timestampOnset = self.timestampOnset;
                s.timestampPrediction = self.timestampPrediction;
                s.actJitterOutcome = self.actJitterOutcome;
                s.actJitterShield = self.actJitterShield;

                s.timestampFixCross1 = self.timestampFixCross1;
                s.timestampFixCross2 = self.timestampFixCross2;
                s.timestampFixCross3 = self.timestampFixCross3;
                s.timestampOutcome = self.timestampOutcome;
                s.timestampShield = self.timestampShield;
                s.timestampOffset = self.timestampOffset;
                s.triggers = self.triggers;
                
                s.rotationRad = self.rotationRad;
                
            elseif isequal(self.taskType, 'HamburgEEG')

                s.group = self.group;
                s.nParticles = self.nParticles;
                s.confettiStd = self.confettiStd;
                s.dotCol = self.dotCol;
                s.initialTendency = self.initialTendency;
                % s.nParticlesCaught = self.nParticlesCaught;

                s.timestampOnset = self.timestampOnset;
                s.timestampPrediction = self.timestampPrediction;
                s.timestampShield = self.timestampShield;
                s.timestampReward = self.timestampReward;
                s.timestampFixCross1 = self.timestampFixCross1;
                s.timestampFixCross2 = self.timestampFixCross2;
                s.timestampFixCross3 = self.timestampFixCross3;
                s.timestampOffset = self.timestampOffset;

            elseif isequal(self.taskType, 'asymReward')

                s.nParticles = self.nParticles;
                s.confettiStd = self.confettiStd;
                s.cpRew = self.cpRew;
                s.asymRewardSign = self.asymRewardSign;
                s.nGreenParticles = self.nGreenParticles;
                s.dotCol = self.dotCol;
                s.initialTendency = self.initialTendency;
                s.nParticlesCaught = self.nParticlesCaught;
                s.greenCaught = self.greenCaught;
                s.redCaught = self.redCaught;
                s.RPE = self.RPE;

                s.timestampOnset = self.timestampOnset;
                s.timestampPrediction = self.timestampPrediction;
                s.timestampOutcome = self.timestampOutcome;
                s.timestampShield = self.timestampShield;
                s.timestampReward = self.timestampReward;
                s.timestampOffset = self.timestampOffset;

            elseif isequal(self.taskType, 'Leipzig')

                s.group = self.group;

            else

                %% Todo: get rid of this when everything else implemented
                s.testDay = self.testDay;
                s.group = self.group;
                s.hazVar = self.hazVar;
                s.safeVar = self.safeVar;
                s.nParticles = self.nParticles;
                s.confettiStd = self.confettiStd;
                s.pushConcentration = self.pushConcentration;
                s.startingBudget = self.startingBudget;
                s.driftConc = self.driftConc;
                s.cpVar = self.cpVar;
                s.TACVar = self.TACVar;
                s.cpRew = self.cpRew;
                s.asymRewardSign = self.asymRewardSign;
                s.nGreenParticles = self.nGreenParticles;
                s.dotCol = self.dotCol;
                s.initialTendency = self.initialTendency;
                s.nParticlesCaught = self.nParticlesCaught;
                s.greenCaught = self.greenCaught;
                s.redCaught = self.redCaught;
                s.RPE = self.RPE;

                s.timestampOnset = self.timestampOnset;
                s.timestampPrediction = self.timestampPrediction;
                s.timestampShield = self.timestampShield;
                s.timestampReward = self.timestampReward;
                s.timestampFixCross1 = self.timestampFixCross1;
                s.timestampFixCross2 = self.timestampFixCross2;
                s.timestampFixCross3 = self.timestampFixCross3;
                s.timestampOffset = self.timestampOffset;

            end
        end
    end

    % Static methods of the task-data-main object
    % -------------------------------------------

    methods(Static)

        function [whichParticlesCaught, nParticlesCaught] = getParticlesCaught(dotPredDist, shieldSize)
            % GETPARTICLESCAUGHT This function computes which and how many confetti
            % particles were caught
            %
            %   Input
            %       dotPredDist: Circular distances between particles and shield mean
            %       shieldSize: Shield size
            %
            %   Output
            %       whichParticlesCaught: Vector indicating particles caught
            %       nParticlesCaught: Number of particles caught

            % Vector indicating particles caught
            whichParticlesCaught = abs(dotPredDist) <= shieldSize/2;

            % Number of particles caught
            nParticlesCaught = sum(whichParticlesCaught);

        end
    end
end

