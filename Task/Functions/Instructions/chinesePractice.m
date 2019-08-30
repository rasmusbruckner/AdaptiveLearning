function chinesePractice(taskParam, subject)
%CHINESEPRACTICE   This function runs the chinese-condition-specific instructions
%
%   Input
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%
%   Output
%       ~


% Initialize to first screen
screenIndex = 1;

while 1
    
    switch(screenIndex)
        
        case 1
            if taskParam.gParam.language == 1
                header = 'Erste Übung';
                txt = ['Sehr gut! Du wurdest zum Beschützer der Galaxie ernannt und sollst nun zwei Planeten '...
                    'vor den Kanonenkugeln beschützen. Du kannst die Planeten deiner Galaxie anhand ihrer Farbe unterscheiden.\n\n'...
                    'Der Gegner hat auf jeden deiner Planeten genau eine Raumschiffkanone gerichtet. Die '...
                    'Positionen der Kanonen bleiben während eines Aufgabenblocks gleich. Es ist zufällig, welcher Planet gerade angegriffen '...
                    'wird. Es wird jedoch immer nur ein Planet zurzeit beschossen.\n\nMerke dir, auf welche Stelle der '...
                    'Gegner seine Kanone auf dem jeweiligen Planeten gerichtet hat. So kannst du bei einem Wechsel des Planeten dein Schild '...
                    'direkt an dieser Stelle positionieren. Um möglichst viele Kanonenkugeln abzuwehren, solltest du dein Schild auf jedem deiner Planeten immer '...
                    'genau an der Stelle positionieren, auf die der Gegner mit seiner Kanone zielt.'];
            elseif taskParam.gParam.language == 2
                header = 'First Exercise';
                txt = ['Very good! You have been named the protector of the galaxy and you now have two planets to protect. \n\n'...
                    'You can differentiate the planets of your galaxy by their colour.\n\n'...
                    'The enemy has aimed exactly one spacecraft cannon on each of your planets\n\n' ...
                    'The cannon position remains the same during a task block.\n It is just a matter of chance which planet is attacked.\n\n'...
                    'Only one planet is ever fired on at any given moment. \n\n'...
                    'Try to know where the enemy has directed his cannon on the respective planet, so you can adjust your shield location accordingly. \n\n'...
                    'To ward off as many cannonballs as possible, you should always try to position your shield exactly at the position the enemy aims his cannon.'];
            end
            feedback = false;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            if fw == 1
                screenIndex = screenIndex + 1;
            end
            WaitSecs(0.1);
            
        case 2
            
            condition = 'chinesePractice_1';
            %LoadData = 'CP_NoNoise';
            taskParam.gParam.nContexts = 1;
            taskParam.gParam.nStates = 2;
            [taskData, ~] = al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject);
            screenIndex = screenIndex + 1;
            WaitSecs(0.1);
            
        case 3
            
            sumCannonDev = sum(abs(taskData.cannonDev) >= 10);
            
            if sumCannonDev >= 4
                if taskParam.gParam.language == 1
                    
                    header = 'Wiederholung der Übung!';
                    txt = ['In der letzten Übung hast du dich zu häufig vom Ziel der Kanone wegbewegt. '...
                        'Du kannst mehr Raketen abwehren, wenn du immer auf dem Ziel der Kanone bleibst!'...
                        '\n\nIn der nächsten Runde kannst nochmal üben. Wenn du noch Fragen hast, kannst du '...
                        'dich auch an den Versuchsleiter wenden.'];
                elseif taskParam.gParam.language == 2
                    header = 'English';
                    txt = 'English';
                end
                
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                if fw == 1
                    screenIndex = screenIndex - 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
            else
                if taskParam.gParam.language == 1
                    
                    header = 'Zweite Übung';
                    txt = ['Aufgrund unterschiedlicher Gravitationskräfte in der Atmosphäre sind die Schüsse der Kanonen ungenau. '...
                        'Das heißt, auch wenn du genau auf das Ziel der Kanone gehst, kannst du die Kanonenkugeln verfehlen. Es ist zufällig, wie '...
                        'ungenau die Kanone ist. Deshalb wehrst du die meisten Kanonenkugeln ab, wenn du den orangenen Punkt genau auf der '...
                        'Stelle positionierst, auf die die jeweilige Kanone gerade zielt.\n\nIn der nächsten '...
                        'Übung sollst du mit der Ungenauigkeit der Kanonen vertraut werden. Lasse den orangenen Punkt immer auf der '...
                        'anvisierten Stelle der jeweiligen Kanone stehen. Wenn du deinen Punkt zu oft neben '...
                        'die anvisierte Stelle steuerst, wird die Übung wiederholt.'];
                elseif taskParam.gParam.language == 2
                    header = 'Second Exercise';
                    txt = ['Due to different graviational forces, the gunshots are not perfectly accurate. \n\n'...
                        'This means that even if you place your shield directly at the target, you can still miss. \n\n'...
                        'It is totally random how inaccurate the cannonball is. \n\n'...
                        'So the best way to defend your planet is still to place shields directly on the position where the cannon is aiming \n\n'...
                        'In the next practice phase, you will become familiar with the inaccuracy of the cannons.\n\n'...
                        'Always leave the orange dot on the targeted position.\n\n'...
                        'If you put your point next to the target too many times, the exercise will repeat.'];
                end
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                if fw == 1
                    screenIndex = screenIndex + 1;
                end
                
            end
            WaitSecs(0.1);
            
        case 4
            
            condition = 'chinesePractice_2';
            taskParam.gParam.nContexts = 1;
            taskParam.gParam.nStates = 2;
            [taskData, ~] = al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(1), condition, subject);
            sumCannonDev = sum(abs(taskData.cannonDev) >= 10);
            screenIndex = screenIndex + 1;
            WaitSecs(0.1);
            
        case 5
            if sumCannonDev >= 4
                if taskParam.gParam.language == 1
                    
                    header = 'Wiederholung der Übung!';
                    txt = ['In der letzten Übung hast du dich zu häufig vom Ziel der Kanone wegbewegt. '...
                        'Du kannst mehr Raketen abwehren, wenn du immer auf dem Ziel der Kanone bleibst!'...
                        '\n\nIn der nächsten Runde kannst nochmal üben. Wenn du noch Fragen hast, kannst du '...
                        'dich auch an den Versuchsleiter wenden.' ];
                elseif taskParam.gParam.language == 2
                    header = 'English';
                    txt = 'English';
                end
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header,txt, feedback);
                if fw == 1
                    screenIndex = screenIndex - 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
            else
                if taskParam.gParam.language == 1
                    
                    header = 'Dritte Übung';
                    txt = ['Deine Planeten werden jetzt von zwei Gegnern beschossen. Du kannst die Gegner anhand ihrer Symbole voneinanander '...
                        'unterscheiden. Wie zuvor hat jeder Gegner auf jeden deiner Planeten genau eine Kanone gerichtet. Die Positionen der Kanonen bleiben '...
                        'während eines Aufgabenblocks gleich.\n\nDeine Planeten werden einige Zeit von dem selben Gegner beschossen. Gelegentlich wird '...
                        'jedoch auch der andere Gegner für einige Zeit auf deine Planeten schießen. Es ist vollkommen zufällig, welcher Gegner gerade deine Planeten '...
                        'beschießt. Die Planeten werden jedoch immer nur von einem Gegner zurzeit beschossen.\n\n Merke dir wieder, auf welche Stelle der '...
                        'jeweilige Gegner auf dem jeweiligen Planeten seine Kanone gerichtet hat. Du kannst dann bei einem Wechsel des Gegners oder des Planeten dein Schild '...
                        'direkt an dieser Stelle positionieren.'];
                elseif taskParam.gParam.language == 2
                    header = 'Third Exercise';
                    txt = ['Your planets are now being shot at by two enemies!\n\n'...
                        'You can tell them apart by the symbols on their spaceships.\n\n'...
                        'Like before, each enemy targets only one spot on your planet and that position does not change in a task block.\n\n'...
                        'Sometimes, your planet will be shot at by one enemy.\n\n'...
                        'Other times, a different enemy will start shooting at your planet.\n\n'...
                        'It is completely random which enemy is shooting your planet at any given moment.\n\n'...
                        'But, there will always only be one enemy who will be shooting at your planet at a time. \n\n'...
                        'Try to remember which position each enemy targets on each planet.\n\n'...
                        'If the enemy or planet changes, try to position your shield on the right spot.'];
                end
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                if fw == 1
                    screenIndex = screenIndex + 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
            end
            WaitSecs(0.1);
            
        case 6
            
            condition = 'chinesePractice_3';
            %cannon = true;
            taskParam.symbol = true;
            taskParam.gParam.nContexts = 2;
            taskParam.gParam.nStates = 2;
            [taskData, ~] = al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(1), condition, subject);
            sumCannonDev = sum(abs(taskData.cannonDev) >= 10);
            screenIndex = screenIndex + 1;
            WaitSecs(0.1);
            
        case 7
            
            if sumCannonDev >= 4
                if taskParam.gParam.language == 1
                    
                    header = 'Wiederholung der Übung!';
                    txt = ['In der letzten Übung hast du dich zu häufig vom Ziel der Kanone wegbewegt. Du kannst mehr Raketen abwehren, wenn du '...
                        'immer auf dem Ziel der Kanone bleibst!\n\nIn der nächsten Runde kannst nochmal üben. Wenn du noch Fragen hast, kannst du '...
                        'dich auch an den Versuchsleiter wenden.'];
                elseif taskParam.gParam.language == 2
                    header = 'English';
                    txt = 'English';
                end
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header,txt, feedback);
                if fw == 1
                    screenIndex = screenIndex - 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
            else
                if taskParam.gParam.language == 1
                    
                    header = 'Vierte Übung';
                    
                    txt = ['Oh nein! Die gegnerischen Raumschiffe haben ihre Tarnfunktion aktiviert und sind '...
                        'jetzt unsichtbar. Du wirst die Kanonen der Gegner jetzt nicht mehr sehen können. '...
                        'Ansonsten bleibt alles so, wie du es schon geübt hast.\n\nDie Kanonen der '...
                        'Gegner zielen und schießen genau so wie vorher. Du verdienst weiterhin für jede '...
                        'abgewehrte Kanonenkugel Geld. Nun musst du aber herausfinden, wohin die unsichtbaren '...
                        'Kanonen zielen und dein Schild entsprechend positionieren. Du kannst die Stellen, '...
                        'an denen die Kanonenkugeln auf dem Planeten landen, als Information nutzen, um dein '...
                        'Schild zu positionieren.\n\nDu solltest dir wieder merken, auf welche Stelle der '...
                        'jeweilige Gegner auf dem jeweiligen Planeten seine Kanone gerichtet hat, '...
                        'auch wenn du die Kanonen jetzt nicht mehr sehen kannst. Du kannst dann bei '...
                        'einem Wechsel des Gegners oder des Planeten dein Schild direkt an dieser '...
                        'Stelle positionieren.'];
                elseif taskParam.gParam.language == 2
                    header = 'Fourth Exercise';
                    txt = ['Oh no! The enemy spaceships have activated their cloaking device and now they are invisible!\n\n'...
                        'You will not see the enemy cannons anymore, but everything else will remain the same as in the practice trials.\n\n'...
                        'The enemy cannons target and shoot just like before.\n\n'...
                        'You will still earn points for every cannonball you cacth. \n\n'...
                        'But now you have to figure out where the invisible cannons are targeting your planet and position your shield accordingly. \n\n'...
                        'You can use the spots where the cannonballs have landed on your planet as cues to position your shield.\n\n'...
                        'Again, try to remember which spot each enemy on each planet is targetting, even if the cannons are invisible.\n\n'...
                        'If an enemy or a planet changes, try to position your shield on the right spot.'];
                end
                feedback = false;
                fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
                if fw == 1
                    screenIndex = screenIndex + 1;
                elseif bw == 1
                    screenIndex = screenIndex - 2;
                end
                WaitSecs(0.1);
            end
            
        case 8
            
            break
    end
    
end
end