classdef al_testTaskDataMain < matlab.mock.TestCase
    %AL_TESTTASKDATAMAIN This class definition file specifies the
    %unit tests for the al_testTaskDataMain class

    methods (Test)

        function testCannonData(testCase)
            % TESTCANNONDATA This function tests the function that
            % generates the main outcomes related to the cannon

            % Control random number for reproducible results
            rng('default')

            % Number of trials in the test
            trials = 200;

            % TaskData-object instance
            taskData = al_taskDataMain(trials, 'Hamburg');

            % Initialize general task parameters
            gParam = al_gparam();
            gParam.blockIndices = [1 101 999 999]; % breaks
            gParam.useCatchTrials = true; % turn catch trials on
            gParam.catchTrialProb = 0.1; % catch-trial probability

            % Trialflow-object instance
            trialflow = al_trialflow();
            trialflow.shield = 'variable'; % use variable shield size

            % TaskParam object that harbors all relevant object instances
            taskParam = al_objectClass();
            taskParam.gParam = gParam;
            taskParam.trialflow = trialflow;

            % Definition of task parameters
            haz = 0.125; % hazard rate
            safe = 3; % safe trials without changepoints
            concentration = 8; % concentration parameter

            % Generate outcomes using cannonData function
            taskData = taskData.al_cannonData(taskParam, haz, concentration, safe);

            % Load expected outcomes from previous functions
            testData = load('testChangepoint.mat');
            testData = testData.taskData;

            % Compare relevant variables
            % --------------------------

            % Mean of distribution
            testCase.verifyEqual(taskData.distMean, testData.distMean);

            % Outcomes
            testCase.verifyEqual(taskData.outcome, testData.outcome);

            % Shield size
            testCase.verifyEqual(taskData.allShieldSize, testData.allShieldSize);

            % Changepoints
            testCase.verifyEqual(taskData.cp, testData.cp);

            % Trials after changepoint
            testCase.verifyEqual(taskData.TAC, testData.TAC);

            % Catch trials
            testCase.verifyEqual(taskData.catchTrial, testData.catchTrial);

            % Shield type
            testCase.verifyEqual(taskData.shieldType, testData.shieldType);

        end

        function testConfettiDataStandard(testCase)
            % TESTALCONFETTIDATA This function tests the function that
            % generates the confetti data

            % Control random number for reproducible results
            rng('default')

            % Number of trials in the test
            trials = 200;

            % TaskData-object instance
            taskData = al_taskDataMain(trials, 'Hamburg');

            % Initialize general task parameters
            gParam = al_gparam();
            gParam.blockIndices = [1 101 999 999]; % breaks

            % Trialflow-object instance
            trialflow = al_trialflow();
            trialflow.reward = 'standard'; % standard condition

            % Cannon-object instance
            cannon = al_cannon(false);
            cannon.nParticles = 40;

            % TaskParam object that harbors all relevant object instances
            taskParam = al_objectClass();
            taskParam.gParam = gParam;
            taskParam.trialflow = trialflow;
            taskParam.cannon = cannon;

            % Generate outcomes using confettiData function
            taskData = taskData.al_confettiData(taskParam);

            % save('DataScripts/unitTest_TaskDataStandard','taskData')

            % Load expected outcomes from previous functions
            testData = load('unitTest_TaskDataStandard.mat');
            testData = testData.taskData;

            % Compare relevant variables
            % --------------------------

            % Number of particles
            testCase.verifyEqual(taskData.nParticles, testData.nParticles);

            % Color of particles
            testCase.verifyEqual(taskData.dotCol, testData.dotCol);

        end

        function testConfettiDataAsymmetric(testCase)
            % TESTALCONFETTIDATAASYMMETRIC This function tests the function that
            % generates the confetti data in the asymmetric version by
            % Jan Gläscher

            % Control random number for reproducible results
            rng('default')

            % Number of trials in the test
            trials = 200;

            % TaskData-object instance
            taskData = al_taskDataMain(trials, 'Hamburg');

            % Initialize general task parameters
            gParam = al_gparam();
            gParam.blockIndices = [1 101 999 999]; % breaks
            gParam.useCatchTrials = true; % turn catch trials on
            gParam.catchTrialProb = 0.1; % catch-trial probability

            % Trialflow-object instance
            trialflow = al_trialflow();
            trialflow.shield = 'variable'; % use variable shield size
            trialflow.reward = 'asymmetric'; % asymmetric rewards

            % Cannon-object instance
            cannon = al_cannon(false);
            cannon.nParticles = 40;

            % TaskParam object that harbors all relevant object instances
            taskParam = al_objectClass();
            taskParam.gParam = gParam;

            % Color-object instance
            colors = al_colors();

            % TaskParam object that harbors all relevant object instances
            taskParam = al_objectClass();
            taskParam.gParam = gParam;
            taskParam.trialflow = trialflow;
            taskParam.cannon = cannon;
            taskParam.colors = colors;

            % Definition of task parameters
            haz = 0.125; % hazard rate
            safe = 3; % safe trials without changepoints
            concentration = 8; % concentration parameter

            % Generate outcomes using cannonData function
            taskData = taskData.al_cannonData(taskParam, haz, concentration, safe);

            % Generate outcomes using confettiData function
            taskData = taskData.al_confettiData(taskParam, haz, concentration, safe);

            % save('Methods/unitTest_TaskDataAsymmetric','taskData')

            % Load expected outcomes from previous functions
            testData = load('unitTest_TaskDataAsymmetric.mat');
            testData = testData.taskData;

            % Compare relevant variables
            % --------------------------

            % Number of particles
            testCase.verifyEqual(taskData.nParticles, testData.nParticles);

            % Number of green particles
            testCase.verifyEqual(taskData.nGreenParticles, testData.nGreenParticles);

            % Color of particles
            testCase.verifyEqual(taskData.dotCol, testData.dotCol);

        end

        function testGenerateCP(testCase)
            % TESTGENERATECP This function tests the function that
            % generates the change points
            %
            %   We're mocking out the sampleRand function to control
            %   the random number generation. More information on
            %   mocking in Matlab here:
            %   https://de.mathworks.com/help/matlab/ref/matlab.mock.testcase.createmock.html


            % Create a mock function for sampleRand
            [mock, behavior] = testCase.createMock(?al_taskDataMain, "MockedMethods", "sampleRand", "constructorInputs", {123, 'Hamburg'});

            % Test if mock works: Output should be 10 when sampleRand is
            % called
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 10)
            testCase.verifyEqual(mock.sampleRand, 10);

            % ------------------
            % Run relevant tests
            % ------------------

            % Change point first trial
            % ------------------------

            taskParam.gParam.blockIndices = 1;
            haz = 0.1;
            s = 0;
            safe = 3;
            currTrial = 1;
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 0.0)

            % First trial
            [self, s] = mock.generateCP(taskParam, haz, s, safe, currTrial);

            % Test outcome
            testCase.verifyEqual(self.cp(1), 1);
            testCase.verifyEqual(s, 3);
            testCase.verifyEqual(self.TAC(1), 0);
            testCase.verifyEqual(self.distMean(1), 0)

            % Change point regular trial
            % --------------------------

            taskParam.gParam.blockIndices = 2;
            s = 0;
            safe = 3;
            currTrial = 1;
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 0.0)

            % First trial
            [self, s] = mock.generateCP(taskParam, haz, s, safe, currTrial);

            % Test outcome
            testCase.verifyEqual(self.cp(1), 1);
            testCase.verifyEqual(s, 3);
            testCase.verifyEqual(self.TAC(1), 0);
            testCase.verifyEqual(self.distMean(1), 0)

            % No change point because random number too high
            % ----------------------------------------------

            taskParam.gParam.blockIndices = 1;
            taskParam.trialflow.distMean = 'fixed';
            s = 3;
            safe = 3;
            currTrial = 2;
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 0.5)
            mock.TAC(1) = 3;
            mock.distMean(1) = 10;

            [self, s] = mock.generateCP(taskParam, haz, s, safe, currTrial);

            % Test outcome
            testCase.verifyEqual(self.cp(2), 0);
            testCase.verifyEqual(s, 2);
            testCase.verifyEqual(self.TAC(2), 4);
            testCase.verifyEqual(self.distMean(2), 10)

            % No change point because s != 0
            % ------------------------------

            taskParam.gParam.blockIndices = 1;
            taskParam.trialflow.distMean = 'fixed';
            s = 3;
            safe = 3;
            currTrial = 2;
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 0.01)
            mock.TAC(1) = 3;
            mock.distMean(1) = 10;

            [self, s] = mock.generateCP(taskParam, haz, s, safe, currTrial);

            % Test outcome
            testCase.verifyEqual(self.cp(2), 0);
            testCase.verifyEqual(s, 2);
            testCase.verifyEqual(self.TAC(2), 4);
            testCase.verifyEqual(self.distMean(2), 10)

        end

        function testAngShieldSize(testCase)
            % TESTANGSHIELDSIZE This function tests the function that
            % generates the random shield size
            %
            %   We're mocking out the exprnd function to control
            %   the random number generation. More information on
            %   mocking in Matlab here:
            %   https://de.mathworks.com/help/matlab/ref/matlab.mock.testcase.createmock.html


            % Create a mock function for sampleRand
            [mock, behavior] = testCase.createMock(?al_taskDataMain, "MockedMethods", "sampleRand", "constructorInputs", {123, 'Hamburg'});

            % Test if mock works: Output should be 10 when sampleRand is
            % called
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 10)
            testCase.verifyEqual(mock.sampleRand, 10);

            % ------------------
            % Run relevant tests
            % ------------------
            
            % Number in correct range
            % -----------------------

            minAngShieldSize = 10;
            maxAngShieldSize = 150;
            shieldMu = 10; 
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 140)
            angShieldSize = mock.getShieldSize(minAngShieldSize, maxAngShieldSize, shieldMu);
            testCase.verifyEqual(angShieldSize, 140);

            % Test case where too large number is initially sampled (170),
            % and the good number (150)
            % -----------------------------------------------------------
            minAngShieldSize = 10;
            maxAngShieldSize = 150;
            shieldMu = 10; 
           
            % Import the mocking framework invoke
            import matlab.mock.actions.Invoke 
          
            % Define the specific outputs
            specificOutputs = [170, 150];

            % Create a function handle that manages call count and outputs
            getNextOutput = al_createOutputFunction(specificOutputs);

            % Use Invoke with the function handle to get the next output
            when(withAnyInputs(behavior.sampleRand), Invoke(@(varargin) getNextOutput()));           
                        
            angShieldSize = mock.getShieldSize(minAngShieldSize, maxAngShieldSize, shieldMu);
            testCase.verifyEqual(angShieldSize, 150);
            
            % Test case where too large number is initially sampled (170),
            % and the good number (150)
            % ------------------------------------------------------------

            % Define the specific outputs
            specificOutputs = [0, 30];

            % Create a function handle that manages call count and outputs
            getNextOutput = al_createOutputFunction(specificOutputs);

            % Use Invoke with the function handle to get the next output
            when(withAnyInputs(behavior.sampleRand), Invoke(@(varargin) getNextOutput()));

            angShieldSize = mock.getShieldSize(minAngShieldSize, maxAngShieldSize, shieldMu);
            testCase.verifyEqual(angShieldSize, 30);
            
        end


        function testGenerateCatchTrial(testCase)
            % TESTGENERATECATCHTRIAL This function tests the function that
            % generates the catch trials
            %
            %   We're mocking out the sampleRand function to control
            %   the random number generation. More information on
            %   mocking in Matlab here:
            %   https://de.mathworks.com/help/matlab/ref/matlab.mock.testcase.createmock.html


            % Create a mock function for sampleRand
            [mock, behavior] = testCase.createMock(?al_taskDataMain, "MockedMethods", "sampleRand", "constructorInputs", {123, 'Hamburg'});

            % Test if mock works: Output should be 10 when sampleRand is
            % called
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 10)
            testCase.verifyEqual(mock.sampleRand, 10);

            % Run relevant tests
            % ------------------

            catchTrialProb = 0.1;
            cp = 0;

            % Simulate sample = 0.5 (catch trial)
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 0.5)
            catchTrial = mock.generateCatchTrial(catchTrialProb, cp);

            % Test outcome
            testCase.verifyEqual(catchTrial, 0);

            % Simulate sample = 0.01 (no catch trial)
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 0)
            catchTrial = mock.generateCatchTrial(catchTrialProb, cp);

            % Test outcome
            testCase.verifyEqual(catchTrial, 1);

            % Simulate sample = 0.5 and cp (no catch trial)
            cp = 1;
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 0.5)
            catchTrial = mock.generateCatchTrial(catchTrialProb, cp);

            % Test outcome
            testCase.verifyEqual(catchTrial, 0);

        end

        function testSampleOutcome(testCase)
            % TESTSAMPLEOUTCOME This function tests the function that
            % samples the outcomes
            %
            %   We're also mocking out the sampleRand function to control
            %   the random number generation.

            % Create a mock function for sampleRand
            [mock, behavior] = testCase.createMock(?al_taskDataMain, "MockedMethods", "sampleRand", "constructorInputs", {123, 'Hamburg'});

            % Simulate sample = 1
            % -------------------
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 1)

            % Call function with nan input (bc sampling function is mocked out)
            outcome = mock.sampleOutcome(nan, nan);

            % Test outcome
            testCase.verifyEqual(outcome, 237);

            % Simulate sample = 0
            % -------------------
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), 0)

            % Call function with nan input (bc sampling function is mocked out)
            outcome = mock.sampleOutcome(nan, nan);

            % Test outcome
            testCase.verifyEqual(outcome, 180);

            % Simulate sample = pi
            % --------------------
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), pi)

            % Call function with nan input (bc sampling function is mocked out)
            outcome = mock.sampleOutcome(nan, nan);

            % Test outcome
            testCase.verifyEqual(outcome, 360);

            % Simulate sample = deg2rad(359-180) = 3.1241
            % -------------------------------------------
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand), deg2rad(359-180))

            % Call function with nan input (bc sampling function is mocked out)
            outcome = mock.sampleOutcome(nan, nan);

            % Test outcome
            testCase.verifyEqual(outcome, 359);

            % Simulate sample = deg2rad(0-180) = -3.1416
            % -------------------------------------------
            testCase.assignOutputsWhen(withAnyInputs(behavior.sampleRand),  deg2rad(0-180))

            % Call function with nan input (bc sampling function is mocked out)
            outcome = mock.sampleOutcome(nan, nan);

            % Test outcome
            testCase.verifyEqual(outcome, 0);

        end

        function testIndicateBlock(testCase)
            % TESTINDICATEBLOCK This function tests the function that
            % samples the outcomes

            % TaskData-object instance
            taskData = al_taskDataMain(200, 'Hamburg');

            % Initialize general task parameters
            gParam = al_gparam();
            gParam.blockIndices = [1 51 101 151]; % breaks

            % TaskParam object that harbors all relevant object instances
            taskParam = al_objectClass();
            taskParam.gParam = gParam;

            % Block 1
            % -------
            currTrial = 10;
            taskData.block(currTrial-1) = 1;
            block = taskData.indicateBlock(taskParam, currTrial);

            % Test outcome
            testCase.verifyEqual(block, 1);

            % Block 2
            % -------
            currTrial = 60;
            taskData.block(currTrial-1) = 2;
            block = taskData.indicateBlock(taskParam, currTrial);

            % Test outcome
            testCase.verifyEqual(block, 2);

            % Block 3
            % -------
            currTrial = 120;
            taskData.block(currTrial-1) = 3;
            block = taskData.indicateBlock(taskParam, currTrial);

            % Test outcome
            testCase.verifyEqual(block, 3);

            % Block 4
            % -------
            currTrial = 199;
            taskData.block(currTrial-1) = 4;
            block = taskData.indicateBlock(taskParam, currTrial);

            % Test outcome
            testCase.verifyEqual(block, 4);

        end

        function testGetParticleColor(testCase)
            % TESTGETPARTICLECOLOR This function tests the function that
            % computes confetti colors in the asymmetric-reward version
            % by Jan Gläscher

            % TaskData-object instance
            taskData = al_taskDataMain(200, 'Hamburg');

            % Define number of particles and concentration
            currNParticles = 40;
            currConcentration = 8;

            % Equal number of green and red and positive sign
            % -----------------------------------------------
            sign = 1;
            cannonDev = 0;
            nGreenParticles = taskData.getParticleColor(currNParticles, cannonDev, currConcentration, sign);

            % Test outcome
            testCase.verifyEqual(nGreenParticles, 20);

            % Equal number of green and red and negative sign
            % -----------------------------------------------
            sign = -1;
            cannonDev = 0;
            nGreenParticles = taskData.getParticleColor(currNParticles, cannonDev, currConcentration, sign);

            % Test outcome
            testCase.verifyEqual(nGreenParticles, 20);

            % Only green when positive sign
            % -----------------------------
            cannonDev = 180;
            sign = 1;
            nGreenParticles = taskData.getParticleColor(currNParticles, cannonDev, currConcentration, sign);

            % Test outcome
            testCase.verifyEqual(nGreenParticles, 40);

            % No green when positive sign
            % ---------------------------
            cannonDev = -180;
            sign = 1;
            nGreenParticles = taskData.getParticleColor(currNParticles, cannonDev, currConcentration, sign);

            % Test outcome
            testCase.verifyEqual(nGreenParticles, 0);

            % No green when negative sign
            % ---------------------------
            cannonDev = 180;
            sign = -1;
            nGreenParticles = taskData.getParticleColor(currNParticles, cannonDev, currConcentration, sign);

            % Test outcome
            testCase.verifyEqual(nGreenParticles, 0);

            % Only green when positive sign
            % -----------------------------
            cannonDev = 180;
            sign = 1;
            nGreenParticles = taskData.getParticleColor(currNParticles, cannonDev, currConcentration, sign);

            % Test outcome
            testCase.verifyEqual(nGreenParticles, 40);

            % Mix of colors positive sign
            % ---------------------------
            sign = 1;
            cannonDev = 10;
            nGreenParticles = taskData.getParticleColor(currNParticles, cannonDev, currConcentration, sign);

            % Test outcome
            testCase.verifyEqual(nGreenParticles, 28);

            % Mix of colors positive sign
            % ---------------------------
            sign = 1;
            cannonDev = -10;
            nGreenParticles = taskData.getParticleColor(currNParticles, cannonDev, currConcentration, sign);

            % Test outcome
            testCase.verifyEqual(nGreenParticles, 12);

            % Mix of colors negative sign
            % ---------------------------
            sign = -1;
            cannonDev = 10;
            nGreenParticles = taskData.getParticleColor(currNParticles, cannonDev, currConcentration, sign);

            % Test outcome
            testCase.verifyEqual(nGreenParticles, 12);

            % Mix of colors negative sign
            % ---------------------------
            sign = -1;
            cannonDev = -10;
            nGreenParticles = taskData.getParticleColor(currNParticles, cannonDev, currConcentration, sign);

            % Test outcome
            testCase.verifyEqual(nGreenParticles, 28);

        end

        function testGetParticlesCaughPartial(testCase)
            %TEST_GETPARTICLESCAUGHTPARTIAL This function tests the function
            % which computes which particles are caught in the shield
            %
            %   Here we test the case where some particles are caught

            % TaskData-object instance
            taskData = al_taskDataMain(123, 'Hamburg');

            % Control random number generator
            rng(1)

            % Confetti parameters
            nParticles = 10;
            confettiStd = 10;
            outcome = 45;
            pred = 45;
            shieldSize = 10;

            % Random angle for each particle (degrees) conditional on outcome and confetti standard deviation
            spread_wide = normrnd(outcome, confettiStd, nParticles, 1);

            % Compute distance between confetti and prediction to determine when it is a catch
            dotPredDist = al_diff(spread_wide, pred)';

            % Apply function and test output
            [whichParticlesCaught, nParticlesCaught] = taskData.getParticlesCaught(dotPredDist, shieldSize);
            expectedwhichParticlesCaught = [false,false,false,false,false,false,false,true,true,false];
            testCase.verifyEqual(whichParticlesCaught, expectedwhichParticlesCaught)
            testCase.verifyEqual(nParticlesCaught, 2)
        end

        function testGetParticlesCaughNone(testCase)
            %TEST_GETPARTICLESCAUGHTNONE This function tests the function
            % which computes which particles are caught in the shield
            %
            %   Here we test the case where none of the particles is caught

            % TaskData-object instance
            taskData = al_taskDataMain(123, 'Hamburg');

            % Control random number generator
            rng(1)

            % Confetti parameters
            nParticles = 10;
            confettiStd = 10;
            outcome = 45;
            pred = 100;
            shieldSize = 10;

            % Random angle for each particle (degrees) conditional on outcome and confetti standard deviation
            spread_wide = normrnd(outcome, confettiStd, nParticles, 1);

            % Compute distance between confetti and prediction to determine when it is a catch
            dotPredDist = al_diff(spread_wide, pred)';

            % Apply function and test output
            [whichParticlesCaught, nParticlesCaught] = taskData.getParticlesCaught(dotPredDist, shieldSize);
            expectedwhichParticlesCaught = false(1, nParticles);
            testCase.verifyEqual(whichParticlesCaught, expectedwhichParticlesCaught)
            testCase.verifyEqual(nParticlesCaught, 0)
        end

        function testGetParticlesCaughAll(testCase)
            %TEST_GETPARTICLESCAUGHTALL This function tests the function
            % which computes which particles are caught in the shield
            %
            %   Here we test the case where all particles are caught.

            % TaskData-object instance
            taskData = al_taskDataMain(123, 'Hamburg');

            % Control random number generator
            rng(1)

            % Confetti parameters
            nParticles = 10;
            confettiStd = 1;
            outcome = 45;
            pred = 45;
            shieldSize = 10;

            % Random angle for each particle (degrees) conditional on outcome and confetti standard deviation
            spread_wide = normrnd(outcome, confettiStd, nParticles, 1);

            % Compute distance between confetti and prediction to determine when it is a catch
            dotPredDist = al_diff(spread_wide, pred)';

            % Apply function and test output
            [whichParticlesCaught, nParticlesCaught] = taskData.getParticlesCaught(dotPredDist, shieldSize);
            expectedwhichParticlesCaught = true(1, nParticles);
            testCase.verifyEqual(whichParticlesCaught, expectedwhichParticlesCaught)
            testCase.verifyEqual(nParticlesCaught, 10)
        end
    end
end

