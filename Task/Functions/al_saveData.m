function al_saveData(taskData)
% AL_SAVEDATA This function saves the behavioral data
%
%   Input
%       taskData: Task-data-object instance
%
%   Output
%       None

% Ensure that files cannot be overwritten
savename = taskData.savename;
checkString = dir([savename '*']);
fileNames = {checkString.name};
if  ~isempty(fileNames)
    savename = [savename '_new'];
end

% Save as struct
taskData = saveobj(taskData);
save(savename, 'taskData');

end