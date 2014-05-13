function DataPractice = BattleShipsInstructions(taskParam, sigma, cBal)
% BattleShipsInstructions runs the practice sessions.
%   Depending on cBal you start with low or high noise condition.

KbReleaseWait();

%% Generate outcomes for practice trials.

condition = 'practice';
practiceData = GenerateOutcomes(taskParam, sigma, condition);

%% Instructions section.

% First screen with painting.
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
    if find(keyCode) == taskParam.enter
        break
    end
end
KbReleaseWait();

% Second screen.
Screen('TextSize', taskParam.window, 30);
if isequal(taskParam.computer, 'Humboldt')
    txt='Auf rauer See möchtest du möglichst viele Schiffe einer Schiffsflotte versenken.\n\nAls Hilfsmittel benutzt du einen Radar, der dir einen\n\nHinweis darauf gibt, wo sich ein Schiff aufhält.';
else
    txt='Auf rauer See möchtest du möglichst viele Schiffe einer Schiffsflotte versenken.\n\nAls Hilfsmittel benutzt du einen Radar, der dir einen Hinweis darauf gibt, wo sich\n\nein Schiff aufhält.';
end

txtPressEnter='Weiter mit Enter';
DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
button = taskParam.enter;
taskParam = ControlLoop(taskParam, txt, button);
KbReleaseWait();

% Third screen.
if isequal(taskParam.computer, 'Humboldt')
    txt='Dein Abschussziel gibst du mit dem blauen Punkt an, den du mit der\n\nrechten und linken Pfeiltaste steuerst.\n\nVersuche den Punkt auf den Zeiger zu bewegen und drücke LEERTASTE.';
else
    txt='Dein Abschussziel gibst du mit dem blauen Punkt an, den du mit der rechten und\n\nlinken Pfeiltaste steuerst.\n\nVersuche den Punkt auf den Zeiger zu bewegen und drücke LEERTASTE.';
end

button = taskParam.space;
taskParam = ControlLoop(taskParam, txt, button);
LineAndBack(taskParam.window, taskParam.screensize)
DrawCircle(taskParam.window);
DrawCross(taskParam.window);
Screen('Flip', taskParam.window);
WaitSecs(1);

% Fourth screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txt='Der schwarze Balken zeigt dir dann die Position des Schiffs an.';
    else
        txt='Der schwarze Balken zeigt dir dann die Position des Schiffs an.';
    end
    LineAndBack(taskParam.window, taskParam.screensize)
    DrawCircle(taskParam.window);
    DrawOutcome(taskParam, 238);
    DrawCross(taskParam.window);
    PredictionSpot(taskParam);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
    DrawFormattedText(taskParam.window,txt,taskParam.screensize(3)*0.15,taskParam.screensize(4)*0.1, [0 0 0]);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode) == taskParam.enter
            break
        end
    end
end
KbReleaseWait();

% Fourth screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txt='Daraufhin siehst du welche Ladung das Schiff an Bord hat. Dies wird dir auch angezeigt, wenn du das Schiff nicht getroffen hast.\n\nDieses Schiff hat GOLD geladen. Wenn du es triffst, verdienst\n\ndu 20 CENT.';
    else
        txt='Daraufhin siehst du welche Ladung das Schiff an Bord hat. Dies wird dir auch\n\nangezeigt, wenn du das Schiff nicht getroffen hast.\n\nDieses Schiff hat GOLD geladen. Wenn du es triffst, verdienst du 20 CENT. ';
    end
    
    LineAndBack(taskParam.window, taskParam.screensize)
    DrawFormattedText(taskParam.window,txt,taskParam.screensize(3)*0.15,taskParam.screensize(4)*0.1, [0 0 0]);
    DrawCircle(taskParam.window)
    DrawGoldBoat(taskParam)
    DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==taskParam.enter
        break
    end
end
KbReleaseWait();

% Fifth screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txt='Dieses Schiff hat BRONZE geladen. Wenn du es triffst, verdienst\n\ndu 10 CENT. ';
    else
        txt='Dieses Schiff hat BRONZE geladen. Wenn du es triffst, verdienst du 10 CENT. ';
    end
    
    LineAndBack(taskParam.window, taskParam.screensize)
    DrawFormattedText(taskParam.window,txt,taskParam.screensize(3)*0.15,taskParam.screensize(4)*0.1, [0 0 0]);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
    DrawCircle(taskParam.window)
    DrawBronzeBoat(taskParam)
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode) == taskParam.enter
        break
    end
end
KbReleaseWait();

% Sixth screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txt='Dieses Schiff hat STEINE geladen. Wenn du es triffst, verdienst\n\ndu 0 CENT. ';
    else
        txt='Dieses Schiff hat STEINE geladen. Wenn du es triffst, verdienst du 0 CENT. ';
    end
    
    LineAndBack(taskParam.window, taskParam.screensize)
    DrawFormattedText(taskParam.window,txt,taskParam.screensize(3)*0.15,taskParam.screensize(4)*0.1, [0 0 0]);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
    DrawCircle(taskParam.window)
    DrawSilverBoat(taskParam)
    Screen('Flip', taskParam.window);
    
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode) == taskParam.enter
        break
    end
end
KbReleaseWait();

% Seventh screen.
header = 'Wie der Radar funktioniert';
if isequal(taskParam.computer, 'Humboldt')
    txt = 'Der Radar zeigt dir die Position der Schiffsflotte leider nur ungefähr an.\n\nDurch den Seegang kommt es oft vor, dass die Schiffe nur in der Nähe\n\nder angezeigten Position sind. Manchmal sind sie etwas weiter links und manchmal\n\netwas weiter rechts. Diese Abweichungen von der Radarnadel sind zufällig und du\n\nkannst nicht perfekt vorhersagen, wo sich ein Schiff aufhält.';
else
    txt = 'Der Radar zeigt dir die Position der Schiffsflotte leider nur ungefähr an.\n\nDurch den Seegang kommt es oft vor, dass die Schiffe nur in der Nähe der\n\nangezeigten Position sind. Manchmal sind sie etwas weiter links und manchmal\n\netwas weiter rechts. Diese Abweichungen von der Radarnadel sind zufällig und du\n\nkannst nicht perfekt vorhersagen, wo sich ein Schiff aufhält.';
end
BigScreen(taskParam, txtPressEnter, header, txt);

% Eigths screen.
header = 'Wie du einen Schuss abgibst';
if isequal(taskParam.computer, 'Humboldt')
    txt='Mit LEERTASTE gibst du einen Schuss ab. Richte dich dabei nach\n\nder Radarnadel. Beachte, dass der Radar dir durch den\n\nSeegang nur ungefähr angibt wo die Schiffe sind.';
else
    txt='Mit LEERTASTE gibst du einen Schuss ab. Richte dich dabei nach der\n\nRadarnadel. Beachte, dass dir der Radar durch den Seegang nur\n\nungefähr angibt wo, die Schiffe sind.';
end
BigScreen(taskParam, txtPressEnter, header, txt);

% Ninth screen.
header = 'Worauf du achten solltest';
if isequal(taskParam.computer, 'Humboldt')
    txt = 'Es ist wichtig, dass du während der Aufgabe immer auf das Fixationskreuz\n\nschaust. Wir bitten dich darum, möglichst wenige Augenbewegungen zu machen.\n\nVersuche außerdem wenig zu blinzeln. Wenn du blinzeln musst, dann bitte bevor\n\ndu einen Schuss abgibst.\n\n\nIn der folgenden Übung sollst du probieren, möglichst viele Schiffe\n\nzu treffen.';
else
    txt = 'Es ist wichtig, dass du während der Aufgabe immer auf das Fixationskreuz\n\nschaust. Wir bitten dich darum, möglichst wenige Augenbewegungen zu machen.\n\nVersuche außerdem wenig zu blinzeln. Wenn du blinzeln musst, dann bitte bevor\n\ndu einen Schuss abgibst.\n\n\nIn der folgenden Übung sollst du probieren, möglichst viele Schiffe zu treffen.';
end
BigScreen(taskParam, txtPressEnter, header, txt);


%%% Intro-trials with length == taskParam.intTrials and also counterbalance condition (cBal) %%%
% TODO: write function for control loop.

if cBal == '1'
    
    % Ninth screen.
    while 1
        lowNoise='Leichter Seegang';
        DrawFormattedText(taskParam.window, lowNoise, 'center','center');
        DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode) == taskParam.enter
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
        DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)== taskParam.enter
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
        DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode) == taskParam.enter
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
            DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
            Screen('Flip', taskParam.window);
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if find(keyCode) == taskParam.enter
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


header = 'Ende der ersten Übung';
if isequal(taskParam.computer, 'Humboldt')
    txt='Im nächsten Übungsdurchgang fahren die Schiffe ab und zu weiter.\n\nWann die Flotte weiterfährt kannst du nicht vorhersagen. Wenn dir\n\ndie Radarnadel eine neue Position anzeigt, solltest du dich\n\ndaran anpassen.\n\n\nVersuche bitte wieder auf das Fixationskreuz zu gucken und möglichst wenig\n\nzu blinzeln.';
else
    txt='Im nächsten Übungsdurchgang fahren die Schiffe ab und zu weiter.\n\nWann die Flotte weiterfährt kannst du nicht vorhersagen. Wenn dir die\n\nRadarnadel eine neue Position anzeigt, solltest du dich daran anpassen.\n\n\nVersuche bitte wieder auf das Fixationskreuz zu gucken und möglichst wenig\n\nzu blinzeln.';
end
BigScreen(taskParam, txtPressEnter, header, txt)


if cBal == '1'
    
    % Fourteenths screen.
    while 1
        txtLowNoise='Leichter Seegang';
        DrawFormattedText(taskParam.window,txtLowNoise, 'center','center');
        DrawFormattedText(taskParam.window,txtPressEnter,'center', taskParam.screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)== taskParam.enter
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
        DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode)== taskParam.enter
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
        DrawFormattedText(taskParam.window,txtPressEnter,'center',taskParam.screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, ~, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode) == taskParam.enter
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
        DrawFormattedText(taskParam.window,txtPressEnter,'center', taskParam.screensize(4)*0.9);
        Screen('Flip', taskParam.window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode) == taskParam.enter
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

%% End of intro %% 

header = 'Ende der zweiten Übung';
if isequal(taskParam.computer, 'Humboldt')
    txt = 'In der folgenden Übung ist dein Radar leider kaputt. Die Radarnadel\n\nkannst du jetzt nur noch selten sehen. In den meisten Fällen musst\n\ndu die Schiffsposition selber herausfinden. Trotzdem solltest du\n\nversuchen, möglichst viele Schiffe abzuschießen.';
else
    txt = 'In der folgenden Übung ist dein Radar leider kaputt. Die Radarnadel kannst du\n\njetzt nur noch selten sehen. In den meisten Fällen musst du die Schiffsposition\n\nselber herausfinden. Du solltest versuchen, möglichst viele Schiffe\n\nabzuschießen.';
end
BigScreen(taskParam, txtPressEnter, header, txt)


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
