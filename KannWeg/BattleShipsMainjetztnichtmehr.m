function BattleShipsMain
clear all
KbReleaseWait();


% 
% 
% -make sure that change-points are significant, i.e. recognizable?
% -still missing: EEG triggers
% -should be indepent of screensize to run on all machines!
% 
% -don't repeat yourself 
% -instructions with for loop instead of while loop in order to save space.
% built in just one kbcheck loop and present new screen!
% built in feedback!
% 
% -build in that you have to hit the ship during the practice trials!!! 
% 



Set outcome parameters. 
trials=20;           % Number of trials.
hazardRate=.3;          % Hazard rate, i.e. how many change-points per???? weighted coin-flip.
sigma=.4;           % standard deviation of the generative distribution. Find out the "logical" deviations. Between .3 and 1??
safe=3;  


%% Open window.

% Suppress warnings. 
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);

% Open a new window.
window=Screen('OpenWindow',0,[],[208 66 1232 834],[], [], [], []);
windowRect=[208 66 1232 834];
[ window, windowRect ] = Screen('OpenWindow', 0, [], []);
assignin ('base','windowRect',windowRect);

%% Set task parameters.

% Spot parameters.
spotRadius = 15; % The radius of the spot.15
greenSpotRadius = 30
meanRadius=1;
rotationRadius = 100; % The radius of the rotation.
initialRotationAngle = 3 * pi /2 ; % The initial rotation angle in radians. 270° that is on top of circle.
spotDiameter = spotRadius * 2;
greenSpotDiameter = greenSpotRadius * 2
spotDiameterMean=meanRadius * 2;
spotRect = [0 0 spotDiameter spotDiameter];
greenSpotRect = [0 0 greenSpotDiameter greenSpotDiameter]
BoatRect = [0 0 60 60];
spotRectMean=[0 0 spotDiameterMean spotDiameterMean];
centeredBoatRect = CenterRect(BoatRect, windowRect);
centeredspotRect = CenterRect(spotRect, windowRect);% Center the spot.
greenCenteredSpotRect = CenterRect(greenSpotRect, windowRect)
centeredSpotRectMean=CenterRect(spotRectMean,windowRect);
rotationAngle = initialRotationAngle;

assignin ('base','centeredspotRect',centeredspotRect);
assignin ('base','centeredSpotRectMean',centeredSpotRectMean);

% Set text display options.
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, 24);  

% Set keys.
ListenChar(2); %prevents input from keyboard 
KbName('UnifyKeyNames');
rightKey=KbName('RightArrow');
leftKey=KbName('LeftArrow');
escapeKey=KbName('ESCAPE');
space=KbName('Space');  
shiftKey=KbName('enter');
shiftKey1=KbName('return');% ('return'); %RightShift



assignin ('base','shiftKey',shiftKey);
assignin ('base','shiftKey1',shiftKey1);
%% Draw gray circle and fixation cross.
function drawCircle 
Screen(window,'FrameOval',[153 204 255],[615 345 825 555],[],[10],[]); %565 295 875 605   / 173 216 230 / 510 240 930 660
%Screen('DrawLine', window, [0 0 0], 710, 450, 730 , 450, [3]); %xHand, yHand
%Screen('DrawLine', window, [0 0 0], 720, 440, 720 , 460, [3]);
end


function drawCross 
%Screen(window,'FrameOval',[128 128 128],[510 240 930 660],[],[20],[]);
Screen('DrawLine', window, [0 0 0], 710, 450, 730 , 450, [3]); %710, 450, 730 , 450%xHand, yHand
Screen('DrawLine', window, [0 0 0], 720, 440, 720 , 460, [3]);%720, 440, 720 , 460
end

%% Draw hand.
function drawHand
meanSpot = OffsetRect(centeredSpotRectMean, xHand, yHand); 
Screen('FillOval', window, [0 0 127], meanSpot); 
Screen('DrawLine', window, [0 0 0], 720, 450, meanSpot(1)+1, meanSpot(2)+1, [3]); %xHand, yHand  720, 450, 720 , 250
assignin ('base','meanSpot',meanSpot);
end

%% Blue spot.
function blueSpot
BlueSpot = OffsetRect(centeredspotRect, xBlue, yBlue); 
Screen('FillOval', window, [255 0 0], BlueSpot); 
end

% Green spot.
function greenSpot
GreenSpot = OffsetRect(greenCenteredSpotRect, xGreen, yGreen);
Screen('FillOval', window, [0 255 0], GreenSpot);  
end


%DrawBoat
function DrawGoldBoat    
[ShipGold map alpha]  = imread('ShipGold.png');
ShipGold(:,:,4) = alpha(:,:);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
ShipGoldTxt = Screen('MakeTexture', window, ShipGold);
Boat = OffsetRect(centeredBoatRect, xGreen, yGreen);
Screen('DrawTexture', window, ShipGoldTxt,[], dstRect);  %Boat
end


%DrawBoat
function DrawGrayBoat    
[ShipGold map alpha]  = imread('ShipSilver.png');
ShipGold(:,:,4) = alpha(:,:);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
ShipGoldTxt = Screen('MakeTexture', window, ShipGold);
Boat = OffsetRect(centeredBoatRect, xGreen, yGreen);
Screen('DrawTexture', window, ShipGoldTxt,[], dstRect);  %Boat

end

%% Gold Bag.
function goldBag

goldBagpic = imread('Geld.jpg');%Geld.jpg
goldBagTxt = Screen('MakeTexture', window ,goldBagpic); 
Screen('DrawTexture', window, goldBagTxt, [], dstRect); 

%Screen('DrawTexture', win, tex, [], dstRect)

end

function DrawCrossHairs
   
[Fadenkreuz map alpha]  = imread('Fadenkreuz.png');
Fadenkreuz(:,:,4) = alpha(:,:);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
FadenkreuzTxt = Screen('MakeTexture', window, Fadenkreuz);
Boat = OffsetRect(centeredBoatRect, xBlue, yBlue);
Screen('DrawTexture', window, FadenkreuzTxt,[], Boat);  %Boat
    
end

function Reward10

reward = '+ 10 Cent'    
Screen('TextSize', window, 40);
DrawFormattedText(window, reward, 'center', 'center', [0 255 0]); 
Screen('TextSize', window, 24);
end

function Reward5

reward = '+ 5 Cent'    
Screen('TextSize', window, 40);
DrawFormattedText(window, reward, 'center', 'center', [0 255 0]); 
Screen('TextSize', window, 24);
end

function Neutral

reward = '0 Cent'    
Screen('TextSize', window, 40);
DrawFormattedText(window, reward, 'center', 'center', [255 0 0]); 
Screen('TextSize', window, 24);
end


%% generateOutcomes


outcome=nan(trials, 1);        % this will be an array of outcomes
distMean=nan(trials, 1);       % this will be an array of distribution mean
cp=zeros(trials, 1);           % this will be an array of binary change-point variable
BoatType = zeros(trials, 1);
catchTrial = zeros(trials, 1);
TAC=nan(trials, 1);            % Trials after change-point.
prediction=nan(trials, 1);     % Prediction of participant (position of blue spot after pressing space)
predErr=nan(trials, 1);        % Prediction error
learnR=nan(trials, 1);         % Learning rate
s=safe;                        % how many guaranteed trials before change-point is possible.
performance = zeros(trials, 1);
accPerf = zeros(trials, 1);

for i = 1:trials
    if (rand<hazardRate & s==0) | i ==1;
        mean=rand(1).*2*pi;
        cp(i)=1;
        s=safe;
        TAC(i)=1;
    else
        TAC(i)=TAC(i-1)+1;
        s=max([s-1, 0]);
    end
    while ~isfinite(outcome(i))|outcome(i)>2*pi|outcome(i)<0;
        outcome(i)=normrnd(mean, sigma);
    end
    distMean(i)=mean;
    
    % BoatType
    
    if (rand(1) <= 0.33) %# 75% chance of falling into this case
        BoatType(i) = 1
    else
        BoatType(i) = 2
    end
    
    
    %CatchTrial
    if rand(1) <= 0.1
        catchTrial(i) = 1
    else
        catchTrial(i) = 0
    end
    
end
    
    %%%%%%%%%%
    
   
    %%%%%%%%%%%
   assignin ('base','distMean',distMean);

   assignin ('base','outcome',outcome);

   

%outcome = [1 1 1 1 1 1 1 1 1 1]



for i=1:trials

while 1
xBlue = rotationRadius * cos(rotationAngle);
yBlue = rotationRadius * sin(rotationAngle);    
xHand = rotationRadius * cos(distMean(i));           
yHand = rotationRadius * sin(distMean(i)); 
xGreen = rotationRadius * cos(outcome(i)); 
yGreen = rotationRadius * sin(outcome(i));   

%DrawFormattedText(window,SignalNoise,'center',100);
%DrawFormattedText(window,PressEnter,'center',800);

if catchTrial(i) == 1
    drawHand
else
    
end

drawCircle
drawCross

blueSpot
Screen('Flip', window);

[ keyIsDown, seconds, keyCode ] = KbCheck;

    if keyIsDown
        if keyCode(rightKey)
            if rotationAngle < 2 * pi
                rotationAngle = rotationAngle + 0.02; %0.02
            else
                rotationAngle = 0;
            end
        elseif keyCode(leftKey)
            if rotationAngle > 0
                rotationAngle = rotationAngle - 0.02;
            else
                rotationAngle = 2 * pi;
            end
        elseif keyCode(space)
             prediction(i) = rotationAngle;
            break;
        end
    end
end
predErr(i)=prediction(i) - outcome(i);
predErr(i)=sqrt((predErr(i)^2));

if catchTrial(i) == 1
    drawHand
else
    
end

drawCircle
drawCross
greenSpot
blueSpot
Screen('Flip', window);
WaitSecs(1);

imageRect = [0 0 100 100];
winRect = windowRect;
dstRect = CenterRect(imageRect, winRect);

if BoatType(i) == 1
DrawGoldBoat
else
DrawGrayBoat
end



drawCircle
Screen('Flip', window);
WaitSecs(1);


if predErr(i) < 0.25 && BoatType(i) == 1
Reward10
performance(i) = 0.1;
elseif predErr(i) < 0.45 && BoatType(i) == 1
Reward5    
performance(i) = 0.5;
else   
Neutral
performance (i) = 0
end
drawCircle
Screen('Flip', window);
WaitSecs(1)


 %Calculate prediction error and learning rate
    
    if i >= 2 
    learnR(i)= (prediction(i) - prediction(i-1))/predErr(i-1);
    learnR(i)=sqrt(learnR(i)^2);
    end

    %accumulated performance
if i >= 2
accPerf(i) = accPerf(i-1) + performance(i)
KbReleaseWait();
end
end   
   
%distMean = evalin('base', 'distMean');    
subplot(3, 1, 1)
hold on
dM=plot(distMean, '--k');
o=plot(outcome, '.g');
b=plot(prediction, '.-b');
leg=legend([o b dM], 'outcome', 'belief', 'mean');
ylabel('location');
xlabel('trial');
set(leg, 'box', 'off')

subplot(3, 1, 2)
hold on
plot(predErr, 'r');
legend('Prediction Error');
set(legend, 'box', 'off')
ylabel('PredErr')
xlabel('trial')   

subplot(3,1,3)
plot(accPerf)
ylabel('Performance')
xlabel('trial')  
legend('Accumulated Performance')
set(legend, 'box', 'off')
 

ListenChar(); %allow keyboard input again.
Screen('CloseAll');
end
