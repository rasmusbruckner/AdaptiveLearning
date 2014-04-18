%%% Data %%%

% Use this script to merge all specified data. You get some basic plots
% and additionaly raw data are written to a text file called 'MergedData'.

clear all

%% Which subjects do you want to load?
subject = {'0037'}; % '0023' '0025' '0027'

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
performance = [];
boatType = [];
age = [];
sex = [];
ID = [];
cBal = [];
predErr = [];
learnR = [];
prediction = [];
outcome = [];
sigma = [];
date= [];

%% Merges all data and exports them to a text file.

Data = fopen('AdaptiveLearning/DataDirectory/MergedData.txt','wt');
fprintf(Data, '%7s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %6s\t %10s\n','ID', 'sex', 'age', 'cBal', 'sigma', 'trial', 'CP', 'TAC', 'cTrial', 'boat', 'dMean', 'outc', 'pred', 'pErr', 'perf', 'accP', 'learnR', 'date');

for i = 1:length(subject)
    
    
    % Low sigma
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).ID;
    ID = [ID; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).sex;
    sex = [sex; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).age;
    age = [age; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).trial;
    trial = [trial; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).cp;
    CP = [CP; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).distMean;
    distMean = [distMean; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).catchTrial;
    catchTrial = [catchTrial; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).TAC;
    TAC = [TAC; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).accPerf;
    accPerf = [accPerf; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).performance;
    performance = [performance; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).boatType;
    boatType = [boatType; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).prediction';
    prediction = [prediction; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).outcome;
    outcome = [outcome; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).sigma;
    sigma = [sigma; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).cBal;
    cBal = [cBal; temp];
    temp = allData{i}.(sprintf('DataLS_%s',  num2str(cell2mat((subject(i)))))).date;
    date = [date; temp];
    
    % High sigma 
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).ID;
    ID = [ID; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).sex;
    sex = [sex; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).age;
    age = [age; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).trial;
    trial = [trial; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).cp;
    CP = [CP; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).distMean;
    distMean = [distMean; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).catchTrial;
    catchTrial = [catchTrial; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).TAC;
    TAC = [TAC; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).accPerf;
    accPerf = [accPerf; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).performance;
    performance = [performance; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).boatType;
    boatType = [boatType; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).prediction';
    prediction = [prediction; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).outcome;
    outcome = [outcome; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).sigma;
    sigma = [sigma; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).cBal;
    cBal = [cBal; temp];
    temp = allData{i}.(sprintf('DataHS_%s',  num2str(cell2mat((subject(i)))))).date;
    date = [date; temp];
end

for i = 1:length(trial)
    
    
    
    
    
    predErrNorm(i) = sqrt((outcome(i) - prediction(i))^2); %
    predErrPlus(i) = sqrt((outcome(i) - prediction(i)+2*pi)^2); %
    predErrMin(i) =  sqrt((outcome(i) - prediction(i)-2*pi)^2); %
    if predErrNorm(i) >= 0 && predErrNorm(i) <= pi
        predErr(i) = predErrNorm(i);
    elseif predErrPlus(i) >= 0 && predErrPlus(i) <= pi
        predErr(i) = predErrPlus(i);
    else
        predErr(i) = predErrMin(i);
    end
    
end


for i = 2:length(trial)
    learnRNorm(i) = sqrt(((prediction(i) - prediction(i-1))/predErr(i-1))^2);
    learnRPlus(i) = sqrt((prediction(i) - prediction(i-1)+2*pi)^2)/predErr(i-1);
    learnRMin(i) = sqrt((prediction(i) - prediction(i-1)-2*pi)^2)/predErr(i-1);
    
    if learnRNorm(i) >= 0 && learnRNorm(i) <= pi
        learnR(i) = learnRNorm(i);
    elseif learnRPlus(i) >= 0 && learnRPlus(i) <= pi
        learnR(i) = learnRPlus(i);
    else
        learnR(i) = learnRMin(i);
    end
    
end
%     % Calculate learning rate.
%     if i >= 2
%         learnR(i) = (prediction(i) - prediction(i-1))/predErr(i-1);
%         learnR(i) = sqrt(learnR(i)^2);
%     end


for i = 1:length(trial)
    
    fprintf(Data,'%7s %7s %7d %7s %7.1f %7d %7d %7d %7d %7d %7.4f %7.4f %7.4f %7.4f %7.2f %7.2f %7.4f %7s\n', ID{i}, sex{i}, age(i), cBal(i), sigma(i), trial(i), CP(i), TAC(i), catchTrial(i), boatType(i), distMean(i), outcome(i), prediction(i), predErr(i), performance(i), accPerf(i), learnR(i), date{i}); %randStimList{i,2}
end

fclose(Data)


%% Basic statistics.

%%% Learning rate %%%
learnR(learnR > 1.5) = [1.5];

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
        
        LR1A = LR1A + learnR(i);
        
    elseif TAC(i) == 2
        
        LR2A = LR2A + learnR(i);
        
    elseif TAC(i) == 3
        
        LR3A = LR3A + learnR(i);
        
    elseif TAC(i) == 4
        
        LR4A = LR4A + learnR(i);
        
    elseif TAC(i) == 5
        
        LR5A = LR5A + learnR(i);
        
    elseif TAC(i) == 6
        
        LR6A = LR6A + learnR(i);
        
    elseif TAC(i) == 7
        
        LR7A = LR7A + learnR(i);
        
    elseif TAC(i) == 8
        
        LR8A = LR8A + learnR(i);
        
    elseif TAC(i) == 9
        
        LR9A = LR9A + learnR(i);
        
    elseif TAC(i) == 10
        
        LR10A = LR10A + learnR(i);
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
bar([LR1A LR2A LR3A LR4A LR5A LR6A LR7A LR8A LR9A])


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
bar([PECP PE1A PE2A PE3A PE4A PE5A PE6A PE7A PE8A])


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
    
    xPredS(i) = 100 * cos(prediction(i));
    yPredS(i) = 100 * sin(prediction(i));
    
    xHand(i) = 100 * cos(distMean(i));
    yHand(i) = 100 * sin(distMean(i));
end

figure
hold on
plot(xOutc, yOutc, '.g', 'MarkerSize', 30)
plot(xPredS, yPredS, '.r', 'MarkerSize', 20)
plot(xHand, yHand, '--rs','MarkerSize', 20, 'MarkerEdgeColor', 'b')
axis equal