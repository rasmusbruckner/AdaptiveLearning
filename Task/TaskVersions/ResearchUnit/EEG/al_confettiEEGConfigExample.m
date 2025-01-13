% Confetti EEG Version Configuration Example
%
% Example of how to add local parameter settings as config input to the
% function that runs the task.
%
% It is recommended that you create your own script with the local 
% parameter settings so that you can re-use your settings.

% Create config structure
config = struct();

% Add desired parameters
config.trialsExp = 2;
config.practTrials = 2;
config.blockIndices = [1 51 101 151];
config.runIntro = true;
config.sentenceLength = 100;
config.textSize = 35;
config.vSpacing = 1;
config.headerSize = 50;
config.screenSize = get(0,'MonitorPositions')*1.0;
config.s = 40;
config.enter = 37;
config.defaultParticles = true;
config.debug = false;
config.showConfettiThreshold = false;
config.printTiming = true;
config.hidePtbCursor = true;
config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
config.useDegreesVisualAngle = true;
config.distance2screen = 700; % defined in mm (for degrees visual angle) and eT
config.screenWidthInMM = 309.40; % for degrees visual angle and ET
config.sendTrigger = false;
config.rotationRadPixel = 140;
config.rotationRadDeg = 2.5;
config.noPtbWarnings = false;
config.predSpotCircleTolerance = 2;

% config.customInstructions = true;
% config.instructionText = al_commonConfettiInstructionsDefaultText_updated(config.language);

% Run task with config input
RunConfettiEEGVersion(config);