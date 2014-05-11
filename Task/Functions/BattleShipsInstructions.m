function DataPractice = BattleShipsInstructions(taskParam, sigma, cBal)

% BattleShipsInstructions runs the practice sessions.

KbReleaseWait();

%% Generate outcomes for practice trials.

condition = 'practice';
practiceData = GenerateOutcomes(taskParam, sigma, condition);

%% Instructions section.

%%%%%%%%%%???????????
screensize = get(0,'MonitorPositions');
%%%%%%%%%%%%%%%%%%%%%


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
        txtScreen2='Auf rauer See möchtest du möglichst viele Schiffe einer Schiffsflotte versenken.\n\nAls Hilfsmittel benutzt du einen Radar, der dir einen\n\nHinweis darauf gibt, wo sich ein Schiff aufhält.';
    else
        txtScreen2='Auf rauer See möchtest du möglichst viele Schiffe einer Schiffsflotte versenken.\n\nAls Hilfsmittel benutzt du einen Radar, der dir einen Hinweis darauf gibt, wo sich\n\nein Schiff aufhält.';
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
        txtScreen3='Dein Abschussziel gibst du mit dem blauen Punkt an, den du mit der\n\nrechten und linken Pfeiltaste steuerst.\n\nVersuche den Punkt auf den Zeiger zu bewegen und drücke LEERTASTE.';
    else
        txtScreen3='Dein Abschussziel gibst du mit dem blauen Punkt an, den du mit der rechten und\n\nlinken Pfeiltaste steuerst.\n\nVersuche den Punkt auf den Zeiger zu bewegen und drücke LEERTASTE.';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - 100, screensize(4)/3] )
    DrawFormattedText(taskParam.window,txtScreen3,200,100);
    
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

Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - 100, screensize(4)/3] )
DrawCircle(taskParam.window);
DrawCross(taskParam.window);
Screen('Flip', taskParam.window);
WaitSecs(1);

Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - 100, screensize(4)/3] )
DrawCircle(taskParam.window);
DrawOutcome(taskParam, 238);
DrawCross(taskParam.window);
PredictionSpot(taskParam);

if isequal(taskParam.computer, 'Humboldt')
    txtScreen3='Der schwarze Balken zeigt dir dann die Position des Schiffs an.';
else
    txtScreen3='Der schwarze Balken zeigt dir dann die Position des Schiffs an.';
end

Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - 100, screensize(4)/3] )
DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
DrawFormattedText(taskParam.window,txtScreen3,200,100);

Screen('Flip', taskParam.window);

while 1
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode) == enter
            break
        end
    end
end

Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - 100, screensize(4)/3] )
DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
DrawCircle(taskParam.window);
DrawCross(taskParam.window);
Screen('Flip', taskParam.window);
WaitSecs(1);

KbReleaseWait();

% Fourth screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen4='Daraufhin siehst du welche Ladung das Schiff an Bord hat. Dies wird dir auch angezeigt, wenn du das Schiff nicht getroffen hast.\n\nDieses Schiff hat GOLD geladen. Wenn du es triffst, verdienst\n\ndu 20 CENT.';
    else
        txtScreen4='Daraufhin siehst du welche Ladung das Schiff an Bord hat. Dies wird dir auch\n\nangezeigt, wenn du das Schiff nicht getroffen hast.\n\nDieses Schiff hat GOLD geladen. Wenn du es triffst, verdienst du 20 CENT. ';
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
        txtScreen7 = 'Wie der Radar funktioniert:\n\n\nDer Radar zeigt dir die Position der Schiffsflotte leider nur ungefähr an.\n\nDurch den Seegang kommt es oft vor, dass die Schiffe nur in der Nähe\n\nder angezeigten Position sind. Manchmal ist sind sie etwas weiter links und manchmal\n\netwas weiter rechts. Diese Abweichungen von der Radarnadel sind zufällig und du\n\nkannst nicht perfekt vorhersagen, wo sich ein Schiff aufhält.';
    else
        txtScreen7 = 'Wie der Radar funktioniert:\n\n\nDer Radar zeigt dir die Position der Schiffsflotte leider nur ungefähr an.\n\nDurch den Seegang kommt es oft vor, dass die Schiffe nur in der Nähe der\n\nangezeigten Position sind. Manchmal ist sind sie etwas weiter links und manchmal\n\netwas weiter rechts. Diese Abweichungen von der Radarnadel sind zufällig und du\n\nkannst nicht perfekt vorhersagen, wo sich ein Schiff aufhält.';
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
        txtScreen8='Mit LEERTASTE feuerst du einen Schuss ab. Richte dich dabei nach\n\nder Radarnadel. Beachte, dass der Radar dir durch den\n\nSeegang nur ungefähr angibt wo die Schiffe sind.\n\n\nIn der folgenden Übung sollst du probieren, möglichst viele Schiffe\n\nzu treffen.';
    else
        txtScreen8='Mit LEERTASTE feuerst du einen Schuss ab. Richte dich dabei nach der\n\nRadarnadel. Beachte, dass dir der Radar durch den Seegang nur\n\nungefähr angibt wo, die Schiffe sind.\n\n\nIn der folgenden Übung sollst du probieren, möglichst viele Schiffe zu treffen.';
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

% Screen 18.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreenEEG = 'Es ist wichtig, dass du während der Aufgabe immer auf das Fixationskreuz\n\nschaust. Wir bitten dich darum, möglichst wenige Augenbewegungen zu machen.\n\nVersuche außerdem wenig zu blinzeln. Wenn du blinzeln musst, dann bitte bevor\n\ndu einen Schuss abgibst.';
    else
        txtScreenEEG = 'Es ist wichtig, dass du während der Aufgabe immer auf das Fixationskreuz\n\nschaust. Wir bitten dich darum, möglichst wenige Augenbewegungen zu machen.\n\nVersuche außerdem wenig zu blinzeln. Wenn du blinzeln musst, dann bitte bevor\n\ndu einen Schuss abgibst.';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)] )
    DrawFormattedText(taskParam.window,txtScreenEEG, 200, 300);
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
    for i = 1:taskParam.intTrials
        
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
    
    for i = 1:taskParam.intTrials
        
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
    
    for i = 1:taskParam.intTrials
        
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
        
        for i = 1:taskParam.intTrials
            
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


KbReleaseWait();


%    Thirteenths screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen13='Du hast die erste Übung abgeschlossen.\n\n\nIm nächsten Übungsdurchgang fahren die Schiffe ab und zu weiter.\n\nWann die Flotte weiterfährt kannst du nicht vorhersagen. Wenn dir\n\ndie Radarnadel eine neue Position anzeigt, solltest du dich\n\ndaran anpassen.';
    else
        txtScreen13='Du hast die erste Übung abgeschlossen.\n\n\nIm nächsten Übungsdurchgang fahren die Schiffe ab und zu weiter.\n\nWann die Flotte weiterfährt kannst du nicht vorhersagen. Wenn dir die\n\nRadarnadel eine neue Position anzeigt, solltest du dich daran anpassen.';
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

%    Thirteenths screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtEEG='Versuche bitte wieder auf das Fixationskreuz zu gucken und möglichst wenig\n\nzu blinzeln.';
    else
        txtEEG='Versuche bitte wieder auf das Fixationskreuz zu gucken und möglichst wenig\n\nzu blinzeln.';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)])
    DrawFormattedText(taskParam.window,txtEEG, 200, 300');
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
    
    for i=1:taskParam.intTrials
        
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
    
    for i=1:taskParam.intTrials
        
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
    
    for i=1:taskParam.intTrials
        
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
    
    for i=1:taskParam.intTrials
        
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
