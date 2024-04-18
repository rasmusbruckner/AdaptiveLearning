% Common Confetti Version Configuration Example
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
config.runIntro = true;
config.sentenceLength = 75;
config.textSize = 35;
config.headerSize = 50;
config.screenSize = get(0,'MonitorPositions')*1.0;
config.s = 40;
config.enter = 37;
config.debug = false;
config.showConfettiThreshold = false;
config.printTiming = true;
config.dataDirectory = '~/Dropbox/AdaptiveLearning/DataDirectory';
config.scanner = false;
config.eyeTracker = false;
config.sendTrigger = false;

% Run task with config input
RunCommonConfettiVersion(config);