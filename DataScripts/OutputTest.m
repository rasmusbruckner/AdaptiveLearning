classdef OutputTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testTaskOutput(testCase)
            
            [DataMain, DataFollowOutcome, DataFollowCannon] = AdaptiveLearning(true);
            actualSolution = round(DataMain.predErr(1));
            expectedSolution = 68;
            testCase.verifyEqual(actualSolution, expectedSolution);
            
        end
        
        
    end
    
end