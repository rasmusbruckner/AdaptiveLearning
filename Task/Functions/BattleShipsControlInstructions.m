function BattleShipsControlInstructions(taskParam)
% Function BattleShipsControlInstructions is an intro for the control session.

KbReleaseWait();

txtPressEnter = 'Weiter mit Enter';

header = 'Gedächtnisaufgabe';    
txt = 'Zum Abschluss kommt eine Gedächtnisaufgabe. Hier sollst du dir die Position\n\ndes Bootes merken und den blauen Punkt daraufhin genau auf diese Position steuern.';
    
BigScreen(taskParam, txtPressEnter, header, txt)    

button = taskParam.enter;

txt = 'Merke dir jetzt die Position des Bootes...';

taskParam = ControlLoop(taskParam, txt, button);

button = taskParam.space;

txt = '...und steuere den blauen Punkt auf die Postition die du dir gemerkt\n\nhast. Dücke dann LEERTASTE.';

taskParam = ControlLoop(taskParam, txt, button);

% Show baseline 2.
DrawCross(taskParam.window)
DrawCircle(taskParam.window)

Screen('Flip', taskParam.window)
WaitSecs(1);

%DrawCross(taskParam.window)
DrawCircle(taskParam.window)
DrawGoldBoat(taskParam)


Screen('Flip', taskParam.window);
WaitSecs(1);

% Show baseline 3.
DrawCircle(taskParam.window)
DrawCross(taskParam.window)

Screen('Flip', taskParam.window);
WaitSecs(1);

KbReleaseWait();

header = 'Start der Gedächtnisaufgabe';
if isequal(taskParam.computer, 'Humboldt')
    txt = 'Denke daran, dass du den blauen Punkt ab jetzt immer auf die letzte Position\n\ndes Bootes steuerst.\n\n\nWenn du dir die letzte Position richtig gemerkt hast bekommst du...\n\nGoldenes Boot: 20 CENT\n\nBronzenes Boot: 10 CENT\n\nSteine: Hier verdienst du leider nichts';
else
    txt = 'Denke daran, dass du den blauen Punkt ab jetzt immer auf die letzte Position\n\ndes Bootes steuerst.\n\n\nWenn du dir die letzte Position richtig gemerkt hast, bekommst du...\n\nGoldenes Boot: 20 CENT\n\nBronzenes Boot: 10 CENT\n\nSteine: Hier verdienst du leider nichts';
end

BigScreen(taskParam, txtPressEnter, header, txt)