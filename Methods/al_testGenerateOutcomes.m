classdef al_testGenerateOutcomes < matlab.unittest.TestCase
    %AL_TESTGENERATEOUTCOMES This class definition file specifies the
    %integration test for the al_testGenerateOutcomes class
        
    methods (Test)
        
        function testChangepoint(testCase)
            % TESTCHANGEPOINT This function tests the function that
            % generates the main outcomes of changepoint condition
        
        
            % Control random number for reproducible results
            rng('default')            

            % Create gParam-object instance
            gParam = al_gparam();

            gParam.trials = 200; % number of trials in the test
            gParam.blockIndices = [1 101 999 999]; % breaks
            gParam.useCatchTrials = true; % turn catch trials on
            gParam.concentration = [8 8 99999999]; % concentration parameter
            gParam.catchTrialProb = 0.1; % catch-trial probability

            % TaskParam object that harbors all relevant object instances
            taskParam = al_objectClass();
            taskParam.gParam = gParam;

            % ---------------
            % Run ARC version
            % ---------------
            
            % For old function, field names were still required
            fieldNames = struct('actJitter', 'actJitter', 'block', 'block',...
            'initiationRTs', 'initiationRTs', 'timestampOnset', 'timestampOnset',...
            'timestampPrediction', 'timestampPrediction', 'timestampOffset',...
            'timestampOffset', 'oddBall', 'oddBall', 'oddballProb',...
            'oddballProb', 'driftConc', 'driftConc', 'allASS', 'allASS', 'ID',...
            'ID', 'concentration', 'concentration', 'age', 'age', 'sex', 'sex',...
            'rew', 'rew', 'actRew', 'actRew', 'date','Date', 'cond', 'cond',...
            'trial', 'trial', 'outcome', 'outcome','distMean', 'distMean', 'cp',...
            'cp', 'haz', 'haz', 'TAC', 'TAC', 'shieldType','shieldType',...
            'catchTrial', 'catchTrial', 'triggers', 'triggers', 'pred',...
            'pred','predErr', 'predErr', 'memErr', 'memErr', 'UP', 'UP',...
            'hit', 'hit', 'cBal', 'cBal', 'perf', 'perf', 'accPerf', 'accPerf',...
            'reversalProb', 'reversalProb');
            taskParam.fieldNames = fieldNames;

             % Generate outcomes using function
            condition = 'main';
            taskData = al_generateOutcomes(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration(1), condition);
            
            % Run integration test
            testData = load('testChangepoint.mat');
            testData = testData.taskData;
            testCase.verifyEqual(taskData, testData)
        end
    end
end