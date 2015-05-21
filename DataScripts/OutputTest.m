classdef OutputTest < matlab.unittest.TestCase
    

% bei followCannon -> catchTrial is nan
% muss catch trial mitkodiert werden? ja oder?
%gibt es sonst noch was was ich vergessen habe?


% checken ob predErr 1 besser nan sein sollte

%  0 0 0 0 -> CP, noCP, noCatch, noReward -> 100
%  0 0 0 1 -> CP, noCP, noCatch, Reward ->  101
%  0 0 1 0 -> CP, noCP, Catch, noReward -> 102
%  0 0 1 1 -> CP, noCP, Catch, Reward -> 103
%  0 1 0 0 -> CP, CP, noCatch, noReward -> 104
%  0 1 0 1 -> CP, CP, noCatch, Reward -> 105
%  0 1 1 0 -> CP, CP, Catch, noReward -> 106
%  0 1 1 1 -> CP, CP, Catch, Reward -> 107

%  1 0 0 0 -> FollowOutcome, noCP, noCatch, noReward -> 108
%  1 0 0 1 -> FollowOutcome, noCP, noCatch, Reward -> 109
%  1 0 1 0 -> FollowOutcome, noCP, Catch, noReward -> 110
%  1 0 1 1 -> FollowOutcome, noCP, Catch, Reward -> 111
%  1 1 0 0 -> FollowOutcome, CP, noCatch, noReward -> 112
%  1 1 0 1 -> FollowOutcome, CP, noCatch, Reward -> 113
%  1 1 1 0 -> FollowOutcome, CP, Catch, noReward -> 114
%  1 1 1 1 -> FollowOutcome, CP, Catch, Reward -> 115

% 10 0 0 0 -> FollowCannon, noCP, noCatch, noReward -> 116
% 10 0 0 1 -> FollowCannon, noCP, noCatch, Reward -> 117
% 10 0 1 0 -> FollowCannon, noCP, Catch, noReward -> 118
% 10 0 1 1 -> FollowCannon, noCP, Catch, Reward -> 119
% 10 1 0 0 -> FollowCannon, CP, noCatch, noReward -> 120
% 10 1 0 1 -> FollowCannon, CP, noCatch, Reward -> 121
% 10 1 1 0 -> FollowCannon, CP, Catch, noReward -> 122
% 10 1 1 1 -> FollowCannon, CP, Catch, Reward -> 123
% 
% I guess trial 1 has code 255. 

%trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4));
       %     trigger = base2dec(trigger, 2) + 100;

% manuell test erstellen
%cp = [1;0;0;0;1;0;0;0;1;0;0;0;0;1;0;0;0;0;0;0];

%outcome = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];
%predMain = [307;200;350;299;200;23;10;11;300;162;162;162;162;150;73;73;73;73;73;73];
% UP =      [0;107;150;51; 99;177;13;1;71; 138;0;  0;    0;12; 77; 0; 0; 0; 0; 0]
            %[0 107 150 51 99 177 13 1 71 138 0 0 0 12 77 0 0 0 0 0]
%predErr =[0;114;75;0;179;0;10;0;172; 6; 8; 44;6; 87;8; 6; 14;21;39;9];
%allASS = [11;43;21;30;64;13;41;31;24;31;20;75;25;16;24;18;17;12;30;34];
   % hit =     [1; 0; 0;  1;0;  1;  1; 1; 0;   1;   1; 0; 1;   0;   1;   1; 0; 0; 0; 1];
% perf =     [0.2;  0;  0;0.2;  0;0.2;0.2;  0;  0;0.2;  0;  0;  0;  0;  0;  0;0;0;0;0.2];

% accPerf =  [0.2;0.2;0.2;0.4;0.4;0.6;0.8;0.8;0.8;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1;1;1;1.2];
%boatType = [0;1;0;0;0;0;0;1;1;0;1;0;1;1;1;1;0;1;1;0];
%actRew =   [1;0;1;1;1;1;1;0;0;1;0;1;0;0;0;0;1;0;0;1];

%catchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
%distMean = [292;292;292;292;10;10;10;10;162;162;162;162;162;73;73;73;73;73;73;73];



% Main

% 1: eigentlich egal
% 2: noCP, noCatch, noRew
% 3: noCP, noCatch, Rew
% 8: noCP, catch, noRew
% 6: noCP, catch, Rew

% 5: CP, noCatch, Rew
% 9: CP, noCatch, noRew
%14: CP, noCatch, noRew



% 4:  noCP, catch, rew
% 7:  noCP, catch, rew
% 10: noCP, catch, rew
% 11: noCP, catch, noRew
% 12: noCP, noCatch, noRew
% 13: noCP, Catch, noRew
% 15: noCP, Catch, noRew
% 16: noCP, noCatch, noRew
% 17: noCP, noCatch, noRew
% 18: noCP, noCatch, noRew
% 19: noCP, noCatch, noRew
% 20: noCP, catch, Rew

%Main_Expected_SummaryTrigger = [255;100;101;103;105;103;103;102;104;103;102;101;102;104;102;102;101;100;100;103];
%FollowOutcome_Expected_SummaryTrigger = [255;116;117;119;121;119;119;118;120;119;118;117;118;120;118;118;117;116;116;119];





    methods (Test)
        
        function testTaskOutput(testCase)
            %             predMain = [307;200;350;299;200;23;10;11;300;162;162;162;162;150;73;73;73;73;73;73];
            %
                         %predFollowOutcome = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];% ones(trial,1);
            %
                      %predFollowCannon = [307;200;350;299;200;23;10;11;300;162;162;162;162;150;73;73;73;73;73;73];
            
            % triggerliste erstellen
            
            [DataMain, DataFollowOutcome, DataFollowCannon] = AdaptiveLearning(true);
            
            Main_Actual_outcome = DataMain.outcome;
            Main_Expected_outcome = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];
            testCase.verifyEqual(Main_Actual_outcome, Main_Expected_outcome);

            Main_Actual_pred = DataMain.pred;
            Main_Expected_pred = [307;200;350;299;200;23;10;11;300;162;162;162;162;150;73;73;73;73;73;73];
            testCase.verifyEqual(Main_Actual_pred, Main_Expected_pred);

            
            Main_Actual_predErr = round(DataMain.predErr);
            Main_Expected_predErr = [0;114;75;0;179;0;10;0;172;6;8;44;6;87;8;6;12;21;39;9];
            testCase.verifyEqual(Main_Actual_predErr, Main_Expected_predErr);

            
            Main_Actual_hit = DataMain.hit;
            Main_Expected_hit = [1; 0; 0; 1; 0; 1; 1; 1; 0; 1; 1; 0; 1; 0; 1; 1; 0; 0; 0; 1];
            testCase.verifyEqual(Main_Actual_hit, Main_Expected_hit);

            Main_Actual_UP = round(DataMain.UP);
            Main_Expected_UP = [0;107;150;51; 99;177;13;1;71; 138;0;  0;    0;12; 77; 0; 0; 0; 0; 0];
            testCase.verifyEqual(Main_Actual_UP, Main_Expected_UP);     
             
            Main_Actual_allASS = round(DataMain.allASS);
            Main_Expected_allASS = round([11.0911946854474;42.7721549861295;20.6452074040670;30.0590067560821;64.2584937909519;12.5238023413691;40.6585624004766;30.6687068315704;24.0647917958204;30.7574110311965;20.3993435965304;74.7776255380259;24.8318515931322;15.8088280244768;24.0309958861010;17.9429379577234;16.5571588417380;12.1121520806927;30.4298216823390;34.2607565195953]);
            testCase.verifyEqual(Main_Actual_allASS, Main_Expected_allASS);

            Main_Actual_catchTrial = DataMain.catchTrial;
            Main_Expected_catchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
            testCase.verifyEqual(Main_Actual_catchTrial, Main_Expected_catchTrial);

            Main_Actual_cp = DataMain.cp;
            Main_Expected_cp = [1;0;0;0;1;0;0;0;1;0;0;0;0;1;0;0;0;0;0;0];
            testCase.verifyEqual(Main_Actual_cp, Main_Expected_cp);

            Main_Actual_distMean = DataMain.distMean;
            Main_Expected_distMean = [292;292;292;292;10;10;10;10;162;162;162;162;162;73;73;73;73;73;73;73];
            testCase.verifyEqual(Main_Actual_distMean, Main_Expected_distMean);


            keyboard
            Main_Actual_perf = DataMain.perf;
            Main_Expected_perf = [0.2;  0;  0;0.2;  0;0.2;0.2;  0;  0;0.2;  0;  0;  0;  0;  0;  0;0;0;0;0.2];
            testCase.verifyEqual(Main_Actual_perf, Main_Expected_perf);

            Main_Actual_accPerf = DataMain.accPerf;
            Main_Expected_accPerf = [0.2;0.2;0.2;0.4;0.4;0.6;0.8;0.8;0.8;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1;1;1;1.2];
            testCase.verifyEqual(Main_Actual_accPerf, Main_Expected_accPerf, 'AbsTol', 0.0001);
            
            Main_Actual_memErr = DataMain.memErr;
            Main_Expected_memErr = [999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999];
            testCase.verifyEqual(Main_Actual_memErr, Main_Expected_memErr)

            Main_Actual_sigma = DataMain.sigma;
            Main_Expected_sigma = [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10];
            testCase.verifyEqual(Main_Actual_sigma, Main_Expected_sigma);

            Main_Actual_vola = DataMain.vola;
            Main_Expected_vola = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25];
            testCase.verifyEqual(Main_Actual_vola, Main_Expected_vola);

            Main_Actual_trial = DataMain.trial;
            Main_Expected_trial = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            testCase.verifyEqual(Main_Actual_trial, Main_Expected_trial);

            Main_Actual_cond = DataMain.cond;
            Main_Expected_cond = {'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main'};
            testCase.verifyEqual(Main_Actual_cond, Main_Expected_cond);
 
            Main_Actual_oddBall = DataMain.oddBall;
            Main_Expected_oddBall = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
            testCase.verifyEqual(Main_Actual_oddBall, Main_Expected_oddBall);

            Main_Actual_oddballProb = DataMain.oddballProb;
            Main_Expected_oddballProb = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25;.25; .25; .25; .25; .25;.25; .25; .25; .25; .25;];
            testCase.verifyEqual(Main_Actual_oddballProb, Main_Expected_oddballProb);

            Main_Actual_driftConc = DataMain.driftConc;
            Main_Expected_driftConc = [30; 30; 30; 30; 30; 30; 30; 30; 30; 30;30; 30; 30; 30; 30;30; 30; 30; 30; 30];
            testCase.verifyEqual(Main_Actual_driftConc, Main_Expected_driftConc);

            Main_Actual_block = DataMain.block;
            Main_Expected_block = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            testCase.verifyEqual(Main_Actual_block, Main_Expected_block);
 
            Main_Actual_boatType = DataMain.boatType;
            Main_Expected_boatType = [0;1;0;0;0;0;0;1;1;0;1;0;1;1;1;1;0;1;1;0];
            testCase.verifyEqual(Main_Actual_boatType, Main_Expected_boatType);
     
            Main_Actual_actRew = DataMain.actRew;
            Main_Expected_actRew = [1;2;1;1;1;1;1;2;2;1;2;1;2;2;2;2;1;2;2;1];
            testCase.verifyEqual(Main_Actual_actRew, Main_Expected_actRew);

            Main_Actual_rew = DataMain.rew;
            Main_Expected_rew = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(Main_Actual_rew, Main_Expected_rew);

            Main_Actual_trigger1 = DataMain.triggers(:,1);
            Main_Expected_trigger1 = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1;];
            testCase.verifyEqual(Main_Actual_trigger1, Main_Expected_trigger1);

            Main_Actual_trigger2 = DataMain.triggers(:,2);
            Main_Expected_trigger2 = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(Main_Actual_trigger2, Main_Expected_trigger2);

            Main_Actual_trigger3 = DataMain.triggers(:,3);
            Main_Expected_trigger3 = [3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3;];
            testCase.verifyEqual(Main_Actual_trigger3, Main_Expected_trigger3);
  
            Main_Actual_trigger4 = DataMain.triggers(:,4);
            Main_Expected_trigger4 = [4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4;];
            testCase.verifyEqual(Main_Actual_trigger4, Main_Expected_trigger4);

            Main_Actual_trigger5 = DataMain.triggers(:,5);
            Main_Expected_trigger5 = [5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5;];
            testCase.verifyEqual(Main_Actual_trigger5, Main_Expected_trigger5);
  
            Main_Actual_trigger6 = DataMain.triggers(:,6);
            Main_Expected_trigger6 = [6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6;];
            testCase.verifyEqual(Main_Actual_trigger6, Main_Expected_trigger6);
            
            Main_Actual_SummaryTrigger = DataMain.triggers(:,7);
            Main_Expected_SummaryTrigger = [255;100;101;103;105;103;103;102;104;103;102;101;102;104;102;102;101;100;100;103];
            testCase.verifyEqual(Main_Actual_SummaryTrigger, Main_Expected_SummaryTrigger);
            
            keyboard

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
%             FollowOutcome_Actual_perf = DataFollowOutcome.perf;
%             FollowOutcome_Expected_perf = [0.2; 0; 0.2;0.2;0.2;0.2;0.2;0;0; 0.2; 0; 0.2; 0; 0; 0; 0; 0.2; 0; 0; 0.2];
%             testCase.verifyEqual(FollowOutcome_Actual_perf, FollowOutcome_Expected_perf);
% 
%             FollowOutcome_Actual_accPerf = DataFollowOutcome.accPerf;
%             FollowOutcome_Expected_accPerf = [0.2;0.2;0.4;0.6;0.8;1;1.2;1.2;1.2;1.4;1.4;1.6;1.6;1.6;1.6;1.6;1.8;1.8;1.8;2];%DataFollowOutcome.accPerf;%[0.200000000000000;0.200000000000000;0.400000000000000;0.600000000000000;0.800000000000000;1;1.20000000000000;1.20000000000000;1.20000000000000;1.40000000000000;1.40000000000000;1.60000000000000;1.60000000000000;1.60000000000000;1.60000000000000;1.60000000000000;1.80000000000000;1.80000000000000;1.80000000000000;2.00000000000000];
%             testCase.verifyEqual(FollowOutcome_Actual_accPerf, FollowOutcome_Expected_accPerf, 'AbsTol', 0.0001);

%             FollowOutcome_Actual_hit = DataFollowOutcome.hit;
%             FollowOutcome_Expected_hit = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
%             testCase.verifyEqual(FollowOutcome_Actual_hit, FollowOutcome_Expected_hit);
%                
            FollowOutcome_Actual_UP = round(DataFollowOutcome.UP);
            FollowOutcome_Expected_UP = round([0;7.00000000000003;39.0000000000000;24.0000000000000;82.0000000000000;2.00000000000000;3.00000000000000;9;117;40.0000000000000;2.00000000000000;36.0000000000000;38;105;18.0000000000000;14.0000000000000;6.00000000000001;33.0000000000000;18;30.0000000000000]);
            testCase.verifyEqual(FollowOutcome_Actual_UP, FollowOutcome_Expected_UP);  
            
%             FollowOutcome_Actual_memErr = DataFollowOutcome.memErr;
%             FollowOutcome_Expected_memErr = [999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999];
%             testCase.verifyEqual(FollowOutcome_Actual_memErr, FollowOutcome_Expected_memErr)
%             
            FollowOutcome_Actual_predErr = round(DataFollowOutcome.predErr);
            FollowOutcome_Expected_predErr = round([0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;]);
            testCase.verifyEqual(FollowOutcome_Actual_predErr, FollowOutcome_Expected_predErr);

            FollowOutcome_Actual_pred = DataFollowOutcome.pred;
            FollowOutcome_Expected_pred = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];
            testCase.verifyEqual(FollowOutcome_Actual_pred, FollowOutcome_Expected_pred);

            FollowOutcome_Actual_catchTrial = DataFollowOutcome.catchTrial;
            FollowOutcome_Expected_catchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
            testCase.verifyEqual(FollowOutcome_Actual_catchTrial, FollowOutcome_Expected_catchTrial);

            FollowOutcome_Actual_cp = DataFollowOutcome.cp;
            FollowOutcome_Expected_cp = [1;0;0;0;1;0;0;0;1;0;0;0;0;1;0;0;0;0;0;0];
            testCase.verifyEqual(FollowOutcome_Actual_cp, FollowOutcome_Expected_cp);
            
            FollowOutcome_Actual_distMean = DataFollowOutcome.distMean;
            FollowOutcome_Expected_distMean = [292;292;292;292;10;10;10;10;162;162;162;162;162;73;73;73;73;73;73;73];
            testCase.verifyEqual(FollowOutcome_Actual_distMean, FollowOutcome_Expected_distMean);

            FollowOutcome_Actual_outcome = DataFollowOutcome.outcome;
            FollowOutcome_Expected_outcome = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];
            testCase.verifyEqual(FollowOutcome_Actual_outcome, FollowOutcome_Expected_outcome);

            FollowOutcome_Actual_sigma = DataFollowOutcome.sigma;
            FollowOutcome_Expected_sigma = [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10];
            testCase.verifyEqual(FollowOutcome_Actual_sigma, FollowOutcome_Expected_sigma);

            FollowOutcome_Actual_vola = DataFollowOutcome.vola;
            FollowOutcome_Expected_vola = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25];
            testCase.verifyEqual(FollowOutcome_Actual_vola, FollowOutcome_Expected_vola);

            FollowOutcome_Actual_trial = DataFollowOutcome.trial;
            FollowOutcome_Expected_trial = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            testCase.verifyEqual(FollowOutcome_Actual_trial, FollowOutcome_Expected_trial);

            FollowOutcome_Actual_cond = DataFollowOutcome.cond;
            FollowOutcome_Expected_cond = {'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome';'followOutcome'};
            testCase.verifyEqual(FollowOutcome_Actual_cond, FollowOutcome_Expected_cond);
 
            FollowOutcome_Actual_oddBall = DataFollowOutcome.oddBall;
            FollowOutcome_Expected_oddBall = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
            testCase.verifyEqual(FollowOutcome_Actual_oddBall, FollowOutcome_Expected_oddBall);

            FollowOutcome_Actual_oddballProb = DataFollowOutcome.oddballProb;
            FollowOutcome_Expected_oddballProb = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25;.25; .25; .25; .25; .25;.25; .25; .25; .25; .25;];
            testCase.verifyEqual(FollowOutcome_Actual_oddballProb, FollowOutcome_Expected_oddballProb);

            FollowOutcome_Actual_driftConc = DataFollowOutcome.driftConc;
            FollowOutcome_Expected_driftConc = [30; 30; 30; 30; 30; 30; 30; 30; 30; 30;30; 30; 30; 30; 30;30; 30; 30; 30; 30];
            testCase.verifyEqual(FollowOutcome_Actual_driftConc, FollowOutcome_Expected_driftConc);
            
            FollowOutcome_Actual_allASS = round(DataFollowOutcome.allASS);
            FollowOutcome_Expected_allASS = round([11.0911946854474;42.7721549861295;20.6452074040670;30.0590067560821;64.2584937909519;12.5238023413691;40.6585624004766;30.6687068315704;24.0647917958204;30.7574110311965;20.3993435965304;74.7776255380259;24.8318515931322;15.8088280244768;24.0309958861010;17.9429379577234;16.5571588417380;12.1121520806927;30.4298216823390;34.2607565195953]);
            testCase.verifyEqual(FollowOutcome_Actual_allASS, FollowOutcome_Expected_allASS);

            FollowOutcome_Actual_block = DataFollowOutcome.block;
            FollowOutcome_Expected_block = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            testCase.verifyEqual(FollowOutcome_Actual_block, FollowOutcome_Expected_block);
 
            FollowOutcome_Actual_boatType = DataFollowOutcome.boatType;
            FollowOutcome_Expected_boatType = [0;1;0;0;0;0;0;1;1;0;1;0;1;1;1;1;0;1;1;0];
            testCase.verifyEqual(FollowOutcome_Actual_boatType, FollowOutcome_Expected_boatType);

            FollowOutcome_Actual_rew = DataFollowOutcome.rew;
            FollowOutcome_Expected_rew = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(FollowOutcome_Actual_rew, FollowOutcome_Expected_rew);

            FollowOutcome_Actual_trigger1 = DataFollowOutcome.triggers(:,1);
            FollowOutcome_Expected_trigger1 = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1;];
            testCase.verifyEqual(FollowOutcome_Actual_trigger1, FollowOutcome_Expected_trigger1);

            FollowOutcome_Actual_trigger2 = DataFollowOutcome.triggers(:,2);
            FollowOutcome_Expected_trigger2 = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(FollowOutcome_Actual_trigger2, FollowOutcome_Expected_trigger2);

            FollowOutcome_Actual_trigger3 = DataFollowOutcome.triggers(:,3);
            FollowOutcome_Expected_trigger3 = [3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3;];
            testCase.verifyEqual(FollowOutcome_Actual_trigger3, FollowOutcome_Expected_trigger3);
  
            FollowOutcome_Actual_trigger4 = DataFollowOutcome.triggers(:,4);
            FollowOutcome_Expected_trigger4 = [4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4;];
            testCase.verifyEqual(FollowOutcome_Actual_trigger4, FollowOutcome_Expected_trigger4);

            FollowOutcome_Actual_trigger5 = DataFollowOutcome.triggers(:,5);
            FollowOutcome_Expected_trigger5 = [5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5;];
            testCase.verifyEqual(FollowOutcome_Actual_trigger5, FollowOutcome_Expected_trigger5);
  
            FollowOutcome_Actual_trigger6 = DataFollowOutcome.triggers(:,6);
            FollowOutcome_Expected_trigger6 = [6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6;];
            testCase.verifyEqual(FollowOutcome_Actual_trigger6, FollowOutcome_Expected_trigger6);

%             FollowOutcome_Actual_SummaryTrigger = DataFollowOutcome.triggers(:,7);
%             FollowOutcome_Expected_SummaryTrigger = [255;102;103;103;107;103;103;102;106;103;102;103;102;106;102;102;103;102;102;103];
%             testCase.verifyEqual(FollowOutcome_Actual_SummaryTrigger, FollowOutcome_Expected_SummaryTrigger);
%             
            keyboard


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            
            FollowCannon_Actual_outcome = DataFollowCannon.outcome;
            FollowCannon_Expected_outcome = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];
            testCase.verifyEqual(FollowCannon_Actual_outcome, FollowCannon_Expected_outcome);

            FollowCannon_Actual_pred = DataFollowCannon.pred;
            FollowCannon_Expected_pred = [307;200;350;299;200;23;10;11;300;162;162;162;162;150;73;73;73;73;73;73];
            testCase.verifyEqual(FollowCannon_Actual_pred, FollowCannon_Expected_pred);

            
            FollowCannon_Actual_predErr = round(DataFollowCannon.predErr);
            FollowCannon_Expected_predErr = [0;114;75;0;179;0;10;0;172;6;8;44;6;87;8;6;12;21;39;9];
            testCase.verifyEqual(FollowCannon_Actual_predErr, FollowCannon_Expected_predErr);

            
            FollowCannon_Actual_hit = DataFollowCannon.hit;
            FollowCannon_Expected_hit = [1; 0; 0; 1; 0; 1; 1; 1; 0; 1; 1; 0; 1; 0; 1; 1; 0; 0; 0; 1];
            testCase.verifyEqual(FollowCannon_Actual_hit, FollowCannon_Expected_hit);

            FollowCannon_Actual_UP = round(DataFollowCannon.UP);
            FollowCannon_Expected_UP = [0;107;150;51; 99;177;13;1;71; 138;0;  0;    0;12; 77; 0; 0; 0; 0; 0];
            testCase.verifyEqual(FollowCannon_Actual_UP, FollowCannon_Expected_UP);     
             
            FollowCannon_Actual_allASS = round(DataFollowCannon.allASS);
            FollowCannon_Expected_allASS = round([11.0911946854474;42.7721549861295;20.6452074040670;30.0590067560821;64.2584937909519;12.5238023413691;40.6585624004766;30.6687068315704;24.0647917958204;30.7574110311965;20.3993435965304;74.7776255380259;24.8318515931322;15.8088280244768;24.0309958861010;17.9429379577234;16.5571588417380;12.1121520806927;30.4298216823390;34.2607565195953]);
            testCase.verifyEqual(FollowCannon_Actual_allASS, FollowCannon_Expected_allASS);

            FollowCannon_Actual_catchTrial = DataFollowCannon.catchTrial;
            FollowCannon_Expected_catchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
            testCase.verifyEqual(FollowCannon_Actual_catchTrial, FollowCannon_Expected_catchTrial);

            FollowCannon_Actual_cp = DataFollowCannon.cp;
            FollowCannon_Expected_cp = [1;0;0;0;1;0;0;0;1;0;0;0;0;1;0;0;0;0;0;0];
            testCase.verifyEqual(FollowCannon_Actual_cp, FollowCannon_Expected_cp);

            FollowCannon_Actual_distMean = DataFollowCannon.distMean;
            FollowCannon_Expected_distMean = [292;292;292;292;10;10;10;10;162;162;162;162;162;73;73;73;73;73;73;73];
            testCase.verifyEqual(FollowCannon_Actual_distMean, FollowCannon_Expected_distMean);

            FollowCannon_Actual_perf = DataFollowCannon.perf;
            FollowCannon_Expected_perf = [0.2;  0;  0;0.2;  0;0.2;0.2;  0;  0;0.2;  0;  0;  0;  0;  0;  0;0;0;0;0.2];
            testCase.verifyEqual(FollowCannon_Actual_perf, FollowCannon_Expected_perf);

            FollowCannon_Actual_accPerf = DataFollowCannon.accPerf;
            FollowCannon_Expected_accPerf = [0.2;0.2;0.2;0.4;0.4;0.6;0.8;0.8;0.8;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1;1;1;1.2];
            testCase.verifyEqual(FollowCannon_Actual_accPerf, FollowCannon_Expected_accPerf, 'AbsTol', 0.0001);
            
            FollowCannon_Actual_memErr = DataFollowCannon.memErr;
            FollowCannon_Expected_memErr = [999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999];
            testCase.verifyEqual(FollowCannon_Actual_memErr, FollowCannon_Expected_memErr)

            FollowCannon_Actual_sigma = DataFollowCannon.sigma;
            FollowCannon_Expected_sigma = [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10];
            testCase.verifyEqual(FollowCannon_Actual_sigma, FollowCannon_Expected_sigma);

            FollowCannon_Actual_vola = DataFollowCannon.vola;
            FollowCannon_Expected_vola = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25];
            testCase.verifyEqual(FollowCannon_Actual_vola, FollowCannon_Expected_vola);

            FollowCannon_Actual_trial = DataFollowCannon.trial;
            FollowCannon_Expected_trial = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            testCase.verifyEqual(FollowCannon_Actual_trial, FollowCannon_Expected_trial);

            FollowCannon_Actual_cond = DataFollowCannon.cond;
            FollowCannon_Expected_cond = {'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon';'followCannon'};
            testCase.verifyEqual(FollowCannon_Actual_cond, FollowCannon_Expected_cond);
 
            FollowCannon_Actual_oddBall = DataFollowCannon.oddBall;
            FollowCannon_Expected_oddBall = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
            testCase.verifyEqual(FollowCannon_Actual_oddBall, FollowCannon_Expected_oddBall);

            FollowCannon_Actual_oddballProb = DataFollowCannon.oddballProb;
            FollowCannon_Expected_oddballProb = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25;.25; .25; .25; .25; .25;.25; .25; .25; .25; .25;];
            testCase.verifyEqual(FollowCannon_Actual_oddballProb, FollowCannon_Expected_oddballProb);

            FollowCannon_Actual_driftConc = DataFollowCannon.driftConc;
            FollowCannon_Expected_driftConc = [30; 30; 30; 30; 30; 30; 30; 30; 30; 30;30; 30; 30; 30; 30;30; 30; 30; 30; 30];
            testCase.verifyEqual(FollowCannon_Actual_driftConc, FollowCannon_Expected_driftConc);

            FollowCannon_Actual_block = DataFollowCannon.block;
            FollowCannon_Expected_block = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            testCase.verifyEqual(FollowCannon_Actual_block, FollowCannon_Expected_block);
 
            FollowCannon_Actual_boatType = DataFollowCannon.boatType;
            FollowCannon_Expected_boatType = [0;1;0;0;0;0;0;1;1;0;1;0;1;1;1;1;0;1;1;0];
            testCase.verifyEqual(FollowCannon_Actual_boatType, FollowCannon_Expected_boatType);
     
            FollowCannon_Actual_actRew = DataFollowCannon.actRew;
            FollowCannon_Expected_actRew = [1;2;1;1;1;1;1;2;2;1;2;1;2;2;2;2;1;2;2;1];
            testCase.verifyEqual(FollowCannon_Actual_actRew, FollowCannon_Expected_actRew);

            FollowCannon_Actual_rew = DataFollowCannon.rew;
            FollowCannon_Expected_rew = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(FollowCannon_Actual_rew, FollowCannon_Expected_rew);

            FollowCannon_Actual_trigger1 = DataFollowCannon.triggers(:,1);
            FollowCannon_Expected_trigger1 = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1;];
            testCase.verifyEqual(FollowCannon_Actual_trigger1, FollowCannon_Expected_trigger1);

            FollowCannon_Actual_trigger2 = DataFollowCannon.triggers(:,2);
            FollowCannon_Expected_trigger2 = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
            testCase.verifyEqual(FollowCannon_Actual_trigger2, FollowCannon_Expected_trigger2);

            FollowCannon_Actual_trigger3 = DataFollowCannon.triggers(:,3);
            FollowCannon_Expected_trigger3 = [3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3;];
            testCase.verifyEqual(FollowCannon_Actual_trigger3, FollowCannon_Expected_trigger3);
  
            FollowCannon_Actual_trigger4 = DataFollowCannon.triggers(:,4);
            FollowCannon_Expected_trigger4 = [4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4;];
            testCase.verifyEqual(FollowCannon_Actual_trigger4, FollowCannon_Expected_trigger4);

            FollowCannon_Actual_trigger5 = DataFollowCannon.triggers(:,5);
            FollowCannon_Expected_trigger5 = [5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5;];
            testCase.verifyEqual(FollowCannon_Actual_trigger5, FollowCannon_Expected_trigger5);
  
            FollowCannon_Actual_trigger6 = DataFollowCannon.triggers(:,6);
            FollowCannon_Expected_trigger6 = [6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6;];
            testCase.verifyEqual(FollowCannon_Actual_trigger6, FollowCannon_Expected_trigger6);
            
            keyboard
            FollowCannon_Actual_SummaryTrigger = DataFollowCannon.triggers(:,7);
            FollowCannon_Expected_SummaryTrigger = [255;116;117;119;121;119;119;118;120;119;118;117;118;120;118;118;117;116;116;119];
            testCase.verifyEqual(FollowCannon_Actual_SummaryTrigger, FollowCannon_Expected_SummaryTrigger);
            
            

        end
        
        
        
        
    end
end