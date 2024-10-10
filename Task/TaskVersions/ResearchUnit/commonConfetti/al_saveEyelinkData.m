function al_saveEyelinkData(et_path, et_file_name)
%AL_SAVEEYELINKDATA This function saves the eye-tracking data
%
%   Input
%       et_path: Data directory path
%       et_file_name: File name
%
%   Output
%       None

fprintf('Saving EyeLink data to %s\n', et_path)
eyefilename = fullfile(et_path,et_file_name);
Eyelink('CloseFile');
Eyelink('WaitForModeReady', 500);
try
    status = Eyelink('ReceiveFile', et_file_name, eyefilename);
    disp(['File ' eyefilename ' saved to disk']);
catch
    warning(['File ' eyefilename ' not saved to disk']);
end
% Eyelink('StopRecording');

end