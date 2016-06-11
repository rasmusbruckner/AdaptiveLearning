classdef OutputTestReversal < matlab.unittest.TestCase
    
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
    % 0 0 0 0 -> noCP, noReversal, noCatch, noReward -> 100
    % 0 0 0 1 -> noCP, noReversal, noCatch, Reward ->  101
    % 0 0 1 0 -> noCP, noReversal, Catch, noReward -> 102
    % 0 0 1 1 -> noCP, noReversal, Catch, Reward -> 103
    % 1 0 0 0 -> CP, noReversal, noCatch, noReward -> 108
    % 1 0 0 1 -> CP, noReversal, noCatch, Reward -> 109
    % 1 0 1 0 -> CP, noReveral, Catch, noReward -> 110
    % 1 0 1 1 -> CP, noReversal, Catch, Reward -> 111
    % 1 1 0 0 -> CP, Reversal, noCatch, noReward -> 112
    % 1 1 0 1 -> CP, Reversal, noCatch, Reward -> 113
    % 1 1 1 0 -> CP, Reversal, Catch, noReward -> 114
    % 1 1 1 1 -> CP, Reversal, Catch, Reward -> 115
    
    
    % 0 1 0 0 -> CP, CP, noCatch, noReward -> 104
    % 0 1 0 1 -> CP, CP, noCatch, Reward -> 105
    % 0 1 1 0 -> CP, CP, Catch, noReward -> 106
    % 0 1 1 1 -> CP, CP, Catch, Reward -> 107
    %
    % I guess trial 1 has code 255.
    %
    
    %%%%%%%%%%%%
    
    methods (Test)
        
        function testTaskOutputReversal(testCase)
            

            [Data] = AdaptiveLearning(true);
            
            %keyboard
            Main_Actual_outcome = Data.DataReversal.outcome;
            Main_Expected_outcome = [211;183;170;168;171;118;126;129;155;306;312;302;295;165;125;105;144;180;164;140];
            testCase.verifyEqual(Main_Actual_outcome, Main_Expected_outcome);
            
            %
            Main_Actual_pred = Data.DataReversal.pred;
            Main_Expected_pred = [0;190;160;164;50;360;126;140;135;106;212;302;300;165;22;220;160;170;144;140];
            testCase.verifyEqual(Main_Actual_pred, Main_Expected_pred);
            
            
            Main_Actual_predErr = Data.DataReversal.predErr;
            Main_Expected_predErr = [-149;-7;10;4;121;118;0;-11;20;-160;100;0;-5;0;103;-115;-16;10;20;0];
            testCase.verifyEqual(Main_Actual_predErr, Main_Expected_predErr, 'AbsTol', 0.1);
%             

            Main_Actual_UP = Data.DataReversal.UP;
            Main_Expected_UP = [0;-170;-30;4;-114;-50;126;14;-5;-29;106;90;-2;-135;-143;-162;-60;10;-26;-4];
            testCase.verifyEqual(Main_Actual_UP, Main_Expected_UP, 'AbsTol', 0.01);
            
% 
            Main_Actual_allASS = Data.DataReversal.allASS;
            Main_Expected_allASS = [11.5124788328748;12.5611360096606;29.2871241766746;23.6608363658634;18.6930207421080;16.3764392912647;19.6117079762646;11.2479026880178;11.5241907745761;12.2470716192960;45.3199352861132;38.2359141560456;28.7738358352410;42.5987300224292;10.4110253666403;13.3887385739345;13.0473628392547;57.0633619669725;10.6269970305702;12.0164071752807];
            testCase.verifyEqual(Main_Actual_allASS, Main_Expected_allASS, 'AbsTol', 0.1);
% 

% %  
%             das noch regeln      
%             Main_Actual_catchTrial = Data.DataReversal.catchTrial;
%             Main_Expected_catchTrial = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
%             testCase.verifyEqual(Main_Actual_catchTrial, Main_Expected_catchTrial);
%             
            Main_Actual_cp = Data.DataReversal.cp;
            Main_Expected_cp = [1;0;0;0;0;1;0;0;0;1;0;0;0;1;0;0;0;0;0;0];
            testCase.verifyEqual(Main_Actual_cp, Main_Expected_cp);
% %             
            Main_Actual_reversal = Data.DataReversal.reversal;
            Main_Expected_reversal = [0;0;0;0;0;0;0;0;0;0;0;0;0;1;0;0;0;0;0;0];
            testCase.verifyEqual(Main_Actual_reversal, Main_Expected_reversal);
 
            
            Main_Actual_distMean = Data.DataReversal.distMean;
            Main_Expected_distMean = [191;191;191;191;191;136;136;136;136;304;304;304;304;136;136;136;136;136;136;136];
            testCase.verifyEqual(Main_Actual_distMean, Main_Expected_distMean);
             
            Main_Actual_memErr = Data.DataReversal.memErr;
            Main_Expected_memErr = [999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999];
            testCase.verifyEqual(Main_Actual_memErr, Main_Expected_memErr)
             %
            Main_Actual_concentration = Data.DataReversal.concentration;
            Main_Expected_concentration = [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10];
            testCase.verifyEqual(Main_Actual_concentration, Main_Expected_concentration);
            %
            Main_Actual_haz = Data.DataReversal.haz;
            Main_Expected_haz = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25];
            testCase.verifyEqual(Main_Actual_haz, Main_Expected_haz);
            %
            Main_Actual_trial = Data.DataReversal.trial;
            Main_Expected_trial = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            testCase.verifyEqual(Main_Actual_trial, Main_Expected_trial);
            
            % in echter task checken
            Main_Actual_cond = Data.DataReversal.cond;
            Main_Expected_cond = {'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal';'reversal'};
            testCase.verifyEqual(Main_Actual_cond, Main_Expected_cond);
            %
            Main_Actual_oddBall = Data.DataReversal.oddBall;
            Main_Expected_oddBall = [NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN];
            testCase.verifyEqual(Main_Actual_oddBall, Main_Expected_oddBall);
            %
            Main_Actual_oddballProb = Data.DataReversal.oddballProb;
            Main_Expected_oddballProb = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25;.25; .25; .25; .25; .25;.25; .25; .25; .25; .25;];
            testCase.verifyEqual(Main_Actual_oddballProb, Main_Expected_oddballProb);
            %
            Main_Actual_driftConc = Data.DataReversal.driftConc;
            Main_Expected_driftConc = [30; 30; 30; 30; 30; 30; 30; 30; 30; 30;30; 30; 30; 30; 30;30; 30; 30; 30; 30];
            testCase.verifyEqual(Main_Actual_driftConc, Main_Expected_driftConc);
            
            Main_Actual_block = Data.DataReversal.block;
            Main_Expected_block = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            testCase.verifyEqual(Main_Actual_block, Main_Expected_block);
            
            Main_Actual_shieldType = Data.DataReversal.shieldType;
            Main_Expected_shieldType = [1;1;1;0;1;1;0;0;0;1;1;0;0;0;0;1;1;0;0;1];
            testCase.verifyEqual(Main_Actual_shieldType, Main_Expected_shieldType);

            Main_Actual_actRew = Data.DataReversal.actRew;
            Main_Expected_actRew = [1;1;1;2;1;  1;2;2;2;1;  1;2;2;2;2;  1;1;2;2;1];
            testCase.verifyEqual(Main_Actual_actRew, Main_Expected_actRew);            

             Main_Actual_hit = Data.DataReversal.hit;
             Main_Expected_hit = [0;0;1;1;0;    0;1;0;0;0;  0;1;1;1;0;  0;0;1;0;1];
             testCase.verifyEqual(Main_Actual_hit, Main_Expected_hit);
             
            Main_Actual_perf = Data.DataReversal.perf;
            Main_Expected_perf = [0;0;0.1;0;0;  0;0;0;0;0;  0;0;0;0;0;  0;0;0;0;0.1];
             testCase.verifyEqual(Main_Actual_perf, Main_Expected_perf);
             
            Main_Actual_accPerf = Data.DataReversal.accPerf;
            Main_Expected_accPerf = [0;0;0.1;0.1;0.1;  0.1;0.1;0.1;0.1;0.1;  0.1;0.1;0.1;0.1;0.1;  0.1;0.1;0.1;0.1;0.2];
            testCase.verifyEqual(Main_Actual_accPerf, Main_Expected_accPerf, 'AbsTol', 0.0001);
             
            Main_Actual_rew = Data.DataReversal.rew;
            Main_Expected_rew = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1;];
            testCase.verifyEqual(Main_Actual_rew, Main_Expected_rew);
            %
            Main_Actual_savedTickmark = Data.DataReversal.savedTickmark;
            Main_Expected_savedTickmark = [0;100;0;50;2;50;360;50;0;0;0;0;0;0;0;50;50;50;50;50];
            testCase.verifyEqual(Main_Actual_savedTickmark,  Main_Expected_savedTickmark);


            Main_Actual_trigger1 = Data.DataReversal.triggers(:,1);
            Main_Expected_trigger1 = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1;];
            testCase.verifyEqual(Main_Actual_trigger1, Main_Expected_trigger1);
            %
            Main_Actual_trigger2 = Data.DataReversal.triggers(:,2);
            Main_Expected_trigger2 = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(Main_Actual_trigger2, Main_Expected_trigger2);
            
            Main_Actual_trigger3 = Data.DataReversal.triggers(:,3);
            Main_Expected_trigger3 = [3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3;];
            testCase.verifyEqual(Main_Actual_trigger3, Main_Expected_trigger3);
            %
            Main_Actual_trigger4 = Data.DataReversal.triggers(:,4);
            Main_Expected_trigger4 = [4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4;];
            testCase.verifyEqual(Main_Actual_trigger4, Main_Expected_trigger4);
            
            Main_Actual_trigger5 = Data.DataReversal.triggers(:,5);
            Main_Expected_trigger5 = [5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5;];
            testCase.verifyEqual(Main_Actual_trigger5, Main_Expected_trigger5);
            
            Main_Actual_trigger6 = Data.DataReversal.triggers(:,6);
            Main_Expected_trigger6 = [6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6;];
            testCase.verifyEqual(Main_Actual_trigger6, Main_Expected_trigger6);
            %
%             
%             0 0 0 0 -> noCP, noReversal, noCatch, noReward -> 100
            % 0 0 0 1 -> noCP, noReversal, noCatch, Reward ->  101
            % 0 0 1 0 -> noCP, noReversal, Catch, noReward -> 102
            % 0 0 1 1 -> noCP, noReversal, Catch, Reward -> 103
            % 1 0 0 0 -> CP, noReversal, noCatch, noReward -> 108
            % 1 0 0 1 -> CP, noReversal, noCatch, Reward -> 109
            % 1 0 1 0 -> CP, noReveral, Catch, noReward -> 110
            % 1 0 1 1 -> CP, noReversal, Catch, Reward -> 111
            % 1 1 0 0 -> CP, Reversal, noCatch, noReward -> 112
            % 1 1 0 1 -> CP, Reversal, noCatch, Reward -> 113
            % 1 1 1 0 -> CP, Reversal, Catch, noReward -> 114
            % 1 1 1 1 -> CP, Reversal, Catch, Reward -> 115
             Main_Actual_SummaryTrigger = Data.DataReversal.triggers(:,7);
             Main_Expected_SummaryTrigger = [255;101;103;102;101;   109;102;100;100;109;    101;102;102;114;100;    101;101;102;100;103];
%             
%             %Main_Expected_SummaryTrigger = [255;101;102;107;110;   106;106;104;108;107;    104;102;104;108;105;    104;102;100;100;106];
%             
%             %condition + cp
%             % digit1 = 0
%             
%             % digit 2 =
%             %Main_Expected_cp = [1;0;0;0;1;0;0;0;1;0;0;0;0;1;0;0;0;0;0;0];
%             
%             % digit3 = hit
%             % Main_Expected_hit = [1; 0; 0; 1; 0; 1; 1; 1; 0; 1; 1; 0; 1; 0; 1; 1; 0; 0; 0; 1];
%             
%             % digit4 = actRew
%             % Main_Expected_actRew = [1;2;1;1;1;1;1;2;2;1;2;1;2;2;2;2;1;2;2;1];
%             
%             % 1 0 0 1 x
%             % 0 0 0 1 x
%             % 0 0 1 1 x
%             % 0 0 1 0 x
%             % 0 0 0 1 x
%             
%             % 1 0 0 1 x
%             % 0 0 1 0 x
%             % 0 0 0 0 x
%             % 0 0 0 0 x
%             % 1 0 0 1 x
%             
%             % 0 0 0 1 x
%             % 0 0 1 0 x
%             % 0 0 1 0 x
%             % 1 1 1 0 x
%             % 0 0 0 0 x
%             
%             % 0 0 0 1 x
%             % 0 0 0 1 x
%             % 0 0 1 0 x
%             % 0 0 0 0 x
%             % 0 0 1 1 x
%             

                
            % trigger = strcat(num2str(0),num2str(0),num2str(1), num2str(1));
             %trigger = base2dec(trigger, 2) + 100
%             
%             
%             
             testCase.verifyEqual(Main_Actual_SummaryTrigger, Main_Expected_SummaryTrigger);
%             %
            
%             
            
        end
        
        
        
        
    end
end