function [el, options] = ELconfig(window, subj, options)
% ELCONFIG This function configurates the EyeLink eye-tracker
%
%   Input
%       window: Psychtoolbox window
%       subj: Eye-tracker file name
%       options: Eye-tracker settings
%
%   Output
%       el: Info about ET settings used for calibration
%       options: Options structure


% Initialize eye-tracker
dummymode=0;
[IsConnected, IsDummy] = EyelinkInit(dummymode);
if IsDummy, warning('SetupEL:dummy','EyeLink in dummy mode!'); end
if ~IsConnected
    warning('SetupEL:noInit','Failed to initialize EyeLink!');
    return
end

% Inform user about eye-tracker version
[~, vs]   = Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );

% Set defaults based on "window" input
el = EyelinkInitDefaults(window);

% make sure we get the right data from eyelink - all of it!
Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,DIAMETER,GAZERES,HREF,PUPIL,INPUT,STATUS,BUTTON');
Eyelink('command', 'link_event_data = GAZE,GAZERES,HREF,DIAMETER,VELOCITY,STATUS');
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK, MESSAGE, INPUT,BUTTON');
Eyelink('command', 'file_sample_data = LEFT,RIGHT,GAZE,DIAMETER,GAZERES,HREF,PUPIL,STATUS,BUTTON,INPUT,HTARGET');
Eyelink('command', 'file_event_data = GAZE,GAZERES,HREF,DIAMETER,VELOCITY');
Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
Eyelink('command', 'enable_automatic_calibration = NO');
Eyelink('command', 'calibration_type = HV5');
Eyelink('command', 'generate_default_targets = NO');

% set up targets ("dots") for calibration and validation
targets = sprintf('calibration_targets = %i,%i %i,%i %i,%i %i,%i %i,%i',...
    options.window_rect(3)/2, options.window_rect(4)/2,...
    options.window_rect(3)/2-200, options.window_rect(4)/2,...
    options.window_rect(3)/2+200, options.window_rect(4)/2,...
    options.window_rect(3)/2, options.window_rect(4)/2-200,...
    options.window_rect(3)/2, options.window_rect(4)/2+200);
vtargets = sprintf('validation_targets = %i,%i %i,%i %i,%i %i,%i %i,%i',...
    options.window_rect(3)/2, options.window_rect(4)/2,...
    options.window_rect(3)/2-200, options.window_rect(4)/2,...
    options.window_rect(3)/2+200, options.window_rect(4)/2,...
    options.window_rect(3)/2, options.window_rect(4)/2-200,...
    options.window_rect(3)/2, options.window_rect(4)/2+200);
Eyelink('command', targets);
Eyelink('command', vtargets);

el.callback = [];
EyelinkUpdateDefaults(el);

%  open edf file for recording data from Eyelink - CANNOT BE MORE THAN 8 CHARACTERS
if length(subj)<=8
    options.edfFile = sprintf('%s.edf', subj);
else
    options.edfFile = sprintf('%s.edf', subj(end-7:end));
end
Eyelink('Openfile', options.edfFile);

% Send information that is written in the preamble
preamble_txt = sprintf('%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %d', ...
    'Experiment', 'CNFDNC', ...
    'subjectnr', subj, ...
    'edfname', options.edfFile, ...
    'screen_hz', options.frameRate, ...
    'screen_resolution', options.window_rect, ...
    'date', datestr(now),...
    'screen_distance', options.dist);
Eyelink('command', 'add_file_preamble_text ''%s''', preamble_txt);

end