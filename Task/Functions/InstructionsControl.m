function InstructionsControl(taskParam, subject)
% Function BattleShipsControlInstructions is an intro for the control session.


screenIndex = 1;
while 1
    switch(screenIndex)
        case 1
            
            txtPressEnter = 'Weiter mit Enter';
            header = 'Genauigkeitsaufgabe';
            
            txt = ['Zum Abschluss kommt eine Aufgabe um deine Genauigkeit zu untersuchen. Hier sollst du den '...
                'blauen Punkt immer auf die Stelle der zuletzt abgeschossenen '...
                'Kanonenkugel steuern. Das heißt, immer GENAU auf das Ende des '...
                'schwarzen Balkens.\n\n'...
                'Diesmal verdienst du 10 CENT, wenn dein blaue Punkt auf der Stelle der letzten Kanonenkugel war UND wenn diese Kugel eine goldene Kugel war. '...
                'In allen anderen Fällen verdienst du wieder nichts. '...
                'Du kannst die Aufgabe jetzt erstmal üben. Wenn du den blauen Punkt zu '...
                'ungenau positionierst, muss die Übung '...
                'wiederholt werden.'];
            
            feedback = false;
            
            [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            
            
            
        case 2
            txt = ['Steuere den blauen Punkt jetzt an das Ende des schwarzen Balkens, '...
                'dass die Mitte des Punktes auf der Position der letzten Kanonenkugel ist.'];
            predErr = 90
            rawPredErr = 90
            pred = 0
            outcome = 90
            distMean = 90
            Data = struct(taskParam.fieldNames.predErr, predErr, taskParam.fieldNames.rawPredErr, rawPredErr, taskParam.fieldNames.pred, pred, taskParam.fieldNames.outcome, outcome);
            
            cannon = false
            
            [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt, cannon, 'space', distMean, Data);
            
            if Data.predErr >= 9
                
                while 1
                    
                    txt=['Leider hast du die Kanonenkugel vefehlt. Versuche es noch einmal!'];
                    
                    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
                    DrawCircle(taskParam);
                    DrawCross(taskParam);
                    PredictionSpot(taskParam);
                    
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
            
            
        case 3
            
            
            header = 'Kurze Übung';
            
            txt = ['Sehr gut! In der nächsten Übung kannst du jetzt kurz üben, '...
                'den blauen Punkt so GENAU wie möglich auf die Position der letzten Kanonenkugel zu steuern. '...
                'Wenn du zu häufig von der Position abweichst, wird die Übung wiederholt.'...
                ];
            
            feedback = false;
            [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            
        case 4
            condition = 'practiceCont';
            %VolaIndication(taskParam, taskParam.strings.txtLowVola, taskParam.strings.txtPressEnter)
            %KbReleaseWait();
            [taskData, Data] = Main(taskParam, taskParam.gParam.vola(1), taskParam.gParam.sigma(1), condition, subject);
            
            
            
            sumCannonDev = sum(taskData.memErr(2:end) >= 9)
            if sumCannonDev >= 5
                
                header = 'Wiederholung der Übung';
                txt = ['In der letzten Übung warst du zu ungenau. '...
                    'Versuche noch einmal, mit der Mitte des Punktes '...
                    'genau auf das Ende des schwarzen Balkens zu gehen!\n\n'...
                    'Wenn du noch Fragen hast, kannst du dich auch an den Versuchsleiter wenden.']
                feedback = false
                [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                
                
                
                
            else
                screenIndex = screenIndex + 1;
                
            end
            
            
        case 5
            
            header = 'Start der Genauigkeitsaufgabe';
            if subject.rew == '1'
                if isequal(taskParam.gParam.computer, 'D_Pilot')
                    txt = ['Denke daran, dass du den blauen Punkt ab jetzt immer auf '...
                        'die letzte Position des Kanonekugel steuerst.\nWenn du dir '...
                        'die letzte Position richtig gemerkt hast, bekommst du...'...
                        'Goldenes Boot: 10 CENT Steine: Hier verdienst du '...
                        'leider nichts\nBitte vermeide Augenbewegungen und '...
                        'blinzeln wieder so gut wie möglich'];
                elseif isequal(taskParam.gParam.computer, 'Dresden')
                    txt = ['Denke daran, dass du den blauen Punkt ab jetzt immer auf '...
                        'die letzte Position des Bootes steuerst.\nWenn du dir '...
                        'die letzte Position richtig gemerkt hast, bekommst du...'...
                        'Goldenes Boot: 10 CENTSteine: Hier verdienst du '...
                        'leider nichts\nBitte vermeide Augenbewegungen und '...
                        'blinzeln\n\nwieder so gut wie möglich'];
                else
                    txt = ['Denke daran, dass du den blauen Punkt ab jetzt immer auf '...
                        'die letzte Position des Bootes steuerst.\nWenn du dir die letzte Position richtig gemerkt hast, bekommst du... Goldenes Boot: 10 CENT Steine: Hier verdienst du leider nichts\nBitte vermeide Augenbewegungen und blinzeln wieder so gut wie möglich'];
                end
            else
                txt = ['Denke daran, dass du den blauen Punkt ab jetzt immer auf '...
                    'die letzte Position des Bootes steuerst.\nWenn du dir die letzte Position richtig gemerkt hast, bekommst du...Silbernes Boot: 10 CENT Sand: Hier verdienst du leider nichts\nBitte vermeide Augenbewegungen und blinzeln wieder so gut wie möglich.'];
            end
            feedback = false;
            [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
            
            
        case 6
            break
    end
    
end
end