classdef al_taskDataMain
    %AL_TASKDATAMAIN This class definition file specifies the
    % properties of a taskDataMain object
    %
    %   The class generates task data and stores participant data

    properties

        % Number of trials
        trials % number of trials

        % Participant
        % -----------

        ID % participant ID
        age % participant age
        sex % participant sex
        date % test date
        testDay % test day
        group % subject group

        % Stable parameters
        % -----------------

        cond % current condition
        concentration % concentration of the outcome-generating distribution
        haz % hazard rate
        hazVar % variance hazard rate
        currHaz % dynamic hazard rate VWM
        rew % reward condition
        cBal % counterbalancing condition
        safe % number of safe trials without changepoints
        safeVar % number of safe trials without variability changepoints
        safeDrift % number of safe trials without drift changepoints
        nParticles % number of confetti particles in Hamburg version
        confettiStd % standard deviation of confetti particles
        pushConcentration % concentration of push manipulation
        startingBudget % start-up budget for conditions with losses
        driftConc % drift standard deviation of cannon

        % Task-generated data
        % -------------------

        currTrial % trial number
        block % block number
        allASS % all angular shield size
        actJitter % actual jitter on each trial
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
        driftState % drift state variance-working-memory pilot
        tickMark % tick-mark condition

        % Task-participant interaction
        % ----------------------------

        pred % predictoin
        predErr % prediction error
        estErr % estimation error
        cannonDev % difference mean and outcome (for asymRew) (todo:delete)
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
        timestampFixCross2
        timestampFixCross3
        timestampOutcome
        timestampShield
        timestampReward
        timestampOffset
        triggers

    end

    % Methods of the task-data-main object
    % ----------------------------------

    methods

        function self = al_taskDataMain(trials)
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

            % Participant
            self.ID = cell(trials, 1);
            self.age = nan(trials, 1);
            self.sex = cell(trials, 1);
            self.date = cell(trials, 1);
            self.testDay = nan(trials, 1);
            self.group = nan(trials, 1);

            % Stable parameters
            self.trials = trials;
            self.cond = cell(trials, 1);
            self.concentration = nan(trials, 1);
            self.haz = nan(trials, 1);
            self.hazVar = nan(trials, 1);
            self.currHaz = nan(trials, 1);
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
            self.allASS = nan(trials, 1);
            self.actJitter = nan(trials, 1);
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
            self.driftState = nan(trials, 1);
            self.tickMark = cell(trials, 1);

            % Task-participant interaction
            self.pred = nan(trials, 1);
            self.predErr = nan(trials, 1);
            self.estErr = nan(trials, 1);
            self.cannonDev = nan(trials, 1);
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
            self.timestampFixCross2 = nan(trials, 1);
            self.timestampFixCross3 = nan(trials, 1);
            self.timestampOutcome = nan(trials, 1);
            self.timestampShield = nan(trials, 1);
            self.timestampReward = nan(trials, 1);
            self.timestampOffset = nan(trials, 1);
            self.triggers = zeros(trials, 8);

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

            if ~isequal(taskParam.trialflow.shieldType, 'constant') && mod(self.trials,2) == 1
                error('This version requires an even number of trials');
            end

            % If variability condition "concentration change points",
            % extract s variable and determine which concentration comes first
            if isequal(taskParam.trialflow.variability, 'changepoint')
                sVar = taskParam.gParam.safeVar;
                concIndex = randi([1,2]);
            end

            % Create "change-point list": Determine change points
            % a priori instead of sampling them online
            if isequal(taskParam.gParam.taskType, 'VWM')
                self = offlineCps(self, taskParam, safe); 
            else
                % Initialize safe variable for online change-point generation
                s = safe;
            end

            % Offline distribution means for variance-working-memory version
            if isequal(taskParam.gParam.taskType, 'VWM')
                self = offlineDistMeans(self, taskParam);
            end

            % Generate outcomes
            % -----------------

            % Cycle over trials
            for i = 1:self.trials

                % Extract current block
                self.block(i) = indicateBlock(self, taskParam, i);

                % Sample online change points in all versions except VWM
                if ~isequal(taskParam.gParam.taskType, 'VWM')
                    [self, s] = generateCP(self, taskParam, haz, s, safe, i);
                end

                % Sample variance change points when in the variability-
                % change-point condition
                if isequal(taskParam.trialflow.variability, 'changepoint')
                    
                    if self.driftState(i) == 0
                        [self, concIndex, sVar] = generateVarCP(self, taskParam, concIndex, sVar, i);
                    end
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
                    self.allASS(i) = self.getShieldSize(taskParam.gParam.minASS, taskParam.gParam.maxASS, taskParam.gParam.mu);
                else
                    self.allASS(i) = rad2deg(taskParam.circle.shieldFixedSizeFactor*sqrt(1/self.concentration(i)));
                end

            end

            % Add hazard rate and safe variable to data
            % Todo: ensure that this is updated in main branch as well
            self.haz = repmat(haz, self.trials, 1);
            self.hazVar = repmat(taskParam.gParam.hazVar, self.trials, 1);
            self.safe = repmat(safe, self.trials, 1);
            self.safeVar = repmat(taskParam.gParam.safeVar, self.trials, 1);
            self.safeDrift = repmat(taskParam.gParam.safeDrift, self.trials, 1);
            self.tickMark = repmat(taskParam.trialflow.currentTickmarks, self.trials, 1);

            % Generate shield types
            if isequal(taskParam.trialflow.shieldType, 'constant')

                % Here all shields have the same color
                self.shieldType = ones(self.trials,1);
            else
                self.shieldType = Shuffle([zeros((self.trials/2),1); ones((self.trials/2),1)]);
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
            %       self: Data-object instance
            %       s: Update safe counter


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

                % Set change point to false
                self.cp(currTrial) = 0;

                % Mean of outcome-generating distribution
                if isequal(taskParam.trialflow.distMean, 'drift')

                    % Add von Mises drift if required:
                    % We use the same function as for outcome generation
                    self.distMean(currTrial) = self.sampleOutcome(self.distMean(currTrial-1), taskParam.gParam.driftConc);
                    self.driftConc(currTrial) = taskParam.gParam.driftConc; % store current value
                else

                    self.distMean(currTrial) = self.distMean(currTrial-1);

                end
            end
        end


        function self = offlineCps(self, taskParam, safe)
            % OFFLINECPS This function generates all change points offline
            %
            %   The idea is that we fist generate when change points occur,
            %   to then generate the magnitude of these change points in
            %   a separate function (offlineDistMeans). That way, we can
            %   achieve more "uniform-like" change-point distributions with
            %   limited tials.
            %
            %   Input
            %       self: Data-object instance
            %       taskParam: Task-parameter-object instance
            %       safe: Safe criterion
            %
            %   Output
            %       self: Data-object instance


            % Initialize safe variable for offline change-point generation
            s = safe;

            % Initialize "trials-after safe" (tas) variable:
            % tas starts counting after safe criterion has been reached
            % (e.g., after 8 trials when safe = 8)
            tas = 0;

            % Cycle over trials
            for i = 1:self.trials

                % Compute current value of dynamic hazard rate
                [self, self.currHaz(i), s, tas] = dynamicHazardRate(self, s, tas);

                % Sampled change points and new blocks count as change points
                if (self.sampleRand('rand') < self.currHaz(i)) || ismember(i, taskParam.gParam.blockIndices)

                    % Indicate current change point
                    self.cp(i) = 1;

                    % Take into account that in some conditions, change points can only occur after a few trials
                    s = safe;

                    % Reset trials after change point
                    self.TAC(i) = 0;

                else

                    % Indicate current change point
                    self.cp(i) = 0;

                    % Increase trials after change point
                    self.TAC(i) = self.TAC(i-1) + 1;

                end
            end
        end


        function [self, currHaz, s, tas] = dynamicHazardRate(self, s, tas)
            % DYNAMICHAZARDRATE This function computes the dynamic hazard
            % rate for offline data generation
            %
            %   The idea is that the hazard rate currHaz = 0 as long as we
            %   are below the safe criterion (and tas = 0). When we are
            %   above safe criterion, the dynamic hazard rate increases,
            %   and so does tas.
            %
            %   Input
            %       self: Data-object instance
            %       s: Current safe value determining when change points are possible
            %       tas: "Trials-after-safe" value
            %
            %   Output
            %       self: Data-object instance
            %       currHaz: Current hazard rate
            %       s: Updated safe value
            %       tas: Updated "trials-after-safe" value


            % Dynamic hazard rate and tas = 0 as long as s below criterion
            if s > 0
                currHaz = 0;
                tas = 0;

                % When s below criterion, hazard rate increases and so does tas
            else
                tas = tas + 1;
                currHaz = 1 - (1/(tas+1));
            end

            % Update safe criterion
            s = max([s-1, 0]);

        end


        function self = offlineDistMeans(self, taskParam)
            % OFFLINEDISTMEANS This function computes the means of the
            % outcome distribution a priori
            %
            %   The function works in two modes:
            %       1. Mean-change-point condition
            %       2. Drift-change-point condition
            %
            %   1. Mean-change-point condition:
            %      The distribution means are more balanced than a fully
            %      random generation based on the uniform distribution. We
            %      have three bins of mean differences (w.r.t to last mean):
            %
            %       1. mean difference in [0, 59]
            %       2. mean difference in [60, 119]
            %       3. mean difference in [120, 170]
            %
            %      Moreover, the sign of the difference is randomly positive
            %      or negative
            %
            %      The function accounts for the number of trials: When the
            %      number of trials cannot be divided into 3 bins with an equal
            %      number of trials (e.g., 100 trials where remainder in division
            %      with remainder would be 1).
            %
            %   2. Drift-change-point condition
            %      Switch between stable (drift state 0) and drifting 
            %      (drift state 1) state  

            % 1. Mean-change-point condition
            % ------------------------------

            if ~isequal(taskParam.trialflow.distMean, 'drift')

                % Compute shifts in distribution means
                % ------------------------------------

                % Compute number of trials per bin
                nMeans = floor(self.trials/3);

                % Compute remainder
                rest = mod(self.trials, 3);

                % Sample means from low, mid, and high bins and add samples
                % from uniform for remainder
                distMeanShifts = [randi([0,59], nMeans,1); randi([60,119], nMeans,1); randi([120,179], nMeans,1); randi([0, 179], rest, 1)];

                % Shuffle means
                distMeanShifts = Shuffle(distMeanShifts);

                % Compute sign of shift
                % ---------------------

                % Compute number of equally sized bins
                nBins = floor(self.trials/2);

                % If no remainder, sample sign randomly
                if mod(self.trials, 2) == 0
                    sign = Shuffle([ones(nBins,1); -ones(nBins,1)]);

                    % If with remainder, add remainder sample
                else
                    sign = Shuffle([ones(nBins,1); -ones(nBins,1); randsample([-1, 1], 1) ]);
                end

                % Combine mean differences and signs
                % ----------------------------------

                distMeanShifts = distMeanShifts .* sign;

                % Cycle over trials to determine distibution means
                for i = 1:self.trials

                    % Stable drift state when sampling stable means
                    self.driftState(i) = 0;

                    % Sample first mean
                    if i == 1
                        self.distMean(i) = round(self.sampleRand('rand').*359);

                        % Sample all other means taking into account
                        % sampled differences
                    elseif i > 1

                        % Add mean differences to current means
                        if self.cp(i)
                            self.distMean(i) = self.circleOperation(self.distMean(i-1), distMeanShifts(i));

                            % Take previous mean for no-change-point trials
                        else
                            self.distMean(i) = self.distMean(i-1);
                        end
                    end
                end
            else

                % 2. Drift-change-point condition
                % -------------------------------

                % Sample first drift state at random
                self.driftState(1) = randi([0,1]);

                % Cycle over trials to determine distibution means
                for i = 1:self.trials

                    % Sample first mean
                    if i == 1
                        self.distMean(i) = round(self.sampleRand('rand').*359);

                        % Sample all other means
                    elseif i > 1

                        % On change point, we switch the drift state
                        if self.cp(i)
                            self.driftState(i) = 1 - self.driftState(i-1);
                        else
                            self.driftState(i) = self.driftState(i-1);
                        end

                        % If drift state 0, we have drifting mean
                        if self.driftState(i) == 1

                            % Add von Mises drift if required:
                            % We use the same function as for outcome generation
                            self.distMean(i) = self.sampleOutcome(self.distMean(i-1), taskParam.gParam.driftConc);

                            % In drift state 1, outcome mean is stable
                        else
                            self.distMean(i) = self.distMean(i-1);
                        end
                    end
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
                    self.dotCol(i).rgb = [repmat(taskParam.colors.green, 1, self.nGreenParticles(i)), repmat(taskParam.colors.red, 1, taskParam.cannon.nParticles-self.nGreenParticles(i))];

                    % For other conditions
                else

                    % ... and random colors
                    self.dotCol(i).rgb = uint8(round(rand(3, taskParam.cannon.nParticles)*255));

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
            %       self: Data-object instance
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

    end

    % Static methods of the taskDataMain object
    % -----------------------------------------

    methods(Static)

        function angShieldSize = getShieldSize(minAngShieldSize, maxAngShieldSize, shieldMu)
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
                angShieldSize = exprnd(shieldMu);
            end
        end


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


        function result = circleOperation(value, change)
            % CIRCLEOPERATIOM This function performs addition or
            % subtraction on a circle
            %
            % Input
            %   value: Starting angle (should be in the range [0, 359])
            %   change: The amount to add or subtract from the starting angle
            %
            % Output
            %   result: The resulting angle, wrapped within the range [0, 359]

            if change >= 0
                % Perform addition and wrap the result
                result = mod(value + change, 360);
            elseif change <0
                % Perform subtraction and wrap the result
                % We add 360 before mod to avoid negative results
                result = mod(value + change + 360, 360);
            end
        end

    end
end

