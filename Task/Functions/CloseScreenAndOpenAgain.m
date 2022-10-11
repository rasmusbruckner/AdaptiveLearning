function window = CloseScreenAndOpenAgain(taskParam, debug, unitTest)
%CLOSESCREENANDOPENAGAIN   This function opens and closes psychtoolbox screen
% at the end of a condition in order to signal participants that
% new task will begin. Only used in Dresden version.    
% 
%    Input
%       taskParam: structure containing task parameters
%       debug: indicates if we're currently debugging the task
%       unitText: indicates if unit test is done
%
%   Output
%       window: Psychtoolbox window

    if ~unitTest
        
        % Adjust text properties
        Screen('TextFont', taskParam.display.window.onScreen, 'Arial');
        Screen('TextSize', taskParam.display.window.onScreen, 30);
        
        % Text that appears on screen
        txt = 'Ende der Aufgabe!\n\nBitte auf den Versuchsleiter warten';

        while 1

            % Print text until "s" is pressed
            % -------------------------------
            Screen('FillRect', taskParam.display.window.onScreen, []);
            DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', 100, [0 0 0]);
            Screen('DrawingFinished', taskParam.display.window.onScreen);
            t = GetSecs;
            Screen('Flip', taskParam.display.window.onScreen, t + 0.1);
            [~, ~, keyCode] = KbCheck;
            if find(keyCode) == taskParam.keys.s
                break
            end
        end

        % Check for "s" to open the screen again
        % --------------------------------------
        WaitSecs(1);
        ShowCursor;
        Screen('CloseAll');
        disp('Press start to continue...')
        WaitSecs(1);

        while 1
            [ keyIsDown, ~, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(taskParam.keys.s)
                    break
                end
            end
        end
        window = OpenWindow(debug, taskParam.gParam.screenNumber);

    end
    window = taskParam.display.window;
end