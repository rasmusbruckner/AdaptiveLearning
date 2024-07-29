% This script computes the length of the common confetti experiment

% Load timing parameters
timingParam = al_timing();

% Set planned parameter values
timingParam.baselineFixLength = 0.25;
timingParam.fixCrossOutcome = 2;
timingParam.fixCrossShield = 0.7;
timingParam.fixedITI = 1.0;
timingParam.jitterFixCrossOutcome = 2;
timingParam.jitterFixCrossShield = 0.6;
timingParam.outcomeLength = 0.65;
timingParam.jitterOutcome = 0.3;
timingParam.shieldLength = 0.65; 
timingParam.jitterShield = 0.3;
timingParam.jitterITI = 0.5;

% Expected reaction time, number of trials and blocks
expectedRT = 2;
nTrials = 60;
nBlocks = 4;

% Compute expected length
al_computeExperimentLength(expectedRT, timingParam, nTrials, nBlocks, 'commonConfetti')