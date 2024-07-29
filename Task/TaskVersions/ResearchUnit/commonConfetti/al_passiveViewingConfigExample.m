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
config.trialsExp = 5; % we will do 50 trials
config.nBlocks = 1;
config.practTrials = 2;
config.passiveViewingPractTrials = 10;
config.passiveViewing = true;
config.baselineFixLength = 0.25;
config.blockIndices = [1 51 101 151];
config.runIntro = true;
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
config.five = 15;
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
config.rotationRadDeg = 2.5; %1.8; % todo: note that this is preliminary
config.customInstructions = true;
config.instructionText = al_commonConfettiInstructionsDefaultText(config.language);
config.noPtbWarnings = false;
config.predSpotCircleTolerance = 2;

% Run task with config input
RunCommonConfettiVersion(config);