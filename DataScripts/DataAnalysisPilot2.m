%%% Data %%%

% Use this script to merge all specified data. You get some basic plots
% and additionaly raw data are written to a text file called 'MergedData'.

clear all


plotData = true;
%% Which subjects do you want to load?
subject = {'Pilot1'}; % '0023' '0025' '0027'

% This is a cell containing the names of the data files.
DataLoad = cell(numel(subject),1);
for j = 1:length(subject)
    
    DataLoad{j,1} = sprintf('BattleShips_%s.mat',  num2str(cell2mat((subject(j)))));
end

% Cell that containts structs with all data.
for i = 1:length(DataLoad)
    
    allData{i,1} = load(DataLoad{i});
end



%% Organize Data.

% Empty cells.
temp = [];
trial = [];
CP = [];
distMean = [];
catchTrial = [];
TAC = [];
accPerf = [];
perf = [];
boatType = [];
age = [];
sex = [];
ID = [];
cBal = [];
predErr = [];
predErrNorm = [];
predErrPlus = [];
predErrMin = [];
memErr = [];
memErrNorm = [];
memErrPlus = [];
memErrMin = [];
UP = [];
UPNorm = [];
UPPlus = [];
UPMin = [];
lRMin = [];
pred = [];
outcome = [];
sigma = [];
date= [];
pDiff = [];
hit = [];
cond = [];
%% Merges all data and exports them to a text file.

Data = fopen('AdaptiveLearning/DataDirectory/MergedData.txt','wt');
fprintf(Data, '%7s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %11s\n', 'ID', 'sex', 'age', 'trial', 'CP', 'TAC', 'cTrial', 'boat', 'dMean', 'outc', 'pred', 'pErr', 'pENorm', 'pEPlus', 'pEMin', 'mErr', 'mENorm', 'mEPlus', 'mEMin', 'UP', 'UPNorm', 'UPPlus', 'UPMin', 'lR', 'hit', 'date');

for i = 1:length(subject)
    
    % ID
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).ID;
    ID = [ID; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).ID;
    ID = [ID; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).ID;
    ID = [ID; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).ID;
    ID = [ID; temp];
    
    % Sex
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).sex;
    sex = [sex; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).sex;
    sex = [sex; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).sex;
    sex = [sex; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).sex;
    sex = [sex; temp];
    
    % Age
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).age;
    age = [age; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).age;
    age = [age; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).age;
    age = [age; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).age;
    age = [age; temp];
    
%     % Condtition
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).cond;
%     cond = [cond; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).cond;
%     cond = [cond; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).cond;
%     cond = [cond; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).cond;
%     cond = [cond; temp];
    
    % Trial
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).trial';
    trial = [trial; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).trial';
    trial = [trial; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).trial';
    trial = [trial; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).trial';
    trial = [trial; temp];
    
    % Change-point
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).cp;
    CP = [CP; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).cp;
    CP = [CP; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).cp;
    CP = [CP; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).cp;
    CP = [CP; temp];
    
    % Distribution mean
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).distMean;
    distMean = [distMean; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).distMean;
    distMean = [distMean; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).distMean;
    distMean = [distMean; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).distMean;
    distMean = [distMean; temp];
    
    % Catch trial
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).catchTrial;
    catchTrial = [catchTrial; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).catchTrial;
    catchTrial = [catchTrial; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).catchTrial;
    catchTrial = [catchTrial; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).catchTrial;
    catchTrial = [catchTrial; temp];
    
    % Trials after change-point
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).TAC;
    TAC = [TAC; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).TAC;
    TAC = [TAC; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).TAC;
    TAC = [TAC; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).TAC;
    TAC = [TAC; temp];
    
%     % Accumulated performance
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).accPerf;
%     accPerf = [accPerf; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).accPerf;
%     accPerf = [accPerf; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).accPerf;
%     accPerf = [accPerf; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).accPerf;
%     accPerf = [accPerf; temp];
%     
%     % Performance
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).perf;
%     perf = [perf; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).perf;
%     perf = [perf; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).perf;
%     perf = [perf; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).perf;
%     perf = [perf; temp];
    
    % Boat type
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).boatType;
    boatType = [boatType; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).boatType;
    boatType = [boatType; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).boatType;
    boatType = [boatType; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).boatType;
    boatType = [boatType; temp];
    
    % Prediction
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).pred;
    pred = [pred; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).pred;
    pred = [pred; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).pred;
    pred = [pred; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).pred;
    pred = [pred; temp];
    
%     % Prediction Error
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).predErr;
%     predErr = [predErr; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).predErr;
%     predErr = [predErr; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).predErr;
%     predErr = [predErr; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).predErr;
%     predErr = [predErr; temp];
%     
%     % Prediction Error
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).predErr;
%     predErr = [predErr; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).predErr;
%     predErr = [predErr; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).predErr;
%     predErr = [predErr; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).predErr;
%     predErr = [predErr; temp];
    
%     % Prediction Error Norm
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).predErrNorm;
%     predErrNorm = [predErrNorm; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).predErrNorm;
%     predErrNorm = [predErrNorm; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).predErrNorm;
%     predErrNorm = [predErrNorm; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).predErrNorm;
%     predErrNorm = [predErrNorm; temp];
    
%     % Prediction Error Plus
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).predErrPlus;
%     predErrPlus = [predErrPlus; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).predErrPlus;
%     predErrPlus = [predErrPlus; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).predErrPlus;
%     predErrPlus = [predErrPlus; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).predErrPlus;
%     predErrPlus = [predErrPlus; temp];
%     
%     % Prediction Error Min
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).predErrMin;
%     predErrMin = [predErrMin; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).predErrMin;
%     predErrMin = [predErrMin; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).predErrMin;
%     predErrMin = [predErrMin; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).predErrMin;
%     predErrMin = [predErrMin; temp];
%     
%     % Memory Error
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).memErr;
%     memErr = [memErr; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).memErr;
%     memErr = [memErr; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).memErr;
%     memErr = [memErr; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).memErr;
%     memErr = [memErr; temp];
%     
%     % Memory Error Norm
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).memErrNorm;
%     memErrNorm = [memErrNorm; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).memErrNorm;
%     memErrNorm = [memErrNorm; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).memErrNorm;
%     memErrNorm = [memErrNorm; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).memErrNorm;
%     memErrNorm = [memErrNorm; temp];
%     
%     % Memory Error Plus
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).memErrPlus;
%     memErrPlus = [memErrPlus; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).memErrPlus;
%     memErrPlus = [memErrPlus; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).memErrPlus;
%     memErrPlus = [memErrPlus; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).memErrPlus;
%     memErrPlus = [memErrPlus; temp];
%     
%     % Memory Error Min
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).memErrMin;
%     memErrMin = [memErrMin; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).memErrMin;
%     memErrMin = [memErrMin; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).memErrMin;
%     memErrMin = [memErrMin; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).memErrMin;
%     memErrMin = [memErrMin; temp];
%     
%     % Update
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).UP;
%     UP = [UP; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).UP;
%     UP = [UP; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).UP;
%     UP = [UP; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).UP;
%     UP = [UP; temp];
%     
%     % Update Norm
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).UPNorm;
%     UPNorm = [UPNorm; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).UPNorm;
%     UPNorm = [UPNorm; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).UPNorm;
%     UPNorm = [UPNorm; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).UPNorm;
%     UPNorm = [UPNorm; temp];
%     
%     % Update Plus
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).UPPlus;
%     UPPlus = [UPPlus; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).UPPlus;
%     UPPlus = [UPPlus; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).UPPlus;
%     UPPlus = [UPPlus; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).UPPlus;
%     UPPlus = [UPPlus; temp];
%     
%     % Update Min
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).UPMin;
%     UPMin = [UPMin; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).UPMin;
%     UPMin = [UPMin; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).UPMin;
%     UPMin = [UPMin; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).UPMin;
%     UPMin = [UPMin; temp];
     
     
    % Outcome
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).outcome;
    outcome = [outcome; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).outcome;
    outcome = [outcome; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).outcome;
    outcome = [outcome; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).outcome;
    outcome = [outcome; temp];
     
    % Sigma
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).sigma;
    sigma = [sigma; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).sigma;
    sigma = [sigma; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).sigma;
    sigma = [sigma; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).sigma;
    sigma = [sigma; temp];
     
    % Counterbalance
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).cBal;
    cBal = [cBal; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).cBal;
    cBal = [cBal; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).cBal;
    cBal = [cBal; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).cBal;
    cBal = [cBal; temp];
    
%     % Hit
%     temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).hit;
%     hit = [hit; temp];
%     temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).hit;
%     hit = [hit; temp];
%     temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).hit;
%     hit = [hit; temp];
%     temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).hit;
%     hit = [hit; temp];
    
    % date
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).date;
    date = [date; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).date;
    date = [date; temp];
    temp = allData{i}.(sprintf('DataControlLS_%s',  num2str(cell2mat((subject(i)))))).date;
    date = [date; temp];
    temp = allData{i}.(sprintf('DataControlHS_%s',  num2str(cell2mat((subject(i)))))).date;
    date = [date; temp];
    
    
    
    
end


for i = 1:length(trial)
   [predErr(i), predErrNorm(i), predErrPlus(i), predErrMin(i)] = Diff(outcome(i), pred(i));
    
    % Calculate hits
    if predErr(i) <= 13
        hit(i) = 1;
    end
    
    if i >=200
    [memErr(i), memErrNorm(i), memErrPlus(i), memErrMin(i)] = Diff(pred(i), outcome(i-1));
    else
    
    memErr(i) = 999;
    memErrNorm(i) = 999;
    memErrPlus(i) = 999;
    memErrMin(i) = 999;
    end
    
    if memErr(i) <= 13
        hit(i) =1
    end
    
    

    
    if i >= 2
        % Calculate update.
        [UP(i), UPNorm(i), UPPlus(i), UPMin(i)] = Diff(pred(i), pred(i-1));
    end
end


for i = 1:length(trial)
    if trial(i) >= 2
        lR(i) = UP(i)/predErr(i-1);
    else
        lR(i) = 0;
    end
end



    









% end

%% only valiid for Pilot1
% for i = 1:length(trial)
%
%     fprintf(Data,'%7s %7s %7d %7d %7d %7d %7d %7d %7d %7d %7.f %7.f %7.f %7.f %7.f %7.2f %7.2f %7.2f %12s\n', ID{i}, sex{i}, age(i), trial(i), CP(i), TAC(i), catchTrial(i), boatType(i), distMean(i), outcome(i), pred(i), predErrNorm(i), predErrPlus(i), predErrMin(i), predErr(i), perf(i), accPerf(i), learnR(i), date{i});
% end

%Regular loop.
for i = 1:length(trial)
    
    fprintf(Data,'%7s %7s %7d %7d %7d %7d %7d %7d %7d %7d %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.2f %7.f %12s\n', ID{i}, sex{i}, age(i), trial(i), CP(i), TAC(i), catchTrial(i), boatType(i), distMean(i), outcome(i), pred(i), predErr(i), predErrNorm(i), predErrPlus(i), predErrMin(i), memErr(i), memErrNorm(i), memErrPlus(i), memErrMin(i), UP(i), UPNorm(i), UPPlus(i), UPMin(i), lR(i), hit(i), date{i}); % learnR(i)
end

fclose(Data)

if plotData == true
    
    %% Basic statistics.
    
    %%% Learning rate %%%
    % Cut everything above 1.5
    lR(lR > 1.5) = 1.5;
    
    LR1A = 0;
    LR2A = 0;
    LR3A = 0;
    LR4A = 0;
    LR5A = 0;
    LR6A = 0;
    LR7A = 0;
    LR8A = 0;
    LR9A = 0;
    LR10A = 0;
    
    % Group learning rates depending on TAC.
    
    for i = 1:length(trial)
        
        if TAC(i) == 1
            
            LR1A = LR1A + lR(i);
            
        elseif TAC(i) == 2
            
            LR2A = LR2A + lR(i);
            
        elseif TAC(i) == 3
            
            LR3A = LR3A + lR(i);
            
        elseif TAC(i) == 4
            
            LR4A = LR4A + lR(i);
            
        elseif TAC(i) == 5
            
            LR5A = LR5A + lR(i);
            
        elseif TAC(i) == 6
            
            LR6A = LR6A + lR(i);
            
        elseif TAC(i) == 7
            
            LR7A = LR7A + lR(i);
            
        elseif TAC(i) == 8
            
            LR8A = LR8A + lR(i);
            
        elseif TAC(i) == 9
            
            LR9A = LR9A + lR(i);
            
        elseif TAC(i) == 10
            
            LR10A = LR10A + lR(i);
        end
    end
    
    
    % Calculate mean of learning rates.
    
    LR1A = LR1A / sum(TAC == 1);
    LR2A = LR2A / sum(TAC == 2);
    LR3A = LR3A / sum(TAC == 3);
    LR4A = LR4A / sum(TAC == 4);
    LR5A = LR5A / sum(TAC == 5);
    LR6A = LR6A / sum(TAC == 6);
    LR7A = LR7A / sum(TAC == 7);
    LR8A = LR8A / sum(TAC == 8);
    LR9A = LR9A / sum(TAC == 9);
    LR10A = LR10A / sum(TAC == 10);
    
    % Plot of learning rate as a function of TAC.
    figure
    bar([LR1A LR2A LR3A LR4A LR5A LR6A])
    
    
    %%%%%%%%%%%%
    
    
    PECP = 0;
    PE1A = 0;
    PE2A = 0;
    PE3A = 0;
    PE4A = 0;
    PE5A = 0;
    PE6A = 0;
    PE7A = 0;
    PE8A = 0;
    PE9A = 0;
    PE10A = 0;
    
    % Group PE depending on TAC.
    
    for i = 1:length(trial)
        
        if TAC(i) == 0
            
            PECP = PECP + predErr(i);
            
        elseif TAC(i) == 1
            
            PE1A = PE1A + predErr(i);
            
        elseif TAC(i) == 2
            
            PE2A = PE2A + predErr(i);
            
        elseif TAC(i) == 3
            
            PE3A = PE3A + predErr(i);
            
        elseif TAC(i) == 4
            
            PE4A = PE4A + predErr(i);
            
        elseif TAC(i) == 5
            
            PE5A = PE5A + predErr(i);
            
        elseif TAC(i) == 6
            
            PE6A = PE6A + predErr(i);
            
        elseif TAC(i) == 7
            
            PE7A = PE7A + predErr(i);
            
        elseif TAC(i) == 8
            
            PE8A = PE8A + predErr(i);
            
        elseif TAC(i) == 9
            
            PE9A = PE9A + predErr(i);
            
        elseif TAC(i) == 10
            
            PE10A = PE10A + predErr(i);
        end
    end
    
    
    % Calculate mean of PE.
    
    PECP = PECP / sum(TAC == 0);
    PE1A = PE1A / sum(TAC == 1);
    PE2A = PE2A / sum(TAC == 2);
    PE3A = PE3A / sum(TAC == 3);
    PE4A = PE4A / sum(TAC == 4);
    PE5A = PE5A / sum(TAC == 5);
    PE6A = PE6A / sum(TAC == 6);
    PE7A = PE7A / sum(TAC == 7);
    PE8A = PE8A / sum(TAC == 8);
    PE9A = PE9A / sum(TAC == 9);
    PE10A = PE10A / sum(TAC == 10);
    
    % Plot of learning rate as a function of TAC.
    figure
    bar([PECP PE1A PE2A PE3A PE4A PE5A])
    
    
    %%% Distribution of boat types %%%
    
    figure
    hist(boatType)
    
    
    %% Do subjects adapt their prediction after a catch trial %%%
    
    %prediction error catch trial!!!!!!!!!!!!
    
    PECatchTrial = 0;
    PENoCatchTrial = 0;
    
    
    for i = 1:length(trial)
        
        if catchTrial(i) == 1
            
            PECatchTrial = PECatchTrial + predErr(i);
            
        elseif catchTrial(i) == 0
            
            PENoCatchTrial = PENoCatchTrial + predErr(i);
            
        end
    end
    
    
    PECatchTrial = PECatchTrial / sum(catchTrial == 1);
    
    PENoCatchTrial = PENoCatchTrial / sum(catchTrial == 0);
    
    figure
    bar([PECatchTrial PENoCatchTrial])
    
    for i = 1:length(trial)
        xOutc(i) = 100 * cos(outcome(i));
        yOutc(i) = 100 * sin(outcome(i));
        
        xPredS(i) = 100 * cos(pred(i));
        yPredS(i) = 100 * sin(pred(i));
        
        xHand(i) = 100 * cos(distMean(i));
        yHand(i) = 100 * sin(distMean(i));
    end
    
    figure
    hold on
    plot(xOutc, yOutc, '.g', 'MarkerSize', 30)
    plot(xPredS, yPredS, '.r', 'MarkerSize', 20)
    plot(xHand, yHand, '--rs','MarkerSize', 20, 'MarkerEdgeColor', 'b')
    axis equal
    
end