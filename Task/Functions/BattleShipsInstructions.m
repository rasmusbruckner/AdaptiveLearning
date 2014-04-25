function DataPractice = BattleShipsInstructions(taskParam, sigma, cBal)

% BattleShipsInstructions runs the practice sessions.

KbReleaseWait();

%% Generate outcomes for practice trials.

%isIntro = 'isIntro';
condition = 'practice';
practiceData = GenerateOutcomes(taskParam, sigma, condition);

%% Instructions section.

%%%%%%%%%%???????????
screensize = get(0,'MonitorPositions');
%%%%%%%%%%%%%%%%%%%%%

NPractice = 10;

if isequal(taskParam.computer, 'Macbook')
    enter = 40;
    %s = 22;
elseif isequal(taskParam.computer, 'Humboldt')
    enter = 13;
    %s = 83;
end


%First screen with painting.
while 1
    
    Screen('TextFont', taskParam.window, 'Arial');
    Screen('TextSize', taskParam.window, 50);
    Ship = imread('Ship.jpg');
    ShipTxt = Screen('MakeTexture', taskParam.window, Ship);
    Screen('DrawTexture', taskParam.window, ShipTxt,[]);
    txtScreen1='Schiffeversenken';
    DrawFormattedText(taskParam.window, txtScreen1, 'center', 100, [255 255 255]);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode) == enter
        break
    end
end

KbReleaseWait();

%Second screen.
distMean = 238;
Screen('TextSize', taskParam.window, 30);
txtPressEnter='Weiter mit Enter';

while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen2='Auf rauer See möchtest du möglichst viele Schiffe versenken.\n\nAls Hilfsmittel benutzt du einen Radar, der dir einen\n\nHinweis darauf gibt, wo sich ein Schiff aufhält.';
    else
        txtScreen2='Auf rauer See möchtest du möglichst viele Schiffe versenken.\n\nAls Hilfsmittel benutzt du einen Radar, der dir einen Hinweis darauf gibt, wo sich\n\nein Schiff aufhält.';
    end
    
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - screensize(3)/10, screensize(4)/3])
    DrawFormattedText(taskParam.window,txtScreen2,screensize(3)*0.15,screensize(4)*0.1, [0 0 0]);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    DrawHand(taskParam, distMean)
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode) == enter
            break
        end
    end
end

KbReleaseWait();

%Third screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen3='Dein Abschussziel gibst du mit dem roten Punkt an, den du mit der\n\nrechten und linken Pfeiltaste steuerst. Probier dies einmal aus.';
    else
        txtScreen3='Dein Abschussziel gibst du mit dem blauen Punkt an, den du mit der rechten und\n\nlinken Pfeiltaste steuerst. Probier dies einmal aus.';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - 100, screensize(4)/3] )
    DrawFormattedText(taskParam.window,txtScreen3,200,100);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    DrawHand(taskParam, distMean)
    PredictionSpot(taskParam)
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    if keyIsDown
        if keyCode(taskParam.rightKey)
            if taskParam.rotAngle < 360*taskParam.unit
                taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
            else
                taskParam.rotAngle = 0;
            end
        elseif keyCode(taskParam.leftKey)
            if taskParam.rotAngle > 0*taskParam.unit
                taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
            else
                taskParam.rotAngle = 360*taskParam.unit;
            end
        elseif find(keyCode)==enter
            break;
        end
    end
end

KbReleaseWait();

% Fourth screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen4='Ein Schiff kann unterschiedliche Ladungen an Board haben.\n\nDieses Schiff hat GOLD geladen. Wenn du es triffst, verdienst\n\ndu 20 CENT. ';
    else
        txtScreen4='Ein Schiff kann unterschiedliche Ladungen an Bord haben.\n\nDieses Schiff hat GOLD geladen. Wenn du es triffst, verdienst du 20 CENT. ';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - screensize(3)/10, screensize(4)/3])
    DrawFormattedText(taskParam.window,txtScreen4,200, 100);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    DrawCircle(taskParam.window)
    DrawGoldBoat(taskParam)
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==enter% don't know why it does not understand return or enter?
        break
    end
end
KbReleaseWait();

% Fifth screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen5='Dieses Schiff hat BRONZE geladen. Wenn du es triffst, verdienst\n\ndu 10 CENT. ';
    else
        txtScreen5='Dieses Schiff hat BRONZE geladen. Wenn du es triffst, verdienst du 10 CENT. ';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - screensize(3)/10, screensize(4)/3])
    DrawFormattedText(taskParam.window,txtScreen5,200, 100);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    DrawCircle(taskParam.window)
    
    DrawBronzeBoat(taskParam)
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    %break
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==enter% don't know why it does not understand return or enter?
        break
    end
end
KbReleaseWait();

% Sixth screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen6='Dieses Schiff hat STEINE geladen. Wenn du es triffst, verdienst\n\ndu 0 CENT. ';
    else
        txtScreen6='Dieses Schiff hat STEINE geladen. Wenn du es triffst, verdienst du 0 CENT. ';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - screensize(3)/10, screensize(4)/3])
    DrawFormattedText(taskParam.window,txtScreen6,200, 100);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    DrawCircle(taskParam.window)
    DrawSilverBoat(taskParam)
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==enter% don't know why it does not understand return or enter?
        break
    end
end
KbReleaseWait();

% Seventh screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen7 = 'Wie der Radar funktioniert:\n\n\nDer Radar zeigt dir die Position des Schiffs leider nur ungefähr an.\n\nDurch das Meeresrauschen kommt es oft vor, dass das Schiff nur in\n\nder Nähe der angezeigten Position ist. Manchmal ist das Schiff links\n\nund manchmal rechts davon. Diese Abweichung ist zufällig und du\n\nkannst nicht perfekt vorhersagen, wo sich das Schiff aufhält.';
    else
        txtScreen7 = 'Wie der Radar funktioniert:\n\n\nDer Radar zeigt dir durch den schwarzen Balken die ungefähre Position des\n\nSchiffs an. Durch den Seegang kommt es oft vor, dass das Schiff nur in der\n\nNähe der angezeigten Position ist. Manchmal ist das Schiff links und manchmal\n\nrechts davon. Diese Abweichungen von der Radarnadel sind zufällig und du\n\nkannst nicht perfekt vorhersagen, wo sich das Schiff aufhält.';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)])
    DrawFormattedText(taskParam.window, txtScreen7, 200, 300);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==enter% don't know why it does not understand return or enter?
        break
    end
end

KbReleaseWait()

% Eigths screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen8='Mit LEERTASTE feuerst du einen Schuss ab. Richte dich dabei nach\n\nder Radarnadel. Beachte, dass der Radar dir durch das\n\nMeeresrauschen nur ungefähr angibt wo das Schiff ist.\n\n\nIn der folgenden Übung sollst du probieren, möglichst viele Schiffe\n\nzu treffen.';
    else
        txtScreen8='Mit LEERTASTE feuerst du einen Schuss ab. Richte dich dabei nach der\n\nRadarnadel. Beachte, dass dir der Radar durch den Seegang nur\n\nungefähr angibt wo, das Schiff ist.\n\n\nIn der folgenden Übung sollst du probieren, möglichst viele Schiffe zu treffen.';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)])
    DrawFormattedText(taskParam.window, txtScreen8, 200, 300);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==enter% don't know why it does not understand return or enter?
        break
    end
end
KbReleaseWait()



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% First practice

if cBal == '1'
    
    % Ninth screen.
    while 1
        lowNoise='Leichter Seegang';
        DrawFormattedText(taskParam.window, lowNoise, 'center','center');
        DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)== enter
                break
            end
        end
    end
    
    distMean = 338;
    outcome = [324;348;371;303;316;332;310;339;357;316;320;308;308;311;330;299;359;375;368;303];
    boatType = [1;3;1;1;3;3;3;1;2;2;1;3;1;3;3;1;3;2;3;2];
    
    
    % Tenth screen with practice block with low noise.
    for i = 1:NPractice
        
        while 1
            DrawCircle(taskParam.window);
            DrawCross(taskParam.window);
            DrawHand(taskParam, distMean);
            PredictionSpot(taskParam);
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            
            if keyIsDown
                if keyCode(taskParam.rightKey)
                    if taskParam.rotAngle < 360*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
                    else
                        taskParam.rotAngle = 0;
                    end
                elseif keyCode(taskParam.leftKey)
                    if taskParam.rotAngle > 0*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
                    else
                        taskParam.rotAngle = 360*taskParam.unit;
                    end
                elseif keyCode(taskParam.space)
                    break;
                end
            end
        end
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawOutcome(taskParam, outcome(i));
        DrawCross(taskParam.window);
        PredictionSpot(taskParam);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
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
        txtScreen11 = 'Starker Seegang';
        DrawFormattedText(taskParam.window,txtScreen11,'center','center', [0 0 0]);
        DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    
    % Twelvth screen with practice block with high noise.
    distMean = 249;
    outcome = [255;237;195;277;205;222;274;263;324;232;236;184;266;240;184;272;244;268;185;236];
    boatType = [1;3;1;1;3;3;3;1;2;2;1;3;1;3;3;1;3;2;3;2];
    
    for i = 1:NPractice
        
        while 1
            DrawCircle(taskParam.window)
            DrawCross(taskParam.window)
            DrawHand(taskParam, distMean)
            PredictionSpot(taskParam)
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            
            if keyIsDown
                if keyCode(taskParam.rightKey)
                    if taskParam.rotAngle < 360*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
                    else
                        taskParam.rotAngle = 0;
                    end
                elseif keyCode(taskParam.leftKey)
                    if taskParam.rotAngle > 0*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
                    else
                        taskParam.rotAngle = 360*taskParam.unit;
                    end
                elseif keyCode(taskParam.space)
                    break;
                end
            end
        end
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawOutcome(taskParam, outcome(i));
        DrawCross(taskParam.window);
        PredictionSpot(taskParam);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
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
        
        DrawCircle(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
    end
    
elseif cBal == '2'
    % Eleventh screen.
    while 1
        txtScreen11 = 'Starker Seegang';
        DrawFormattedText(taskParam.window,txtScreen11,'center','center', [0 0 0]);
        DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    
    % Twelvth screen with practice block with high noise.
    distMean = 249;
    outcome = [255;237;195;277;205;222;274;263;324;232;236;184;266;240;184;272;244;268;185;236];
    boatType = [1;3;1;1;3;3;3;1;2;2;1;3;1;3;3;1;3;2;3;2];
    
    for i = 1:NPractice
        
        while 1
            DrawCircle(taskParam.window)
            DrawCross(taskParam.window)
            DrawHand(taskParam, distMean)
            PredictionSpot(taskParam)
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            
            if keyIsDown
                if keyCode(taskParam.rightKey)
                    if taskParam.rotAngle < 360*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
                    else
                        taskParam.rotAngle = 0;
                    end
                elseif keyCode(taskParam.leftKey)
                    if taskParam.rotAngle > 0*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
                    else
                        taskParam.rotAngle = 360*taskParam.unit;
                    end
                elseif keyCode(taskParam.space)
                    break;
                end
            end
        end
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawOutcome(taskParam, outcome(i));
        DrawCross(taskParam.window);
        PredictionSpot(taskParam);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
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
        
        DrawCircle(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        while 1
            lowNoise='Leichter Seegang';
            DrawFormattedText(taskParam.window, lowNoise, 'center','center');
            DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if find(keyCode)== enter
                    break
                end
            end
        end
        
        distMean = 338;
        outcome = [324;348;371;303;316;332;310;339;357;316;320;308;308;311;330;299;359;375;368;303];
        boatType = [1;3;1;1;3;3;3;1;2;2;1;3;1;3;3;1;3;2;3;2];
        
        for i = 1:NPractice
            
            while 1
                DrawCircle(taskParam.window);
                DrawCross(taskParam.window);
                DrawHand(taskParam, distMean);
                PredictionSpot(taskParam);
                Screen('Flip', taskParam.window);
                
                [ keyIsDown, seconds, keyCode ] = KbCheck;
                
                if keyIsDown
                    if keyCode(taskParam.rightKey)
                        if taskParam.rotAngle < 360*taskParam.unit
                            taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
                        else
                            taskParam.rotAngle = 0;
                        end
                    elseif keyCode(taskParam.leftKey)
                        if taskParam.rotAngle > 0*taskParam.unit
                            taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
                        else
                            taskParam.rotAngle = 360*taskParam.unit;
                        end
                    elseif keyCode(taskParam.space)
                        break;
                    end
                end
            end
            
            DrawCircle(taskParam.window);
            DrawCross(taskParam.window);
            Screen('Flip', taskParam.window);
            WaitSecs(1);
            
            DrawCircle(taskParam.window);
            DrawOutcome(taskParam, outcome(i));
            DrawCross(taskParam.window);
            PredictionSpot(taskParam);
            Screen('Flip', taskParam.window);
            WaitSecs(1);
            
            DrawCircle(taskParam.window);
            DrawCross(taskParam.window);
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
        
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KbReleaseWait();


%    Thirteenths screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen13='Du hast die erste Übung abgeschlossen.\n\n\nIm nächsten Übungsdurchgang fährt das Schiff ab und zu weiter.\n\nWann ein Schiff weiterfährt kannst du nicht vorhersagen. Wenn dir\n\ndie Kompassnadel eine neue Position anzeigt, solltest du dich\n\ndaran anpassen.';
    else
        txtScreen13='Du hast die erste Übung abgeschlossen.\n\n\nIm nächsten Übungsdurchgang fährt das Schiff ab und zu weiter.\n\nWann ein Schiff weiterfährt kannst du nicht vorhersagen. Wenn dir die\n\nKompassnadel eine neue Position anzeigt, solltest du dich daran anpassen.';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)])
    DrawFormattedText(taskParam.window,txtScreen13, 200, 300');
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode)==enter
            break
        end
    end
end





KbReleaseWait();

if cBal == '1'
    
    % Fourteenths screen.
    while 1
        txtLowNoise='Leichter Seegang';
        DrawFormattedText(taskParam.window,txtLowNoise, 'center','center');
        DrawFormattedText(taskParam.window,txtPressEnter,'center', screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    
    % Fifteenths screen with practice block with low noise.
    outcome = [142;165;88;147;248;250;232;268;237;231;271;315;315;309;327;260;299;250;291;42];
    distMean = [146;146;146;146;242;242;242;242;242;242;242;291;291;291;291;291;291;291;291;20];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:NPractice
        
        while 1
            DrawCircle(taskParam.window);
            DrawCross(taskParam.window);
            DrawHand(taskParam, distMean(i));
            PredictionSpot(taskParam);
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            
            if keyIsDown
                if keyCode(taskParam.rightKey)
                    if taskParam.rotAngle < 360*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
                    else
                        taskParam.rotAngle = 0;
                    end
                elseif keyCode(taskParam.leftKey)
                    if taskParam.rotAngle > 0*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
                    else
                        taskParam.rotAngle = 360*taskParam.unit;
                    end
                elseif keyCode(taskParam.space)
                    break;
                end
            end
        end
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawOutcome(taskParam, outcome(i))
        DrawCross(taskParam.window);
        PredictionSpot(taskParam);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        KbReleaseWait();
        
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
    
    % Sixteenths screen.
    while 1
        txtHighNoise = 'Starker Seegang';
        DrawFormattedText(taskParam.window,txtHighNoise,'center','center', [0 0 0]);
        DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    KbReleaseWait();
    
    % Screen 17 with practice block with high noise.
    outcome = [329;372;317;285;340;344;266;332;264;110;135;180;163;237;189;93;229;247;312;179];
    distMean = [312;312;312;312;312;312;312;312;312;176;176;176;176;176;176;176;224;224;224;224];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:NPractice
        
        while 1
            
            DrawCircle(taskParam.window)
            DrawCross(taskParam.window)
            DrawHand(taskParam, distMean(i))
            PredictionSpot(taskParam)
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            
            if keyIsDown
                if keyCode(taskParam.rightKey)
                    if taskParam.rotAngle < 360*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
                    else
                        taskParam.rotAngle = 0;
                    end
                elseif keyCode(taskParam.leftKey)
                    if taskParam.rotAngle > 0*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
                    else
                        taskParam.rotAngle = 360*taskParam.unit;
                    end
                elseif keyCode(taskParam.space)
                    break;
                end
            end
        end
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawOutcome(taskParam, outcome(i));
        DrawCross(taskParam.window);
        PredictionSpot(taskParam);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1)
        KbReleaseWait();
        
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
        
        DrawCircle(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window)
        DrawCross(taskParam.window)
        Screen('Flip', taskParam.window);
        WaitSecs(1)
    end
    
    KbReleaseWait();
    
    
    % Thirteenths screen.
% while 1
%     
%     if isequal(taskParam.computer, 'Humboldt')
%         txtScreen13='Du hast die erste Übung abgeschlossen.\n\n\nIm nächsten Übungsdurchgang fährt das Schiff ab und zu weiter.\n\nWann ein Schiff weiterfährt kannst du nicht vorhersagen. Wenn dir\n\ndie Kompassnadel eine neue Position anzeigt, solltest du dich\n\ndaran anpassen.';
%     else
%         txtScreen13='Du hast die erste Übung abgeschlossen.\n\n\nIm nächsten Übungsdurchgang fährt das Schiff ab und zu weiter.\n\nWann ein Schiff weiterfährt kannst du nicht vorhersagen. Wenn dir die\n\nKompassnadel eine neue Position anzeigt, solltest du dich daran anpassen.';
%     end
%     
%     Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)])
%     DrawFormattedText(taskParam.window,txtScreen13, 200, 300');
%     DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
%     Screen('Flip', taskParam.window);
%     
%     [ keyIsDown, seconds, keyCode ] = KbCheck;
%     if keyIsDown
%         if find(keyCode)==enter
%             break
%         end
%     end
% end
    
elseif cBal == '2'
    
    
    % Sixteenths screen.
    while 1
        txtHighNoise = 'Starker Seegang';
        DrawFormattedText(taskParam.window,txtHighNoise,'center','center', [0 0 0]);
        DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    KbReleaseWait();
    
    % Screen 17 with practice block with high noise.
    outcome = [329;372;317;285;340;344;266;332;264;110;135;180;163;237;189;93;229;247;312;179];
    distMean = [312;312;312;312;312;312;312;312;312;176;176;176;176;176;176;176;224;224;224;224];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:NPractice
        
        while 1
            
            DrawCircle(taskParam.window)
            DrawCross(taskParam.window)
            DrawHand(taskParam, distMean(i))
            PredictionSpot(taskParam)
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            
            if keyIsDown
                if keyCode(taskParam.rightKey)
                    if taskParam.rotAngle < 360*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
                    else
                        taskParam.rotAngle = 0;
                    end
                elseif keyCode(taskParam.leftKey)
                    if taskParam.rotAngle > 0*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
                    else
                        taskParam.rotAngle = 360*taskParam.unit;
                    end
                elseif keyCode(taskParam.space)
                    break;
                end
            end
        end
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawOutcome(taskParam, outcome(i));
        DrawCross(taskParam.window);
        PredictionSpot(taskParam);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1)
        KbReleaseWait();
        
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
        
        DrawCircle(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window)
        DrawCross(taskParam.window)
        Screen('Flip', taskParam.window);
        WaitSecs(1)
    end
    
    KbReleaseWait();
    
    
    
%     % Thirteenths screen.
% while 1
%     
%     if isequal(taskParam.computer, 'Humboldt')
%         txtScreen13='Du hast die erste Übung abgeschlossen.\n\n\nIm nächsten Übungsdurchgang fährt das Schiff ab und zu weiter.\n\nWann ein Schiff weiterfährt kannst du nicht vorhersagen. Wenn dir\n\ndie Kompassnadel eine neue Position anzeigt, solltest du dich\n\ndaran anpassen.';
%     else
%         txtScreen13='Du hast die erste Übung abgeschlossen.\n\n\nIm nächsten Übungsdurchgang fährt das Schiff ab und zu weiter.\n\nWann ein Schiff weiterfährt kannst du nicht vorhersagen. Wenn dir die\n\nKompassnadel eine neue Position anzeigt, solltest du dich daran anpassen.';
%     end
%     
%     Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)])
%     DrawFormattedText(taskParam.window,txtScreen13, 200, 300');
%     DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
%     Screen('Flip', taskParam.window);
%     
%     [ keyIsDown, seconds, keyCode ] = KbCheck;
%     if keyIsDown
%         if find(keyCode)==enter
%             break
%         end
%     end
% end
    
    % Fourteenths screen.
    while 1
        txtLowNoise='Leichter Seegang';
        DrawFormattedText(taskParam.window,txtLowNoise, 'center','center');
        DrawFormattedText(taskParam.window,txtPressEnter,'center', screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)==enter
                break
            end
        end
    end
    
    % Fifteenths screen with practice block with low noise.
    outcome = [142;165;88;147;248;250;232;268;237;231;271;315;315;309;327;260;299;250;291;42];
    distMean = [146;146;146;146;242;242;242;242;242;242;242;291;291;291;291;291;291;291;291;20];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:NPractice
        
        while 1
            DrawCircle(taskParam.window);
            DrawCross(taskParam.window);
            DrawHand(taskParam, distMean(i));
            PredictionSpot(taskParam);
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            
            if keyIsDown
                if keyCode(taskParam.rightKey)
                    if taskParam.rotAngle < 360*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
                    else
                        taskParam.rotAngle = 0;
                    end
                elseif keyCode(taskParam.leftKey)
                    if taskParam.rotAngle > 0*taskParam.unit
                        taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
                    else
                        taskParam.rotAngle = 360*taskParam.unit;
                    end
                elseif keyCode(taskParam.space)
                    break;
                end
            end
        end
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawOutcome(taskParam, outcome(i))
        DrawCross(taskParam.window);
        PredictionSpot(taskParam);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        
        DrawCircle(taskParam.window);
        DrawCross(taskParam.window);
        Screen('Flip', taskParam.window);
        WaitSecs(1);
        KbReleaseWait();
        
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
    
end


%     % Thirteenths screen.
% while 1
%     
%     if isequal(taskParam.computer, 'Humboldt')
%         txtScreen13='Du hast die erste Übung abgeschlossen.\n\n\nIm nächsten Übungsdurchgang fährt das Schiff ab und zu weiter.\n\nWann ein Schiff weiterfährt kannst du nicht vorhersagen. Wenn dir\n\ndie Kompassnadel eine neue Position anzeigt, solltest du dich\n\ndaran anpassen.';
%     else
%         txtScreen13='Du hast die erste Übung abgeschlossen.\n\n\nIm nächsten Übungsdurchgang fährt das Schiff ab und zu weiter.\n\nWann ein Schiff weiterfährt kannst du nicht vorhersagen. Wenn dir die\n\nKompassnadel eine neue Position anzeigt, solltest du dich daran anpassen.';
%     end
%     
%     Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)])
%     DrawFormattedText(taskParam.window,txtScreen13, 200, 300');
%     DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
%     Screen('Flip', taskParam.window);
%     
%     [ keyIsDown, seconds, keyCode ] = KbCheck;
%     if keyIsDown
%         if find(keyCode)==enter
%             break
%         end
%     end
% end


% Screen 18.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen18 = 'Du hast die zweite Übung abgeschlossen.\n\n\nLetzte Übung: Leider ist dein Radar kaputt gegangen. Die Radarnadel\n\nkannst du jetzt nur noch selten sehen. In den meisten Fällen musst\n\ndu die Schiffsposition selber herausfinden. Trotzdem solltest du\n\nversuchen möglichst viele Schiffe abzuschießen.\n\n\nViel Erfolg!';
    else
        txtScreen18 = 'Du hast die zweite Übung abgeschlossen.\n\n\nLetzte Übung: Leider ist dein Radar kaputt gegangen. Die Radarnadel kannst du\n\njetzt nur noch selten sehen. In den meisten Fällen musst du die Schiffsposition\n\nselber herausfinden. Du solltest versuchen möglichst viele Schiffe\n\nabzuschießen. Viel Erfolg!';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)] )
    DrawFormattedText(taskParam.window,txtScreen18, 200, 300);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode)==enter
            break
        end
    end
end
KbReleaseWait();




%%%%%%%%%%%%%%%%%%%%

%
% % Screen 19.
% while 1
%     DrawFormattedText(taskParam.window,txtLowNoise,'center','center', [0 0 0]);
%     DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
%     Screen('Flip', taskParam.window);
%
%     [ keyIsDown, seconds, keyCode ] = KbCheck;
%     if keyIsDown
%         if find(keyCode)==enter
%             break
%         end
%     end
% end
%
% KbReleaseWait();
%
% % Screen 20 with practice trials with low noise.
% for i=1:taskParam.practTrials
%
%     while 1
%
%         if practiceData.catchTrial(i) == 1
%             DrawHand(taskParam, practiceData.distMean(i))
%         end
%
%         DrawCircle(taskParam.window)
%         DrawCross(taskParam.window)
%         PredictionSpot(taskParam)
%         Screen('Flip', taskParam.window);
%
%         [ keyIsDown, seconds, keyCode ] = KbCheck;
%
%         if keyIsDown
%             if keyCode(taskParam.rightKey)
%                 if taskParam.rotAngle < 360*taskParam.unit
%                     taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
%                 else
%                     taskParam.rotAngle = 0;
%                 end
%             elseif keyCode(taskParam.leftKey)
%                 if taskParam.rotAngle > 0*taskParam.unit
%                     taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
%                 else
%                     taskParam.rotAngle = 360*taskParam.unit;
%                 end
%             elseif keyCode(taskParam.space)
%                 prediction(i) = taskParam.rotAngle;
%                 break;
%             end
%         end
%     end
%
%     predErr(i)=prediction(i) - practiceData.outcome(i);
%     predErr(i)=sqrt((predErr(i)^2));
%
%     DrawCircle(taskParam.window)
%     DrawCross(taskParam.window)
%     Screen('Flip', taskParam.window);
%     if practiceData.catchTrial(i) == 1
%         DrawHand(taskParam, practiceData.distMean(i));
%     end
%     WaitSecs(1);
%
%     DrawCircle(taskParam.window);
%     DrawOutcome(taskParam, practiceData.outcome(i));
%     PredictionSpot(taskParam);
%     DrawCross(taskParam.window);
%     Screen('Flip', taskParam.window);
%     WaitSecs(1);
%
%     DrawCircle(taskParam.window);
%     DrawCross(taskParam.window);
%     Screen('Flip', taskParam.window);
%     WaitSecs(1);
%
%     DrawCircle(taskParam.window);
%
%     if practiceData.boatType(i) == 1
%         DrawGoldBoat(taskParam)
%     elseif practiceData.boatType(i) == 2
%         DrawBronzeBoat(taskParam)
%     else
%         DrawSilverBoat(taskParam)
%     end
%
%     Screen('Flip', taskParam.window);
%     WaitSecs(1);
%
%     DrawCircle(taskParam.window)
%     DrawCross(taskParam.window)
%     Screen('Flip', taskParam.window);
%     WaitSecs(1);
%
%     if i >= 2
%         learnR(i)= (prediction(i) - prediction(i-1))/predErr(i-1);
%         learnR(i)=sqrt(learnR(i)^2);
%     end
%
% end
%
% KbReleaseWait();
%
% % Screen 21.
% while 1
%     DrawFormattedText(taskParam.window,txtHighNoise,'center','center', [0 0 0]);
%     DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
%     Screen('Flip', taskParam.window);
%
%     [ keyIsDown, seconds, keyCode ] = KbCheck;
%     if keyIsDown
%         if find(keyCode)==enter
%             break
%         end
%     end
% end
% KbReleaseWait();
%
% % Screen 22 with practice block with high noise.
% for i=1:taskParam.practTrials
%
%     while 1
%
%         if practiceData.catchTrial(i) == 1
%             DrawHand(taskParam, practiceData.distMean(i))
%         end
%
%         DrawCircle(taskParam.window)
%         DrawCross(taskParam.window)
%         PredictionSpot(taskParam)
%         Screen('Flip', taskParam.window);
%
%         [ keyIsDown, seconds, keyCode ] = KbCheck;
%
%         if keyIsDown
%             if keyCode(taskParam.rightKey)
%                 if taskParam.rotAngle < 360*taskParam.unit
%                     taskParam.rotAngle = taskParam.rotAngle + 1*taskParam.unit; %0.02
%                 else
%                     taskParam.rotAngle = 0;
%                 end
%             elseif keyCode(taskParam.leftKey)
%                 if taskParam.rotAngle > 0*taskParam.unit
%                     taskParam.rotAngle = taskParam.rotAngle - 1*taskParam.unit;
%                 else
%                     taskParam.rotAngle = 360*taskParam.unit;
%                 end
%             elseif keyCode(taskParam.space)
%                 prediction(i) = taskParam.rotAngle;
%                 break;
%             end
%         end
%     end
%     predErr(i)=prediction(i) - practiceData.outcome(i);
%     predErr(i)=sqrt((predErr(i)^2));
%
%     DrawCircle(taskParam.window)
%     DrawCross(taskParam.window)
%     Screen('Flip', taskParam.window);
%     if practiceData.catchTrial(i) == 1
%         DrawHand(taskParam, practiceData.distMean(i))
%     end
%     WaitSecs(1);
%
%     DrawCircle(taskParam.window)
%     DrawOutcome(taskParam, practiceData.outcome(i))
%     PredictionSpot(taskParam)
%     DrawCross(taskParam.window)
%     Screen('Flip', taskParam.window);
%     WaitSecs(1);
%
%     DrawCircle(taskParam.window)
%     DrawCross(taskParam.window)
%     Screen('Flip', taskParam.window);
%     WaitSecs(1);
%
%     DrawCircle(taskParam.window)
%
%     if practiceData.boatType(i) == 1
%         DrawGoldBoat(taskParam)
%     elseif practiceData.boatType(i) == 2
%         DrawBronzeBoat(taskParam)
%     else
%         DrawSilverBoat(taskParam)
%     end
%
%     Screen('Flip', taskParam.window);
%     WaitSecs(1);
%
%     DrawCircle(taskParam.window)
%     DrawCross(taskParam.window)
%     Screen('Flip', taskParam.window);
%     WaitSecs(1);
%
%     if i >= 2
%         learnR(i)= (prediction(i) - prediction(i-1))/predErr(i-1);
%         learnR(i)=sqrt(learnR(i)^2);
%     end
%
% end
% KbReleaseWait();

%%%%%%%%%%%%


% Screen 23.
% while 1
%
%     if isequal(taskParam.computer, 'Humboldt')
%         txtScreen23 = 'Du hast die Übungsphase erfolgreich abgeschlossen.\n\n\nJetzt geht es mit dem Hauptteil weiter. Die Aufgabe ist die gleiche\n\nwie in der letzten Übung. Zur Erinnerung: In den meisten Fällen\n\nmusst du die Schiffsposition selber herausfinden. Nur in wenigen\n\nFällen zeigt dir die Radarnadel wo sich das Schiff ungefähr aufhält,\n\ndies hilft dir das Schiff zu treffen.\n\n\nWenn du ein goldenes Schiff triffst verdienst du 20 CENT.\n\nWenn du ein bronzenes Schiff abschießt verdienst du 10 CENT.\n\nBei einem Schiff mit Steinen an Board verdienst du NICHTS.\n\n\nViel Erfolg!';
%     else
%         txtScreen23 = 'Du hast die Übungsphase erfolgreich abgeschlossen.\n\n\nJetzt geht es mit dem Hauptteil weiter. Die Aufgabe ist die gleiche wie in der\n\nletzten Übung. Zur Erinnerung: In den meisten Fällen musst du die\n\nSchiffsposition selber herausfinden. Nur in wenigen Fällen zeigt dir die\n\nRadarnadel wo sich das Schiff ungefähr aufhält, dies hilft dir das Schiff zu treffen.\n\n\nWenn du ein goldenes Schiff triffst verdienst du 20 CENT.\n\nWenn du ein bronzenes Schiff abschießt verdienst du 10 CENT.\n\nBei einem Schiff mit Steinen an Bord verdienst du NICHTS.\n\n\nViel Erfolg!';
%     end
%
%     txtStartMain = 'Der Versuchsleiter startet jetzt die EEG-Aufzeichnung und die Aufgabe';
%     Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/11, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 5)] ) %(screensize(4) / 4)
%     DrawFormattedText(taskParam.window,txtScreen23, 200, 100);
%     DrawFormattedText(taskParam.window,txtStartMain,'center',screensize(4)*0.9);
%     Screen('Flip', taskParam.window);
%
%     [ keyIsDown, seconds, keyCode ] = KbCheck;
%     if keyIsDown
%         if find(keyCode)==s
%             break
%         end
%     end
% end

%% Save data.

fOutcome = 'outcome';
fDistMean = 'distMean';
fCp = 'cp';
fBoatType = 'boatType';
fCatchTrial = 'catchTrial';
fTAC = 'TAC';
fPrediction = 'prediction';
fPredErr = 'predErr';
fPerformance = 'performance';
fAccPerf = 'accPerf';


DataPractice = struct(fOutcome, practiceData.outcome, fDistMean, practiceData.distMean, fCp, practiceData.cp, ...
    fBoatType, practiceData.boatType, fCatchTrial, practiceData.catchTrial, fTAC, practiceData.TAC);


end
