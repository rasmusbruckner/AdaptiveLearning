function BattleShipsInstructions(taskParam, subject)
% BattleShipsInstructions runs the practice sessions.
%   Depending on cBal you start with low or high volatility.

KbReleaseWait();
needle = true;
%% Instructions section.

% Screen 1 with painting.
while 1
    
    Screen('TextFont', taskParam.gParam.window, 'Arial');
    Screen('TextSize', taskParam.gParam.window, 50);
    Ship = imread('Sea.jpg');
    ShipTxt = Screen('MakeTexture', taskParam.gParam.window, Ship);
    Screen('DrawTexture', taskParam.gParam.window, ShipTxt,[]);
    txtScreen1='Schiffeversenken';
    DrawFormattedText(taskParam.gParam.window, txtScreen1, 'center', 100, [255 255 255]);
    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs; 
    Screen('Flip', taskParam.gParam.window, t + 0.1);
    
    [~, ~, keyCode] = KbCheck;
    if find(keyCode) == taskParam.keys.enter
        break
    end
end
KbReleaseWait();

% Screen 2.

if isequal(taskParam.gParam.computer, 'Dresden')
    Screen('TextSize', taskParam.gParam.window, 25);
    txt=['Auf rauer See möchtest du möglichst viele Schiffe einer\n\n'...
         'Schiffsflotte versenken. Als Hilfsmittel benutzt du '...
         'einen Radar,\n\nder dir einen Hinweis darauf gibt, wo sich '...
         'die Schiffsflotte aufhält.'];
elseif isequal(taskParam.gParam.computer, 'D_Pilot')
    Screen('TextSize', taskParam.gParam.window, 30);
    txt=['Auf rauer See möchtest du möglichst viele Schiffe einer '...
         'Schiffsflotte versenken. Als Hilfsmittel\n\nbenutzt du '...
         'einen Radar, der dir einen Hinweis darauf gibt, wo sich '...
         'die Schiffsflotte aufhält.'];     
else
    Screen('TextSize', taskParam.gParam.window, 30);
    txt=['Auf rauer See möchtest du möglichst viele Schiffe einer '...
         'Schiffsflotte versenken.\n\nAls Hilfsmittel benutzt du einen '...
         'Radar, der dir einen Hinweis darauf gibt,\n\nwo sich die '...
         'Schiffsflotte aufhält.'];

end

DrawFormattedText(taskParam.gParam.window, taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
button = taskParam.keys.enter;
taskParam = ControlLoopInstrTxt(taskParam, txt, button, needle);
KbReleaseWait();

% Screen 3.
if isequal(taskParam.gParam.computer, 'Dresden')
    txt=['Dein Abschussziel gibst du mit dem blauen Punkt an, den du\n\n'...
         'mit der rechten und linken Pfeiltaste steuerst.'...
         'Versuche den\n\nPunkt auf den Zeiger zu bewegen und drücke '...
         'LEERTASTE.'];
elseif isequal(taskParam.gParam.computer, 'D_Pilot')
    txt=['Dein Abschussziel gibst du mit dem blauen Punkt an, den du '...
         'mit der rechten und linken\n\nPfeiltaste steuerst. '...
         'Versuche den Punkt auf den Zeiger zu bewegen und drücke '...
         'LEERTASTE.'];     
else
    txt=['Dein Abschussziel gibst du mit dem blauen Punkt an, den '...
         'du mit der rechten und\n\nlinken Pfeiltaste steuerst.\n\n'...
         'Versuche den Punkt auf den Zeiger zu bewegen und drücke '...
         'LEERTASTE.'];
end

button = taskParam.keys.space;
taskParam = ControlLoopInstrTxt(taskParam, txt, button, needle);
LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
DrawCircle(taskParam);
DrawCross(taskParam);
Screen('DrawingFinished', taskParam.gParam.window);
t = GetSecs; 
Screen('Flip', taskParam.gParam.window, t + 0.1);
WaitSecs(1);

% Screen 4.
while 1
    
    if isequal(taskParam.gParam.computer, 'Dresden')
        txt=['Der schwarze Balken zeigt dir dann die Position '...
             'des Schiffs an.\n\nWenn dein Punkt auf dem Schiff ist, '...
             'hast du es getroffen.'];
    elseif isequal(taskParam.gParam.computer, 'D_Pilot')    
        txt=['Der schwarze Balken zeigt dir dann die Position '...
             'des Schiffs an. Wenn dein Punkt auf dem\n\nSchiff ist, '...
             'hast du es getroffen.'];
    else
        txt=['Der schwarze Balken zeigt dir dann die Position des '...
             'Schiffs an. Wenn dein\n\nPunkt auf dem Schiff ist, hast '...
             'du es getroffen.'];
    end
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    DrawCircle(taskParam);
    DrawOutcome(taskParam, 238);
    DrawCross(taskParam);
    PredictionSpot(taskParam);
    DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9, [255 255 255]);
    
    if isequal(taskParam.gParam.computer, 'Dresden')
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
    else
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1);
    end
    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.1);
    
    [ keyIsDown, ~, keyCode ] = KbCheck;
    if keyIsDown
        if find(keyCode) == taskParam.keys.enter
            break
        end
    end
end
KbReleaseWait();

% Screen 5.
while 1
    
    if subject.rew == '1'
    if isequal(taskParam.gParam.computer, 'Dresden')    
    txt=['Daraufhin siehst du welche Ladung dein anvisiertes Schiff an Bord hat.\n\n'...
         'Dies wird dir auch angezeigt, wenn du das Schiff nicht '...
         'getroffen\n\nhast. Dieses Schiff hat GOLD geladen. Wenn du '...
         'es triffst,\n\nverdienst du 10 CENT.'];
    elseif isequal(taskParam.gParam.computer, 'D_Pilot')    
    txt=['Daraufhin siehst du welche Ladung dein anvisiertes Schiff an Bord hat. '...
         'Dies wird dir auch angezeigt,\n\nwenn du das Schiff nicht '...
         'getroffen hast. Dieses Schiff hat GOLD geladen. Wenn du '...
         'es triffst,\n\nverdienst du 10 CENT.'];
    else
    txt=['Daraufhin siehst du welche Ladung dein anvisiertes Schiff an Bord hat.\n\n'...
         'Dies wird dir auch angezeigt, wenn du das Schiff nicht '...
         'getroffen hast.\n\nDieses Schiff hat GOLD geladen. Wenn du '...
         'es triffst, verdienst du 10 CENT.'];   
    end
    else
    txt=['Daraufhin siehst du welche Ladung dein anvisiertes Schiff an Bord hat. '...
         'Dies wird dir auch\n\nangezeigt, wenn du das Schiff nicht '...
         'getroffen hast.\n\nDieses Schiff hat SILBER geladen. Wenn du '...
         'es triffst, verdienst du 10 CENT.'];
    end
        
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    if isequal(taskParam.gParam.computer, 'Dresden')
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
    else
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1);
    end
    DrawCircle(taskParam)
    if subject.rew == '1'
    DrawBoat(taskParam, taskParam.colors.gold)
    else
    DrawBoat(taskParam, taskParam.colors.silver)
    end
    DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('DrawingFinished', taskParam.gParam.window, [], []);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.1);
    
    
    [ ~, ~ , keyCode ] = KbCheck;
    if find(keyCode)==taskParam.keys.enter
        break
    end
end
KbReleaseWait();

% Screen 6.
while 1
    if isequal(taskParam.gParam.computer, 'D_Pilot')
        if subject.rew == '1'
            txt=['Dieses Schiff hat STEINE geladen. Wenn du es triffst, '...
                'verdienst du leider NICHTS.'];
        else
            txt=['Dieses Schiff hat SAND geladen. Wenn du es triffst, '...
                'verdienst du leider NICHTS.'];
        end
    else
        if subject.rew == '1'
            txt=['Dieses Schiff hat STEINE geladen. Wenn du es triffst, '...
                'verdienst\n\ndu leider NICHTS.'];
        else
            txt=['Dieses Schiff hat SAND geladen. Wenn du es triffst, '...
                'verdienst du leider NICHTS.'];
        end
    end
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    if isequal(taskParam.gParam.computer, 'Dresden')
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.05,taskParam.gParam.screensize(4)*0.05);
    else
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1);
    end
    DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    DrawCircle(taskParam)
    if subject.rew == '1'
    DrawBoat(taskParam, taskParam.colors.silver)
    else
    DrawBoat(taskParam, taskParam.colors.gold)
    end
    Screen('DrawingFinished', taskParam.gParam.window, [], []);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.1);
    
    [~, ~, keyCode ] = KbCheck;
    if find(keyCode) == taskParam.keys.enter
        break
    end
end
KbReleaseWait();

% Screen 7.
header = 'Wie der Radar funktioniert';
if isequal(taskParam.gParam.computer, 'D_Pilot')
    txt = ['Der Radar zeigt dir die Position der Schiffsflotte leider '...
          'nur ungefähr an. Durch den Seegang\n\nkommt es oft vor, dass '...
          'die Schiffe nur in der Nähe der angezeigten Position '...
          'sind.\n\nManchmal sind sie etwas weiter links und manchmal '...
          'etwas weiter rechts. Diese Abweichungen\n\nvon der '...
          'Radarnadel sind zufällig und du kannst nicht perfekt '...
          'vorhersagen, wo sich ein Schiff aufhält.'];
elseif isequal(taskParam.gParam.computer, 'Dresden')
    txt = ['Der Radar zeigt dir die Position der Schiffsflotte leider\n\n'...
          'nur ungefähr an. Durch den Seegang kommt es oft vor,\n\ndass '...
          'die Schiffe nur in der Nähe der angezeigten\n\nPosition '...
          'sind. Manchmal sind sie etwas weiter links\n\nund manchmal '...
          'etwas weiter rechts. Diese\n\nAbweichungen von der '...
          'Radarnadel sind zufällig\n\nund du kannst nicht perfekt '...
          'vorhersagen, wo sich\n\nein Schiff aufhält.'];

else
    txt = ['Der Radar zeigt dir die Position der Schiffsflotte leider '...
            'nur ungefähr an.\n\nDurch den Seegang kommt es oft vor, '...
            'dass die Schiffe nur in der Nähe der\n\nangezeigten '...
            'Position sind. Manchmal sind sie etwas weiter links '...
            'und manchmal\n\netwas weiter rechts. Diese Abweichungen von '...
            'der Radarnadel sind zufällig und du\n\nkannst nicht perfekt '...
            'vorhersagen, wo sich ein Schiff aufhält.'];
end
BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt);

% Screen 8.
header = 'Wie du einen Schuss abgibst';
if isequal(taskParam.gParam.computer, 'D_Pilot')
    txt=['Mit LEERTASTE gibst du einen Schuss ab. Richte dich dabei '...
         'nach der Radarnadel. Beachte,\n\ndass der Radar dir durch '...
         'den Seegang nur ungefähr angibt wo die Schiffe sind.'];
elseif isequal(taskParam.gParam.computer, 'Dresden')
    txt=['Mit LEERTASTE gibst du einen Schuss ab. Richte dich\n\ndabei '...
         'nach der Radarnadel. Beachte, dass dir der\n\nRadar durch '...
         'den Seegang nur ungefähr angibt wo,\n\ndie Schiffe sind.'];
else
    txt=['Mit LEERTASTE gibst du einen Schuss ab. Richte dich dabei '...
         'nach der\n\nRadarnadel. Beachte, dass dir der Radar durch '...
         'den Seegang nur\n\nungefähr angibt wo, die Schiffe sind.'];
end
BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt);

% Screen 9.
header = 'Worauf du achten solltest';
if isequal(taskParam.gParam.computer, 'D_Pilot')
    txt = ['Es ist wichtig, dass du während der Aufgabe'...
           'immer auf das Fixationskreuz schaust.'...
           '\n\nWir bitten dich darum, möglichst wenige Augenbewegungen '...
           'zu machen. Versuche außerdem\n\nwenig zu blinzeln. Wenn du '...
           'blinzeln musst, dann bitte bevor du einen Schuss abgibst.'...
           '\n\n\nIn der folgenden Übung sollst du probieren, möglichst '...
           'viele Schiffe zu treffen.'];
elseif isequal(taskParam.gParam.computer, 'Dresden')
    txt = ['Es ist wichtig, dass du während der Aufgabe '...
           'immer\n\nauf das Fixationskreuz schaust. '...
           'Wir bitten dich darum,\n\nmöglichst wenige Augenbewegungen '...
           'zu machen.\n\nVersuche außerdem wenig zu blinzeln. Wenn du\n\n'...
           'blinzeln musst, dann bitte bevor du einen Schuss\n\nabgibst.'...
           '\n\nIn der folgenden Übung sollst du probieren, möglichst\n\n'...
           'viele Schiffe zu treffen.'];       
else
    txt = ['Es ist wichtig, dass du während der Aufgabe immer auf das '...
           'Fixationskreuz\n\nschaust. Wir bitten dich darum, möglichst '...
           'wenige Augenbewegungen zu machen.\n\nVersuche außerdem '...
           'wenig zu blinzeln. Wenn du blinzeln musst, dann bitte bevor'...
           '\n\n\ndu einen Schuss abgibst.\n\nIn der folgenden Übung '...
           'sollst du probieren, möglichst viele Schiffe zu treffen.'];
end
BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt);


distMean = 210;
outcome = [225;216;223;211;199];
boatType = [2 1 1 2 1];


% Screen 10 (1st practice block).
for i = 1:5%taskParam.gParam.intTrials
    taskParam = ControlLoop(taskParam, distMean, outcome(i), boatType(i));
end

% Screen 11.
header = 'Ende der ersten Übung';
if isequal(taskParam.gParam.computer, 'D_Pilot')
    txt= ['Im nächsten Übungsdurchgang fahren die Schiffe ab und zu '...
          'weiter. Wann die Flotte weiterfährt\n\nkannst du nicht '...
          'vorhersagen. Wenn dir die Radarnadel eine neue Position '...
          'anzeigt, solltest du dich daran\n\nanpassen.\n\n\nVersuche '...
          'bitte wieder auf das Fixationskreuz zu gucken und möglichst '...
          'wenig zu blinzeln.'];
elseif isequal(taskParam.gParam.computer, 'Dresden')
    txt= ['Im nächsten Übungsdurchgang fahren die Schiffe ab\n\nund zu '...
          'weiter. Wann die Flotte weiterfährt\n\nkannst du nicht '...
          'vorhersagen. Wenn dir die Radarnadel\n\neine neue Position '...
          'anzeigt, solltest du dich daran anpassen.\n\n\nVersuche '...
          'bitte wieder auf das Fixationskreuz zu gucken und\n\nmöglichst '...
          'wenig zu blinzeln.'];     
else
    if taskParam.gParam.runVola == true
    txt = ['Im nächsten Übungsdurchgang fahren die Schiffe ab und zu '...
          'weiter.\n\nWann die Flotte weiterfährt kannst du nicht '...
          'vorhersagen. Wenn dir die\n\nRadarnadel eine neue Position '...
          'anzeigt, solltest du dich daran anpassen.\n\n\nVersuche '...
          'bitte wieder auf das Fixationskreuz zu gucken und möglichst '...
          'wenig\n\nzu blinzeln.'];
    else 
    txt = ['Im nächsten Übungsdurchgang fahren die Schiffe ab und zu '...
          'weiter.\n\nWann die Flotte weiterfährt kannst du nicht '...
          'vorhersagen. Wenn dir die\n\nRadarnadel eine neue Position '...
          'anzeigt, solltest du dich daran anpassen.\n\n\nVersuche '...
          'bitte wieder auf das Fixationskreuz zu gucken und möglichst '...
          'wenig\n\nzu blinzeln.'];    
    end
end
BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt)

if subject.cBal == '1'
    
    % Screen 21.
    if taskParam.gParam.runSigma == false
    VolaIndication(taskParam, taskParam.strings.txtLowVola, taskParam.strings.txtPressEnter)
    else
    VolaIndication(taskParam, taskParam.strings.txtLVHS, taskParam.strings.txtPressEnter)
    end
        
    % Screen 22 (2nd practice block with low volatility).
    
    if taskParam.gParam.runSigma == false
    outcome = [247;256;243;251;232;250;255;104;116;79];
    distMean = [239;239;239;239;239;239;239;100;100;100];
    else
    outcome = [123;104;112;109;94;124;288;262;315;306];
    distMean = [107;107;107;107;107;107;291;291;291;291];
    end
    boatType = [1 2 1 2 2 1 2 1 1 2];
    
    for i=1:taskParam.gParam.intTrials
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
    end
    
    % Screen 23.
    if taskParam.gParam.runSigma == false
    VolaIndication(taskParam, taskParam.strings.txtHighVola, taskParam.strings.txtPressEnter)
    outcome = [6;13;26;35;53;39;55;65;293;278];
    distMean = [16;16;16;16;46;46;46;46;290;290];
    else
    VolaIndication(taskParam, taskParam.strings.txtHVLS, taskParam.strings.txtPressEnter)
    outcome = [23;38;57;31;225;209;214;195;166;172];
    distMean = [30;30;30;30;216;216;216;216;172;172];
    end
    KbReleaseWait();
    
    % Screen 24 (2nd practice block with high volatility).
    %outcome = [329;372;317;285;340;344;266;332;264;110;135;180;163;237;189;93;229;247;312;179];
    %outcome = [6;13;26;35;53;39;55;65;293;278];
    %distMean = [16;16;16;16;46;46;46;46;290;290];
    %distMean = [312;312;312;312;312;312;312;312;312;176;176;176;176;176;176;176;224;224;224;224];
    
    boatType = [1 1 2 1 2 1 2 1 2 2];
    
    for i=1:taskParam.gParam.intTrials
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
    end
    
elseif subject.cBal == '2'
    
    % Screen 25.
    if taskParam.gParam.runVola == false
    VolaIndication(taskParam, taskParam.strings.txtHighVola, taskParam.strings.txtPressEnter)
    else
    VolaIndication(taskParam, taskParam.strings.txtHVHS, taskParam.strings.txtPressEnter)
    end
    KbReleaseWait();
    
    % Screen 26 (2nd practice block with high volatility).
    outcome = [329;372;317;285;340;344;266;332;264;110;135;180;163;237;189;93;229;247;312;179];
    distMean = [312;312;312;312;312;312;312;312;312;176;176;176;176;176;176;176;224;224;224;224];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:taskParam.gParam.intTrials
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
    end
    
    % Screen 27.
    if taskParam.gParam.runVola == false
    VolaIndication(taskParam, taskParam.strings.txtLowVola, taskParam.strings.txtPressEnter)
    else
    VolaIndication(taskParam, taskParam.strings.txtLVLS, taskParam.strings.txtPressEnter)
    end   
    
    % Screen 28 (2nd practice block with low volatility).
    outcome = [142;165;88;147;248;250;232;268;237;231;271;315;315;309;327;260;299;250;291;42];
    distMean = [146;146;146;146;242;242;242;242;242;242;242;291;291;291;291;291;291;291;291;20];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:taskParam.gParam.intTrials
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
    end
end

header = 'Ende der zweiten Übung';
if isequal(taskParam.gParam.computer, 'D_Pilot')
    txt = ['In der folgenden Übung ist dein Radar leider kaputt. '...
           'Die Radarnadel kannst du jetzt nur noch\n\nselten sehen. '...
           'In den meisten Fällen musst du die Schiffsposition '...
           'selber herausfinden. Du\n\nsolltest versuchen, '...
           'möglichst viele Schiffe abzuschießen.'];
elseif isequal(taskParam.gParam.computer, 'Dresden')
    txt = ['In der folgenden Übung ist dein Radar leider kaputt. '...
           'Die Radarnadel\n\nkannst du jetzt nur noch selten sehen. '...
           'In den meisten Fällen musst\n\ndu die Schiffsposition '...
           'selber herausfinden. Du\n\nsolltest versuchen, '...
           'möglichst viele Schiffe abzuschießen.'];
else
    txt = ['In der folgenden Übung ist dein Radar leider kaputt. '...
           'Die Radarnadel kannst du\n\njetzt nur noch selten sehen. '...
           'In den meisten Fällen musst du die Schiffsposition\n\n'...
           'selber herausfinden. Du solltest versuchen, möglichst '...
           'viele Schiffe\n\nabzuschießen.'];
end
BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt)
end
