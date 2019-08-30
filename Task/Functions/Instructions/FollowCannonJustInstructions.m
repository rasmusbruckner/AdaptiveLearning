function FollowCannonJustInstructions
%FOLLOWCANNONJUSTINSTRUCTIONS   This function runs the instruction for the follow-cannon version of the Dresden experiment
%
%   Input
%       ~
%
%    Output
%       ~


if subject.cBal == 1 || subject.cBal == 2 || subject.cBal == 3
    screenIndex = 1;
else
    screenIndex = 2;
    
end

while 1
    switch(screenIndex)
        
        case 1
            
            txt = 'Kanonenkugeln Abwehren';
            screenIndex = YourTaskScreen(txt, taskParam.textures.shieldTxt, screenIndex);
            
        case 2
            if subject.cBal == 1 || subject.cBal == 2 || subject.cBal == 3
                
                header = 'Kanonenkugeln Abwehren';
                
                if isequal(subject.group, '1')
                    
                    txt = ['In dieser Aufgabe ist das Ziel '...
                        'wieder möglichst viele Kanonenkugeln '...
                        'abzuwehren. Der Unterschied ist '...
                        'allerdings, dass du die Kanone dieses '...
                        'Mal sehen kannst.'];
                else
                    
                    txt = ['In dieser Aufgabe ist das Ziel '...
                        'wieder möglichst viele Kanonenkugeln '...
                        'abzuwehren. Der Unterschied ist '...
                        'allerdings, dass Sie die Kanone '...
                        'dieses Mal sehen können.'];
                end
                
                feedback = false;
                fw = al_bigScreen(taskParam,taskParam.strings.txtPressEnter, header, txt, feedback);
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
                
                txt = ['In dieser Aufgabe sollst du wieder '...
                    'versuchen möglichst viele Kanonenkugeln '...
                    'abzuwehren. Da du das Ziel der Kanone die '...
                    'ganze Zeit siehst, steuerst du dein '...
                    'Schild am besten genau auf die schwarze '...
                    'Nadel.\n\nBeachte allerdings, dass du '...
                    'jetzt nicht mehr sehen kannst wie die '...
                    'Kanonenkugel fliegt, sondern nur wo sie '...
                    'landet.'];
            elseif isequal(subject.group, '1') && (subject.cBal == 1 || subject.cBal == 2 || subject.cBal == 3 || subject.cBal == 5 )
                txt = ['In dieser Aufgabe sollst du wieder '...
                    'versuchen möglichst viele Kanonenkugeln '...
                    'abzuwehren. Da du das Ziel der Kanone die '...
                    'ganze Zeit siehst, steuerst du dein '...
                    'Schild am besten genau auf die schwarze '...
                    'Nadel.'];
            elseif isequal(subject.group, '2') && (subject.cBal == 4 || subject.cBal == 6)
                txt = ['In dieser Aufgabe sollen Sie wieder '...
                    'versuchen möglichst viele Kanonenkugeln '...
                    'abzuwehren. Da Sie das Ziel der Kanone '...
                    'die ganze Zeit sehen, steuern Sie Ihr '...
                    'Schild am besten genau auf die schwarze '...
                    'Nadel.\n\nBeachten Sie allerdings, dass '...
                    'Sie jetzt nicht mehr sehen können wie die '...
                    'Kanonenkugel fliegt, sondern nur wo sie '...
                    'landet.'];
            elseif isequal(subject.group, '2') && (subject.cBal == 1 || subject.cBal == 2 || subject.cBal == 3 || subject.cBal == 5 )
                txt = ['In dieser Aufgabe sollen Sie wieder '...
                    'versuchen möglichst viele Kanonenkugeln '...
                    'abzuwehren. Da Sie das Ziel der Kanone '...
                    'die ganze Zeit sehen, steuern Sie Ihr '...
                    'Schild am besten genau auf die schwarze '...
                    'Nadel.'];
            end
            
            feedback = false;
            fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
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
