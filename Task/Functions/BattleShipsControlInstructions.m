function BattleShipsControlInstructions(taskParam, subject)
% Function BattleShipsControlInstructions is an intro for the control session.

KbReleaseWait();

% Screen 1.
txtPressEnter = 'Weiter mit Enter';
header = 'Gedächtnisaufgabe';
if isequal(taskParam.gParam.computer, 'D_Pilot')
txt = ['Zum Abschluss kommt eine Gedächtnisaufgabe. Hier sollst du dir '...
        'die Position des Bootes merken\n\nund den blauen Punkt '...
        'daraufhin genau auf diese Position steuern.'];
else
txt = ['Zum Abschluss kommt eine Gedächtnisaufgabe. Hier sollst du dir '...
        'die Position des Bootes merken\n\nund den blauen Punkt '...
        'daraufhin genau auf diese Position steuern.'];    
end
BigScreen(taskParam, txtPressEnter, header, txt)

% Screen 2.
outcome = 238;
txt = 'Merke dir jetzt die Position des Bootes...';

while 1
    
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1, []);
    
    DrawCircle(taskParam)
    DrawCross(taskParam)
    DrawOutcome(taskParam, outcome)
    
    PredictionSpot(taskParam)
    DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('DrawingFinished', taskParam.gParam.window);
    time = GetSecs;
    Screen('Flip', taskParam.gParam.window, time + 0.1);
    
    [~, ~, keyCode] = KbCheck;
    if find(keyCode) == taskParam.keys.enter
        break
    end
    
end

% Screen 3.
button = taskParam.keys.space;
if isequal(taskParam.gParam.computer, 'D_Pilot')
txt = ['...und steuere den blauen Punkt auf die Postition die du '...
        'dir gemerkt hast. Dücke dann LEERTASTE.'];
else
txt = ['...und steuere den blauen Punkt auf die Postition die du '...
        'dir gemerkt\n\nhast. Dücke dann LEERTASTE.'];
end
needle = false;
taskParam = ControlLoopInstrTxt(taskParam, txt, button, needle);
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
    ShipTxt = DrawBoat(taskParam, taskParam.colors.gold);
else
    ShipTxt = DrawBoat(taskParam, taskParam.colors.silver);
end
Screen('DrawingFinished', taskParam.gParam.window);
Screen('Flip', taskParam.gParam.window, time + 1.1);
Screen('Close', ShipTxt);

% Show baseline 3.
LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
DrawCircle(taskParam)
DrawCross(taskParam)
Screen('DrawingFinished', taskParam.gParam.window);
Screen('Flip', taskParam.gParam.window, time + 1.6);
WaitSecs(1);

KbReleaseWait();

header = 'Start der Gedächtnisaufgabe';
if subject.rew == '1'
    if isequal(taskParam.gParam.computer, 'D_Pilot')
    txt = ['Denke daran, dass du den blauen Punkt ab jetzt immer auf '...
        'die letzte Position des Bootes steuerst.\n\n\nWenn du dir'...
        'die letzte Position richtig gemerkt hast, bekommst du...'...
        '\n\nGoldenes Boot: 20 CENT\n\nSteine: Hier verdienst du'...
        'leider nichts\n\n\nBitte vermeide Augenbewegungen und '...
        'blinzeln wieder so gut wie möglich'];
    else
    txt = ['Denke daran, dass du den blauen Punkt ab jetzt immer auf '...
        'die letzte Position\n\ndes Bootes steuerst.\n\n\nWenn du dir die letzte Position richtig gemerkt hast, bekommst du...\n\nGoldenes Boot: 20 CENT\n\nSteine: Hier verdienst du leider nichts\n\n\nBitte vermeide Augenbewegungen und blinzeln wieder so gut wie möglich'];
    end
else
    txt = ['Denke daran, dass du den blauen Punkt ab jetzt immer auf '...
        'die letzte Position\n\ndes Bootes steuerst.\n\n\nWenn du dir die letzte Position richtig gemerkt hast, bekommst du...\n\nSilbernes Boot: 20 CENT\n\nSand: Hier verdienst du leider nichts\n\n\nBitte vermeide Augenbewegungen und blinzeln wieder so gut wie möglich.'];
end

BigScreen(taskParam, txtPressEnter, header, txt)