%%% Plot individual subject behavior %%%

clear all

% Which data do you want to plot?
subject = '0027';

%DataLoad = cell(size(subject),1)
DataLoad = sprintf('BattleShips_%s.mat',  num2str((subject)));

% Cell that containts structs with data.
Data = load(DataLoad);
    
%% Basic plotting.

trial = Data.(sprintf('Data_%s',  num2str(((subject))))).trial
prediction = Data.(sprintf('Data_%s',  num2str(((subject))))).prediction;



outcome = Data.(sprintf('Data_%s',  num2str(((subject))))).outcome;
distMean = Data.(sprintf('Data_%s',  num2str(((subject))))).distMean;

for i = 1:length(trial)
    
    predErrNorm(i) = sqrt((outcome(i) - prediction(i))^2); %
    predErrPlus(i) = sqrt((outcome(i) - prediction(i)+2*pi)^2); %
    predErrMin(i) =  sqrt((outcome(i) - prediction(i)-2*pi)^2); %
    if predErrNorm(i) >= 0 && predErrNorm(i) <= pi
        predErr(i) = predErrNorm(i)
    elseif predErrPlus(i) >= 0 && predErrPlus(i) <= pi
        predErr(i) = predErrPlus(i)
    else
        predErr(i) = predErrMin(i)
    end

end

figure
subplot(3, 1, 1)
hold on
dM = plot(distMean, '--k')
o = plot(outcome, '.g');
b = plot(prediction, '.-b');
leg=legend([o b dM], 'outcome', 'belief', 'mean');
ylabel('Location');
xlabel('Trial');
set(leg, 'box', 'off')

subplot(3, 1, 2)
hold on
plot(predErr, 'r')
ylabel('PredErr')
xlabel('Trial')

subplot(3, 1, 3)
plot(Data.(sprintf('Data_%s',  num2str(((subject))))).accPerf)
ylabel('Performance')
xlabel('Trial')






einheit = 360/(2*pi);


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


