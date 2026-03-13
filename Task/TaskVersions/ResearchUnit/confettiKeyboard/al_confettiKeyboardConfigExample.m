% Confetti-cannon-task configuration example for keyboard version
%
% Example of how to add local parameter settings as config input to the
% function that runs the task.
%
% It is recommended that you create your own script with the local 
% parameter settings so that you can re-use your settings.


% Create config structure
config = struct();

% Add desired parameters
config.trialsExp = 5;
config.nBlocks = 4;
config.practTrialsVis = 10;
config.practTrialsHid = 20; 
config.passiveViewing = false;
config.baselineFixLength = 0.25;
config.blockIndices = [1 999 999 999]; % we don't have breaks within each block
config.runIntro = true;
config.language = 'German'; %'English';
config.sentenceLength = 100;
config.textSize = 35;
config.vSpacing = 1;
config.headerSize = 50;
config.screenSize = [0 0 1920 1080]*1; %0.5; % get(0,'MonitorPositions')*1.0;
config.globalScreenBorder = 0; % 1920; % default is 0
config.screenNumber = 1;
config.s = 40;
config.enter = 37;
config.five = 15;
config.defaultParticles = true;
config.debug = false;
config.showConfettiThreshold = false;
config.printTiming = true;
config.hidePtbCursor = true;
config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
config.scanner = false;
config.useDegreesVisualAngle = true;
config.distance2screen = 350; % defined in mm (for degrees visual angle)
config.screenWidthInMM = 309.40; % for degrees visual angle 
config.rotationRadPixel = 140;
config.rotationRadDeg = 5;
config.customInstructions = false;
config.noPtbWarnings = false;

% Run task with config input
RunConfettiKeyboardVersion(config);