function catchTrial = al_generateCatchTrial(cp)
%AL_GENERATECATCHTRIAL   This function samples a catch trial.
%
%   Input
%       cp: change point indication
%
%   Output
%       catchTrial: sampled catchTrial

    if rand <= .10 && cp == 0
        catchTrial = 1;
    else
        catchTrial = 0;
    end
end