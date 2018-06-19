function window = CloseScreenAndOpenAgain(taskParam, debug, unitTest)
    %CLOSESCREENANDOPENAGAIN   Opens and closes psychtoolbox screen
    %at the end of a condition in order to signal participants that
    %new task will begin

    if ~unitTest

        Screen('TextFont', taskParam.gParam.window, 'Arial');
        Screen('TextSize', taskParam.gParam.window, 30);

        txt='Ende der Aufgabe!\n\nBitte auf den Versuchsleiter warten';

        while 1

            Screen('FillRect', taskParam.gParam.window, []);
            DrawFormattedText(taskParam.gParam.window, txt,...
                'center', 100, [0 0 0]);
            Screen('DrawingFinished', taskParam.gParam.window);


            t = GetSecs;
            Screen('Flip', taskParam.gParam.window, t + 0.1);
            [~, ~, keyCode] = KbCheck;

            if find(keyCode) == taskParam.keys.s
                break
            end

        end

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

        window = OpenWindow(debug);

    end
    window = taskParam.gParam.window;
end