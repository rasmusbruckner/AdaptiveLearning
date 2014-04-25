function BattleShipsControlInstructions(taskParam)
% Function BattleShipsControlInstructions is an intro for the control session.

KbReleaseWait();


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

txtPressEnter = 'Weiter mit Enter';

KbReleaseWait();

while 1

txtControl = 'Zum Abschluss kommt eine kurze Gedächtnisaufgabe. Deine Aufgabe ist es,\n\ndir die Position des Bootes zu merken und den blauen Punkt daraufhin\n\ngenau auf diese Position zu steuern.';
Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)])
DrawFormattedText(taskParam.window, txtControl, 200, 300);
DrawFormattedText(taskParam.window, txtPressEnter, 'center', screensize(4)*0.9);
Screen('Flip', taskParam.window);

[ keyIsDown, seconds, keyCode ] = KbCheck;
if keyIsDown
    if find(keyCode)==enter
        break
    end
end
end


KbReleaseWait();

distMean = 360;
%Third screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen3='Merke dir jetzt die Position des Bootes...';
    else
        txtScreen3='Merke dir jetzt die Position des Bootes...';
    end
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - 100, screensize(4)/3] )
    DrawFormattedText(taskParam.window,txtScreen3,200,100);
    DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    DrawOutcome(taskParam, distMean)
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
        elseif find(keyCode)==enter
            break;
        end
    end
end

KbReleaseWait();

% Fourth screen.
while 1
    
    if isequal(taskParam.computer, 'Humboldt')
        txtScreen4='... und steuere den blauen Punkt auf die Postition die du dir gemerkt hast.\n\nDücke dann LEERTASTE.';
    else
        txtScreen4='... und steuere den blauen Punkt auf die Postition die du dir gemerkt hast.\n\nDücke dann LEERTASTE.';
    end
    
    
    Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4)/15, screensize(3) - screensize(3)/10, screensize(4)/3])
    DrawFormattedText(taskParam.window,txtScreen4,200, 100);
    %DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    PredictionSpot(taskParam)
    %DrawFormattedText(taskParam.window,txtPressEnter,'center',screensize(4)*0.9);
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
        elseif find(keyCode)==taskParam.space
            break;
        end
    end
end

KbReleaseWait();


% Show baseline 2.
DrawCross(taskParam.window)
DrawCircle(taskParam.window)

% Trigger: baseline 2.
%     lptwrite(taskParam.port, taskParam.baseline2Trigger);
%     WaitSecs(1/taskParam.sampleRate);
%     lptwrite(taskParam.port,0) % Port wieder auf null stellen

Screen('Flip', taskParam.window)
WaitSecs(1);

% Show boat and calculate performance.       %TRIGGER

DrawCross(taskParam.window)
DrawCircle(taskParam.window)
DrawGoldBoat(taskParam)


% Trigger: boat.
%     lptwrite(taskParam.port, taskParam.boatTrigger);
%     WaitSecs(1/taskParam.sampleRate);
%     lptwrite(taskParam.port,0) % Port wieder auf null stellen

Screen('Flip', taskParam.window);
WaitSecs(1);

% Show baseline 3.
DrawCircle(taskParam.window)
DrawCross(taskParam.window)

% Trigger: baseline 3.
%     lptwrite(taskParam.port, taskParam.baseline3Trigger);
%     WaitSecs(1/taskParam.sampleRate);
%     lptwrite(taskParam.port,0) % Port wieder auf null stellen

Screen('Flip', taskParam.window);
WaitSecs(1);

%     taskData.trial(i) = i;
%     taskData.age(i) = str2double(Subject.age);
%     taskData.ID{i} = Subject.ID;
%     taskData.sex{i} = Subject.sex;
%     taskData.date{i} = Subject.date


%%%%%%%%%%%%%%%%

KbReleaseWait();


while 1
Screen('FillRect', taskParam.window, [224,255,255], [screensize(3)/10, screensize(4) / 4, screensize(3) - (screensize(3)/10), screensize(4) - (screensize(4) / 4)])
txtPay = 'Das war es auch schon!\n\n\nBezahlung:\n\nGoldenes Boot: Wenn du dir die letzte Position richtig gemerkt hast, bekommst\ndu 20 CENT.\n\nBronzenes Boot: Wenn du dir die letzte Postion richtig gemerkt hast, bekommst\ndu 10 CENT.\n\nSteine: Hier verdienst du leider nichts.';
DrawFormattedText(taskParam.window, txtPay, 200, 300);

EnterGo = 'Mit Enter geht es los';
DrawFormattedText(taskParam.window, EnterGo, 'center', screensize(4)*0.9);
Screen('Flip', taskParam.window);

[ keyIsDown, seconds, keyCode ] = KbCheck;
if keyIsDown
    if find(keyCode)==enter
        break
    end
end
end


%%%%%%%%%%%%%%%%%


end
