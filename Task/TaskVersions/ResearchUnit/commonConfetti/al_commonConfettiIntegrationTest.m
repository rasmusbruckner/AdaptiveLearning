classdef al_commonConfettiIntegrationTest < matlab.unittest.TestCase
    % This function runs an integration test for the Hamburg version
    % To run the test, put run(al_commonConfettiIntegrationTest) in command window

    % Test methods
    methods (Test)

        function testTaskOutput(testCase)


            % Run task in unit-test mode
            % --------------------------

            cBal = '1';

            % Create structure
            config = struct();

            % Default parameters
            config.trialsExp = 2;
            config.practTrials = 2;
            config.runIntro = true; %false;
            config.language = 'German';
            config.sentenceLength = 120;
            config.vSpacing = 1;
            config.textSize = 35;
            config.headerSize = 50;
            config.vSpacing = 1;
            config.screenSize = get(0,'MonitorPositions')*1.0;
            config.screenNumber = 1;
            config.s = 40;
            config.enter = 37;
            config.debug = false;
            config.showConfettiThreshold = false;
            config.printTiming = true;
            config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
            config.scanner = false;
            config.eyeTracker = false;
            config.sendTrigger = false;
            config.screenNumber = 1;
            config.customInstructions = true;
            config.instructionText = al_commonConfettiInstructionsDefaultText_updated();

            [dataMain, ~] = RunCommonConfettiVersion(config, true, cBal);

            % Todo: Test both noise conditions

            % Test output
            % -----------

            % ID
            expectedID = repmat({'99999'},20,1);
            testCase.verifyEqual(dataMain.ID, expectedID);

            % Sex
            expectedGender = repmat({'f'},20,1);
            testCase.verifyEqual(dataMain.gender, expectedGender);

            % Age
            expectedAge = repmat(99,20,1);
            testCase.verifyEqual(dataMain.age, expectedAge);

            % Date
            expectedDate = repmat({date},20,1);
            testCase.verifyEqual(dataMain.date, expectedDate);

            % Condition
            expectedCondition = repmat({'main'},20,1);
            testCase.verifyEqual(dataMain.cond, expectedCondition);

            % Concentration
            expectedConcentration = repmat(12,20,1);
            testCase.verifyEqual(dataMain.concentration, expectedConcentration);

            % Push concentration
            expectedPushConcentration = repmat(4,20,1);
            testCase.verifyEqual(dataMain.pushConcentration, expectedPushConcentration);

            % Hazard rate
            expectedHaz = repmat(0.125,20,1);
            testCase.verifyEqual(dataMain.haz, expectedHaz);

            % Safe trial before changepoint
            expectedSafe = repmat(3,20,1);
            testCase.verifyEqual(dataMain.safe, expectedSafe);

            % Group
            expectedGroup = ones(20,1);
            testCase.verifyEqual(dataMain.group, expectedGroup);

            % Reward
            expectedRew = nan(20,1);
            testCase.verifyEqual(dataMain.rew, expectedRew);

            % Actual jitter with tolerance of 100 ms
            %expectedActJitter = repmat(0.1, 20, 1);
            %testCase.verifyEqual(dataMain.actJitter, expectedActJitter, "AbsTol", 0.1);

            % Block number
            expectedBlock = ones(20,1);
            testCase.verifyEqual(dataMain.block, expectedBlock);

            % RT with tolerance of 100 ms
            expectedRT = repmat(0.5,20,1);
            testCase.verifyEqual(dataMain.RT, expectedRT, "AbsTol", 0.1);

            % Initiation RTs with tolerance of 100 ms
            expectedInitiationRTs = repmat(0.25,20,1);
            testCase.verifyEqual(dataMain.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);

            % All angular shield size
            expectedAllShieldSize = repmat(rad2deg(2*sqrt(1/12)), 20, 1);
            testCase.verifyEqual(dataMain.allShieldSize, expectedAllShieldSize, "AbsTol", 1.e-10);

            % Changepoint
            expectedCP = [1; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0];
            testCase.verifyEqual(dataMain.cp, expectedCP);

            % Actual reward
            expectedActRew = nan(20,1);
            testCase.verifyEqual(dataMain.actRew, expectedActRew);

            % Current trial
            expectedTrial = linspace(1,20,20)';
            testCase.verifyEqual(dataMain.currTrial, expectedTrial);

            % Outcome
            expectedOutcome = [295; 276; 302; 267; 299; 313; 300; 298; 273; 311; 331; 307; 325; 282; 277; 304; 315; 189; 194; 199];
            testCase.verifyEqual(dataMain.outcome, expectedOutcome);

            % Distribution mean
            expectedDistMean = [283; 283; 283; 283; 283; 283; 283; 283; 283; 312; 312; 312; 312; 312; 312; 312; 312; 206; 206; 206];
            testCase.verifyEqual(dataMain.distMean, expectedDistMean);

            % Counterbalancing
            expectedCBal = ones(20,1);
            testCase.verifyEqual(dataMain.cBal, expectedCBal);

            % Trials after changepoint
            expectedTAC = [0; 1; 2; 3; 4; 5; 6; 7; 8; 0; 1; 2; 3; 4; 5; 6; 7; 0; 1; 2];
            testCase.verifyEqual(dataMain.TAC, expectedTAC);

            % Shield type
            expectedShieldType = ones(20,1);
            testCase.verifyEqual(dataMain.shieldType, expectedShieldType);

            % Catch trial
            expectedCatchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
            testCase.verifyEqual(dataMain.catchTrial, expectedCatchTrial);

            % Prediction
            expectedPred = [307; 270; 350; 299; 200; 313; 10; 11; 300; 162; 162; 162; 162; 150; 73; 73; 73; 190; 201; 201];
            testCase.verifyEqual(dataMain.pred, expectedPred, "AbsTol", 1.e-10);

            % Prediction error
            expectedPredErr = [-12; 6; -48; -32; 99; 0; -70; -73; -27; 149; 169; 145; 163; 132; -156; -129; -118; -1;	-7;	-2];
            testCase.verifyEqual(dataMain.predErr, expectedPredErr, "AbsTol", 1.e-10);

            % Estimation Error
            expectedEstErr = [-24; 13; -67; -16; 83; -30; -87; -88; -17; 150; 150; 150; 150; 162; -121; -121; -121; 16; 5; 5];
            testCase.verifyEqual(dataMain.estErr, expectedEstErr, 'AbsTol', 1.e-10);

            % Update
            expectedUP = [nan; -37; 80; -51; -99; 113; 57; 1; -71; -138; 0; 0; 0; -12; -77; 0; 0; 117; 11; 0];
            testCase.verifyEqual(dataMain.UP, expectedUP, "AbsTol", 1.e-10);

            % Hit
            expectedHit = [1; 1; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1];
            testCase.verifyEqual(dataMain.hit, expectedHit);

            % Performance
            expectedPerf = [0.1; 0.1; 0; 0; 0; 0.1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0.1; 0.1; 0.1];
            testCase.verifyEqual(dataMain.perf, expectedPerf);

            % Accumulated performance
            expectedAccPerf = [0.1; 0.2; 0.2; 0.2; 0.2; 0.3; 0.3; 0.3; 0.3; 0.3; 0.3; 0.3; 0.3; 0.3; 0.3; 0.3; 0.3; 0.4; 0.5; 0.6];
            testCase.verifyEqual(dataMain.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);

            % Initial tendency
            % Changed expected values to radians, after updating al_mouseLoop
            % Todo: adjust in future version so that transformation in unit test is not
            % necessary anymore
            testCase.verifyEqual(dataMain.initialTendency, deg2rad(expectedPred));

            % Cannon deviation
            expectedCannonDev = [-24; 13; -67; -16; 83; -30; -87; -88; -17; 150; 150; 150; 150; 162; -121; -121; -121; 16; 5; 5];
            testCase.verifyEqual(dataMain.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);

            % Initial starting point of prediction
            expectedZ_noPush = nan(20, 1);
            testCase.verifyEqual(dataMain.z, expectedZ_noPush);

            % Push magnitude
            expectedZ_noPush = nan(20, 1);
            testCase.verifyEqual(dataMain.y, expectedZ_noPush, 'AbsTol', 1.e-10);

            % Number of confetti particles shot
            expectedNParticles = repmat(40, 20, 1);
            testCase.verifyEqual(dataMain.nParticles, expectedNParticles)

            % Number of particles caught in shield
            %expectedNParticlesCaught = [40 40 0 0 0 40 0 0 0 0 0 0 0 0 0 0 0 40 40 40]';
            %testCase.verifyEqual(dataMain.nParticlesCaught, expectedNParticlesCaught)

            % Confetti standard deviation
            expectedConfettiStd = repmat(6, 20, 1);
            testCase.verifyEqual(dataMain.confettiStd, expectedConfettiStd)

            % Asymmetric-reward condition sign
            expectedAsymRewardSign = nan(20, 1);
            testCase.verifyEqual(dataMain.asymRewardSign, expectedAsymRewardSign);

            % Timestamps: Not testing absolute values bc the reference
            % value depends on manual input (todo: fix when doing CI)

            % Difference prediction and trial onset
            expectedOnsetPredDiff = repmat(0.5, 20, 1);
            actualOnsetPredDiff = dataMain.timestampPrediction - dataMain.timestampOnset;
            testCase.verifyEqual(actualOnsetPredDiff, expectedOnsetPredDiff, 'AbsTol', 0.05)

            % Difference offset and prediction
            %expectedPredShotPlusITIDiff = repmat(1.4, 20, 1); %2.4
            %actualPredShotPlusITIDiff = dataMain.timestampOffset - dataMain.timestampPrediction;
            %testCase.verifyEqual(actualPredShotPlusITIDiff, expectedPredShotPlusITIDiff, 'AbsTol', 0.1)

            % Triggers
            %% todo: update in next round
            %expectedTriggers = zeros(20,1);
            %testCase.verifyEqual(dataMain.triggers(:,1), expectedTriggers);
            %testCase.verifyEqual(dataMain.triggers(:,2), expectedTriggers);
            %testCase.verifyEqual(dataMain.triggers(:,3), expectedTriggers);
            %testCase.verifyEqual(dataMain.triggers(:,4), expectedTriggers);
            %testCase.verifyEqual(dataMain.triggers(:,5), expectedTriggers);
            %testCase.verifyEqual(dataMain.triggers(:,6), expectedTriggers);

        end
    end
end