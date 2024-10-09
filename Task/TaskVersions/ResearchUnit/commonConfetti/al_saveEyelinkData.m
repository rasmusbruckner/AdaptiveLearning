function al_saveEyelinkData(tracker_instance, et_path, et_file_name)
%AL_SAVEEYELINKDATA This function saves the eye-tracking data
%
%   Input
%       et_path: Data directory path
%       et_file_name: File name
%
%   Output
%       None
 
% !! THIS IS THE EDITED SMI VERSION FOR JENA !!
 
fprintf('Saving SMI data to %s\n', et_path)
eyefilename = fullfile(et_path,et_file_name);

tracker_instance.stopRecording();
tracker_instance.saveData(eyefilename);


% Eyelink('StopRecording');
 
end
