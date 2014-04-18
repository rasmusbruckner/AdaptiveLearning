function taskDataControl = GenerateControlOutcomes(taskParam)
%This function generates the outcomes for BattleShipsControl
%   It generates random numbers between 0 and 360 degrees. 

% Preallocate variables.
trial = zeros(taskParam.contTrials, 1);
outcome= zeros(taskParam.contTrials, 1);       
ID = cell(trial, 1);
age = zeros(trial, 1);
sex = cell(trial, 1);

% Generate outcomes.
for i = 1:length(trial)
        outcome(i) = round(rand(1).*360); 
end

% Field names.
fTrial = 'trial';
fOutcome = 'outcome';
fID = 'ID';
fAge = 'age';
fSex = 'sex';

% Save data in struct. 
taskDataControl = struct(fID, {ID}, fAge, age,fSex, {sex}, fTrial, i, fOutcome, outcome);
end