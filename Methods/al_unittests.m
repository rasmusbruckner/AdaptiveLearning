classdef al_unittests < matlab.unittest.TestCase
    %AL_UNITTESTS This class definition file specifies the unit tests
    %
    % To run the tests: runtests('al_unittests')

    methods (Test)
        
        function testDiff_neg(testCase)
            %TEST_Diff_NEG  This function tests the diff function when a
            %negative result is expected
            
            % Apply diff function and test output
            diff = al_diff(0, 1);
            testCase.verifyEqual(diff,-1)
        end
        
        function testDiff_pos(testCase)
            %TEST_Diff_POS  This function tests the diff function when a
            %positive result is expected
            
            % Apply diff function and test output
            diff = al_diff(60, 10);
            testCase.verifyEqual(diff, 50, 'AbsTol', 0.01)
        end
        
         function testDiff_neg_180(testCase)
             %TEST_Diff_NEG_180  This function tests the diff function when a
            %negative result is expected, and whether the difference is
            %smaller than 180 degrees
            
            % Apply diff function and test output
            diff = al_diff(181, 0);
            testCase.verifyEqual(diff, -179)
        end
        
        function testDiff_pos_180(testCase)
            %TEST_Diff_POS_180  This function tests the diff function when a
            %positive result is expected, and whether the difference is
            %smaller than 180 degrees
            
            % Apply diff function and test output
            diff = al_diff(0, 181);
            testCase.verifyEqual(diff, 179)
        end
        
        function testOutcome_normal(testCase)
            %TEST_OUTCOME_NORMAL  This function tests the outcome function
            
            % TaskData-object instance
            taskData = al_taskDataMain(200, 'Hamburg');
            
            % Control random number generator
            rng('default')
            
            % Sample outcome and test output
            outcome = taskData.sampleOutcome(10, 8);
            testCase.verifyEqual(outcome, 19)
        end
        
        function testOutcome_right_side(testCase)
            %TEST_OUTCOME_RIGHT_SIDE  This function tests the outcome function
            % when the mean is on the left but outcome appears on the right
            
             % TaskData-object instance
            taskData = al_taskDataMain(200, 'Hamburg');

            % Control random number generator
            rng('default')
            
            % Sample outcome and test output
            outcome = taskData.sampleOutcome(358, 8);
            testCase.verifyEqual(outcome, 7)
        end
        
        function testOutcome_left_side(testCase)
            %TEST_OUTCOME_LEFT_SIDE  This function tests the outcome function
            % when the mean is zero and outcome appears on the left
            
            % TaskData-object instance
            taskData = al_taskDataMain(200, 'Hamburg');

            % Control random number generator
            rng(1)
            
            % Sample outcome and test output
            outcome = taskData.sampleOutcome(0, 8);
            testCase.verifyEqual(outcome, 345)
        end

        function testSendTriggerHamburg(testCase)
            %TESTSENDTRIGGERHAMBURG This function tests the common version
            % triggers
            
            % Task condition
            condition = 'Hamburg';
            
            % Object that harbors all relevant object instances
            taskParam = al_objectClass();
            taskParam.gParam.taskType = 'Hamburg';
            taskParam.gParam.eyeTracker = false;
            taskParam.gParam.sendTrigger = false;
            taskParam.gParam.printTrigger = false;
            
            % TaskData-object instance
            taskData = al_taskDataMain(200, condition);
            
            % Send static triggers
            triggerTrialOnset = al_sendTrigger(taskParam, taskData, condition, 1, 'trialOnset');
            triggerResponseOnset = al_sendTrigger(taskParam, taskData, condition, 1, 'responseOnset');
            triggerResponseLogged = al_sendTrigger(taskParam, taskData, condition, 1, 'responseLogged');
            triggerFix = al_sendTrigger(taskParam, taskData, condition, 1, 'fix');

            % Test static triggers
            testCase.verifyEqual(triggerTrialOnset, 1)
            testCase.verifyEqual(triggerResponseOnset, 2)
            testCase.verifyEqual(triggerResponseLogged, 3)
            testCase.verifyEqual(triggerFix, 4)

            % Test dynamic triggers
            % ---------------------

            taskData.cp(1) = 0;
            triggerOutcomeNoCP = al_sendTrigger(taskParam, taskData, condition, 1, 'outcome');
            testCase.verifyEqual(triggerOutcomeNoCP, 50)

            taskData.cp(1) = 1;
            triggerOutcomeCP = al_sendTrigger(taskParam, taskData, condition, 1, 'outcome');
            testCase.verifyEqual(triggerOutcomeCP, 51)

            taskData.hit(1) = 0;
            triggerOutcomeNoHit = al_sendTrigger(taskParam, taskData, condition, 1, 'shield');
            testCase.verifyEqual(triggerOutcomeNoHit, 90)

            taskData.hit(1) = 1;
            triggerOutcomeHit = al_sendTrigger(taskParam, taskData, condition, 1, 'shield');
            testCase.verifyEqual(triggerOutcomeHit, 91)

        end

%         function testSendTriggerHamburgEEG(testCase)
% 
%         end
    end
end