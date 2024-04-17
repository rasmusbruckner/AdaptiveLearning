% This script computes the length of the planned Magdeburg fMRI experiment

% Load timing parameters
timingParam = al_timing();

% Set planned parameter values
timingParam.cannonBallAnimation = 0.5;
timingParam.cannonMissAnimation = 0.75;
timingParam.jitterITI = 4;
timingParam.jitterOutcome = 4;
timingParam.fixCrossLength = 2;
timingParam.fixedITI = 2;

% Expected reaction time, number of trials and blocks
expectedRT = 2;
nTrials = 60;
nBlocks = 6;

% Compute expected length
al_computeExperimentLength(expectedRT, timingParam, nTrials, nBlocks)