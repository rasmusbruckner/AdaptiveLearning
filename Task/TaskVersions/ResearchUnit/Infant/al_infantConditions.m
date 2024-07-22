function [dataInfantBlock1, dataInfantBlock2] = al_infantConditions(taskParam)
%AL_INFANTCONDITIONS This function runs the duck-pond conditions
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       dataInfantBlock1: Task-data object block 1
%       dataInfantBlock2: Task-data object block 2


% Screen background
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.background);

% Extract concentration
concentration = taskParam.gParam.concentration;

% Update trial flow
taskParam.trialflow.shot = 'static';
taskParam.trialflow.colors = 'dark';
taskParam.trialflow.shieldAppearance = 'lines';
taskParam.trialflow.exp = 'exp';

% ------------
% Main task
% ------------

% Initialize and set up eye-tracker file
if taskParam.gParam.eyeTracker

    % opens up class
    Tobii = EyeTrackingOperations();
    
    % searches Eyetrackers via USB / Ethernet and Network
    found_eyetrackers = tobii.find_all_eyetrackers();
    
    % gives info on first found Eyetracker
    myTobii = found_eyetrackers(1);
    disp(["Address: ", myTobii.Address])
    disp(["Model: ", myTobii.Model])
    disp(["Name: ", myTobii.Name])
    disp(["Serial number: ", myTobii.SerialNumber])

else 

    myTobii = nan;
    disp("No Tobii eye-tracker connected")
    
end

% Total number of trials: practice (habituation) + exp (test trials)
trial = taskParam.gParam.practTrials + taskParam.gParam.trials;

% Run task block 1
taskParam.trialflow.exp = 'block1';
dataInfantBlock1 = al_infantLoop(taskParam, 'main', concentration, trial, myTobii);

% Run task block 2
al_bigScreen(taskParam, ' ', 'Zweiter Durchgang', true, true);
taskParam.trialflow.exp = 'block2';
dataInfantBlock2 = al_infantLoop(taskParam, 'main', concentration, trial, myTobii);

end