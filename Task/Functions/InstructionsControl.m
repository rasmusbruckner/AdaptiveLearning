function InstructionsControl(taskParam, subject)
% Function BattleShipsControlInstructions is an intro for the control session.

KbReleaseWait();

screenIndex = 1;
while 1
    switch(screenIndex)
        case 1
            % Screen 1.
            txtPressEnter = 'Weiter mit Enter';
            header = 'Kontrollaufgabe';
%             if isequal(taskParam.gParam.computer, 'D_Pilot')
%                 txt = ['Zum Abschluss kommt eine Gedächtnisaufgabe. Hier sollst du dir '...
%                     'die Position des Bootes merken\n\nund den blauen Punkt '...
%                     'daraufhin genau auf diese Position steuern.'];
%             elseif isequal(taskParam.gParam.computer, 'Dresden')
%                 txt = ['Zum Abschluss kommt eine Gedächtnisaufgabe. Hier sollst du dir '...
%                     'die\n\nPosition des Bootes merken und den blauen Punkt '...
%                     'daraufhin genau\n\nauf diese Position steuern.'];
%             else
                txt = ['Zum Abschluss kommt eine Kontrollaufgabe. Hier sollst du den '...
                    'blauen Punkt immer auf die Stelle der zuletzt abgeschossenen '...
                    'Kanonenkugel steuern. Das heißt, immer genau auf das Ende des '...
                    'schwarzen Balken.\n\n'...
                    'Du kannst die Aufgabe jetzt erstmal üben. Wenn du den blauen Punkt zu '...
                    'oft neben das Ende des schwarzen Balkens steuerst, muss die Übung '...
                    'wiederholt werden.'];
%             end
            feedback = false;
            %BigScreen(taskParam, txtPressEnter, header, txt, feedback)
            [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
         
       case 2
            condition = 'practice';
            VolaIndication(taskParam, taskParam.strings.txtLowVola, taskParam.strings.txtPressEnter)
            KbReleaseWait();
            [taskData, Data] = Main(taskParam, taskParam.gParam.vola(1), taskParam.gParam.sigma(1), condition, subject);


            
        sumCannonDev = sum(taskData.memErr(2:end) >= 10)
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
            
       
        case 3
            button = taskParam.keys.space;
%             if isequal(taskParam.gParam.computer, 'D_Pilot')
%                 txt = ['...und steuere den blauen Punkt auf die Postition, die du '...
%                     'dir gemerkt hast. Drücke dann LEERTASTE.'];
%             elseif isequal(taskParam.gParam.computer, 'Dresden')
%                 txt = ['...und steuere den blauen Punkt auf die Postition, die\n\ndu '...
%                     'dir gemerkt hast. Drücke dann LEERTASTE.'];
%             else
                txt = ['...und steuere den blauen Punkt auf die Postition, die du '...
                    'dir gemerkt\n\nhast. Drücke dann LEERTASTE.'];
%             end
            cannon = false;
            distMean = 100
            predErr = 10
            [taskParam, fw, bw, Data] = InstrLoopTxt(taskParam, txt, cannon, 'space', distMean);
            time = GetSecs;
            
            % Show baseline 2.
            LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
            DrawCross(taskParam)
            DrawCircle(taskParam)
            Screen('DrawingFinished', taskParam.gParam.window);
            Screen('Flip', taskParam.gParam.window, time + 0.1)
            
            % Show boat.
            LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
            DrawCircle(taskParam)
            if subject.rew == '1'
                RewardTxt = Reward(taskParam, 'gold');
            else
                RewardTxt = Reward(taskParam, 'silver');
            end
            Screen('DrawingFinished', taskParam.gParam.window);
            Screen('Flip', taskParam.gParam.window, time + 1.1);
            Screen('Close', RewardTxt);
            
            % Show baseline 3.
            LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
            DrawCircle(taskParam)
            DrawCross(taskParam)
            Screen('DrawingFinished', taskParam.gParam.window);
            Screen('Flip', taskParam.gParam.window, time + 1.6);
            WaitSecs(1);
            
            KbReleaseWait();
            
            header = 'Start der Kontrollaufgabe';
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
            feedback = false
            %BigScreen(taskParam, txtPressEnter, header, txt, feedback)
            [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            elseif bw == 1
                screenIndex = screenIndex - 1;
            end
        case 4
            break
    end
    
end
end