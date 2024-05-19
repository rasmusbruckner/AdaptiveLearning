function al_bigScreen(taskParam, header, txt, feedback, endOfTask)
%AL_BIGSCREEN This function draws the background during the instructions
%
%   Input
%       taskParam: Task-parameter-object instance
%       header: Header that is displayed
%       txt: Main text that is displayed
%       feedback: Indicates if task feedback or instructions are presented
%       endOfTask: Optional input argument for different breakKey
%
%   Output
%       None


% Manage optional breakKey input: if not provided, use SPACE as default
if ~exist('endOfTask', 'var') || isempty(endOfTask)
    endOfTask = false;
end

% Display text until keypress
while 1
    % Draw desired lines and background on the screen
    Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*0.16,...
        taskParam.display.screensize(3), taskParam.display.screensize(4)*0.16, 5);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*0.8,...
        taskParam.display.screensize(3), taskParam.display.screensize(4)*0.8, 5);
    Screen('FillRect', taskParam.display.window.onScreen, [0, 25, 51], [0, (taskParam.display.screensize(4)*0.16),...  % +3
        taskParam.display.screensize(3), (taskParam.display.screensize(4)*0.8)]);
    
    % Print header
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.headerSize);
    DrawFormattedText(taskParam.display.window.onScreen, header, 'center', taskParam.display.screensize(4)*0.1, [255 255 255]);
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
    
    % Extract length of text
    sentenceLength = taskParam.strings.sentenceLength;
    
    % Print main text
    if feedback == true
        % When feedback is presented, print in screen center...
        DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', 'center', [255 255 255], sentenceLength, [], [], taskParam.strings.vSpacing);
    else
        % ...otherwise at defined location
        DrawFormattedText(taskParam.display.window.onScreen, txt, taskParam.display.screensize(4)*0.2, taskParam.display.screensize(4)*0.2,...
            [255 255 255], sentenceLength, [], [], taskParam.strings.vSpacing);
    end
    
    % Print "Press Enter" to indicate how to continue with instructions
    if ~endOfTask
        DrawFormattedText(taskParam.display.window.onScreen,  taskParam.strings.txtPressEnter, 'center', taskParam.display.screensize(4)*0.9);
    else
        DrawFormattedText(taskParam.display.window.onScreen,  'Bitte auf Versuchtsleiter:in warten...', 'center', taskParam.display.screensize(4)*0.9);
    end
    
    % All text strings are presented
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    
    % Flip screen to present changes
    time = GetSecs;
    Screen('Flip', taskParam.display.window.onScreen, time + 0.1);
    
    % Check for response of participant to continue to next screen
    [ ~, ~, keyCode] = KbCheck( taskParam.keys.kbDev );
    if keyCode(taskParam.keys.enter) && ~taskParam.unitTest.run && ~endOfTask
        break
    elseif keyCode(taskParam.keys.s) && ~taskParam.unitTest.run && endOfTask
        break
    elseif taskParam.unitTest.run
        WaitSecs(1);
        break
    elseif keyCode(taskParam.keys.esc)
        ListenChar();
        ShowCursor;
        Screen('CloseAll');
        error('User pressed Escape to finish task')
    end
end

% Wait for keyboard release
KbReleaseWait();


