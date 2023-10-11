classdef al_unittests < matlab.unittest.TestCase
    %AL_UNITTESTS  This class definition file specifies the unit tests
    
    % To run the tests: runtests('al_unittests')
    %
    % Tests inlcude:
    %     testDiff_neg: XX
    %     testDiff_post: XX
    %     testDiff_neg_180: XX
    %     testDiff_post_180: XX
    %     testOutcome_normal: XX
    %     testOutcome_right_side: XX
    %     testOutcome_left_side: XX
    %     testgetParticlesCaughPartial: XX
    %     testgetParticlesCaughNone: XX
    %     testgetParticlesCaughAll: XX

    
% Other tests that should be added in the future: 

% Classes:
%   al_subject add unit tests for classes

% Functions:
%   al_confettiLoop: requires a couple of mock functions
%   al_controlPredSpotKeyboard
%   al_generateCatchTrial
%   all alGenereateOutcomes 
% 
% Other relevant function not yet tested
%   al_getShieldSize
%   al_indicateBlock
%   al_instrLoopTxt 
%   al_keyboardLoop
%   al_mainLoop
%   al_mouseLoop
%   al_sampleOutcome (to some degree done here already)
%   al_sendTrigger
%   al_sleepLoop
%   all task condition functions

    methods (Test)
        
        function testDiff_neg(testCase)
            %TEST_Diff_NEG  This function tests the diff function when a
            %negative result is expected
            
            % Apply diff function and test output
            diff=al_diff(0, 1);
            testCase.verifyEqual(diff,-1)
        end
        
        function testDiff_pos(testCase)
            %TEST_Diff_POS  This function tests the diff function when a
            %positive result is expected
            
            % Apply diff function and test output
            diff=al_diff(60, 10);
            testCase.verifyEqual(diff, 50, 'AbsTol', 0.01)
        end
        
         function testDiff_neg_180(testCase)
             %TEST_Diff_NEG_180  This function tests the diff function when a
            %negative result is expected, and whether the difference is
            %smaller than 180 degrees
            
            % Apply diff function and test output
            diff=al_diff(181, 0);
            testCase.verifyEqual(diff, -179)
        end
        
        function testDiff_pos_180(testCase)
            %TEST_Diff_POS_180  This function tests the diff function when a
            %positive result is expected, and whether the difference is
            %smaller than 180 degrees
            
            % Apply diff function and test output
            diff=al_diff(0, 181);
            testCase.verifyEqual(diff, 179)
        end
        
        function testOutcome_normal(testCase)
            %TEST_OUTCOME_NORMAL  This function tests the outcome function
            
            % Control random number generator
            rng('default')
            
            % Sample outcome and test output
            outcome = al_sampleOutcome(10, 8);
            testCase.verifyEqual(outcome, 19)
        end
        
        function testOutcome_right_side(testCase)
            %TEST_OUTCOME_RIGHT_SIDE  This function tests the outcome function
            % when the mean is on the left but outcome appears on the right
            
            % Control random number generator
            rng('default')
            
            % Sample outcome and test output
            outcome = al_sampleOutcome(358, 8);
            testCase.verifyEqual(outcome, 7)
        end
        
        function testOutcome_left_side(testCase)
            %TEST_OUTCOME_LEFT_SIDE  This function tests the outcome function
            % when the mean is zero and outcome appears on the left
            
            % Control random number generator
            rng(1)
            
            % Sample outcome and test output
            outcome = al_sampleOutcome(0, 8);
            testCase.verifyEqual(outcome, 345)
        end

        function testgetParticlesCaughPartial(testCase)
            %TEST_GETPARTICLESCAUGHTPARTIAL This function tests the function
            % which computes which particles are caught in the shield
            %
            % Here we test the case where some particles are caught
            
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
            [whichParticlesCaught, nParticlesCaught] = al_getParticlesCaught(dotPredDist, shieldSize);
            expectedwhichParticlesCaught = [false,false,false,false,false,false,false,true,true,false];
            testCase.verifyEqual(whichParticlesCaught, expectedwhichParticlesCaught)
            testCase.verifyEqual(nParticlesCaught, 2)
        end

        function testgetParticlesCaughNone(testCase)
            %TEST_GETPARTICLESCAUGHTNONE This function tests the function
            % which computes which particles are caught in the shield
            %
            % Here we test the case where none of the particles is caught
            
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
            [whichParticlesCaught, nParticlesCaught] = al_getParticlesCaught(dotPredDist, shieldSize);
            expectedwhichParticlesCaught = false(1, nParticles);
            testCase.verifyEqual(whichParticlesCaught, expectedwhichParticlesCaught)
            testCase.verifyEqual(nParticlesCaught, 0)
        end

        function testgetParticlesCaughAll(testCase)
            %TEST_GETPARTICLESCAUGHTALL This function tests the function
            % which computes which particles are caught in the shield
            %
            % Here we test the case where all particles are caught

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
            [whichParticlesCaught, nParticlesCaught] = al_getParticlesCaught(dotPredDist, shieldSize);
            expectedwhichParticlesCaught = true(1, nParticles);
            testCase.verifyEqual(whichParticlesCaught, expectedwhichParticlesCaught)
            testCase.verifyEqual(nParticlesCaught, 10)
        end
    end
end