% Infant Version Configuration Example
%
% Example of how to add local parameter settings as config input to the
% function that runs the task.
%
% It is recommended that you create your own script with the local 
% parameter settings so that you can re-use your settings.

% Create config structure
config = struct();

% Add desired parameters
config.trialsExp = 4; % habituation trials
config.practTrials = 8; % test trials
config.sentenceLength = 100;
config.textSize = 35;
config.vSpacing = 1;
config.headerSize = 50;
config.screenSize = [0 0 1920 1080]*0.5; % get(0,'MonitorPositions')*1.0;
config.screenNumber = 1;
config.s = 40;
config.enter = 37;
config.defaultParticles = false;
config.debug = false;
config.printTiming = true;
config.hidePtbCursor = false; % turn on when using "mouse tracking" but turn off for eye tracking
config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
config.eyeTracker = false;
config.useDegreesVisualAngle = true;
config.distance2screen = 700; % defined in mm (for degrees visual angle) and eT
config.screenWidthInMM = 309.40; % for degrees visual angle and ET
config.screenHeightInMM = 210; % for ET
config.sendTrigger = false;
config.rotationRadPixel = 140; % 170
config.rotationRadDeg = 3.16;%1.8; % todo: note that this is preliminary
config.customInstructions = true;
config.instructionText = al_commonConfettiInstructionsDefaultText('German');
config.noPtbWarnings = false;

% Run task with config input
RunInfantVersion(config);