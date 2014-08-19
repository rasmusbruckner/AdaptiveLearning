function LineAndBack(taskParam)
% This function draws the backgound during the instructions.

%In Dresden 1/3.5!

if isequal(taskParam.gParam.computer,'Dresden')
Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0, taskParam.gParam.screensize(4)*1/3.5, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*1/3.5, 5);
else 
Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0, taskParam.gParam.screensize(4)*1/4, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*1/4, 5);
end

Screen('DrawLine', taskParam.gParam.window, [0 0 0], 0, taskParam.gParam.screensize(4)*3/4, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)*3/4, 5);
Screen('FillRect', taskParam.gParam.window, [0 25 51], [0, 0, taskParam.gParam.screensize(3), (taskParam.gParam.screensize(4)*1/4)-3]);
Screen('FillRect', taskParam.gParam.window, [0 25 51], [0, taskParam.gParam.screensize(4)*3/4, taskParam.gParam.screensize(3), taskParam.gParam.screensize(4)]);
end


