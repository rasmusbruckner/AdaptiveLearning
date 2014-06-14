%%% ExportData %%%

% Use this script to merge all specified data and to make a CSV file to
% called 'MergedData'.

clear all

%% Which subjects do you want to load?
subject = {'rre'};

% This is a cell containing the names of the data files.
DataLoad = cell(numel(subject),1);
for j = 1:length(subject)
    
    DataLoad{j,1} = sprintf('BattleShips_%s.mat',  num2str(cell2mat((subject(j)))));
end

allData = cell(length(DataLoad));
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
vola = [];
rew = [];
sigma = [];
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
date= [];
pDiff = [];
hit = [];
cond = [];
%% Merges all data and exports them to a text file.

Data = fopen('AdaptiveLearning/DataDirectory/MergedData.txt','wt');
fprintf(Data, '%7s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %11s\n', 'ID', 'sex', 'age', 'cond', 'cBal', 'vola', 'rew', 'sigma', 'trial', 'CP', 'TAC', 'cTrial', 'boat', 'dMean', 'outc', 'pred', 'pErr', 'pENorm', 'pEPlus', 'pEMin', 'mErr', 'mENorm', 'mEPlus', 'mEMin', 'UP', 'UPNorm', 'UPPlus', 'UPMin', 'lR', 'hit', 'perf', 'accP', 'date');

for i = 1:length(subject)
    
    % ID
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).ID;
    ID = [ID; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).ID;
    ID = [ID; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).ID;
    ID = [ID; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).ID;
    ID = [ID; temp];
    
    % Sex
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).sex;
    sex = [sex; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).sex;
    sex = [sex; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).sex;
    sex = [sex; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).sex;
    sex = [sex; temp];
    
    % Age
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).age;
    age = [age; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).age;
    age = [age; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).age;
    age = [age; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).age;
    age = [age; temp];
    
    % Condtition
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).cond;
    cond = [cond; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).cond;
    cond = [cond; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).cond;
    cond = [cond; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).cond;
    cond = [cond; temp];
    
    % Vola
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).vola;
    vola = [vola; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).vola;
    vola = [vola; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).vola;
    vola = [vola; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).vola;
    vola = [vola; temp];
    
    % Reward
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).rew;
    rew = [rew; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).rew;
    rew = [rew; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).rew;
    rew = [rew; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).rew;
    rew = [rew; temp];
    
    % Trial
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).trial';
    trial = [trial; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).trial';
    trial = [trial; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).trial';
    trial = [trial; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).trial';
    trial = [trial; temp];
    
    % Change-point
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).cp;
    CP = [CP; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).cp;
    CP = [CP; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).cp;
    CP = [CP; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).cp;
    CP = [CP; temp];
    
    % Distribution mean
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).distMean;
    distMean = [distMean; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).distMean;
    distMean = [distMean; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).distMean;
    distMean = [distMean; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).distMean;
    distMean = [distMean; temp];
    
    % Catch trial
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).catchTrial;
    catchTrial = [catchTrial; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).catchTrial;
    catchTrial = [catchTrial; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).catchTrial;
    catchTrial = [catchTrial; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).catchTrial;
    catchTrial = [catchTrial; temp];
    
    % Trials after change-point
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).TAC;
    TAC = [TAC; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).TAC;
    TAC = [TAC; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).TAC;
    TAC = [TAC; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).TAC;
    TAC = [TAC; temp];
    
    % Accumulated performance
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).accPerf;
    accPerf = [accPerf; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).accPerf;
    accPerf = [accPerf; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).accPerf;
    accPerf = [accPerf; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).accPerf;
    accPerf = [accPerf; temp];
    
    % Performance
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).perf;
    perf = [perf; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).perf;
    perf = [perf; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).perf;
    perf = [perf; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).perf;
    perf = [perf; temp];
    
    % Boat type
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).boatType;
    boatType = [boatType; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).boatType;
    boatType = [boatType; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).boatType;
    boatType = [boatType; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).boatType;
    boatType = [boatType; temp];
    
    % Prediction
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).pred;
    pred = [pred; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).pred;
    pred = [pred; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).pred;
    pred = [pred; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).pred;
    pred = [pred; temp];
    
    % Prediction Error
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).predErr;
    predErr = [predErr; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).predErr;
    predErr = [predErr; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).predErr;
    predErr = [predErr; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).predErr;
    predErr = [predErr; temp];
    
    % Prediction Error
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).predErr;
    predErr = [predErr; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).predErr;
    predErr = [predErr; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).predErr;
    predErr = [predErr; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).predErr;
    predErr = [predErr; temp];
    
    % Prediction Error Norm
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).predErrNorm;
    predErrNorm = [predErrNorm; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).predErrNorm;
    predErrNorm = [predErrNorm; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).predErrNorm;
    predErrNorm = [predErrNorm; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).predErrNorm;
    predErrNorm = [predErrNorm; temp];
    
    % Prediction Error Plus
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).predErrPlus;
    predErrPlus = [predErrPlus; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).predErrPlus;
    predErrPlus = [predErrPlus; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).predErrPlus;
    predErrPlus = [predErrPlus; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).predErrPlus;
    predErrPlus = [predErrPlus; temp];
    
    % Prediction Error Min
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).predErrMin;
    predErrMin = [predErrMin; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).predErrMin;
    predErrMin = [predErrMin; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).predErrMin;
    predErrMin = [predErrMin; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).predErrMin;
    predErrMin = [predErrMin; temp];
    
    % Memory Error
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).memErr;
    memErr = [memErr; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).memErr;
    memErr = [memErr; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).memErr;
    memErr = [memErr; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).memErr;
    memErr = [memErr; temp];
    
    % Memory Error Norm
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).memErrNorm;
    memErrNorm = [memErrNorm; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).memErrNorm;
    memErrNorm = [memErrNorm; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).memErrNorm;
    memErrNorm = [memErrNorm; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).memErrNorm;
    memErrNorm = [memErrNorm; temp];
    
    % Memory Error Plus
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).memErrPlus;
    memErrPlus = [memErrPlus; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).memErrPlus;
    memErrPlus = [memErrPlus; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).memErrPlus;
    memErrPlus = [memErrPlus; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).memErrPlus;
    memErrPlus = [memErrPlus; temp];
    
    % Memory Error Min
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).memErrMin;
    memErrMin = [memErrMin; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).memErrMin;
    memErrMin = [memErrMin; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).memErrMin;
    memErrMin = [memErrMin; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).memErrMin;
    memErrMin = [memErrMin; temp];
    
    % Update
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).UP;
    UP = [UP; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).UP;
    UP = [UP; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).UP;
    UP = [UP; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).UP;
    UP = [UP; temp];
    
    % Update Norm
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).UPNorm;
    UPNorm = [UPNorm; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).UPNorm;
    UPNorm = [UPNorm; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).UPNorm;
    UPNorm = [UPNorm; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).UPNorm;
    UPNorm = [UPNorm; temp];
    
    % Update Plus
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).UPPlus;
    UPPlus = [UPPlus; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).UPPlus;
    UPPlus = [UPPlus; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).UPPlus;
    UPPlus = [UPPlus; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).UPPlus;
    UPPlus = [UPPlus; temp];
    
    % Update Min
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).UPMin;
    UPMin = [UPMin; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).UPMin;
    UPMin = [UPMin; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).UPMin;
    UPMin = [UPMin; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).UPMin;
    UPMin = [UPMin; temp];
    
    
    % Outcome
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).outcome;
    outcome = [outcome; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).outcome;
    outcome = [outcome; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).outcome;
    outcome = [outcome; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).outcome;
    outcome = [outcome; temp];
    
    % Sigma
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).sigma;
    sigma = [sigma; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).sigma;
    sigma = [sigma; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).sigma;
    sigma = [sigma; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).sigma;
    sigma = [sigma; temp];
    
    % Counterbalance
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).cBal;
    cBal = [cBal; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).cBal;
    cBal = [cBal; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).cBal;
    cBal = [cBal; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).cBal;
    cBal = [cBal; temp];
    
    % Hit
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).hit;
    hit = [hit; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).hit;
    hit = [hit; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).hit;
    hit = [hit; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).hit;
    hit = [hit; temp];
    
    % date
    temp = allData{i}.(sprintf('DataLV_%s',  num2str(cell2mat((subject(i)))))).date;
    date = [date; temp];
    temp = allData{i}.(sprintf('DataHV_%s',  num2str(cell2mat((subject(i)))))).date;
    date = [date; temp];
    temp = allData{i}.(sprintf('DataControlLV_%s',  num2str(cell2mat((subject(i)))))).date;
    date = [date; temp];
    temp = allData{i}.(sprintf('DataControlHV_%s',  num2str(cell2mat((subject(i)))))).date;
    date = [date; temp];
    
end


for i = 1:length(trial)
    if trial(i) >= 2
        lR(i) = UP(i)/predErr(i-1);
    else
        lR(i) = 0;
    end
end

%Regular loop.
for i = 1:length(trial)
    
    fprintf(Data,'%7s %7s %7d %7s %7s %7.1f %7s %7d %7d %7d %7d %7d %7d %7d %7d %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.f %7.2f %7.f %7.2f %7.2f %12s\n', ID{i}, sex{i}, age(i), cond{i}, cBal{i}, vola(i), rew(i), sigma(i), trial(i), CP(i), TAC(i), catchTrial(i), boatType(i), distMean(i), outcome(i), pred(i), predErr(i), predErrNorm(i), predErrPlus(i), predErrMin(i), memErr(i), memErrNorm(i), memErrPlus(i), memErrMin(i), UP(i), UPNorm(i), UPPlus(i), UPMin(i), lR(i), hit(i), perf(i), accPerf(i), date{i}); % learnR(i)
end

fclose(Data);

