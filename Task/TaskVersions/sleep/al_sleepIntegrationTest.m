classdef al_sleepIntegrationTest < matlab.unittest.TestCase
    % This function runs an integration test for the sleep version
    % To run the test, put run(al_sleepIntegrationTest) in command window

    % Test methods
    methods (Test)
        
        function testTaskOutput(testCase)
            

            % Run task in unit-test mode
            % --------------------------

            cBal = '1';
            day = '1';
            [dataNoPush_cBal1_day1, dataPush_cBal1_day1] = RunSleepVersion(true, cBal, day);
            
            cBal = '2';
            day = '1';
            [dataNoPush_cBal2_day1, dataPush_cBal2_day1] = RunSleepVersion(true, cBal, day);

            cBal = '1';
            day = '2';
            [dataNoPush_cBal1_day2, dataPush_cBal1_day2] = RunSleepVersion(true, cBal, day);
            
            cBal = '2';
            day = '2';
            [dataNoPush_cBal2_day2, dataPush_cBal2_day2] = RunSleepVersion(true, cBal, day);

            % Test output
            % -----------

            % ID
            expectedID = repmat({'01'},20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.ID, expectedID);
            testCase.verifyEqual(dataPush_cBal1_day1.ID, expectedID);
            testCase.verifyEqual(dataNoPush_cBal2_day1.ID, expectedID);
            testCase.verifyEqual(dataPush_cBal2_day1.ID, expectedID);
            testCase.verifyEqual(dataNoPush_cBal1_day2.ID, expectedID);
            testCase.verifyEqual(dataPush_cBal1_day2.ID, expectedID);
            testCase.verifyEqual(dataNoPush_cBal2_day2.ID, expectedID);
            testCase.verifyEqual(dataPush_cBal2_day2.ID, expectedID);

            % Sex
            expectedSex = repmat({'f'},20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.sex, expectedSex);
            testCase.verifyEqual(dataPush_cBal1_day1.sex, expectedSex);
            testCase.verifyEqual(dataNoPush_cBal2_day1.sex, expectedSex);
            testCase.verifyEqual(dataPush_cBal2_day1.sex, expectedSex);
            testCase.verifyEqual(dataNoPush_cBal1_day2.sex, expectedSex);
            testCase.verifyEqual(dataPush_cBal1_day2.sex, expectedSex);
            testCase.verifyEqual(dataNoPush_cBal2_day2.sex, expectedSex);
            testCase.verifyEqual(dataPush_cBal2_day2.sex, expectedSex);

            % Age
            expectedAge = repmat(99,20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.age, expectedAge);
            testCase.verifyEqual(dataPush_cBal1_day1.age, expectedAge);
            testCase.verifyEqual(dataNoPush_cBal2_day1.age, expectedAge);
            testCase.verifyEqual(dataPush_cBal2_day1.age, expectedAge);
            testCase.verifyEqual(dataNoPush_cBal1_day2.age, expectedAge);
            testCase.verifyEqual(dataPush_cBal1_day2.age, expectedAge);
            testCase.verifyEqual(dataNoPush_cBal2_day2.age, expectedAge);
            testCase.verifyEqual(dataPush_cBal2_day2.age, expectedAge);

            % Date
            expectedDate = repmat({date},20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.date, expectedDate);
            testCase.verifyEqual(dataPush_cBal1_day1.date, expectedDate);
            testCase.verifyEqual(dataNoPush_cBal2_day1.date, expectedDate);
            testCase.verifyEqual(dataPush_cBal2_day1.date, expectedDate);
            testCase.verifyEqual(dataNoPush_cBal1_day2.date, expectedDate);
            testCase.verifyEqual(dataPush_cBal1_day2.date, expectedDate);
            testCase.verifyEqual(dataNoPush_cBal2_day2.date, expectedDate);
            testCase.verifyEqual(dataPush_cBal2_day2.date, expectedDate);

            % Test day
            expectedTestDay = ones(20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.testDay, expectedTestDay);
            testCase.verifyEqual(dataPush_cBal1_day1.testDay, expectedTestDay);
            testCase.verifyEqual(dataNoPush_cBal2_day1.testDay, expectedTestDay);
            testCase.verifyEqual(dataPush_cBal2_day1.testDay, expectedTestDay);
            expectedTestDay = ones(20,1) + 1;
            testCase.verifyEqual(dataNoPush_cBal1_day2.testDay, expectedTestDay);
            testCase.verifyEqual(dataPush_cBal1_day2.testDay, expectedTestDay);
            testCase.verifyEqual(dataNoPush_cBal2_day2.testDay, expectedTestDay);
            testCase.verifyEqual(dataPush_cBal2_day2.testDay, expectedTestDay);

            % Condition
            expectedCondition = repmat({'noPush'},20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.cond, expectedCondition);
            testCase.verifyEqual(dataNoPush_cBal2_day1.cond, expectedCondition);
            testCase.verifyEqual(dataNoPush_cBal1_day2.cond, expectedCondition);
            testCase.verifyEqual(dataNoPush_cBal2_day2.cond, expectedCondition);
            expectedCondition = repmat({'push'},20,1);
            testCase.verifyEqual(dataPush_cBal1_day1.cond, expectedCondition);
            testCase.verifyEqual(dataPush_cBal2_day1.cond, expectedCondition);
            testCase.verifyEqual(dataPush_cBal1_day2.cond, expectedCondition);
            testCase.verifyEqual(dataPush_cBal2_day2.cond, expectedCondition);

            % Concentration
            expectedConcentration = repmat(12,20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.concentration, expectedConcentration);
            testCase.verifyEqual(dataPush_cBal1_day1.concentration, expectedConcentration);
            testCase.verifyEqual(dataNoPush_cBal2_day1.concentration, expectedConcentration);
            testCase.verifyEqual(dataPush_cBal2_day1.concentration, expectedConcentration);
            testCase.verifyEqual(dataNoPush_cBal1_day2.concentration, expectedConcentration);
            testCase.verifyEqual(dataPush_cBal1_day2.concentration, expectedConcentration);
            testCase.verifyEqual(dataNoPush_cBal2_day2.concentration, expectedConcentration);
            testCase.verifyEqual(dataPush_cBal2_day2.concentration, expectedConcentration);

            % Push concentration
            expectedPushConcentration = repmat(4,20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.pushConcentration, expectedPushConcentration);
            testCase.verifyEqual(dataPush_cBal1_day1.pushConcentration, expectedPushConcentration);
            testCase.verifyEqual(dataNoPush_cBal2_day1.pushConcentration, expectedPushConcentration);
            testCase.verifyEqual(dataPush_cBal2_day1.pushConcentration, expectedPushConcentration);
            testCase.verifyEqual(dataNoPush_cBal1_day2.pushConcentration, expectedPushConcentration);
            testCase.verifyEqual(dataPush_cBal1_day2.pushConcentration, expectedPushConcentration);
            testCase.verifyEqual(dataNoPush_cBal2_day2.pushConcentration, expectedPushConcentration);
            testCase.verifyEqual(dataPush_cBal2_day2.pushConcentration, expectedPushConcentration);

            % Hazard rate
            expectedHaz = repmat(0.125,20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.haz, expectedHaz);
            testCase.verifyEqual(dataPush_cBal1_day1.haz, expectedHaz);
            testCase.verifyEqual(dataNoPush_cBal2_day1.haz, expectedHaz);
            testCase.verifyEqual(dataPush_cBal2_day1.haz, expectedHaz);
            testCase.verifyEqual(dataNoPush_cBal1_day2.haz, expectedHaz);
            testCase.verifyEqual(dataPush_cBal1_day2.haz, expectedHaz);
            testCase.verifyEqual(dataNoPush_cBal2_day2.haz, expectedHaz);
            testCase.verifyEqual(dataPush_cBal2_day2.haz, expectedHaz);
           
            % Safe trial before changepoint
            expectedSafe = repmat(3,20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.safe, expectedSafe);
            testCase.verifyEqual(dataPush_cBal1_day1.safe, expectedSafe);
            testCase.verifyEqual(dataNoPush_cBal2_day1.safe, expectedSafe);
            testCase.verifyEqual(dataPush_cBal2_day1.safe, expectedSafe);
            testCase.verifyEqual(dataNoPush_cBal1_day2.safe, expectedSafe);
            testCase.verifyEqual(dataPush_cBal1_day2.safe, expectedSafe);
            testCase.verifyEqual(dataNoPush_cBal2_day2.safe, expectedSafe);
            testCase.verifyEqual(dataPush_cBal2_day2.safe, expectedSafe);
            
            % Group
            expectedGroup = ones(20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.group, expectedGroup);
            testCase.verifyEqual(dataPush_cBal1_day1.group, expectedGroup);
            testCase.verifyEqual(dataNoPush_cBal2_day1.group, expectedGroup);
            testCase.verifyEqual(dataPush_cBal2_day1.group, expectedGroup);
            testCase.verifyEqual(dataNoPush_cBal1_day2.group, expectedGroup);
            testCase.verifyEqual(dataPush_cBal1_day2.group, expectedGroup);
            testCase.verifyEqual(dataNoPush_cBal2_day2.group, expectedGroup);
            testCase.verifyEqual(dataPush_cBal2_day2.group, expectedGroup);

            % Reward
            expectedRew = nan(20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.rew, expectedRew);
            testCase.verifyEqual(dataPush_cBal1_day1.rew, expectedRew);
            testCase.verifyEqual(dataNoPush_cBal2_day1.rew, expectedRew);
            testCase.verifyEqual(dataPush_cBal2_day1.rew, expectedRew);
            testCase.verifyEqual(dataNoPush_cBal1_day2.rew, expectedRew);
            testCase.verifyEqual(dataPush_cBal1_day2.rew, expectedRew);
            testCase.verifyEqual(dataNoPush_cBal2_day2.rew, expectedRew);
            testCase.verifyEqual(dataPush_cBal2_day2.rew, expectedRew);

            % Actual jitter with tolerance of 100 ms 
            expectedActJitter = repmat(0.1, 20, 1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.actJitter, expectedActJitter, "AbsTol", 0.1);
            testCase.verifyEqual(dataPush_cBal1_day1.actJitter, expectedActJitter, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal2_day1.actJitter, expectedActJitter, "AbsTol", 0.1);
            testCase.verifyEqual(dataPush_cBal2_day1.actJitter, expectedActJitter, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal1_day2.actJitter, expectedActJitter, "AbsTol", 0.1);
            testCase.verifyEqual(dataPush_cBal1_day2.actJitter, expectedActJitter, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal2_day2.actJitter, expectedActJitter, "AbsTol", 0.1);
            testCase.verifyEqual(dataPush_cBal2_day2.actJitter, expectedActJitter, "AbsTol", 0.1);

            % Block number
            expectedBlock = ones(20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.block, expectedBlock);
            testCase.verifyEqual(dataPush_cBal1_day1.block, expectedBlock);
            testCase.verifyEqual(dataNoPush_cBal2_day1.block, expectedBlock);
            testCase.verifyEqual(dataPush_cBal2_day1.block, expectedBlock);
            testCase.verifyEqual(dataNoPush_cBal1_day2.block, expectedBlock);
            testCase.verifyEqual(dataPush_cBal1_day2.block, expectedBlock);
            testCase.verifyEqual(dataNoPush_cBal2_day2.block, expectedBlock);
            testCase.verifyEqual(dataPush_cBal2_day2.block, expectedBlock);

            % RT with tolerance of 100 ms
            expectedRT = repmat(0.5,20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataPush_cBal1_day1.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal2_day1.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataPush_cBal2_day1.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal1_day2.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataPush_cBal1_day2.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal2_day2.RT, expectedRT, "AbsTol", 0.1);
            testCase.verifyEqual(dataPush_cBal2_day2.RT, expectedRT, "AbsTol", 0.1);

            % Initiation RTs with tolerance of 100 ms
            expectedInitiationRTs = repmat(0.5,20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal2_day1.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal2_day1.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal1_day2.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal1_day2.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal2_day2.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);
            testCase.verifyEqual(dataNoPush_cBal2_day2.initiationRTs, expectedInitiationRTs, "AbsTol", 0.1);

            % All angular shield size
            expectedAllASS = repmat(rad2deg(2*sqrt(1/12)), 20, 1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.allASS, expectedAllASS, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day1.allASS, expectedAllASS, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day1.allASS, expectedAllASS, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day1.allASS, expectedAllASS, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal1_day2.allASS, expectedAllASS, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day2.allASS, expectedAllASS, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day2.allASS, expectedAllASS, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day2.allASS, expectedAllASS, "AbsTol", 1.e-10);

            % Changepoint
            expectedCP = [1; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0];
            testCase.verifyEqual(dataNoPush_cBal1_day1.cp, expectedCP);
            testCase.verifyEqual(dataPush_cBal1_day1.cp, expectedCP);
            testCase.verifyEqual(dataNoPush_cBal2_day1.cp, expectedCP);
            testCase.verifyEqual(dataPush_cBal2_day1.cp, expectedCP);
            testCase.verifyEqual(dataNoPush_cBal1_day2.cp, expectedCP);
            testCase.verifyEqual(dataPush_cBal1_day2.cp, expectedCP);
            testCase.verifyEqual(dataNoPush_cBal2_day2.cp, expectedCP);
            testCase.verifyEqual(dataPush_cBal2_day2.cp, expectedCP);

            % Actual reward
            expectedActRew = nan(20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.actRew, expectedActRew);
            testCase.verifyEqual(dataPush_cBal1_day1.actRew, expectedActRew);
            testCase.verifyEqual(dataNoPush_cBal2_day1.actRew, expectedActRew);
            testCase.verifyEqual(dataPush_cBal2_day1.actRew, expectedActRew);
            testCase.verifyEqual(dataNoPush_cBal1_day2.actRew, expectedActRew);
            testCase.verifyEqual(dataPush_cBal1_day2.actRew, expectedActRew);
            testCase.verifyEqual(dataNoPush_cBal2_day2.actRew, expectedActRew);
            testCase.verifyEqual(dataPush_cBal2_day2.actRew, expectedActRew);

            % Current trial
            expectedTrial = linspace(1,20,20)';
            testCase.verifyEqual(dataNoPush_cBal1_day1.currTrial, expectedTrial);
            testCase.verifyEqual(dataPush_cBal1_day1.currTrial, expectedTrial);
            testCase.verifyEqual(dataNoPush_cBal2_day1.currTrial, expectedTrial);
            testCase.verifyEqual(dataPush_cBal2_day1.currTrial, expectedTrial);
            testCase.verifyEqual(dataNoPush_cBal1_day2.currTrial, expectedTrial);
            testCase.verifyEqual(dataPush_cBal1_day2.currTrial, expectedTrial);
            testCase.verifyEqual(dataNoPush_cBal2_day2.currTrial, expectedTrial);
            testCase.verifyEqual(dataPush_cBal2_day2.currTrial, expectedTrial);

            % Outcome
            expectedOutcome = [295; 276; 302; 267; 299; 313; 300; 298; 273; 311; 331; 307; 325; 282; 277; 304; 315; 189; 194; 199];
            testCase.verifyEqual(dataNoPush_cBal1_day1.outcome, expectedOutcome);
            testCase.verifyEqual(dataPush_cBal1_day1.outcome, expectedOutcome);
            testCase.verifyEqual(dataNoPush_cBal2_day1.outcome, expectedOutcome);
            testCase.verifyEqual(dataPush_cBal2_day1.outcome, expectedOutcome);
            testCase.verifyEqual(dataNoPush_cBal1_day2.outcome, expectedOutcome);
            testCase.verifyEqual(dataPush_cBal1_day2.outcome, expectedOutcome);
            testCase.verifyEqual(dataNoPush_cBal2_day2.outcome, expectedOutcome);
            testCase.verifyEqual(dataPush_cBal2_day2.outcome, expectedOutcome);

            % Distribution mean
            expectedDistMean = [283; 283; 283; 283; 283; 283; 283; 283; 283; 312; 312; 312; 312; 312; 312; 312; 312; 206; 206; 206];
            testCase.verifyEqual(dataNoPush_cBal1_day1.distMean, expectedDistMean);
            testCase.verifyEqual(dataPush_cBal1_day1.distMean, expectedDistMean);
            testCase.verifyEqual(dataNoPush_cBal2_day1.distMean, expectedDistMean);
            testCase.verifyEqual(dataPush_cBal2_day1.distMean, expectedDistMean);
            testCase.verifyEqual(dataNoPush_cBal1_day2.distMean, expectedDistMean);
            testCase.verifyEqual(dataPush_cBal1_day2.distMean, expectedDistMean);
            testCase.verifyEqual(dataNoPush_cBal2_day2.distMean, expectedDistMean);
            testCase.verifyEqual(dataPush_cBal2_day2.distMean, expectedDistMean);

            % Counterbalancing
            expectedCBal = ones(20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.cBal, expectedCBal);
            testCase.verifyEqual(dataPush_cBal1_day1.cBal, expectedCBal);
            expectedCBal = ones(20,1) + 1;
            testCase.verifyEqual(dataNoPush_cBal2_day1.cBal, expectedCBal);
            testCase.verifyEqual(dataPush_cBal2_day1.cBal, expectedCBal);
            expectedCBal = ones(20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day2.cBal, expectedCBal);
            testCase.verifyEqual(dataPush_cBal1_day2.cBal, expectedCBal);
            expectedCBal = ones(20,1) + 1;
            testCase.verifyEqual(dataNoPush_cBal2_day2.cBal, expectedCBal);
            testCase.verifyEqual(dataPush_cBal2_day2.cBal, expectedCBal);

            % Trials after changepoint
            expectedTAC = [0; 1; 2; 3; 4; 5; 6; 7; 8; 0; 1; 2; 3; 4; 5; 6; 7; 0; 1; 2];
            testCase.verifyEqual(dataNoPush_cBal1_day1.TAC, expectedTAC);
            testCase.verifyEqual(dataPush_cBal1_day1.TAC, expectedTAC);
            testCase.verifyEqual(dataNoPush_cBal2_day1.TAC, expectedTAC);
            testCase.verifyEqual(dataPush_cBal2_day1.TAC, expectedTAC);
            testCase.verifyEqual(dataNoPush_cBal1_day2.TAC, expectedTAC);
            testCase.verifyEqual(dataPush_cBal1_day2.TAC, expectedTAC);
            testCase.verifyEqual(dataNoPush_cBal2_day2.TAC, expectedTAC);
            testCase.verifyEqual(dataPush_cBal2_day2.TAC, expectedTAC);
    
            % Shield type
            expectedShieldType = ones(20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.shieldType, expectedShieldType);
            testCase.verifyEqual(dataPush_cBal1_day1.shieldType, expectedShieldType);
            testCase.verifyEqual(dataNoPush_cBal2_day1.shieldType, expectedShieldType);
            testCase.verifyEqual(dataPush_cBal2_day1.shieldType, expectedShieldType);
            testCase.verifyEqual(dataNoPush_cBal1_day2.shieldType, expectedShieldType);
            testCase.verifyEqual(dataPush_cBal1_day2.shieldType, expectedShieldType);
            testCase.verifyEqual(dataNoPush_cBal2_day2.shieldType, expectedShieldType);
            testCase.verifyEqual(dataPush_cBal2_day2.shieldType, expectedShieldType);
           
            % Catch trial
            expectedCatchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
            testCase.verifyEqual(dataNoPush_cBal1_day1.catchTrial, expectedCatchTrial);
            testCase.verifyEqual(dataPush_cBal1_day1.catchTrial, expectedCatchTrial);
            testCase.verifyEqual(dataNoPush_cBal1_day2.catchTrial, expectedCatchTrial);
            testCase.verifyEqual(dataPush_cBal1_day2.catchTrial, expectedCatchTrial);
            
            % Prediction
            expectedPred = [307; 270; 350; 299; 200; 313; 10; 11; 300; 162; 162; 162; 162; 150; 73; 73; 73; 190; 201; 201];
            testCase.verifyEqual(dataNoPush_cBal1_day1.pred, expectedPred, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day1.pred, expectedPred, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day1.pred, expectedPred, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day1.pred, expectedPred, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal1_day2.pred, expectedPred, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day2.pred, expectedPred, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day2.pred, expectedPred, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day2.pred, expectedPred, 'AbsTol', 1.e-10);

            % Prediction error
            expectedPredErr = [-12; 6; -48; -32; 99; 0; -70; -73; -27; 149; 169; 145; 163; 132; -156; -129; -118; -1;	-7;	-2];
            testCase.verifyEqual(dataNoPush_cBal1_day1.predErr, expectedPredErr, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day1.predErr, expectedPredErr, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day1.predErr, expectedPredErr, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day1.predErr, expectedPredErr, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal1_day2.predErr, expectedPredErr, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day2.predErr, expectedPredErr, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day2.predErr, expectedPredErr, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day2.predErr, expectedPredErr, "AbsTol", 1.e-10);

            % Estimation Error
            expectedEstErr = [-24; 13; -67; -16; 83; -30; -87; -88; -17; 150; 150; 150; 150; 162; -121; -121; -121; 16; 5; 5];
            testCase.verifyEqual(dataNoPush_cBal1_day1.estErr, expectedEstErr, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day1.estErr, expectedEstErr, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day1.estErr, expectedEstErr, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day1.estErr, expectedEstErr, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal1_day2.estErr, expectedEstErr, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day2.estErr, expectedEstErr, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day2.estErr, expectedEstErr, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day2.estErr, expectedEstErr, 'AbsTol', 1.e-10);

            % Update
            expectedUP = [nan; -37; 80; -51; -99; 113; 57; 1; -71; -138; 0; 0; 0; -12; -77; 0; 0; 117; 11; 0];
            testCase.verifyEqual(dataNoPush_cBal1_day1.UP, expectedUP, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day1.UP, expectedUP, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day1.UP, expectedUP, "AbsTol", 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day1.UP, expectedUP, "AbsTol", 1.e-10);

            % Hit
            expectedHit = [1; 1; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1];
            testCase.verifyEqual(dataNoPush_cBal1_day1.hit, expectedHit);
            testCase.verifyEqual(dataPush_cBal1_day1.hit, expectedHit);
            testCase.verifyEqual(dataNoPush_cBal2_day1.hit, expectedHit);
            testCase.verifyEqual(dataPush_cBal2_day1.hit, expectedHit);
            testCase.verifyEqual(dataNoPush_cBal1_day2.hit, expectedHit);
            testCase.verifyEqual(dataPush_cBal1_day2.hit, expectedHit);
            testCase.verifyEqual(dataNoPush_cBal2_day2.hit, expectedHit);
            testCase.verifyEqual(dataPush_cBal2_day2.hit, expectedHit);

            % Performance
            expectedPerf = [0.05; 0.05; 0; 0; 0; 0.05; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0.05; 0.05; 0.05];
            testCase.verifyEqual(dataNoPush_cBal1_day1.perf, expectedPerf);
            testCase.verifyEqual(dataPush_cBal1_day1.perf, expectedPerf);
            testCase.verifyEqual(dataNoPush_cBal2_day1.perf, expectedPerf);
            testCase.verifyEqual(dataPush_cBal2_day1.perf, expectedPerf);
            testCase.verifyEqual(dataNoPush_cBal1_day2.perf, expectedPerf);
            testCase.verifyEqual(dataPush_cBal1_day2.perf, expectedPerf);
            testCase.verifyEqual(dataNoPush_cBal2_day2.perf, expectedPerf);
            testCase.verifyEqual(dataPush_cBal2_day2.perf, expectedPerf);
    
            % Accumulated performance
            expectedAccPerf = [0.05; 0.1; 0.1; 0.1; 0.1; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.15; 0.2; 0.25; 0.3];
            testCase.verifyEqual(dataNoPush_cBal1_day1.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day1.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day1.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day1.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal1_day2.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day2.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day2.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day2.accPerf, expectedAccPerf, 'AbsTol', 1.e-10);

            % Initial tendency
            expectedInitialTendency = nan(20, 1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.initialTendency, expectedInitialTendency);
            testCase.verifyEqual(dataPush_cBal1_day1.initialTendency, expectedInitialTendency);
            testCase.verifyEqual(dataNoPush_cBal2_day1.initialTendency, expectedInitialTendency);
            testCase.verifyEqual(dataPush_cBal2_day1.initialTendency, expectedInitialTendency);
            testCase.verifyEqual(dataNoPush_cBal1_day2.initialTendency, expectedInitialTendency);
            testCase.verifyEqual(dataPush_cBal1_day2.initialTendency, expectedInitialTendency);
            testCase.verifyEqual(dataNoPush_cBal2_day2.initialTendency, expectedInitialTendency);
            testCase.verifyEqual(dataPush_cBal2_day2.initialTendency, expectedInitialTendency);

            % Cannon deviation
            expectedCannonDev = [-24; 13; -67; -16; 83; -30; -87; -88; -17; 150; 150; 150; 150; 162; -121; -121; -121; 16; 5; 5];
            testCase.verifyEqual(dataNoPush_cBal1_day1.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day1.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day1.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day1.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal1_day2.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day2.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day2.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day2.cannonDev, expectedCannonDev, 'AbsTol', 1.e-10);

            % Initial starting point of prediction
            expectedY_Push = repmat([-10, 10], 1,10)';
            expectedY_Push(1) = 0;
            expectedZ_noPush = [0; 307; 270; 350; 299; 200; 313; 10; 11; 300; 162; 162; 162; 162; 150; 73; 73; 73; 190; 201];
            testCase.verifyEqual(dataNoPush_cBal1_day1.z, expectedZ_noPush, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day1.z, expectedY_Push + expectedZ_noPush, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day1.z, expectedZ_noPush, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day1.z, expectedY_Push + expectedZ_noPush, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal1_day2.z, expectedZ_noPush, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day2.z, expectedY_Push + expectedZ_noPush, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day2.z, expectedZ_noPush, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day2.z, expectedY_Push + expectedZ_noPush, 'AbsTol', 1.e-10);
            
            % Push magnitude
            testCase.verifyEqual(dataNoPush_cBal1_day1.y, zeros(20, 1), 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day1.y, expectedY_Push, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day1.y, zeros(20, 1), 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day1.y, expectedY_Push, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal1_day2.y, zeros(20, 1), 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal1_day2.y, expectedY_Push, 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataNoPush_cBal2_day2.y, zeros(20, 1), 'AbsTol', 1.e-10);
            testCase.verifyEqual(dataPush_cBal2_day2.y, expectedY_Push, 'AbsTol', 1.e-10);

            % Timestamps: Not testing absolute values bc the reference
            % value depends on manual input (todo: fix when doing CI)
            
            % Difference prediction and trial onset
            expectedOnsetPredDiff = repmat(0.5, 20, 1);
            actualOnsetPredDiffNoPush = dataNoPush_cBal1_day1.timestampPrediction - dataNoPush_cBal1_day1.timestampOnset;
            actualOnsetPredDiffPush = dataPush_cBal1_day1.timestampPrediction - dataPush_cBal1_day1.timestampOnset;
            testCase.verifyEqual(actualOnsetPredDiffNoPush, expectedOnsetPredDiff, 'AbsTol', 0.05)
            testCase.verifyEqual(actualOnsetPredDiffPush, expectedOnsetPredDiff, 'AbsTol', 0.05)
            actualOnsetPredDiffNoPush = dataNoPush_cBal2_day1.timestampPrediction - dataNoPush_cBal2_day1.timestampOnset;
            actualOnsetPredDiffPush = dataPush_cBal2_day1.timestampPrediction - dataPush_cBal2_day1.timestampOnset;
            testCase.verifyEqual(actualOnsetPredDiffNoPush, expectedOnsetPredDiff, 'AbsTol', 0.05)
            testCase.verifyEqual(actualOnsetPredDiffPush, expectedOnsetPredDiff, 'AbsTol', 0.05)
            actualOnsetPredDiffNoPush = dataNoPush_cBal1_day2.timestampPrediction - dataNoPush_cBal1_day2.timestampOnset;
            actualOnsetPredDiffPush = dataPush_cBal1_day2.timestampPrediction - dataPush_cBal1_day2.timestampOnset;
            testCase.verifyEqual(actualOnsetPredDiffNoPush, expectedOnsetPredDiff, 'AbsTol', 0.05)
            testCase.verifyEqual(actualOnsetPredDiffPush, expectedOnsetPredDiff, 'AbsTol', 0.05)
            actualOnsetPredDiffNoPush = dataNoPush_cBal2_day2.timestampPrediction - dataNoPush_cBal2_day2.timestampOnset;
            actualOnsetPredDiffPush = dataPush_cBal2_day2.timestampPrediction - dataPush_cBal2_day2.timestampOnset;
            testCase.verifyEqual(actualOnsetPredDiffNoPush, expectedOnsetPredDiff, 'AbsTol', 0.05)
            testCase.verifyEqual(actualOnsetPredDiffPush, expectedOnsetPredDiff, 'AbsTol', 0.05)

            % Difference offset and prediction
            expectedPredShotPlusITIDiff = repmat(2.4, 20, 1);
            actualPredShotPlusITIDiffNoPush = dataNoPush_cBal1_day1.timestampOffset - dataNoPush_cBal1_day1.timestampPrediction;
            actualPredShotPlusITIDiffPush = dataPush_cBal1_day1.timestampOffset - dataPush_cBal1_day1.timestampPrediction;
            testCase.verifyEqual(actualPredShotPlusITIDiffNoPush, expectedPredShotPlusITIDiff, 'AbsTol', 0.1)
            testCase.verifyEqual(actualPredShotPlusITIDiffPush, expectedPredShotPlusITIDiff, 'AbsTol', 0.1)
            actualPredShotPlusITIDiffNoPush = dataNoPush_cBal2_day1.timestampOffset - dataNoPush_cBal2_day1.timestampPrediction;
            actualPredShotPlusITIDiffPush = dataPush_cBal2_day1.timestampOffset - dataPush_cBal2_day1.timestampPrediction;
            testCase.verifyEqual(actualPredShotPlusITIDiffNoPush, expectedPredShotPlusITIDiff, 'AbsTol', 0.1)
            testCase.verifyEqual(actualPredShotPlusITIDiffPush, expectedPredShotPlusITIDiff, 'AbsTol', 0.1)
            actualPredShotPlusITIDiffNoPush = dataNoPush_cBal1_day2.timestampOffset - dataNoPush_cBal1_day2.timestampPrediction;
            actualPredShotPlusITIDiffPush = dataPush_cBal1_day2.timestampOffset - dataPush_cBal1_day2.timestampPrediction;
            testCase.verifyEqual(actualPredShotPlusITIDiffNoPush, expectedPredShotPlusITIDiff, 'AbsTol', 0.1)
            testCase.verifyEqual(actualPredShotPlusITIDiffPush, expectedPredShotPlusITIDiff, 'AbsTol', 0.1)
            actualPredShotPlusITIDiffNoPush = dataNoPush_cBal2_day2.timestampOffset - dataNoPush_cBal2_day2.timestampPrediction;
            actualPredShotPlusITIDiffPush = dataPush_cBal2_day2.timestampOffset - dataPush_cBal2_day2.timestampPrediction;
            testCase.verifyEqual(actualPredShotPlusITIDiffNoPush, expectedPredShotPlusITIDiff, 'AbsTol', 0.1)
            testCase.verifyEqual(actualPredShotPlusITIDiffPush, expectedPredShotPlusITIDiff, 'AbsTol', 0.1)

            % Triggers
            expectedTriggers = zeros(20,1);
            testCase.verifyEqual(dataNoPush_cBal1_day1.triggers(:,1), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day1.triggers(:,2), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day1.triggers(:,3), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day1.triggers(:,4), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day1.triggers(:,5), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day1.triggers(:,6), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day1.triggers(:,1), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day1.triggers(:,2), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day1.triggers(:,3), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day1.triggers(:,4), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day1.triggers(:,5), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day1.triggers(:,6), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day1.triggers(:,1), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day1.triggers(:,2), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day1.triggers(:,3), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day1.triggers(:,4), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day1.triggers(:,5), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day1.triggers(:,6), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day1.triggers(:,1), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day1.triggers(:,2), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day1.triggers(:,3), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day1.triggers(:,4), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day1.triggers(:,5), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day1.triggers(:,6), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day2.triggers(:,1), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day2.triggers(:,2), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day2.triggers(:,3), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day2.triggers(:,4), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day2.triggers(:,5), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal1_day2.triggers(:,6), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day2.triggers(:,1), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day2.triggers(:,2), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day2.triggers(:,3), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day2.triggers(:,4), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day2.triggers(:,5), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal1_day2.triggers(:,6), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day2.triggers(:,1), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day2.triggers(:,2), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day2.triggers(:,3), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day2.triggers(:,4), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day2.triggers(:,5), expectedTriggers);
            testCase.verifyEqual(dataNoPush_cBal2_day2.triggers(:,6), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day2.triggers(:,1), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day2.triggers(:,2), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day2.triggers(:,3), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day2.triggers(:,4), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day2.triggers(:,5), expectedTriggers);
            testCase.verifyEqual(dataPush_cBal2_day2.triggers(:,6), expectedTriggers);
                        
        end        
    end
end