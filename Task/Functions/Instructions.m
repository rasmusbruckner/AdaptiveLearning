function Instructions(taskParam, whichPractice, subject)

cannon = true;

Screen('TextFont', taskParam.gParam.window, 'Arial');
Screen('TextSize', taskParam.gParam.window, 50);
sentenceLength = taskParam.gParam.sentenceLength;
if subject.rew == 1
    colRew = 'gold';
    colNoRew = 'silber';
elseif subject.rew == 2
    colRew = 'silber';
    colNoRew = 'gold';
end


if isequal(subject.group, '1')
    DeineVersusIhre = 'Deine';
else
    DeineVersusIhre = 'Ihre';
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
        Screen('TextSize', taskParam.gParam.window, 50);
        
        if ~taskParam.gParam.allThreeConditions
            
            if (isequal(whichPractice, 'mainPractice') && subject.cBal == 1) || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 2)
                txt='Herzlich Willkommen\n\nErster Teil...';
            else
                txt = 'Zweiter Teil...';
            end
            
        elseif taskParam.gParam.allThreeConditions
            
            if (isequal(whichPractice, 'mainPractice') && subject.cBal == 1)...
                    || (isequal(whichPractice, 'mainPractice') && subject.cBal == 2)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 3)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 5)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 4)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 6)
                txt='Herzlich Willkommen\n\nErster Teil...';
            elseif (isequal(whichPractice, 'mainPractice') && subject.cBal == 3)...
                    || (isequal(whichPractice, 'mainPractice') && subject.cBal == 4)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 1)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 6)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 2)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5)
                txt = 'Zweiter Teil...';
            elseif (isequal(whichPractice, 'mainPractice') && subject.cBal == 5)...
                    || (isequal(whichPractice, 'mainPractice') && subject.cBal == 6)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 2)...
                    || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 4)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 1)...
                    || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 3)
                txt = 'Dritter Teil...';
            end
            
        end
        
        while 1
            
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
    end

% kind of done
    function SharedInstructions_MainOddballFollowCannon
        
        screenIndex = 1;
        
        while 1
            
            switch(screenIndex)
                
                case 1
                    
                    txt = sprintf('%s Aufgabe: Kanonenkugeln fangen', DeineVersusIhre);
                    screenIndex = YourTaskScreen(txt, screenIndex);
                    
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
                                'Der orangene Strich zeigt Ihnen die Position deines letzten Schildes. Steuern '...
                                'Sie den orangenen Punkt bitte auf das Ziel '...
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
                                'Kanonenkugel abgefangen. '...
                                'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, '...
                                'zählt es als Treffer.'];
                        else
                            txt=['Das Schild erscheint nach dem '...
                                'Schuss. In diesem Fall haben Sie die '...
                                'Kanonenkugel abgefangen. '...
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
                        txt = sprintf(['Wenn du Kanonenkugeln fängst, '...
                            'kannst du Geld verdienen. Wenn das Schild '...
                            '%s ist, verdienst du 20 CENT wenn du die '...
                            'Kanonenkugel fängst. Wenn das Schild %s '...
                            'ist, verdienst du nichts. Die Größe deines '...
                            'Schildes kann sich jedes Mal ändern. '...
                            'Die Farbe und die Größe des Schildes siehst '...
                            'du erst, nachdem die Kanone geschossen hat. '...
                            'Daher versuchst du am besten jede '...
                            'Kanonenkugel zu fangen.\n\n'...
                            'Um einen Eindruck von der wechselnden Größe '...
                            'und Farbe des Schildes zu bekommen '...
                            'kommt jetzt eine kurze Übung.\n\n'], colRew, colNoRew);
                    else
                        txt = sprintf(['Wenn Sie Kanonenkugeln fangen, '...
                            'können Sie Geld verdienen. Wenn das Schild '...
                            '%s ist, verdienen Sie 20 CENT wenn Sie die '...
                            'Kanonenkugel fangen. Wenn das Schild %s '...
                            'ist, verdienen Sie nichts. Die Größe Ihres '...
                            'Schildes kann sich jedes Mal ändern. '...
                            'Die Farbe und die Größe des Schildes sehen Sie '...
                            'erst, nachdem die Kanone geschossen hat. '...
                            'Daher versuchen Sie am besten jede '...
                            'Kanonenkugel zu fangen.\n\n'...
                            'Um einen Eindruck von der wechselnden Größe '...
                            'und Farbe des Schildes zu bekommen '...
                            'kommt jetzt eine kurze Übung.\n\n'], colRew, colNoRew);
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
                            txt='Versuche die Kanonenkugel jetzt wieder zu fangen.';
                        else
                            txt='Versuchen Sie die Kanonenkugel jetzt wieder zu fangen.';
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
                            txt = sprintf(['Weil du die Kanonenkugel gefangen '...
                                'hast und das Schild %s war, '...
                                'hättest du jetzt 20 CENT verdient.'], colRew);
                        else
                            txt = sprintf(['Weil Sie die Kanonenkugel gefangen '...
                                'haben und das Schild %s war, '...
                                'hätten Sie jetzt 20 CENT verdient.'], colRew);
                        end
                    elseif taskParam.gParam.oddball == true
                        txt = sprintf(['You caught the ball and the shield is %s. '...
                            'So you would earn 20 CENTS.'], colRew);
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
                            
                            txt='Versuche die Kanonenkugel jetzt wieder zu fangen.';
                        else
                            txt='Versuchen Sie bitte die Kanonenkugel wieder zu fangen.';
                            
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
                            
                            txt=sprintf(['Du hast die Kanonenkugel gefangen, '...
                                'aber das Schild war %s. Daher hättest '...
                                'du nichts verdient.'], colNoRew);
                            
                        else
                            
                            txt=sprintf(['Sie haben die Kanonenkugel gefangen, '...
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
                    
                    header = 'Erste Übung';
                    
                    if isequal(whichPractice, 'mainPractice') || isequal(whichPractice, 'followCannonPractice')
                        if isequal(subject.group, '1')
                            txt=['In dieser Übung ist das Ziel so viele '...
                                'Kanonenkugeln wie möglich zu fangen. '...
                                'Die Kanone bleibt meistens an der '...
                                'selben Stelle. Manchmal dreht sich die '...
                                'Kanone allerdings und zielt auf eine '...
                                'andere Stelle. Wenn du den orangenen '...
                                'Punkt GENAU auf die Stelle steuerst, '...
                                'auf die die Kanone zielt, fängst du '...
                                'die MEISTEN Kugeln.\n\nWenn du deinen '...
                                'Punkt zu oft neben die anvisierte '...
                                'Stelle steuerst, wird die Übung wiederholt.'];
                        else
                            txt=['In dieser Übung ist das Ziel so viele '...
                                'Kanonenkugeln wie möglich zu fangen. '...
                                'Die Kanone bleibt meistens an der '...
                                'selben Stelle. Manchmal dreht sich die '...
                                'Kanone allerdings und zielt auf eine '...
                                'andere Stelle. Wenn Sie den orangenen '...
                                'Punkt GENAU auf die Stelle steuern, '...
                                'auf die die Kanone zielt, fangen Sie '...
                                'die MEISTEN Kugeln.\n\nWenn Sie Ihren '...
                                'Punkt zu oft neben die anvisierte '...
                                'Stelle steuern, wird die Übung wiederholt.'];
                        end
                    else
                        
                        if isequal(subject.group, '1')
                            txt=['In dieser Übung ist das Ziel so viele Kanonenkugeln wie möglich aufzusammeln. '...
                                'Du wirst feststellen, dass die Kanone relativ ungenau schießt, aber meistens auf die selbe Stelle zielt. '...
                                'Manchmal dreht sich die Kanone allerdings auch und zielt auf eine andere Stelle. '...
                                'Du verdienst am meisten, wenn du den organgenen Punkt GENAU '...
                                'auf den schwarzen Strich steuerst, weil du so sicher die Kugel aufsammelst. '...
                                '\n\nWenn du die Kugel zu oft nicht aufsammelst, '...
                                'wird die '...
                                'Übung wiederholt.'];
                        else
                            txt=['In dieser Übung ist das Ziel so viele Kanonenkugeln wie möglich aufzusammeln. '...
                                'Sie werden feststellen, dass die Kanone relativ ungenau schießt, aber meistens auf die selbe Stelle zielt. '...
                                'Manchmal dreht sich die Kanone allerdings auch und zielt auf eine andere Stelle. '...
                                'Sie verdienen am meisten, wenn Sie den organgenen Punkt GENAU '...
                                'auf den schwarzen Strich steuern, weil Sie so sicher die Kugel aufsammeln. '...
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
                        header = 'Zweite Übung';
                        
                        if isequal(subject.group, '1')
                            
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
                        else
                            txt=['Weil die Kanone schon sehr alt ist, sind die '...         % noise.
                                'Schüsse ziemlich ungenau. Wenn Sie den orangenen Punkt '...
                                'genau auf die Stelle steuerst, auf die die Kanone '...
                                'zielt, fängen Sie die meisten Kugeln. Durch die '...
                                'Ungenauigkeit der Kanone kann die Kugel aber manchmal '...
                                'auch ein Stück neben die anvisierte Stelle '...
                                'fliegen, wodurch Sie sie dann verpassen.\n\n'...
                                'In der nächsten Übung sollen Sie mit der '...
                                'Ungenauigkeit der Kanone erstmal vertraut werden. '...
                                'Lassen Sie orangenen Punkt bitte immer auf der '...
                                'anvisierten Stelle stehen. Wenn Sie Ihren Punkt zu oft '...
                                'neben die anvisierte Stelle steuern, wird die '...
                                'Übung wiederholt.'];
                        end
                        
                    else
                        header = 'Erste Übung';
                        
                        if isequal(subject.group, '1')
                            
                            txt=['In dieser Übung ist das Ziel so viele Kanonenkugeln wie möglich aufzusammeln. '...
                                'Du wirst feststellen, dass die Kanone relativ ungenau schießt, aber meistens auf die selbe Stelle zielt. '...
                                'Manchmal dreht sich die Kanone allerdings auch und zielt auf eine andere Stelle. '...
                                'Du verdienst am meisten, wenn du den organgenen Punkt GENAU '...
                                'auf den schwarzen Strich steuerst, weil du so sicher die Kugel aufsammelst. '...
                                '\n\nWenn du die Kugel zu oft nicht aufsammelst, '...
                                'wird die '...
                                'Übung wiederholt.'];
                        else
                            
                            txt=['In dieser Übung ist das Ziel so viele Kanonenkugeln wie möglich aufzusammeln. '...
                                'Sie werden feststellen, dass die Kanone relativ ungenau schießt, aber meistens auf die selbe Stelle zielt. '...
                                'Manchmal dreht sich die Kanone allerdings auch und zielt auf eine andere Stelle. '...
                                'Sie verdienen am meisten, wenn Sie den organgenen Punkt GENAU '...
                                'auf den schwarzen Strich steuern, weil Sie so sicher die Kugel aufsammeln. '...
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
                    
                    txt = 'Deine Aufgabe: Kanonenkugeln fangen';
                    screenIndex = YourTaskScreen(txt, screenIndex);
                    
                case 2
                    
                    if subject.cBal == 1 || subject.cBal == 2 || subject.cBal == 3
                        header = 'Erste Übung';
                    else
                        header = 'Dritte Übung';
                    end
                    
                    
                    
                    if isequal(subject.group, '1')
                        
                        txt = ['In dieser Aufgabe sollst du wieder versuchen '...
                            'möglichst viele Kanonenkugeln zu fangen. Da du '...
                            'die Kanone jetzt die ganze Zeit siehst, '...
                            'steuerst du dein Schild am besten '...
                            'genau auf das Ziel der Kanone (schwarze Nadel).'...
                            '\\Beachte allerdings, dass du jetzt nicht mehr '...
                            'sehen kannst wie die Kanonenkugel fliegt.'];
                    else
                        txt = ['In dieser Aufgabe sollen Sie wieder versuchen '...
                            'möglichst viele Kanonenkugeln zu fangen. Da Sie '...
                            'die Kanone jetzt die ganze Zeit sehen, '...
                            'steuern Sie Ihr Schild am besten '...
                            'genau auf das Ziel der Kanone (schwarze Nadel).'...
                            '\\Beachten Sie bitte, dass Sie jetzt nicht mehr '...
                            'sehen können wie die Kanonenkugel fliegt.'];
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
                    
                case 3
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
                    if subject.cBal == 4 || subject.cBal == 5 || subject.cBal == 6
                        header = 'Erste Übung';
                    else
                        header = 'Dritte Übung';
                    end
                    
                    if isequal(subject.group, '1')
                        
                        txt = ['Ok, bis jetzt kanntest du das Ziel '...
                            'der Kanone und du konntest die meisten '...
                            'Kugeln abfangen. Im nächsten '...
                            'Übungsdurchgang wird die Kanone nicht '...
                            'mehr sichtbar sein. Anstelle der '...
                            'Kanone siehst du ab jetzt ein Kreuz '...
                            'und auch wo die Kanonenkugeln landen.\n\n'...
                            'Um weiterhin viele Kanonenkugeln '...
                            'fangen zu können, musst du aufgrund '...
                            'der Landeposition einschätzen, auf '...
                            'welche Stelle die Kanone zielt und '...
                            'den orangenen Punkt auf diese Position '...
                            'steuern. Wenn du denkst, dass die '...
                            'Kanone auf eine neue Stelle zielt, '...
                            'solltest du auch den orangenen Punkt '...
                            'dort hin bewegen.'];
                    else
                        txt = ['Ok, bis jetzt kannten Sie das Ziel '...
                            'der Kanone und Sie konnten die meisten '...
                            'Kugeln abfangen. Im nächsten '...
                            'Übungsdurchgang wird die Kanone nicht '...
                            'mehr sichtbar sein. Anstelle der '...
                            'Kanone sehen Sie ab jetzt ein Kreuz '...
                            'und auch wo die Kanonenkugeln landen.\n\n'...
                            'Um weiterhin viele Kanonenkugeln '...
                            'fangen zu können, müssen Sie aufgrund '...
                            'der Landeposition einschätzen, auf '...
                            'welche Stelle die Kanone zielt und '...
                            'den orangenen Punkt auf diese Position '...
                            'steuern. Wenn Sie denken, dass die '...
                            'Kanone auf eine neue Stelle zielt, '...
                            'solltest Sie auch den orangenen Punkt '...
                            'dort hin bewegen.'];
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
                    
                case 2
                    break
            end
        end
        
    end

    function FollowOutcomeInstructions
        
        screenIndex = 1;
        while 1
            switch(screenIndex)
                
                case 1
                    
                    txt = sprintf('%s Aufgabe: Kanonenkugeln einsammeln', DeineVersusIhre);
                    screenIndex = YourTaskScreen(txt, screenIndex);
                    
                case 2
                    
                    screenIndex = FirstCannonSlide(screenIndex);
                    
                case 3
                    
                    [screenIndex, Data] = PressSpaceToInitiateCannonShot(screenIndex, true);
                    
                case 4
                    
                    if isequal(subject.group, '1')
                        
                        txt=['Der schwarze Strich zeigt dir die Position der letzten Kugel. '...
                            'Der orangene Strich zeigt dir die Position deines letzten Schildes. Bewege den orangenen Punkt zur Stelle der letzten Kanonenkugel '...
                            'und drücke LEERTASTE um die Kugel aufzusammeln. '...
                            'Gleichzeitig schießt die Kanone dann eine neue Kugel ab.'];
                    else
                        txt=['Bewegen Sie den orangenen Punkt zur Stelle der letzten Kanonenkugel '...
                            '(schwarzer Strich) und drücken Sie bitte LEERTASTE um die Kugel aufzusammeln. '...
                            'Gleichzeitig schießt die Kanone dann eine neue Kugel ab.'];
                    end
                    Data.distMean = 35;
                    Data.outcome = 290;
                    [screenIndex, Data] = MoveSpotToLastOutcome(screenIndex, Data, txt);
                    
                case 5
                    
                    if isequal(subject.group, '1')
                        txt=['Sehr gut! Du hast die vorherige Kanonenkugel aufgesammelt. '...
                            'Wie du sehen kannst hat die Kanone auch eine neue Kugel abgeschossen, '...
                            'die du im nächsten Durchgang aufsammeln kannst.'];
                        
                    else
                        txt=['Sehr gut! Sie haben die vorherige Kanonenkugel aufgesammelt. '...
                            'Wie Sie sehen können hat die Kanone auch eine neue Kugel abgeschossen, '...
                            'die Sie im nächsten Durchgang aufsammeln können.'];
                    end
                    distMean = 35;
                    Data.distMean = 35;
                    Data.outcome = 35;
                    screenIndex = YouDidNotCollectTheCannonBall_TryAgain(screenIndex, Data, distMean, txt);
                    
                case 6
                    
                    if isequal(subject.group, '1')
                        txt=['Bewege den orangenen Punkt jetzt wieder zur Stelle der letzten Kanonenkugel '...
                            '(schwarzer Strich) und drücke LEERTASTE um die Kugel aufzusammeln.'];
                    else
                        txt=['Bewegen Sie den orangenen Punkt jetzt wieder zur Stelle der letzten Kanonenkugel '...
                            '(schwarzer Strich) und drücken Sie bitte LEERTASTE um die Kugel aufzusammeln.'];
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
                            'kannst du Geld verdienen. Wenn das Schild %s '...
                            'ist, verdienst du 20 CENT wenn du die '...
                            'Kanonenkugel aufsammelst. Wenn das Schild %s '...
                            'ist, verdienst du nichts. Die Größe deines '...
                            'Schildes kann sich jedes Mal ändern. '...
                            'Die Farbe und die Größe des Schildes siehst '...
                            'du erst, nachdem die Kanone geschossen hat. '...
                            'Daher versuchst du am besten jede Kanonenkugel '...
                            'aufzusammeln.\n\nUm einen Eindruck von der '...
                            'wechselnden Größe und Farbe des Schildes zu bekommen '...
                            'kommt jetzt eine kurze Übung.'], colRew, colNoRew);
                        
                    else
                        
                        txt = sprintf(['Wenn Sie Kanonenkugeln aufsammeln, '...
                            'können Sie Geld verdienen. Wenn das Schild %s '...
                            'ist, verdienen Sie 20 CENT wenn Sie die '...
                            'Kanonenkugel aufsammeln. Wenn das Schild %s '...
                            'ist, verdienen Sie nichts. Die Größe Ihres '...
                            'Schildes kann sich jedes Mal ändern. '...
                            'Die Farbe und die Größe des Schildes sehen '...
                            'Sie erst, nachdem die Kanone geschossen hat. '...
                            'Daher versuchen Sie am besten jede Kanonenkugel '...
                            'aufzusammeln.\n\nUm einen Eindruck von der '...
                            'wechselnden Größe und Farbe des Schildes zu bekommen '...
                            'kommt jetzt eine kurze Übung.'], colRew, colNoRew);
                        
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
                        
                        txt = sprintf(['Weil du die Kanonenkugel aufgesammelt '...
                            'hast und das Schild %s war, '...
                            'hättest du jetzt 20 CENT verdient.'], colRew);
                    else
                        
                        
                        txt = sprintf(['Weil Sie die Kanonenkugel aufgesammelt '...
                            'haben und das Schild %s war, '...
                            'hätten Sie jetzt 20 CENT verdient.'], colRew);
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
                        txt= ['Versuchen Sie bitte die letzte Kanonenkugel extra nicht '...
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
                    
                    break
            end
        end
    end

    function [screenIndex] = YourTaskScreen(txt, screenIndex)
        while 1
            Screen('TextFont', taskParam.gParam.window, 'Arial');
            Screen('TextSize', taskParam.gParam.window, 30);
            DrawFormattedText(taskParam.gParam.window, txt,...
                'center', 100, [255 255 255], sentenceLength);
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
                        'Kreises. Mit dem orangenen Punkt kannst du angeben, '...
                        'wo du dein Schild platzieren möchtest, um die '...
                        'Kanonenkugel abzufangen.\nDu kannst den Punkt mit den '...
                        'grünen und gelben Tasten steuern. '...
                        'Grün kannst du für schnelle Bewegungen und '...
                        'gelb für langsame Bewegungen benutzen.'];
                else
                    txt=['Eine Kanone zielt auf eine Stelle des '...
                        'Kreises. Mit dem orangenen Punkt können Sie angeben, '...
                        'wo Sie Ihr Schild platzieren möchten, um die '...
                        'Kanonenkugel abzufangen.\nSie können den Punkt mit den '...
                        'grünen und gelben Tasten steuern. '...
                        'Grün können Sie für schnelle Bewegungen und '...
                        'gelb für langsame Bewegungen benutzen.'];
                    
                end
            else
                if isequal(subject.group, '1')
                    txt=['Eine Kanone zielt auf eine Stelle des '...
                        'Kreises. Mit dem orangenen Punkt kannst du angeben, '...
                        'wo du dein Schild platzieren möchtest, um die '...
                        'Kanonenkugel aufzusammeln.\nDu kannst den Punkt mit den '...
                        'grünen und gelben Tasten steuern. '...
                        'Grün kannst du für schnelle Bewegungen und '...
                        'gelb für langsame Bewegungen benutzen.'];
                else
                    txt=['Eine Kanone zielt auf eine Stelle des '...
                        'Kreises. Mit dem orangenen Punkt können Sie angeben, '...
                        'wo Sie Ihr Schild platzieren möchten, um die '...
                        'Kanonenkugel aufzusammeln.\nSie können den Punkt mit den '...
                        'grünen und gelben Tasten steuern. '...
                        'Grün können Sie für schnelle Bewegungen und '...
                        'gelb für langsame Bewegungen benutzen.'];
                end
            end
        elseif taskParam.gParam.oddball == true
            txt=['A cannon is aimed at the circle. Indicate where '...
                'you would like to place your shield with the orange spot. '...
                'You can move the orange spot with the green and yellow '...
                'buttons. Green is for fast movements and yellow is '...
                'for slow movements.'];
        end
        
        
        Screen('TextSize', taskParam.gParam.window, 30);
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
        WaitSecs(0.5)
        
        
        Data.tickMark=true;
        
        %Data.outcome=320;
        %Data.pred = 360;
        Data.distMean=distMean
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
        WaitSecs(0.5)
        
        
        Data.tickMark=true;
        
        %Data.outcome=320;
        %Data.pred = 360;
        Data.distMean=distMean
        
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
                        
                        txt=['Du hast die Kanonenkugel abgefangen. '...
                            'Versuche die Kanonenkugel diesmal zu verpassen!'];
                    else
                        
                        txt=['Sie haben die Kanonenkugel abgefangen. '...
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
            header = 'Das Schild';
            
            %                         txt = sprintf(['Wenn du Kanonenkugeln fängst, '...
            %                             'kannst du Geld verdienen. Wenn das Schild '...
            %                             '%s ist, verdienst du 20 CENT wenn du die '...
            %                             'Kanonenkugel fängst. Wenn das Schild %s '...
            %                             'ist, verdienst du nichts. Die Größe deines '...
            %                             'Schildes kann sich jedes Mal ändern. '...
            %                             'Die Farbe und die Größe des Schildes kennst '...
            %                             'du erst, nachdem die Kanone geschossen hat. '...
            %                             'Daher versuchst du am besten jede '...
            %                             'Kanonenkugel zu fangen.\n\n'...
            %                             'Um einen Eindruck von der wechselnden Größe '...
            %                             'und Farbe des Schildes zu bekommen '...
            %                             'kommt jetzt eine kurze Übung.\n\n'...
            %                             'Die Position des letzten Balls wird dir '...
            %                             'mit einem kleinen schwarzen Strich angezeigt.\n\n'...
            %                             'Außerdem wird die Position deines '...
            %                             'orangenen Punktes aus dem vorherigen Durchgang mit '...
            %                             'einem orangenen Strich angezeigt.'], colRew, colNoRew);
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
                'is %s you will earn 20 CENTS for catching '...
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
                'orange line.'], colRew, colNoRew);
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
                
                txt=['Das Ziel der Kanone wird mit der '...
                    'schwarzen Nadel angezeigt. Drücke LEERTASTE, '...
                    'damit die Kanone schießt.'];
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
        WaitSecs(0.5)
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
                    
                    txt=sprintf(['Du hast die Kanonenkugel aufgesammelt, '...
                        'aber das Schild war %s. Daher hättest '...
                        'du nichts verdient.'], colNoRew);
                else
                    txt=sprintf(['Sie haben die Kanonenkugel aufgesammelt, '...
                        'aber das Schild war %s. Daher hätten '...
                        'Sie nichts verdient.'], colNoRew);
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
                    
                    if isequal(subject.group, '1')
                        
                        header = 'Wiederholung der Übung';
                        txt = ['In der letzten Übung hast du dich zu häufig '...
                            'vom Ziel der Kanone wegbewegt. Du kannst '...
                            'mehr Kugeln fangen, wenn du immer auf dem Ziel '...
                            'der Kanone bleibst!\n\nIn der nächsten Runde '...
                            'kannst nochmal üben. Wenn du noch Fragen hast, '...
                            'kannst du dich auch an den Versuchsleiter wenden.'];
                    else
                        txt = ['In der letzten Übung haben Sie sich zu häufig '...
                            'vom Ziel der Kanone wegbewegt. Sie können '...
                            'mehr Kugeln fangen, wenn Sie immer auf dem Ziel '...
                            'der Kanone bleiben!\n\nIn der nächsten Runde '...
                            'können Sie nochmal üben. Wenn Sie noch Fragen haben, '...
                            'können Sie sich auch an den Versuchsleiter wenden.'];
                    end
                elseif isequal(whichPractice, 'followOutcomePractice')
                    if isequal(subject.group, '1')
                        header = 'Wiederholung der Übung';
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
