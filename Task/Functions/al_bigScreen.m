function fw = al_bigScreen(taskParam, txtPressEnter, header, txt, feedback)
%AL_BIGSCREEN   This function draws background during the instructions
%
%   Input
%       taskParam: structure containing task parameters
%       txtPressEnter:  text that indicates that enter should be pressed to continue
%       header: header that is printed on screen
%       txt: main text that is printed on screen
%       feedback: indicates if task feedback or instructions are presented
%
%   Output
%       fw: indicates that participant pressed "go forward to next slide"


% Initialize variables
fw = 0;

while 1
    
    % Draw desired lines and background on the screen
    Screen('FillRect', taskParam.gParam.window.onScreen, [66 66 66]);
    Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], 0, taskParam.gParam.screensize(4)*0.16,...
        taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.16, 5);
    Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0], 0, taskParam.gParam.screensize(4)*0.8,...
        taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*0.8, 5);
    Screen('FillRect', taskParam.gParam.window.onScreen, [0, 25, 51], [0, (taskParam.gParam.screensize(4)*0.16)+3,...
        taskParam.gParam.screensize(3), (taskParam.gParam.screensize(4)*0.8)-2]);
    
    % Print header
    Screen('TextSize', taskParam.gParam.window.onScreen, 30);
    if isequal(taskParam.gParam.computer, 'Dresden')
        DrawFormattedText(taskParam.gParam.window.onScreen, header, 'center', 50, [255 255 255]);
    else
        DrawFormattedText(taskParam.gParam.window.onScreen, header, 'center', taskParam.gParam.screensize(4)*0.1, [255 255 255]);
    end
    
    % Set textsize of printed text
    if isequal(taskParam.gParam.computer, 'Dresden')
        Screen('TextSize', taskParam.gParam.window.onScreen, 19);
    else
        Screen('TextSize', taskParam.gParam.window.onScreen, 30);
    end
    
    % Extract length of text
    sentenceLength = taskParam.gParam.sentenceLength;
    
    % Print main text
    if feedback == true
        % When feedback is presented, print in screen center...
        DrawFormattedText(taskParam.gParam.window.onScreen, txt, 'center', 'center', [255 255 255], sentenceLength, [], [], 1);
    else
        % ...otherwise at defined location
        DrawFormattedText(taskParam.gParam.window.onScreen, txt, taskParam.gParam.screensize(4)*0.2, taskParam.gParam.screensize(4)*0.2,...
            [255 255 255], sentenceLength, [], [], 1);
    end
    
    % Print "Press Enter" to inticate how to continue with instructions
    DrawFormattedText(taskParam.gParam.window.onScreen, txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('DrawingFinished', taskParam.gParam.window.onScreen);
    
    % Flip screen to present changes
    time = GetSecs;
    Screen('Flip', taskParam.gParam.window.onScreen, time + 0.1);
    
    % Check for response of participant to continue to next screen
    [ ~, ~, keyCode] = KbCheck;
    if keyCode(taskParam.keys.enter) && ~taskParam.unitTest
        fw = 1;
        break
    elseif taskParam.unitTest
        WaitSecs(1);
        break
    end
end

% Wait for keyboard release
KbReleaseWait();


