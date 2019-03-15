function al_endTask(taskType, taskParam, textSize, totWin, subject)
%AL_ENDTASK   Screen that shows collected amount of money
%
%   INPUT
%       taskType: current task type
%       taskParam: structure containing task parameters
%       textSize: size of the printed text
%       totWin: payoff
%       subject: structure containing information about subject
%   Output
%       ~ 


while 1
    
    % Depending on task type, select what should be printed on screen
    % ---------------------------------------------------------------
    if isequal(taskType, 'oddball') || isequal(taskType, 'reversal')
        header = 'End of task!';
        txt = sprintf('Thank you for participating!\n\n\nYou earned $ %.2f', totWin);
    elseif isequal(taskType, 'dresden') 
        header = 'Ende des Versuchs!';
        if isequal(subject.group, '1')
            txt = sprintf('Vielen Dank für deine Teilnahme!\n\n\nDu hast %.2f Euro verdient.', totWin);
        else
            txt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben %.2f Euro verdient.', totWin);
        end
    elseif isequal(taskType, 'chinese')    
        header = 'End of task!';
        txt = sprintf('Thank you for participating!\n\n\nYou earned %.0f points.', totWin);    
    elseif isequal(taskType, 'ARC')
        header = 'End of task!';
        txt = sprintf('Thank you for participating!\n\n\nYou earned %.0f points.', totWin*10);
    end
    
    % Draw text, lines and rectangles
    % -------------------------------
    Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], 0, taskParam.gParam.screensize(4)*0.16, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.16, 5);
    Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], 0, taskParam.gParam.screensize(4)*0.8, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.8, 5);
    Screen('FillRect', taskParam.gParam.window.onScreen, [0 25 51], [0, (taskParam.gParam.screensize(4)*0.16)+3, taskParam.gParam.screensize(3), (taskParam.gParam.screensize(4)*0.8)-2]);
    Screen('TextSize', taskParam.gParam.window.onScreen, 30);
    DrawFormattedText(taskParam.gParam.window.onScreen, header, 'center', taskParam.gParam.screensize(4)*0.1);
    Screen('TextSize', taskParam.gParam.window.onScreen, textSize);
    DrawFormattedText(taskParam.gParam.window.onScreen, txt, 'center', 'center');
    
    % Flip screen to present changes
    % ------------------------------
    Screen('DrawingFinished', taskParam.gParam.window.onScreen, [], []);
    time = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, time + 0.1);
    
    % Check for keypress
    % ------------------
    [ ~, ~, keyCode] = KbCheck;
    if find(keyCode) == taskParam.keys.s & ~taskParam.unitTest
        break
    elseif taskParam.unitTest
        WaitSecs(1);
        break
    end
end
end