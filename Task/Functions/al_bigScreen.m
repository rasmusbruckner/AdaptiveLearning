function fw = al_bigScreen(taskParam, header, txt, feedback, endOfTask)
%AL_BIGSCREEN This function draws background during the instructions
%
%   Input
%       taskParam: Task-parameter-object instance
%       header: Header that is printed on screen
%       txt: Main text that is printed on screen
%       feedback: Indicates if task feedback or instructions are presented
%
%   Output
%       fw: indicates that participant pressed "go forward to next slide"


% Manage optional breakKey input: if not provided, use SPACE as default
if ~exist('endOfTask', 'var') || isempty(endOfTask)
    endOfTask = false;
end

% Todo: This has to be properly cleaned and documented

% Initialize variables
fw = 0;

while 1
    
    % Draw desired lines and background on the screen
    Screen('FillRect', taskParam.display.window.onScreen, [66 66 66]);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*0.16,...
        taskParam.display.screensize(3), taskParam.display.screensize(4)*0.16, 5);
    Screen('DrawLine', taskParam.display.window.onScreen, [0 0 0], 0, taskParam.display.screensize(4)*0.8,...
        taskParam.display.screensize(3), taskParam.display.screensize(4)*0.8, 5);
    Screen('FillRect', taskParam.display.window.onScreen, [0, 25, 51], [0, (taskParam.display.screensize(4)*0.16),...  % +3
        taskParam.display.screensize(3), (taskParam.display.screensize(4)*0.8)]); % -2
    
    % Print header
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.headerSize);
    %if isequal(taskParam.gParam.computer, 'Dresden')
     %  DrawFormattedText(taskParam.display.window.onScreen, header, 'center', 50, [255 255 255]);
    %else
    DrawFormattedText(taskParam.display.window.onScreen, header, 'center', taskParam.display.screensize(4)*0.1, [255 255 255]);
    %end
    
    % Set textsize of printed text
    % Todo: should be based on trialflow
%    if isequal(taskParam.gParam.computer, 'Dresden')
 %       Screen('TextSize', taskParam.display.window.onScreen, 19);
  %  else
        Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
   % end
    
    % Extract length of text
    sentenceLength = taskParam.strings.sentenceLength;
    
    % Print main text
    if feedback == true
        % When feedback is presented, print in screen center...
        DrawFormattedText(taskParam.display.window.onScreen, txt, 'center', 'center', [255 255 255], sentenceLength, [], [], 1);
    else
        % ...otherwise at defined location
        DrawFormattedText(taskParam.display.window.onScreen, txt, taskParam.display.screensize(4)*0.2, taskParam.display.screensize(4)*0.2,...
            [255 255 255], sentenceLength, [], [], 1);
    end
    
    % Print "Press Enter" to indicate how to continue with instructions
    if ~endOfTask
        DrawFormattedText(taskParam.display.window.onScreen,  taskParam.strings.txtPressEnter, 'center',taskParam.display.screensize(4)*0.9);
    end
    
    Screen('DrawingFinished', taskParam.display.window.onScreen);
    
    % Flip screen to present changes
    time = GetSecs;
    Screen('Flip', taskParam.display.window.onScreen, time + 0.1);
    
    % Check for response of participant to continue to next screen
    [ ~, ~, keyCode] = KbCheck( taskParam.keys.kbDev );
    if keyCode(taskParam.keys.enter) && ~taskParam.unitTest && ~endOfTask
        % keyCode
        fw = 1;  % todo: this should be deleted
        break
    elseif keyCode(taskParam.keys.s) && ~taskParam.unitTest && endOfTask
        break
    elseif taskParam.unitTest
        WaitSecs(1);
        break
    end
end

% Wait for keyboard release
KbReleaseWait();


