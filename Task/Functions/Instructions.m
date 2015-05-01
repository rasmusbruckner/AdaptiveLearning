function Instructions(taskParam, type, subject)
% BattleShipsInstructions runs the practice sessions.
%   Depending on cBal you start with a different task.


%% KRITERIUM UNBEDINGT EINBAUEN


cannon = true;

Screen('TextFont', taskParam.gParam.window, 'Arial');
Screen('TextSize', taskParam.gParam.window, 50);
sentenceLength = taskParam.gParam.sentenceLength;
if subject.rew == 1
    colRew = 'blau';
    colNoRew = 'grün';
elseif subject.rew == 2
    colRew = 'grün';
    colNoRew = 'blau';
end

while 1
    Screen('TextFont', taskParam.gParam.window, 'Arial');
    Screen('TextSize', taskParam.gParam.window, 50);
    if (isequal(type, 'Practice') && subject.cBal == 1) || (isequal(type, 'PracticeCont') && subject.cBal == 2)
        txt='Herzlich Willkommen\n\nErster Teil...';
    else
        txt = 'Zweiter Teil...';
    end
    
    DrawFormattedText(taskParam.gParam.window, txt,...
        'center', 100, [255 255 255]);
    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.1);
    [~, ~, keyCode] = KbCheck;
    if find(keyCode) == taskParam.keys.enter
        break
    end
end
WaitSecs(0.1);

if isequal(type, 'Oddball') || isequal(type, 'Main') || isequal(type, 'Practice') %&& subject.cBal == 1)
    MainAndOddballInstructions
elseif isequal(type, 'PracticeCont') %&& subject.cBal == 2)
    ControlInstructions
end


    function ControlInstructions
        
        %Data.distMean = [290 310];
        %Data.outcome = Data.distMean;
        
        screenIndex = 1;
        while 1
            switch(screenIndex)
                case 1
                    % Intro screen
                    while 1
                        WaitSecs(0.1);
                        Screen('TextFont', taskParam.gParam.window, 'Arial');
                        Screen('TextSize', taskParam.gParam.window, 50);
                        txt='Deine Aufgabe: Kanonenkugeln einsammeln';
                        DrawFormattedText(taskParam.gParam.window, txt,...
                            'center', 100, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        [~, ~, keyCode] = KbCheck;
                        if find(keyCode) == taskParam.keys.enter
                            if (isequal(type, 'PracticeCont')) && subject.cBal == 2
                                screenIndex = screenIndex + 1;
                            else
                                screenIndex = screenIndex + 1;
                            end
                            break
                        end
                    end
                    WaitSecs(0.1);
                    
                    
                case 2
                    WaitSecs(0.1);
                    Screen('TextSize', taskParam.gParam.window, 30);
                    txt=['Eine Kanone zielt auf eine Stelle des '...
                        'Kreises. Mit dem orangenen Punkt kannst du angeben, '...
                        'wo du dein Schild platzieren möchtest, um die '...
                        'Kanonenkugel einzusammeln.\nDu kannst den Punk mit den '...
                        'grünen und gelben Tasten steuern. '...
                        'Grün kannst du für schnelle Bewegungen und '...
                        'gelb für langsame Bewegungen benutzen.'];
                    distMean = 0;
                    outcome = 0;
                    DrawFormattedText(taskParam.gParam.window,...
                        taskParam.strings.txtPressEnter,'center',...
                        taskParam.gParam.screensize(4)*0.9);
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                        txt, cannon, 'arrow', distMean);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 1; % go to case 1
                    end
                    WaitSecs(0.1);
                case 3
                    
                    % Hands-on intro
                    txt=['Drücke LEERTASTE, damit die Kanone schießt.'];
                    distMean = 290;
                    outcome = 290;
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                        txt, cannon, 'space', distMean);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                        %elseif bw == 1
                        %    screenIndex = screenIndex - 1;
                    end
                    
                case 4
                    % Feedback that ball was caught
                    background = true;
                    Cannonball(taskParam, distMean, outcome, background)
                    
                    LineAndBack(taskParam)
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, outcome);
                    Cannon(taskParam, distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        
                        txt=['Nach dem Schuss erscheint dein Schild. '...
                            'Das Schild kannst du benutzen um die Kanonenkugel einzusammeln. '];
                        
                        LineAndBack(taskParam)
                        Cannon(taskParam, distMean)
                        DrawCircle(taskParam)
                        
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 1)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 0)
                            
                        end
                        DrawOutcome(taskParam, outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.6);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex + 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 3; % go to case 2
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                    
                    
                    
                case 5
                    % Hands-on intro
                    
                    % Feedback that ball was caught
                    %
                    %                     LineAndBack(taskParam)
                    %                     DrawCircle(taskParam);
                    %                     DrawCross(taskParam);
                    %                     %PredictionSpot(taskParam);
                    %                     %DrawOutcome(taskParam, outcome);
                    %                     %Cannon(taskParam, distMean)
                    %                     Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    %                     Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.1, 1);
                    WaitSecs(0.5)
                    
                    txt=['Bewege den orangenen Punkt zur Stelle der letzten Kanonenkugel '...
                        '(schwarzer Strich) und drücke LEERTASTE um die Kugel aufzusammeln. '...
                        'Gleichzeitig schießt die Kanone dann eine neue Kugel ab.'];
                    Data.distMean = 35;
                    Data.outcome = 290;
                    Data.tickMark = true;
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                        txt, cannon, 'space', Data.distMean, Data);
                    
                    if fw == 1
                        screenIndex = screenIndex + 1;
                        %elseif bw == 1
                        %    screenIndex = screenIndex - 1;
                    end
                    
                case 6
                    
                    % Feedback that ball was caught
                    Data.distMean = 35;
                    Data.outcome = 35;
                    background = true;
                    Cannonball(taskParam, Data.distMean, Data.outcome, background)
                    %WaitSecs(0.5)
                    if Data.memErr >=9
                        
                        LineAndBack(taskParam)
                        DrawCross(taskParam)
                        DrawCircle(taskParam)
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.5, 1);
                        %WaitSecs(0.5)
                        
                        
                        while 1
                            
                            txt=['Du hast die Kanonenkugel leider nicht aufgesammelt. '...
                                'Versuche es nochmal!'];
                            
                            LineAndBack(taskParam)
                            DrawCircle(taskParam);
                            DrawCross(taskParam);
                            PredictionSpot(taskParam);
                            DrawOutcome(taskParam, Data.outcome);
                            Cannon(taskParam, Data.distMean)
                            DrawPE_Bar(taskParam, Data, 1)
                            TickMark(taskParam, Data.outcome, 'outc')
                            TickMark(taskParam, Data.pred, 'pred')
                            DrawFormattedText(taskParam.gParam.window,...
                                taskParam.strings.txtPressEnter,'center',...
                                taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                            DrawFormattedText(taskParam.gParam.window,txt,...
                                taskParam.gParam.screensize(3)*0.1,...
                                taskParam.gParam.screensize(4)*0.05,...
                                [255 255 255], sentenceLength);
                            Screen('DrawingFinished', taskParam.gParam.window);
                            %t = GetSecs;
                            Screen('Flip', taskParam.gParam.window, t + 1.5);
                            [ keyIsDown, ~, keyCode ] = KbCheck;
                            if keyIsDown
                                if keyCode(taskParam.keys.enter)
                                    screenIndex = screenIndex - 1 ;
                                    break
                                elseif keyCode(taskParam.keys.delete)
                                    screenIndex = screenIndex - 5; % go to case 2
                                    break
                                end
                            end
                        end
                    else
                        
                        
                        LineAndBack(taskParam)
                        DrawCircle(taskParam);
                        DrawCross(taskParam);
                        PredictionSpot(taskParam);
                        DrawOutcome(taskParam, Data.outcome);
                        Cannon(taskParam, Data.distMean)
                        DrawPE_Bar(taskParam, Data, 1)
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        % Show baseline 1.
                        LineAndBack(taskParam)
                        DrawCross(taskParam)
                        DrawCircle(taskParam)
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                        while 1
                            
                            txt=['Sehr gut! Du hast die vorherige Kanonenkugel aufgesammelt. '...
                                'Wie du sehen kannst hat die Kanone auch eine neue Kugel abgeschossen, '...
                                'die du im nächsten Durchgang aufsammeln kannst.'];
                            
                            LineAndBack(taskParam)
                            Cannon(taskParam, Data.distMean)
                            DrawCircle(taskParam)
                            
                            if subject.rew == 1
                                Shield(taskParam, 20, Data.pred, 1)
                            elseif subject.rew == 2
                                Shield(taskParam, 20, Data.pred, 0)
                                
                            end
                            DrawOutcome(taskParam, Data.outcome) %%TRIGGER
                            DrawFormattedText(taskParam.gParam.window,txt,...
                                taskParam.gParam.screensize(3)*0.1,...
                                taskParam.gParam.screensize(4)*0.05,...
                                [255 255 255], sentenceLength);
                            DrawFormattedText(taskParam.gParam.window,...
                                taskParam.strings.txtPressEnter,'center',...
                                taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                            Screen('DrawingFinished', taskParam.gParam.window, 1);
                            Screen('Flip', taskParam.gParam.window, t + 1.6);
                            [ keyIsDown, ~, keyCode ] = KbCheck;
                            if keyIsDown
                                if keyCode(taskParam.keys.enter)
                                    screenIndex = screenIndex + 1;
                                    break
                                elseif keyCode(taskParam.keys.delete)
                                    screenIndex = screenIndex - 3; % go to case 2
                                    break
                                end
                            end
                        end
                    end
                    WaitSecs(0.1);
                    
                    
                    
                case 7
                    % Hands-on intro
                    
                    % Feedback that ball was caught
                    %
                    %                     LineAndBack(taskParam)
                    %                     DrawCircle(taskParam);
                    %                     DrawCross(taskParam);
                    %                     %PredictionSpot(taskParam);
                    %                     %DrawOutcome(taskParam, outcome);
                    %                     %Cannon(taskParam, distMean)
                    %                     Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    %                     Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.1, 1);
                    WaitSecs(0.5)
                    
                    txt=['Bewege den orangenen Punkt jetzt wieder zur Stelle der letzten Kanonenkugel '...
                        '(schwarzer Strich) und drücke LEERTASTE um die Kugel aufzusammeln.'];
                    Data.distMean = 190;
                    Data.outcome = 35;
                    Data.tickMark = true;
                    
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                        txt, cannon, 'space', Data.distMean, Data);
                    
                    if fw == 1
                        screenIndex = screenIndex + 1;
                        %elseif bw == 1
                        %    screenIndex = screenIndex - 1;
                    end
                    
                case 8
                    
                    % Feedback that ball was caught
                    Data.distMean = 190;
                    Data.outcome = 190;
                    background = true;
                    Cannonball(taskParam, Data.distMean, Data.outcome, background)
                    
                    if Data.memErr >=9
                        
                        LineAndBack(taskParam)
                        DrawCross(taskParam)
                        DrawCircle(taskParam)
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.5, 1);
                        %WaitSecs(0.5)
                        
                        
                        while 1
                            
                            txt=['Du hast die Kanonenkugel leider nicht aufgesammelt. '...
                                'Versuche es nochmal!'];
                            
                            LineAndBack(taskParam)
                            DrawCircle(taskParam);
                            DrawCross(taskParam);
                            PredictionSpot(taskParam);
                            DrawOutcome(taskParam, Data.outcome);
                            Cannon(taskParam, Data.distMean)
                            DrawPE_Bar(taskParam, Data, 1)
                            TickMark(taskParam, Data.outcome, 'outc')
                            TickMark(taskParam, Data.pred, 'pred')
                            DrawFormattedText(taskParam.gParam.window,...
                                taskParam.strings.txtPressEnter,'center',...
                                taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                            DrawFormattedText(taskParam.gParam.window,txt,...
                                taskParam.gParam.screensize(3)*0.1,...
                                taskParam.gParam.screensize(4)*0.05,...
                                [255 255 255], sentenceLength);
                            Screen('DrawingFinished', taskParam.gParam.window);
                            %t = GetSecs;
                            Screen('Flip', taskParam.gParam.window, t + 1.5);
                            [ keyIsDown, ~, keyCode ] = KbCheck;
                            if keyIsDown
                                if keyCode(taskParam.keys.enter)
                                    screenIndex = screenIndex - 1 ;
                                    break
                                elseif keyCode(taskParam.keys.delete)
                                    screenIndex = screenIndex - 5; % go to case 2
                                    break
                                end
                            end
                        end
                    else
                        
                        
                        %                     % Feedback that ball was caught
                        %                     Data.distMean = 190;
                        %                     Data.outcome = 190;
                        %                     background = true;
                        %                     Cannonball(taskParam, Data.distMean, Data.outcome, background)
                        LineAndBack(taskParam)
                        DrawCircle(taskParam);
                        DrawCross(taskParam);
                        PredictionSpot(taskParam);
                        DrawOutcome(taskParam, Data.outcome);
                        Cannon(taskParam, Data.distMean)
                        DrawPE_Bar(taskParam, Data, 1)
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        % Show baseline 1.
                        LineAndBack(taskParam)
                        DrawCross(taskParam)
                        DrawCircle(taskParam)
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                        
                        while 1
                            
                            txt=['Gut gemacht. Als nächstes zeigen wir dir, wie du Geld gewinnen kannst.'];
                            
                            LineAndBack(taskParam)
                            Cannon(taskParam, Data.distMean)
                            DrawCircle(taskParam)
                            
                            if subject.rew == 1
                                Shield(taskParam, 20, Data.pred, 1)
                            elseif subject.rew == 2
                                Shield(taskParam, 20, Data.pred, 0)
                                
                            end
                            DrawOutcome(taskParam, Data.outcome) %%TRIGGER
                            DrawFormattedText(taskParam.gParam.window,txt,...
                                taskParam.gParam.screensize(3)*0.1,...
                                taskParam.gParam.screensize(4)*0.05,...
                                [255 255 255], sentenceLength);
                            DrawFormattedText(taskParam.gParam.window,...
                                taskParam.strings.txtPressEnter,'center',...
                                taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                            Screen('DrawingFinished', taskParam.gParam.window, 1);
                            Screen('Flip', taskParam.gParam.window, t + 1.6);
                            [ keyIsDown, ~, keyCode ] = KbCheck;
                            if keyIsDown
                                if keyCode(taskParam.keys.enter)
                                    screenIndex = screenIndex + 1;
                                    break
                                elseif keyCode(taskParam.keys.delete)
                                    screenIndex = screenIndex - 3; % go to case 2
                                    break
                                end
                            end
                        end
                        WaitSecs(0.1);
                        
                        
                    end
                    
                    
                case 9
                    
                    
                    header = 'Das Schild';
                    if subject.rew == 1
                        colRew = 'blau';
                        colNoRew = 'grün';
                    elseif subject.rew == 2
                        colRew = 'grün';
                        colNoRew = 'blau';
                    end
                    txt = sprintf(['Wenn du Kanonenkugeln aufsammelst, kannst du Geld verdienen. '...
                        'Wenn das Schild %s ist, verdienst du 20 CENT wenn du die Kanonenkugel aufsammelst. '...
                        'Wenn das Schild %s ist, verdienst du nichts. '...
                        'Die Größe deines Schildes kann sich jedes Mal ändern. '...  % reward.
                        'Die Farbe und die Größe des Schildes kennst du erst, nachdem die Kanone geschossen hat. '...
                        'Daher versuchst du am besten jede Kanonenkugel aufzusammeln.\n\n'...
                        'Um einen Eindruck von der wechselnden Größe und Farbe des Schildes zu bekommen '...Um einen Eindruck von verschiedenen Schildgrößen '...
                        'kommt jetzt eine kurze Übung.\n\n'...
                        'Die Position des letzten Balls wird dir wieder mit einem kleinen schwarzen Strich angezeigt.\n\n'...
                        'Außerdem wird die Position deines orangenen Punktes aus dem vorherigen Durchgang wieder mit '...
                        'einem orangenen Strich angezeigt.'], colRew, colNoRew);
                    
                    
                    feedback = false;
                    [fw, bw] = BigScreen(taskParam,...
                        taskParam.strings.txtPressEnter, header, txt, feedback);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 7; % go to case 2
                    end
                    WaitSecs(0.1);
                    
                    
                    
                case 10
                    condition = 'shield';
                    
                    PractLoop(taskParam, subject, taskParam.gParam.vola(2),taskParam.gParam.sigma(3), cannon, condition);
                    screenIndex = screenIndex + 1;
                    %%%%%%%
                    WaitSecs(0.1);
                    
                    
                case 11
                    % Intro about
                    
                    header = 'Gewinnmöglichkeiten';
                    txt = ['Um dir genau zu zeigen, wann du Geld verdienst, '...
                        'spielen wir jetzt alle Möglichkeiten durch.'];
                    
                    feedback = false;
                    [fw, bw] = BigScreen(taskParam,...
                        taskParam.strings.txtPressEnter, header, txt, feedback);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 2;
                    end
                    WaitSecs(0.1);
                    
                    
                case 12
                    
                    % Hands-on intro
                    txt=['Drücke LEERTASTE, damit die Kanone schießt.'];
                    distMean = 290;
                    outcome = 290;
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                        txt, cannon, 'space', distMean);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                        %elseif bw == 1
                        %    screenIndex = screenIndex - 1;
                    end
                    
                case 13
                    % Feedback that ball was caught
                    background = true;
                    Cannonball(taskParam, distMean, outcome, background)
                    LineAndBack(taskParam)
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, outcome);
                    Cannon(taskParam, distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    %while 1
                    
                    txt=['Nach dem Schuss erscheint dein Schild. '...
                        'Das Schild kannst du benutzen um die Kanonenkugel einzusammeln. '];
                    
                    LineAndBack(taskParam)
                    Cannon(taskParam, distMean)
                    DrawCircle(taskParam)
                    
                    if subject.rew == 1
                        Shield(taskParam, 20, Data.pred, 1)
                    elseif subject.rew == 2
                        Shield(taskParam, 20, Data.pred, 0)
                        
                    end
                    DrawOutcome(taskParam, outcome) %%TRIGGER
                    %DrawFormattedText(taskParam.gParam.window,txt,...
                    % taskParam.gParam.screensize(3)*0.1,...
                    % taskParam.gParam.screensize(4)*0.05,...
                    %[255 255 255], sentenceLength);
                    % DrawFormattedText(taskParam.gParam.window,...
                    %   taskParam.strings.txtPressEnter,'center',...
                    %    taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 1.6);
                    %  [ keyIsDown, ~, keyCode ] = KbCheck;
                    %                         if keyIsDown
                    %                             if keyCode(taskParam.keys.enter)
                    %                                 screenIndex = screenIndex + 1;
                    %                                 break
                    %                             elseif keyCode(taskParam.keys.delete)
                    %                                 screenIndex = screenIndex - 3; % go to case 2
                    %                                 break
                    %                             end
                    %                         end
                    %end
                    
                    
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 2.1, 1);
                    WaitSecs(1);
                    
                    screenIndex = screenIndex + 1;
                    
                case 14
                    
                    txt= 'Versuche die letzte Kanonenkugel jetzt wieder aufzusammeln (angezeigt durch den schwarzen Strich).';
                    
                    Data.distMean = 35;
                    Data.outcome = 290;
                    %Data.pred = 0;
                    Data.tickMark = true;
                    
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt,...
                        cannon, 'space', Data.distMean, Data);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                        %elseif bw == 1
                        %   screenIndex = screenIndex - 2;
                    end
                    WaitSecs(0.1);
                case 15
                    Data.distMean = 35;
                    Data.outcome = 35;
                    background = true;
                    Cannonball(taskParam, Data.distMean, Data.outcome, background)
                    
                    if Data.memErr >= 9
                        while 1
                            
                            txt=['Leider hast du die Kanonenkugel vefehlt. '...
                                'Versuche es noch einmal!'];
                            
                            LineAndBack(taskParam)
                            DrawCircle(taskParam);
                            DrawCross(taskParam);
                            PredictionSpot(taskParam);
                            DrawOutcome(taskParam, Data.outcome);
                            Cannon(taskParam, Data.distMean)
                            DrawPE_Bar(taskParam, Data, 1)
                            DrawFormattedText(taskParam.gParam.window,...
                                taskParam.strings.txtPressEnter,'center',...
                                taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                            DrawFormattedText(taskParam.gParam.window,txt,...
                                taskParam.gParam.screensize(3)*0.1,...
                                taskParam.gParam.screensize(4)*0.05,...
                                [255 255 255], sentenceLength);
                            Screen('DrawingFinished', taskParam.gParam.window);
                            t = GetSecs;
                            Screen('Flip', taskParam.gParam.window, t + 0.1);
                            
                            [ keyIsDown, ~, keyCode ] = KbCheck;
                            if keyIsDown
                                if keyCode(taskParam.keys.enter)
                                    screenIndex = screenIndex - 1;
                                    break
                                elseif keyCode(taskParam.keys.delete)
                                    screenIndex = screenIndex - 2; % go to case 11
                                    break
                                end
                            end
                        end
                    else
                        screenIndex = screenIndex + 1;
                    end
                    WaitSecs(0.1);
                case 16
                    LineAndBack(taskParam)
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, Data.outcome);
                    Cannon(taskParam, Data.distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        
                        
                        txt = sprintf(['Weil du die Kanonenkugel aufgesammelt '...
                            'hast und das Schild %s war, '...
                            'hättest du jetzt 20 CENT verdient.'], colRew);
                        
                        LineAndBack(taskParam)
                        Cannon(taskParam, Data.distMean)
                        DrawCircle(taskParam)
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 1)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 0)
                        end
                        DrawOutcome(taskParam, Data.outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.6);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex + 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 3; % go to case 11
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                    
                case 17
                    
                    
                    txt=['Versuche die Kanonenkugel bei nächsten Schuss '...         % miss the ball.
                        'zu verfehlen.'];
                    
                    Data.distMean = 190;
                    Data.outcome = 35;
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                        txt, cannon, 'space', Data.distMean, Data);
                    background = true;
                    Data.distMean = 190;
                    Data.outcome = 190;
                    Cannonball(taskParam, Data.distMean, Data.outcome, background)
                    if Data.memErr >= 9
                        screenIndex = screenIndex + 2;
                    else
                        screenIndex = screenIndex + 1;
                    end
                    WaitSecs(0.1);
                case 18
                    while 1
                        
                        txt=['Du hast die Kanonenkugel aufgesammelt. '...
                            'Versuche die Kanonenkugel diesmal extra nicht aufzusammeln!'];
                        
                        LineAndBack(taskParam)
                        DrawCircle(taskParam);
                        DrawCross(taskParam);
                        PredictionSpot(taskParam);
                        DrawOutcome(taskParam, Data.outcome);
                        Cannon(taskParam, Data.distMean)
                        DrawPE_Bar(taskParam, Data, 1)
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex - 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 5;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 19
                    LineAndBack(taskParam)                                      % ball was caught.
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, Data.outcome);
                    Cannon(taskParam, Data.distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        
                        txt=['Weil du die Kanonenkugel nicht aufgesammelt hast, '...
                            'hättest du nichts verdient.'];
                        
                        LineAndBack(taskParam)
                        Cannon(taskParam, Data.distMean)
                        DrawCircle(taskParam)
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 1)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 0)
                        end
                        DrawOutcome(taskParam, Data.outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.6);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex + 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 6;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 20
                    
                    txt='Versuche die Kanonenkugel jetzt wieder aufzusammeln.';
                    
                    Data.distMean = 160;
                    Data.outcome = 190;
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt,...
                        cannon, 'space', Data.distMean, Data);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 1;
                    end
                    WaitSecs(0.1);
                case 21
                    background = true;
                    Data.distMean = 160;
                    Data.outcome = 160;
                    Cannonball(taskParam, Data.distMean, Data.outcome, background)
                    if Data.memErr <= 9
                        screenIndex = screenIndex + 2;
                    else
                        screenIndex = screenIndex + 1;
                    end
                    WaitSecs(0.1);
                    
                case 22
                    while 1
                        
                        txt=['Leider hast du die Kanonenkugel nicht aufgesammelt. '...
                            'Versuche es noch einmal!'];
                        
                        LineAndBack(taskParam)
                        DrawCircle(taskParam);
                        DrawCross(taskParam);
                        PredictionSpot(taskParam);
                        DrawOutcome(taskParam, Data.outcome);
                        Cannon(taskParam, Data.distMean)
                        DrawPE_Bar(taskParam, Data, 1)
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex - 2;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 9;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 23
                    LineAndBack(taskParam)                                      % ball was caught.
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, Data.outcome);
                    Cannon(taskParam, Data.distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        
                        txt=sprintf(['Du hast die Kanonenkugel aufgesammelt, '...
                            'aber das Schild war %s. Daher hättest '...
                            'du nichts verdient.'], colNoRew);
                        
                        LineAndBack(taskParam)
                        Cannon(taskParam, Data.distMean)
                        DrawCircle(taskParam)
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 0)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 1)
                        end
                        DrawOutcome(taskParam, Data.outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.6);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex + 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 10;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 24                                                        % Try to
                    
                    txt=['Veruche die Kanonenkugel bei nächsten Schuss wieder '...  % miss the ball.
                        'extra nicht aufzusammeln.'];
                    
                    Data.distMean = 10;
                    Data.outcome = 160;
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt,...
                        cannon, 'space', Data.distMean, Data);                                                            % Simulate shoot.
                    Data.disMean = 10
                    Data.outcome = 10
                    background = true;
                    Cannonball(taskParam, Data.distMean, Data.outcome, background)
                    if Data.memErr >= 9
                        screenIndex = screenIndex + 2;
                    else
                        screenIndex = screenIndex + 1;
                    end
                    WaitSecs(0.1);
                case 25                                                             % Feedback.
                    while 1
                        
                        txt=['Du hast die Kanonenkugel aufgesammelt. '...
                            'Versuche die Kanonenkugel diesmal zu verpassen!'];
                        
                        LineAndBack(taskParam)
                        DrawCircle(taskParam);
                        DrawCross(taskParam);
                        PredictionSpot(taskParam);
                        DrawOutcome(taskParam, Data.outcome);
                        Cannon(taskParam, Data.distMean)
                        DrawPE_Bar(taskParam, Data, 1)
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex - 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 12;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 26
                    LineAndBack(taskParam)                                      % ball was caught.
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, Data.outcome);
                    Cannon(taskParam, Data.distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        
                        txt=['Weil du die Kanonenkugel nicht aufgesammelt hast, '...
                            'hättest du nichts verdient.'];
                        
                        LineAndBack(taskParam)
                        Cannon(taskParam, Data.distMean)
                        DrawCircle(taskParam)
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 0)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 1)
                        end
                        DrawOutcome(taskParam, Data.outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.6);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                if subject.cBal == 1
                                    screenIndex = screenIndex + 1;
                                    break
                                elseif subject.cBal == 2
                                    screenIndex = screenIndex + 1;
                                    break
                                end
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 13;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                    
                case 27
                    
                    header = 'Erste Übung';
                    
                    txt=['In dieser Übung ist das Ziel so viele Kanonenkugeln wie möglich aufzusammeln. '...         % noise.
                        'Du wirst feststellen, dass die Kanone relativ ungenau schießt, aber meistens auf die selbe Stelle zielt. '...
                        'Manchmal dreht sich die Kanone allerdings auch und zielt auf eine andere Stelle. '...
                        'Du verdienst am meisten, wenn du den organgenen Punkt GENAU '...
                        'auf den schwarzen Strich steuerst, weil du so sicher die Kugel aufsammelst. '...
                        '\n\nWenn du die Kugel zu oft nicht aufsammelst, '...
                        'wird die '...
                        'Übung wiederholt.'];
                    
                    
                    feedback = false;
                    [fw, bw] = BigScreen(taskParam, ...
                        taskParam.strings.txtPressEnter, header, txt, feedback);
                    if fw == 1
                        screenIndex = screenIndex + 1; % 3 war erst 2 sieht aber doppelt aus
                    end
                    %end
                    WaitSecs(0.1);
                    
                case 28                                                        % Show performance
                    
                    
                    
                    condition = 'practice';
                    [taskParam, practData] = PractLoop(taskParam,...
                        subject, taskParam.gParam.vola(3),...
                        taskParam.gParam.sigma(1), cannon, condition, 'Control_Practice');
                    
                    %                     hits = sum(practData.hit == 1);
                    %                     goldBall = sum(practData.boatType == 1);
                    %                     goldHit = practData.accPerf(end)/taskParam.gParam.rewMag;
                    %                     silverBall = sum(practData.boatType == 0);
                    %                     silverHit = hits - goldHit;
                    %                     maxMon = (length(find(practData.boatType == 1))...
                    %                         * taskParam.gParam.rewMag);
                    
                    [txt, header] = Feedback(practData, taskParam, subject, condition);
                    
                    %header = 'Leistung';
                    
                    %txt = sprintf(['Gefangene blaue Kugeln: %.0f von '...
                    %   '%.0f\n\nGefangene grüne Kugeln: %.0f von '...
                    %   '%.0f\n\n In diesem Block hättest du %.2f von '...
                    %  'maximal %.2f Euro gewonnen'], goldHit,...
                    % goldBall, silverHit, silverBall,...
                    %practData.accPerf(end), maxMon);
                    
                    feedback = true;
                    [fw, bw] = BigScreen(taskParam,...
                        taskParam.strings.txtPressEnter, header, txt,feedback);
                    sumCannonDev = sum(practData.cannonDev >= taskParam.gParam.catchTrialCriterion);
                    if fw == 1
                        if taskParam.gParam.oddball == true && subject.cBal == 2
                            screenIndex = screenIndex + 1;
                        else
                            screenIndex = screenIndex + 1;
                        end
                    elseif bw == 1
                        screenIndex = screenIndex - 1;
                    end
                    WaitSecs(0.1);
                    
                case 29
                    sumControlDev = sum(practData.controlDev >= 10);
                    if sumControlDev >= 4
                        
                        header = 'Wiederholung der Übung';
                        
                        txt = ['In der letzten Übung hast du dich zu häufig '...
                            'vom Ziel der Kanone wegbewegt. Du kannst '...
                            'mehr Kugeln fangen, wenn du immer auf dem Ziel '...
                            'der Kanone bleibst!\n\nIn der nächsten Runde '...
                            'kannst nochmal üben. Wenn du noch Fragen hast, '...
                            'kannst du dich auch an den Versuchsleiter wenden.'];
                        
                        feedback = false;
                        [fw, bw] = BigScreen(taskParam,...
                            taskParam.strings.txtPressEnter, header, txt,...
                            feedback);
                        if fw == 1
                            screenIndex = screenIndex - 1;
                        elseif bw == 1
                            screenIndex = screenIndex - 2;
                        end
                    else
                        screenIndex = screenIndex + 1;
                    end
                    
                    WaitSecs(0.1);
                    
                case 30
                    
                    %if taskParam.gParam.oddball == false
                    header = 'Zweite Übung';
                    txt = ['In dieser Übung bleibt alles gleich außer, dass du die Kanone jetzt nicht mehr sehen kannst. '...
                        'Anstelle der Kanone siehst du ab jetzt ein '...
                        'Kreuz und auch wo die Kanonenkugeln landen.\n\n'...
                        'Um weiterhin Kanonenkugeln aufsammeln zu können, '...
                        'musst du deinen Punkt einfach nur zum schwarzen '...
                        'Strich steuern.'];
                    
                    feedback = false;
                    [fw, bw] = BigScreen(taskParam,...
                        taskParam.strings.txtPressEnter, header, txt, feedback);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                        
                    elseif bw == 1
                        screenIndex = screenIndex - 3;
                    end
                    %end
                    WaitSecs(0.1);
                    
                case 31
                    break
                    
            end
        end
    end

    function MainAndOddballInstructions
        if (isequal(type, 'Oddball') && subject.cBal == 1) || ((isequal(type, 'Main')) && subject.cBal == 2) || ((isequal(type, 'Practice')) && subject.cBal == 1)
            screenIndex = 1;
        elseif isequal(type, 'Oddball') && subject.cBal == 2 || ((isequal(type, 'Main')) && subject.cBal == 1)
            screenIndex = 25;
            %elseif (isequal(type, 'Main')) && subject.cBal == 2
            %screenIndex = 1;
            %elseif (isequal(type, 'Main')) && subject.cBal == 1
            % screenIndex = 25;
        elseif (isequal(type, 'Practice')) && subject.cBal == 2
            screenIndex = 1;
        end
        
        %sentenceLength = taskParam.gParam.sentenceLength;
        
        while 1
            switch(screenIndex) % Endless loop for "go-back"
                case 1
                    % Intro screen
                    while 1
                        WaitSecs(0.1);
                        Screen('TextFont', taskParam.gParam.window, 'Arial');
                        Screen('TextSize', taskParam.gParam.window, 50);
                        txt='Deine Aufgabe: Kanonenkugeln fangen';
                        DrawFormattedText(taskParam.gParam.window, txt,...
                            'center', 100, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        [~, ~, keyCode] = KbCheck;
                        if find(keyCode) == taskParam.keys.enter
                            if (isequal(type, 'Practice')) && subject.cBal == 2 % is this right?
                                screenIndex = screenIndex + 1;
                            else
                                screenIndex = screenIndex + 1;
                            end
                            break
                        end
                    end
                    WaitSecs(0.1);
                case 2
                    Screen('TextSize', taskParam.gParam.window, 30);
                    if taskParam.gParam.oddball == false
                        txt=['Eine Kanone zielt auf eine Stelle des '...
                            'Kreises. Mit dem orangenen Punkt kannst du angeben, '...
                            'wo du dein Schild platzieren möchtest, um die '...
                            'Kanonenkugel abzufangen.\nDu kannst den Punk mit den '...
                            'grünen und gelben Tasten steuern. '...
                            'Grün kannst du für schnelle Bewegungen und '...
                            'gelb für langsame Bewegungen benutzen.'];
                    elseif taskParam.gParam.oddball == true
                        txt=['A cannon is aimed at the circle. Indicate where '...
                            'you would like to place your shield with the orange spot. '...
                            'You can move the orange spot with the green and yellow '...
                            'buttons. Green is for fast movements and yellow is '...
                            'for slow movements.'];
                    end
                    distMean = 0;
                    outcome = 0;
                    DrawFormattedText(taskParam.gParam.window,...
                        taskParam.strings.txtPressEnter,'center',...
                        taskParam.gParam.screensize(4)*0.9);
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                        txt, cannon, 'arrow', distMean);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 1; % go to case 1
                    end
                    WaitSecs(0.1);
                case 3
                    % Hands-on intro
                    if taskParam.gParam.oddball == false
                        txt=['Steuere den orangenen Punkt jetzt auf die Stelle, '...
                            'worauf die Kanone zielt und drücke LEERTASTE.'];
                    elseif taskParam.gParam.oddball == true
                        txt=['Move the orange spot to the part of the circle, '...
                            'where the cannon is aimed and press SPACE.'];
                    end
                    distMean = 290;
                    outcome = 290;
                    
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                        txt, cannon, 'space', distMean);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                        %elseif bw == 1
                        %    screenIndex = screenIndex - 1;
                    end
                case 4
                    background = true;
                    Cannonball(taskParam, distMean, outcome, background)
                    if Data.predErr >= 9
                        %while 1
                        if taskParam.gParam.oddball == false
                            txt=['Leider hast du die Kanonenkugel vefehlt. '...
                                'Versuche es noch einmal!'];
                        elseif taskParam.gParam.oddball == true
                            txt=['You missed the cannonball. '...
                                'Try it again!'];
                        end
                        LineAndBack(taskParam)
                        DrawCircle(taskParam);
                        DrawCross(taskParam);
                        PredictionSpot(taskParam);
                        DrawOutcome(taskParam, outcome);
                        Cannon(taskParam, distMean)
                        DrawPE_Bar(taskParam, Data, 1)
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        while 1
                            [ keyIsDown, ~, keyCode ] = KbCheck;
                            if keyIsDown
                                if keyCode(taskParam.keys.enter)
                                    screenIndex = screenIndex - 1;
                                    break
                                elseif keyCode(taskParam.keys.delete)
                                    screenIndex = screenIndex - 2; % go to case 2
                                    break
                                end
                            end
                        end
                    else
                        screenIndex = screenIndex +1;
                    end
                    WaitSecs(0.1);
                case 5
                    % Feedback that ball was caught
                    LineAndBack(taskParam)
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, outcome);
                    Cannon(taskParam, distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        if taskParam.gParam.oddball == false
                            txt=['Das Schild erscheint nach dem '...
                                'Schuss. In diesem Fall hast du die '...
                                'Kanonenkugel abgefangen. '...
                                'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, '...
                                'zählt es als Treffer.'];
                        elseif taskParam.gParam.oddball == true
                            txt=['After the cannon is shot you will see the shield. '...
                                'In this case you caught the ball. If at least half '...
                                'of the ball overlaps with the shield then it is a "catch".'];
                        end
                        LineAndBack(taskParam)
                        Cannon(taskParam, distMean)
                        DrawCircle(taskParam)
                        
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 1)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 0)
                            
                        end
                        DrawOutcome(taskParam, outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.6);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex + 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 3; % go to case 2
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 6
                    if taskParam.gParam.oddball == false
                        txt = ['Steuere den orangenen Punkt jetzt neben das Ziel der '...
                            'Kanone, so dass du die Kanonenkugel verfehlst '...
                            'und drücke LEERTASTE.'];
                        distMean = 35;
                        outcome = 35;
                    elseif taskParam.gParam.oddball == true
                        txt = ['Now try to place the shield so that you miss the '...
                            'cannonball. Then hit SPACE. '];
                        distMean = 35;
                        outcome = 35;
                    end
                    
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt,...
                        cannon, 'space', distMean);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    end
                    
                    WaitSecs(0.1);
                case 7
                    background = true;
                    Cannonball(taskParam, distMean, outcome, background)
                    if Data.predErr <=9
                        while 1
                            if taskParam.gParam.oddball == false
                                txt=['Du hast die Kanonenkugel abgefangen. '...
                                    'Versuche die Kanonenkugel diesmal zu verpassen!'];
                            elseif taskParam.gParam.oddball == true
                                txt=['You caught the cannonball. '...
                                    'Try to miss it!'];
                            end
                            LineAndBack(taskParam)
                            DrawCircle(taskParam);
                            DrawCross(taskParam);
                            PredictionSpot(taskParam);
                            DrawOutcome(taskParam, outcome);
                            Cannon(taskParam, distMean)
                            DrawPE_Bar(taskParam, Data, 1)
                            DrawFormattedText(taskParam.gParam.window,...
                                taskParam.strings.txtPressEnter,'center',...
                                taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                            DrawFormattedText(taskParam.gParam.window,txt,...
                                taskParam.gParam.screensize(3)*0.1,...
                                taskParam.gParam.screensize(4)*0.05,...
                                [255 255 255], sentenceLength);
                            Screen('DrawingFinished', taskParam.gParam.window);
                            t = GetSecs;
                            Screen('Flip', taskParam.gParam.window, t + 0.1);
                            [ keyIsDown, ~, keyCode ] = KbCheck;
                            if keyIsDown
                                if keyCode(taskParam.keys.enter)
                                    screenIndex = screenIndex - 1 ;
                                    break
                                elseif keyCode(taskParam.keys.delete)
                                    screenIndex = screenIndex - 5; % go to case 2
                                    break
                                end
                            end
                        end
                    else
                        if taskParam.gParam.oddball == false
                            txt=['Der schwarze Balken zeigt dir '...
                                'wie weit die Kanonenkugel von deinem '...
                                'Punkt entfernt war. Daraufhin siehst du dann...'];
                        elseif taskParam.gParam.oddball == true
                            txt=['Der schwarze Balken zeigt dir '...
                                'wie weit die Kanonenkugel von deinem '...
                                'Punkt entfernt war. Daraufhin siehst du dann...'];
                        end
                        LineAndBack(taskParam)
                        DrawCircle(taskParam);
                        DrawCross(taskParam);
                        PredictionSpot(taskParam);
                        DrawOutcome(taskParam, outcome);
                        Cannon(taskParam, distMean)
                        DrawPE_Bar(taskParam, Data, 1)
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        screenIndex = screenIndex + 1;
                    end
                    
                case 8
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        if taskParam.gParam.oddball == false
                            txt=['In '...
                                'diesem Fall hast du die Kanonenkugel verpasst.'];
                        elseif taskParam.gParam.oddball == true
                            txt=['In this case you missed the cannonball.'];
                        end
                        LineAndBack(taskParam)
                        Cannon(taskParam, distMean)
                        DrawCircle(taskParam)
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 1)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 0)
                        end
                        DrawOutcome(taskParam, outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.2);
                        
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex + 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 6; % go to case 2
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 9
                    if taskParam.gParam.oddball == false
                        header = 'Das Schild';
                        %                         if subject.rew == 1
                        %                             colRew = 'blau';
                        %                             colNoRew = 'grün';
                        %                         elseif subject.rew == 2
                        %                             colRew = 'grün';
                        %                             colNoRew = 'blau';
                        %                         end
                        txt = sprintf(['Wenn du Kanonenkugeln fängst, kannst du Geld verdienen. '...
                            'Wenn das Schild %s ist, verdienst du 20 CENT wenn du die Kanonenkugel fängst. '...
                            'Wenn das Schild %s ist, verdienst du nichts. '...
                            'Die Größe deines Schildes kann sich jedes Mal ändern. '...  % reward.
                            'Die Farbe und die Größe des Schildes kennst du erst, nachdem die Kanone geschossen hat. '...
                            'Daher versuchst du am besten jede Kanonenkugel zu fangen.\n\n'...
                            'Um einen Eindruck von der wechselnden Größe und Farbe des Schildes zu bekommen '...Um einen Eindruck von verschiedenen Schildgrößen '...
                            'kommt jetzt eine kurze Übung.\n\n'...
                            'Die Position des letzten Balls wird dir mit einem kleinen schwarzen Strich angezeigt.\n\n'...
                            'Außerdem wird die Position deines orangenen Punktes aus dem vorherigen Durchgang mit '...
                            'einem orangenen Strich angezeigt.'], colRew, colNoRew);
                    elseif taskParam.gParam.oddball == true
                        header = 'Your Shield';
                        if subject.rew == 1
                            colRew = 'blue';
                            colNoRew = 'green';
                        elseif subject.rew == 2
                            colRew = 'green';
                            colNoRew = 'blue';
                        end
                        txt = sprintf(['You can earn money by catching cannonballs in your '...  % reward.
                            'shield. If the shield is %s you will earn 20 CENTS for '...
                            'catching the ball. If the shield is %s you will not earn anything. '...
                            'On some trials the shield will be large and on some trials it will be small. '...
                            'You cannot know the SIZE or COLOR of the shield until the cannon is fired '...   % reward.
                            'so it is best to try to catch the ball on every trial.\n\n'...
                            'You will now have some practice to get a sense of how the color and size of '...
                            'the shield vary.\n\n'...
                            'The location of the ball fired on the previous trial will be marked with a black line.\n\n'...
                            'Moreover, the location of the orange spot from the previous trial will be marked with an orange line.'], colRew, colNoRew);
                    end
                    
                    feedback = false;
                    [fw, bw] = BigScreen(taskParam,...
                        taskParam.strings.txtPressEnter, header, txt, feedback);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 7; % go to case 2
                    end
                    WaitSecs(0.1);
                    
                case 10
                    condition = 'shield';
                    
                    PractLoop(taskParam, subject, taskParam.gParam.vola(3),taskParam.gParam.sigma(3), cannon, condition);
                    screenIndex = screenIndex + 1;
                    %%%%%%%
                    WaitSecs(0.1);
                case 11
                    % Intro about
                    if taskParam.gParam.oddball == false
                        header = 'Gewinnmöglichkeiten';
                        txt = ['Um dir genau zu zeigen, wann du Geld verdienst, '...
                            'spielen wir jetzt alle Möglichkeiten durch.'];
                    elseif taskParam.gParam.oddball == true
                        header = 'Trial Outcomes';
                        txt = sprintf(['Now lets see what happens when you hit '...
                            'or miss the ball with a %s or %s shield...'], colRew, colNoRew);
                    end
                    feedback = false;
                    [fw, bw] = BigScreen(taskParam,...
                        taskParam.strings.txtPressEnter, header, txt, feedback);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 2;
                    end
                    WaitSecs(0.1);
                case 12                                                              % Try to
                    if taskParam.gParam.oddball == false
                        txt='Versuche die Kanonenkugel jetzt wieder zu fangen.';      % miss the ball.
                    elseif taskParam.gParam.oddball == true
                        txt='Now try to catch the ball.';
                    end
                    distMean = 290;
                    outcome = 290;
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt,...
                        cannon, 'space', distMean);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                        %elseif bw == 1
                        %   screenIndex = screenIndex - 2;
                    end
                    WaitSecs(0.1);
                case 13
                    background = true;
                    Cannonball(taskParam, distMean, outcome, background)
                    if Data.predErr >= 9
                        while 1
                            if taskParam.gParam.oddball == false
                                txt=['Leider hast du die Kanonenkugel vefehlt. '...
                                    'Versuche es noch einmal!'];
                            elseif taskParam.gParam.oddball == true
                                txt=['Now you missed the ball. '...
                                    'Try to catch it!'];
                                
                            end
                            LineAndBack(taskParam)
                            DrawCircle(taskParam);
                            DrawCross(taskParam);
                            PredictionSpot(taskParam);
                            DrawOutcome(taskParam, outcome);
                            Cannon(taskParam, distMean)
                            DrawPE_Bar(taskParam, Data, 1)
                            DrawFormattedText(taskParam.gParam.window,...
                                taskParam.strings.txtPressEnter,'center',...
                                taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                            DrawFormattedText(taskParam.gParam.window,txt,...
                                taskParam.gParam.screensize(3)*0.1,...
                                taskParam.gParam.screensize(4)*0.05,...
                                [255 255 255], sentenceLength);
                            Screen('DrawingFinished', taskParam.gParam.window);
                            t = GetSecs;
                            Screen('Flip', taskParam.gParam.window, t + 0.1);
                            
                            [ keyIsDown, ~, keyCode ] = KbCheck;
                            if keyIsDown
                                if keyCode(taskParam.keys.enter)
                                    screenIndex = screenIndex - 1;
                                    break
                                elseif keyCode(taskParam.keys.delete)
                                    screenIndex = screenIndex - 2; % go to case 11
                                    break
                                end
                            end
                        end
                    else
                        screenIndex = screenIndex + 1;
                    end
                    WaitSecs(0.1);
                case 14
                    % Reward
                    LineAndBack(taskParam)                                      % ball was caught.
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, outcome);
                    Cannon(taskParam, distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        
                        if taskParam.gParam.oddball == false
                            txt = sprintf(['Weil du die Kanonenkugel gefangen '...
                                'hast und das Schild %s war, '...
                                'hättest du jetzt 20 CENT verdient.'], colRew);
                        elseif taskParam.gParam.oddball == true
                            txt = sprintf(['You caught the ball and the shield is %s. '...
                                'So you would earn 20 CENTS.'], colRew);
                        end
                        LineAndBack(taskParam)
                        Cannon(taskParam, distMean)
                        DrawCircle(taskParam)
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 1)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 0)
                        end
                        DrawOutcome(taskParam, outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.6);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex + 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 3; % go to case 11
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                    
                case 15                                                             % Try to
                    
                    if taskParam.gParam.oddball == false
                        txt=['Versuche die Kanonenkugel bei nächsten Schuss '...         % miss the ball.
                            'zu verfehlen.'];
                    elseif taskParam.gParam.oddball == true
                        txt=['Now try to miss the ball.'];
                    end
                    distMean = 35;
                    outcome = 35;
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                        txt, cannon, 'space', distMean);
                    background = true;
                    Cannonball(taskParam, distMean, outcome, background)
                    if Data.predErr >= 9
                        screenIndex = screenIndex + 2;
                    else
                        screenIndex = screenIndex + 1;
                    end
                    WaitSecs(0.1);
                case 16
                    while 1
                        if taskParam.gParam.oddball == false
                            txt=['Du hast die Kanonenkugel gefangen. '...
                                'Versuche die Kanonenkugel diesmal zu verpassen!'];
                        elseif taskParam.gParam.oddball == true
                            txt=['You caught the cannonball. '...
                                'Try to miss it!'];
                        end
                        LineAndBack(taskParam)
                        DrawCircle(taskParam);
                        DrawCross(taskParam);
                        PredictionSpot(taskParam);
                        DrawOutcome(taskParam, outcome);
                        Cannon(taskParam, distMean)
                        DrawPE_Bar(taskParam, Data, 1)
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex - 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 5;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 17
                    LineAndBack(taskParam)                                      % ball was caught.
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, outcome);
                    Cannon(taskParam, distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        if taskParam.gParam.oddball == false
                            txt=['Weil du die Kanonenkugel verpasst hast, '...
                                'hättest du nichts verdient.'];
                        elseif taskParam.gParam.oddball == true
                            txt=['You missed the ball so you would earn nothing.'];
                        end
                        LineAndBack(taskParam)
                        Cannon(taskParam, distMean)
                        DrawCircle(taskParam)
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 1)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 0)
                        end
                        DrawOutcome(taskParam, outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.6);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex + 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 6;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 18                                                             % Try to
                    if taskParam.gParam.oddball == false
                        txt='Versuche die Kanonenkugel jetzt wieder zu fangen.';        % catch the ball.
                    elseif taskParam.gParam.oddball == true
                        txt='Now try to catch the ball.';
                    end
                    distMean = 190;
                    outcome = 190;
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt,...
                        cannon, 'space', distMean);
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 1;
                    end
                    WaitSecs(0.1);
                case 19
                    background = true;
                    Cannonball(taskParam, distMean, outcome, background)
                    if Data.predErr <= 9
                        screenIndex = screenIndex + 2;
                    else
                        screenIndex = screenIndex + 1;
                    end
                    WaitSecs(0.1);
                    
                case 20
                    while 1
                        if taskParam.gParam.oddball == false
                            txt=['Leider hast du die Kanonenkugel vefehlt. '...
                                'Versuche es noch einmal!'];
                        elseif taskParam.gParam.oddball == true
                            txt=['You missed the ball. '...
                                'Try to catch it!'];
                        end
                        LineAndBack(taskParam)
                        DrawCircle(taskParam);
                        DrawCross(taskParam);
                        PredictionSpot(taskParam);
                        DrawOutcome(taskParam, outcome);
                        Cannon(taskParam, distMean)
                        DrawPE_Bar(taskParam, Data, 1)
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex - 2;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 9;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 21
                    LineAndBack(taskParam)                                      % ball was caught.
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, outcome);
                    Cannon(taskParam, distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        if taskParam.gParam.oddball == false
                            txt=sprintf(['Du hast die Kanonenkugel gefangen, '...
                                'aber das Schild war %s. Daher hättest '...
                                'du nichts verdient.'], colNoRew);
                        elseif taskParam.gParam.oddball == true
                            txt=sprintf(['You caught the ball and your shield was %s '...
                                'so you would earn nothing.'], colNoRew);
                        end
                        LineAndBack(taskParam)
                        Cannon(taskParam, distMean)
                        DrawCircle(taskParam)
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 0)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 1)
                        end
                        DrawOutcome(taskParam, outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.6);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex + 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 10;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 22                                                            % Try to
                    if taskParam.gParam.oddball == false
                        txt=['Veruche die Kanonenkugel bei nächsten Schuss wieder '...  % miss the ball.
                            'zu verfehlen.'];
                    elseif taskParam.gParam.oddball == true
                        txt=['Now try to miss the cannonball. '];
                    end
                    distMean = 160;
                    outcome = 160;
                    [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt,...
                        cannon, 'space', distMean);                                                            % Simulate shoot.
                    background = true;
                    Cannonball(taskParam, distMean, outcome, background)
                    if Data.predErr >= 9
                        screenIndex = screenIndex + 2;
                    else
                        screenIndex = screenIndex + 1;
                    end
                    WaitSecs(0.1);
                case 23                                                             % Feedback.
                    while 1
                        if taskParam.gParam.oddball == false
                            txt=['Du hast die Kanonenkugel gefangen. '...
                                'Versuche die Kanonenkugel diesmal zu verpassen!'];
                        elseif taskParam.gParam.oddball == true
                            txt=['You caught the cannonball. '...
                                'Try to miss it!'];
                        end
                        LineAndBack(taskParam)
                        DrawCircle(taskParam);
                        DrawCross(taskParam);
                        PredictionSpot(taskParam);
                        DrawOutcome(taskParam, outcome);
                        Cannon(taskParam, distMean)
                        DrawPE_Bar(taskParam, Data, 1)
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        Screen('DrawingFinished', taskParam.gParam.window);
                        t = GetSecs;
                        Screen('Flip', taskParam.gParam.window, t + 0.1);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                screenIndex = screenIndex - 1;
                                break
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 12;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                case 24
                    LineAndBack(taskParam)                                      % ball was caught.
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    DrawOutcome(taskParam, outcome);
                    Cannon(taskParam, distMean)
                    DrawPE_Bar(taskParam, Data, 1)
                    Screen('DrawingFinished', taskParam.gParam.window);
                    t = GetSecs;
                    Screen('Flip', taskParam.gParam.window, t + 0.1);
                    % Show baseline 1.
                    LineAndBack(taskParam)
                    DrawCross(taskParam)
                    DrawCircle(taskParam)
                    Screen('DrawingFinished', taskParam.gParam.window, 1);
                    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                    while 1
                        if taskParam.gParam.oddball == false
                            txt=['Weil du die Kanonenkugel verpasst hast, '...
                                'hättest du nichts verdient.'];
                        elseif taskParam.gParam.oddball == true
                            txt=['You missed the ball so you would earn nothing.'...
                                ];
                        end
                        LineAndBack(taskParam)
                        Cannon(taskParam, distMean)
                        DrawCircle(taskParam)
                        if subject.rew == 1
                            Shield(taskParam, 20, Data.pred, 0)
                        elseif subject.rew == 2
                            Shield(taskParam, 20, Data.pred, 1)
                        end
                        DrawOutcome(taskParam, outcome) %%TRIGGER
                        DrawFormattedText(taskParam.gParam.window,txt,...
                            taskParam.gParam.screensize(3)*0.1,...
                            taskParam.gParam.screensize(4)*0.05,...
                            [255 255 255], sentenceLength);
                        DrawFormattedText(taskParam.gParam.window,...
                            taskParam.strings.txtPressEnter,'center',...
                            taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                        Screen('DrawingFinished', taskParam.gParam.window, 1);
                        Screen('Flip', taskParam.gParam.window, t + 1.6);
                        [ keyIsDown, ~, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(taskParam.keys.enter)
                                if subject.cBal == 1
                                    screenIndex = screenIndex + 2;
                                    break
                                elseif subject.cBal == 2
                                    screenIndex = screenIndex + 2;
                                    break
                                end
                            elseif keyCode(taskParam.keys.delete)
                                screenIndex = screenIndex - 13;
                                break
                            end
                        end
                    end
                    WaitSecs(0.1);
                    
                case 25
                    if subject.cBal == 2 && isequal(type,'Main')
                        
                        screenIndex = screenIndex +1;
                        
                    else
                        header = 'Break';
                        txt = 'Now take a break\n\nTo continue press Enter';
                        feedback = true;
                        [fw, bw] = BigScreen(taskParam, ...
                            taskParam.strings.txtPressEnter, header, txt, feedback);
                        if fw == 1
                            screenIndex = screenIndex + 1;
                        end
                    end
                    WaitSecs(0.1);
                case 26
                    
                    if isequal(type, 'Oddball')
                        if taskParam.gParam.oddball == false
                            header = 'Erste Übung';
                            txt=['Weil die Kanone schon sehr alt ist, sind die '...         % noise.
                                'Schüsse ziemlich ungenau. Wenn du den orangenen Punkt '...
                                'GENAU auf die Stelle steuerst, auf die die Kanone '...
                                'zielt, fängst du die MEISTEN Kugeln. Durch die '...
                                'Ungenauigkeit der Kanone kann die Kugel aber manchmal '...
                                'auch ein Stück neben die anvisierte Stelle '...
                                'fliegen, wodurch du sie dann verpasst.\n\n'...
                                'In der nächsten Übung sollst du mit der '...
                                'Ungenauigkeit der Kanone erstmal vertraut werden. '...
                                'Lasse den orangenen Punkt bitte immer auf der '...
                                'anvisierten Stelle stehen. Wenn du deinen Punkt '...
                                'neben die anvisierte Stelle steuerst, wird die '...
                                'Übung wiederholt.'];
                        elseif taskParam.gParam.oddball == true
                            header = 'First Practice';
                            txt = ['In this block of trials you will try to catch '...         % noise.
                                'balls shot from a cannon. The aim of the cannon will not be '...
                                'stationary but instead move unpredictably.'...
                                ];
                        end
                        feedback = false;
                        [fw, bw] = BigScreen(taskParam, ...
                            taskParam.strings.txtPressEnter, header, txt, feedback);
                        if fw == 1
                            screenIndex = screenIndex + 1;
                        elseif bw == 1
                            screenIndex = screenIndex - 14;
                        end
                        WaitSecs(0.1);
                    elseif isequal(type, 'Main') || isequal(type, 'Practice')
                        if taskParam.gParam.oddball == false
                            header = 'Erste Übung';
                            %                     txt=['Weil die Kanone schon sehr alt ist, sind die '...         % noise.
                            %                         'Schüsse ziemlich ungenau. Wenn du den orangenen Punkt '...
                            %                         'GENAU auf die Stelle steuerst, auf die die Kanone '...
                            %                         'zielt, fängst du die MEISTEN Kugeln. Durch die '...
                            %                         'Ungenauigkeit der Kanone kann die Kugel aber manchmal '...
                            %                         'auch ein Stück neben die anvisierte Stelle '...
                            %                         'fliegen, wodurch du sie dann verpasst.\n\n'...
                            %                         'In der nächsten Übung sollst du mit der '...
                            %                         'Ungenauigkeit der Kanone erstmal vertraut werden. '...
                            %                         'Lasse den orangenen Punkt bitte immer auf der '...
                            %                         'anvisierten Stelle stehen. Wenn du deinen Punkt '...
                            %                         'neben die anvisierte Stelle steuerst, wird die '...
                            %                         'Übung wiederholt.'];
                            txt=['In dieser Übung ist das Ziel so viele Kanonenkugeln wie möglich zu fangen. '...         % noise.
                                'Die Kanone bleibt meistens an der selben Stelle. '...
                                'Manchmal dreht sich die Kanone allerdings und zielt auf eine andere Stelle. '...
                                'Wenn du den orangenen Punkt '...
                                'GENAU auf die Stelle steuerst, auf die die Kanone '...
                                'zielt, fängst du die MEISTEN Kugeln.\n\nWenn du deinen Punkt '...
                                'zu oft neben die anvisierte Stelle steuerst, wird die '...
                                'Übung wiederholt.'];
                        elseif taskParam.gParam.oddball == true
                            %header = 'Break';
                            %txt = 'Now take a break\n\nTo continue press Enter';
                            header = 'First Practice';
                            txt = ['You will now need to catch cannonballs shot '...
                                'from a cannon. The cannon will usually remain aimed '...
                                'at the same location. However, occasionally the cannon will be reaimed '...
                                'to a completely different part of the circle.\n\n'...
                                'To earn most money you should center your shield on the location '...
                                'at which the cannon is aimed.'...
                                ];
                        end
                        
                        feedback = false;
                        [fw, bw] = BigScreen(taskParam, ...
                            taskParam.strings.txtPressEnter, header, txt, feedback);
                        if fw == 1
                            screenIndex = screenIndex + 3; % war erst 2 sieht aber doppelt aus
                        end
                    end
                    WaitSecs(0.1);
                    
                case 27                                                          % Show performance
                    
                    %--------------
                    %
                    % Oddball
                    %
                    %--------------
                    
                    %if subject.cBal == '1'
                    
                    if taskParam.gParam.oddball == false
                        condition = 'practice';
                        [taskParam, practData] = PractLoop(taskParam,...
                            subject, taskParam.gParam.vola(3),...
                            taskParam.gParam.sigma(1), cannon, condition);
                    elseif taskParam.gParam.oddball == true
                        condition = 'practiceNoOddball';
                        [taskParam, practData] = PractLoop(taskParam,...
                            subject, taskParam.gParam.vola(3),...
                            taskParam.gParam.sigma(3), cannon, condition);
                    end
                    hits = sum(practData.hit == 1);
                    goldBall = sum(practData.boatType == 1);
                    goldHit = practData.accPerf(end)/taskParam.gParam.rewMag;
                    silverBall = sum(practData.boatType == 0);
                    silverHit = hits - goldHit;
                    maxMon = (length(find(practData.boatType == 1))...
                        * taskParam.gParam.rewMag);
                    if taskParam.gParam.oddball == false
                        header = 'Leistung';
                        
                        txt = sprintf(['Gefangene blaue Kugeln: %.0f von '...
                            '%.0f\n\nGefangene grüne Kugeln: %.0f von '...
                            '%.0f\n\n In diesem Block hättest du %.2f von '...
                            'maximal %.2f Euro gewonnen'], goldHit,...
                            goldBall, silverHit, silverBall,...
                            practData.accPerf(end), maxMon);
                    elseif taskParam.gParam.oddball == true
                        %                 header = 'Performance';
                        %                 if subject.rew == 1
                        %                     colRewCap = 'Blue';
                        %                     colNoRewCap = 'Green';
                        %                 elseif subject.rew == 2
                        %                     colRewCap = 'Green';
                        %                     colNoRewCap = 'Blue';
                        %                 end
                        %                 txt = sprintf(['%s shield catches: %.0f of '...
                        %                     '%.0f\n\n%s shield catches: %.0f of '...
                        %                     '%.0f\n\nIn this block you would have earned %.2f of '...
                        %                     'possible $ %.2f.'], colRewCap, goldHit,...
                        %                     goldBall, colNoRewCap, silverHit, silverBall,...
                        %                     practData.accPerf(end), maxMon);
                        
                        [txt, header] = Feedback(practData, taskParam, subject, condition);
                    end
                    feedback = true;
                    [fw, bw] = BigScreen(taskParam,...
                        taskParam.strings.txtPressEnter, header, txt,feedback);
                    sumCannonDev = sum(practData.cannonDev >= taskParam.gParam.catchTrialCriterion);
                    if fw == 1
                        if taskParam.gParam.oddball == true && subject.cBal == 2
                            screenIndex = screenIndex + 1;
                        else
                            screenIndex = screenIndex + 1;
                        end
                    elseif bw == 1
                        screenIndex = screenIndex - 1;
                    end
                    WaitSecs(0.1);
                    
                    
                    
                case 28
                    if (isequal(type, 'Oddball') && sumCannonDev >= 4) || (isequal(type, 'Practice') && sumCannonDev >= 4)
                        if taskParam.gParam.oddball == false
                            header = 'Wiederholung der Übung';
                            txt = ['In der letzten Übung hast du dich zu '...
                                'häufig vom Ziel der Kanone wegbewegt. Du '...
                                'kannst mehr Kugeln fangen, wenn du '...
                                'immer auf dem Ziel der Kanone bleibst!\n\n'...
                                'In der nächsten Runde kannst du nochmal üben. '...
                                'Wenn du noch Fragen hast, kannst du dich auch '...
                                'an den Versuchsleiter wenden.'];
                        elseif taskParam.gParam.oddball == true
                            header = 'Try it again!';
                            txt = ['In that block your shield was not always placed '...
                                'where the cannon was aiming. Remember: Placing your '...
                                'shield where the cannon is aimed will be the best way '...
                                'to earn money. '...
                                'Now try again. '...
                                ];
                        end
                        feedback = false;
                        [fw, bw] = BigScreen(taskParam,...
                            taskParam.strings.txtPressEnter, header, txt,...
                            feedback);
                        if fw == 1
                            screenIndex = screenIndex - 1;
                        elseif bw == 1
                            screenIndex = screenIndex - 2;
                        end
                    else
                        
                        %------------------
                        %
                        % Oddball
                        %
                        %------------------
                        if isequal(type, 'Oddball')
                            
                            if taskParam.gParam.oddball == false
                                header = 'Zweite Übung';
                                
                                txt = ['Gut gemacht! In der letzten Übung hast '...
                                    'du den orangenen Punkt auf die Stelle gesteuert, '...
                                    'auf die die Kanone gezielt hat und dadurch '...
                                    'viele Kugeln gefangen. Zusätzlich zu der '...
                                    'Ungenauigkeit der Kanone, wird die Kanone '...
                                    'in der nächsten Übung ab '...
                                    'und zu auf eine neue Stelle zielen. Wenn du '...
                                    'siehst, dass die Kanone auf eine neue Stelle '...
                                    'zielt, solltest du den orangenen Punkt auf das '...
                                    'neue Ziel der Kanone steuern.\n\nIm ersten '...
                                    'Block wird die Kanone nur selten auf eine '...
                                    'neue Stelle zielen. Im zweiten Block ändert '...
                                    'die Kanone ihr Ziel etwas häufiger. '...
                                    'Wenn du deinen Punkt zu oft neben die '...
                                    'anvisierte Stelle steuerst, muss die Übung '...
                                    'wiederholt werden.'];
                            elseif taskParam.gParam.oddball == true
                                header = 'Second Practice';
                                
                                txt = ['On some trials the ball will be fired '...
                                    'from a different cannon that you cannot see. '...
                                    'When this occurs the ball is equally likely '...
                                    'to land at any location on the circle. '...
                                    'However, these trials will be quite rare so your '...
                                    'best strategy is still to place the shield where '...
                                    'the cannon is aimed.\n\n'...
                                    'Press Enter to see an example of this.'];
                            end
                            feedback = false;
                            [fw, bw] = BigScreen(taskParam,...
                                taskParam.strings.txtPressEnter, header, txt,...
                                feedback);
                            if fw == 1
                                screenIndex = screenIndex + 1;
                            elseif bw == 1
                                screenIndex = screenIndex - 2;
                            end
                        elseif isequal(type, 'Main') || isequal(type, 'Practice')
                            
                            if taskParam.gParam.oddball == false
                                header = 'Zweite Übung';
                                
                                txt = ['Gut gemacht! In der letzten Übung hast '...
                                    'du den orangenen Punkt auf die Stelle gesteuert, '...
                                    'auf die die Kanone gezielt hat und dadurch '...
                                    'viele Kugeln gefangen. Zusätzlich zu der '...
                                    'Ungenauigkeit der Kanone, wird die Kanone '...
                                    'in der nächsten Übung ab '...
                                    'und zu auf eine neue Stelle zielen. Wenn du '...
                                    'siehst, dass die Kanone auf eine neue Stelle '...
                                    'zielt, solltest du den orangenen Punkt auf das '...
                                    'neue Ziel der Kanone steuern.\n\nIm ersten '...
                                    'Block wird die Kanone nur selten auf eine '...
                                    'neue Stelle zielen. Im zweiten Block ändert '...
                                    'die Kanone ihr Ziel etwas häufiger. '...
                                    'Wenn du deinen Punkt zu oft neben die '...
                                    'anvisierte Stelle steuerst, muss die Übung '...
                                    'wiederholt werden.'];
                            elseif taskParam.gParam.oddball == true
                                header = 'First Practice';
                                
                                txt = ['You will now need to catch cannonballs shot '...
                                    'from a cannon. The cannon will usually remain aimed '...
                                    'at the same location. However, occasionally the cannon will be reaimed '...
                                    'to a completely different part of the circle.\n\n'...
                                    'To earn most money you should center your shield on the location '...
                                    'at which the cannon is aimed.'...
                                    ''];
                            end
                            feedback = false;
                            [fw, bw] = BigScreen(taskParam,...
                                taskParam.strings.txtPressEnter, header, txt,...
                                feedback);
                            if fw == 1
                                screenIndex = screenIndex + 1;
                            elseif bw == 1
                                screenIndex = screenIndex - 2;
                            end
                        end
                    end
                    WaitSecs(0.1);
                    
                case 29                                                           % Show performance.
                    %------------------
                    %
                    % Oddball
                    %
                    %------------------
                    
                    if isequal(type, 'Oddball')
                        if taskParam.gParam.oddball == false
                            [taskParam, practData] = PractLoop(taskParam, subject,...
                                taskParam.gParam.vola(1), taskParam.gParam.sigma(1),...
                                cannon, condition);
                        elseif taskParam.gParam.oddball == true
                            txt=['Move the orange spot to the part of the circle, '...       % about how to
                                'where the cannon is aimed and press SPACE.'];
                            
                            distMean = 290;
                            outcome = 170;
                            [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                                txt, cannon, 'space', distMean);
                            LineAndBack(taskParam)                                      % ball was caught.
                            DrawCircle(taskParam);
                            DrawCross(taskParam);
                            PredictionSpot(taskParam);
                            DrawOutcome(taskParam, outcome);
                            Cannon(taskParam, distMean)
                            DrawPE_Bar(taskParam, Data, 1)
                            Screen('DrawingFinished', taskParam.gParam.window);
                            t = GetSecs;
                            Screen('Flip', taskParam.gParam.window, t + 0.1);
                            % Show baseline 1.
                            LineAndBack(taskParam)
                            DrawCross(taskParam)
                            DrawCircle(taskParam)
                            Screen('DrawingFinished', taskParam.gParam.window, 1);
                            Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
                            while 1
                                txt=['In this case the cannonball was shot from a different cannon that you cannot see. '...
                                    'Keep in mind that these trials will be quite rare so your best strategy is to '...
                                    'place your shield where the cannon that you can see is aimed. \n'...
                                    'Press enter to start the practice block.'];
                                LineAndBack(taskParam)
                                Cannon(taskParam, distMean)
                                DrawCircle(taskParam)
                                if subject.rew == 1
                                    Shield(taskParam, 20, Data.pred, 1)
                                elseif subject.rew == 2
                                    Shield(taskParam, 20, Data.pred, 0)
                                end
                                DrawOutcome(taskParam, outcome) %%TRIGGER
                                DrawFormattedText(taskParam.gParam.window,txt,...
                                    taskParam.gParam.screensize(3)*0.1,...
                                    taskParam.gParam.screensize(4)*0.05,...
                                    [255 255 255], sentenceLength);
                                DrawFormattedText(taskParam.gParam.window,...
                                    taskParam.strings.txtPressEnter,'center',...
                                    taskParam.gParam.screensize(4)*0.9, [255 255 255]);
                                Screen('DrawingFinished', taskParam.gParam.window, 1);
                                Screen('Flip', taskParam.gParam.window, t + 1.6);
                                [ keyIsDown, ~, keyCode ] = KbCheck;
                                if keyIsDown
                                    if keyCode(taskParam.keys.enter)
                                        screenIndex = screenIndex + 1;
                                        break
                                    elseif keyCode(taskParam.keys.delete)
                                        screenIndex = screenIndex - 3; % go to case 2
                                        break
                                    end
                                end
                            end
                            condition = 'practiceOddball';
                            LoadData = 'NoNoise';
                            [taskParam, practData] = PractLoop(taskParam, subject,...
                                taskParam.gParam.vola(3), taskParam.gParam.sigma(3),...
                                cannon, condition, LoadData);
                        end
                    elseif isequal(type, 'Main') || isequal(type, 'Practice') %% HHIIIEERR!!!
                        condition = 'practice';
                        LoadData = 'CP_NoNoise';
                        [taskParam, practData] = PractLoop(taskParam, subject,...
                            taskParam.gParam.vola(1), taskParam.gParam.sigma(3),...
                            cannon, condition, LoadData);
                    end
                    hits = sum(practData.hit == 1);
                    goldBall = sum(practData.boatType == 1);
                    goldHit = practData.accPerf(end)/taskParam.gParam.rewMag;
                    silverBall = sum(practData.boatType == 0);
                    silverHit = hits - goldHit;
                    maxMon = (length(find(practData.boatType == 1))...
                        * taskParam.gParam.rewMag);
                    if taskParam.gParam.oddball == false
                        [txt, header] = Feedback(practData, taskParam, subject, condition);
                        
                        
                        %                         header = 'Leistung';
                        %
                        %                         txt = sprintf(['Gefangene blaue Kugeln: %.0f von '...
                        %                             '%.0f\n\nGefangene grüne Kugeln: %.0f von '...
                        %                             '%.0f\n\n In diesem Block hättest du %.2f von '...
                        %                             'maximal %.2f Euro gewonnen'], goldHit,...
                        %                             goldBall, silverHit, silverBall,...
                        %                             practData.accPerf(end), maxMon);
                    elseif taskParam.gParam.oddball == true
                        %                 header = 'Performance';
                        %                 txt = sprintf(['%s shield catches: %.0f of '...
                        %                     '%.0f\n\n%s shield catches: %.0f of '...
                        %                     '%.0f\n\nIn this block you would have earned %.2f of '...
                        %                     'possible $ %.2f.'], colRewCap, goldHit,...
                        %                     goldBall, colNoRewCap, silverHit, silverBall,...
                        %                     practData.accPerf(end), maxMon);
                        [txt, header] = Feedback(practData, taskParam, subject, condition);
                    end
                    feedback = true;
                    [fw, bw] = BigScreen(taskParam,...
                        taskParam.strings.txtPressEnter, header, txt, feedback);
                    
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 1;
                    end
                    WaitSecs(0.1);
                case 30
                    sumCannonDev = sum(practData.cannonDev >= taskParam.gParam.catchTrialCriterion);
                    if sumCannonDev >= 4
                        
                        header = 'Wiederholung der Übung';
                        if taskParam.gParam.oddball == false
                            txt = ['In der letzten Übung hast du dich zu häufig '...
                                'vom Ziel der Kanone wegbewegt. Du kannst '...
                                'mehr Kugeln fangen, wenn du immer auf dem Ziel '...
                                'der Kanone bleibst!\n\nIn der nächsten Runde '...
                                'kannst nochmal üben. Wenn du noch Fragen hast, '...
                                'kannst du dich auch an den Versuchsleiter wenden.'];
                        elseif taskParam.gParam.oddball == true
                            header = 'Try it again!';
                            txt = ['In that block your shield was not always placed '...
                                'where the cannon was aiming. Remember: Placing your '...
                                'shield where the cannon is aimed will be the best way '...
                                'to earn money. '...
                                'Now try again. '...
                                ];
                        end
                        feedback = false;
                        [fw, bw] = BigScreen(taskParam,...
                            taskParam.strings.txtPressEnter, header, txt,...
                            feedback);
                        if fw == 1
                            screenIndex = screenIndex - 1;
                        elseif bw == 1
                            screenIndex = screenIndex - 2;
                        end
                        %screenIndex = screenIndex;
                    else
                        screenIndex = screenIndex + 1;
                    end
                    %             if subject.cBal == '2'
                    %                 if taskParam.gParam.runVola == false
                    %                     VolaIndication(taskParam,...
                    %                         taskParam.strings.txtHighVola,...
                    %                         taskParam.strings.txtPressEnter)
                    %                 else
                    %                     VolaIndication(taskParam,...
                    %                         taskParam.strings.txtHVHS,...
                    %                         taskParam.strings.txtPressEnter)
                    %                 end
                    %                 taskParam = PractLoop(taskParam, subject,...
                    %                     distMean(i), outcome(i), boatType(i), cannon);
                    %                 if taskParam.gParam.runVola == false
                    %                     VolaIndication(taskParam,...
                    %                         taskParam.strings.txtLowVola,...
                    %                         taskParam.strings.txtPressEnter)
                    %                 else
                    %                     VolaIndication(taskParam,...
                    %                         taskParam.strings.txtLVLS,...
                    %                         taskParam.strings.txtPressEnter)
                    %                 end
                    %                 taskParam = PractLoop(taskParam,...
                    %                     subject, distMean(i), outcome(i), boatType(i));
                    %             end
                    WaitSecs(0.1);
                case 31
                    
                    % Introduce
                    if isequal(type, 'Oddball')
                        
                        if taskParam.gParam.oddball == false
                            header = 'Erste Übung';
                            
                            txt=['Weil die Kanone schon sehr alt ist, sind die '...         % noise.
                                'Schüsse ziemlich ungenau. Wenn du den orangenen Punkt '...
                                'GENAU auf die Stelle steuerst, auf die die Kanone '...
                                'zielt, fängst du die MEISTEN Kugeln. Durch die '...
                                'Ungenauigkeit der Kanone kann die Kugel aber manchmal '...
                                'auch ein Stück neben die anvisierte Stelle '...
                                'fliegen, wodurch du sie dann verpasst.\n\n'...
                                'In der nächsten Übung sollst du mit der '...
                                'Ungenauigkeit der Kanone erstmal vertraut werden. '...
                                'Lasse den orangenen Punkt bitte immer auf der '...
                                'anvisierten Stelle stehen. Wenn du deinen Punkt '...
                                'neben die anvisierte Stelle steuerst, wird die '...
                                'Übung wiederholt.'];
                        elseif taskParam.gParam.oddball == true
                            header = 'Third Practice';
                            
                            txt = ['In this block you will encounter a cannon that is '...         % noise.
                                'not perfectly accurate. On some trials it might shoot '...
                                'a bit above where it is aimed and on other trials a bit '...
                                'below. Your best strategy is still to place the shield '...
                                'in the location where the cannon is aimed.\n\n'...
                                'The cannon will still move unpredictably and balls will still '...
                                'occasionally be shot by another randomly aimed cannon.'...
                                ];
                        end
                        feedback = false;
                        [fw, bw] = BigScreen(taskParam, ...
                            taskParam.strings.txtPressEnter, header, txt, feedback);
                        if fw == 1
                            screenIndex = screenIndex + 1;
                        elseif bw == 1
                            screenIndex = screenIndex - 3;
                        end
                        
                    elseif isequal(type, 'Main') || isequal(type, 'Practice')
                        
                        if taskParam.gParam.oddball == false
                            header = 'Zweite Übung';
                            
                            txt=['Weil die Kanone schon sehr alt ist, sind die '...         % noise.
                                'Schüsse ziemlich ungenau. Wenn du den orangenen Punkt '...
                                'GENAU auf die Stelle steuerst, auf die die Kanone '...
                                'zielt, fängst du die MEISTEN Kugeln. Durch die '...
                                'Ungenauigkeit der Kanone kann die Kugel aber manchmal '...
                                'auch ein Stück neben die anvisierte Stelle '...
                                'fliegen, wodurch du sie dann verpasst.\n\n'...
                                'In der nächsten Übung sollst du mit der '...
                                'Ungenauigkeit der Kanone erstmal vertraut werden. '...
                                'Lasse den orangenen Punkt bitte immer auf der '...
                                'anvisierten Stelle stehen. Wenn du deinen Punkt zu oft '...
                                'neben die anvisierte Stelle steuerst, wird die '...
                                'Übung wiederholt.'];
                        elseif taskParam.gParam.oddball == true
                            header = 'Second Practice';
                            
                            txt = ['In this block you will encounter a cannon that is '...         % noise.
                                'not perfectly accurate. On some trials it might shoot '...
                                'a bit above where it is aimed and on other trials a bit '...
                                'below. Your best strategy is still to place the shield '...
                                'in the location where the cannon is aimed.\n\n'...
                                'The cannon will still remain stable on most trials '...
                                'but be reaimed to another location on the circle occasionally.'...
                                ];
                        end
                        feedback = false;
                        [fw, bw] = BigScreen(taskParam, ...
                            taskParam.strings.txtPressEnter, header, txt, feedback);
                        if fw == 1
                            screenIndex = screenIndex + 1;
                        elseif bw == 1
                            screenIndex = screenIndex - 3;
                        end
                        
                    end
                    WaitSecs(0.1);
                case 32
                    % Show performance.
                    
                    %------------------
                    %
                    % Oddball
                    %
                    %------------------
                    
                    
                    if isequal(type, 'Oddball')
                        if taskParam.gParam.oddball == false
                            LoadOddballPracticeNoNoise = true;
                            [taskParam, practData] = PractLoop(taskParam, subject,...
                                taskParam.gParam.vola(1), taskParam.gParam.sigma(1),...
                                cannon, condition, LoadOddballPracticeNoNoise);
                        elseif taskParam.gParam.oddball == true
                            condition = 'practiceOddball';
                            LoadData = 'Noise';
                            [taskParam, practData] = PractLoop(taskParam, subject,...
                                taskParam.gParam.vola(3), taskParam.gParam.sigma(1),...
                                cannon, condition, LoadData);
                        end
                    elseif isequal(type, 'Main') || isequal(type, 'Practice')
                        LoadData = 'CP_Noise';
                        condition = 'practice';
                        [taskParam, practData] = PractLoop(taskParam, subject,...
                            taskParam.gParam.vola(1), taskParam.gParam.sigma(1),...
                            cannon, condition,LoadData);
                    end
                    hits = sum(practData.hit == 1);
                    goldBall = sum(practData.boatType == 1);
                    goldHit = practData.accPerf(end)/taskParam.gParam.rewMag;
                    silverBall = sum(practData.boatType == 0);
                    silverHit = hits - goldHit;
                    maxMon = (length(find(practData.boatType == 1))...
                        * taskParam.gParam.rewMag);
                    if taskParam.gParam.oddball == false
                        %                         header = 'Leistung';
                        %
                        %                         txt = sprintf(['Gefangene blaue Kugeln: %.0f von '...
                        %                             '%.0f\n\nGefangene grüne Kugeln: %.0f von '...
                        %                             '%.0f\n\n In diesem Block hättest du %.2f von '...
                        %                             'maximal %.2f Euro gewonnen'], goldHit,...
                        %                             goldBall, silverHit, silverBall,...
                        %                             practData.accPerf(end), maxMon);
                        [txt, header] = Feedback(practData, taskParam, subject, condition);
                        
                    elseif taskParam.gParam.oddball == true
                        %                 header = 'Performance';
                        %
                        %                txt = sprintf(['%s shield catches: %.0f of '...
                        %                     '%.0f\n\n%s shield catches: %.0f of '...
                        %                     '%.0f\n\nIn this block you would have earned %.2f of '...
                        %                     'possible $ %.2f.'], colRewCap, goldHit,...
                        %                     goldBall, colNoRewCap, silverHit, silverBall,...
                        %                     practData.accPerf(end), maxMon);
                        [txt, header] = Feedback(practData, taskParam, subject, condition);
                        
                    end
                    feedback = true;
                    [fw, bw] = BigScreen(taskParam,...
                        taskParam.strings.txtPressEnter, header, txt, feedback);
                    
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 1;
                    end
                    WaitSecs(0.1);
                case 33
                    sumCannonDev = sum(practData.cannonDev >= taskParam.gParam.catchTrialCriterion);
                    if sumCannonDev >= 4
                        if taskParam.gParam.oddball == false
                            header = 'Wiederholung der Übung';
                            txt = ['In der letzten Übung hast du dich zu häufig '...
                                'vom Ziel der Kanone wegbewegt. Du kannst '...
                                'mehr Kugeln fangen, wenn du immer auf dem Ziel '...
                                'der Kanone bleibst!\n\nIn der nächsten Runde '...
                                'kannst nochmal üben. Wenn du noch Fragen hast, '...
                                'kannst du dich auch an den Versuchsleiter wenden.'];
                        elseif taskParam.gParam.oddball == true
                            header = 'Try it again!';
                            txt = ['In that block your shield was not always placed '...
                                'where the cannon was aiming. Remember: Placing your '...
                                'shield where the cannon is aimed will be the best way '...
                                'to earn money. '...
                                'Now try again. '...
                                ];
                        end
                        feedback = false;
                        [fw, bw] = BigScreen(taskParam,...
                            taskParam.strings.txtPressEnter, header, txt,...
                            feedback);
                        if fw == 1
                            screenIndex = screenIndex - 1;
                        elseif bw == 1
                            screenIndex = screenIndex - 2;
                        end
                        %screenIndex = screenIndex;
                    else
                        screenIndex = screenIndex + 1;
                    end
                    %             if subject.cBal == '2'
                    %                 if taskParam.gParam.runVola == false
                    %                     VolaIndication(taskParam,...
                    %                         taskParam.strings.txtHighVola,...
                    %                         taskParam.strings.txtPressEnter)
                    %                 else
                    %                     VolaIndication(taskParam,...
                    %                         taskParam.strings.txtHVHS,...
                    %                         taskParam.strings.txtPressEnter)
                    %                 end
                    %                 taskParam = PractLoop(taskParam, subject,...
                    %                     distMean(i), outcome(i), boatType(i), cannon);
                    %                 if taskParam.gParam.runVola == false
                    %                     VolaIndication(taskParam,...
                    %                         taskParam.strings.txtLowVola,...
                    %                         taskParam.strings.txtPressEnter)
                    %                 else
                    %                     VolaIndication(taskParam,...
                    %                         taskParam.strings.txtLVLS,...
                    %                         taskParam.strings.txtPressEnter)
                    %                 end
                    %                 taskParam = PractLoop(taskParam,...
                    %                     subject, distMean(i), outcome(i), boatType(i));
                    %             end
                    WaitSecs(0.1);
                case 34                                                            % End of intro
                    if isequal(type, 'Oddball')
                        if taskParam.gParam.oddball == false
                            header = 'Ende der zweiten Übung';
                            txt = ['Ok, bis jetzt kanntest du das Ziel der Kanone '...
                                'und du konntest die meisten Kugeln abfangen. '...
                                'Im nächsten Übungsdurchgang wird die Kanone nicht mehr sichtbar '...
                                'sein. Anstelle der Kanone siehst du ab jetzt ein '...
                                'Kreuz und auch wo die Kanonenkugeln landen.\n\n'...
                                'Um weiterhin viele Kanonenkugeln fangen zu können, '...
                                'musst du aufgrund der Landeposition einschätzen, auf '...
                                'welche Stelle die Kanone zielt und den orangenen Punkt '...
                                'auf diese Position steuern. Wenn du denkst, dass die '...
                                'Kanone auf eine neue Stelle zielt, solltest du auch '...
                                'den orangenen Punkt dort hin bewegen.'];
                        elseif taskParam.gParam.oddball == true
                            header = 'Fourth Practice';
                            txt = ['In this block everything will be exactly the '...
                                'same except that you will no longer see the cannon. '...
                                'The cannon is still aiming and shooting exactly as before. '...
                                'You will be paid for catching balls exactly as before. '...
                                'But now you must place your shield at the position where you '...
                                'think the cannon is aimed.\n\n'...
                                'Since you will still see each ball shot from the cannon, '...
                                'you will be able to use the locations of past shots to inform your decision.'];
                            
                        end
                        feedback = false;
                        [fw, bw] = BigScreen(taskParam,...
                            taskParam.strings.txtPressEnter, header, txt, feedback);
                        if fw == 1
                            screenIndex = screenIndex + 1;
                            
                        elseif bw == 1
                            screenIndex = screenIndex - 3;
                        end
                    elseif isequal(type, 'Main') || isequal(type, 'Practice')
                        if taskParam.gParam.oddball == false
                            header = 'Dritte Übung';
                            txt = ['Ok, bis jetzt kanntest du das Ziel der Kanone '...
                                'und du konntest die meisten Kugeln abfangen. '...
                                'Im nächsten Übungsdurchgang wird die Kanone nicht mehr sichtbar sein. '...
                                'Anstelle der Kanone siehst du ab jetzt ein '...
                                'Kreuz und auch wo die Kanonenkugeln landen.\n\n'...
                                'Um weiterhin viele Kanonenkugeln fangen zu können, '...
                                'musst du aufgrund der Landeposition einschätzen, auf '...
                                'welche Stelle die Kanone zielt und den orangenen Punkt '...
                                'auf diese Position steuern. Wenn du denkst, dass die '...
                                'Kanone auf eine neue Stelle zielt, solltest du auch '...
                                'den orangenen Punkt dort hin bewegen.'];
                        elseif taskParam.gParam.oddball == true
                            header = 'Third Practice';
                            txt = ['In this block everything will be exactly the '...
                                'same except that you will no longer see the cannon. '...
                                'The cannon is still aiming and shooting exactly as before. '...
                                'You will be paid for catching balls exactly as before. '...
                                'But now you must place your shield at the position where you '...
                                'think the cannon is aimed.\n\n'...
                                'Since you will still see each ball shot from the cannon, '...
                                'you will be able to use the locations of past shots to inform your decision.'];
                        end
                        feedback = false;
                        [fw, bw] = BigScreen(taskParam,...
                            taskParam.strings.txtPressEnter, header, txt, feedback);
                        if fw == 1
                            screenIndex = screenIndex + 1;
                            
                        elseif bw == 1
                            screenIndex = screenIndex - 3;
                        end
                    end
                    WaitSecs(0.1);
                    %         case 35
                    %             Screen('TextSize', taskParam.gParam.window, 30);
                    %             if taskParam.gParam.oddball == false && subject.cBal == 1
                    %                 txt=['Eine Kanone zielt auf eine Stelle des '...
                    %                     'Kreises. Mit dem orangenen Punkt kannst du angeben, '...
                    %                     'wo du dein Schild platzieren möchtest, um die '...
                    %                     'Kanonenkugel abzufangen.\nDu kannst den Punk mit den '...
                    %                     'grünen und gelben Tasten steuern. '...
                    %                     'Grün kannst du für schnelle Bewegungen und '...
                    %                     'gelb für langsame Bewegungen benutzen.'];
                    %             elseif taskParam.gParam.oddball == true
                    %                 txt=['A cannon is aimed at the circle. Indicate where '...
                    %                     'you would like to place your shield with the orange spot. '...
                    %                     'You can move the orange spot with the green and yellow '...
                    %                     'buttons. Green is for fast movements and yellow is '...
                    %                     'for slow movements.'];
                    %             else
                    %                 txt=['Eine Kanone schießt auf eine Stelle des '...
                    %                     'Kreises. Mit dem orangenen Punkt kannst du angeben, '...
                    %                     'wo du dein Schild platzieren möchtest, um die '...
                    %                     'Kanonenkugel nach dem Schuss einzusammel.\nDu kannst den Punk mit den '...
                    %                     'grünen und gelben Tasten steuern. '...
                    %                     'Grün kannst du für schnelle Bewegungen und '...
                    %                     'gelb für langsame Bewegungen benutzen.'];
                    %             end
                    %             distMean = 0;
                    %             outcome = 0;
                    %             DrawFormattedText(taskParam.gParam.window,...
                    %                 taskParam.strings.txtPressEnter,'center',...
                    %                 taskParam.gParam.screensize(4)*0.9);
                    %             [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                    %                 txt, cannon, 'arrow', distMean);
                    %             if fw == 1
                    %                 screenIndex = screenIndex + 1;
                    %             elseif bw == 1
                    %                 screenIndex = screenIndex - 1; % go to case 1
                    %             end
                    %             WaitSecs(0.1);
                    %         case 36
                    %             keyboard
                    %             % Hands-on intro
                    %             if taskParam.gParam.oddball == false
                    %                 txt=['Drücke LEERTASTE sodass die Kanone einen Schuss abgibt.'];
                    %             end
                    %             distMean = 290;
                    %             outcome = 290;
                    %             [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
                    %                 txt, cannon, 'space', distMean);
                    %             if fw == 1
                    %                 screenIndex = screenIndex + 1;
                    %             end
                case 35                                                             % Break out of loop.
                    break
            end
        end
        
    end
end
