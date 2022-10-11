function al_ARC_Instructions(taskParam, subject, cannon, whichPractice)
%SHAREDINSTRUCTIONS   This function runs the general instructions that are the same for each condtion
%
%   Input
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%       cannon: logical that indicates if cannon should be shown during instruction
%       whichPractice: indicates which practice condition should be presented
%
%   Output
%       ~


% Initialize to first screen
screenIndex = 1;

% Adjust text settings
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
Screen('TextSize', taskParam.display.window.onScreen, 50);

% Todo: Put these into the task-specific practice functions and delete
% them here
% if isequal(taskParam.gParam.taskType, 'dresden')
%     
%     if (isequal(whichPractice, 'mainPractice') && subject.cBal == 1) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 2) || (isequal(whichPractice, 'followOutcomePractice')...
%             && subject.cBal == 3) || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 5) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 4)...
%             || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 6)
%         
%         txt = 'Herzlich Willkommen\n\nErste Aufgabe...';
%         
%     elseif (isequal(whichPractice, 'mainPractice') && subject.cBal == 3)|| (isequal(whichPractice, 'mainPractice') && subject.cBal == 4) || (isequal(whichPractice, 'followOutcomePractice')...
%             && subject.cBal == 1) || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 6) || (isequal(whichPractice, 'followCannonPractice')...
%             && subject.cBal == 2 || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 5))
%         
%         txt = 'Zweite Aufgabe...';
%         
%     elseif (isequal(whichPractice, 'mainPractice') && subject.cBal == 5) || (isequal(whichPractice, 'mainPractice') && subject.cBal == 6)...
%             || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 2) || (isequal(whichPractice, 'followOutcomePractice') && subject.cBal == 4) || (isequal(whichPractice, 'followCannonPractice')...
%             && subject.cBal == 1) || (isequal(whichPractice, 'followCannonPractice') && subject.cBal == 3)
%         
%         txt = 'Dritte Aufgabe...';
%     end
% else
%     if isequal(whichPractice, 'oddballPractice')
%         txt = 'Oddball Task';
%     elseif isequal(whichPractice, 'mainPractice')
%         txt = 'Change Point Task';
%     elseif isequal(whichPractice, 'reversal')
%         txt = 'Reversal Task';
%     elseif isequal(whichPractice, 'chinese')
%         if taskParam.gParam.language == 1
%             txt = 'Beschütze Deine Planeten';
%         elseif taskParam.gParam.language == 2
%             txt = 'Protect your planets!';
%         end
%     end
% end
% Display first slide indicating the current task version
al_indicateCondition(taskParam, 'Change Point Task') % subject, whichPractice

% Introduce cannon
distMean = 300;
txt = 'A cannon is aimed at the circle. Indicate where you would like to place your shield to catch cannonballs with the orange spot. You can move the orange spot using the mouse.';
%     if isequal(taskParam.gParam.taskType, 'dresden')
%         if isequal(whichPractice, 'mainPractice') || isequal(whichPractice, 'followCannonPractice')
%             if isequal(taskParam.subject.group, '1')
%                 txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Deine Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen Punkt kannst du angeben, '...
%                     'wo du dein Schild platzieren möchtest, um die Kanonenkugel abzuwehren.\nDu kannst den Punkt mit den grünen und blauen Tasten steuern. Grün kannst du für schnelle '...
%                     'Bewegungen und blau für langsame Bewegungen benutzen.'];
%             else
%                 txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Ihre Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen '...
%                     'Punkt können Sie angeben, wo Sie Ihr Schild platzieren möchten, um die Kanonenkugel abzuwehren.\nSie können den Punkt mit den '...
%                     'grünen und blauen Tasten steuern. Grün können Sie für schnelle Bewegungen und blau für langsame Bewegungen benutzen.'];
%             end
%         else
%             if isequal(taskParam.subject.group, '1')
%                 txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Deine Aufgabe ist es, Kanonenkugeln mit einem Korb aufzusammeln. Mit dem orangenen '...
%                     'Punkt kannst du angeben, wo du deinen Korb platzieren möchtest, um die Kanonenkugel aufzusammeln.\nDu kannst den '...
%                     'Punkt mit den grünen und blauen Tasten steuern. Grün kannst du für schnelle Bewegungen und blau für langsame Bewegungen benutzen.'];
%             else
%                 txt = ['Eine Kanone zielt auf eine Stelle des Kreises. Ihre Aufgabe ist es, Kanonenkugeln mit einem Korb aufzusammeln. Mit dem orangenen Punkt können Sie angeben, '...
%                     'wo Sie Ihren Korb platzieren möchten, um die Kanonenkugeln aufzusammeln.\nSie können den Punkt mit den grünen und blauen Tasten steuern. Grün können Sie für schnelle '...
%                     'Bewegungen und blau für langsame Bewegungen benutzen.'];
%             end
%         end
%     elseif isequal(taskParam.gParam.taskType, 'oddball')
%         txt = ['A cannon is aimed at the circle. Indicate where you would like to place your shield to catch cannonballs with the orange spot. '...
%             'You can move the orange spot with the green and yellow buttons. Green is for fast movements and yellow is for slow movements.'];
%     elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC')
%         txt = 'A cannon is aimed at the circle. Indicate where you would like to place your shield to catch cannonballs with the orange spot. You can move the orange spot using the mouse.';
%     elseif isequal(taskParam.gParam.taskType, 'chinese')
%         if taskParam.gParam.language == 1
%             txt = ['Du bist die Weltraumpolizei und beschützt deinen Planeten.\nEin fremdes Raumschiff zielt mit seiner Kanone auf eine Stelle deines Planeten und feuert '...
%                 'Kanonenkugeln. Deine Aufgabe ist es, die Kanonenkugel mit einem Schild abzuwehren. Mit dem orangenen Punkt kannst du angeben, wo du dein Schild platzieren möchtest, '...
%                 'um die Kanonenkugel abzuwehren. Du kannst den Punkt mit der Maus bewegen. Das kannst du jetzt ausprobieren.'];
%         elseif taskParam.gParam.language == 2
%             txt = ['You are the space police and you must protect your planet.\n\nA foreign spaceship aims its cannon at a spot on your planet and fires '...
%                 'cannonballs. \nYour task is to fend off the cannonball with a shield. The orange dot lets you specify a point where you want to place your shield, '...
%                 'to ward off the cannonballs. \n\nYou can move the point with your mouse. Try it now.'];
%         end
%     end
screenIndex = al_introduceCannon(screenIndex, taskParam, distMean, cannon, txt);

% Introduce shot of the cannon
distMean = 240;
taskData = al_taskDataMain();
taskData.distMean = 240;
taskData.allASS = 20;
taskData.shieldType = 1;
% if introduceNeedle
%     if isequal(taskParam.gParam.taskType, 'dresden')
%         if isequal(taskParam.subject.group, '1')
%             txt = 'Das Ziel der Kanone wird mit der schwarzen Nadel angezeigt. Drücke LEERTASTE, damit die Kanone schießt.';
%         else
%             txt = 'Das Ziel der Kanone wird mit der schwarzen Nadel angezeigt. Drücke Sie bitte LEERTASTE, damit die Kanone schießt.';
%         end
%     elseif isequal(taskParam.gParam.taskType, 'oddball')
%         txt = 'The aim of the cannon is indicated with the black line. Hit SPACE to initiate a cannon shot.';
%     elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC') ||(isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 2)
%         %txt = 'The aim of the cannon is indicated with the black line. Hit the left mouse button to initiate a cannon shot.';
%         txt = 'The aim of the cannon is indicated by the black line. \n\nHit the left mouse button to initiate a cannon shot.';
%     elseif (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 1)
%         txt = 'Das Ziel der Kanone wird mit der schwarzen Linie angezeigt. Drücke die linke Maustaste, damit die Kanone schießt.';
%     else
%         txt = 'Das Ziel der Kanone wird mit der schwarzen Linie angezeigt. Drücke die linke Maustaste, damit die Kanone schießt.';
%     end
% else
%     if isequal(subject.group, '1')
%         txt = 'Drücke LEERTASTE, damit die Kanone schießt.';
%     else
%         txt = 'Drücken Sie bitte LEERTASTE, damit die Kanone schießt.';
%     end
% end
[screenIndex, taskData, taskParam] = introduceShot(taskParam, screenIndex, true, distMean, cannon, taskData);
WaitSecs(0.1);

% Introduce orange spot
% Todo: try to use either distMean or Data.distMean, not both...

distMean = 300;
Data.distMean = 300; %distMean;
txt = 'Move the orange spot to the part of the circle, where the cannon is aimed and press the left mouse button.';
% if isequal(taskParam.gParam.taskType, 'dresden')
%     if isequal(whichPractice, 'mainPractice') % noch nicht getestet!
%         if isequal(taskParam.subject.group, '1')
%             txt=['Der schwarze Strich zeigt dir die Position der letzten Kugel. Der orangene Strich zeigt dir die '...
%                 'Position deines letzten Schildes. Steuere den orangenen Punkt jetzt auf das Ziel der Kanone und drücke LEERTASTE.'];
%         else
%             txt=['Der schwarze Strich zeigt Ihnen die Position der letzten Kugel. Der orangene Strich zeigt Ihnen die '...
%                 'Position Ihres letzten Schildes. Steuern Sie den orangenen Punkt jetzt bitte auf das Ziel der Kanone und drücken Sie LEERTASTE.'];
%         end
%     elseif isequal(whichPractice, 'followOutcomePractice')
%         
%         if isequal(taskParam.subject.group, '1')
%                 
%                 txt=['Der schwarze Strich zeigt dir die '...
%                     'Position der letzten Kugel. Der orangene '...
%                     'Strich zeigt dir die Position deines '...
%                     'letzten Korbes. Bewege den orangenen '...
%                     'Punkt zur Stelle der letzten Kanonenkugel '...
%                     'und drücke LEERTASTE um die Kugel '...
%                     'aufzusammeln. '...
%                     'Gleichzeitig schießt die Kanone dann eine '...
%                     'neue Kugel ab.'];
%             else
%                 
%                 txt=['Der schwarze Strich zeigt Ihnen die '...
%                     'Position der letzten Kugel. Der orangene '...
%                     'Strich zeigt Ihnen die Position Ihres '...
%                     'letzten Korbes. Bewegen Sie den orangenen '...
%                     'Punkt zur Stelle der letzten Kanonenkugel '...
%                     'und drücken Sie LEERTASTE um die Kugel '...
%                     'aufzusammeln. Gleichzeitig schießt die '...
%                     'Kanone dann eine neue Kugel ab.'];
%         end
%     end
% elseif isequal(taskParam.gParam.taskType, 'oddball')
%     txt = 'Move the orange spot to the part of the circle, where the cannon is aimed and press SPACE.';
% elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC') || (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 2)
%     txt = 'Move the orange spot to the part of the circle, where the cannon is aimed and press the left mouse button.';
% elseif (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 1)
%     txt = 'Bewege den orangenen Punkt zu der Stelle auf dem Planeten auf die die Kanone zielt und drücke die linke Maustaste.';
% end
[screenIndex, taskData, taskParam] = introduceSpot(taskParam, screenIndex, distMean, taskData, cannon, txt);

% % Introduce miss of cannonball
% if (isequal(whichPractice, 'mainPractice') && abs(Data.predErr) >= 9) || (isequal(whichPractice, 'followCannonPractice')...
%         && abs(Data.predErr) >= 9) || (isequal(whichPractice, 'oddballPractice') && abs(Data.predErr) >= 9) || (isequal(whichPractice, 'reversal')...
%         && abs(Data.predErr) >= 9) || (isequal(whichPractice, 'chinese') && abs(Data.predErr) >= 9)
%     if isequal(taskParam.gParam.taskType, 'dresden')
%         if isequal(taskParam.subject.group, '1')
%             txt = 'Leider hast du die Kanonenkugel vefehlt. Versuche es noch einmal!';
%         else
%             txt = 'Leider haben Sie die Kanonenkugel vefehlt. Versuchen Sie es bitte noch einmal!';
%         end
%     elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC') ||...
%             (isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 2)
%         txt = 'You missed the cannonball. Try it again!';
%     elseif isequal(taskParam.gParam.taskType, 'chinese') && taskParam.gParam.language == 1
%         txt = 'Du hast die Kanonenkugel verfehlt. Versuche es nochmal!';
%     else
%         txt = 'Du hast die Kanonenkugel verfehlt. Versuche es nochmal!';
%     end
[screenIndex, taskData, taskParam] = introduceMisses(taskParam, screenIndex, taskData, distMean, whichPractice);

% Introduce shield
win = true;
% if isequal(taskParam.gParam.taskType, 'dresden')
%     if isequal(subject.group, '1')
%         txt = ['Das Schild erscheint nach dem Schuss. In diesem Fall hast du die Kanonenkugel abgewehrt. '...
%             'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, zählt es als Treffer.'];
%     else
%         txt = ['Das Schild erscheint nach dem Schuss. In diesem Fall haben Sie die Kanonenkugel abgewehrt. '...
%             'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, zählt es als Treffer.'];
%     end
% elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType,'reversal') || isequal(taskParam.gParam.taskType,'ARC')
%     txt = ['After the cannon is shot you will see the shield. In this case you caught the '...
%         'ball. If at least half of the ball overlaps with the shield then it is a "catch".'];
% elseif isequal(taskParam.gParam.taskType, 'chinese')
%     if taskParam.gParam.language == 1
%         txt = ['Dein Schild erscheint nach dem Schuss des Raumschiffs. In diesem Fall hast du die Kanonenkugel abgewehrt. Wenn mindestens '...
%             'die Hälfte der Kugel auf dem Schild ist, hast du sie erfolgreich abgewehrt.'];
%     elseif taskParam.gParam.language == 2
%         txt = ['After the cannon is shot you will see the shield. \n\nIn this case you caught the '...
%         'ball. \n\nIf at least half of the ball overlaps with the shield then it is a "catch".'];   
%     end
% else
%   txt = ['Das Schild erscheint nach dem Schuss. In diesem Fall haben Sie die Kanonenkugel abgewehrt. '...
%         'Wenn mindestens die Hälfte der Kugel auf dem Schild ist, zählt es als Treffer.'];
% 
% end
[screenIndex, taskData] = introduceShield(taskParam, subject, screenIndex, taskData, distMean, win);

% Introduce miss with shield
% distMean = 65;
% if isequal(taskParam.gParam.taskType, 'dresden')
%     if isequal(taskParam.subject.group, '1')
%         txt = 'Steuere den orangenen Punkt jetzt neben das Ziel der Kanone, so dass du die Kanonenkugel verfehlst und drücke LEERTASTE.';
%     else
%         txt = 'Steuern Sie den orangenen Punkt jetzt bitte neben das Ziel der Kanone, so dass Sie die Kanonenkugel verfehlen und drücken Sie LEERTASTE.';
%     end
%     
% elseif isequal(taskParam.gParam.taskType, 'oddball')
%     txt = 'Now try to place the shield so that you miss the cannonball. Then hit SPACE. ';
% elseif isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC')
%     txt = 'Now try to place the shield so that you miss the cannonball. Then hit the left mouse button. ';
% elseif isequal(taskParam.gParam.taskType, 'chinese')
%     if taskParam.gParam.language == 1
%         txt = 'Versuche nun dein Schild so zu positionieren, dass du die Kanonenkugel verfehlst. Drücke dann die linke Maustaste.';
%     elseif taskParam.gParam.language == 2
%         txt = 'Now try to position your shield so that you miss the cannonball. \n\nThen press the left mouse button.';    
%     end
% else
%     txt = 'Versuche nun dein Schild so zu positionieren, dass du die Kanonenkugel verfehlst. Drücke dann die linke Maustaste.';
% 
% end
[screenIndex, taskData, taskParam] = introduceShieldMiss(taskParam, screenIndex, taskData, distMean, cannon);

% Repeat shield miss if cannonball was caught
taskData.outcome = distMean;

[screenIndex, taskData, t] = repeatShieldMiss(taskParam, screenIndex, taskData, distMean);

% Confirm that cannonball was missed
win = true;
% if isequal(taskParam.gParam.taskType, 'dresden')
%     if isequal(subject.group, '1')
%         txt = 'In diesem Fall hast du die Kanonenkugel verpasst.';
%     else
%         txt = 'In diesem Fall haben Sie die Kanonenkugel verpasst.';
%     end
% elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType,'reversal') ||isequal(taskParam.gParam.taskType,'ARC')
%     txt = 'In this case you missed the cannonball.';
% elseif isequal(taskParam.gParam.taskType, 'chinese')
%     if taskParam.gParam.language == 1
%         txt = 'In diesem Fall hast du die Kanonenkugel verfehlt.';
%     elseif taskParam.gParam.language == 2
%         txt = 'In this case you missed the cannonball.';
%     end
% else
%     txt = 'In diesem Fall hast du die Kanonenkugel verfehlt.';
% 
% end
[screenIndex, taskData, t] = confirmMiss(taskParam, subject, screenIndex, taskData, t, distMean, win);

% % Introduce shield color
% if isequal(taskParam.gParam.taskType, 'dresden')
%     if isequal(whichPractice, 'followOutcomePractice')
%         header = 'Der Korb';
%     else
%         header = 'Das Schild';
%     end
%     if taskParam.subject.rew == 1
%         colRew = 'gold';
%         colNoRew = 'grau';
%     elseif taskParam.subject.rew == 2
%         colRew = 'silber';
%         colNoRew = 'gelb';
%     end
%     txt = sprintf(['Wenn du Kanonenkugeln abwehrst, '...
%                             'kannst du Geld verdienen. Wenn das Schild '...
%                             '%s ist, verdienst du %s CENT wenn du die '...
%                             'Kanonenkugel abwehrst. Wenn das Schild %s '...
%                             'ist, verdienst du nichts. Ebenso wie die '...
%                             'Farbe, kann auch die Größe deines '...
%                             'Schildes variieren. '...
%                             'Die Farbe und die Größe des Schildes siehst '...
%                             'du erst, nachdem die Kanone geschossen hat. '...
%                             'Daher versuchst du am besten jede '...
%                             'Kanonenkugel abzuwehren.\n\n'...
%                             'Um einen Eindruck von der wechselnden Größe '...
%                             'und Farbe des Schildes zu bekommen, '...
%                             'kommt jetzt eine kurze Übung.\n\n'], colRew, num2str(100*taskParam.gParam.rewMag), colNoRew);
%     
% elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType, 'reversal')
%     header = 'Your Shield';
%     if subject.rew == 1
%         colRew = 'blue';
%         colNoRew = 'green';
%     elseif subject.rew == 2
%         colRew = 'green';
%         colNoRew = 'blue';
%     end
%     txt = sprintf(['You can earn money by catching '...
%         'cannonballs in your shield. If the shield '...
%         'is %s you will earn %s CENTS for catching '...
%         'the ball. If the shield is %s you will not '...
%         'earn anything. On some trials the shield '...
%         'will be large and on some trials it will '...
%         'be small. You cannot know the SIZE or '...
%         'COLOR of the shield until the cannon '...
%         'is fired so it is best to try to catch '...
%         'the ball on every trial.\n\n'...
%         'You will now have some practice to get a '...
%         'sense of how the color and size of '...
%         'the shield vary.\n\nThe location of the '...
%         'ball fired on the previous trial will be '...
%         'marked with a black line.\n\nMoreover, '...
%         'the location of the orange spot from the '...
%         'previous trial will be marked with an '...
%         'orange line.'],...
%         colRew, num2str(100*taskParam.gParam.rewMag), colNoRew);
% elseif isequal(taskParam.gParam.taskType, 'chinese')
%     if taskParam.gParam.language == 1
%         header = 'Dein Schild';
%         if subject.rew == 1
%             colRew = 'schwarz';
%             colNoRew = 'green';
%         elseif subject.rew == 2
%             colRew = 'green';
%             colNoRew = 'blue';
%         end
%         txt = sprintf(['Wenn du die Kanonenkugeln abwehrst, verdienst du '...
%             'Geld. Du verdienst %s Cent für jede abgewehrte Kanonenkugel. '...
%             'Dieses Geld wird dir am Ende '...
%             'des Experiments ausgezahlt.\n\nDie Größe deines Schildes '...
%             'kann sich in jedem Durchgang verändern. Die Größe '...
%             'des Schildes siehst du jedoch erst, nachdem die '...
%             'Kanone geschossen hat. Daher solltest du versuchen, '...
%             'dein Schild so genau wie möglich zu positionieren, '...
%             'um so viele Kanonenkugeln wie möglich abzuwehren.\n\nUm einen '...
%             'Eindruck von der wechselnden Größe des Schildes zu '...
%             'bekommen, folgt jetzt eine kurze Übung.'],...
%             num2str(100*taskParam.gParam.rewMag));
%     elseif taskParam.gParam.language == 2
%         header = 'Your Shield';
%         if subject.rew == 1
%             colRew = 'blue';
%             colNoRew = 'green';
%         elseif subject.rew == 2
%             colRew = 'green';
%             colNoRew = 'blue';
%         end
%         %     txt = sprintf(['You can collect points by catching '...
%         %             'cannonballs in your shield. On some trials '...
%         %             'the shield will be large and on some trials it will '...
%         %             'be small. You cannot know the size of the shield '...
%         %             'until the cannon is fired so it is best to '...
%         %             'try to catch the ball on every trial.\n\n'...
%         %             'You will now have some practice to get a '...
%         %             'sense of how the size of the shield varies.'],...
%         %             'schwarz', num2str(100*taskParam.gParam.rewMag), 'schwarz');
%         txt = sprintf(['You can collect points by catching '...
%             'cannonballs in your shield. \n\nOn some trials '...
%             'the shield will be large and on some trials it will '...
%             'be small.\n\nYou cannot know the size of the shield '...
%             'until the cannon is fired, so it is best to '...
%             'try to catch the ball on every trial.\n\n'...
%             'You will now have some practice to get a '...
%             'sense of how the size of the shield varies.'],...
%             'schwarz', num2str(100*taskParam.gParam.rewMag), 'schwarz');
%     end
% elseif isequal(taskParam.gParam.taskType, 'ARC')
%     header = 'Your Shield';
%     if taskParam.gParam.showTickmark
%         txt = sprintf(['You can collect points by catching '...
%             'cannonballs in your shield. On some trials '...
%             'the shield will be large and on some trials it will '...
%             'be small. You cannot know the size of the shield '...
%             'until the cannon is fired so it is best to '...
%             'try to catch the ball on every trial.\n\n'...
%             'You will now have some practice to get a '...
%             'sense of how the size of the shield varies.'...
%             '\n\nThe location of the ball fired on the '...
%             'previous trial will be marked with a black '...
%             'line.\n\nMoreover, the location of the orange '...
%             'spot from the previous trial will be marked with an '...
%             'orange line.'],...
%             'schwarz', num2str(100*taskParam.gParam.rewMag), 'schwarz');
%     elseif ~taskParam.gParam.showTickmark
%         txt = sprintf(['You can collect points by catching '...
%             'cannonballs in your shield. On some trials '...
%             'the shield will be large and on some trials it will '...
%             'be small. You cannot know the size of the shield '...
%             'until the cannon is fired so it is best to '...
%             'try to catch the ball on every trial.\n\n'...
%             'You will now have some practice to get a '...
%             'sense of how the size of the shield varies.'],...
%             'schwarz', num2str(100*taskParam.gParam.rewMag), 'schwarz');
%     end
% else
%     header = ''
%     txt = '';
% end
[screenIndex, taskData] = introduceShieldColor(taskParam, subject, screenIndex, taskData, whichPractice);

% Run short practice block to illustrate shield size and color
%[screenIndex, taskData] = ShieldPractice(taskParam, subject, screenIndex);
condition = 'shield';
%[taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(2), taskParam.gParam.concentration(3)); 
taskData = al_generateOutcomesMain(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition);
taskParam.condition = condition;
trial = taskData.trial;
taskData.initialTendency = nan(trial,1);
%taskData.latentState = 0;
[~, taskData] =  al_mainLoop(taskParam, taskParam.gParam.haz(2), taskParam.gParam.concentration(3), condition, subject, taskData, trial);
%screenIndex = screenIndex + 1;
WaitSecs(0.1);

% XX
MainAndFollowCannon_CannonVisibleNoise(whichPractice, taskParam, subject)

% XX
condition = 'onlinePractice';
[taskData, trial] = al_loadTaskData(taskParam, condition, taskParam.gParam.haz(1), taskParam.gParam.concentration(3)); 
al_mainLoop(taskParam, taskParam.gParam.haz(1), taskParam.gParam.concentration(3), condition, subject, taskData, trial);


end