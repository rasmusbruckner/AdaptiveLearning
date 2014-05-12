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

%while 1

header = 'Gedächtnisaufgabe';    
txt = 'Zum Abschluss kommt eine Gedächtnisaufgabe. Hier sollst du die\n\ndir die Position des Bootes merken und den blauen Punkt\n\ndaraufhin genau auf diese Position steuern.';
    
BigScreen(taskParam, txtPressEnter, header, txt)    

button = taskParam.enter;

txt = 'Merke dir jetzt die Position des Bootes...';

taskParam = ControlLoop(taskParam, txt, button);

button = taskParam.space;

txt = '...und steuere den blauen Punkt auf die Postition die du dir gemerkt\n\nhast. Dücke dann LEERTASTE.';

taskParam = ControlLoop(taskParam, txt, button);


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

%DrawCross(taskParam.window)
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



KbReleaseWait();

header = 'Start der Gedächtnisaufgabe';
if isequal(taskParam.computer, 'Humboldt')
    txt = 'Denke daran, dass du den blauen\n\nPunkt ab jetzt immer auf die letzte Position des Bootes steuerst.\n\n\nBezahlung:\n\nGoldenes Boot: Wenn du dir die letzte Position richtig gemerkt hast,\nbekommst du 20 CENT.\n\nBronzenes Boot: Wenn du dir die letzte Postion richtig gemerkt hast,\nbekommst du 10 CENT.\n\nSteine: Hier verdienst du leider nichts.';
else
    txt = 'Denke daran, dass du den blauen Punkt ab jetzt\n\nimmer auf die letzte Position des Bootes steuerst.\n\n\nBezahlung:\n\nGoldenes Boot: Wenn du dir die letzte Position richtig gemerkt hast, bekommst\ndu 20 CENT.\n\nBronzenes Boot: Wenn du dir die letzte Postion richtig gemerkt hast, bekommst\ndu 10 CENT.\n\nSteine: Hier verdienst du leider nichts.';
end

BigScreen(taskParam, txtPressEnter, header, txt)    




%end
