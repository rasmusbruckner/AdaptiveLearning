classdef al_commonConfettiIntegrationTest < matlab.unittest.TestCase
    % This function runs an integration test for the Hamburg version
    % To run the test, put run(al_commonConfettiIntegrationTest) in command window

    % Test methods
    methods (Test)

        function testTaskOutput(testCase)

            % Run task in unit-test mode
            % --------------------------

            % Create structure
            config = struct();

            % Default parameters
            config.trialsExp = 20;
            config.nBlocks = 1;
            config.practTrialsVis = 10;
            config.practTrialsHid = 20; 
            config.cannonPractCriterion = 0; %4; % criterion cannon practice
            config.cannonPractNumOutcomes = 5; % number of trials cannon practice
            config.passiveViewingPractTrials = 10;
            config.passiveViewing = false; % test with true and false
            config.baselineFixLength = 0.25; 
            config.blockIndices = [1 51 101 151];
            config.runIntro = true;
            config.baselineArousal = false; % true;
            config.language = 'German';
            config.sentenceLength = 100;
            config.vSpacing = 1;
            config.textSize = 35;
            config.headerSize = 50;
            config.vSpacing = 1;
            config.screenSize = get(0,'MonitorPositions')*1;
            config.screenNumber = 1;
            config.s = 40;
            config.five = 15;
            config.enter = 37;
            config.defaultParticles = true;
            config.debug = false;
            config.showConfettiThreshold = false;
            config.printTiming = true;
            config.hidePtbCursor = true;
            config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
            config.meg = false;
            config.scanner = false;
            config.eyeTracker = false;
            config.onlineSaccades = false;
            config.saccThres = 1;
            config.useDegreesVisualAngle = true;
            config.distance2screen = 700;
            config.screenWidthInMM = 309.40;
            config.screenHeightInMM = 210;
            config.sendTrigger = false;
            config.sampleRate = 500; % Sampling rate for EEG
            config.session = nan;
            config.port = hex2dec('E050');
            config.rotationRadPixel = 140;
            config.rotationRadDeg = 2.5; % todo: note that this is preliminary
            config.screenNumber = 1;
            config.customInstructions = true;
            config.instructionText = al_commonConfettiInstructionsDefaultText();
            config.noPtbWarnings = false;
            config.predSpotCircleTolerance = 2;
           
            unitTest = al_unitTest();
            unitTest.run = true;
            unitTest.pred = [0; 0; 0; 0; 135; 90; 90; 90; 90; 288; 180; 180; 180; 180; 180; 270; 270; 270; 260; 130];

            % low noise: 132, 130, 147, 149, 135, 138, 149, 169, 151, 276, 297, 294, 294, 298, 289, 300, 305, 285, 258, 271
            % high noise: 40, 50, 77, 40, 70, 319, 263, 286, 261, 290, 271, 159, 108, 136, 153, 121, 128, 128, 101, 124

            cBal = '1';
            [dataLowNoise_cBal1, dataHighNoise_cBal1] = RunCommonConfettiVersion(config, unitTest, cBal);
            dataLowNoise_cBal1 = dataLowNoise_cBal1.conditionBlock1;
            dataHighNoise_cBal1 = dataHighNoise_cBal1.conditionBlock1;

            cBal = '2';
            [dataLowNoise_cBal2, dataHighNoise_cBal2] = RunCommonConfettiVersion(config, unitTest, cBal);
            dataLowNoise_cBal2 = dataLowNoise_cBal2.conditionBlock1;
            dataHighNoise_cBal2 = dataHighNoise_cBal2.conditionBlock1;

            % Test output
            % -----------

            % Prediction error
            expectedPredErrLowNoise_cBal1 = rad2deg(circ_dist(deg2rad(unitTest.taskDataIntegrationTest_HamburgLowNoise.outcome), deg2rad(unitTest.pred)));
            testCase.verifyEqual(dataLowNoise_cBal1.predErr, expectedPredErrLowNoise_cBal1, "AbsTol", 1.e-10);
            expectedPredErrHighNoise_cBal1 = rad2deg(circ_dist(deg2rad(unitTest.taskDataIntegrationTest_HamburgHighNoise.outcome), deg2rad(unitTest.pred)));
            testCase.verifyEqual(dataHighNoise_cBal1.predErr, expectedPredErrHighNoise_cBal1, "AbsTol", 1.e-10);
            expectedPredErrLowNoise_cBal2 = rad2deg(circ_dist(deg2rad(unitTest.taskDataIntegrationTest_HamburgLowNoise.outcome), deg2rad(unitTest.pred)));
            testCase.verifyEqual(dataLowNoise_cBal2.predErr, expectedPredErrLowNoise_cBal2, "AbsTol", 1.e-10);
            expectedPredErrHighNoise_cBal2 = rad2deg(circ_dist(deg2rad(unitTest.taskDataIntegrationTest_HamburgHighNoise.outcome), deg2rad(unitTest.pred)));
            testCase.verifyEqual(dataHighNoise_cBal2.predErr, expectedPredErrHighNoise_cBal2, "AbsTol", 1.e-10);

            % Estimation error
            expectedEstErrLowNoise_cBal1 = rad2deg(circ_dist(deg2rad(unitTest.taskDataIntegrationTest_HamburgLowNoise.distMean), deg2rad(unitTest.pred)));
            testCase.verifyEqual(dataLowNoise_cBal1.estErr, expectedEstErrLowNoise_cBal1, unitTest.pred, 'AbsTol', 1.e-10);
            expectedEstErrHighNoise_cBal1 = rad2deg(circ_dist(deg2rad(unitTest.taskDataIntegrationTest_HamburgHighNoise.distMean), deg2rad(unitTest.pred)));
            testCase.verifyEqual(dataHighNoise_cBal1.estErr, expectedEstErrHighNoise_cBal1, unitTest.pred, 'AbsTol', 1.e-10);   
            expectedEstErrLowNoise_cBal2 = rad2deg(circ_dist(deg2rad(unitTest.taskDataIntegrationTest_HamburgLowNoise.distMean), deg2rad(unitTest.pred)));
            testCase.verifyEqual(dataLowNoise_cBal2.estErr, expectedEstErrLowNoise_cBal2, unitTest.pred, 'AbsTol', 1.e-10);
            expectedEstErrHighNoise_cBal2 = rad2deg(circ_dist(deg2rad(unitTest.taskDataIntegrationTest_HamburgHighNoise.distMean), deg2rad(unitTest.pred)));
            testCase.verifyEqual(dataHighNoise_cBal2.estErr, expectedEstErrHighNoise_cBal2, unitTest.pred, 'AbsTol', 1.e-10);

            % Update
            expectedUP = nan(20,1);
            expectedUP(2:end) = rad2deg(circ_dist(deg2rad(unitTest.pred(2:end)), deg2rad(unitTest.pred(1:end-1))));
            testCase.verifyEqual(dataLowNoise_cBal1.UP, expectedUP, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataHighNoise_cBal1.UP, expectedUP, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataLowNoise_cBal2.UP, expectedUP, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataHighNoise_cBal2.UP, expectedUP, "AbsTol", 1.e-10);

            % Hit
            expectedHitLowNoise_cBal1 = zeros(20,1);
            expectedHitLowNoise_cBal1(abs(expectedPredErrLowNoise_cBal1) <= unitTest.taskDataIntegrationTest_HamburgLowNoise.allShieldSize/2) = 1;
            testCase.verifyEqual(dataLowNoise_cBal1.hit, expectedHitLowNoise_cBal1);
            expectedHitHighNoise_cBal1 = zeros(20,1);
            expectedHitHighNoise_cBal1(abs(expectedPredErrHighNoise_cBal1) <= unitTest.taskDataIntegrationTest_HamburgHighNoise.allShieldSize/2) = 1;
            testCase.verifyEqual(dataHighNoise_cBal1.hit, expectedHitHighNoise_cBal1);
            expectedHitLowNoise_cBal2 = zeros(20,1);
            expectedHitLowNoise_cBal2(abs(expectedPredErrLowNoise_cBal2) <= unitTest.taskDataIntegrationTest_HamburgLowNoise.allShieldSize/2) = 1;
            testCase.verifyEqual(dataLowNoise_cBal2.hit, expectedHitLowNoise_cBal2);
            expectedHitHighNoise_cBal2 = zeros(20,1);
            expectedHitHighNoise_cBal2(abs(expectedPredErrHighNoise_cBal2) <= unitTest.taskDataIntegrationTest_HamburgHighNoise.allShieldSize/2) = 1;
            testCase.verifyEqual(dataHighNoise_cBal2.hit, expectedHitHighNoise_cBal2);

            % Performance
            expectedPerfLowNoise_cBal1 = expectedHitLowNoise_cBal1 * 0.1;
            testCase.verifyEqual(dataLowNoise_cBal1.perf, expectedPerfLowNoise_cBal1);
            expectedPerfHighNoise_cBal1 = expectedHitHighNoise_cBal1 * 0.1;
            testCase.verifyEqual(dataHighNoise_cBal1.perf, expectedPerfHighNoise_cBal1);
            expectedPerfLowNoise_cBal2 = expectedHitLowNoise_cBal2 * 0.1;
            testCase.verifyEqual(dataLowNoise_cBal2.perf, expectedPerfLowNoise_cBal2);
            expectedPerfHighNoise_cBal2 = expectedHitHighNoise_cBal2 * 0.1;
            testCase.verifyEqual(dataHighNoise_cBal2.perf, expectedPerfHighNoise_cBal2);

            % Accumulated performance
            expectedAccPerfLowNoise_cBal1 = cumsum(expectedPerfLowNoise_cBal1);
            testCase.verifyEqual(dataLowNoise_cBal1.accPerf, expectedAccPerfLowNoise_cBal1, 'AbsTol', 1.e-10);
            expectedAccPerfHighNoise_cBal1 = cumsum(expectedPerfHighNoise_cBal1);
            testCase.verifyEqual(dataHighNoise_cBal1.accPerf, expectedAccPerfHighNoise_cBal1, 'AbsTol', 1.e-10);
            expectedAccPerfLowNoise_cBal2 = cumsum(expectedPerfLowNoise_cBal2);
            testCase.verifyEqual(dataLowNoise_cBal2.accPerf, expectedAccPerfLowNoise_cBal2, 'AbsTol', 1.e-10);
            expectedAccPerfHighNoise_cBal2 = cumsum(expectedPerfHighNoise_cBal2);
            testCase.verifyEqual(dataHighNoise_cBal2.accPerf, expectedAccPerfHighNoise_cBal2, 'AbsTol', 1.e-10);

            % Prediction
            testCase.verifyEqual(dataLowNoise_cBal1.pred, unitTest.pred, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataHighNoise_cBal1.pred, unitTest.pred, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataLowNoise_cBal2.pred, unitTest.pred, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataHighNoise_cBal2.pred, unitTest.pred, "AbsTol", 1.e-10);

            % Outcome
            testCase.verifyEqual(dataLowNoise_cBal1.outcome, unitTest.taskDataIntegrationTest_HamburgLowNoise.outcome);
            testCase.verifyEqual(dataHighNoise_cBal1.outcome, unitTest.taskDataIntegrationTest_HamburgHighNoise.outcome);
            testCase.verifyEqual(dataLowNoise_cBal2.outcome, unitTest.taskDataIntegrationTest_HamburgLowNoise.outcome);
            testCase.verifyEqual(dataHighNoise_cBal2.outcome, unitTest.taskDataIntegrationTest_HamburgHighNoise.outcome);

            % Distribution mean
            testCase.verifyEqual(dataLowNoise_cBal1.distMean, unitTest.taskDataIntegrationTest_HamburgLowNoise.distMean);
            testCase.verifyEqual(dataHighNoise_cBal1.distMean, unitTest.taskDataIntegrationTest_HamburgHighNoise.distMean);
            testCase.verifyEqual(dataLowNoise_cBal2.distMean, unitTest.taskDataIntegrationTest_HamburgLowNoise.distMean);
            testCase.verifyEqual(dataHighNoise_cBal2.distMean, unitTest.taskDataIntegrationTest_HamburgHighNoise.distMean);

            % Changepoint
            testCase.verifyEqual(dataLowNoise_cBal1.cp, unitTest.taskDataIntegrationTest_HamburgLowNoise.cp);
            testCase.verifyEqual(dataHighNoise_cBal1.cp, unitTest.taskDataIntegrationTest_HamburgHighNoise.cp);
            testCase.verifyEqual(dataLowNoise_cBal2.cp, unitTest.taskDataIntegrationTest_HamburgLowNoise.cp);
            testCase.verifyEqual(dataHighNoise_cBal2.cp, unitTest.taskDataIntegrationTest_HamburgHighNoise.cp);

            % Trials after changepoint
            testCase.verifyEqual(dataLowNoise_cBal1.TAC, unitTest.taskDataIntegrationTest_HamburgLowNoise.TAC);
            testCase.verifyEqual(dataHighNoise_cBal1.TAC, unitTest.taskDataIntegrationTest_HamburgHighNoise.TAC);
            testCase.verifyEqual(dataLowNoise_cBal2.TAC, unitTest.taskDataIntegrationTest_HamburgLowNoise.TAC);
            testCase.verifyEqual(dataHighNoise_cBal2.TAC, unitTest.taskDataIntegrationTest_HamburgHighNoise.TAC);

            % Catch trial
            testCase.verifyEqual(dataLowNoise_cBal1.catchTrial, unitTest.taskDataIntegrationTest_HamburgLowNoise.catchTrial);
            testCase.verifyEqual(dataHighNoise_cBal1.catchTrial, unitTest.taskDataIntegrationTest_HamburgHighNoise.catchTrial);
            testCase.verifyEqual(dataLowNoise_cBal2.catchTrial, unitTest.taskDataIntegrationTest_HamburgLowNoise.catchTrial);
            testCase.verifyEqual(dataHighNoise_cBal2.catchTrial, unitTest.taskDataIntegrationTest_HamburgHighNoise.catchTrial);

            % ID
            expectedID = repmat({'99999'},20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.ID, expectedID);
            testCase.verifyEqual(dataHighNoise_cBal1.ID, expectedID);
            testCase.verifyEqual(dataLowNoise_cBal2.ID, expectedID);
            testCase.verifyEqual(dataHighNoise_cBal2.ID, expectedID);

            % Gender
            expectedGender = repmat({'f'},20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.gender, expectedGender);
            testCase.verifyEqual(dataHighNoise_cBal1.gender, expectedGender);
            testCase.verifyEqual(dataLowNoise_cBal2.gender, expectedGender);
            testCase.verifyEqual(dataHighNoise_cBal2.gender, expectedGender);

            % Age
            expectedAge = repmat(99,20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.age, expectedAge);
            testCase.verifyEqual(dataHighNoise_cBal1.age, expectedAge);
            testCase.verifyEqual(dataLowNoise_cBal2.age, expectedAge);
            testCase.verifyEqual(dataHighNoise_cBal2.age, expectedAge);

            % Date
            expectedDate = repmat({date},20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.date, expectedDate);
            testCase.verifyEqual(dataHighNoise_cBal1.date, expectedDate);
            testCase.verifyEqual(dataLowNoise_cBal2.date, expectedDate);
            testCase.verifyEqual(dataHighNoise_cBal2.date, expectedDate);

            % Condition
            expectedCondition = repmat({'main'},20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.cond, expectedCondition);
            testCase.verifyEqual(dataHighNoise_cBal1.cond, expectedCondition);
            testCase.verifyEqual(dataLowNoise_cBal2.cond, expectedCondition);
            testCase.verifyEqual(dataHighNoise_cBal2.cond, expectedCondition);

            % Concentration
            expectedConcentrationLowNoise = repmat(16,20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.concentration, expectedConcentrationLowNoise);
            testCase.verifyEqual(dataLowNoise_cBal2.concentration, expectedConcentrationLowNoise);
            expectedConcentrationHighNoise = repmat(8,20,1);
            testCase.verifyEqual(dataHighNoise_cBal1.concentration, expectedConcentrationHighNoise);
            testCase.verifyEqual(dataHighNoise_cBal2.concentration, expectedConcentrationHighNoise);

            % Hazard rate
            expectedHaz = repmat(0.125,20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.haz, expectedHaz);
            testCase.verifyEqual(dataHighNoise_cBal1.haz, expectedHaz);
            testCase.verifyEqual(dataLowNoise_cBal2.haz, expectedHaz);
            testCase.verifyEqual(dataHighNoise_cBal2.haz, expectedHaz);

            % Safe trial before changepoint
            expectedSafe = repmat(3,20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.safe, expectedSafe);
            testCase.verifyEqual(dataHighNoise_cBal1.safe, expectedSafe);
            testCase.verifyEqual(dataLowNoise_cBal2.safe, expectedSafe);
            testCase.verifyEqual(dataHighNoise_cBal2.safe, expectedSafe);

            % Group
            expectedGroup = ones(20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.group, expectedGroup);
            testCase.verifyEqual(dataHighNoise_cBal1.group, expectedGroup);
            testCase.verifyEqual(dataLowNoise_cBal2.group, expectedGroup);
            testCase.verifyEqual(dataHighNoise_cBal2.group, expectedGroup);

            % Reward
            expectedRew = nan(20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.rew, expectedRew);
            testCase.verifyEqual(dataHighNoise_cBal1.rew, expectedRew);
            testCase.verifyEqual(dataLowNoise_cBal2.rew, expectedRew);
            testCase.verifyEqual(dataHighNoise_cBal2.rew, expectedRew);

            % Block number
            expectedBlock = ones(20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.block, expectedBlock);
            testCase.verifyEqual(dataHighNoise_cBal1.block, expectedBlock);
            testCase.verifyEqual(dataLowNoise_cBal2.block, expectedBlock);
            testCase.verifyEqual(dataHighNoise_cBal2.block, expectedBlock);

            % RT with tolerance of 100 ms
            expectedRT = repmat(0.5,20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataHighNoise_cBal1.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataLowNoise_cBal2.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataHighNoise_cBal2.RT, expectedRT, "AbsTol", 0.1);

            % Initiation RTs with tolerance of 100 ms
            if config.passiveViewing == false
                expectedInitiationRTs = repmat(0.25,20,1);
                testCase.verifyEqual(dataLowNoise_cBal1.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
                testCase.verifyEqual(dataHighNoise_cBal1.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
                testCase.verifyEqual(dataLowNoise_cBal2.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
                testCase.verifyEqual(dataHighNoise_cBal2.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
            end

            % All angular shield size
            testCase.verifyEqual(dataLowNoise_cBal1.allShieldSize, unitTest.taskDataIntegrationTest_HamburgLowNoise.allShieldSize, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataHighNoise_cBal1.allShieldSize, unitTest.taskDataIntegrationTest_HamburgHighNoise.allShieldSize, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataLowNoise_cBal2.allShieldSize, unitTest.taskDataIntegrationTest_HamburgLowNoise.allShieldSize, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataHighNoise_cBal2.allShieldSize, unitTest.taskDataIntegrationTest_HamburgHighNoise.allShieldSize, "AbsTol", 1.e-10);

            % Current trial
            expectedTrial = linspace(1,20,20)';
            testCase.verifyEqual(dataLowNoise_cBal1.currTrial, expectedTrial);
            testCase.verifyEqual(dataHighNoise_cBal1.currTrial, expectedTrial);
            testCase.verifyEqual(dataLowNoise_cBal2.currTrial, expectedTrial);
            testCase.verifyEqual(dataHighNoise_cBal2.currTrial, expectedTrial);

            % Counterbalancing
            expectedCBal1 = ones(20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.cBal, expectedCBal1);
            testCase.verifyEqual(dataHighNoise_cBal1.cBal, expectedCBal1);
            expectedCBal2 = ones(20,1)*2;
            testCase.verifyEqual(dataLowNoise_cBal2.cBal, expectedCBal2);
            testCase.verifyEqual(dataHighNoise_cBal2.cBal, expectedCBal2);

            % Shield type
            expectedShieldType = ones(20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.shieldType, expectedShieldType);
            testCase.verifyEqual(dataHighNoise_cBal1.shieldType, expectedShieldType);
            testCase.verifyEqual(dataLowNoise_cBal2.shieldType, expectedShieldType);
            testCase.verifyEqual(dataHighNoise_cBal2.shieldType, expectedShieldType);

            % Initial tendency
            if config.passiveViewing == false
                testCase.verifyEqual(dataLowNoise_cBal1.initialTendency, unitTest.pred);
                testCase.verifyEqual(dataHighNoise_cBal1.initialTendency, unitTest.pred);
                testCase.verifyEqual(dataLowNoise_cBal2.initialTendency, unitTest.pred);
                testCase.verifyEqual(dataHighNoise_cBal2.initialTendency, unitTest.pred);
            end

            % Number of confetti particles shot
            expectedNParticles = repmat(40, 20, 1);
            testCase.verifyEqual(dataLowNoise_cBal1.nParticles, expectedNParticles)
            testCase.verifyEqual(dataHighNoise_cBal1.nParticles, expectedNParticles)
            testCase.verifyEqual(dataLowNoise_cBal2.nParticles, expectedNParticles)
            testCase.verifyEqual(dataHighNoise_cBal2.nParticles, expectedNParticles)

            % Confetti standard deviation
            expectedConfettiStd = repmat(6.0652, 20, 1); % 3.7907
            testCase.verifyEqual(dataLowNoise_cBal1.confettiStd, expectedConfettiStd, "AbsTol", 1.e-4)
            testCase.verifyEqual(dataHighNoise_cBal1.confettiStd, expectedConfettiStd, "AbsTol", 1.e-4)
            testCase.verifyEqual(dataLowNoise_cBal2.confettiStd, expectedConfettiStd, "AbsTol", 1.e-4)
            testCase.verifyEqual(dataHighNoise_cBal2.confettiStd, expectedConfettiStd, "AbsTol", 1.e-4)

            % Triggers
            % --------

            % Trial-onset trigger
            expectedTriggers_1 = ones(20,1);
            testCase.verifyEqual(dataLowNoise_cBal1.triggers(:,1), expectedTriggers_1);
            testCase.verifyEqual(dataHighNoise_cBal1.triggers(:,1), expectedTriggers_1);
            testCase.verifyEqual(dataLowNoise_cBal2.triggers(:,1), expectedTriggers_1);
            testCase.verifyEqual(dataHighNoise_cBal2.triggers(:,1), expectedTriggers_1);

            % Response-onset trigger
            expectedTriggers_2 = ones(20,1)*2;
            testCase.verifyEqual(dataLowNoise_cBal1.triggers(:,2), expectedTriggers_2);
            testCase.verifyEqual(dataHighNoise_cBal1.triggers(:,2), expectedTriggers_2);
            testCase.verifyEqual(dataLowNoise_cBal2.triggers(:,2), expectedTriggers_2);
            testCase.verifyEqual(dataHighNoise_cBal2.triggers(:,2), expectedTriggers_2);

            % Response-logged (prediction) trigger
            expectedTriggers_3 = ones(20,1)*3;
            testCase.verifyEqual(dataLowNoise_cBal1.triggers(:,3), expectedTriggers_3);
            testCase.verifyEqual(dataHighNoise_cBal1.triggers(:,3), expectedTriggers_3);
            testCase.verifyEqual(dataLowNoise_cBal2.triggers(:,3), expectedTriggers_3);
            testCase.verifyEqual(dataHighNoise_cBal2.triggers(:,3), expectedTriggers_3);

            % Fixation-cross triggers
            expectedTriggers_4 = ones(20,1)*4;
            testCase.verifyEqual(dataLowNoise_cBal1.triggers(:,4), expectedTriggers_4);
            testCase.verifyEqual(dataLowNoise_cBal1.triggers(:,6), expectedTriggers_4);
            testCase.verifyEqual(dataLowNoise_cBal1.triggers(:,8), expectedTriggers_4);
            testCase.verifyEqual(dataHighNoise_cBal1.triggers(:,4), expectedTriggers_4);
            testCase.verifyEqual(dataHighNoise_cBal1.triggers(:,6), expectedTriggers_4);
            testCase.verifyEqual(dataHighNoise_cBal1.triggers(:,8), expectedTriggers_4);
            testCase.verifyEqual(dataLowNoise_cBal2.triggers(:,4), expectedTriggers_4);
            testCase.verifyEqual(dataLowNoise_cBal2.triggers(:,6), expectedTriggers_4);
            testCase.verifyEqual(dataLowNoise_cBal2.triggers(:,8), expectedTriggers_4);
            testCase.verifyEqual(dataHighNoise_cBal2.triggers(:,4), expectedTriggers_4);
            testCase.verifyEqual(dataHighNoise_cBal2.triggers(:,6), expectedTriggers_4);
            testCase.verifyEqual(dataHighNoise_cBal2.triggers(:,8), expectedTriggers_4);

            % Outcome trigger
            expectedTriggers_5_lowNoise_cBal1 = ones(20,1)*50;
            expectedTriggers_5_lowNoise_cBal1(unitTest.taskDataIntegrationTest_HamburgLowNoise.cp==1) = 51;
            expectedTriggers_5_lowNoise_cBal1(unitTest.taskDataIntegrationTest_HamburgLowNoise.catchTrial==1) = 49;
            testCase.verifyEqual(dataLowNoise_cBal1.triggers(:,5), expectedTriggers_5_lowNoise_cBal1);
            expectedTriggers_5_highNoise_cBal1 = ones(20,1)*50;
            expectedTriggers_5_highNoise_cBal1(unitTest.taskDataIntegrationTest_HamburgHighNoise.cp==1) = 51;
            expectedTriggers_5_highNoise_cBal1(unitTest.taskDataIntegrationTest_HamburgHighNoise.catchTrial==1) = 49;
            testCase.verifyEqual(dataHighNoise_cBal1.triggers(:,5), expectedTriggers_5_highNoise_cBal1);
            expectedTriggers_5_lowNoise_cBal2 = ones(20,1)*50;
            expectedTriggers_5_lowNoise_cBal2(unitTest.taskDataIntegrationTest_HamburgLowNoise.cp==1) = 51;
            expectedTriggers_5_lowNoise_cBal2(unitTest.taskDataIntegrationTest_HamburgLowNoise.catchTrial==1) = 49;
            testCase.verifyEqual(dataLowNoise_cBal2.triggers(:,5), expectedTriggers_5_lowNoise_cBal2);
            expectedTriggers_5_highNoise_cBal2= ones(20,1)*50;
            expectedTriggers_5_highNoise_cBal2(unitTest.taskDataIntegrationTest_HamburgHighNoise.cp==1) = 51;
            expectedTriggers_5_highNoise_cBal2(unitTest.taskDataIntegrationTest_HamburgHighNoise.catchTrial==1) = 49;
            testCase.verifyEqual(dataHighNoise_cBal2.triggers(:,5), expectedTriggers_5_highNoise_cBal2);

            % Shield trigger
            expectedTriggers_7_lowNoise_cBal1 = ones(20,1)*90;
            expectedTriggers_7_lowNoise_cBal1(expectedHitLowNoise_cBal1==1) = 91;
            testCase.verifyEqual(dataLowNoise_cBal1.triggers(:,7), expectedTriggers_7_lowNoise_cBal1);
            expectedTriggers_7_highNoise_cBal1 = ones(20,1)*90;
            expectedTriggers_7_highNoise_cBal1(expectedHitHighNoise_cBal1==1) = 91;
            testCase.verifyEqual(dataHighNoise_cBal1.triggers(:,7), expectedTriggers_7_highNoise_cBal1);
            expectedTriggers_7_lowNoise_cBal2 = ones(20,1)*90;
            expectedTriggers_7_lowNoise_cBal2(expectedHitLowNoise_cBal2==1) = 91;
            testCase.verifyEqual(dataLowNoise_cBal2.triggers(:,7), expectedTriggers_7_lowNoise_cBal2);
            expectedTriggers_7_highNoise_cBal2 = ones(20,1)*90;
            expectedTriggers_7_highNoise_cBal2(expectedHitHighNoise_cBal2==1) = 91;
            testCase.verifyEqual(dataHighNoise_cBal2.triggers(:,7), expectedTriggers_7_highNoise_cBal2);

            % Timing
            % ------

            % Difference prediction and trial onset
            expectedBaselineOnsetDiff = repmat(0.25, 20, 1);
            actualBaselineOnsetDiff = dataLowNoise_cBal1.timestampOnset - dataLowNoise_cBal1.timestampBaseline;
            testCase.verifyEqual(actualBaselineOnsetDiff, expectedBaselineOnsetDiff, 'AbsTol', 0.05)
            actualBaselineOnsetDiff = dataHighNoise_cBal1.timestampOnset - dataHighNoise_cBal1.timestampBaseline;
            testCase.verifyEqual(actualBaselineOnsetDiff, expectedBaselineOnsetDiff, 'AbsTol', 0.05)
            actualBaselineOnsetDiff = dataLowNoise_cBal2.timestampOnset - dataLowNoise_cBal2.timestampBaseline;
            testCase.verifyEqual(actualBaselineOnsetDiff, expectedBaselineOnsetDiff, 'AbsTol', 0.05)
            actualBaselineOnsetDiff = dataHighNoise_cBal2.timestampOnset - dataHighNoise_cBal2.timestampBaseline;
            testCase.verifyEqual(actualBaselineOnsetDiff, expectedBaselineOnsetDiff, 'AbsTol', 0.05)
    
            % Difference prediction and trial onset
            expectedOnsetPredDiff = repmat(0.5, 20, 1);
            actualOnsetPredDiff = dataLowNoise_cBal1.timestampPrediction - dataLowNoise_cBal1.timestampOnset;
            testCase.verifyEqual(actualOnsetPredDiff, expectedOnsetPredDiff, 'AbsTol', 0.05)
            actualOnsetPredDiff = dataHighNoise_cBal1.timestampPrediction - dataHighNoise_cBal1.timestampOnset;
            testCase.verifyEqual(actualOnsetPredDiff, expectedOnsetPredDiff, 'AbsTol', 0.05)
            actualOnsetPredDiff = dataLowNoise_cBal2.timestampPrediction - dataLowNoise_cBal2.timestampOnset;
            testCase.verifyEqual(actualOnsetPredDiff, expectedOnsetPredDiff, 'AbsTol', 0.05)
            actualOnsetPredDiff = dataHighNoise_cBal2.timestampPrediction - dataHighNoise_cBal2.timestampOnset;
            testCase.verifyEqual(actualOnsetPredDiff, expectedOnsetPredDiff, 'AbsTol', 0.05)
    
            % Difference outcome and fixation-coss 2
            tolerance = 0.05;
            actualOutcFix2Diff = dataLowNoise_cBal1.timestampFixCross2 - dataLowNoise_cBal1.timestampOutcome;
            testCase.verifyLessThanOrEqual(actualOutcFix2Diff, 0.8 + tolerance)
            testCase.verifyGreaterThanOrEqual(actualOutcFix2Diff, 0.0)
            actualOutcFix2Diff = dataHighNoise_cBal1.timestampFixCross2 - dataHighNoise_cBal1.timestampOutcome;
            testCase.verifyLessThanOrEqual(actualOutcFix2Diff, 0.8 + tolerance)
            testCase.verifyGreaterThanOrEqual(actualOutcFix2Diff, 0.0)
            actualOutcFix2Diff = dataLowNoise_cBal2.timestampFixCross2 - dataLowNoise_cBal2.timestampOutcome;
            testCase.verifyLessThanOrEqual(actualOutcFix2Diff, 0.8 + tolerance)
            testCase.verifyGreaterThanOrEqual(actualOutcFix2Diff, 0.0)
            actualOutcFix2Diff = dataHighNoise_cBal2.timestampFixCross2 - dataHighNoise_cBal2.timestampOutcome;
            testCase.verifyLessThanOrEqual(actualOutcFix2Diff, 0.8 + tolerance)
            testCase.verifyGreaterThanOrEqual(actualOutcFix2Diff, 0.0)
            
            % Actual onset jitter
            testCase.verifyLessThanOrEqual(dataLowNoise_cBal1.actJitterOnset, 0.5)
            testCase.verifyGreaterThanOrEqual(dataLowNoise_cBal1.actJitterOnset, 0.0)
            testCase.verifyLessThanOrEqual(dataHighNoise_cBal1.actJitterOnset, 0.5)
            testCase.verifyGreaterThanOrEqual(dataHighNoise_cBal1.actJitterOnset, 0.0)
            testCase.verifyLessThanOrEqual(dataLowNoise_cBal2.actJitterOnset, 0.5)
            testCase.verifyGreaterThanOrEqual(dataLowNoise_cBal2.actJitterOnset, 0.0)
            testCase.verifyLessThanOrEqual(dataHighNoise_cBal2.actJitterOnset, 0.5)
            testCase.verifyGreaterThanOrEqual(dataHighNoise_cBal2.actJitterOnset, 0.0)

            % Difference shield and fixation-coss 3 
            actualShieldFix3Diff = dataLowNoise_cBal1.timestampFixCross3 - dataLowNoise_cBal1.timestampShield;
            testCase.verifyLessThanOrEqual(actualShieldFix3Diff, 0.8 + tolerance)
            testCase.verifyGreaterThanOrEqual(actualShieldFix3Diff, 0.0)
            actualShieldFix3Diff = dataHighNoise_cBal1.timestampFixCross3 - dataHighNoise_cBal1.timestampShield;
            testCase.verifyLessThanOrEqual(actualShieldFix3Diff, 0.8 + tolerance)
            testCase.verifyGreaterThanOrEqual(actualShieldFix3Diff, 0.0)
            actualShieldFix3Diff = dataLowNoise_cBal2.timestampFixCross3 - dataLowNoise_cBal2.timestampShield;
            testCase.verifyLessThanOrEqual(actualShieldFix3Diff, 0.8 + tolerance)
            testCase.verifyGreaterThanOrEqual(actualShieldFix3Diff, 0.0)
            actualShieldFix3Diff = dataHighNoise_cBal2.timestampFixCross3 - dataHighNoise_cBal2.timestampShield;
            testCase.verifyLessThanOrEqual(actualShieldFix3Diff, 0.8 + tolerance)
            testCase.verifyGreaterThanOrEqual(actualShieldFix3Diff, 0.0)

            % Actual jitter fixation cross outcome
            testCase.verifyLessThanOrEqual(dataLowNoise_cBal1.actJitterFixCrossOutcome, 2.0)
            testCase.verifyGreaterThanOrEqual(dataLowNoise_cBal1.actJitterFixCrossOutcome, 0.0)
            testCase.verifyLessThanOrEqual(dataHighNoise_cBal1.actJitterFixCrossOutcome, 2.0)
            testCase.verifyGreaterThanOrEqual(dataHighNoise_cBal1.actJitterFixCrossOutcome, 0.0)
            testCase.verifyLessThanOrEqual(dataLowNoise_cBal2.actJitterFixCrossOutcome, 2.0)
            testCase.verifyGreaterThanOrEqual(dataLowNoise_cBal2.actJitterFixCrossOutcome, 0.0)
            testCase.verifyLessThanOrEqual(dataHighNoise_cBal2.actJitterFixCrossOutcome, 2.0)
            testCase.verifyGreaterThanOrEqual(dataHighNoise_cBal2.actJitterFixCrossOutcome, 0.0)

            % Actual jitter fixation cross outcome
            testCase.verifyLessThanOrEqual(dataLowNoise_cBal1.actJitterOutcome, 0.15)
            testCase.verifyGreaterThanOrEqual(dataLowNoise_cBal1.actJitterOutcome, 0.0)
            testCase.verifyLessThanOrEqual(dataHighNoise_cBal1.actJitterOutcome, 0.15)
            testCase.verifyGreaterThanOrEqual(dataHighNoise_cBal1.actJitterOutcome, 0.0)
            testCase.verifyLessThanOrEqual(dataLowNoise_cBal2.actJitterOutcome, 0.15)
            testCase.verifyGreaterThanOrEqual(dataLowNoise_cBal2.actJitterOutcome, 0.0)
            testCase.verifyLessThanOrEqual(dataHighNoise_cBal2.actJitterOutcome, 0.15)
            testCase.verifyGreaterThanOrEqual(dataHighNoise_cBal2.actJitterOutcome, 0.0)

            % Actual jitter fixation cross shield
            testCase.verifyLessThanOrEqual(dataLowNoise_cBal1.actJitterFixCrossShield, 0.6)
            testCase.verifyGreaterThanOrEqual(dataLowNoise_cBal1.actJitterFixCrossShield, 0.0)
            testCase.verifyLessThanOrEqual(dataHighNoise_cBal1.actJitterFixCrossShield, 0.6)
            testCase.verifyGreaterThanOrEqual(dataHighNoise_cBal1.actJitterFixCrossShield, 0.0)
            testCase.verifyLessThanOrEqual(dataLowNoise_cBal2.actJitterFixCrossShield, 0.6)
            testCase.verifyGreaterThanOrEqual(dataLowNoise_cBal2.actJitterFixCrossShield, 0.0)
            testCase.verifyLessThanOrEqual(dataHighNoise_cBal2.actJitterFixCrossShield, 0.6)
            testCase.verifyGreaterThanOrEqual(dataHighNoise_cBal2.actJitterFixCrossShield, 0.0)

            % Actual jitter fixation cross outcome
            testCase.verifyLessThanOrEqual(dataLowNoise_cBal1.actJitterShield, 0.15)
            testCase.verifyGreaterThanOrEqual(dataLowNoise_cBal1.actJitterShield, 0.0)
            testCase.verifyLessThanOrEqual(dataHighNoise_cBal1.actJitterShield, 0.15)
            testCase.verifyGreaterThanOrEqual(dataHighNoise_cBal1.actJitterShield, 0.0)
            testCase.verifyLessThanOrEqual(dataLowNoise_cBal2.actJitterShield, 0.15)
            testCase.verifyGreaterThanOrEqual(dataLowNoise_cBal2.actJitterShield, 0.0)
            testCase.verifyLessThanOrEqual(dataHighNoise_cBal2.actJitterShield, 0.15)
            testCase.verifyGreaterThanOrEqual(dataHighNoise_cBal2.actJitterOutcome, 0.0)

            % Display-object instance
            display = al_display();
            display.screensize = config.screenSize;

            % Rotation radius
            testCase.verifyEqual(dataLowNoise_cBal1.rotationRad, display.deg2pix(config.rotationRadDeg), 'AbsTol', 1)
            testCase.verifyEqual(dataHighNoise_cBal1.rotationRad, display.deg2pix(config.rotationRadDeg), 'AbsTol', 1)
            testCase.verifyEqual(dataLowNoise_cBal2.rotationRad, display.deg2pix(config.rotationRadDeg), 'AbsTol', 1)
            testCase.verifyEqual(dataHighNoise_cBal2.rotationRad, display.deg2pix(config.rotationRadDeg), 'AbsTol', 1)

        end
    end
end