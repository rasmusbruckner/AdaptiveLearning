function taskParam = al_introduceCannon(taskParam, taskData, trial, txt)
%AL_INTRODUCECANNON This function introduces the cannon to the participants
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       txt: Presented text
%
%   Output
%       taskParam: Task-parameter-object instance

WaitSecs(0.1);

% Set text size and font
Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
Screen('TextFont', taskParam.display.window.onScreen, 'Arial');

% Show cannon and instructions
initRT_Timestamp = GetSecs(); % reference value to compute initiation RT
break_key = taskParam.keys.enter; % enter required to continue
[~, taskParam] = al_keyboardLoop(taskParam, taskData, trial, initRT_Timestamp, txt, break_key);

WaitSecs(0.1);

end
