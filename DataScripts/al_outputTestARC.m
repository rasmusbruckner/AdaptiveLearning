classdef al_outputTestARC < matlab.unittest.TestCase
    
    % This function runs a unit test for the reversal version.
    % ---------------------------------------------------------------------
    
    % To run the unit test put run(OutputTestReversal) in command window
    %
    % use: rew = 1
    % trials = 20
    % taskType = reversal
    
    
    
    
    %
    %     This should be the trigger scheme:
    %
    % % Trigger 1: Trial Onset (subject presses buttons to indicate
    % prediction)
    % % Trigger 2: Prediction/Fixation Cross 1: When subject presses Space
    % until 500 mSec
    % % Trigger 3: Outcome: 500 - 1000 mSec
    % % Trigger 4: Fixation Cross 2: 1000 - 2000 mSec
    % % Trigger 5: Shield: 2000 - 2500 mSec
    % % Trigger 6: Fixation Cross 3: 2500 - 3500 mSec
    % % Trigger 7: Trial Summary
    %
    % ###############################################
    %
    % The following part is a list of the last trigger (trigger 7 with the
    % trial summary):
    %
    % first digit=condition (CP vs. Oddball)
    % second digit=event (CP condition: CP versus no CP // Oddball
    % condition:
    % oddball vs. no oddball)
    % third digit = catch vs. no catch
    % fourth digit = reward vs. no reward
    %
    % we use base2dec and add 100 to obtain trigger codes between 100 and
    % 115.
    %
    % 0 0 0 0 -> noCP,  noReversal, noCatch, noReward -> 100
    % 0 0 0 1 -> noCP,  noReversal, noCatch, Reward ->  101
    % 0 0 1 0 -> noCP,  noReversal, Catch,   noReward -> 102
    % 0 0 1 1 -> noCP,  noReversal, Catch,   Reward -> 103
    % 1 0 0 0 -> CP,    noReversal, noCatch, noReward -> 108
    % 1 0 0 1 -> CP,    noReversal, noCatch, Reward -> 109
    % 1 0 1 0 -> CP,    noReversal, Catch,   noReward -> 110
    % 1 0 1 1 -> CP,    noReversal, Catch,   Reward -> 111
    % 1 1 0 0 -> CP,    Reversal,   noCatch, noReward -> 112
    % 1 1 0 1 -> CP,    Reversal,   noCatch, Reward -> 113
    % 1 1 1 0 -> CP,    Reversal,   Catch,   noReward -> 114
    % 1 1 1 1 -> CP,    Reversal,   Catch,   Reward -> 115
    
    
    % 0 1 0 0 -> CP, CP, noCatch, noReward -> 104
    % 0 1 0 1 -> CP, CP, noCatch, Reward -> 105
    % 0 1 1 0 -> CP, CP, Catch, noReward -> 106
    % 0 1 1 1 -> CP, CP, Catch, Reward -> 107
    %
    % I guess trial 1 has code 255.
    %
    
    %%%%%%%%%%%%
    
    methods (Test)
        
        function testTaskOutputARC(testCase)
            

            [Data] = adaptiveLearning(true);
            
            keyboard
            Main_Actual_outcome = Data.outcome;
            Main_Expected_outcome = [81;112;109;102;114;90;109;131;93;102;129;201;192;222;224;226;188;233;220;209];
            testCase.verifyEqual(Main_Actual_outcome, Main_Expected_outcome);
            
            
            Main_Actual_pred = Data.pred;
            Main_Expected_pred = [81;112;109;102;114;90;109;131;93;102;200;200;200;200;200;200;200;200;200;200]
            testCase.verifyEqual(Main_Actual_pred, Main_Expected_pred);
            
            
            Main_Actual_predErr = Data.predErr;
            Main_Expected_predErr = al_diff(Main_Actual_outcome, Main_Actual_pred)
            testCase.verifyEqual(Main_Actual_predErr, Main_Expected_predErr, 'AbsTol', 0.1);
%             

            Main_Actual_UP = Data.UP;
            Main_Expected_UP = [0; al_diff(Main_Actual_pred(2:20), Main_Actual_pred(1:19))]
            testCase.verifyEqual(Main_Actual_UP, Main_Expected_UP, 'AbsTol', 0.01);
            
% 
            Main_Actual_allASS = Data.allASS;
            Main_Expected_allASS = [12.0640118577800;14.7181847159520;78.5325755527781;13.7123842476763;25.6655734519582;15.8595410663762;53.7275264011085;47.4888996167352;17.3396444387023;20.7511979476107;21.0800044527509;25.6647648778593;13.9471504363279;28.6158147415729;17.4209219397602;34.5934361278699;80.0078069319372;17.0787731519239;14.5482541280655;21.2834815760527]
            testCase.verifyEqual(Main_Actual_allASS, Main_Expected_allASS, 'AbsTol', 0.1);
%             
            Main_Actual_cp = Data.cp;
            Main_Expected_cp = [1;0;0;0;0;0;0;0;0;0;0;1;0;0;0;0;0;0;0;0];
            testCase.verifyEqual(Main_Actual_cp, Main_Expected_cp);
% %             
            Main_Actual_reversal = Data.reversal;
            Main_Expected_reversal = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
            testCase.verifyEqual(Main_Actual_reversal, Main_Expected_reversal);
      
            Main_Actual_distMean = Data.distMean;
            Main_Expected_distMean = [103;103;103;103;103;103;103;103;103;103;103;217;217;217;217;217;217;217;217;217]
            testCase.verifyEqual(Main_Actual_distMean, Main_Expected_distMean);
             
            Main_Actual_memErr = Data.memErr;
            Main_Expected_memErr = [999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999];
            testCase.verifyEqual(Main_Actual_memErr, Main_Expected_memErr)
             %
            Main_Actual_concentration = Data.concentration;
            Main_Expected_concentration = [8;8;8;8;8;8;8;8;8;8;8;8;8;8;8;8;8;8;8;8];
            testCase.verifyEqual(Main_Actual_concentration, Main_Expected_concentration);
            %
            Main_Actual_haz = Data.haz;
            Main_Expected_haz = [.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;.125;];
            testCase.verifyEqual(Main_Actual_haz, Main_Expected_haz);
            %
            Main_Actual_trial = Data.trial;
            Main_Expected_trial = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            testCase.verifyEqual(Main_Actual_trial, Main_Expected_trial);
            
            % in echter task checken
            Main_Actual_cond = Data.cond;
            Main_Expected_cond = {'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';};
            testCase.verifyEqual(Main_Actual_cond, Main_Expected_cond);
            %
            Main_Actual_oddBall = Data.oddBall;
            Main_Expected_oddBall = [NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN];
            testCase.verifyEqual(Main_Actual_oddBall, Main_Expected_oddBall);
            %
            Main_Actual_oddballProb = Data.oddballProb;
            Main_Expected_oddballProb = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25;.25; .25; .25; .25; .25;.25; .25; .25; .25; .25;];
            testCase.verifyEqual(Main_Actual_oddballProb, Main_Expected_oddballProb);
            %
            Main_Actual_driftConc = Data.driftConc;
            Main_Expected_driftConc = [30; 30; 30; 30; 30; 30; 30; 30; 30; 30;30; 30; 30; 30; 30;30; 30; 30; 30; 30];
            testCase.verifyEqual(Main_Actual_driftConc, Main_Expected_driftConc);
            
            Main_Actual_block = Data.block;
            Main_Expected_block = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            testCase.verifyEqual(Main_Actual_block, Main_Expected_block);
            
            Main_Actual_shieldType = Data.shieldType;
            Main_Expected_shieldType = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
            testCase.verifyEqual(Main_Actual_shieldType, Main_Expected_shieldType);

            Main_Actual_actRew = Data.actRew;
            Main_Expected_actRew = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
            testCase.verifyEqual(Main_Actual_actRew, Main_Expected_actRew);            

            Main_Actual_hit = Data.hit;
            Main_Expected_hit = [1;1;1;1;1;    1;1;1;1;1;  0;1;0;0;0;  0;1;0;0;1];
            testCase.verifyEqual(Main_Actual_hit, Main_Expected_hit);
             
            Main_Actual_perf = Data.perf;
            Main_Expected_perf = [0.1;0.1;0.1;0.1;0.1;  0.1;0.1;0.1;0.1;0.1;  0;0.1;0;0;0;  0;0.1;0;0;0.1];
            testCase.verifyEqual(Main_Actual_perf, Main_Expected_perf);
             
            Main_Actual_accPerf = Data.accPerf;
            Main_Expected_accPerf = [0.1;0.2;0.3;0.4;0.5;  0.6;0.7;0.8;0.9;1;  1;1.1;1.1;1.1;1.1;  1.1;1.2;1.2;1.2;1.3];
            testCase.verifyEqual(Main_Actual_accPerf, Main_Expected_accPerf, 'AbsTol', 0.0001);
             
            Main_Actual_rew = Data.rew;
            Main_Expected_rew = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
            testCase.verifyEqual(Main_Actual_rew, Main_Expected_rew);
            %
            %Main_Actual_savedTickmark = Data.savedTickmark;
            %Main_Expected_savedTickmark = [0;100;0;50;2;50;360;50;0;0;0;0;0;0;0;50;50;50;50;50];
            %testCase.verifyEqual(Main_Actual_savedTickmark,  Main_Expected_savedTickmark);

 
            
        end
        
        
        
        
    end
end