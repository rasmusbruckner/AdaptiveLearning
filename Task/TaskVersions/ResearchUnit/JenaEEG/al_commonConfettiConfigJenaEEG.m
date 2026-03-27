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
config.trialsExp = 60; %default for experiment is 200 for each noise condition
config.nBlocks = 4; %blocks per noise condition, i.e. 4 blocks
config.practTrialsVis = 10;
config.practTrialsHid = 20; 
config.cannonPractCriterion = 4; % criterion cannon practice
config.cannonPractNumOutcomes = 5; % number of trials cannon practice
config.cannonPractFailCrit = 3;
config.passiveViewing = false;
config.passiveViewingPractTrials = 10;
config.baselineFixLength = 0.25;
config.blockIndices = [1 999 999 999]; % we don't have breaks within each block

config.runIntro = false; % false;
config.baselineArousal = false; % true;

config.language = 'German'; % 'English';
config.sentenceLength = 70;
config.textSize = 32;
config.vSpacing = 1;
config.headerSize = 50;
config.screenSize = [0 0 1280 1024]*1; % get(0,'MonitorPositions')*1.0;
config.globalScreenBorder = 0; %1920; % default is 0
config.screenNumber = 1;
config.s = 83;
config.enter = 13;
config.five = 15;
config.defaultParticles = true;
config.debug = false;
config.showConfettiThreshold = false;
config.printTiming = true;
config.hidePtbCursor = true;
config.dataDirectory = 'C://Users//Matlab-User//Documents//AdaptiveLearning//DataDirectory';
config.meg = false;
config.scanner = false;
config.eyeTracker = false; %true;
config.onlineSaccades = false;
config.saccThres = 1;
config.useDegreesVisualAngle = true;
config.distance2screen = 740; %700; % defined in mm (for degrees visual angle) and eT
config.screenWidthInMM = 386; % for degrees visual angle and ET
config.screenHeightInMM = 290; %210; % for ET

% #todo für mat 2025 wieder rausnehmen!
% config.trackerVersion = 'SMI';

config.sendTrigger = true;
config.sampleRate = 512; % Sampling rate for EEG
%config.port = hex2dec('E050');
config.port = hex2dec('378');

config.rotationRadPixel = 140; % 170
config.rotationRadDeg = 3.16; % 2.5
config.customInstructions = true;
config.instructionText = al_commonConfettiInstructionsJena(config.language);
config.noPtbWarnings = false;
config.predSpotCircleTolerance = 2;

if config.sendTrigger
    %[config.session, ~] = IOPort( 'OpenSerialPort', 'COM1' );
    ioObj = io64; 
    status = io64(ioObj);    
    config.session = ioObj;
        
        % Initialize the driver (status 0 = success)
        
        
        if status ~= 0
            error(['io64 driver i' ...
                'nstallation failed. Do you have inpoutx64.dll?']);
        end
        
        % Reset port to 0 at start to ensure lines are low
        io64(ioObj, config.port, 0);
else
    config.session = nan;
end

% Run task with config input
RunCommonConfettiVersion(config);