classdef OutputTestOddball < matlab.unittest.TestCase
    
    % to run the unit test put: run(OutputTest) in command window
    % use: rew = 2
    % trials = 20
    
    % bei followCannon -> catchTrial is nan
    % muss catch trial mitkodiert werden? ja oder?
    %gibt es sonst noch was was ich vergessen habe?
    
    
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
    % 0 0 0 0 -> CP, noCP, noCatch, noReward -> 100
    % 0 0 0 1 -> CP, noCP, noCatch, Reward ->  101
    % 0 0 1 0 -> CP, noCP, Catch, noReward -> 102
    % 0 0 1 1 -> CP, noCP, Catch, Reward -> 103
    % 0 1 0 0 -> CP, CP, noCatch, noReward -> 104
    % 0 1 0 1 -> CP, CP, noCatch, Reward -> 105
    % 0 1 1 0 -> CP, CP, Catch, noReward -> 106
    % 0 1 1 1 -> CP, CP, Catch, Reward -> 107
    % 1 0 0 0 -> Odd, noOdd, noCatch, noReward -> 108
    % 1 0 0 1 -> Odd, noOdd, noCatch, Reward -> 109
    % 1 0 1 0 -> Odd, noOdd, Catch, noReward -> 110
    % 1 0 1 1 -> Odd, noOdd, Catch, Reward -> 111
    % 1 1 0 0 -> Odd, Odd, noCatch, noReward -> 112
    % 1 1 0 1 -> Odd, Odd, noCatch, Reward -> 113
    % 1 1 1 0 -> Odd, Odd, Catch, noReward -> 114
    % 1 1 1 1 -> Odd, Odd, Catch, Reward -> 115
    %
    % I guess trial 1 has code 255.
    %
    
    %%%%%%%%%%%%
    
    methods (Test)
        
        function testTaskOutputOddball(testCase)
            
            % triggerliste erstellen
            %keyboard
            
            
            
            [Data] = AdaptiveLearning(true);
            
            %keyboard
            Main_Actual_outcome = Data.DataMain.outcome;
            Main_Expected_outcome = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];
            testCase.verifyEqual(Main_Actual_outcome, Main_Expected_outcome);
            
            %
            Main_Actual_pred = Data.DataMain.pred;
            Main_Expected_pred = [307;200;350;299;200;23;10;11;300;162;162;162;162;150;73;73;73;73;73;73];
            testCase.verifyEqual(Main_Actual_pred, Main_Expected_pred);
            
            
            Main_Actual_predErr = round(Data.DataMain.predErr);
            Main_Expected_predErr = [0;114;75;0;179;0;10;0;172;6;8;44;6;87;8;6;12;21;39;9];
            testCase.verifyEqual(Main_Actual_predErr, Main_Expected_predErr);
            
            Main_Actual_hit = Data.DataMain.hit;
            Main_Expected_hit = [1; 0; 0; 1; 0; 1; 1; 1; 0; 1; 1; 0; 1; 0; 1; 1; 0; 0; 0; 1];
            testCase.verifyEqual(Main_Actual_hit, Main_Expected_hit);
            
            Main_Actual_UP = round(Data.DataMain.UP);
            Main_Expected_UP = [0;107;150;51; 99;177;13;1;71; 138;0;  0;    0;12; 77; 0; 0; 0; 0; 0];
            testCase.verifyEqual(Main_Actual_UP, Main_Expected_UP);
            
            Main_Actual_allASS = round(Data.DataMain.allASS);
            Main_Expected_allASS = round([11.0911946854474;42.7721549861295;20.6452074040670;30.0590067560821;64.2584937909519;12.5238023413691;40.6585624004766;30.6687068315704;24.0647917958204;30.7574110311965;20.3993435965304;74.7776255380259;24.8318515931322;15.8088280244768;24.0309958861010;17.9429379577234;16.5571588417380;12.1121520806927;30.4298216823390;34.2607565195953]);
            testCase.verifyEqual(Main_Actual_allASS, Main_Expected_allASS);
            
            Main_Actual_catchTrial = Data.DataMain.catchTrial;
            Main_Expected_catchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
            testCase.verifyEqual(Main_Actual_catchTrial, Main_Expected_catchTrial);
            
            Main_Actual_cp = Data.DataMain.cp;
            Main_Expected_cp = [1;0;0;0;1;0;0;0;1;0;0;0;0;1;0;0;0;0;0;0];
            testCase.verifyEqual(Main_Actual_cp, Main_Expected_cp);
            
            Main_Actual_distMean = Data.DataMain.distMean;
            Main_Expected_distMean = [292;292;292;292;10;10;10;10;162;162;162;162;162;73;73;73;73;73;73;73];
            testCase.verifyEqual(Main_Actual_distMean, Main_Expected_distMean);
            
            Main_Actual_perf = Data.DataMain.perf;
            Main_Expected_perf = [0.1;  0;  0;0.1;  0;0.1;0.1;  0;  0;0.1;  0;  0;  0;  0;  0;  0;0;0;0;0.1];
            testCase.verifyEqual(Main_Actual_perf, Main_Expected_perf);
            
            Main_Actual_accPerf = Data.DataMain.accPerf;
            Main_Expected_accPerf = [0.1;0.1;0.1;0.2;0.2;0.3;0.4;0.4;0.4;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.6];
            testCase.verifyEqual(Main_Actual_accPerf, Main_Expected_accPerf, 'AbsTol', 0.0001);
            
            Main_Actual_memErr = Data.DataMain.memErr;
            Main_Expected_memErr = [999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999];
            testCase.verifyEqual(Main_Actual_memErr, Main_Expected_memErr)
            %
            Main_Actual_sigma = Data.DataMain.sigma;
            Main_Expected_sigma = [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10];
            testCase.verifyEqual(Main_Actual_sigma, Main_Expected_sigma);
            %
            Main_Actual_vola = Data.DataMain.vola;
            Main_Expected_vola = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25];
            testCase.verifyEqual(Main_Actual_vola, Main_Expected_vola);
            %
            Main_Actual_trial = Data.DataMain.trial;
            Main_Expected_trial = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            testCase.verifyEqual(Main_Actual_trial, Main_Expected_trial);
            %
            Main_Actual_cond = Data.DataMain.cond;
            Main_Expected_cond = {'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main'};
            testCase.verifyEqual(Main_Actual_cond, Main_Expected_cond);
            %
            Main_Actual_oddBall = Data.DataMain.oddBall;
            Main_Expected_oddBall = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
            testCase.verifyEqual(Main_Actual_oddBall, Main_Expected_oddBall);
            %
            Main_Actual_oddballProb = Data.DataMain.oddballProb;
            Main_Expected_oddballProb = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25;.25; .25; .25; .25; .25;.25; .25; .25; .25; .25;];
            testCase.verifyEqual(Main_Actual_oddballProb, Main_Expected_oddballProb);
            %
            Main_Actual_driftConc = Data.DataMain.driftConc;
            Main_Expected_driftConc = [30; 30; 30; 30; 30; 30; 30; 30; 30; 30;30; 30; 30; 30; 30;30; 30; 30; 30; 30];
            testCase.verifyEqual(Main_Actual_driftConc, Main_Expected_driftConc);
            
            Main_Actual_block = Data.DataMain.block;
            Main_Expected_block = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            testCase.verifyEqual(Main_Actual_block, Main_Expected_block);
            
            Main_Actual_shieldType = Data.DataMain.shieldType;
            Main_Expected_shieldType = [0;1;0;0;0;0;0;1;1;0;1;0;1;1;1;1;0;1;1;0];
            testCase.verifyEqual(Main_Actual_shieldType, Main_Expected_shieldType);
            %
            Main_Actual_actRew = Data.DataMain.actRew;
            Main_Expected_actRew = [1;2;1;1;1;1;1;2;2;1;2;1;2;2;2;2;1;2;2;1];
            testCase.verifyEqual(Main_Actual_actRew, Main_Expected_actRew);
            %
            Main_Actual_rew = Data.DataMain.rew;
            Main_Expected_rew = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(Main_Actual_rew, Main_Expected_rew);
            %
            Main_Actual_trigger1 = Data.DataMain.triggers(:,1);
            Main_Expected_trigger1 = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1;];
            testCase.verifyEqual(Main_Actual_trigger1, Main_Expected_trigger1);
            %
            Main_Actual_trigger2 = Data.DataMain.triggers(:,2);
            Main_Expected_trigger2 = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(Main_Actual_trigger2, Main_Expected_trigger2);
            
            Main_Actual_trigger3 = Data.DataMain.triggers(:,3);
            Main_Expected_trigger3 = [3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3;];
            testCase.verifyEqual(Main_Actual_trigger3, Main_Expected_trigger3);
            %
            Main_Actual_trigger4 = Data.DataMain.triggers(:,4);
            Main_Expected_trigger4 = [4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4;];
            testCase.verifyEqual(Main_Actual_trigger4, Main_Expected_trigger4);
            
            Main_Actual_trigger5 = Data.DataMain.triggers(:,5);
            Main_Expected_trigger5 = [5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5;];
            testCase.verifyEqual(Main_Actual_trigger5, Main_Expected_trigger5);
            
            Main_Actual_trigger6 = Data.DataMain.triggers(:,6);
            Main_Expected_trigger6 = [6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6;];
            testCase.verifyEqual(Main_Actual_trigger6, Main_Expected_trigger6);
            %
            
            % triggerschema hat sich natürlich verändert! wieder das
            % brown triggerschema verwenden... hab ich... jetzt
            % triggers hier rein setzen.
            Main_Actual_SummaryTrigger = Data.DataMain.triggers(:,7);
            Main_Expected_SummaryTrigger = [255;100;101;103;105;   103;103;102;104;103;    102;101;102;104;102;    102;101;100;100;103];
            
            %Main_Expected_SummaryTrigger = [255;101;102;107;110;   106;106;104;108;107;    104;102;104;108;105;    104;102;100;100;106];
            
            %condition + cp
            % digit1 = 0
            
            % digit 2 =
            %Main_Expected_cp = [1;0;0;0;1;0;0;0;1;0;0;0;0;1;0;0;0;0;0;0];
            
            % digit3 = hit
            % Main_Expected_hit = [1; 0; 0; 1; 0; 1; 1; 1; 0; 1; 1; 0; 1; 0; 1; 1; 0; 0; 0; 1];
            
            % digit4 = actRew
            % Main_Expected_actRew = [1;2;1;1;1;1;1;2;2;1;2;1;2;2;2;2;1;2;2;1];
            
            % 0 1 1 1 x
            % 0 0 0 0 x
            % 0 0 0 1 x
            % 0 0 1 1 x
            % 0 1 0 1 x
            
            % 0 0 1 1 x
            % 0 0 1 1 x
            % 0 0 1 0 x
            % 0 1 0 0 x
            % 0 0 1 1 x
            
            % 0 0 1 0 x
            % 0 0 0 1 x
            % 0 0 1 0 x
            % 0 1 0 0 x
            % 0 0 1 0 x
            
            % 0 0 1 0 x
            % 0 0 0 1 x
            % 0 0 0 0 x
            % 0 0 0 0 x
            % 0 0 1 1 x
            
            %trigger = strcat(num2str(0),num2str(0),num2str(0), num2str(0));
            %trigger = base2dec(trigger, 2) + 100
            
            
            
            testCase.verifyEqual(Main_Actual_SummaryTrigger, Main_Expected_SummaryTrigger);
            %
            
            %% Oddball %%
            
            
            Oddball_Actual_outcome = Data.DataOddball.outcome;
            Oddball_Expected_outcome = [168;52;27;356;50;57;26;40;345;42;45;19;45;48;25;52;17;56;32;50];
            testCase.verifyEqual(Oddball_Actual_outcome, Oddball_Expected_outcome);
            
            
            Oddball_Actual_pred = Data.DataOddball.pred;
            Oddball_Expected_pred = [0;169;105;28;13;   34;46;37;37;10;     26;36;28;36;41;     34;44;30;42;38];
            testCase.verifyEqual(Oddball_Actual_pred, Oddball_Expected_pred);
            
            Oddball_Actual_predErr = round(Data.DataOddball.predErr);
            Oddball_Expected_predErr = [168;117;78;32;37;23;20;3;52;32;19;17;17;12;16;18;27;26;10;12];
            testCase.verifyEqual(Oddball_Actual_predErr, Oddball_Expected_predErr);
            
            Oddball_Actual_hit = Data.DataOddball.hit;
            Oddball_Expected_hit = [0;0;0;1;0;0;1;1;0;0;1;1;1;1;1;0;0;0;1;1];
            testCase.verifyEqual(Oddball_Actual_hit, Oddball_Expected_hit);
            
            Oddball_Actual_UP = round(Data.DataOddball.UP);
            Oddball_Expected_UP = [0;169;64;77;15;  21;12;9;0;27;    16;10;8;8;5;    7;10;14;12;4];
            testCase.verifyEqual(Oddball_Actual_UP, Oddball_Expected_UP);
            
            Oddball_Actual_allASS = round(Data.DataOddball.allASS);
            Oddball_Expected_allASS = round([56.3064169119110;44.7806770819131;32.7628787930898;88.4460393955587;27.5553596399993;23.0169262891260;74.4986218944005;60.0948974162446;57.0078924412632;31.7982792485999;54.3044071256679;70.7407899977594;34.4213389185473;29.2090877790941;32.1457183826683;21.1053433044513;20.3465608984038;46.8616528666608;30.3427769268406;30.4911381108101]);
            testCase.verifyEqual(Oddball_Actual_allASS, Oddball_Expected_allASS);
            
            Oddball_Actual_catchTrial = Data.DataOddball.catchTrial;
            Oddball_Expected_catchTrial = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
            testCase.verifyEqual(Oddball_Actual_catchTrial, Oddball_Expected_catchTrial);
            
            Oddball_Actual_cp = Data.DataOddball.cp;
            Oddball_Expected_cp = [NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN];
            testCase.verifyEqual(Oddball_Actual_cp, Oddball_Expected_cp);
            
            Oddball_Actual_distMean = round(Data.DataOddball.distMean);
            Oddball_Expected_distMean = round([35.9659756492466;19.8262284443369;25.5095503187431;33.0793504979593;36.0514016801332;16.9686796646885;20.9240546489374;21.3119123215556;37.7617830290837;40.7526136296083;49.2648116118448;43.7497656695111;56.4795648563220;51.7035829196282;48.9285095836465;34.0877052038865;23.1005511901041;52.1721565683915;54.1879625643795;65.5393724834024]);
            testCase.verifyEqual(Oddball_Actual_distMean, Oddball_Expected_distMean);
            
            Oddball_Actual_perf = Data.DataOddball.perf;
            Oddball_Expected_perf = [0;0;0;0.100000000000000;0;0;0.100000000000000;0;0;0;0.100000000000000;0.100000000000000;0;0;0;0;0;0;0;0.100000000000000];
            testCase.verifyEqual(Oddball_Actual_perf, Oddball_Expected_perf);
            
            Oddball_Actual_accPerf = Data.DataOddball.accPerf;
            Oddball_Expected_accPerf = [0;0;0;0.100000000000000;0.100000000000000;0.100000000000000;0.200000000000000;0.200000000000000;0.200000000000000;0.200000000000000;0.300000000000000;0.400000000000000;0.400000000000000;0.400000000000000;0.400000000000000;0.400000000000000;0.400000000000000;0.400000000000000;0.400000000000000;0.500000000000000];
            testCase.verifyEqual(Oddball_Actual_accPerf, Oddball_Expected_accPerf, 'AbsTol', 0.01);
            
            Oddball_Actual_memErr = Data.DataOddball.memErr;
            Oddball_Expected_memErr = [999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999];
            testCase.verifyEqual(Oddball_Actual_memErr, Oddball_Expected_memErr)
            
            Oddball_Actual_sigma = Data.DataOddball.sigma;
            Oddball_Expected_sigma = [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10];
            testCase.verifyEqual(Oddball_Actual_sigma, Oddball_Expected_sigma);
            
            Oddball_Actual_vola = Data.DataOddball.vola;
            Oddball_Expected_vola = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25];
            testCase.verifyEqual(Oddball_Actual_vola, Oddball_Expected_vola);
            
            Oddball_Actual_trial = Data.DataOddball.trial;
            Oddball_Expected_trial = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            testCase.verifyEqual(Oddball_Actual_trial, Oddball_Expected_trial);
            
            Oddball_Actual_cond = Data.DataOddball.cond;
            Oddball_Expected_cond = {'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball';'oddball'};
            testCase.verifyEqual(Oddball_Actual_cond, Oddball_Expected_cond);
            
            Oddball_Actual_oddBall = Data.DataOddball.oddBall;
            Oddball_Expected_oddBall = [true;false;false;false;false;false;false;false;true;false;false;false;false;false;false;true;false;false;false;false];
            testCase.verifyEqual(Oddball_Actual_oddBall, Oddball_Expected_oddBall);
            
            Oddball_Actual_oddballProb = Data.DataOddball.oddballProb;
            Oddball_Expected_oddballProb = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25;.25; .25; .25; .25; .25;.25; .25; .25; .25; .25;];
            testCase.verifyEqual(Oddball_Actual_oddballProb, Oddball_Expected_oddballProb);
            
            Oddball_Actual_driftConc = Data.DataOddball.driftConc;
            Oddball_Expected_driftConc = [30; 30; 30; 30; 30; 30; 30; 30; 30; 30;30; 30; 30; 30; 30;30; 30; 30; 30; 30];
            testCase.verifyEqual(Oddball_Actual_driftConc, Oddball_Expected_driftConc);
            
            Oddball_Actual_block = Data.DataOddball.block;
            Oddball_Expected_block = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            testCase.verifyEqual(Oddball_Actual_block, Oddball_Expected_block);
            
            Oddball_Actual_shieldType = Data.DataOddball.shieldType;
            Oddball_Expected_shieldType = [0;0;1;0;0;1;0;1;0;1;0;0;1;1;1;0;1;1;1;0];
            testCase.verifyEqual(Oddball_Actual_shieldType, Oddball_Expected_shieldType);
            
            Oddball_Actual_actRew = Data.DataOddball.actRew;
            Oddball_Expected_actRew =  [1;1;2;1;1;2;1;2;1;2;1;1;2;2;2;1;2;2;2;1];
            testCase.verifyEqual(Oddball_Actual_actRew, Oddball_Expected_actRew);
            
            Oddball_Actual_rew = Data.DataOddball.rew;
            Oddball_Expected_rew = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(Oddball_Actual_rew, Oddball_Expected_rew);
            
            Oddball_Actual_trigger1 = Data.DataOddball.triggers(:,1);
            Oddball_Expected_trigger1 = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1;];
            testCase.verifyEqual(Oddball_Actual_trigger1, Oddball_Expected_trigger1);
            
            Oddball_Actual_trigger2 = Data.DataOddball.triggers(:,2);
            Oddball_Expected_trigger2 = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(Oddball_Actual_trigger2, Oddball_Expected_trigger2);
            
            Oddball_Actual_trigger3 = Data.DataOddball.triggers(:,3);
            Oddball_Expected_trigger3 = [3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3;];
            testCase.verifyEqual(Oddball_Actual_trigger3, Oddball_Expected_trigger3);
            
            Oddball_Actual_trigger4 = Data.DataOddball.triggers(:,4);
            Oddball_Expected_trigger4 = [4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4;];
            testCase.verifyEqual(Oddball_Actual_trigger4, Oddball_Expected_trigger4);
            
            Oddball_Actual_trigger5 = Data.DataOddball.triggers(:,5);
            Oddball_Expected_trigger5 = [5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5;];
            testCase.verifyEqual(Oddball_Actual_trigger5, Oddball_Expected_trigger5);
            
            Oddball_Actual_trigger6 = Data.DataOddball.triggers(:,6);
            Oddball_Expected_trigger6 = [6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6;];
            testCase.verifyEqual(Oddball_Actual_trigger6, Oddball_Expected_trigger6);
            
            
            % 1 0 0 0 -> Odd, noOdd, noCatch, noReward -> 108
            % 1 0 0 1 -> Odd, noOdd, noCatch, Reward -> 109
            % 1 0 1 0 -> Odd, noOdd, Catch, noReward -> 110
            % 1 0 1 1 -> Odd, noOdd, Catch, Reward -> 111
            % 1 1 0 0 -> Odd, Odd, noCatch, noReward -> 112
            % 1 1 0 1 -> Odd, Odd, noCatch, Reward -> 113
            % 1 1 1 0 -> Odd, Odd, Catch, noReward -> 114
            % 1 1 1 1 -> Odd, Odd, Catch, Reward -> 115
            
            
            %
            %% trigger funktionieren mit jetzigen einstellungen. jetzt andere dinger testen und u.u. trigger anpassen damit alles
            %% getestet wird.
            
            
            % triggerschema hat sich natürlich verändert! wieder das
            %                 % brown triggerschema verwenden... hab ich... jetzt
            %                 % triggers hier rein setzen.
            
            %                 %Oddball_Expected_SummaryTrigger = [255;101;102;107;110;   106;106;104;108;107;    104;102;104;108;105;    104;102;100;100;106];
            %
            %                 %condition
            %                 % digit1 = 1
            %
            %                 % digit 2 =
            %Oddball_Expected_oddBall = [true;false;false;false;false;  false;false;false;true;false;   false;false;false;false;false;      true;false;false;false;false];
            
            %
            %                  % digit3 = hit
            %Oddball_Expected_hit = [0;0;0;1;0;     0;1;1;0;0;      1;1;1;1;1;      0;0;0;1;1];
            %
            %                 % digit4 = actRew
            %                 Oddball_Expected_actRew = [1;1;2;1;1;     2;1;2;1;2;      1;1;2;2;2;      1;2;2;2;1];
            %
            %                 % 255
            %                 % 1 0 0 1
            %                 % 1 0 0 0
            %                 % 1 0 1 1
            %                 % 1 0 0 1
            %
            %                 % 1 0 0 0
            %                 % 1 0 1 1
            %                 % 1 0 1 0
            %                 % 1 1 0 1
            %                 % 1 0 0 0
            %
            %                 % 1 0 1 1
            %                 % 1 0 1 1
            %                 % 1 0 1 0
            %                 % 1 0 1 0
            %                 % 1 0 1 0
            %
            %                 % 1 1 0 1
            %                 % 1 0 0 0
            %                 % 1 0 0 0
            %                 % 1 0 1 0
            %                 % 1 0 1 1
            %
            %trigger = strcat(num2str(1),num2str(1),num2str(0), num2str(1));
            %trigger = base2dec(trigger, 2) + 100
            %
            %
            Oddball_Actual_SummaryTrigger = Data.DataOddball.triggers(:,7);
            Oddball_Expected_SummaryTrigger = [255;109;108;111;109;   108;111;110;113;108;    111;111;110;110;110;    113;108;108;110;111];
            
            testCase.verifyEqual(Oddball_Actual_SummaryTrigger, Oddball_Expected_SummaryTrigger);
            % %
            
        end
        
        
        
        
    end
end