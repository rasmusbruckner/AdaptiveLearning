function DataPractice = BattleShipsInstructionsExp(taskParam, Subject)
KbReleaseWait();


%% generateOutcomes

isIntro = 'isIntro'
practiceData = GenerateOutcomes(taskParam, isIntro)

%% Instructions section.

Screen('TextFont', taskParam.window, 'Arial');
Screen('TextSize', taskParam.window, 30);

PressEnter='Weiter mit Enter';

EndeBsp='Ende der Übung';

distMean = 3.5221
outcome = [3.6814;3.7952;3.7124;4.2026;3.5820;3.2110;3.8454;3.8916;2.9962;3.7550;2.9774;3.5070;3.1258;2.8844;3.5593]


KbReleaseWait();
%%%%%%%%
counterPage = 1;

while 1
    
    
%     switch counterPage,
%     
%     
%     case '1',
%     
%     Willkommen='Schiffeversenken';
%     DrawFormattedText(taskParam.window, Willkommen, 'center', 'center');
%     Screen('Flip', taskParam.window);
%    
     [ keyIsDown, seconds, keyCode ] = KbCheck;
   
     if find(keyCode)==40 % don't know why it does not understand return or enter?
        counterPage = counterPage + 1
        KbReleaseWait();
        
    elseif find(keyCode)==42
        counterPage = counterPage - 1
        
        KbReleaseWait();
    end
    
    
    cases(counterPage)
end

KbReleaseWait();

%Third screen.
while 1
    
    Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
    Zeiger='Dein Abschussziel gibst du mit dem roten Punkt an, den du mit der rechten und\n\nlinken Pfeiltaste steuerst. Probier dies einmal aus.';
    DrawFormattedText(taskParam.window,Zeiger,200,100);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    DrawHand(taskParam, distMean)
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    if keyIsDown
        if keyCode(taskParam.rightKey)
            if taskParam.rotAngle < 2 * pi
                taskParam.rotAngle = taskParam.rotAngle + 0.02; %0.02
            else
                taskParam.rotAngle = 0;
            end
        elseif keyCode(taskParam.leftKey)
            if taskParam.rotAngle > 0
                taskParam.rotAngle = taskParam.rotAngle - 0.02;
            else
                taskParam.rotAngle = 2 * pi;
            end
        elseif find(keyCode)==40
            break;
        end
    end
end

KbReleaseWait();

% Fourth screen.
while 1
    Screen('FillRect', taskParam.window, [224,255,255], [100 250 1340 700] )
    LT='Der Radar zeigt dir die Position der Schiffsflotte leider nur ungefähr an. Durch\n\ndas Meeresrauschen kommt es oft vor, dass die Schiffsflotte nur in der Nähe\n\nder angezeigten Position ist. Manchmal sind die Schiffe links und manchmal\n\nrechts davon. Diese Abweichung ist zufällig und du kannst nicht perfekt\n\nvorhersagen wo sich die Schiffe aufhalten.';
    DrawFormattedText(taskParam.window, LT, 200, 300);
    DrawFormattedText(taskParam.window, PressEnter, 'center', 800);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?
        break
    end
end

% Fifth screen.
while 1
    
    Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
    LT1='Orientiere dich jetzt am Radar und gib auf die angezeigte Stelle mit der\n\nLeertaste einen Schuss ab. ';
    DrawFormattedText(taskParam.window,LT1,200,100);
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    DrawHand(taskParam, distMean)
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    if keyIsDown
        if keyCode(taskParam.rightKey)
            if taskParam.rotAngle < 2 * pi
                taskParam.rotAngle = taskParam.rotAngle + 0.02; %0.02
            else
                taskParam.rotAngle = 0;
            end
        elseif keyCode(taskParam.leftKey)
            if taskParam.rotAngle > 0
                taskParam.rotAngle = taskParam.rotAngle - 0.02;
            else
                taskParam.rotAngle = 2 * pi;
            end
        elseif keyCode(taskParam.space)
            break;
        end
    end
end

Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
DrawFormattedText(taskParam.window,LT1,200,100);
DrawCircle(taskParam.window)
DrawCross(taskParam.window)
DrawHand(taskParam, distMean)
PredictionSpot(taskParam)
Screen('Flip', taskParam.window);
WaitSecs(1)

KbReleaseWait();

% Sixth screen.
while 1
    
    uebung='Nach dem Schuss siehst du auf dem Radar, wo sich die Flotte tastächlich\n\naufgehalten hat.';
    Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
    DrawFormattedText(taskParam.window,uebung,200,100);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    DrawHand(taskParam, distMean)
    
    DrawOutcome(taskParam, outcome(1))
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?
        break
    end
end

% Seventh screen
for i = 1:2
    
    while 1
        
        uebung20='Versuche jetzt ein paar Schiffe zu erwischen! Du triffst die meisten Schiffe wenn\n\ndu an die Stelle schießt, die die Nadel anzeigt.';
        Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
        DrawFormattedText(taskParam.window,uebung20, 200 ,100);
        DrawCircle(taskParam.window)
        DrawCross(taskParam.window)
        
        DrawHand(taskParam, distMean)
        PredictionSpot(taskParam)
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        
        if keyIsDown
            if keyCode(taskParam.rightKey)
                if taskParam.rotAngle < 2 * pi
                    taskParam.rotAngle = taskParam.rotAngle + 0.02; %0.02
                else
                    taskParam.rotAngle = 0;
                end
            elseif keyCode(taskParam.leftKey)
                if taskParam.rotAngle > 0
                    taskParam.rotAngle = taskParam.rotAngle - 0.02;
                else
                    taskParam.rotAngle = 2 * pi;
                end
            elseif keyCode(taskParam.space)
                break;
            end
        end
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
    
    DrawFormattedText(taskParam.window,uebung20,200,100);
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    DrawHand(taskParam, distMean)
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
    DrawFormattedText(taskParam.window,uebung20,200,100);
    DrawCircle(taskParam.window)
    DrawOutcome(taskParam, outcome(i+1))
    DrawCross(taskParam.window)
    DrawHand(taskParam, distMean)
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
end

% Eigth screen.
while 1
    
    danach3='Nach dem Schuss wirst du außerdem sehen, ob das Schiff mit Gold, Bronze\n\noder Steinen beladen war.';
    Screen('FillRect', taskParam.window, [224,255,255], [100 250 1340 700] )
    
    DrawFormattedText(taskParam.window, danach3, 200, 300, [0 0 0]);
    
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?
        break
    end
end

KbReleaseWait()

while 1
    
    
    uebung10='Dieses Schiff hat GOLD geladen. Wenn du es triffst, verdienst du 10 CENT. ';
    Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
    DrawFormattedText(taskParam.window,uebung10,200, 100);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    DrawCircle(taskParam.window)
    
    DrawGoldBoat(taskParam)
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    Screen('Flip', taskParam.window);
    %break
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?
        break
    end
end
KbReleaseWait();

while 1
    
    uebung10='Dieses Schiff hat BRONZE geladen. Wenn du es triffst, verdienst du 5 CENT. ';
    Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
    DrawFormattedText(taskParam.window,uebung10,200, 100);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    DrawCircle(taskParam.window)
    
    DrawBronzeBoat(taskParam)
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    Screen('Flip', taskParam.window);
    %break
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?
        break
    end
end
KbReleaseWait();

while 1
    
    uebung10='Dieses Schiff hat STEINE geladen. Wenn du es triffst, verdienst du 0 CENT. ';
    Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
    DrawFormattedText(taskParam.window,uebung10,200, 100);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    DrawCircle(taskParam.window)
    
    DrawSilverBoat(taskParam)
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    Screen('Flip', taskParam.window);
    %break
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?
        break
    end
end
KbReleaseWait();

% Ninths screen.
while 1
    
    uebung2='Als nächstes folgt eine weitere Übung.\n\n\nVersuche möglichst viele Schiffe abzuschießen.';
    DrawFormattedText(taskParam.window, uebung2, 'center', 'center');
    
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?
        break
    end
end

KbReleaseWait()

distMean = 5.6871
outcome = [5.7353;5.4992;5.8554;6.12002;5.7564;5.5456;5.0669;6.0078;5.1794;5.3779;5.9741;5.8475;5.9035;5.8403;5.4474]
boatType = [2;3;2;2;1;1;3;1;3;2;1;2;1;3;2]
for i = 1:2
    
    while 1
        
        DrawCircle(taskParam.window)
        DrawCross(taskParam.window)
        
        DrawHand(taskParam, distMean)
        PredictionSpot(taskParam)
        
        
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        
        if keyIsDown
            if keyCode(taskParam.rightKey)
                if taskParam.rotAngle < 2 * pi
                    taskParam.rotAngle = taskParam.rotAngle + 0.02; %0.02
                else
                    taskParam.rotAngle = 0;
                end
            elseif keyCode(taskParam.leftKey)
                if taskParam.rotAngle > 0
                    taskParam.rotAngle = taskParam.rotAngle - 0.02;
                else
                    taskParam.rotAngle = 2 * pi;
                end
            elseif keyCode(taskParam.space)
                break;
            end
        end
    end
    
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    
    DrawHand(taskParam, distMean)
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    
    WaitSecs(1);
    
    DrawCircle(taskParam.window)
    DrawOutcome(taskParam, outcome(i))
    DrawCross(taskParam.window)
    
    DrawHand(taskParam, distMean)
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    
    WaitSecs(1);
    
    imageRect = [0 0 100 100];
    winRect = taskParam.windowRect;
    dstRect = CenterRect(imageRect, winRect);
    
    if boatType(i) == 1
        DrawGoldBoat(taskParam)
    elseif boatType(i) == 2
        DrawBronzeBoat(taskParam)
    else
        DrawSilverBoat(taskParam)
    end
    
    DrawCircle(taskParam.window)
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    Screen('Flip', taskParam.window);
    WaitSecs(1)
    KbReleaseWait();
end

% Eleventh screen.
while 1
    DrawFormattedText(taskParam.window,EndeBsp,'center','center', [0 0 0]);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    Screen('Flip', taskParam.window);
    
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
    
    Screen('FillRect', taskParam.window, [224,255,255], [100 250 1340 700] )
    
    SignalNoise='Jetzt kommt eine weitere Übung. Diesmal fährt die Schiffsflotte ab und zu weiter.\n\nWann die Schiffe weiterfahren kannst du nicht vorhersagen. Wenn dir die\n\nKompassnadel eine neue Position anzeigt, solltest du dich daran anpassen.';
    DrawFormattedText(taskParam.window,SignalNoise, 200, 300');
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode)==40
            break
        end
    end
end

outcome = [4.1400;4.1838;4.0714;3.2556;0.9115;0.3070;1.4542;1.2557;0.3225;1.8568;1.4340;1.9056;1.2091;3.1185;2.8020;3.0907;2.6963;2.7947;2.7443;2.0287]
distMean = [3.6738;3.6738;3.6738;3.6738;0.9277;0.9277;0.9277;0.9277;0.9277;1.6577;1.6577;1.6577;1.6577;2.7166;2.7166;2.7166;2.7166;2.7166;2.7166;1.9122]
boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3]

for i=1:1  %20%trials
    
    %%%%%
    while 1
        
        DrawCircle(taskParam.window)
        DrawCross(taskParam.window)
        
        DrawHand(taskParam, distMean(i))
        PredictionSpot(taskParam)
        
        
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        
        if keyIsDown
            if keyCode(taskParam.rightKey)
                if taskParam.rotAngle < 2 * pi
                    taskParam.rotAngle = taskParam.rotAngle + 0.02; %0.02
                else
                    taskParam.rotAngle = 0;
                end
            elseif keyCode(taskParam.leftKey)
                if taskParam.rotAngle > 0
                    taskParam.rotAngle = taskParam.rotAngle - 0.02;
                else
                    taskParam.rotAngle = 2 * pi;
                end
            elseif keyCode(taskParam.space)
                break;
            end
        end
    end
    
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    
    DrawHand(taskParam, distMean(i))
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    
    WaitSecs(1);
    
    DrawCircle(taskParam.window)
    DrawOutcome(taskParam, outcome(i))
    DrawCross(taskParam.window)
    
    DrawHand(taskParam, distMean(i))
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    
    WaitSecs(1);
    
    imageRect = [0 0 100 100];
    winRect = taskParam.windowRect;
    dstRect = CenterRect(imageRect, winRect);
    
    if boatType(i) == 1
        DrawGoldBoat(taskParam)
    elseif boatType(i) == 2
        DrawBronzeBoat(taskParam)
    else
        DrawSilverBoat(taskParam)
    end
    
    DrawCircle(taskParam.window)
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    Screen('Flip', taskParam.window);
    WaitSecs(1)
    KbReleaseWait();
    
end

%Fourteenths Screen.
while 1
    DrawFormattedText(taskParam.window,EndeBsp,'center','center', [0 0 0]);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode)==40
            break
        end
    end
end
KbReleaseWait();

while 1
    %Fifteens screen
    Screen('FillRect', taskParam.window, [224,255,255], [100 250 1340 700] )
    
    nachUebung = 'Jetzt kommt die letzte Übung. Falls du noch Fragen hast, ist jetzt der richtige\n\n Zeitpunkt um sie zu stellen!'
    
    DrawFormattedText(taskParam.window,nachUebung, 'center', 300);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode)==40
            break
        end
    end
end
KbReleaseWait();

while 1
    %Fifteens screen
    Screen('FillRect', taskParam.window, [224,255,255], [100 250 1340 700] )
    
    nachUebung1 = 'Leider ist dein Radar kaputt gegangen. Trotzdem musst du versuchen, so\n\nviele Schiffe wie möglich abzuschießen. Die Radarnadel zeigt dir jedoch nicht\n\nmehr an, wo sich die Schiffsflotte aufhält. Viel Erfolg!'
    
    DrawFormattedText(taskParam.window,nachUebung1, 200, 300);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode)==40
            break
        end
    end
end
KbReleaseWait();

%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:taskParam.practTrials
    
    while 1
        
        if practiceData.catchTrial(i) == 1
            DrawHand(taskParam, practiceData.distMean(i))
        else
            
        end
        
        DrawCircle(taskParam.window)
        DrawCross(taskParam.window)
        
        PredictionSpot(taskParam)
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        
        if keyIsDown
            if keyCode(taskParam.rightKey)
                if taskParam.rotAngle < 2 * pi
                    taskParam.rotAngle = taskParam.rotAngle + 0.02; %0.02
                else
                    taskParam.rotAngle = 0;
                end
            elseif keyCode(taskParam.leftKey)
                if taskParam.rotAngle > 0
                    taskParam.rotAngle = taskParam.rotAngle - 0.02;
                else
                    taskParam.rotAngle = 2 * pi;
                end
            elseif keyCode(taskParam.space)
                prediction(i) = taskParam.rotAngle;
                break;
            end
        end
    end
    predErr(i)=prediction(i) - practiceData.outcome(i);
    predErr(i)=sqrt((predErr(i)^2));
    
    if practiceData.catchTrial(i) == 1
        DrawHand(taskParam, practiceData.distMean(i))
    else
        
    end
    
    DrawCircle(taskParam.window)
    PredictionSpot(taskParam)
    DrawCross(taskParam.window)
    Screen('Flip', taskParam.window);
    if practiceData.catchTrial(i) == 1
        DrawHand(taskParam, practiceData.distMean(i))
    else
        
    end
    WaitSecs(1);
    
    DrawCircle(taskParam.window)
    
    
    DrawCircle(taskParam.window)
    DrawOutcome(taskParam, practiceData.outcome(i))
    PredictionSpot(taskParam)
    DrawCross(taskParam.window)
    Screen('Flip', taskParam.window);
    
    WaitSecs(1);
    
    
    DrawCircle(taskParam.window)
    DrawOutcome(taskParam, practiceData.outcome(i))
    PredictionSpot(taskParam)
    
    if practiceData.boatType(i) == 1
        DrawGoldBoat(taskParam)
    elseif practiceData.boatType(i) == 2
        DrawBronzeBoat(taskParam)
    else
        DrawSilverBoat(taskParam)
    end
    
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    Screen('Flip', taskParam.window);
    WaitSecs(1);
    
    
    
    
    
    if i >= 2
        learnR(i)= (prediction(i) - prediction(i-1))/predErr(i-1);
        learnR(i)=sqrt(learnR(i)^2);
    end
    
end
KbReleaseWait();


while 1
    
    Screen('FillRect', taskParam.window, [224,255,255], [100 250 1340 700] )
    
    nachUebung32 = 'Sehr gut. In dieser Übung hättest du ... Euro gewonnen.\n\n\nDie Übungsphase ist jetzt abgeschlossen. Ab jetzt spielst du um echtes Geld!\n\n\nFalls du noch Fragen hast, stellst du sie an den Versuchsleiter.\n\n\nMit Enter geht es los '
    
    DrawFormattedText(taskParam.window,nachUebung32, 200, 300);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode)==40
            break
        end
    end
    
end

end

%% Save data.


% %fOutcome = 'outcome';
% %fDistMean = 'distMean';
% fCp = 'cp';
% fBoatType = 'boatType';
% fCatchTrial = 'catchTrial';
% fTAC = 'TAC';
% fPrediction = 'prediction';
% fPredErr = 'predErr';
% fPerformance = 'performance';
% fAccPerf = 'accPerf';

% 
% DataPractice = struct(fOutcome, practiceData.outcome, fDistMean, practiceData.distMean, fCp, practiceData.cp, ...
%     fBoatType, practiceData.boatType, fCatchTrial, practiceData.catchTrial, fTAC, practiceData.TAC, ...
%     fPrediction, prediction, fPredErr, predErr); %accPerf.

%%%%%%%%%%%%%%%%%%%%%%%%%
% end
