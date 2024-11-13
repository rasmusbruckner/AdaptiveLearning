% Common Confetti Version Configuration Example
%
% Example of how to add local parameter settings as config input to the
% function that runs the task.
%
% It is recommended that you create your own script with the local 
% parameter settings so that you can re-use your settings.

%PsychDebugWindowConfiguration(0,0.5);
% Create config structure
config = struct();

% Add desired parameters
config.trialsExp = 47; %47; %default for experiment is 100 for 4 blocks (400), trying 38 trials for 8 blocks (304)
config.nBlocks = 3; %blocks per noise condition, default is 2
config.practTrialsVis = 10; %10
config.practTrialsHid = 20; %20
config.cannonPractCriterion = 4; % criterion cannon practice
config.cannonPractNumOutcomes = 5; % number of trials cannon practice
config.cannonPractFailCrit = 3;
config.passiveViewing = false;
config.passiveViewingPractTrials = 10;
config.baselineFixLength = 0.25;
config.blockIndices = [1 999 999 999]; % we don't have breaks within each block
config.runIntro = true; % true
config.baselineArousal = true; % true;
config.language = 'German'; % 'English';
config.sentenceLength = 80;
config.textSize = 32;
config.vSpacing = 1;
config.headerSize = 50;
config.screenSize = [0 0 1680 1050]*1; % get(0,'MonitorPositions')*1.0;
config.screenNumber = 1;
config.s = 83;
config.enter = 13;
config.five = 15;
config.defaultParticles = true;
config.debug = false;
config.showConfettiThreshold = false;
config.printTiming = true;
config.hidePtbCursor = true;
config.dataDirectory = 'C://Users//Matlab-User//Documents//AdaptiveLearning//DataDirectory'; %'C://Users//Matlab-User//Documents//AdaptiveLearning//DataDirectory'
config.meg = false;
config.scanner = false;
config.eyeTracker = true; %true;
config.trackerVersion = 'SMI'; %set 'eyelink' or 'SMI'
config.onlineSaccades = false;
config.saccThres = 1;
config.useDegreesVisualAngle = true;
config.distance2screen = 740; %700; % defined in mm (for degrees visual angle) and eT
config.screenWidthInMM = 580; % for degrees visual angle and ET
config.screenHeightInMM = 295; %210; % for ET
config.sendTrigger = false;
config.sampleRate = 500; % Sampling rate for EEG
config.port = hex2dec('E050');
config.rotationRadPixel = 140; % 170
config.rotationRadDeg = 3.16; % 2.5
config.customInstructions = true;
config.instructionText = al_commonConfettiInstructionsJena(config.language);
config.noPtbWarnings = false;
config.predSpotCircleTolerance = 2;

if config.sendTrigger
    [config.session, ~] = IOPort( 'OpenSerialPort', 'COM3' );
else
    config.session = nan;
end

% Run task with config input
RunCommonConfettiVersion(config);