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
    Screen('Flip', taskParam.gParam.window);
    
    [~, ~, keyCode] = KbCheck;
    if find(keyCode) == taskParam.keys.enter
        break
    end
end
KbReleaseWait();

% Screen 2.
Screen('TextSize', taskParam.gParam.window, 30);
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt=['Auf rauer See möchtest'...
    'du möglichst viele Schiffe einer\n\nSchiffsflotte versenken. Als Hilfsmittel benutzt du einen Radar,\n\nder dir einen Hinweis darauf gibt, wo sich ein Schiff aufhält.'];
else
    txt='Auf rauer See möchtest du möglichst viele Schiffe einer Schiffsflotte versenken.\n\nAls Hilfsmittel benutzt du einen Radar, der dir einen Hinweis darauf gibt, wo sich\n\nein Schiff aufhält.';
end

DrawFormattedText(taskParam.gParam.window, taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
button = taskParam.keys.enter;
taskParam = ControlLoopInstrTxt(taskParam, txt, button, needle);
KbReleaseWait();

% Screen 3.
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt='Dein Abschussziel gibst du mit dem blauen Punkt an, den du mit der\n\nrechten und linken Pfeiltaste steuerst.\n\nVersuche den Punkt auf den Zeiger zu bewegen und drücke LEERTASTE.';
else
    txt='Dein Abschussziel gibst du mit dem blauen Punkt an, den du mit der rechten und\n\nlinken Pfeiltaste steuerst.\n\nVersuche den Punkt auf den Zeiger zu bewegen und drücke LEERTASTE.';
end

button = taskParam.keys.space;
taskParam = ControlLoopInstrTxt(taskParam, txt, button, needle);
LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
DrawCircle(taskParam);
DrawCross(taskParam);
Screen('Flip', taskParam.gParam.window);
WaitSecs(1);

% Screen 4.
while 1
    
    if isequal(taskParam.gParam.computer, 'Humboldt')
        txt='Der schwarze Balken zeigt dir dann die Position des Schiffs an. Wenn dein Punkt auf dem Schiff ist, hast du es getroffen.';
    else
        txt='Der schwarze Balken zeigt dir dann die Position des Schiffs an. Wenn dein\n\nPunkt auf dem Schiff ist, hast du es getroffen.';
    end
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    DrawCircle(taskParam);
    DrawOutcome(taskParam, 238);
    DrawCross(taskParam);
    PredictionSpot(taskParam);
    DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1, [0 0 0]);
    Screen('Flip', taskParam.gParam.window);
    
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
    txt='Daraufhin siehst du welche Ladung das Schiff an Bord hat. Dies wird dir auch\n\nangezeigt, wenn du das Schiff nicht getroffen hast.\n\nDieses Schiff hat GOLD geladen. Wenn du es triffst, verdienst du 20 CENT. ';
    else
    txt='Daraufhin siehst du welche Ladung das Schiff an Bord hat. Dies wird dir auch\n\nangezeigt, wenn du das Schiff nicht getroffen hast.\n\nDieses Schiff hat SILBER geladen. Wenn du es triffst, verdienst du 20 CENT. ';
    end
        
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1, [0 0 0]);
    DrawCircle(taskParam)
    if subject.rew == '1'
    DrawBoat(taskParam, taskParam.colors.gold)
    else
    DrawBoat(taskParam, taskParam.colors.silver)
    end
    DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('Flip', taskParam.gParam.window);
    
    [ ~, ~ , keyCode ] = KbCheck;
    if find(keyCode)==taskParam.keys.enter
        break
    end
end
KbReleaseWait();

% Screen 6.
while 1
    
    if subject.rew == '1'
    txt='Dieses Schiff hat STEINE geladen. Wenn du es triffst, verdienst du leider NICHTS. ';
    else    
    txt='Dieses Schiff hat SAND geladen. Wenn du es triffst, verdienst du leider NICHTS. ';
    end
    
    LineAndBack(taskParam.gParam.window, taskParam.gParam.screensize)
    DrawFormattedText(taskParam.gParam.window,txt,taskParam.gParam.screensize(3)*0.15,taskParam.gParam.screensize(4)*0.1, [0 0 0]);
    DrawFormattedText(taskParam.gParam.window,taskParam.strings.txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    DrawCircle(taskParam)
    if subject.rew == '1'
    DrawBoat(taskParam, taskParam.colors.silver)
    else
    DrawBoat(taskParam, taskParam.colors.gold)
    end
    Screen('Flip', taskParam.gParam.window);
    
    [~, ~, keyCode ] = KbCheck;
    if find(keyCode) == taskParam.keys.enter
        break
    end
end
KbReleaseWait();

% Screen 7.
header = 'Wie der Radar funktioniert';
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt = 'Der Radar zeigt dir die Position der Schiffsflotte leider nur ungefähr an.\n\nDurch den Seegang kommt es oft vor, dass die Schiffe nur in der Nähe\n\nder angezeigten Position sind. Manchmal sind sie etwas weiter links\n\nund manchmal etwas weiter rechts. Diese Abweichungen von der\n\nRadarnadel sind zufällig und du kannst nicht perfekt vorhersagen,\n\nwo sich ein Schiff aufhält.';
else
    txt = 'Der Radar zeigt dir die Position der Schiffsflotte leider nur ungefähr an.\n\nDurch den Seegang kommt es oft vor, dass die Schiffe nur in der Nähe der\n\nangezeigten Position sind. Manchmal sind sie etwas weiter links und manchmal\n\netwas weiter rechts. Diese Abweichungen von der Radarnadel sind zufällig und du\n\nkannst nicht perfekt vorhersagen, wo sich ein Schiff aufhält.';
end
BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt);

% Screen 8.
header = 'Wie du einen Schuss abgibst';
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt='Mit LEERTASTE gibst du einen Schuss ab. Richte dich dabei nach\n\nder Radarnadel. Beachte, dass der Radar dir durch den Seegang\n\nnur ungefähr angibt wo die Schiffe sind.';
else
    txt='Mit LEERTASTE gibst du einen Schuss ab. Richte dich dabei nach der\n\nRadarnadel. Beachte, dass dir der Radar durch den Seegang nur\n\nungefähr angibt wo, die Schiffe sind.';
end
BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt);

% Screen 9.
header = 'Worauf du achten solltest';
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt = 'Es ist wichtig, dass du während der Aufgabe immer auf das\n\nFixationskreuz schaust. Wir bitten dich darum, möglichst wenige\n\nAugenbewegungen zu machen. Versuche außerdem wenig zu blinzeln.\n\nWenn du blinzeln musst, dann bitte bevor du einen Schuss abgibst.\n\n\nIn der folgenden Übung sollst du probieren, möglichst viele Schiffe\n\nzu treffen.';
else
    txt = 'Es ist wichtig, dass du während der Aufgabe immer auf das Fixationskreuz\n\nschaust. Wir bitten dich darum, möglichst wenige Augenbewegungen zu machen.\n\nVersuche außerdem wenig zu blinzeln. Wenn du blinzeln musst, dann bitte bevor\n\ndu einen Schuss abgibst.\n\n\nIn der folgenden Übung sollst du probieren, möglichst viele Schiffe zu treffen.';
end
BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt);


distMean = 338;
outcome = [324;348;371;303;316;332;310;339;357;316;320;308;308;311;330;299;359;375;368;303];
boatType = [1;3;1;1;3;3;3;1;2;2;1;3;1;3;3;1;3;2;3;2];


% Screen 10 (1st practice block).
for i = 1:taskParam.gParam.intTrials
    taskParam = ControlLoop(taskParam, distMean, outcome(i), boatType(i));
end

% Screen 11.
header = 'Ende der ersten Übung';
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt='Im nächsten Übungsdurchgang fahren die Schiffe ab und zu weiter.\n\nWann die Flotte weiterfährt kannst du nicht vorhersagen. Wenn dir\n\ndie Radarnadel eine neue Position anzeigt, solltest du dich daran\n\nanpassen.\n\n\nVersuche bitte wieder auf das Fixationskreuz zu gucken und möglichst\n\nwenig zu blinzeln.';
else
    txt='Im nächsten Übungsdurchgang fahren die Schiffe ab und zu weiter.\n\nWann die Flotte weiterfährt kannst du nicht vorhersagen. Wenn dir die\n\nRadarnadel eine neue Position anzeigt, solltest du dich daran anpassen.\n\n\nVersuche bitte wieder auf das Fixationskreuz zu gucken und möglichst wenig\n\nzu blinzeln.';
end
BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt)

if subject.cBal == '1'
    
    % Screen 21.
    VolaIndication(taskParam, taskParam.strings.txtLowVola, taskParam.strings.txtPressEnter)
    
    % Screen 22 (2nd practice block with low volatility).
    outcome = [142;165;88;147;248;250;232;268;237;231;271;315;315;309;327;260;299;250;291;42];
    distMean = [146;146;146;146;242;242;242;242;242;242;242;291;291;291;291;291;291;291;291;20];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:taskParam.gParam.intTrials
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
    end
    
    % Screen 23.
    VolaIndication(taskParam, taskParam.strings.txtHighVola, taskParam.strings.txtPressEnter)
    
    KbReleaseWait();
    
    % Screen 24 (2nd practice block with high volatility).
    outcome = [329;372;317;285;340;344;266;332;264;110;135;180;163;237;189;93;229;247;312;179];
    distMean = [312;312;312;312;312;312;312;312;312;176;176;176;176;176;176;176;224;224;224;224];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:taskParam.gParam.intTrials
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
    end
    
elseif subject.cBal == '2'
    
    % Screen 25.
    VolaIndication(taskParam, taskParam.strings.txtHighVola, taskParam.strings.txtPressEnter)
    
    KbReleaseWait();
    
    % Screen 26 (2nd practice block with high volatility).
    outcome = [329;372;317;285;340;344;266;332;264;110;135;180;163;237;189;93;229;247;312;179];
    distMean = [312;312;312;312;312;312;312;312;312;176;176;176;176;176;176;176;224;224;224;224];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:taskParam.gParam.intTrials
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
    end
    
    % Screen 27.
    VolaIndication(taskParam, taskParam.strings.txtLowVola, taskParam.strings.txtPressEnter)
    
    % Screen 28 (2nd practice block with low volatility).
    outcome = [142;165;88;147;248;250;232;268;237;231;271;315;315;309;327;260;299;250;291;42];
    distMean = [146;146;146;146;242;242;242;242;242;242;242;291;291;291;291;291;291;291;291;20];
    boatType = [1;1;2;2;2;2;3;1;3;2;2;3;3;1;1;2;1;2;2;3];
    
    for i=1:taskParam.gParam.intTrials
        taskParam = ControlLoop(taskParam, distMean(i), outcome(i), boatType(i));
    end
end

header = 'Ende der zweiten Übung';
if isequal(taskParam.gParam.computer, 'Humboldt')
    txt = 'In der folgenden Übung ist dein Radar leider kaputt. Die Radarnadel\n\nkannst du jetzt nur noch selten sehen. In den meisten Fällen musst\n\ndu die Schiffsposition selber herausfinden. Trotzdem solltest du\n\nversuchen, möglichst viele Schiffe abzuschießen.';
else
    txt = 'In der folgenden Übung ist dein Radar leider kaputt. Die Radarnadel kannst du\n\njetzt nur noch selten sehen. In den meisten Fällen musst du die Schiffsposition\n\nselber herausfinden. Du solltest versuchen, möglichst viele Schiffe\n\nabzuschießen.';
end
BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt)


%% End of intro // Save data.


end
