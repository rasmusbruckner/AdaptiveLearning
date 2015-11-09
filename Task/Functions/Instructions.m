function Instructions(taskParam, whichPractice, subject)

cannon = true;

Screen('TextFont', taskParam.gParam.window, 'Arial');
Screen('TextSize', taskParam.gParam.window, 50);
sentenceLength = taskParam.gParam.sentenceLength;
if subject.rew == 1
    colRew = 'gold';
    colNoRew = 'grau';
elseif subject.rew == 2
    colRew = 'silber';
    colNoRew = 'gelb';
end

DisplayPartOfTask

if isequal(whichPractice, 'oddballPractice')...
        || (isequal(whichPractice, 'mainPractice') && subject.cBal == 1)...
        || (isequal(whichPractice, 'mainPractice') && subject.cBal == 2)...
        || (isequal(whichPractice, 'mainPractice') && subject.cBal == 3)...
        || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 4)...
        || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5)...
        || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 6)
    SharedInstructions_MainOddballFollowCannon
elseif isequal(whichPractice, 'oddballPractice')...
        || (isequal(whichPractice, 'mainPractice') && subject.cBal == 4)...
        || (isequal(whichPractice, 'mainPractice') && subject.cBal == 5)...
        || (isequal(whichPractice, 'mainPractice') && subject.cBal == 6)
    MainJustInstructions
elseif isequal(whichPractice, 'oddballPractice')...
        || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 1)...
        || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 2)...
        || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 3)
    FollowCannonJustInstructions
elseif isequal(whichPractice, 'followOutcomePractice')
    FollowOutcomeInstructions
end

% kind of done
    function DisplayPartOfTask
        
        Screen('TextFont', taskParam.gParam.window, 'Arial');
        Screen('TextSize', taskParam.gParam.window, 30);
        
        %if ~taskParam.gParam.allThreeConditions
        
        %             if (isequal(whichPractice, 'mainPractice') && subject.cBal == 1) || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 2)
        %                 txt='Herzlich Willkommen\n\nErster Teil...';
        %             else
        %                 txt = 'Zweiter Teil...';
        %             end
        
        %elseif taskParam.gParam.allThreeConditions
        
        if taskParam.gParam.oddball == false
            
            if (isequal(whichPractice, 'mainPractice') && subject.cBal == 1)...
                    || (isequal(whichPractice, 'mainPractice') && subject.cBal == 2)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 3)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 5)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 4)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 6)
                txt='Herzlich Willkommen\n\nErste Aufgabe...';
            elseif (isequal(whichPractice, 'mainPractice') && subject.cBal == 3)...
                    || (isequal(whichPractice, 'mainPractice') && subject.cBal == 4)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 1)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 6)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 2)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5)
                txt = 'Zweite Aufgabe...';
            elseif (isequal(whichPractice, 'mainPractice') && subject.cBal == 5)...
                    || (isequal(whichPractice, 'mainPractice') && subject.cBal == 6)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 2)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 4)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 1)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 3)
                txt = 'Dritte Aufgabe...';
            end
            
        else
            
            if (isequal(whichPractice, 'mainPractice') && subject.cBal == 1)...
                    || (isequal(whichPractice, 'oddballPractice') && subject.cBal == 2)
                txt = 'Welcome\n\nFirst Task...';
            elseif (isequal(whichPractice, 'oddballPractice') && subject.cBal == 1)...
                    || (isequal(whichPractice, 'mainPractice') && subject.cBal == 2)
                txt = 'Second Task...';
            end
            
        end
        
        %end
        
        while 1
            
            Screen('FillRect', taskParam.gParam.window, []);
            DrawFormattedText(taskParam.gParam.window, txt,...
                'center', 100, [0 0 0]);
            
            
            %Screen('DrawTexture', taskParam.gParam.window, taskParam.textures.shieldTxt,[], taskParam.textures.dstRect)%, 'center', [], [0], [0 0 0], [], []);  %Boat
            %Screen('DrawTexture', taskParam.gParam.window, taskParam.textures.basketTxt,[], taskParam.textures.dstRect)%, 'center', [], [0], [0 0 0], [], []);  %Boat
            
            
            Screen('DrawingFinished', taskParam.gParam.window);
            
            
            t = GetSecs;
            Screen('Flip', taskParam.gParam.window, t + 0.1);
            [~, ~, keyCode] = KbCheck;
            
            if find(keyCode) == taskParam.keys.enter
                break
            end
        end
        
        WaitSecs(0.1);
    end

% kind of done
    function SharedInstructions_MainOddballFollowCannon
        
        screenIndex = 1;
        
        while 1
            
            switch(screenIndex)
                
                case 1
                    
                    if taskParam.gParam.oddball == false
                        txt = 'Kanonenkugeln Abwehren';
                    else
                        txt = 'First Task';
                    end
                    screenIndex = YourTaskScreen(txt,...
                        taskParam.textures.shieldTxt, screenIndex);
                    
                case 2
                    
                    screenIndex = FirstCannonSlide(screenIndex);
                    
                case 3
                    
                    [screenIndex, Data] = PressSpaceToInitiateCannonShot(screenIndex, true);
                    WaitSecs(0.1);
                    
                case 4
                    distMean = 290; % das nicht!!!!
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            txt=['Der schwarze Strich zeigt dir die Position der letzten Kugel. '...
                                'Der orangene Strich zeigt dir die Position deines letzten Schildes. Steuere '...
                                'den orangenen Punkt jetzt auf das Ziel '...
                                'der Kanone und drücke LEERTASTE.'];
                        else
                            txt=['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. '...
                                'Der orangene Strich zeigt Ihnen die Position Ihres letzten Schildes. Steuern '...
                                'Sie den orangenen Punkt jetzt bitte auf das Ziel '...
                                'der Kanone und drücken Sie LEERTASTE.'];
                        end
                    elseif taskParam.gParam.oddball == true
                        txt=['Move the orange spot to the part of the circle, '...
                            'where the cannon is aimed and press SPACE.'];
                    end
                    [screenIndex, Data] = MoveSpotToCannonAim(screenIndex, txt, distMean, Data);
                    
                case 5
                    
                    distMean = 290; %% das macht nichts
                    screenIndex = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
                    
                case 6
                    
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            txt=['Das Schild erscheint nach dem '...
                                'Schuss. In diesem Fall hast du die '...
                                'Kanonenkugel abgewehrt. '...
                                'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, '...
                                'zählt es als Treffer.'];
                        else
                            txt=['Das Schild erscheint nach dem '...
                                'Schuss. In diesem Fall haben Sie die '...
                                'Kanonenkugel abgewehrt. '...
                                'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, '...
                                'zählt es als Treffer.'];
                        end
                    elseif taskParam.gParam.oddball == true
                        txt=['After the cannon is shot you will see the shield. '...
                            'In this case you caught the ball. If at least half '...
                            'of the ball overlaps with the shield then it is a "catch".'];
                    end
                    win = true;
                    [screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, txt, distMean, win);
                    
                case 7
                    
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            txt = ['Steuere den orangenen Punkt jetzt neben das Ziel der '...
                                'Kanone, so dass du die Kanonenkugel verfehlst '...
                                'und drücke LEERTASTE.'];
                        else
                            txt = ['Steuern Sie den orangenen Punkt jetzt bitte neben das Ziel der '...
                                'Kanone, so dass Sie die Kanonenkugel verfehlen '...
                                'und drücken Sie LEERTASTE.'];
                        end
                        
                    elseif taskParam.gParam.oddball == true
                        txt = ['Now try to place the shield so that you miss the '...
                            'cannonball. Then hit SPACE. '];
                        
                    end
                    distMean = 35;
                    [screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, txt, distMean);
                    
                case 8
                    Data.outcome = distMean;
                    [screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
                    
                case 9
                    
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            txt=['In diesem Fall hast du die Kanonenkugel verpasst.'];
                        else
                            txt=['In diesem Fall haben Sie die Kanonenkugel verpasst.'];
                            
                        end
                    elseif taskParam.gParam.oddball == true
                        txt=['In this case you missed the cannonball.'];
                    end
                    win = true;
                    [screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, txt, distMean, win);
                    
                case 10
                    if isequal(subject.group, '1')
                        txt = sprintf(['Wenn du Kanonenkugeln abwehrst, '...
                            'kannst du Geld verdienen. Wenn das Schild '...
                            '%s ist, verdienst du %s CENT wenn du die '...
                            'Kanonenkugel abwehrst. Wenn das Schild %s '...
                            'ist, verdienst du nichts. Ebenso wie die '...
                            'Farbe, kann auch die Größe deines '...
                            'Schildes variieren. '...
                            'Die Farbe und die Größe des Schildes siehst '...
                            'du erst, nachdem die Kanone geschossen hat. '...
                            'Daher versuchst du am besten jede '...
                            'Kanonenkugel abzuwehren.\n\n'...
                            'Um einen Eindruck von der wechselnden Größe '...
                            'und Farbe des Schildes zu bekommen, '...
                            'kommt jetzt eine kurze Übung.\n\n'], colRew, num2str(100*taskParam.gParam.rewMag), colNoRew);
                    else
                        txt = sprintf(['Wenn Sie Kanonenkugeln abwehren, '...
                            'können Sie Geld verdienen. Wenn das Schild '...
                            '%s ist, verdienen Sie %s CENT wenn Sie die '...
                            'Kanonenkugel abwehren. Wenn das Schild %s '...
                            'ist, verdienen Sie nichts. Ebenso wie die '...
                            'Farbe, kann auch die Größe Ihres '...
                            'Schildes variieren. '...
                            'Die Farbe und die Größe des Schildes sehen '...
                            'Sie erst, nachdem die Kanone geschossen hat. '...
                            'Daher versuchen Sie am besten jede '...
                            'Kanonenkugel abzuwehren.\n\n'...
                            'Um einen Eindruck von der wechselnden Größe '...
                            'und Farbe des Schildes zu bekommen, '...
                            'kommt jetzt eine kurze Übung.\n\n'], colRew, num2str(100*taskParam.gParam.rewMag), colNoRew);
                    end
                    [screenIndex, Data] = YourShield(screenIndex, Data, txt);
                    
                case 11
                    
                    [screenIndex, Data] = ShieldPractice(screenIndex, whichPractice);
                    
                case 12
                    
                    screenIndex = TrialOutcomes(screenIndex);
                    
                case 13
                    
                    distMean = 290;
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            txt='Versuche die Kanonenkugel jetzt wieder zu abzuwehren.';
                        else
                            txt='Versuchen Sie die Kanonenkugel jetzt wieder zu abzuwehren.';
                        end
                    elseif taskParam.gParam.oddball == true
                        txt='Now try to catch the ball.';
                    end
                    
                    [screenIndex, Data] = MoveSpotToCannonAim(screenIndex, txt, distMean, Data);
                    
                case 14
                    
                    [screenIndex, Data] = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
                    
                case 15
                    
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            if isequal(whichPractice, 'followOutcome')
                                txt = sprintf(['Weil du die Kanonenkugel abgewehrt '...
                                    'hast und der Korb %s war, '...
                                    'hättest du jetzt %s CENT verdient.'], colRew, num2str(100*taskParam.gParam.rewMag));
                            else
                                txt = sprintf(['Weil du die Kanonenkugel abgewehrt '...
                                    'hast und das Schild %s war, '...
                                    'hättest du jetzt %s CENT verdient.'], colRew, num2str(100*taskParam.gParam.rewMag));
                            end
                        else
                            if isequal(whichPractice, 'followOutcome')
                                txt = sprintf(['Weil Sie die Kanonenkugel abgewehrt '...
                                    'haben und der Korb %s war, '...
                                    'hätten Sie jetzt %s CENT verdient.'], colRew, num2str(100*taskParam.gParam.rewMag));
                            else
                                txt = sprintf(['Weil Sie die Kanonenkugel abgewehrt '...
                                    'haben und das Schild %s war, '...
                                    'hätten Sie jetzt %s CENT verdient.'], colRew, num2str(100*taskParam.gParam.rewMag));
                            end
                        end
                    elseif taskParam.gParam.oddball == true
                        txt = sprintf(['You caught the ball and the shield is %s. '...
                            'So you would earn %s CENTS.'], colRew, num2str(100*taskParam.gParam.rewMag));
                    end
                    
                    win = true;
                    [screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, txt, distMean, win);
                    
                case 16
                    
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            txt=['Versuche die Kanonenkugel beim nächsten Schuss '...
                                'zu verfehlen.'];
                        else
                            txt=['Versuchen Sie die Kanonenkugel bitte beim nächsten Schuss '...
                                'zu verfehlen.'];
                        end
                    elseif taskParam.gParam.oddball == true
                        txt=['Now try to miss the ball.'];
                    end
                    distMean = 35;
                    [screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, txt, distMean);
                    
                case 17
                    
                    Data.outcome = distMean;
                    [screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
                    
                case 18
                    
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            
                            txt=['Weil du die Kanonenkugel verpasst hast, '...
                                'hättest du nichts verdient.'];
                        else
                            txt=['Weil Sie die Kanonenkugel verpasst haben, '...
                                'hätten Sie nichts verdient.'];
                        end
                    elseif taskParam.gParam.oddball == true
                        txt=['You missed the ball so you would earn nothing.'];
                    end
                    win = true;
                    
                    [screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, txt, distMean, win);
                    
                case 19
                    
                    distMean = 190;
                    
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            
                            txt='Versuche die Kanonenkugel jetzt wieder zu abzuwehren.';
                        else
                            txt='Versuchen Sie bitte die Kanonenkugel wieder zu abzuwehren.';
                            
                        end
                    elseif taskParam.gParam.oddball == true
                        txt='Now try to catch the ball.';
                    end
                    
                    [screenIndex, Data] = MoveSpotToCannonAim(screenIndex, txt, distMean, Data);
                    
                case 20
                    
                    screenIndex = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean);
                    
                case 21
                    
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            
                            
                            txt=sprintf(['Du hast die Kanonenkugel abgewehrt, '...
                                'aber das Schild war %s. Daher hättest '...
                                'du nichts verdient.'], colNoRew);
                            
                        else
                            
                            txt=sprintf(['Sie haben die Kanonenkugel abgewehrt, '...
                                'aber das Schild war %s. Daher hätten '...
                                'Sie nichts verdient.'], colNoRew);
                            
                        end
                    elseif taskParam.gParam.oddball == true
                        txt=sprintf(['You caught the ball and your shield was %s '...
                            'so you would earn nothing.'], colNoRew);
                    end
                    
                    
                    win = false;
                    [screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, txt, distMean, win);
                    
                case 22
                    Data.outcome = distMean;
                    distMean = 160;
                    
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            
                            txt=['Versuche die Kanonenkugel bei nächsten Schuss '...
                                'zu verfehlen.'];
                        else
                            txt=['Versuchen Sie bitte die Kanonenkugel bei nächsten Schuss '...
                                'zu verfehlen.'];
                        end
                    elseif taskParam.gParam.oddball == true
                        txt=['Now try to miss the ball.'];
                    end
                    [screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, txt, distMean);
                    
                case 23
                    
                    distMean = 160;
                    Data.outcome = distMean;
                    [screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean);
                    
                case 24
                    
                    if taskParam.gParam.oddball == false
                        if isequal(subject.group, '1')
                            
                            txt=['Weil du die Kanonenkugel verpasst hast, '...
                                'hättest du nichts verdient.'];
                        else
                            txt=['Weil Sie die Kanonenkugel verpasst haben, '...
                                'hätten Sie nichts verdient.'];
                        end
                    elseif taskParam.gParam.oddball == true
                        txt=['You missed the ball so you would earn nothing.'];
                    end
                    win = false;
                    [screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, txt, distMean, false);
                    
                case 25
                    
                    if isequal(whichPractice, 'mainPractice') || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 4) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 6)
                        
                        MainAndFollowCannon_CannonVisibleNoNoise
                        
                        MainAndFollowCannon_CannonVisibleNoise
                        
                    else
                        
                        FollowCannonJustInstructions
                        
                    end
                    
                    break
            end
        end
    end

    function MainAndFollowCannon_CannonVisibleNoNoise
        
        screenIndex = 1;
        
        while 1
            
            switch(screenIndex)
                
                
                %                 case 1
                %
                %                     if subject.cBal == 2 && isequal(whichPractice,'mainPractice')
                %                         screenIndex = screenIndex +1;
                %                     else
                %                         header = 'Break';
                %                         txt = 'Now take a break\n\nTo continue press Enter';
                %                         feedback = true;
                %                         [fw, bw] = BigScreen(taskParam, ...
                %                             taskParam.strings.txtPressEnter, header, txt, feedback);
                %                         if fw == 1
                %                             screenIndex = screenIndex + 1;
                %                         end
                %                     end
                %                     WaitSecs(0.1);
                
                case 1
                    
                    if taskParam.gParam.oddball == false
                        header = 'Erste Übung';
                    else
                        header = 'First Practice';
                    end
                    
                    if isequal(whichPractice, 'mainPractice') || isequal(whichPractice, 'followCannonPractice')
                        if isequal(subject.group, '1')
                            
                            if taskParam.gParam.oddball == false
                                
                                txt=['In dieser Übung ist das Ziel möglichst '...
                                    'viele Kanonenkugeln abzuwehren. '...
                                    'Die Kanone bleibt meistens an der '...
                                    'selben Stelle. Manchmal dreht sich die '...
                                    'Kanone allerdings und zielt auf eine '...
                                    'andere Stelle. Wenn du den orangenen '...
                                    'Punkt genau auf die Stelle steuerst, '...
                                    'auf die die Kanone zielt, wehrst du '...
                                    'die meisten Kugeln ab.\n\nWenn du deinen '...
                                    'Punkt zu oft neben die anvisierte '...
                                    'Stelle steuerst, wird die Übung wiederholt.'];
                                
                            else
                                
                                txt = ['English Text'];
                                
                            end
                        else
                            txt=['In dieser Übung ist das Ziel möglichst '...
                                'viele Kanonenkugeln abzuwehren. '...
                                'Die Kanone bleibt meistens an der '...
                                'selben Stelle. Manchmal dreht sich die '...
                                'Kanone allerdings und zielt auf eine '...
                                'andere Stelle. Wenn Sie den orangenen '...
                                'Punkt genau auf die Stelle steuern, '...
                                'auf die die Kanone zielt, wehren Sie '...
                                'die meisten Kugeln ab.\n\nWenn Sie Ihren '...
                                'Punkt zu oft neben die anvisierte '...
                                'Stelle steuern, wird die Übung wiederholt.'];
                        end
                    else
                        
                        if isequal(subject.group, '1')
                            txt=['In dieser Übung ist das Ziel '...
                                'möglichst viele Kanonenkugeln '...
                                'aufzusammeln. Du wirst feststellen, '...
                                'dass die Kanone relativ ungenau schießt, '...
                                'aber meistens auf die selbe Stelle zielt. '...
                                'Manchmal dreht sich die Kanone '...
                                'allerdings auch und zielt auf eine '...
                                'andere Stelle. Du verdienst am meisten, '...
                                'wenn du den orangenen Punkt genau '...
                                'auf den schwarzen Strich steuerst, weil '...
                                'du so sicher die Kugel aufsammelst. '...
                                '\n\nWenn du die Kugel zu oft nicht aufsammelst, '...
                                'wird die '...
                                'Übung wiederholt.'];
                        else
                            txt=['In dieser Übung ist das Ziel '...
                                'möglichst viele Kanonenkugeln '...
                                'aufzusammeln. Sie werden feststellen, '...
                                'dass die Kanone relativ ungenau schießt, '...
                                'aber meistens auf die selbe Stelle zielt. '...
                                'Manchmal dreht sich die Kanone '...
                                'allerdings auch und zielt auf eine '...
                                'andere Stelle. Sie verdienen am meisten, '...
                                'wenn Sie den orangenen Punkt genau '...
                                'auf den schwarzen Strich steuern, weil '...
                                'Sie so sicher die Kugel aufsammeln. '...
                                '\n\nWenn Sie die Kugel zu oft nicht aufsammeln, '...
                                'wird die '...
                                'Übung wiederholt.'];
                        end
                        
                    end
                    feedback = false;
                    [fw, bw] = BigScreen(taskParam, ...
                        taskParam.strings.txtPressEnter, header, txt, feedback);
                    
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    end
                    WaitSecs(0.1);
                    
                case 2
                    
                    condition = 'mainPractice';
                    LoadData = 'CP_NoNoise';
                    [taskParam, practData] = PractLoop(taskParam, subject,...
                        taskParam.gParam.vola(1), taskParam.gParam.sigma(3),...
                        cannon, condition, LoadData);
                    
                    [txt, header] = Feedback(practData, taskParam, subject, condition);
                    feedback = true;
                    [fw, bw] = BigScreen(taskParam,...
                        taskParam.strings.txtPressEnter, header, txt, feedback);
                    
                    if fw == 1
                        screenIndex = screenIndex + 1;
                    elseif bw == 1
                        screenIndex = screenIndex - 1;
                    end
                    WaitSecs(0.1);
                    
                case 3
                    
                    screenIndex = performanceCriterion(screenIndex, practData);
                    
                case 4
                    
                    break
                    
            end
            
        end
        
    end

    function MainAndFollowCannon_CannonVisibleNoise
        
        screenIndex = 1;
        
        while 1
            
            switch(screenIndex)
                
                
                case 1
                    
                    
                    if isequal(whichPractice, 'mainPractice') || isequal(whichPractice, 'followCannonPractice')
                        if taskParam.gParam.oddball == false
                            header = 'Zweite Übung';
                        else
                            header = 'Second Practice';
                        end
                        
                        if isequal(subject.group, '1')
                            
                            if taskParam.gParam.oddball == false
                                
                                txt=['Weil die Kanone schon sehr alt ist, sind die '...
                                    'Schüsse ziemlich ungenau. Das heißt, auch wenn '...
                                    'du genau auf das Ziel gehst, kannst du '...
                                    'die Kugel verfehlen. Die Ungenauigkeit '...
                                    'ist zufällig, dennoch wehrst du '...
                                    'die meisten Kugeln ab, wenn du den orangenen Punkt '...
                                    'genau auf die Stelle steuerst, auf die die Kanone '...
                                    'zielt.\n\nIn der nächsten Übung sollst du mit der '...
                                    'Ungenauigkeit der Kanone erstmal vertraut werden. '...
                                    'Lasse den orangenen Punkt bitte immer auf der '...
                                    'anvisierten Stelle stehen. Wenn du deinen Punkt zu oft '...
                                    'neben die anvisierte Stelle steuerst, wird die '...
                                    'Übung wiederholt.'];
                                
                            else
                                txt = ['English Text'];
                            end
                        else
                            txt=['Weil die Kanone schon sehr alt ist, sind die '...
                                'Schüsse ziemlich ungenau. Das heißt, auch wenn '...
                                'Sie genau auf das Ziel gehen, können Sie '...
                                'die Kugel verfehlen. Die Ungenauigkeit '...
                                'ist zufällig, dennoch wehren Sie '...
                                'die meisten Kugeln ab, wenn Sie den orangenen Punkt '...
                                'genau auf die Stelle steuern, auf die die Kanone '...
                                'zielt.\n\nIn der nächsten Übung sollen Sie mit der '...
                                'Ungenauigkeit der Kanone erstmal vertraut werden. '...
                                'Lassen Sie den orangenen Punkt bitte immer auf der '...
                                'anvisierten Stelle stehen. Wenn Sie Ihren Punkt zu oft '...
                                'neben die anvisierte Stelle steuern, wird die '...
                                'Übung wiederholt.'];
                        end
                        
                    else
                        
                        header = 'Erste Übung';
                        
                        
                        if isequal(subject.group, '1')
                            
                            
                            
                            
                            txt=['In dieser Übung ist das Ziel möglichst '...
                                'viele Kanonenkugeln aufzusammeln. '...
                                'Du wirst feststellen, dass die Kanone '...
                                'relativ ungenau schießt, aber meistens '...
                                'auf die selbe Stelle zielt. Diese '...
                                'Ungenauigkeit ist zufällig. Manchmal '...
                                'dreht sich die Kanone '...
                                'auch und zielt auf eine andere Stelle. '...
                                'Du verdienst am meisten, wenn du den '...
                                'orangenen Punkt genau auf den '...
                                'schwarzen Strich steuerst, weil du '...
                                'so sicher die Kugel aufsammelst. '...
                                '\n\nWenn du die Kugel zu oft nicht aufsammelst, '...
                                'wird die '...
                                'Übung wiederholt.'];
                        else
                            
                            txt=['In dieser Übung ist das Ziel möglichst '...
                                'viele Kanonenkugeln aufzusammeln. '...
                                'Du wirst feststellen, dass die Kanone '...
                                'relativ ungenau schießt, aber meistens '...
                                'auf die selbe Stelle zielt. Diese '...
                                'Ungenauigkeit ist zufällig. Manchmal '...
                                'dreht sich die Kanone '...
                                'auch und zielt auf eine andere Stelle. '...
                                'Du verdienst am meisten, wenn du den '...
                                'orangenen Punkt genau auf den '...
                                'schwarzen Strich steuerst, weil du '...
                                'so sicher die Kugel aufsammelst. '...
                                '\n\nWenn du die Kugel zu oft nicht aufsammelst, '...
                                'wird die '...
                                'Übung wiederholt.'];
                        end
                        
                        
                    %end
                    
            end
            
            feedback = false;
            [fw, bw] = BigScreen(taskParam, ...
                taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 3;
            end
            
            
            WaitSecs(0.1);
            case 2
                
                
                LoadData = 'CP_Noise';
                if isequal(whichPractice, 'mainPractice')
                    condition = 'mainPractice';
                elseif isequal(whichPractice, 'followCannonPractice')
                    condition = 'followCannonPractice';
                elseif isequal(whichPractice, 'followOutcomePractice')
                    condition = 'followOutcomePractice';
                end
                [taskParam, practData] = PractLoop(taskParam, subject,...
                    taskParam.gParam.vola(1), taskParam.gParam.sigma(1),...
                    cannon, condition,LoadData);
                
                [txt, header] = Feedback(practData, taskParam, subject, condition);
                
                feedback = true;
                [fw, bw] = BigScreen(taskParam,...
                    taskParam.strings.txtPressEnter, header, txt, feedback);
                
                if fw == 1
                    screenIndex = screenIndex + 1;
                elseif bw == 1
                    screenIndex = screenIndex - 1;
                end
                WaitSecs(0.1);
                
                case 3
                    
                    screenIndex = performanceCriterion(screenIndex, practData);
                    
                    case 4
                        
                        if isequal(whichPractice, 'followCannonPractice')
                            FollowCannonJustInstructions
                            
                        elseif isequal(whichPractice, 'followOutcomePractice')
                            break
                        else
                            MainJustInstructions
                        end
                        
                        break
        end
        
    end

end

function FollowCannonJustInstructions
if subject.cBal == 1 || subject.cBal == 2 || subject.cBal == 3
    screenIndex = 1;
else
    screenIndex = 2;
    
end
while 1
    switch(screenIndex)
        
        
        case 1
            
            txt = 'Kanonenkugeln Abwehren';
            screenIndex = YourTaskScreen(txt,...
                taskParam.textures.shieldTxt, screenIndex);
            
        case 2
            if subject.cBal == 1 || subject.cBal == 2 || subject.cBal == 3
                
                header = 'Kanonenkugeln Abwehren';
                
                
                if isequal(subject.group, '1')
                    
                    txt = ['In dieser Aufgabe ist das Ziel wieder '....
                        'möglichst viele Kanonenkugeln abzuwehren. '...
                        'Der Unterschied ist allerdings, dass du '...
                        'die Kanone dieses Mal sehen kannst.'];
                else
                    
                    txt = ['In dieser Aufgabe ist das Ziel wieder '....
                        'möglichst viele Kanonenkugeln abzuwehren. '...
                        'Der Unterschied ist allerdings, dass Sie '...
                        'die Kanone dieses Mal sehen können.'];
                end
                
                
                feedback = false;
                [fw, bw] = BigScreen(taskParam,...
                    taskParam.strings.txtPressEnter, header, txt, feedback);
                if fw == 1
                    screenIndex = screenIndex + 1;
                    
                elseif bw == 1
                    screenIndex = screenIndex - 3;
                end
            else
                screenIndex = screenIndex + 1;
            end
            WaitSecs(0.1);
            
        case 3
            
            if subject.cBal == 1 || subject.cBal == 2 || subject.cBal == 3
                header = 'Erste Übung';
            else
                header = 'Dritte Übung';
            end
            
            
            
            if isequal(subject.group, '1') && (subject.cBal == 4 || subject.cBal == 6)
                
                txt = ['In dieser Aufgabe sollst du wieder versuchen '...
                    'möglichst viele Kanonenkugeln abzuwehren. Da du '...
                    'das Ziel der Kanone die ganze Zeit siehst, '...
                    'steuerst du dein Schild am besten '...
                    'genau auf die schwarze Nadel.'...
                    '\n\nBeachte allerdings, dass du jetzt nicht mehr '...
                    'sehen kannst wie die Kanonenkugel fliegt, sondern nur wo sie landet.'];
            elseif isequal(subject.group, '1') && (subject.cBal == 1 || subject.cBal == 2 ||...
                    subject.cBal == 3 || subject.cBal == 5 )
                txt = ['In dieser Aufgabe sollst du wieder versuchen '...
                    'möglichst viele Kanonenkugeln abzuwehren. Da du '...
                    'das Ziel der Kanone die ganze Zeit siehst, '...
                    'steuerst du dein Schild am besten '...
                    'genau auf die schwarze Nadel.'];
            elseif isequal(subject.group, '2') && (subject.cBal == 4 || subject.cBal == 6)
                txt = ['In dieser Aufgabe sollen Sie wieder versuchen '...
                    'möglichst viele Kanonenkugeln abzuwehren. Da Sie '...
                    'das Ziel der Kanone die ganze Zeit sehen, '...
                    'steuern Sie Ihr Schild am besten '...
                    'genau auf die schwarze Nadel.'...
                    '\n\nBeachten Sie allerdings, dass Sie jetzt nicht mehr '...
                    'sehen können wie die Kanonenkugel fliegt, sondern nur wo sie landet.'];
            elseif isequal(subject.group, '2') && (subject.cBal == 1 || subject.cBal == 2 ||...
                    subject.cBal == 3 || subject.cBal == 5 )
                txt = ['In dieser Aufgabe sollen Sie wieder versuchen '...
                    'möglichst viele Kanonenkugeln abzuwehren. Da Sie '...
                    'das Ziel der Kanone die ganze Zeit sehen, '...
                    'steuern Sie Ihr Schild am besten '...
                    'genau auf die schwarze Nadel.'];
            end
            
            feedback = false;
            [fw, bw] = BigScreen(taskParam,...
                taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
                
            elseif bw == 1
                screenIndex = screenIndex - 3;
            end
            
            WaitSecs(0.1);
            
        case 4
            break
    end
end

end

function MainJustInstructions

screenIndex = 1;
while 1
    switch(screenIndex)
        
        
        %                 case 1
        %
        %                     while 1
        %                         WaitSecs(0.1);
        %                         Screen('TextFont', taskParam.gParam.window, 'Arial');
        %                         Screen('TextSize', taskParam.gParam.window, 50);
        %                         txt='Deine Aufgabe: Kanonenkugeln fangen';
        %                         DrawFormattedText(taskParam.gParam.window, txt,...
        %                             'center', 100, [255 255 255]);
        %                         Screen('DrawingFinished', taskParam.gParam.window);
        %                         t = GetSecs;
        %                         Screen('Flip', taskParam.gParam.window, t + 0.1);
        %                         [~, ~, keyCode] = KbCheck;
        %                         if find(keyCode) == taskParam.keys.enter
        %                             if (isequal(whichPractice, 'mainPractice')) && subject.cBal == 2
        %                                 screenIndex = screenIndex + 1;
        %                             else
        %                                 screenIndex = screenIndex + 1;
        %                             end
        %                             break
        %                         end
        %                     end
        %                     WaitSecs(0.1);
        case 1
            if subject.cBal == 4 || subject.cBal == 6 || subject.cBal == 5
                txt = 'Kanonenkugeln Abwehren';
                screenIndex = YourTaskScreen(txt,...
                    taskParam.textures.shieldTxt, screenIndex);
            else
                screenIndex = screenIndex + 1;
            end
            
        case 2
            if subject.cBal == 4 || subject.cBal == 6 || subject.cBal == 5
                
                header = 'Kanonenkugeln Abwehren';
                
                
                if isequal(subject.group, '1')
                    
                    txt = ['In dieser Aufgabe ist das Ziel wieder '....
                        'möglichst viele Kanonenkugeln abzuwehren. '...
                        'Der Unterschied ist allerdings, dass du '...
                        'die Kanone diesmal nur noch selten sehen kannst.'];
                else
                    
                    txt = ['In dieser Aufgabe ist das Ziel wieder '....
                        'möglichst viele Kanonenkugeln abzuwehren. '...
                        'Der Unterschied ist allerdings, dass Sie '...
                        'die Kanone diesmal nur noch selten sehen können.'];
                end
                
                
                feedback = false;
                [fw, bw] = BigScreen(taskParam,...
                    taskParam.strings.txtPressEnter, header, txt, feedback);
                if fw == 1
                    screenIndex = screenIndex + 1;
                    
                elseif bw == 1
                    screenIndex = screenIndex - 3;
                end
            else
                screenIndex = screenIndex + 1;
            end
            WaitSecs(0.1);
        case 3
            if subject.cBal == 4 || subject.cBal == 5 || subject.cBal == 6
                header = 'Erste Übung';
            else
                header = 'Dritte Übung';
            end
            
            if isequal(subject.group, '1')
                
                txt = ['Bis jetzt kanntest du das Ziel '...
                    'der Kanone und du konntest die meisten '...
                    'Kugeln abwehren. Im nächsten '...
                    'Übungsdurchgang wird die Kanone in den '...
                    'meisten Fällen nicht '...
                    'mehr sichtbar sein. Anstelle der '...
                    'Kanone siehst dann ein Kreuz. '...
                    'Außerdem siehst du wo die '...
                    'Kanonenkugeln landen.\n\n'...
                    'Um weiterhin viele Kanonenkugeln '...
                    'abzuwehren, musst du aufgrund '...
                    'der Landeposition einschätzen, auf '...
                    'welche Stelle die Kanone zielt und '...
                    'den orangenen Punkt auf diese Position '...
                    'steuern. Wenn du denkst, dass die '...
                    'Kanone auf eine neue Stelle zielt, '...
                    'solltest du auch den orangenen Punkt '...
                    'dorthin bewegen.\n\nWenn du die '...
                    'Kanone siehst, steuerst du dein Schild '...
                    'am besten genau auf das Ziel der Kanone.'];
            else
                
                txt = ['Bis jetzt kannten Sie das Ziel '...
                    'der Kanone und Sie konnten die meisten '...
                    'Kugeln abwehren. Im nächsten '...
                    'Übungsdurchgang wird die Kanone in den '...
                    'meisten Fällen nicht '...
                    'mehr sichtbar sein. Anstelle der '...
                    'Kanone sehen Sie dann ein Kreuz. '...
                    'Außerdem sehen Sie wo die '...
                    'Kanonenkugeln landen.\n\n'...
                    'Um weiterhin viele Kanonenkugeln '...
                    'abzuwehren, müssen Sie aufgrund '...
                    'der Landeposition einschätzen, auf '...
                    'welche Stelle die Kanone zielt und '...
                    'den orangenen Punkt auf diese Position '...
                    'steuern. Wenn Sie denken, dass die '...
                    'Kanone auf eine neue Stelle zielt, '...
                    'sollten Sie auch den orangenen Punkt '...
                    'dorthin bewegen.\n\nWenn Sie die '...
                    'Kanone sehen, steuern Sie Ihr Schild '...
                    'am besten genau auf das Ziel der Kanone.'];
            end
            feedback = false;
            [fw, bw] = BigScreen(taskParam,...
                taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
                
            elseif bw == 1
                screenIndex = screenIndex - 3;
            end
            
            WaitSecs(0.1);
            
        case 4
            break
    end
end

end

function FollowOutcomeInstructions

screenIndex = 1;
while 1
    switch(screenIndex)
        
        case 1
            
            txt = 'Kanonenkugeln Aufsammeln';
            screenIndex = YourTaskScreen(txt,...
                taskParam.textures.basketTxt, screenIndex);
            
        case 2
            
            screenIndex = FirstCannonSlide(screenIndex);
            
        case 3
            
            [screenIndex, Data] = PressSpaceToInitiateCannonShot(screenIndex, true);
            
        case 4
            
            if isequal(subject.group, '1')
                
                txt=['Der schwarze Strich zeigt dir die '...
                    'Position der letzten Kugel. Der orangene '...
                    'Strich zeigt dir die Position deines '...
                    'letzten Korbes. Bewege den orangenen '...
                    'Punkt zur Stelle der letzten Kanonenkugel '...
                    'und drücke LEERTASTE um die Kugel aufzusammeln. '...
                    'Gleichzeitig schießt die Kanone dann eine neue Kugel ab.'];
            else
                
                txt=['Der schwarze Strich zeigt Ihnen die '...
                    'Position der letzten Kugel. Der orangene '...
                    'Strich zeigt Ihnen die Position Ihres '...
                    'letzten Korbes. Bewegen Sie den orangenen '...
                    'Punkt zur Stelle der letzten Kanonenkugel '...
                    'und drücken Sie LEERTASTE um die Kugel aufzusammeln. '...
                    'Gleichzeitig schießt die Kanone dann eine neue Kugel ab.'];
            end
            Data.distMean = 35;
            Data.outcome = 290;
            [screenIndex, Data] = MoveSpotToLastOutcome(screenIndex, Data, txt);
            
        case 5
            
            if isequal(subject.group, '1')
                txt=['Der Korb erscheint nach dem Schuss. '...
                    'In diesem Fall hast du die Kanonenkugel mit dem Korb aufgesammelt. '...
                    'Wie du sehen kannst, hat die Kanone auch eine neue Kugel abgeschossen, '...
                    'die du im nächsten Durchgang aufsammeln kannst. '...
                    'Wenn mindestens die Hälfte der Kugel im Korb ist, '...
                    'zählt es als aufgesammelt.'];
                
            else
                txt=['Der Korb erscheint nach dem Schuss. '...
                    'In diesem Fall haben Sie die Kanonenkugel mit dem Korb aufgesammelt. '...
                    'Wie Sie sehen können, hat die Kanone auch eine neue Kugel abgeschossen, '...
                    'die Sie im nächsten Durchgang aufsammeln können. '...
                    'Wenn mindestens die Hälfte der Kugel im Korb ist, '...
                    'zählt es als aufgesammelt.'];
                
            end
            distMean = 35;
            Data.distMean = 35;
            Data.outcome = 35;
            screenIndex = YouDidNotCollectTheCannonBall_TryAgain(screenIndex, Data, distMean, txt);
            
        case 6
            
            if isequal(subject.group, '1')
                txt=['Platziere den Korb jetzt wieder '...
                    'auf der Stelle der letzten Kanonenkugel '...
                    '(schwarzer Strich) und drücke LEERTASTE '...
                    'um die Kugel aufzusammeln.'];
            else
                
                
                txt=['Platzieren Sie den Korb jetzt wieder '...
                    'auf der Stelle der letzten Kanonenkugel '...
                    '(schwarzer Strich) und drücken Sie LEERTASTE '...
                    'um die Kugel aufzusammeln.'];
            end
            Data.distMean = 190;
            Data.outcome = 35;
            [screenIndex, Data] = MoveSpotToLastOutcome(screenIndex, Data, txt);
            
        case 7
            
            if isequal(subject.group, '1')
                
                txt=['Sehr gut! Du hast die vorherige Kanonenkugel wieder aufgesammelt.'];
                
            else
                txt=['Sehr gut! Sie haben die vorherige Kanonenkugel wieder aufgesammelt.'];
                
            end
            distMean = 190;
            Data.distMean = 190;
            Data.outcome = 190;
            screenIndex = YouDidNotCollectTheCannonBall_TryAgain(screenIndex, Data, distMean, txt);
            
        case 8
            
            if isequal(subject.group, '1')
                txt = sprintf(['Wenn du Kanonenkugeln aufsammelst, '...
                    'kannst du Geld verdienen. Wenn der Korb '...
                    '%s ist, verdienst du %s CENT wenn du die '...
                    'Kanonenkugel aufsammelst. Wenn der Korb %s '...
                    'ist, verdienst du nichts. Ebenso wie die '...
                    'Farbe, kann auch die Größe deines '...
                    'Korbes variieren. '...
                    'Die Farbe und die Größe des Korbes siehst '...
                    'du erst, nachdem die Kanone geschossen hat. '...
                    'Daher versuchst du am besten jede '...
                    'Kanonenkugel aufzusammeln.\n\n'...
                    'Um einen Eindruck von der wechselnden Größe '...
                    'und Farbe des Korbes zu bekommen, '...
                    'kommt jetzt eine kurze Übung.\n\n'], colRew, num2str(100*taskParam.gParam.rewMag), colNoRew);
                
            else
                
                txt = sprintf(['Wenn Sie Kanonenkugeln aufsammeln, '...
                    'können Sie Geld verdienen. Wenn der Korb '...
                    '%s ist, verdienen Sie %s CENT wenn Sie die '...
                    'Kanonenkugel aufsammeln. Wenn der Korb %s '...
                    'ist, verdienen Sie nichts. Ebenso wie die '...
                    'Farbe, kann auch die Größe Ihres '...
                    'Korbes variieren. '...
                    'Die Farbe und die Größe des Korbes sehen '...
                    'Sie erst, nachdem die Kanone geschossen hat. '...
                    'Daher versuchen Sie am besten jede '...
                    'Kanonenkugel aufzusammeln.\n\n'...
                    'Um einen Eindruck von der wechselnden Größe '...
                    'und Farbe des Korbes zu bekommen, '...
                    'kommt jetzt eine kurze Übung.\n\n'], colRew, num2str(100*taskParam.gParam.rewMag), colNoRew);
                
            end
            [screenIndex, Data] = YourShield(screenIndex, Data,txt);
            
        case 9
            
            screenIndex = ShieldPractice(screenIndex, whichPractice);
            
        case 10
            
            screenIndex = TrialOutcomes(screenIndex);
            
        case 11
            
            [screenIndex, Data] = PressSpaceToInitiateCannonShot(screenIndex, false);
            
        case 12
            
            if isequal(subject.group, '1')
                
                
                txt= ['Versuche die letzte Kanonenkugel jetzt wieder '...
                    'aufzusammeln (angezeigt durch den schwarzen Strich).'];
            else
                txt= ['Versuchen Sie bitte die letzte Kanonenkugel wieder '...
                    'aufzusammeln (angezeigt durch den schwarzen Strich).'];
            end
            Data.distMean = 35;
            Data.outcome = 290;
            [screenIndex, Data] = MoveSpotToLastOutcome(screenIndex, Data, txt);
            
        case 13
            
            if isequal(subject.group, '1')
                if isequal(whichPractice, 'followOutcomePractice')
                    txt = sprintf(['Weil du die Kanonenkugel aufgesammelt '...
                        'hast und der Korb %s war, '...
                        'hättest du jetzt %s CENT verdient.'], colRew, num2str(100*taskParam.gParam.rewMag));
                else
                    txt = sprintf(['Weil du die Kanonenkugel aufgesammelt '...
                        'hast und das Schild %s war, '...
                        'hättest du jetzt %s CENT verdient.'], colRew, num2str(100*taskParam.gParam.rewMag)); % notwendig?
                end
            else
                if isequal(whichPractice, 'followOutcomePractice')
                    txt = sprintf(['Weil Sie die Kanonenkugel aufgesammelt '...
                        'haben und der Korb %s war, '...
                        'hätten Sie jetzt %s CENT verdient.'], colRew, num2str(100*taskParam.gParam.rewMag));
                else
                    txt = sprintf(['Weil Sie die Kanonenkugel aufgesammelt '...
                        'haben und das Schild %s war, '...
                        'hätten Sie jetzt %s CENT verdient.'], colRew, num2str(100*taskParam.gParam.rewMag)); % notwendig?
                end
            end
            distMean = 35;
            Data.distMean = 35;
            Data.outcome = 35;
            screenIndex = YouDidNotCollectTheCannonBall_TryAgain(screenIndex, Data, distMean, txt);
            
        case 14
            
            if isequal(subject.group, '1')
                
                
                txt= ['Versuche die letzte Kanonenkugel jetzt extra nicht '...
                    'aufzusammeln.'];
            else
                txt= ['Versuchen Sie bitte die letzte Kanonenkugel extra nicht '...
                    'aufzusammeln.'];
            end
            Data.distMean = 190;
            Data.outcome = 35;
            [screenIndex, Data] = MoveSpotToLastOutcome(screenIndex, Data, txt);
            
        case 15
            
            Data.distMean = 190;
            Data.outcome = 190;
            win = true;
            [screenIndex, Data] = YouCollectedTheCannonball_TryToMissIt(screenIndex, Data, win);
            
        case 16
            
            if isequal(subject.group, '1')
                txt= ['Versuche die letzte Kanonenkugel jetzt wieder '...
                    'aufzusammeln (angezeigt durch den schwarzen Strich).'];
            else
                txt= ['Versuchen Sie die letzte Kanonenkugel bitte wieder '...
                    'aufzusammeln (angezeigt durch den schwarzen Strich).'];
            end
            Data.distMean = 160;
            Data.outcome = 190;
            [screenIndex, Data] = MoveSpotToLastOutcome(screenIndex, Data, txt);
            
        case 17
            
            [screenIndex, Data] = YouMissedTheCannonball_TryToCollectIt(screenIndex, Data);
            
        case 18
            
            
            if isequal(subject.group, '1')
                
                txt= ['Versuche die letzte Kanonenkugel jetzt extra nicht '...
                    'aufzusammeln.'];
            else
                txt= ['Versuchen Sie bitte die letzte Kanonenkugel nicht '...
                    'aufzusammeln.'];
            end
            Data.distMean = 10;
            Data.outcome = 160;
            [screenIndex, Data] = MoveSpotToLastOutcome(screenIndex, Data, txt);
            
        case 19
            
            Data.distMean = 10;
            Data.outcome = 10;
            win = false;
            [screenIndex, Data] = YouCollectedTheCannonball_TryToMissIt(screenIndex, Data, win);
            
        case 20
            
            MainAndFollowCannon_CannonVisibleNoise
            
            screenIndex = screenIndex + 1;
            
        case 21
            
            header = 'Zweite Übung';
            
            if isequal(subject.group, '1')
                
                txt=['Im nächsten '...
                    'Übungsdurchgang wird die Kanone meistens '...
                    'nicht mehr sichtbar sein. Anstelle der '...
                    'Kanone siehst du dann ein Kreuz, ansonsten bleibt alles gleich. '...
                    'Da du in dieser Aufgabe Kanonenkugeln '...
                    'aufsammelst, brauchst du nicht auf die '...
                    'Kanone zu achten.'];
            else
                
                txt=['Im nächsten '...
                    'Übungsdurchgang wird die Kanone meistens '...
                    'nicht mehr sichtbar sein. Anstelle der '...
                    'Kanone sehen Sie dann ein Kreuz, ansonsten bleibt alles gleich. '...
                    'Da Sie in dieser Aufgabe Kanonenkugeln '...
                    'aufsammeln, brauchen Sie nicht auf die '...
                    'Kanone zu achten.'];
                
            end
            
            
            
            feedback = false;
            [fw, bw] = BigScreen(taskParam, ...
                taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 3;
            end
            
            
            WaitSecs(0.1);
            
        case 22
            
            break
    end
end
end

function [screenIndex] = YourTaskScreen(txt, texture, screenIndex)
while 1
    Screen('TextFont', taskParam.gParam.window, 'Arial');
    Screen('TextSize', taskParam.gParam.window, 30);
    DrawFormattedText(taskParam.gParam.window, txt,...
        'center', 100, [0 0 0], sentenceLength);
    Screen('DrawTexture', taskParam.gParam.window, texture,[],...
        taskParam.textures.dstRect)
    
    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.1);
    [~, ~, keyCode] = KbCheck;
    if find(keyCode) == taskParam.keys.enter
        screenIndex = screenIndex + 1;
        break
    end
    
end
WaitSecs(0.1);
end

function [screenIndex] = FirstCannonSlide(screenIndex)

WaitSecs(0.1);
if taskParam.gParam.oddball == false
    if isequal(whichPractice, 'mainPractice') || isequal(whichPractice, 'followCannonPractice')
        if isequal(subject.group, '1')
            txt=['Eine Kanone zielt auf eine Stelle des '...
                'Kreises. Deine Aufgabe ist es, die Kanonenkugel '...
                'mit einem Schild abzuwehren. Mit dem orangenen '...
                'Punkt kannst du angeben, wo du dein Schild '...
                'platzieren möchtest, um die '...
                'Kanonenkugel abzuwehren.\nDu kannst den Punkt mit den '...
                'grünen und blauen Tasten steuern. '...
                'Grün kannst du für schnelle Bewegungen und '...
                'blau für langsame Bewegungen benutzen.'];
        else
            txt=['Eine Kanone zielt auf eine Stelle des '...
                'Kreises. Ihre Aufgabe ist es, die Kanonenkugel '...
                'mit einem Schild abzuwehren. Mit dem orangenen '...
                'Punkt können Sie angeben, wo Sie Ihr Schild '...
                'platzieren möchten, um die '...
                'Kanonenkugel abzuwehren.\nSie können den Punkt mit den '...
                'grünen und blauen Tasten steuern. '...
                'Grün können Sie für schnelle Bewegungen und '...
                'blau für langsame Bewegungen benutzen.'];
            
        end
    else
        if isequal(subject.group, '1')
            txt=['Eine Kanone zielt auf eine Stelle des '...
                'Kreises. Deine Aufgabe ist es, Kanonenkugeln '...
                'mit einem Korb aufzusammeln. Mit dem orangenen '...
                'Punkt kannst du angeben, '...
                'wo du deinen Korb platzieren möchtest, um die '...
                'Kanonenkugel aufzusammeln.\nDu kannst den Punkt mit den '...
                'grünen und blauen Tasten steuern. '...
                'Grün kannst du für schnelle Bewegungen und '...
                'blau für langsame Bewegungen benutzen.'];
        else
            txt=['Eine Kanone zielt auf eine Stelle des '...
                'Kreises. Ihre Aufgabe ist es, Kanonenkugeln '...
                'mit einem Korb aufzusammeln. Mit dem orangenen '...
                'Punkt können Sie angeben, '...
                'wo Sie Ihren Korb platzieren möchten, um die '...
                'Kanonenkugeln aufzusammeln.\nSie können den Punkt mit den '...
                'grünen und blauen Tasten steuern. '...
                'Grün können Sie für schnelle Bewegungen und '...
                'blau für langsame Bewegungen benutzen.'];
        end
    end
elseif taskParam.gParam.oddball == true
    txt=['A cannon is aimed at the circle. Indicate where '...
        'you would like to place your shield with the orange spot. '...
        'You can move the orange spot with the green and yellow '...
        'buttons. Green is for fast movements and yellow is '...
        'for slow movements.'];
end

if isequal(taskParam.gParam.computer, 'Dresden')
    Screen('TextSize', taskParam.gParam.window, 19);
else
    Screen('TextSize', taskParam.gParam.window, 30);
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
    screenIndex = screenIndex - 1;
end
WaitSecs(0.1);
end

function [screenIndex, Data] = MoveSpotToCannonAim(screenIndex, txt, distMean, Data)

t = GetSecs;
LineAndBack(taskParam)
DrawCross(taskParam)
DrawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window, 1);
Screen('Flip', taskParam.gParam.window, t + 0.1, 1);
WaitSecs(0.5);


Data.tickMark=true;

%Data.outcome=320;
%Data.pred = 360;
Data.distMean=distMean;
[taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
    txt, cannon, 'space', distMean, Data);
if fw == 1
    screenIndex = screenIndex + 1;
end
WaitSecs(0.1);
end

function [screenIndex, Data] = YouMissedTheCannonBall_TryAgain(screenIndex, Data, distMean)
outcome = distMean;
Data.outcome = distMean;
background = true;
Cannonball(taskParam, distMean, outcome, background)
if (isequal(whichPractice, 'mainPractice') && Data.predErr >= 9) || (isequal(whichPractice, 'followCannonPractice') && Data.predErr >= 9)
    %while 1
    if taskParam.gParam.oddball == false
        if isequal(subject.group, '1')
            txt=['Leider hast du die Kanonenkugel vefehlt. '...
                'Versuche es noch einmal!'];
        else
            txt=['Leider haben Sie die Kanonenkugel vefehlt. '...
                'Versuchen Sie es bitte noch einmal!'];
        end
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
                screenIndex = screenIndex - 2;
                break
            end
        end
    end
else
    screenIndex = screenIndex +1;
end
WaitSecs(0.1);
end

function [screenIndex, Data] = AfterCannonIsShotYouSeeTheShield(screenIndex, Data, txt, distMean, win)
outcome = distMean;
LineAndBack(taskParam)
DrawCircle(taskParam);
DrawCross(taskParam);
PredictionSpot(taskParam);
DrawOutcome(taskParam, outcome);
Cannon(taskParam, distMean)
Screen('DrawingFinished', taskParam.gParam.window);
t = GetSecs;
Screen('Flip', taskParam.gParam.window, t + 0.1);
LineAndBack(taskParam)
DrawCross(taskParam)
DrawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window, 1);
Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
while 1
    
    LineAndBack(taskParam)
    Cannon(taskParam, distMean)
    DrawCircle(taskParam)
    
    if (subject.rew == 1 && win) || (subject.rew == 2 && ~win)
        Shield(taskParam, 20, Data.pred, 1)
    elseif (subject.rew == 2 && win) || (subject.rew == 1 && ~win)
        Shield(taskParam, 20, Data.pred, 0)
        
    end
    DrawOutcome(taskParam, outcome)
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
            screenIndex = screenIndex - 3;
            break
        end
    end
end
WaitSecs(0.1);

end

function [screenIndex, Data] = TryToMissTheCannon(screenIndex, Data, txt, distMean)


t = GetSecs;
LineAndBack(taskParam)
DrawCross(taskParam)
DrawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window, 1);
Screen('Flip', taskParam.gParam.window, t + 0.1, 1);
WaitSecs(0.5);


Data.tickMark=true;

%Data.outcome=320;
%Data.pred = 360;
Data.distMean=distMean;

outcome = distMean;
Data.tickMark = true;
[taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt,...
    cannon, 'space', distMean, Data);
if fw == 1
    screenIndex = screenIndex + 1;
end

WaitSecs(0.1);
end

function [screenIndex, Data, t] = YouCaughtTheCannonball_TryToMissIt(screenIndex, Data, distMean)

outcome = Data.outcome;
background = true;
Cannonball(taskParam, distMean, outcome, background)

if Data.predErr <=9
    while 1
        if taskParam.gParam.oddball == false
            if isequal(subject.group, '1')
                
                txt=['Du hast die Kanonenkugel abgewehrt. '...
                    'Versuche die Kanonenkugel diesmal zu verpassen!'];
            else
                
                txt=['Sie haben die Kanonenkugel abgewehrt. '...
                    'Versuchen Sie die Kanonenkugel diesmal bitte zu verpassen!'];
            end
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
                screenIndex = screenIndex - 5;
                break
            end
        end
    end
else
    if taskParam.gParam.oddball == false
        if isequal(subject.group, '1')
            
            txt=['Der schwarze Balken zeigt dir '...
                'wie weit die Kanonenkugel von deinem '...
                'Punkt entfernt war. Daraufhin siehst du dann...'];
        else
            txt=['Der schwarze Balken zeigt Ihnen '...
                'wie weit die Kanonenkugel von Ihrem '...
                'Punkt entfernt war. Daraufhin siehst du dann...'];
        end
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
    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.1);
    screenIndex = screenIndex + 1;
end

WaitSecs(0.1);

end

function [screenIndex, Data, t] = InThisCaseYouMissedTheCannonball(screenIndex, Data, t, txt, distMean, win)

outcome = distMean;
LineAndBack(taskParam)
DrawCross(taskParam)
DrawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window, 1);
Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
while 1
    
    LineAndBack(taskParam)
    Cannon(taskParam, distMean)
    DrawCircle(taskParam)
    if (subject.rew == 1 && win) || (subject.rew == 2 && ~win)
        Shield(taskParam, 20, Data.pred, 1)
    elseif (subject.rew == 2 && win) || (subject.rew == 1 && ~win)
        Shield(taskParam, 20, Data.pred, 0)
    end
    DrawOutcome(taskParam, outcome)
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
            screenIndex = screenIndex - 6;
            break
        end
    end
end
WaitSecs(0.1);
end

function [screenIndex, Data] = YourShield(screenIndex, Data, txt)
if taskParam.gParam.oddball == false
    if isequal(whichPractice, 'followOutcomePractice')
        header = 'Der Korb';
        
    else
        header = 'Das Schild';
    end
    
elseif taskParam.gParam.oddball == true
    header = 'Your Shield';
    if subject.rew == 1
        colRew = 'blue';
        colNoRew = 'green';
    elseif subject.rew == 2
        colRew = 'green';
        colNoRew = 'blue';
    end
    txt = sprintf(['You can earn money by catching '...
        'cannonballs in your shield. If the shield '...
        'is %s you will earn %s CENTS for catching '...
        'the ball. If the shield is %s you will not '...
        'earn anything. On some trials the shield '...
        'will be large and on some trials it will '...
        'be small. You cannot know the SIZE or '...
        'COLOR of the shield until the cannon '...
        'is fired so it is best to try to catch '...
        'the ball on every trial.\n\n'...
        'You will now have some practice to get a '...
        'sense of how the color and size of '...
        'the shield vary.\n\nThe location of the '...
        'ball fired on the previous trial will be '...
        'marked with a black line.\n\nMoreover, '...
        'the location of the orange spot from the '...
        'previous trial will be marked with an '...
        'orange line.'], colRew, num2str(100*taskParam.gParam.rewMag), colNoRew);
end

feedback = false;
[fw, bw] = BigScreen(taskParam,...
    taskParam.strings.txtPressEnter, header, txt, feedback);
if fw == 1
    screenIndex = screenIndex + 1;
elseif bw == 1
    screenIndex = screenIndex - 7;
end
WaitSecs(0.1);

end

function [screenIndex, Data] = ShieldPractice(screenIndex, whichPractice)

condition = 'shield';
if (isequal(whichPractice, 'mainPractice')) || (isequal(whichPractice, 'followCannonPractice'))
    vola = taskParam.gParam.vola(3);
else
    vola = taskParam.gParam.vola(2);
end
[taskParam, Data] = PractLoop(taskParam, subject,...
    vola,...
    taskParam.gParam.sigma(3), cannon, condition);
screenIndex = screenIndex + 1;
WaitSecs(0.1);
end

function [screenIndex] = TrialOutcomes(screenIndex)
if taskParam.gParam.oddball == false
    header = 'Gewinnmöglichkeiten';
    if isequal(subject.group, '1')
        
        txt = ['Um dir genau zu zeigen, wann du Geld verdienst, '...
            'spielen wir jetzt alle Möglichkeiten durch.'];
    else
        txt = ['Um Ihnen genau zu zeigen, wann Sie Geld verdienen, '...
            'spielen wir jetzt alle Möglichkeiten durch.'];
    end
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
end

function [screenIndex, Data] = PressSpaceToInitiateCannonShot(screenIndex, introduceNeedle)
if introduceNeedle
    if isequal(subject.group, '1')
        
        
        if taskParam.gParam.oddball == false
            
            txt=['Das Ziel der Kanone wird mit der '...
                'schwarzen Nadel angezeigt. Drücke LEERTASTE, '...
                'damit die Kanone schießt.'];
            
        else
            txt = ['english text'];
        end
    else
        txt=['Das Ziel der Kanone wird mit der '...
            'schwarzen Nadel angezeigt. Drücke Sie bitte LEERTASTE, '...
            'damit die Kanone schießt.'];
        
    end
else
    if isequal(subject.group, '1')
        
        txt=['Drücke LEERTASTE, '...
            'damit die Kanone schießt.'];
    else
        txt=['Drücke Sie bitte LEERTASTE, '...
            'damit die Kanone schießt.'];
        
    end
end

distMean = 290;
outcome = 290;
[taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
    txt, cannon, 'space', distMean);

if fw == 1
    
    outcome = distMean;
    background = true;
    Cannonball(taskParam, distMean, outcome, background)
    screenIndex = screenIndex + 1;
    
    return
end
WaitSecs(0.1);



end

function [screenIndex, Data] = MoveSpotToLastOutcome(screenIndex, Data, txt)
t = GetSecs;
LineAndBack(taskParam)
DrawCross(taskParam)
DrawCircle(taskParam)
Screen('DrawingFinished', taskParam.gParam.window, 1);
Screen('Flip', taskParam.gParam.window, t + 0.1, 1);
WaitSecs(0.5);
%                     txt=['Bewege den orangenen Punkt zur Stelle der letzten Kanonenkugel '...
%                         '(schwarzer Strich) und drücke LEERTASTE um die Kugel aufzusammeln. '...
%                         'Gleichzeitig schießt die Kanone dann eine neue Kugel ab.'];
%Data.distMean = 35;
%Data.outcome = 290;
Data.tickMark = true;
[taskParam, fw, bw, Data] = InstrLoopTxt(taskParam,...
    txt, cannon, 'space', Data.distMean, Data);

if fw == 1
    screenIndex = screenIndex + 1;
end
end

function [screenIndex] = YouDidNotCollectTheCannonBall_TryAgain(screenIndex, Data, distMean, txt)

%Data.distMean = 35;
%Data.outcome = 35;
background = true;
Cannonball(taskParam, Data.distMean, Data.outcome, background)
if Data.memErr >=9
    
    LineAndBack(taskParam)
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.5, 1);
    
    while 1
        if isequal(subject.group, '1')
            txt=['Du hast die Kanonenkugel leider nicht aufgesammelt. '...
                'Versuche es nochmal!'];
        else
            txt=['Sie haben die Kanonenkugel leider nicht aufgesammelt. '...
                'Versuchen Sie es bitte nochmal!'];
        end
        
        LineAndBack(taskParam)
        DrawCircle(taskParam);
        DrawCross(taskParam);
        PredictionSpot(taskParam);
        DrawOutcome(taskParam, Data.outcome);
        Cannon(taskParam, Data.distMean)
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
        Screen('Flip', taskParam.gParam.window, t + 1.5);
        [ keyIsDown, ~, keyCode ] = KbCheck;
        if keyIsDown
            if keyCode(taskParam.keys.enter)
                screenIndex = screenIndex - 1 ;
                break
            elseif keyCode(taskParam.keys.delete)
                screenIndex = screenIndex - 5;
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
    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.1);
    LineAndBack(taskParam)
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
    while 1
        %
        %                             txt=['Sehr gut! Du hast die vorherige Kanonenkugel aufgesammelt. '...
        %                                 'Wie du sehen kannst hat die Kanone auch eine neue Kugel abgeschossen, '...
        %                                 'die du im nächsten Durchgang aufsammeln kannst.'];
        
        LineAndBack(taskParam)
        Cannon(taskParam, Data.distMean)
        DrawCircle(taskParam)
        
        if subject.rew == 1
            Shield(taskParam, 20, Data.pred, 1)
        elseif subject.rew == 2
            Shield(taskParam, 20, Data.pred, 0)
            
        end
        DrawOutcome(taskParam, Data.outcome)
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
                screenIndex = screenIndex - 3;
                break
            end
        end
    end
end
WaitSecs(0.1);
end

function [screenIndex, Data] = YouCollectedTheCannonball_TryToMissIt(screenIndex, Data, win)

background = true;
Cannonball(taskParam, Data.distMean, Data.outcome, background)

if Data.memErr <= 9
    
    
    
    while 1
        if isequal(subject.group, '1')
            
            txt=['Du hast die Kanonenkugel aufgesammelt. '...
                'Versuche die Kanonenkugel diesmal extra nicht aufzusammeln!'];
        else
            txt=['Sie haben die Kanonenkugel aufgesammelt. '...
                'Versuchen Sie sie bitte extra nicht aufzusammeln!'];
        end
        
        LineAndBack(taskParam)
        DrawCircle(taskParam);
        DrawCross(taskParam);
        PredictionSpot(taskParam);
        DrawOutcome(taskParam, Data.outcome);
        Cannon(taskParam, Data.distMean)
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
    
    
    
else
    
    
    
    LineAndBack(taskParam)
    DrawCircle(taskParam);
    DrawCross(taskParam);
    PredictionSpot(taskParam);
    DrawOutcome(taskParam, Data.outcome);
    Cannon(taskParam, Data.distMean)
    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.1);
    LineAndBack(taskParam)
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    Screen('Flip', taskParam.gParam.window, t + 0.6, 1);
    while 1
        
        if isequal(subject.group, '1')
            
            txt=['Weil du die Kanonenkugel nicht aufgesammelt hast, '...
                'hättest du nichts verdient.'];
        else
            txt=['Weil Sie die Kanonenkugel nicht aufgesammelt haben, '...
                'hätten Sie nichts verdient.'];
            
        end
        
        LineAndBack(taskParam)
        Cannon(taskParam, Data.distMean)
        DrawCircle(taskParam)
        if (subject.rew == 1 && win) || (subject.rew == 2 && ~win)
            Shield(taskParam, 20, Data.pred, 1)
        elseif (subject.rew == 2 && win) || (subject.rew == 1 && ~win)
            Shield(taskParam, 20, Data.pred, 0)
        end
        DrawOutcome(taskParam, Data.outcome)
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
    
    
end
WaitSecs(0.1);
end

function [screenIndex, Data] = YouMissedTheCannonball_TryToCollectIt(screenIndex, Data)

background = true;
Data.distMean = 160;
Data.outcome = 160;
Cannonball(taskParam, Data.distMean, Data.outcome, background)
if Data.memErr <= 9
    
    LineAndBack(taskParam)
    DrawCircle(taskParam);
    DrawCross(taskParam);
    PredictionSpot(taskParam);
    DrawOutcome(taskParam, Data.outcome);
    Cannon(taskParam, Data.distMean)
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
        
        if isequal(subject.group, '1')
            if isequal(whichPractice, 'followOutcomePractice')
                txt=sprintf(['Du hast die Kanonenkugel aufgesammelt, '...
                    'aber der Korb war %s. Daher hättest '...
                    'du nichts verdient.'], colNoRew);
            else
                txt=sprintf(['Du hast die Kanonenkugel aufgesammelt, '...
                    'aber das Schild war %s. Daher hättest '...
                    'du nichts verdient.'], colNoRew);
                
            end
        else
            if isequal(whichPractice, 'followOutcomePractice')
                txt=sprintf(['Sie haben die Kanonenkugel aufgesammelt, '...
                    'aber der Korb war %s. Daher hätten '...
                    'Sie nichts verdient.'], colNoRew);
            else
                txt=sprintf(['Du hast die Kanonenkugel aufgesammelt, '...
                    'aber das Schild war %s. Daher hätten '...
                    'Sie nichts verdient.'], colNoRew);
                
            end
        end
        LineAndBack(taskParam)
        Cannon(taskParam, Data.distMean)
        DrawCircle(taskParam)
        if subject.rew == 1
            Shield(taskParam, 20, Data.pred, 0)
        elseif subject.rew == 2
            Shield(taskParam, 20, Data.pred, 1)
        end
        DrawOutcome(taskParam, Data.outcome)
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
    
    
    %screenIndex = screenIndex + 2;
else
    
    
    
    
    %case 20
    
    while 1
        
        if isequal(subject.group, '1')
            
            txt=['Leider hast du die Kanonenkugel nicht aufgesammelt. '...
                'Versuche es noch einmal!'];
        else
            txt=['Leider haben Sie die Kanonenkugel nicht aufgesammelt. '...
                'Versuchen Sie es bitte noch einmal!'];
        end
        
        LineAndBack(taskParam)
        DrawCircle(taskParam);
        DrawCross(taskParam);
        PredictionSpot(taskParam);
        DrawOutcome(taskParam, Data.outcome);
        Cannon(taskParam, Data.distMean)
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
    
    screenIndex = screenIndex + 1;
end
WaitSecs(0.1);
end

function [screenIndex] = performanceCriterion(screenIndex, practData)

if isequal(whichPractice, 'mainPractice') || isequal(whichPractice, 'followCannonPractice')
    sumCannonDev = sum(practData.cannonDev >= taskParam.gParam.practiceTrialCriterion);
elseif isequal(whichPractice, 'followOutcomePractice')
    sumCannonDev = sum(practData.controlDev >= taskParam.gParam.practiceTrialCriterion);
end
if sumCannonDev >= 4
    if taskParam.gParam.oddball == false
        
        if isequal(whichPractice, 'mainPractice') || isequal(whichPractice, 'followCannonPractice')
            header = 'Wiederholung der Übung';
            if isequal(subject.group, '1')
                txt = ['In der letzten Übung hast du dich zu häufig '...
                    'vom Ziel der Kanone wegbewegt. Du kannst '...
                    'mehr Kugeln abwehren, wenn du immer auf dem Ziel '...
                    'der Kanone bleibst!\n\nIn der nächsten Runde '...
                    'kannst nochmal üben. Wenn du noch Fragen hast, '...
                    'kannst du dich auch an den Versuchsleiter wenden.'];
            else
                txt = ['In der letzten Übung haben Sie sich zu häufig '...
                    'vom Ziel der Kanone wegbewegt. Sie können '...
                    'mehr Kugeln abwehren, wenn Sie immer auf dem Ziel '...
                    'der Kanone bleiben!\n\nIn der nächsten Runde '...
                    'können Sie nochmal üben. Wenn Sie noch Fragen haben, '...
                    'können Sie sich auch an den Versuchsleiter wenden.'];
            end
        elseif isequal(whichPractice, 'followOutcomePractice')
            header = 'Wiederholung der Übung';
            if isequal(subject.group, '1')
                txt = ['In der letzten Übung hast du die jeweils '...
                    'letzte Kugel zu selten aufgesammelt.\n\nIn der nächsten Runde '...
                    'kannst nochmal üben. Wenn du noch Fragen hast, '...
                    'kannst du dich auch an den Versuchsleiter wenden.'];
            else
                txt = ['In der letzten Übung haben Sie die jeweils '...
                    'letzte Kugel zu selten aufgesammelt.\n\nIn der nächsten Runde '...
                    'können Sie nochmal üben. Wenn Sie noch Fragen haben, '...
                    'können Sie sich auch an den Versuchsleiter wenden.'];
            end
        end
        
    elseif taskParam.gParam.oddball == true
        header = 'Try it again!';
        txt = ['In that block your shield was not always placed '...
            'where the cannon was aiming. Remember: Placing your '...
            'shield where the cannon is aimed will be the best way '...
            'to earn money. '...
            'Now try again. '];
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
    screenIndex = screenIndex + 1;
end

WaitSecs(0.1);
end
end
