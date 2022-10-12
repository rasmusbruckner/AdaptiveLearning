classdef al_sleepIntegrationTest < matlab.unittest.TestCase
    % This function runs an integration test for the sleep version
    % To run the test, put run(al_sleepIntegrationTest) in command window

    % Todo: Test all cBals and all Days 

    % Test methods
    methods (Test)
        
        function testTaskOutput(testCase)
            

            % Run task in unit-test mode
            [dataNoPush, dataPush] = RunSleepVersion(true);
                     
            % ID
            expectedID = repmat(99999,20,1);
            testCase.verifyEqual(dataNoPush.ID, expectedID);
            testCase.verifyEqual(dataPush.ID, expectedID);

            % Sex
            expectedSex = repmat({'f'},20,1);
            testCase.verifyEqual(dataNoPush.sex, expectedSex);
            testCase.verifyEqual(dataPush.sex, expectedSex);

            % Age
            expectedAge = repmat(99,20,1);
            testCase.verifyEqual(dataNoPush.age, expectedAge);
            testCase.verifyEqual(dataPush.age, expectedAge);

            % Date
            expectedDate = repmat({date},20,1);
            testCase.verifyEqual(dataNoPush.Date, expectedDate);
            testCase.verifyEqual(dataPush.Date, expectedDate);

            % Test day
            expectedTestDay = ones(20,1);
            testCase.verifyEqual(dataNoPush.testDay, expectedTestDay);
            testCase.verifyEqual(dataPush.testDay, expectedTestDay);

            % Condition
            expectedCondition = repmat({'noPush'},20,1);
            testCase.verifyEqual(dataNoPush.cond, expectedCondition);
            expectedCondition = repmat({'push'},20,1);
            testCase.verifyEqual(dataPush.cond, expectedCondition);

            % Concentration
            expectedConcentration = repmat(12,20,1);
            testCase.verifyEqual(dataNoPush.concentration, expectedConcentration);
            testCase.verifyEqual(dataPush.concentration, expectedConcentration);

            % Push concentration
            expectedPushConcentration = repmat(4,20,1);
            testCase.verifyEqual(dataNoPush.pushConcentration, expectedPushConcentration);
            testCase.verifyEqual(dataPush.pushConcentration, expectedPushConcentration);

            % Hazard rate
            expectedHaz = repmat(0.125,20,1);
            testCase.verifyEqual(dataNoPush.haz, expectedHaz);
            testCase.verifyEqual(dataPush.haz, expectedHaz);
           
            % Safe trial before changepoint
            expectedSafe = repmat(3,20,1);
            testCase.verifyEqual(dataNoPush.safe, expectedSafe);
            testCase.verifyEqual(dataPush.safe, expectedSafe);
            
            % Group
            expectedGroup = ones(20,1);
            testCase.verifyEqual(dataNoPush.group, expectedGroup);
            testCase.verifyEqual(dataPush.group, expectedGroup);

            % Reward
            expectedRew = nan(20,1);
            testCase.verifyEqual(dataNoPush.rew, expectedRew);
            testCase.verifyEqual(dataPush.rew, expectedRew);
           
            % Actual jitter with tolerance of 100 ms 
            expectedActJitter = repmat(0.1, 20, 1);
            testCase.verifyEqual(dataNoPush.actJitter, expectedActJitter, "AbsTol", 0.1);
            testCase.verifyEqual(dataPush.actJitter, expectedActJitter, "AbsTol", 0.1);
           
            % Block number
            expectedBlock = ones(20,1);
            testCase.verifyEqual(dataNoPush.block, expectedBlock);
            testCase.verifyEqual(dataPush.block, expectedBlock);
            
            % RT with tolerance of 100 ms
            expectedRT = repmat(0.5,20,1);
            testCase.verifyEqual(dataNoPush.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataPush.RT, expectedRT, "AbsTol", 0.1);

            % Initiation RTs with tolerance of 100 ms
            expectedInitiationRTs = repmat(0.5,20,1);
            testCase.verifyEqual(dataNoPush.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);

            % All angular shield size
            expectedAllASS = repmat(rad2deg(2*sqrt(1/12)), 20, 1);
            testCase.verifyEqual(dataNoPush.allASS, expectedAllASS, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush.allASS, expectedAllASS, "AbsTol", 1.e-10);

            % Changepoint
            expectedCP = [1; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0];
            testCase.verifyEqual(dataNoPush.cp, expectedCP);
            testCase.verifyEqual(dataPush.cp, expectedCP);
            
            % Actual reward
            expectedActRew = nan(20,1);
            testCase.verifyEqual(dataNoPush.actRew, expectedActRew);
            testCase.verifyEqual(dataPush.actRew, expectedActRew);

            % Current trial
            expectedTrial = linspace(1,20,20)';
            testCase.verifyEqual(dataNoPush.currTrial, expectedTrial);
            testCase.verifyEqual(dataPush.currTrial, expectedTrial);

            % Outcome
            expectedOutcome = [295; 276; 302; 267; 299; 313; 300; 298; 273; 311; 331; 307; 325; 282; 277; 304; 315; 189; 194; 199];
            testCase.verifyEqual(dataNoPush.outcome, expectedOutcome);
            testCase.verifyEqual(dataPush.outcome, expectedOutcome);

            % Distribution mean
            expectedDistMean = [283; 283;	283; 283; 283; 283;	283; 283; 283; 312;	312; 312; 312; 312;	312; 312; 312; 206;	206; 206];
            testCase.verifyEqual(dataNoPush.distMean, expectedDistMean);
            testCase.verifyEqual(dataPush.distMean, expectedDistMean);

            % Counterbalancing
            expectedCBal = ones(20,1);
            testCase.verifyEqual(dataNoPush.cBal, expectedCBal);
            testCase.verifyEqual(dataPush.cBal, expectedCBal);

            % Trials after changepoint
            expectedTAC = [0; 1; 2; 3; 4; 5; 6; 7; 8; 0; 1; 2; 3; 4; 5; 6; 7; 0; 1; 2];
            testCase.verifyEqual(dataNoPush.TAC, expectedTAC);
            testCase.verifyEqual(dataPush.TAC, expectedTAC);

            % Shield type
            expectedShieldType = ones(20,1);
            testCase.verifyEqual(dataNoPush.shieldType, expectedShieldType);
            testCase.verifyEqual(dataPush.shieldType, expectedShieldType);
           
            % Catch trial
            expectedCatchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
            testCase.verifyEqual(dataNoPush.catchTrial, expectedCatchTrial);
            testCase.verifyEqual(dataPush.catchTrial, expectedCatchTrial);
            
            % Prediction
            expectedPred = [307; 270; 350; 299; 200; 313; 10; 11; 300; 162; 162; 162; 162; 150; 73; 73; 73; 190; 201; 201];
            testCase.verifyEqual(dataNoPush.pred, expectedPred);
            testCase.verifyEqual(dataPush.pred, expectedPred);
            
            % Prediction error
            expectedPredErr = [-12; 6; -48; -32; 99; 0; -70; -73; -27; 149; 169; 145; 163; 132; -156; -129; -118; -1;	-7;	-2];
            testCase.verifyEqual(dataNoPush.predErr, expectedPredErr, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush.predErr, expectedPredErr, "AbsTol", 1.e-10);
            
            % Estimation Error
            expectedEstErr = [-24; 13; -67; -16; 83; -30; -87; -88; -17; 150; 150; 150; 150; 162; -121; -121; -121; 16; 5; 5];
            testCase.verifyEqual(dataNoPush.estErr, expectedEstErr, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush.estErr, expectedEstErr, 'AbsTol', 1.e-10);

            % Update
            expectedUP = [nan; -37; 80; -51; -99; 113; 57; 1; -71; -138; 0; 0; 0; -12; -77; 0; 0; 117; 11; 0];
            testCase.verifyEqual(dataNoPush.UP, expectedUP, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush.UP, expectedUP, "AbsTol", 1.e-10);
            
            % Hit
            expectedHit = [1; 1; 0; 0; 0; 1; 0; 0; 0; 0;	0; 0; 0; 0; 0; 0; 0; 1; 1; 1];
            testCase.verifyEqual(dataNoPush.hit, expectedHit);
            testCase.verifyEqual(dataPush.hit, expectedHit);
            
            % Performance
            expectedPerf = [0.05; 0.05; 0; 0; 0; 0.05; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0.05; 0.05; 0.05];
            testCase.verifyEqual(dataNoPush.perf, expectedPerf);
            testCase.verifyEqual(dataPush.perf, expectedPerf);
            
            % Accumulated performance
            expectedAccPerf = [0.05; 0.1; 0.1; 0.1; 0.1; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.2; 0.25; 0.3];
            testCase.verifyEqual(dataNoPush.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);
            
            % Initial tendency
            expectedInitialTendency = nan(20, 1);
            testCase.verifyEqual(dataNoPush.initialTendency, expectedInitialTendency);
            testCase.verifyEqual(dataPush.initialTendency, expectedInitialTendency);

            % Cannon deviation
            expectedCannonDev = [-24; 13; -67; -16; 83; -30; -87; -88; -17; 150; 150; 150; 150; 162; -121; -121; -121; 16; 5; 5];
            testCase.verifyEqual(dataNoPush.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);

            % Initial starting point of prediction
            expectedY_Push = repmat([-10, 10], 1,10)';
            expectedY_Push(1) = 0;
            expectedZ_noPush = [0; 307; 270; 350; 299; 200; 313; 10; 11; 300; 162; 162; 162; 162; 150; 73; 73; 73; 190; 201];
            testCase.verifyEqual(dataNoPush.z, expectedZ_noPush);
            testCase.verifyEqual(dataPush.z, expectedY_Push + expectedZ_noPush);
            
            % Push magnitude
            testCase.verifyEqual(dataNoPush.y, zeros(20, 1), 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush.y, expectedY_Push, 'AbsTol', 1.e-10);

            % Latent state
            expectedLatentState = zeros(20, 1);
            testCase.verifyEqual(dataNoPush.latentState, expectedLatentState);
            testCase.verifyEqual(dataPush.latentState, expectedLatentState);
            
            % Timestamps: Not testing absolute values bc the reference
            % value depends on manual input (todo: fix when doin CI)
            
            % Difference prediction and trial onset
            expectedOnsetPredDiff = repmat(0.5, 20, 1);
            actualOnsetPredDiffNoPush = dataNoPush.timestampPrediction - dataNoPush.timestampOnset;
            actualOnsetPredDiffPush = dataPush.timestampPrediction - dataPush.timestampOnset;
            testCase.verifyEqual(expectedOnsetPredDiff, actualOnsetPredDiffNoPush, 'AbsTol', 0.05)
            testCase.verifyEqual(expectedOnsetPredDiff, actualOnsetPredDiffPush, 'AbsTol', 0.05)

            % Difference offset and prediction
            expectedPredShotPlusITIDiff = repmat(2.4, 20, 1);
            actualPredShotPlusITIDiffNoPush = dataNoPush.timestampOffset -dataNoPush.timestampPrediction;
            actualPredShotPlusITIDiffPush = dataPush.timestampOffset -dataPush.timestampPrediction;
            testCase.verifyEqual(expectedPredShotPlusITIDiff, actualPredShotPlusITIDiffNoPush, 'AbsTol', 0.1)
            testCase.verifyEqual(expectedPredShotPlusITIDiff, actualPredShotPlusITIDiffPush, 'AbsTol', 0.1)
            
            % Triggers
            expectedTriggers = zeros(20,1);
            testCase.verifyEqual(dataNoPush.triggers(:,1), expectedTriggers);
            testCase.verifyEqual(dataNoPush.triggers(:,2), expectedTriggers);
            testCase.verifyEqual(dataNoPush.triggers(:,3), expectedTriggers);
            testCase.verifyEqual(dataNoPush.triggers(:,4), expectedTriggers);
            testCase.verifyEqual(dataNoPush.triggers(:,5), expectedTriggers);
            testCase.verifyEqual(dataNoPush.triggers(:,6), expectedTriggers);
            testCase.verifyEqual(dataPush.triggers(:,1), expectedTriggers);
            testCase.verifyEqual(dataPush.triggers(:,2), expectedTriggers);
            testCase.verifyEqual(dataPush.triggers(:,3), expectedTriggers);
            testCase.verifyEqual(dataPush.triggers(:,4), expectedTriggers);
            testCase.verifyEqual(dataPush.triggers(:,5), expectedTriggers);
            testCase.verifyEqual(dataPush.triggers(:,6), expectedTriggers);
            
            % Memory error
            expectedMemErr = [];
            testCase.verifyEqual(dataNoPush.memErr, expectedMemErr)
            testCase.verifyEqual(dataNoPush.memErrNorm, expectedMemErr)
            testCase.verifyEqual(dataNoPush.memErrPlus, expectedMemErr)
            testCase.verifyEqual(dataNoPush.memErrMin, expectedMemErr)
            testCase.verifyEqual(dataPush.memErr, expectedMemErr)
            testCase.verifyEqual(dataPush.memErrNorm, expectedMemErr)
            testCase.verifyEqual(dataPush.memErrPlus, expectedMemErr)
            testCase.verifyEqual(dataPush.memErrMin, expectedMemErr)
            
        end        
    end
end