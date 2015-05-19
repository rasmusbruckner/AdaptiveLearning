classdef OutputTest < matlab.unittest.TestCase
    
    % block?
    % welche trigger?
    
    % timestampOnset
    % timestampPrediction
    % timestampOffset
    % allASS
    % driftConc
    % oddballProb
    % oddball
    % cond
    % trial
    % vola
    % sigma
    % outcome
    % distMean
    % cp
    % catchTrial
    % pred
    % predErr
    % memErr
    % UP
    % hit
    % perf
    % accPerf
    
    methods (Test)
        
        function testTaskOutput(testCase)
            
            %             predMain = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];% ones(trial,1);
            %
            %             predFollowOutcome = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];% ones(trial,1);
            %
            %             predFollowCannon = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];% ones(trial,1);
            
            [DataMain, DataFollowOutcome, DataFollowCannon] = AdaptiveLearning(true);
            
            Main_Actual_perf = DataMain.perf;
            Main_Actual_accPerf = DataMain.accPerf;
            Main_Actual_hit = DataMain.hit;
            Main_Actual_UP = DataMain.UP;
            Main_Actual_memErr = DataMain.memErr;
            Main_Actual_predErr = DataMain.predErr;
            Main_Actual_pred = DataMain.pred;
            Main_Actual_catchTrial = DataMain.catchTrial;
            Main_Actual_cp = DataMain.cp;
            Main_Actual_distMean = DataMain.distMean;
            Main_Actual_outcome = DataMain.outcome;
            Main_Actual_sigma = DataMain.sigma;
            Main_Actual_vola = DataMain.vola;
            Main_Actual_trial = DataMain.trial;
            Main_Actual_cond = DataMain.cond;
            Main_Actual_oddBall = DataMain.oddBall;
            Main_Actual_oddballProb = DataMain.oddballProb;
            Main_Actual_driftCond = DataMain.driftConc;
            Main_Actual_allASS = round(DataMain.allASS);
            Main_Actual_timestampOffset = DataMain.timestampOffset;
            Main_Actual_timestampPrediction = DataMain.timestampPrediction;
            Main_Actual_timestampOnset = DataMain.timestampOnset;
            Main_Actual_block = DataMain.block;
            %             Main_Expected_perf =
            %             Main_Expected_accPerf =
                         Main_Expected_hit = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            %             Main_Expected_UP =
            %             Main_Expected_memErr =
            %             Main_Expected_predErr =
            %             Main_Expected_pred =
            %             Main_Expected_catchTrial =
            %             Main_Expected_cp =
                         Main_Expected_distMean = [292;292;292;292;10;10;10;10;162;162;162;162;162;73;73;73;73;73;73;73];
                         Main_Expected_outcome = [307;314;275;299;21;23;20;11;128;168;170;206;168;63;81;67;61;94;112;82];
                         Main_Expected_sigma = [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10];
                         Main_Expected_vola = [.25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25; .25];
                        % Main_Expected_trial = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            %             Main_Expected_cond =
                         Main_Expected_oddBall = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
            %             Main_Expected_oddballProb =
            %             Main_Expected_driftCond =
                         Main_Expected_allASS = round([11.0911946854474;42.7721549861295;20.6452074040670;30.0590067560821;64.2584937909519;12.5238023413691;40.6585624004766;30.6687068315704;24.0647917958204;30.7574110311965;20.3993435965304;74.7776255380259;24.8318515931322;15.8088280244768;24.0309958861010;17.9429379577234;16.5571588417380;12.1121520806927;30.4298216823390;34.2607565195953]);
            %             Main_Expected_timestampOffset =
            %             Main_Expected_timestampPrediction =
            %             Main_Expected_timestampOnset =
            Main_Expected_block = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
            
            testCase.verifyEqual(Main_Actual_hit, Main_Expected_hit);
            testCase.verifyEqual(Main_Actual_distMean, Main_Expected_distMean);
            testCase.verifyEqual(Main_Actual_outcome, Main_Expected_outcome);
            testCase.verifyEqual(Main_Actual_sigma, Main_Expected_sigma);
            testCase.verifyEqual(Main_Actual_vola, Main_Expected_vola);
            testCase.verifyEqual(Main_Actual_oddBall, Main_Expected_oddBall);
            testCase.verifyEqual(Main_Actual_allASS, Main_Expected_allASS);
            testCase.verifyEqual(Main_Actual_block, Main_Expected_block);
            
            
            
            
            
            
            %             actualSolution = round(DataMain.predErr(1));
            %             expectedSolution = 68;
            %             testCase.verifyEqual(actualSolution, expectedSolution);
            
        end
        
        
        
        
    end
end