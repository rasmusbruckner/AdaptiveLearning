classdef OutputTestOddball < matlab.unittest.TestCase
    
    % to run the unit test put: run(OutputTest) in command window
    % use: rew = 2
    % trials = 20
    
    % bei followCannon -> catchTrial is nan
    % muss catch trial mitkodiert werden? ja oder?
    %gibt es sonst noch was was ich vergessen habe?
    
   
    
    
    %%%%%%%%%%%%
    
    methods (Test)
        
        function testTaskOutputOddball(testCase)
           
            % triggerliste erstellen
            %keyboard
            
            
           
                [Data] = AdaptiveLearning(true);
                
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
                
                Main_Actual_boatType = Data.DataMain.boatType;
                Main_Expected_boatType = [0;1;0;0;0;0;0;1;1;0;1;0;1;1;1;1;0;1;1;0];
                testCase.verifyEqual(Main_Actual_boatType, Main_Expected_boatType);
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
                % brown triggerschema verwenden...
                Main_Actual_SummaryTrigger = Data.DataMain.triggers(:,7);
                Main_Expected_SummaryTrigger = [255;101;102;107;110;   106;106;104;108;107;    104;102;104;108;105;    104;102;100;100;106];
                testCase.verifyEqual(Main_Actual_SummaryTrigger, Main_Expected_SummaryTrigger);
%             
            
        end
        
        
        
        
    end
end