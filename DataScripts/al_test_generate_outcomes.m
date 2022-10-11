classdef al_test_generate_outcomes < matlab.unittest.TestCase
    %AL_UNITTESTS  This class definition file specifies the unit tests
    
    % To run the tests: runtests('al_test_generate_outcomes')
    
    methods (Test)
        
        function testChangepoint(testCase)
            % XX
        
            
            rng('default')

            
            % Initialize
            gparam_init = al_gparaminit();
            gparam_init.trials = 200;
            gparam_init.blockIndices = [1 101 999 999];
            gparam_init.useCatchTrials = true;
            gparam_init.concentration = [8 8 99999999]; % [16 8 99999999];

            % Create object instance
            gParam = al_gparam(gparam_init);

            taskParam = ColorClass();
            taskParam.gParam = gParam;

            % ---------------
            % Run ARC version
            % ---------------
            
            % This has to be updated to object style
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

            % unitTest = false;
            condition = 'main';
            taskData = al_generateOutcomes(taskParam, taskParam.gParam.haz, taskParam.gParam.concentration(1), condition);
            
            % Apply diff function and test output
            % diff=al_diff(0, 1);
            testData = load('testChangepoint.mat');
            testData = testData.taskData;
            testCase.verifyEqual(taskData, testData)
        end
    end
end