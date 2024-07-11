% Passive Viewing Configuration Example
%
% Example of how to add local parameter settings as config input to the
% function that runs the task.
%
% It is recommended that you create your own script with the local 
% parameter settings so that you can re-use your settings.


% todo: optionally no noise conditions and only random outcomes with haz=1

% Create config structure
config = struct();

% Add desired parameters
config.trialsExp = 5;
config.practTrials = 2;
config.passiveViewing = true;
config.baselineFixLength = 0.75; % in this case slightly longer baseline to ensure response window is long enough
config.blockIndices = [1 51 101 151];
config.runIntro = false;
config.baselineArousal = false;
config.language = 'German';
config.sentenceLength = 100;
config.textSize = 35;
config.vSpacing = 1;
config.headerSize = 50;
config.screenSize = [0 0 1920 1080]*1;
config.screenNumber = 1;
config.s = 40;
config.enter = 37;
config.five = 15; %'5';
config.debug = false;
config.showConfettiThreshold = false;
config.printTiming = true;
config.hidePtbCursor = true;
config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
config.scanner = false;
config.eyeTracker = false;
config.useDegreesVisualAngle = true;
config.distance2screen = 700; % defined in mm (for degrees visual angle) and eT
config.screenWidthInMM = 309.40; % for degrees visual angle and ET
config.screenHeightInMM = 210; % for ET
config.sendTrigger = false;
config.rotationRadPixel = 140; % 170
config.rotationRadDeg = 3.16; %1.8; % todo: note that this is preliminary
config.customInstructions = true;
config.instructionText = al_commonConfettiInstructionsDefaultText(config.language);
config.noPtbWarnings = false;

% Run task with config input
RunCommonConfettiVersion(config);