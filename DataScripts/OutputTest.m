classdef OutputTest < matlab.unittest.TestCase
    
    % to run the unit test put: run(OutputTest) in command window
    % use: rew = 2
    % trials = 20
    
    % bei followCannon -> catchTrial is nan
    % muss catch trial mitkodiert werden? ja oder?
    %gibt es sonst noch was was ich vergessen habe?
    
    % neues schema
    
    %  0 0 0 0 0 -> CP, noCP, noCatch, noReward, noCT -> 100
    %  0 0 0 0 1 -> CP, noCP, noCatch, noReward, CT -> 101
    %  0 0 0 1 0 -> CP, noCP, noCatch, Reward, noCT ->  102
    %  0 0 0 1 1 -> CP, noCP, noCatch, Reward, CT ->  103
    %  0 0 1 0 0 -> CP, noCP, Catch, noReward, noCT -> 104
    %  0 0 1 0 1 -> CP, noCP, Catch, noReward, CT -> 105
    %  0 0 1 1 0 -> CP, noCP, Catch, Reward, noCT -> 106
    %  0 0 1 1 1 -> CP, noCP, Catch, Reward, CT -> 107
    %  0 1 0 0 0 -> CP, CP, noCatch, noReward, noCT -> 108
    %  0 1 0 0 1 -> CP, CP, noCatch, noReward, CT -> 109
    %  0 1 0 1 0 -> CP, CP, noCatch, Reward, noCT -> 110
    %  0 1 0 1 1 -> CP, CP, noCatch, Reward, CT -> 111
    %  0 1 1 0 0 -> CP, CP, Catch, noReward, noCT -> 112
    %  0 1 1 0 1 -> CP, CP, Catch, noReward, CT -> 113
    %  0 1 1 1 0 -> CP, CP, Catch, Reward, noCT -> 114
    %  0 1 1 1 1 -> CP, CP, Catch, Reward, CT -> 115
    
    %  1 0 0 0 0 -> FollowOutcome, noCP, noCatch, noReward, noCT -> 116
    %  1 0 0 0 1 -> FollowOutcome, noCP, noCatch, noReward, CT -> 117
    %  1 0 0 1 0 -> FollowOutcome, noCP, noCatch, Reward, noCT ->  118
    %  1 0 0 1 1 -> FollowOutcome, noCP, noCatch, Reward, CT ->  119
    %  1 0 1 0 0 -> FollowOutcome, noCP, Catch, noReward, noCT -> 120
    %  1 0 1 0 1 -> FollowOutcome, noCP, Catch, noReward, CT -> 121
    %  1 0 1 1 0 -> FollowOutcome, noCP, Catch, Reward, noCT -> 122
    %  1 0 1 1 1 -> FollowOutcome, noCP, Catch, Reward, CT -> 123
    %  1 1 0 0 0 -> FollowOutcome, CP, noCatch, noReward, noCT -> 124
    %  1 1 0 0 1 -> FollowOutcome, CP, noCatch, noReward, CT -> 125
    %  1 1 0 1 0 -> FollowOutcome, CP, noCatch, Reward, noCT -> 126
    %  1 1 0 1 1 -> FollowOutcome, CP, noCatch, Reward, CT -> 127
    %  1 1 1 0 0 -> FollowOutcome, CP, Catch, noReward, noCT -> 128
    %  1 1 1 0 1 -> FollowOutcome, CP, Catch, noReward, CT -> 129
    %  1 1 1 1 0 -> FollowOutcome, CP, Catch, Reward, noCT -> 130
    %  1 1 1 1 1 -> FollowOutcome, CP, Catch, Reward, CT -> 131
    
    % 10 0 0 0 1 -> FollowCannon, noCP, noCatch, noReward, CT -> 133
    % 10 0 0 1 1 -> FollowCannon, noCP, noCatch, Reward, CT ->  135
    % 10 0 1 0 1 -> FollowCannon, noCP, Catch, noReward, CT -> 137
    % 10 0 1 1 1 -> FollowCannon, noCP, Catch, Reward, CT -> 139
    % 10 1 0 0 1 -> FollowCannon, CP, noCatch, noReward, CT -> 141
    % 10 1 0 1 1 -> FollowCannon, CP, noCatch, Reward, CT -> 143
    % 10 1 1 0 1 -> FollowCannon, CP, Catch, noReward, CT -> 145
    % 10 1 1 1 1 -> FollowCannon, CP, Catch, Reward, CT -> 147
    
    
    
    
    
    
    
    %  1 0 0 0  -> FollowOutcome, noCP, noCatch, noReward -> 108
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
    
    
    
    % checken ob predErr 1 besser nan sein sollte
    
    %  0 0 0 0 -> CP, noCP, noCatch, noReward -> 100
    %  0 0 0 1 -> CP, noCP, noCatch, Reward ->  101
    %  0 0 1 0 -> CP, noCP, Catch, noReward -> 102
    %  0 0 1 1 -> CP, noCP, Catch, Reward -> 103
    %  0 1 0 0 -> CP, CP, noCatch, noReward -> 104
    %  0 1 0 1 -> CP, CP, noCatch, Reward -> 105
    %  0 1 1 0 -> CP, CP, Catch, noReward -> 106
    %  0 1 1 1 -> CP, CP, Catch, Reward -> 107
    
    
    
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
    %actRew =   [1;0;1;1;1;     1;1;0;0;1;      0;1;0;0;0;0;1;0;0;1];
    
    
    %distMean = [292;292;292;292;10;10;10;10;162;162;162;162;162;73;73;73;73;73;73;73];
    
    
    
    % Main
    
    %  0 0 0 0 0 -> CP, noCP, noCatch, noReward, noCT -> 100
    %  0 0 0 0 1 -> CP, noCP, noCatch, noReward, CT -> 101
    %  0 0 0 1 0 -> CP, noCP, noCatch, Reward, noCT ->  102
    %  0 0 0 1 1 -> CP, noCP, noCatch, Reward, CT ->  103
    %  0 0 1 0 0 -> CP, noCP, Catch, noReward, noCT -> 104
    %  0 0 1 0 1 -> CP, noCP, Catch, noReward, CT -> 105
    %  0 0 1 1 0 -> CP, noCP, Catch, Reward, noCT -> 106
    %  0 0 1 1 1 -> CP, noCP, Catch, Reward, CT -> 107
    %  0 1 0 0 0 -> CP, CP, noCatch, noReward, noCT -> 108
    %  0 1 0 0 1 -> CP, CP, noCatch, noReward, CT -> 109
    %  0 1 0 1 0 -> CP, CP, noCatch, Reward, noCT -> 110
    %  0 1 0 1 1 -> CP, CP, noCatch, Reward, CT -> 111
    %  0 1 1 0 0 -> CP, CP, Catch, noReward, noCT -> 112
    %  0 1 1 0 1 -> CP, CP, Catch, noReward, CT -> 113
    %  0 1 1 1 0 -> CP, CP, Catch, Reward, noCT -> 114
    %  0 1 1 1 1 -> CP, CP, Catch, Reward, CT -> 115
    
    % 1: eigentlich egal
    % 2: noCP, noCatch, noRew, CT -> 101
    % 3: noCP, noCatch, Rew, noCT -> 102
    % 8: noCP, catch, noRew, noCT -> 104
    % 6: noCP, catch, Rew, noCT -> 106
    
    % 5: CP, noCatch, Rew, noCT -> 110
    % 9: CP, noCatch, noRew, noCT -> 108
    %14: CP, noCatch, noRew, noCT -> 108
    
    % 4:  noCP, catch, rew, CT -> 107
    % 7:  noCP, catch, rew, noCT -> 106
    % 10: noCP, catch, rew, CT -> 107
    % 11: noCP, catch, noRew, noCT -> 104
    % 12: noCP, noCatch, rew, noCt -> 102
    % 13: noCP, Catch, noRew, noCT -> 104
    % 15: noCP, Catch, noRew, CT -> 105
    % 16: noCP, Catch, noRew, noCT -> 104
    % 17: noCP, noCatch, Rew, noCT -> 102
    % 18: noCP, noCatch, noRew, noCT -> 100
    % 19: noCP, noCatch, noRew, noCT -> 100
    % 20: noCP, catch, Rew, noCT -> 106
    
    
    %catchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
    
    %Main_Expected_SummaryTrigger = [255;101;102;107;110;   106;106;104;108;107;    104;102;104;108;105;    104;102;100;100;106];
    
    
    
    %%%%%%%%%%%%%%%
    
    %  1 0 0 0 0 -> FollowOutcome, noCP, noCatch, noReward, noCT -> 116
    %  1 0 0 0 1 -> FollowOutcome, noCP, noCatch, noReward, CT -> 117
    %  1 0 0 1 0 -> FollowOutcome, noCP, noCatch, Reward, noCT ->  118
    %  1 0 0 1 1 -> FollowOutcome, noCP, noCatch, Reward, CT ->  119
    %  1 0 1 0 0 -> FollowOutcome, noCP, Catch, noReward, noCT -> 120
    %  1 0 1 0 1 -> FollowOutcome, noCP, Catch, noReward, CT -> 121
    %  1 0 1 1 0 -> FollowOutcome, noCP, Catch, Reward, noCT -> 122
    %  1 0 1 1 1 -> FollowOutcome, noCP, Catch, Reward, CT -> 123
    %  1 1 0 0 0 -> FollowOutcome, CP, noCatch, noReward, noCT -> 124
    %  1 1 0 0 1 -> FollowOutcome, CP, noCatch, noReward, CT -> 125
    %  1 1 0 1 0 -> FollowOutcome, CP, noCatch, Reward, noCT -> 126
    %  1 1 0 1 1 -> FollowOutcome, CP, noCatch, Reward, CT -> 127
    %  1 1 1 0 0 -> FollowOutcome, CP, Catch, noReward, noCT -> 128
    %  1 1 1 0 1 -> FollowOutcome, CP, Catch, noReward, CT -> 129
    %  1 1 1 1 0 -> FollowOutcome, CP, Catch, Reward, noCT -> 130
    %  1 1 1 1 1 -> FollowOutcome, CP, Catch, Reward, CT -> 131
    
    
    
    
    
    % followOutcome
    %cp =                   [1;  0;  0;  0; 1; 0; 0; 0;  1;  0;  0;  0;  0; 1; 0; 0; 0; 0; 0; 0];
    %predFollowOutcome = [307;200;100;275;299;     21;23;20;11 ;128;   168;170;206;168;100;0  ; 250;250;250;112];
    % UP =               [0  ;107;100;175; 24;     82; 2; 3;  9;117;    40;  2; 36; 38; 68;100; 110; 0 ;  0;138];
    
    
    % outcome =          [307;314;275;299; 21;     23;20;11;128;168;   170;206;168; 63; 81;67; 61; 94;112;82];
    % memErr =            [999;107;146;  0;  0; 0; 0; 0; 0;   0;  0;  0;  0;  0; 37;81;177;171;156;112];
    % hit =               [  0; 0;  0;  1;  1;  1;  1;  1;  1;  1;  1;  1;  1;  1;   0; 0;  0;  0;  0;  1;];
    %actRew =             [  1; 0;  1;  1;  1;  1;  1;  0;  0;  1;  0;  1;  0;  0;   0; 0;  1;  0;  0;  1];
    
    % perf =              [  0; 0;  0;0.2;0.2;0.2;0.2;  0;  0;0.2;  0;0.2;  0;  0;   0;  0;  0;  0;  0;0.2;];
    % accPerf =           [  0; 0;  0;0.2;0.4;0.6;0.8;0.8;0.8;  1;  1;1.2;1.2;1.2; 1.2;1.2;1.2;1.2;1.2;1.4;];
    
    
    % predErr =           [  0;114;175; 24; 82; 2; 3; 9;117; 40;  2; 36; 38;105; 19;67;171;156;138;82];
    
    
    
    %1: 255
    %2: noCP, noCatch, noRew, CT -> 117
    %3: noCP, noCatch, Rew, noCT -> 118
    %8: noCP, Catch, noRew, noCT -> 120
    %4: noCP, Catch, Rew, CT -> 123
    
    %9 CP, Catch, noRew, noCT -> 128
    %5 CP, Catch, Rew, noCT -> 130
    %14: CP, Catch, noRew, noCT -> 128
    
    %6:  noCP, Catch, rew, noCT -> 122
    %7:  noCP, Catch, rew, noCT -> 122
    
    %10: noCP, Catch, rew, CT -> 123
    %11: noCP, Catch, noRew, noCT -> 120
    %12: noCP, Catch, rew, noCT -> 122
    %13: noCP, Catch, noRew, noCT -> 120
    %15: noCP, noCatch,noRew ,CT -> 117
    %16: noCP, noCatch, noRew, noCT -> 116
    %17: noCP, noCatch, Rew, noCT -> 118
    %18: noCP, noCatch, noRew, noCT -> 116
    %19: noCP, noCatch, noRew, noCT -> 116
    %20: noCP, Catch, rew, noCT -> 122
    
    %catchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
    
    
    %FollowOutcome_Expected_SummaryTrigger = [255;117;118;123;130;  122;122;120;128;123;    120;122;120;128;117;    116;118;116;116;122];
    
    %          actRew =   [1;0;1;1;1;   1;1;0;0;1;  0;1;0;0;0;  0;1;0;0;1];
    
    
    %%%%%%%%%%%%%
    
    
    % 10 0 0 0 1 -> FollowCannon, noCP, noCatch, noReward, CT -> 133
    % 10 0 0 1 1 -> FollowCannon, noCP, noCatch, Reward, CT ->  135
    % 10 0 1 0 1 -> FollowCannon, noCP, Catch, noReward, CT -> 137
    % 10 0 1 1 1 -> FollowCannon, noCP, Catch, Reward, CT -> 139
    % 10 1 0 0 1 -> FollowCannon, CP, noCatch, noReward, CT -> 141
    % 10 1 0 1 1 -> FollowCannon, CP, noCatch, Reward, CT -> 143
    % 10 1 1 0 1 -> FollowCannon, CP, Catch, noReward, CT -> 145
    % 10 1 1 1 1 -> FollowCannon, CP, Catch, Reward, CT -> 147
    
    
    
    % 1: eigentlich egal
    % 2: noCP, noCatch, noRew -> 133
    % 3: noCP, noCatch, Rew -> 135
    % 8: noCP, catch, noRew, -> 137
    % 6: noCP, catch, Rew -> 139
    
    % 5: CP, noCatch, Rew -> 143
    % 9: CP, noCatch, noRew -> 141
    %14: CP, noCatch, noRew -> 141
    
    % 4:  noCP, catch, rew -> 139
    % 7:  noCP, catch, rew -> 139
    % 10: noCP, catch, rew -> 139
    % 11: noCP, catch, noRew -> 137
    % 12: noCP, noCatch, rew -> 135
    % 13: noCP, Catch, noRew -> 137
    % 15: noCP, Catch, noRew -> 137
    % 16: noCP, Catch, noRew -> 137
    % 17: noCP, noCatch, Rew -> 135
    % 18: noCP, noCatch, noRew -> 133
    % 19: noCP, noCatch, noRew -> 133
    % 20: noCP, catch, Rew -> 139
    
    
    % FollowCannon_Expected_SummaryTrigger = [255;133;135;139;143;  139;139;137;141;139;    137;135;137;141;137;    137;135;133;133;139];
    
    
    
    %%%%%%%%%%%%
    
    methods (Test)
        
        function testTaskOutput(testCase)
            %             predMain = [307;200;350;299;200;23;10;11;300;162;162;162;162;150;73;73;73;73;73;73];
            %
            %%predFollowCannon = [307;200;350;299;200;23;10;11;300;162;162;162;162;150;73;73;73;73;73;73];
            
            
            % triggerliste erstellen
            keyboard
            %oddball = true;
            
%             if oddball
%                 
%                 [DataMain,~,~, DataOddball] = AdaptiveLearning(true);
%                 
%                 Main_Actual_outcome = DataMain.outcome;
%                 Main_Expected_outcome = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];
%                 testCase.verifyEqual(Main_Actual_outcome, Main_Expected_outcome);
%                 
%                 Main_Actual_pred = DataMain.pred;
%                 Main_Expected_pred = [307;200;350;299;200;23;10;11;300;162;162;162;162;150;73;73;73;73;73;73];
%                 testCase.verifyEqual(Main_Actual_pred, Main_Expected_pred);
%                 
%                 Main_Actual_predErr = round(DataMain.predErr);
%                 Main_Expected_predErr = [0;114;75;0;179;0;10;0;172;6;8;44;6;87;8;6;12;21;39;9];
%                 testCase.verifyEqual(Main_Actual_predErr, Main_Expected_predErr);
%                 
%                 Main_Actual_hit = DataMain.hit;
%                 Main_Expected_hit = [1; 0; 0; 1; 0; 1; 1; 1; 0; 1; 1; 0; 1; 0; 1; 1; 0; 0; 0; 1];
%                 testCase.verifyEqual(Main_Actual_hit, Main_Expected_hit);
%                 
%                 Main_Actual_UP = round(DataMain.UP);
%                 Main_Expected_UP = [0;107;150;51; 99;177;13;1;71; 138;0;  0;    0;12; 77; 0; 0; 0; 0; 0];
%                 testCase.verifyEqual(Main_Actual_UP, Main_Expected_UP);
%                 
%                 Main_Actual_allASS = round(DataMain.allASS);
%                 Main_Expected_allASS = round([11.0911946854474;42.7721549861295;20.6452074040670;30.0590067560821;64.2584937909519;12.5238023413691;40.6585624004766;30.6687068315704;24.0647917958204;30.7574110311965;20.3993435965304;74.7776255380259;24.8318515931322;15.8088280244768;24.0309958861010;17.9429379577234;16.5571588417380;12.1121520806927;30.4298216823390;34.2607565195953]);
%                 testCase.verifyEqual(Main_Actual_allASS, Main_Expected_allASS);
%                 
%                 Main_Actual_catchTrial = DataMain.catchTrial;
%                 Main_Expected_catchTrial = [0;1;0;1;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0];
%                 testCase.verifyEqual(Main_Actual_catchTrial, Main_Expected_catchTrial);
%                 
%                 Main_Actual_cp = DataMain.cp;
%                 Main_Expected_cp = [1;0;0;0;1;0;0;0;1;0;0;0;0;1;0;0;0;0;0;0];
%                 testCase.verifyEqual(Main_Actual_cp, Main_Expected_cp);
%                 
%                 Main_Actual_distMean = DataMain.distMean;
%                 Main_Expected_distMean = [292;292;292;292;10;10;10;10;162;162;162;162;162;73;73;73;73;73;73;73];
%                 testCase.verifyEqual(Main_Actual_distMean, Main_Expected_distMean);
%                 
%                 Main_Actual_perf = DataMain.perf;
%                 Main_Expected_perf = [0.1;  0;  0;0.1;  0;0.1;0.1;  0;  0;0.1;  0;  0;  0;  0;  0;  0;0;0;0;0.1];
%                 testCase.verifyEqual(Main_Actual_perf, Main_Expected_perf);
%                 
%                 Main_Actual_accPerf = DataMain.accPerf;
%                 Main_Expected_accPerf = [0.1;0.1;0.1;0.2;0.2;0.3;0.4;0.4;0.4;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.6];
%                 testCase.verifyEqual(Main_Actual_accPerf, Main_Expected_accPerf, 'AbsTol', 0.0001);
%                 
%                 Main_Actual_memErr = DataMain.memErr;
%                 Main_Expected_memErr = [999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999];
%                 testCase.verifyEqual(Main_Actual_memErr, Main_Expected_memErr)
%                 
%                 Main_Actual_sigma = DataMain.sigma;
%                 Main_Expected_sigma = [12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12];
%                 testCase.verifyEqual(Main_Actual_sigma, Main_Expected_sigma);
%                 
%                 Main_Actual_vola = DataMain.vola;
%                 Main_Expected_vola = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25];
%                 testCase.verifyEqual(Main_Actual_vola, Main_Expected_vola);
%                 
%                 Main_Actual_trial = DataMain.trial;
%                 Main_Expected_trial = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
%                 testCase.verifyEqual(Main_Actual_trial, Main_Expected_trial);
%                 
%                 Main_Actual_cond = DataMain.cond;
%                 Main_Expected_cond = {'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main';'main'};
%                 testCase.verifyEqual(Main_Actual_cond, Main_Expected_cond);
%                 
%                 Main_Actual_oddBall = DataMain.oddBall;
%                 Main_Expected_oddBall = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
%                 testCase.verifyEqual(Main_Actual_oddBall, Main_Expected_oddBall);
%                 
%                 Main_Actual_oddballProb = DataMain.oddballProb;
%                 Main_Expected_oddballProb = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25;.25; .25; .25; .25; .25;.25; .25; .25; .25; .25;];
%                 testCase.verifyEqual(Main_Actual_oddballProb, Main_Expected_oddballProb);
%                 
%                 Main_Actual_driftConc = DataMain.driftConc;
%                 Main_Expected_driftConc = [30; 30; 30; 30; 30; 30; 30; 30; 30; 30;30; 30; 30; 30; 30;30; 30; 30; 30; 30];
%                 testCase.verifyEqual(Main_Actual_driftConc, Main_Expected_driftConc);
%                 
%                 Main_Actual_block = DataMain.block;
%                 Main_Expected_block = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
%                 testCase.verifyEqual(Main_Actual_block, Main_Expected_block);
%                 
%                 Main_Actual_boatType = DataMain.boatType;
%                 Main_Expected_boatType = [0;1;0;0;0;0;0;1;1;0;1;0;1;1;1;1;0;1;1;0];
%                 testCase.verifyEqual(Main_Actual_boatType, Main_Expected_boatType);
%                 
%                 Main_Actual_actRew = DataMain.actRew;
%                 Main_Expected_actRew = [1;2;1;1;1;1;1;2;2;1;2;1;2;2;2;2;1;2;2;1];
%                 testCase.verifyEqual(Main_Actual_actRew, Main_Expected_actRew);
%                 
%                 Main_Actual_rew = DataMain.rew;
%                 Main_Expected_rew = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
%                 testCase.verifyEqual(Main_Actual_rew, Main_Expected_rew);
%                 
%                 Main_Actual_trigger1 = DataMain.triggers(:,1);
%                 Main_Expected_trigger1 = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1;];
%                 testCase.verifyEqual(Main_Actual_trigger1, Main_Expected_trigger1);
%                 
%                 Main_Actual_trigger2 = DataMain.triggers(:,2);
%                 Main_Expected_trigger2 = [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
%                 testCase.verifyEqual(Main_Actual_trigger2, Main_Expected_trigger2);
%                 
%                 Main_Actual_trigger3 = DataMain.triggers(:,3);
%                 Main_Expected_trigger3 = [3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3;];
%                 testCase.verifyEqual(Main_Actual_trigger3, Main_Expected_trigger3);
%                 
%                 Main_Actual_trigger4 = DataMain.triggers(:,4);
%                 Main_Expected_trigger4 = [4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4;];
%                 testCase.verifyEqual(Main_Actual_trigger4, Main_Expected_trigger4);
%                 
%                 Main_Actual_trigger5 = DataMain.triggers(:,5);
%                 Main_Expected_trigger5 = [5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5; 5;];
%                 testCase.verifyEqual(Main_Actual_trigger5, Main_Expected_trigger5);
%                 
%                 Main_Actual_trigger6 = DataMain.triggers(:,6);
%                 Main_Expected_trigger6 = [6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6; 6;];
%                 testCase.verifyEqual(Main_Actual_trigger6, Main_Expected_trigger6);
%                 
%                 Main_Actual_SummaryTrigger = DataMain.triggers(:,7);
%                 Main_Expected_SummaryTrigger = [255;101;102;107;110;   106;106;104;108;107;    104;102;104;108;105;    104;102;100;100;106];
%                 testCase.verifyEqual(Main_Actual_SummaryTrigger, Main_Expected_SummaryTrigger);
%                 
%                 keyboard
          %  else
                
                [DataMain, DataFollowOutcome, DataFollowCannon] = AdaptiveLearning(true);
                keyboard
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
                
                Main_Actual_perf = DataMain.perf;
                Main_Expected_perf = [0.1;  0;  0;0.1;  0;0.1;0.1;  0;  0;0.1;  0;  0;  0;  0;  0;  0;0;0;0;0.1];
                testCase.verifyEqual(Main_Actual_perf, Main_Expected_perf);
                
                Main_Actual_accPerf = DataMain.accPerf;
                Main_Expected_accPerf = [0.1;0.1;0.1;0.2;0.2;0.3;0.4;0.4;0.4;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.6];
                testCase.verifyEqual(Main_Actual_accPerf, Main_Expected_accPerf, 'AbsTol', 0.0001);
                
                Main_Actual_memErr = DataMain.memErr;
                Main_Expected_memErr = [999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999];
                testCase.verifyEqual(Main_Actual_memErr, Main_Expected_memErr)
                
                Main_Actual_sigma = DataMain.sigma;
                Main_Expected_sigma = [12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12];
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
                Main_Expected_SummaryTrigger = [255;101;102;107;110;   106;106;104;108;107;    104;102;104;108;105;    104;102;100;100;106];
                testCase.verifyEqual(Main_Actual_SummaryTrigger, Main_Expected_SummaryTrigger);
                
                keyboard
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                FollowOutcome_Actual_perf = DataFollowOutcome.perf;
                FollowOutcome_Expected_perf = [  0; 0;  0;0.1;0.1;0.1;0.1;  0;  0;0.1;  0;0.1;  0;  0;   0; 0;  0;  0;  0;  0.1;];
                testCase.verifyEqual(FollowOutcome_Actual_perf, FollowOutcome_Expected_perf);
                
                FollowOutcome_Actual_accPerf = DataFollowOutcome.accPerf;
                FollowOutcome_Expected_accPerf = [  0; 0;  0;0.1;0.2;0.3;0.4;0.4;0.4;  0.5;  0.5;0.6;0.6;0.6; 0.6;0.6;0.6;0.6;0.6;0.7;];
                testCase.verifyEqual(FollowOutcome_Actual_accPerf, FollowOutcome_Expected_accPerf, 'AbsTol', 0.0001);
                
                FollowOutcome_Actual_hit = DataFollowOutcome.hit;
                FollowOutcome_Expected_hit = [  0; 0;  0;  1;  1; 1; 1; 1; 1;   1;  1;  1;  1; 1;   0; 0;  0;  0;  0;  1;];
                testCase.verifyEqual(FollowOutcome_Actual_hit, FollowOutcome_Expected_hit);
                
                FollowOutcome_Actual_UP = round(DataFollowOutcome.UP);
                FollowOutcome_Expected_UP =  [0  ;107;100;175; 24;     82; 2; 3;  9;117;    40;  2; 36; 38; 68;100; 110; 0 ;  0;138];
                testCase.verifyEqual(FollowOutcome_Actual_UP, FollowOutcome_Expected_UP);
                
                FollowOutcome_Actual_memErr = round(DataFollowOutcome.memErr);
                FollowOutcome_Expected_memErr = [999;107;146;  0;  0; 0; 0; 0; 0;   0;  0;  0;  0;  0; 37;81;177;171;156;0];
                testCase.verifyEqual(FollowOutcome_Actual_memErr, FollowOutcome_Expected_memErr)
                
                keyboard
                FollowOutcome_Actual_predErr = round(DataFollowOutcome.predErr);
                FollowOutcome_Expected_predErr = [  0;114;175; 24; 82; 2; 3; 9;117; 40;  2; 36; 38;105; 19;67;171;156;138;30];
                testCase.verifyEqual(FollowOutcome_Actual_predErr, FollowOutcome_Expected_predErr);
                
                FollowOutcome_Actual_pred = DataFollowOutcome.pred;
                FollowOutcome_Expected_pred = [307;200;100;275;299;21;23;20;11;128;168;170;206;168;100;0;250;250;250;112];
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
                FollowOutcome_Expected_sigma = [12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12];
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
                
                FollowOutcome_Actual_SummaryTrigger = DataFollowOutcome.triggers(:,7);
                FollowOutcome_Expected_SummaryTrigger = [255;117;118;123;130;  122;122;120;128;123;    120;122;120;128;117;    116;118;116;116;122];
                testCase.verifyEqual(FollowOutcome_Actual_SummaryTrigger, FollowOutcome_Expected_SummaryTrigger);
                
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
                FollowCannon_Expected_perf = [0.1;  0;  0;0.1;  0;0.1;0.1;  0;  0;0.1;  0;  0;  0;  0;  0;  0;0;0;0;0.1];
                testCase.verifyEqual(FollowCannon_Actual_perf, FollowCannon_Expected_perf);
                
                FollowCannon_Actual_accPerf = DataFollowCannon.accPerf;
                FollowCannon_Expected_accPerf = [0.1;0.1;0.1;0.2;0.2;0.3;0.4;0.4;0.4;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.6];
                testCase.verifyEqual(FollowCannon_Actual_accPerf, FollowCannon_Expected_accPerf, 'AbsTol', 0.0001);
                
                FollowCannon_Actual_memErr = DataFollowCannon.memErr;
                FollowCannon_Expected_memErr = [999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999;999];
                testCase.verifyEqual(FollowCannon_Actual_memErr, FollowCannon_Expected_memErr)
                
                FollowCannon_Actual_sigma = DataFollowCannon.sigma;
                FollowCannon_Expected_sigma = [12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12; 12];
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
                
                FollowCannon_Actual_SummaryTrigger = DataFollowCannon.triggers(:,7);
                FollowCannon_Expected_SummaryTrigger = [255;133;135;139;143;  139;139;137;141;139;    137;135;137;141;137;    137;135;133;133;139];
                testCase.verifyEqual(FollowCannon_Actual_SummaryTrigger, FollowCannon_Expected_SummaryTrigger);
           % end
            
        end
        
        
        
        
    end
end