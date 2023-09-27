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
breakKey = taskParam.keys.enter; % enter required to continue

% Todo update using trialflow mouse vs. keyboard
if strcmp(taskParam.gParam.taskType, 'Sleep')
    
    [~, taskParam] = al_keyboardLoop(taskParam, taskData, trial, initRT_Timestamp, txt, breakKey);

elseif strcmp(taskParam.gParam.taskType, 'Hamburg') || isequal(taskParam.gParam.taskType, 'asymReward') || strcmp(taskParam.gParam.taskType, 'HamburgEEG') || strcmp(taskParam.gParam.taskType, 'Leipzig')
    
    % Reset mouse to screen center
    SetMouse(taskParam.display.screensize(3)/2, taskParam.display.screensize(4)/2, taskParam.display.window.onScreen) % 720, 450,

    % Participant indicates prediction
    press = 0;
    condition = 'main';
    [~, taskParam] = al_mouseLoop(taskParam, taskData, condition, trial, initRT_Timestamp, press, txt, breakKey);

end
WaitSecs(0.1);

end
