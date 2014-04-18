function BattleShipsInstructions
clear all
 %KbReleaseWait();
%%% Compass %%%

%{
%-include prediction error line? probably biasing
-make sure that change-points are significant, i.e. recognizable?
-still missing: EEG triggers
-should be indepent of screensize to run on all machines!
-aura!!!
-don't repeat yourself 
-instructions with for loop instead of while loop in order to save space.
built in just one kbcheck loop and present new screen!
built in feedback!
-why does enter not work?
-build in that you have to hit the ship during the practice trials!!! 

- fadenkreuz stockt bei null: vielleicht mit matlab bauen!!
- fadenkreuz lenkt ab!

-aktuelle version: radar gibt mean an aber kann meeresrauschen nicht
abbilden. man übt also mit dem radar und sieht ein kleines schiff als
outcome. rauschen wird direkt am anfang mit eingeführt. 

danach wird geasgt, dass der radar kaputt gegangen ist. und die ungefähre
position eingeschätzt werden muss aber trotzdem beachtet werden muss, dass
das meeresrauschen die aufgabe weiterhin erschwert. 
%}

% Set outcome parameters. 
trials=10;           % Number of trials.
hazardRate=.4;      % Hazard rate, i.e. how many change-points per???? weighted coin-flip.
sigma=.3;           % standard deviation of the generative distribution. Find out the "logical" deviations. Between .3 and 1??
safe=3;  


%% Open window.

% Suppress warnings. 
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);

% Open a new window.
%window=Screen('OpenWindow',0,[],[208 66 1232 834],[], [], [], []);
%windowRect=[208 66 1232 834];
[ window, windowRect ] = Screen('OpenWindow', 0);
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

%enter=(find(keyCode)==40)

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
function DrawBoat    
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

function Reward

reward = '+ 10 Cent'    
Screen('TextSize', window, 40);
DrawFormattedText(window, reward, 'center', 'center', [0 255 0]); 
Screen('TextSize', window, 24);
end



%% generateOutcomes


outcome=nan(trials, 1);        % this will be an array of outcomes
distMean=nan(trials, 1);       % this will be an array of distribution mean
cp=zeros(trials, 1);           % this will be an array of binary change-point variable
TAC=nan(trials, 1);            % Trials after change-point.
prediction=nan(trials, 1);     % Prediction of participant (position of blue spot after pressing space)
predErr=nan(trials, 1);        % Prediction error
learnR=nan(trials, 1);         % Learning rate
s=safe;                        % how many guaranteed trials before change-point is possible.

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
   
    end
    
   assignin ('base','distMean',distMean);

   assignin ('base','outcome',outcome);
%% Instructions section.

PressEnter='Weiter mit Enter';        
Willkommen='Schiffeversenken';
Schatzsuche='Auf rauer See möchtest du möglichst viele Schiffe einer Schiffsflotte versenken. \n\n Als Hilfsmittel benutzt du einen Radar, der dir einen Hinweis darauf gibt, wo sich die Schiffsflotte aufhält.';
Zeiger='Dein Abschussziel gibst du mit dem blauen Punkt an, den du mit der rechten und linken Pfeiltaste steuerst.\n\n Probier dies einmal aus. ';
LT='Der Radar zeigt dir die Position der Schiffsflotte leider nur ungefähr an.\n\nDurch das Meeresrauschen kommt es jedoch oft vor, dass die Schiffsflotte nur in der Nähe der angezeigten Position ist.\n\nManchmal sind die Schiffe links und manchmal rechts davon.\n\nDiese Abweichung ist zufällig und du kannst nicht perfekt vorhersagen wo sich die Schiffe aufhalten.';
LT1='Orientiere dich jetzt am Radar und gib auf die angezeigte Stelle einen Schuss ab. ';


%danach='Sehr gut! Diesmal hast du ein Schiff getroffen.';
danach2='Wie du gesehen hast sind die Schiffe entweder mit Gold oder Steinen beladen.\n\nWenn du ein Schiff mit Gold triffst, wird das Gold in Geld umgerechnet und am Ende an dich ausgezahlt.\n\n Wenn sich Steine an Bord befinden bekommst du dafür leider kein Geld.\n\nBeachte, dass du vorher nicht wissen kannst, ob ein Schiff Gold oder Steine geladen hat.\n\nUm möglichst viel Geld zu verdienen, solltest du daher jedes mal versuchen ein Schiff zu treffen.';
uebung3='Weil dein Radar immer die LETZTE Position der Schiffsflotte anzeigt,\n\nmusst du beim ersten Schuss raten wo sich das Schiff befindet.';
EndeBsp='Ende der Übung';

BlauerPunkt='Mit dem blauen Punkt kannst du angeben, wo du nach dem Schatz suchen möchtest.\n\n Du bewegst deinen Punkt mit den Pfeiltasten nach links und rechts. Probier dies mal aus.';
ObtainOutcome='Wenn du den blauen Punkt zum Zeiger gesteuert hast, drückst du Leertaste um den Schatz einzusammeln.';
SchatzBekommen='Sehr gut! Du hast den Schatz gefunden.\n\n Als nächstes kommt eine kurze Übung. Um möglichst viele Schätze zu sammeln, solltest du also versuchen, den blauen Punkt auf den Schatz zu steuern und dich nicht von der ungenauigkeit des Zeigers ablenken zu lassen\n\nIn der nächsten Übung wirst du die Position des Schatzes erst sehen, wenn du angegeben hast, wo du nach dem Schatz suchst.';
EndeUebung='Ende der Übung.';
ZeigerKaputt='Jetzt, wo du schon erfolgreich einige Schätze gesammelt hast, wird es etwas schwieriger.\n\nDer Schatz wird dir jetzt nicht mehr angezeigt. Trotzdem sollst du versuch soviele Schätze wie möglich zu finden.';

HandDemo=[4.3 3.7 3.8 4.0 4.2 3.6 4.1 4.2 3.7 3.8];
GreenDemo=[4.5 3.8 4 4.7 4.6 3.6 3.7 4.1 4 4.4];
ShipTraining = [4 4 4 4 4 4 4 4 4 4]; 

xBlue = rotationRadius * cos(rotationAngle);
yBlue = rotationRadius * sin(rotationAngle);
%xGreen = rotationRadius * cos(outcome(i)); 
%yGreen = rotationRadius * sin(outcome(i));   
xHand = rotationRadius * cos(4);            %(outcome(i));
yHand = rotationRadius * sin(4);        %(outcome(i));


%First screen.
while 1

    DrawFormattedText(window, Willkommen, 'center', 'center'); 
    Screen('Flip', window);

    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?   
        break
    end
end
    
KbReleaseWait();

%Second screen.

while 1
DrawFormattedText(window,Schatzsuche,'center',100);
DrawFormattedText(window,PressEnter,'center',800);
xHand = rotationRadius * cos(4);           
yHand = rotationRadius * sin(4);   
drawCircle
drawCross
drawHand
Screen('Flip', window);

[ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown    
        if find(keyCode)==40
            break
        end
    end
end

KbReleaseWait();


 

%Third screen.
while 1
    
xHand = rotationRadius * cos(4);           
yHand = rotationRadius * sin(4); 
xGreen = rotationRadius * cos(GreenDemo(i)); 
yGreen = rotationRadius * sin(GreenDemo(i));   
xBlue = rotationRadius * cos(rotationAngle);
yBlue = rotationRadius * sin(rotationAngle);

DrawFormattedText(window,Zeiger,'center',100);
DrawFormattedText(window,PressEnter,'center',800);
drawCircle
drawCross
drawHand
blueSpot
%DrawCrossHairs
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
        elseif find(keyCode)==40
            break;
        end
    end
end

KbReleaseWait();


% Fourth screen.
while 1

    DrawFormattedText(window, LT, 'center', 'center'); 
    DrawFormattedText(window, PressEnter, 'center', 800); 
    Screen('Flip', window);

    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?   
        break
    end
end





% Fifth screen.
while 1
    
xHand = rotationRadius * cos(4);           
yHand = rotationRadius * sin(4); 
xGreen = rotationRadius * cos(GreenDemo(i)); 
yGreen = rotationRadius * sin(GreenDemo(i));   
xBlue = rotationRadius * cos(rotationAngle);
yBlue = rotationRadius * sin(rotationAngle);

DrawFormattedText(window,LT1,'center',100);
drawCircle
drawCross
drawHand
blueSpot
%DrawCrossHairs
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
            break;
        end
    end
end

KbReleaseWait();


% Sixth screen
while 1
uebung='Nach dem Schuss siehst du an dem grünen Punkt, wo sich die Flotte tastächlich aufgehalten hat.';

DrawFormattedText(window,uebung,'center',100);
DrawFormattedText(window,PressEnter,'center',800);
drawCircle
drawCross
drawHand
%DrawBoat
blueSpot
%DrawCrossHairs
greenSpot

Screen('Flip', window);

[ keyIsDown, seconds, keyCode ] = KbCheck;
if find(keyCode)==40 % don't know why it does not understand return or enter?   
  break
end
end

% Seventh screen.
while 1

imageRect = [0 0 100 100];
winRect = windowRect;
dstRect = CenterRect(imageRect, winRect);    
uebung10='Daraufhin siehst du, ob du das Schiff versenkt hast und ob das Schiff Gold oder Steine geladen hatte...';

DrawFormattedText(window,uebung10,'center',100);
DrawFormattedText(window,PressEnter,'center',800);
drawCircle

DrawBoat
%goldBag
%drawCross
%drawHand
%blueSpot
%greenSpot
DrawFormattedText(window,PressEnter,'center',800);
Screen('Flip', window);

%break
[ keyIsDown, seconds, keyCode ] = KbCheck;
if find(keyCode)==40 % don't know why it does not understand return or enter?   
  break
end
end
KbReleaseWait();
while 1

gewinn = '... sowie, wieviel du gewonnen hast'   
%reward = '+ 10 Cent'
Reward
drawCircle
%Screen('TextSize', window, 34);  
DrawFormattedText(window, gewinn, 'center', 100, [0 0 0]); 

Screen('Flip', window);

[ keyIsDown, seconds, keyCode ] = KbCheck;
if find(keyCode)==40 % don't know why it does not understand return or enter?   
  break
end
end

  
 KbReleaseWait();


while 1

    DrawFormattedText(window, danach2, 'center', 'center', [0 0 0]); 
    
    DrawFormattedText(window,PressEnter,'center',800);
    Screen('Flip', window);

    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?   
        break
    end
end
    
KbReleaseWait()

% Ninths screen.
while 1
    
    uebung2='Die Schiffsflotte hält sich meistens an einer Stelle im Meer auf.\n\nDurch das Meeresrauschen schwanken die Schiffe allerdings ein bisschen um die auf dem Radar angezeigten Stelle.\n\nDiese Schwankungen sind zufällig und du kannst sie nicht vorhersagen.\n\n Um möglichst viele Schiffe abzuschießen solltest du auf die Stelle zielen, die der Radar dir angibt.\n\n\nAls nächstes folgt eine kurze Übung.';
    DrawFormattedText(window, uebung2, 'center', 'center'); 
    
    DrawFormattedText(window,PressEnter,'center',800);
    Screen('Flip', window);

    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?   
        break
    end
end
    
KbReleaseWait()



 




for i=1:10%trials

while 1
    
  
xHand = rotationRadius * cos(ShipTraining(i));           
yHand = rotationRadius * sin(ShipTraining(i)); 
xGreen = rotationRadius * cos(GreenDemo(i)); 
yGreen = rotationRadius * sin(GreenDemo(i));   
xBlue = rotationRadius * cos(rotationAngle);
yBlue = rotationRadius * sin(rotationAngle);


drawCircle
drawCross

drawHand
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
            break;
        end
    end
end


drawCircle
greenSpot
drawCross

drawHand
blueSpot
Screen('Flip', window);

WaitSecs(1);

imageRect = [0 0 100 100];
winRect = windowRect;
dstRect = CenterRect(imageRect, winRect);

DrawBoat
drawCircle
Screen('Flip', window);
WaitSecs(1);

Reward
drawCircle
Screen('Flip', window);
WaitSecs(1)
KbReleaseWait();
end
  
% Eleventh screen.
while 1
DrawFormattedText(window,EndeBsp,'center','center', [0 0 0]);
DrawFormattedText(window,PressEnter,'center',800);
Screen('Flip', window);

[ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown    
        if find(keyCode)==40
            break
        end
    end
end

% Twelvths screen.
while 1
    
    
DrawFormattedText(window,EndeBsp,'center','center');
DrawFormattedText(window,PressEnter,'center',800);
Screen('Flip', window);

[ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown    
        if find(keyCode)==40
            break
        end
    end
end

KbReleaseWait();
  


% Thirteenths screen.   

while 1
    
SignalNoise='Wie du sehen konntest schießt du die meisten Schiffe ab, indem du auf die Stelle schießt, die der Kompass dir angibt.\n\n Es ist unmöglich jedes Mal zu treffen, aber so triffst du immerhin meistens.\n\nJetzt kommt eine weitere Übung. Diesmal fährt die Schiffsflotte ab und zu weiter.\n\nWann die Schiffe weiterfahren kannst du nicht vorhersagen.\n\nWenn dir die Kompassnadel eine neue Position anzeigt, solltest du dich daran anpassen.';    
DrawFormattedText(window,SignalNoise,'center','center');
DrawFormattedText(window,PressEnter,'center',800);
Screen('Flip', window);

[ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown    
        if find(keyCode)==40
            break
        end
    end
end




HandDemo=[4 4 4 4 6 6 6 1 1 1];%Make those random!!
GreenDemo=[4.2 3.8 4.3 4.5 5.8 6.3 6.1 1.4 1.1 1];

for i=1:10%trials

while 1
xBlue = rotationRadius * cos(rotationAngle);
yBlue = rotationRadius * sin(rotationAngle);    
xHand = rotationRadius * cos(HandDemo(i));           
yHand = rotationRadius * sin(HandDemo(i)); 
xGreen = rotationRadius * cos(GreenDemo(i)); 
yGreen = rotationRadius * sin(GreenDemo(i));   

%DrawFormattedText(window,SignalNoise,'center',100);
%DrawFormattedText(window,PressEnter,'center',800);
drawCircle
drawCross
drawHand
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
            break;
        end
    end
end

drawCircle

drawCross

drawHand
greenSpot
blueSpot
Screen('Flip', window);

WaitSecs(1);

imageRect = [0 0 100 100];
winRect = windowRect;
dstRect = CenterRect(imageRect, winRect);

DrawBoat
drawCircle
Screen('Flip', window);
WaitSecs(1);

Reward
drawCircle
Screen('Flip', window);
WaitSecs(1)

KbReleaseWait();
end
  
%Fourteenths Screen.

while 1
DrawFormattedText(window,EndeBsp,'center','center', [0 0 0]);
DrawFormattedText(window,PressEnter,'center',800);
Screen('Flip', window);

[ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown    
        if find(keyCode)==40
            break
        end
    end
end

%Fifteens screen
nachUebung = 'Sehr gut! Du hast den Übungsteil jetzt abgeschlossen.\n\nAb jetzt spielst du um echtes Geld. Denke daran, dass du für jedes abgeschossene Schiff mit Goldladung 10 Cent erhälst.  ' 

DrawFormattedText(window,nachUebung,'center','center');
Screen('Flip', window);
WaitSecs(2);


KbReleaseWait();






ListenChar(); %allow keyboard input again.
Screen('CloseAll');
end
