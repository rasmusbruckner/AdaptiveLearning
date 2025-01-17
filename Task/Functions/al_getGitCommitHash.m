function commitHash = al_getGitCommitHash()
% AL_GETGITCOMMITHASH This function gets the commit hash from git to track
% for transparency
%
%   Input
%       None
%
%   Output
%       commitHash: Commit hash of the active branch

% Main task folder
projectRoot = al_findProjectRoot();

% Define the path to the .git/HEAD file
headFilePath = fullfile(projectRoot, '.git', 'HEAD');

% Check if the .git/HEAD file exists
if ~isfile(headFilePath)
    error('.git/HEAD file not found. Ensure you are in a Git repository.');
end

% Read the contents of the .git/HEAD file
headContent = strtrim(fileread(headFilePath));

if startsWith(headContent, 'ref:')

    % Extract the branch reference path (e.g., refs/heads/main)
    refPath = strtrim(strrep(headContent, 'ref:', ''));

    % Construct the full path to the reference file
    refFilePath = fullfile(projectRoot, '.git', refPath);

    % Read the commit hash from the reference file
    if isfile(refFilePath)
        commitHash = strtrim(fileread(refFilePath));
    else
        error('Reference file %s not found.', refFilePath);
    end
else
    % If .git/HEAD contains a direct commit hash, use it directly
    commitHash = headContent;
end

end
