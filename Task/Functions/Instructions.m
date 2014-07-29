function Instructions(taskParam, practData, subject)
% BattleShipsInstructions runs the practice sessions.
%   Depending on cBal you start with low or high volatility.

KbReleaseWait();
cannon = true;


txtPressEnter='Zurück mit Löschen - Weiter mit Enter';

%% Instructions section.

% Endless loop for "go-back".
screenIndex = 1;
while 1
    switch(screenIndex)
        case 1
            
            %------------------------
            % Screen 1 with painting
            %------------------------
            while 1
                
                Screen('TextFont', taskParam.gParam.window, 'Arial');
                Screen('TextSize', taskParam.gParam.window, 50);
                
                imageRect = [0 0 500 500];
                dstRect = CenterRect(imageRect, taskParam.gParam.windowRect);
                [cannonPic, ~, alpha]  = imread('cannon.png');
                cannonPic(:,:,4) = alpha(:,:);
                Screen('BlendFunction', taskParam.gParam.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
                cannonTxt = Screen('MakeTexture', taskParam.gParam.window, cannonPic);
                %Screen('DrawTexture', taskParam.gParam.window, cannonTxt,[], dstRect, [], [], [0], [0 0 0], [], []);  %Boat
                
                txtScreen1='Cannonball';
                DrawFormattedText(taskParam.gParam.window, txtScreen1, 'center', 100, [255 255 255]);
                Screen('DrawingFinished', taskParam.gParam.window);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                
                [~, ~, keyCode] = KbCheck;
                if find(keyCode) == taskParam.keys.enter
                    screenIndex = screenIndex + 1;
                    break
                end
                
                
            end
            KbReleaseWait();
            
            
            %---------
            % Screen 2
            %---------
            
        case 2
            
            Screen('TextSize', taskParam.gParam.window, 30);
            txt=['Eine Kanone zielt auf eine Stelle des weißen Kreises. Mit dem blauen Punkt '...
                'kannst du die Kanonenkugel abfangen und verhindern, dass der '...
                'Kreis getroffen wird.\n\nProbiere den blauen Punkt mit '...
                'den blauen (schnell) und grünen (langsam) Tasten auf dem Kreis '...
                'zu bewegen.'];
            
            distMean = 0;
            outcome = 0;
            
            DrawFormattedText(taskParam.gParam.window, taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
            [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt, cannon, 'arrow', distMean);
            
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            
            KbReleaseWait();

            %---------
            % Screen 3
            %---------
        case 3

            txt=['Steuere den blauen Punkt jetzt auf die Stelle, worauf die '...
                'Kanone zielt und drücke LEERTASTE.'];

            distMean = 290;
            outcome = 290;
            [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt, cannon, 'space', distMean);
            KbReleaseWait();
            background = true;
            Cannonball(taskParam, distMean, outcome, background)
            KbReleaseWait();

            if Data.predErr >= 9
                
                while 1

                    txt=['Leider hast du die Kanonenkugel vefehlt. Versuche es noch einmal!'];
                    
                    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, outcome);
                    Cannon(taskParam, distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                    
                    
                    if isequal(taskParam.gParam.computer, 'Dresden')
                        DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                    else
                        DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 80);
                    end
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    
                    
                    [ keyIsDown, ~, keyCode ] = KbCheck;
                    if keyIsDown
                        if keyCode(taskParam.keys.enter)
                            screenIndex = screenIndex;
                            break
                        elseif keyCode(taskParam.keys.delete)
                            screenIndex = screenIndex;
                            break
                        end
                    end
                end
                
            else     
                screenIndex = screenIndex +1;            
            end
            KbReleaseWait();
        
        case 4
            
            while 1

                txt=['Wie du siehst, hast du die Kanonenkugel abgefangen.'];
                LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                DrawCircle(taskParam);
                DrawCross(taskParam);
                PredictionSpot(taskParam);
                DrawOutcome(taskParam, outcome);
                Cannon(taskParam, distMean)
                DrawPE_Bar(taskParam, Data, 1)
                DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                
                if isequal(taskParam.gParam.computer, 'Dresden')
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                else
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 80);
                end
                Screen('DrawingFinished', taskParam.gParam.window);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                
                [ keyIsDown, ~, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(taskParam.keys.enter)
                        screenIndex = screenIndex + 1;
                        break
                    elseif keyCode(taskParam.keys.delete)
                        screenIndex = screenIndex - 3;
                        break
                    end
                end
            end
            
            
            KbReleaseWait();
            
            
            %---------
            %
            % Screen 6
            %
            %---------
            
            case 5
            
            txt=['Steuere den blauen Punkt jetzt neben das Ziel der '...
                'Kanone, so dass du die Kanonenkugel verfehlst '...
                'und drücke LEERTASTE.'];
            % end
            
            
            distMean = 35;
            outcome = 35;
            [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt, cannon, 'space', distMean);
            KbReleaseWait();
            background = true;
            Cannonball(taskParam, distMean, outcome, background)

            if Data.predErr <=9

            while 1
                
                if isequal(taskParam.gParam.computer, 'Dresden')
                    txt=['Der schwarze Balken zeigt dir dann die Position '...
                        'des Schiffs an.\n\nWenn dein Punkt auf dem Schiff ist, '...
                        'hast du es getroffen.'];
                elseif isequal(taskParam.gParam.computer, 'D_Pilot')
                    txt=['Der schwarze Balken zeigt dir dann die Position '...
                        'des Schiffs an. Wenn dein Punkt auf dem\n\nSchiff ist, '...
                        'hast du es getroffen.'];
                else
                    txt=['Du hast die Kanonenkugel abgefangen. Versuche die Kanonenkugel diesmal zu verpassen!'];
                end
                LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                DrawCircle(taskParam);
                DrawCross(taskParam);
                PredictionSpot(taskParam);
                DrawOutcome(taskParam, outcome);
                Cannon(taskParam, distMean)
                DrawPE_Bar(taskParam, Data, 1)
                DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                
                
                if isequal(taskParam.gParam.computer, 'Dresden')
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                else
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 80);
                end
                Screen('DrawingFinished', taskParam.gParam.window);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                
                [ keyIsDown, ~, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(taskParam.keys.enter)
                        screenIndex = screenIndex;
                        break
                    elseif keyCode(taskParam.keys.delete)
                        screenIndex = screenIndex;
                        break
                    end
                end
            end
            
            else 
                
                
                while 1

                txt=['Wie du siehst, hast du die Kanonenkugel diesmal verpasst. '...
                        'Der schwarze Balken zeigt dir wie weit die Kanonenkugel vom '...
                        'blauen Punkt entfernt war.'];
                LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                DrawCircle(taskParam);
                DrawCross(taskParam);
                PredictionSpot(taskParam);
                DrawOutcome(taskParam, outcome);
                Cannon(taskParam, distMean)
                DrawPE_Bar(taskParam, Data, 1)
                DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                
                if isequal(taskParam.gParam.computer, 'Dresden')
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                else
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 80);
                end
                Screen('DrawingFinished', taskParam.gParam.window);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                
                [ keyIsDown, ~, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(taskParam.keys.enter)
                        screenIndex = screenIndex + 1;
                        break
                    elseif keyCode(taskParam.keys.delete)
                        screenIndex = screenIndex - 3;
                        break
                    end
                end
            end
            
            
            KbReleaseWait();
            
            
                
                
            end
            
            KbReleaseWait();
            
        case 6
            txt=['Nachdem du siehst, ob du die Kanonenkugel gefangen hast, '...
                'erfährst du, ob die Kanonenkugel aus Gold oder Eisen '...
                'war. Beachte, dass du vor und während dem Schuss nicht herausfinden kannst, '...
                'aus welchem Material die Kugel gemacht ist.\n\nWenn du eine goldene Kanonenkugel '...
                'gefangen hast, verdienst du 10 Cent. Wenn du eine silberne Kugel fängst, '... 
                'verdienst du leider nichts. Am Ende der Studie bekommst du das Geld '...
                'für die gefangenen goldenen Kugeln tatsächlich ausgezahlt.\n\n'...
                'Weil du vorher nicht weißt, ob die Kanonenkugel gold oder silber ist, '...
                'probierst du am besten alle Kugeln zu fangen.'];
            
            
            header = 'Die Kanonenkugeln';
            feedback = false
            [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end    
            
        case 7

            txt=['Versuche die Kanonenkugel jetzt wieder zu fangen.'];
            
            distMean = 290;
            outcome = 290;
            [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt, cannon, 'space', distMean);
            KbReleaseWait();
            background = true;
            Cannonball(taskParam, distMean, outcome, background)
            KbReleaseWait();
            
            if Data.predErr >= 9
                
                while 1

                    txt=['Leider hast du die Kanonenkugel vefehlt. Versuche es noch einmal!'];
                    
                    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, outcome);
                    Cannon(taskParam, distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                    
                    
                    if isequal(taskParam.gParam.computer, 'Dresden')
                        DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                    else
                        DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 80);
                    end
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    
                    
                    [ keyIsDown, ~, keyCode ] = KbCheck;
                    if keyIsDown
                        if keyCode(taskParam.keys.enter)
                            screenIndex = screenIndex;
                            break
                        elseif keyCode(taskParam.keys.delete)
                            screenIndex = screenIndex;
                            break
                        end
                    end
                end
                
            else     
                screenIndex = screenIndex +1;            
            end
            KbReleaseWait();
            


        case 8
            while 1
                
                
                txt=['Da du die eine goldene Kanonenkugel gefangen hast, '...
                    'hättest du jetzt 10 CENT verdient.'];
                
                
                LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                if isequal(taskParam.gParam.computer, 'Dresden')
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                else
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 80);
                end
                DrawCircle(taskParam)
                PredictionSpot(taskParam);
                DrawPE_Bar(taskParam, Data, 1)
                DrawOutcome(taskParam, outcome);
                if subject.rew == '1'
                    Reward(taskParam, 'gold')
                else
                    DrawBoat(taskParam, taskParam.colors.silver)
                end
                DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
                Screen('DrawingFinished', taskParam.gParam.window, [], []);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                screenIndex = GetScreenIndex(taskParam, screenIndex);
                break
                
            end
            KbReleaseWait();
            
            %---------
            % Screen 7
            %---------
        case 9
            
            txt=['Veruche die Kanonenkugel bei nächsten Schuss zu verfehlen.'];
            % end
            
            
            distMean = 35;
            outcome = 35;
            [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt, cannon, 'space', distMean);
            KbReleaseWait();
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            
            KbReleaseWait();
            
        case 10
            background = true;
            Cannonball(taskParam, distMean, outcome, background)
            if Data.predErr >= 9
                screenIndex = screenIndex + 2;
            else
                screenIndex = screenIndex + 1;
            end
            KbReleaseWait();
            
        case 11
            
            while 1
                
                if isequal(taskParam.gParam.computer, 'Dresden')
                    txt=['Der schwarze Balken zeigt dir dann die Position '...
                        'des Schiffs an.\n\nWenn dein Punkt auf dem Schiff ist, '...
                        'hast du es getroffen.'];
                elseif isequal(taskParam.gParam.computer, 'D_Pilot')
                    txt=['Der schwarze Balken zeigt dir dann die Position '...
                        'des Schiffs an. Wenn dein Punkt auf dem\n\nSchiff ist, '...
                        'hast du es getroffen.'];
                else
                    txt=['Du hast die Kanonenkugel abgefangen. Versuche die Kanonenkugel diesmal zu verpassen!'];
                end
                LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                DrawCircle(taskParam);
                DrawCross(taskParam);
                PredictionSpot(taskParam);
                DrawOutcome(taskParam, outcome);
                Cannon(taskParam, distMean)
                DrawPE_Bar(taskParam, Data, 1)
                DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                
                
                if isequal(taskParam.gParam.computer, 'Dresden')
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                else
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 80);
                end
                Screen('DrawingFinished', taskParam.gParam.window);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                
                [ keyIsDown, ~, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(taskParam.keys.enter)
                        screenIndex = screenIndex - 2;
                        break
                    elseif keyCode(taskParam.keys.delete)
                        screenIndex = screenIndex - 2;
                        break
                    end
                end
            end
            
            
            KbReleaseWait();
            
            
            
            
           
        case 12
            while 1
                
                
                txt=['Weil du eine goldene Kugel verpasst hast, '...
                    'hättest du in diesem Fall NICHTS verdient.'];
                
                
                LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                if isequal(taskParam.gParam.computer, 'Dresden')
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                else
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 90);
                end
                DrawCircle(taskParam)
                PredictionSpot(taskParam);
                DrawPE_Bar(taskParam, Data, 1)
                DrawOutcome(taskParam, outcome);
                if subject.rew == '1'
                    
                    
                    Reward(taskParam, 'gold')
                else
                    DrawBoat(taskParam, taskParam.colors.silver)
                end
                DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
                Screen('DrawingFinished', taskParam.gParam.window, [], []);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                screenIndex = GetScreenIndex(taskParam, screenIndex);
                break
                
            end
            KbReleaseWait();
            
            %---------
            % Screen 11
            %---------
        case 13
            
            txt=['Versuche die Kanonenkugel jetzt wieder zu fangen.'];
            
            
            
            distMean = 190;
            outcome = 190;
            [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt, cannon, 'space', distMean);
            KbReleaseWait();
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            
            KbReleaseWait();
        case 14
            
            background = true;
            Cannonball(taskParam, distMean, outcome, background)
            if Data.predErr <= 9
                screenIndex = screenIndex + 2;
            else
                screenIndex = screenIndex + 1;
            end
            KbReleaseWait();
            
        case 15
            
            while 1
                
                if isequal(taskParam.gParam.computer, 'Dresden')
                    txt=['Der schwarze Balken zeigt dir dann die Position '...
                        'des Schiffs an.\n\nWenn dein Punkt auf dem Schiff ist, '...
                        'hast du es getroffen.'];
                elseif isequal(taskParam.gParam.computer, 'D_Pilot')
                    txt=['Der schwarze Balken zeigt dir dann die Position '...
                        'des Schiffs an. Wenn dein Punkt auf dem\n\nSchiff ist, '...
                        'hast du es getroffen.'];
                else
                    txt=['Leider hast du die Kanonenkugel vefehlt. Versuche es noch einmal!'];
                end
                LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                DrawCircle(taskParam);
                DrawCross(taskParam);
                PredictionSpot(taskParam);
                DrawOutcome(taskParam, outcome);
                Cannon(taskParam, distMean)
                DrawPE_Bar(taskParam, Data, 1)
                DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                
                
                if isequal(taskParam.gParam.computer, 'Dresden')
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                else
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 80);
                end
                Screen('DrawingFinished', taskParam.gParam.window);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                
                [ keyIsDown, ~, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(taskParam.keys.enter)
                        screenIndex = screenIndex - 2;
                        break
                    elseif keyCode(taskParam.keys.delete)
                        screenIndex = screenIndex - 2;
                        break
                    end
                end
            end
            
            
            KbReleaseWait();
            
            
        case 16
            while 1
                
                
                txt=['Weil du eine eiserne Kanonenkugel gefangen hast, '...
                    'hättest du NICHTS verdient.'];
                
                LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                if isequal(taskParam.gParam.computer, 'Dresden')
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                else
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 90);
                end
                DrawCircle(taskParam)
                PredictionSpot(taskParam);
                DrawPE_Bar(taskParam, Data, 1)
                DrawOutcome(taskParam, outcome);
                if subject.rew == '1'
                    color = 'gold';
                    Reward(taskParam, 'silver')
                else
                    DrawBoat(taskParam, taskParam.colors.silver)
                end
                DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
                Screen('DrawingFinished', taskParam.gParam.window, [], []);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                screenIndex = GetScreenIndex(taskParam, screenIndex);
                break
                
            end
            KbReleaseWait();
            
            %---------
            % Screen 3
            %---------
        case 17
            
            txt=['Veruche die Kanonenkugel bei nächsten Schuss wieder zu verfehlen.'];
            % end
            
            
            distMean = 160;
            outcome = 160;
            [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt, cannon, 'space', distMean);
            KbReleaseWait();
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            
            KbReleaseWait();
        case 18
            
            
            background = true;
            Cannonball(taskParam, distMean, outcome, background)
            if Data.predErr >= 9
                screenIndex = screenIndex + 2;
            else
                screenIndex = screenIndex + 1;
            end
            KbReleaseWait();
            
            
            %---------
            %
            % Screen 5
            %
            %---------
            
        case 19
            
            while 1
                
                if isequal(taskParam.gParam.computer, 'Dresden')
                    txt=['Der schwarze Balken zeigt dir dann die Position '...
                        'des Schiffs an.\n\nWenn dein Punkt auf dem Schiff ist, '...
                        'hast du es getroffen.'];
                elseif isequal(taskParam.gParam.computer, 'D_Pilot')
                    txt=['Der schwarze Balken zeigt dir dann die Position '...
                        'des Schiffs an. Wenn dein Punkt auf dem\n\nSchiff ist, '...
                        'hast du es getroffen.'];
                else
                    txt=['Du hast die Kanonenkugel abgefangen. Versuche die Kanonenkugel diesmal zu verpassen!'];                end
                LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                DrawCircle(taskParam);
                DrawCross(taskParam);
                PredictionSpot(taskParam);
                DrawOutcome(taskParam, outcome);
                Cannon(taskParam, distMean)
                DrawPE_Bar(taskParam, Data, 1)
                DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                
                
                if isequal(taskParam.gParam.computer, 'Dresden')
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                else
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 80);
                end
                Screen('DrawingFinished', taskParam.gParam.window);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                
                [ keyIsDown, ~, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(taskParam.keys.enter)
                        screenIndex = screenIndex - 2;
                        break
                    elseif keyCode(taskParam.keys.delete)
                        screenIndex = screenIndex - 2;
                        break
                    end
                end
            end
 
            
        case 20
            while 1
                
                
                txt=['In diesem Fall war die Kugel aus Eisen und du '...
                    'hast sie verpasst. Daher hättest du NICHTS verdient.'];
                
                
                LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                if isequal(taskParam.gParam.computer, 'Dresden')
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
                else
                    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.1,taskParam.gParam.screensize(4)*0.05, [255 255 255], 90);
                end
                DrawCircle(taskParam)
                
                
                PredictionSpot(taskParam);
                DrawPE_Bar(taskParam, Data, 1)
                DrawOutcome(taskParam, outcome);
                
                
                if subject.rew == '1'
                    Reward(taskParam, 'silver')
                else
                    DrawBoat(taskParam, taskParam.colors.silver)
                end
                DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
                Screen('DrawingFinished', taskParam.gParam.window, [], []);
                t = GetSecs;
                Screen('Flip', taskParam.gParam.window, t + 0.1);
                
                screenIndex = GetScreenIndex(taskParam, screenIndex);
                break
                
            end
            KbReleaseWait();
            
            
            
            %---------
            %
            % Screen 8
            %
            %---------

            
            
        case 21
            txt=['Weil die Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. '...
                'Wenn du den blauen Punkt genau auf die Stelle steuerst, auf die die Kanone zielt, fängst du '...
                'die meisten Kugeln. Durch die Ungenauigkeit der Kanone kann die '...
                'Kugel aber manchmal auch ein Stück neben die anvisierte Stelle fliegen, '...
                'wodurch du sie dann verpasst.\n\n'...
                'In der nächsten Übung sollst du mit der ungenauigkeit der Kanone erstmal vertraut werden. '...
                'Lasse den blauen Punkt bitte immer auf der anvisierten Stelle stehen. '...
                'Wenn du deinen Punkt neben die anvisierte Stelle steuerst, wird die Übung wiederholt.'];
            
            
            header = 'Erste Übung';
            
            
            [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            
            
        case 22
            if subject.cBal == '1'
                
                
                [taskParam, practData] = PractLoop(taskParam, subject, taskParam.gParam.vola(3), taskParam.gParam.sigma(1), cannon)
                
                hits = sum(practData.hit == 1)
                goldBall = sum(practData.boatType == 1)
                goldHit = practData.accPerf(end)/taskParam.gParam.rewMag %sum(practData.boatType == 1)
                silverBall = sum(practData.boatType == 2)
                silverHit = hits - goldHit;
                
                maxMon = (length(find(practData.boatType == 1)) * taskParam.gParam.rewMag);
                txt = sprintf(['Gefangene goldene Kugeln: %.0f von %.0f\n\n'...
                               'Gefangene eiserne Kugeln: %.0f von %.0f\n\n'...
                               'In diesem Block hättest du %.2f von '...
                               'maximal %.2f Euro gewonnen'], goldHit, goldBall, silverHit, silverBall, practData.accPerf(end), maxMon);
                
                header = 'Leistung';
                feedback = true
                [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                sumCannonDev = sum(practData.cannonDev >= 5)
                
                if sumCannonDev >= 5
                    
                    header = 'Wiederholung der Übung';
                    txt = ['In der letzten Übung hast du dich zu häufig vom Ziel '...
                        'der Kanone wegbewegt. Du kannst mehr Kugeln fangen, wenn du '...
                        'immer auf dem Ziel der Kanone bleibst!\n\n'...
                        'In der nächsten Runde kannst du nochmal üben. '...
                        'Wenn du noch Fragen hast, kannst du dich auch an den Versuchsleiter wenden.']
                    feedback = false
                    [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                    
                    
                    screenIndex = screenIndex;
                   
                else
                    header = 'Zweite Übung';
                    txt = ['Gut gemacht! In der letzten Übung hast du den blauen Punkt '...
                        'auf die Stelle gesteuert, auf die die Kanone gezielt hat und dadurch viele '...
                        'Kugeln gefangen. '...
                        'In der nächsten Übung wird die Kanone ab und zu auf eine neue Stelle zielen. '...
                        'Wenn du siehst, dass die Kanone auf eine neue Stelle zielt, solltest du den blauen Punkt '...
                        'auf das neue Ziel der Kanone steuern.\n\n'...
                        'Im ersten Block wird die Kanone nur selten auf eine neue Stelle zielen. '...
                        'Im zweiten Block ändert die Kanone ihr Ziel etwas häufiger. '...
                        'Wenn du deinen Punkt zu oft neben die anvisierte Stelle steuerst, muss die Übung wiederholt werden.']
                    feedback = false
                    [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                    
                    screenIndex = screenIndex + 1;
                    
                end
            end
            
        case 23
            
            VolaIndication(taskParam, taskParam.strings.txtLowVola, taskParam.strings.txtPressEnter)
            KbReleaseWait();
            [taskParam, practData] = PractLoop(taskParam, subject, taskParam.gParam.vola(1), taskParam.gParam.sigma(1), cannon);
            
            hits = sum(practData.hit == 1)
                goldBall = sum(practData.boatType == 1)
                goldHit = practData.accPerf(end)/taskParam.gParam.rewMag %sum(practData.boatType == 1)
                silverBall = sum(practData.boatType == 2)
                silverHit = hits - goldHit;
                
                maxMon = (length(find(practData.boatType == 1)) * taskParam.gParam.rewMag);
                txt = sprintf(['Gefangene goldene Kugeln: %.0f von %.0f\n\n'...
                               'Gefangene eiserne Kugeln: %.0f von %.0f\n\n'...
                               'In diesem Block hättest du %.2f von '...
                               'maximal %.2f Euro gewonnen'], goldHit, goldBall, silverHit, silverBall, practData.accPerf(end), maxMon);
                
                header = 'Leistung';
                feedback = true
                [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            
            
            sumCannonDev = sum(practData.cannonDev >= 5)
            if sumCannonDev >= 5
                
                header = 'Wiederholung der Übung';
                txt = ['In der letzten Übung hast du dich zu häufig vom Ziel '...
                    'der Kanone wegbewegt. Du kannst mehr Kugeln fangen, wenn du '...
                    'immer auf dem Ziel der Kanone bleibst!\n\n'...
                    'In der nächsten Runde kannst nochmal üben. '...
                    'Wenn du noch Fragen hast, kannst du dich auch an den Versuchsleiter wenden.']
                feedback = false
                [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                
               
                screenIndex = screenIndex;
                % elseif bw == 1
                %     screenIndex = screenIndex - 1;
                %end
            else
                screenIndex = screenIndex + 1;
                
            end
            
            if subject.cBal == '2'
                
              
                if taskParam.gParam.runVola == false
                    VolaIndication(taskParam, taskParam.strings.txtHighVola, taskParam.strings.txtPressEnter)
                else
                    VolaIndication(taskParam, taskParam.strings.txtHVHS, taskParam.strings.txtPressEnter)
                end
                KbReleaseWait();
                
                
                
                
                taskParam = PractLoop(taskParam, subject, distMean(i), outcome(i), boatType(i), cannon);
                
                
                
                if taskParam.gParam.runVola == false
                    VolaIndication(taskParam, taskParam.strings.txtLowVola, taskParam.strings.txtPressEnter)
                else
                    VolaIndication(taskParam, taskParam.strings.txtLVLS, taskParam.strings.txtPressEnter)
                end
                
                
                
                
                taskParam = PractLoop(taskParam, subject, distMean(i), outcome(i), boatType(i));
               
            end
        case 24
            
            VolaIndication(taskParam, taskParam.strings.txtHighVola, taskParam.strings.txtPressEnter)
            KbReleaseWait();
            [taskParam, practData] = PractLoop(taskParam, subject, taskParam.gParam.vola(2), taskParam.gParam.sigma(1), cannon);
            
            hits = sum(practData.hit == 1)
                goldBall = sum(practData.boatType == 1)
                goldHit = practData.accPerf(end)/taskParam.gParam.rewMag %sum(practData.boatType == 1)
                silverBall = sum(practData.boatType == 2)
                silverHit = hits - goldHit;
                
                maxMon = (length(find(practData.boatType == 1)) * taskParam.gParam.rewMag);
                txt = sprintf(['Gefangene goldene Kugeln: %.0f von %.0f\n\n'...
                               'Gefangene eiserne Kugeln: %.0f von %.0f\n\n'...
                               'In diesem Block hättest du %.2f von '...
                               'maximal %.2f Euro gewonnen'], goldHit, goldBall, silverHit, silverBall, practData.accPerf(end), maxMon);
                
                header = 'Leistung';
                feedback = true
                [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            
            sumCannonDev = sum(practData.cannonDev >= 5)
            if sumCannonDev >= 5
                
                header = 'Wiederholung der Übung';
                txt = ['In der letzten Übung hast du dich zu häufig vom Ziel '...
                    'der Kanone wegbewegt. Du kannst mehr Kugeln fangen, wenn du '...
                    'immer auf dem Ziel der Kanone bleibst!\n\n'...
                    'In der nächsten Runde kannst nochmal üben. '...
                    'Wenn du noch Fragen hast, kannst du dich auch an den Versuchsleiter wenden.']
                feedback = false
                [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                
               
                screenIndex = screenIndex;
               
            else
                screenIndex = screenIndex + 1;
                
            end
            
            if subject.cBal == '2'
                
                
                if taskParam.gParam.runVola == false
                    VolaIndication(taskParam, taskParam.strings.txtHighVola, taskParam.strings.txtPressEnter)
                else
                    VolaIndication(taskParam, taskParam.strings.txtHVHS, taskParam.strings.txtPressEnter)
                end
                KbReleaseWait();
                
                
                
                
                taskParam = PractLoop(taskParam, subject, distMean(i), outcome(i), boatType(i), cannon);
                
                
                
                if taskParam.gParam.runVola == false
                    VolaIndication(taskParam, taskParam.strings.txtLowVola, taskParam.strings.txtPressEnter)
                else
                    VolaIndication(taskParam, taskParam.strings.txtLVLS, taskParam.strings.txtPressEnter)
                end
                
                
                
                
                taskParam = PractLoop(taskParam, subject, distMean(i), outcome(i), boatType(i));
                
            end    
            
        case 25
            header = 'Ende der zweiten Übung';

                txt = ['Ok, bis jetzt kanntest du das Ziel der Kanone und du konntest '...
                    'die meisten Kugeln abfangen. Im nächsten Übungsdurchgang wird die '...
                    'Kanone von Nebel verdeckt sein, so dass du sie nicht mehr sehen kannst. '...
                    'Allerdings siehst du, wo die Kanonenkugeln landen.\n\n'...
                    'Um weiterhin viele Kanonenkugeln fangen zu können, musst du aufgrund der Landeposition '...
                    'einschätzen, auf welche Stelle die Kanone zielt und den blauen Punkt auf diese Position steuern. '...
                    'Wenn du denkst, dass die Kanone auf eine neue Stelle zielt, solltest du auch den blauen Punkt dort hin bewegen. '];

            feedback = false;
            [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
                
            elseif bw == 1
                screenIndex = screenIndex - 1;
                
            end
        case 26
            break
    end
    
end
end
