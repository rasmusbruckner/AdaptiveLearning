function projectRoot = al_findProjectRoot()
% AL_FINDPROJECTROOT This function finds the common task folder
%
%   Input
%       None
%
%   Output
%       projectRoot: Common task folder


% Start at the folder of the currently running script
currentFolder = fileparts(mfilename('fullpath'));

% Define a marker to identify the project root, e.g., a .git folder or README file
rootMarker = '.git'; % Change this to any marker file/folder in your project root, like 'README.md'

% Loop upwards to find the project root
while ~isfolder(fullfile(currentFolder, rootMarker)) && ~isempty(currentFolder)
    % Move up one directory level
    currentFolder = fileparts(currentFolder);
end

% Check if we found the root
if isempty(currentFolder)
    error('Project root not found. Ensure the project has a %s marker.', rootMarker);
else
    projectRoot = currentFolder;
end
end