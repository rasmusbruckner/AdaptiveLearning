function catchTrial = al_generateCatchTrial(taskParam, cp)
%AL_GENERATECATCHTRIAL   This function samples a catch trial.
%
%   Input
%       cp: changepoint indication
%
%   Output
%       catchTrial: sampled catch trial

if rand <= taskParam.gParam.catchTrialProb && cp == 0
    catchTrial = 1;
else
    catchTrial = 0;
end
end