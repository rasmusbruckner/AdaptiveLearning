function al_conditionIndication(taskParam, txtNoise, txtPressEnter)
%AL_CONDITIONINDICATION This function displays the current task condition
%
%   Input
%       taskParam: structure containing task parameters
%       txtNoise: text indicating current condition
%       txtPressEnter: text indicating that enter should be pressed to continue
%
%   Output
%       ~


% Draw desired text 
DrawFormattedText(taskParam.display.window.onScreen, txtNoise, 'center','center', [255 255 255]);
DrawFormattedText(taskParam.display.window.onScreen,txtPressEnter,'center', taskParam.gParam.screensize(4)*0.9);
Screen('DrawingFinished', taskParam.display.window.onScreen);
t = GetSecs;
Screen('Flip', taskParam.display.window.onScreen, t + 0.1);

% Check for keyboard press to continue instruction
if ~taskParam.unitTest
    while 1
        
        [ keyIsDown, ~, keyCode ] = KbCheck;
        if keyIsDown
            if find(keyCode) == taskParam.keys.enter
                break
            end
        end
    end
else
    WaitSecs(1);
end
end

