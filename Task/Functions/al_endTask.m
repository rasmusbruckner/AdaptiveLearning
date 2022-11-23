function al_endTask(taskType, taskParam, textSize, totWin, subject)
%AL_ENDTASK This function implements the screen that shows collected amount of money
%
%   Input
%       taskType: current task type
%       taskParam: structure containing task parameters
%       textSize: size of the printed text
%       totWin: payoff
%       subject: structure containing information about subject
%
%   Output
%       ~

% todo: use trialflow instead of taskType

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
    elseif isequal(taskType, 'ARC') || isequal(taskType, 'Hamburg')  || isequal(taskType, 'Sleep')
        header = 'End of task!';
        txt = sprintf('Thank you for participating!\n\n\nYou earned %.0f points.', totWin*10);
    end
    
    % Draw text, lines and rectangles
    % -------------------------------
    % todo: replace by lineAndBack function
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*0.16, taskParam.display.screensize(3), taskParam.display.screensize(4)*0.16, 5);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*0.8, taskParam.display.screensize(3), taskParam.display.screensize(4)*0.8, 5);
    Screen('FillRect', taskParam.display.window.onScreen, [0 25 51], [0, (taskParam.display.screensize(4)*0.16)+3, taskParam.display.screensize(3), (taskParam.display.screensize(4)*0.8)-2]);
    
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.headerSize);
    DrawFormattedText(taskParam.display.window.onScreen, header, 'center', taskParam.display.screensize(4)*0.1);
    Screen('TextSize', taskParam.display.window.onScreen, textSize);
    DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', 'center');
    
    % Flip screen to present changes
    % ------------------------------
    Screen('DrawingFinished', taskParam.display.window.onScreen, [], []);
    time = GetSecs;
    Screen('Flip', taskParam.display.window.onScreen, time + 0.1);
    
    % Check for keypress
    % ------------------
    [ ~, ~, keyCode] = KbCheck( taskParam.keys.kbDev );
    if find(keyCode) == taskParam.keys.s & ~taskParam.unitTest
        break
    elseif taskParam.unitTest
        WaitSecs(1);
        break
    end
end
end