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
        rew % reward condition
        cBal % counterbalancing condition
        safe % number of safe trials without changepoints
        nParticles % number of confetti particles in Hamburg version
        confettiStd % standard deviation of confetti particles
        pushConcentration % concentration of push manipulation
        startingBudget % start-up budget for conditions with losses

        % Task-generated data
        % -------------------

        currTrial % trial number
        block % block number
        allASS % all angular shield size
        actJitter % actual jitter on each trial
        cp % changepoint index
        cpRew % reward-distribution-changepoint index
        outcome % current outcome
        distMean % mean of outcome-generating distribution
        TAC % trials after changepoint
        catchTrial % catch-trial index
        shieldType % Current shield type
        z % Default shield location
        y % Push magnitude
        asymRewardSign % reward sign in asymReward version
        nGreenParticles % number of green particles
        dotCol % color of confetti particles

        % Task-participant interaction
        % ----------------------------

        pred % predictoin
        predErr % prediction error
        estErr % estimation error
        cannonDev % difference mean and outcome (for asymRew)
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

    % Methods of the taskDataMain object
    % ----------------------------------

    methods

        function self = al_taskDataMain(trials)
            % al_taskDataMain This function creates a data object of
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
            self.date = cell(trials, 1); % achtung war vorher groß geschrieben!
            self.testDay = nan(trials, 1);
            self.group = nan(trials, 1);

            % Stable parameters
            self.trials = trials;
            self.cond = cell(trials, 1);
            self.concentration = nan(trials, 1);
            self.haz = nan(trials, 1);
            self.rew = nan(trials, 1);
            self.cBal = nan(trials, 1);
            self.safe = nan(trials, 1);
            self.nParticles = nan(trials, 1);
            self.confettiStd = nan(trials, 1);
            self.pushConcentration = nan(trials, 1);
            self.startingBudget = nan(trials, 1);

            % Task-generated data
            self.currTrial = nan(trials, 1);
            self.block = nan(trials, 1);
            self.allASS = nan(trials, 1);
            self.actJitter = nan(trials, 1);
            self.cp = nan(trials, 1);
            self.cpRew = nan(trials, 1);
            self.outcome = nan(trials, 1);
            self.distMean = nan(trials, 1);
            self.TAC = nan(trials, 1);
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
            % AL_CANNON This function generates the cannon outcomes
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


            % Initialize safe variable
            s = safe;

            % Generate outcomes for CP condition
            % ----------------------------------

            % Cycle over trials
            for i = 1:self.trials

                self.block(i) = self.indicateBlock(taskParam, i);

                % Generate changepoints   todo: haz ist hier noch nicht für
                % jeden trial
                if (self.sampleRand('rand') < haz && s == 0) || i == taskParam.gParam.blockIndices(1) || i == taskParam.gParam.blockIndices(2) || i == taskParam.gParam.blockIndices(3) || i == taskParam.gParam.blockIndices(4)

                    % Indicate current change point
                    self.cp(i) = 1;

                    % Draw mean of current distribution
                    mean = round(self.sampleRand('rand').*359);

                    % Take into account that on some conditions changepoints can only occur after a few trials
                    s = safe;

                    % Reset trials after change point
                    self.TAC(i) = 0;
                else

                    % Increase trials after change point
                    self.TAC(i) = self.TAC(i-1) + 1;

                    % Update "safe criterion"
                    s = max([s-1, 0]);

                    % Set changepoint to false
                    self.cp(i) = 0;

                end

                % Draw outcome
                self.outcome(i) = self.sampleOutcome(mean, concentration);

                % Save actual mean
                self.distMean(i) = mean;

                % Generate catch trials
                if taskParam.gParam.useCatchTrials
                    self.catchTrial(i) = self.generateCatchTrial(taskParam.gParam.catchTrialProb, self.cp(i));
                end

                % Generate angular shield size
                if isequal(taskParam.trialflow.shield, 'variable')
                    self.allASS(i) = self.getShieldSize(taskParam.gParam.minASS, taskParam.gParam.maxASS, taskParam.gParam.mu);
                else
                    self.allASS(i) = rad2deg(taskParam.circle.shieldFixedSizeFactor*sqrt(1/concentration));
                end

            end

            % Add hazard rate, concentration, and safe variable to data
            self.haz = repmat(haz, length(self.trials), 1);
            self.concentration = repmat(concentration, length(self.trials), 1);
            self.safe = repmat(safe, length(self.trials), 1);  % todo: ensure that "safe" is not part of gParam anymore

            % Generate shield types
            if isequal(taskParam.trialflow.shieldType, 'constant')

                % Here all shields have the same color
                self.shieldType = ones(self.trials,1);
            else
                % Todo: implement warning if trial cannot be divided by 2
                self.shieldType = Shuffle([zeros((self.trials/2),1); ones((self.trials/2),1)]);
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

                    % Todo: this should be done with al_diff!!
                    %outcomeDeviation = self.outcome(i) - self.distMean(i);
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
            %       currMean: mean of distribution
            %       currConcentration: concentration of distribution
            %
            %   Output
            %       outcome: sampled outcome
        

            % We subtract (in sampleRand function) and add 180 (here)
            % to ensure that outcomes are in range [0, 359]. The circ_vmrnd
            % function would otherwise generate negative outcomes as well
            outcome = round(180 + rad2deg(self.sampleRand('circ_vmrnd', currMean, currConcentration)));

        end

         function catchTrial = generateCatchTrial(self,catchTrialProb, cp)
            %GENERATECATCHTRIAL This function samples catch trials
            %
            %   Input
            %       catchTrialProb: Probability of a catch trial
            %       cp: Changepoint index
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
    end

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

        function block = indicateBlock(taskParam, currTrial)
        %INDICATEBLOCK This function codes the current block of in the cannon task
        %
        %   Input
        %       taskParam: Task-parameter-object instance
        %       currTrial: Current trial
        %
        %   Output
        %       block: Block number
        
            if currTrial >= taskParam.gParam.blockIndices(1) && currTrial < taskParam.gParam.blockIndices(2)
                block = 1;
            elseif currTrial >= taskParam.gParam.blockIndices(2) && currTrial < taskParam.gParam.blockIndices(3)
                block = 2;
            elseif currTrial >= taskParam.gParam.blockIndices(3) && currTrial < taskParam.gParam.blockIndices(4)
                block = 3;
            elseif currTrial >= taskParam.gParam.blockIndices(4)
                block = 4;
            end
        end 

       function [whichParticlesCaught, nParticlesCaught] = getParticlesCaught(dotPredDist, shieldSize)
            % GETPARTICLESCAUGHT This function computes which and how many confetti
            % particles are caught
            %
            %   Input
            %       dotPredDist: Distances between particles and shield mean
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

