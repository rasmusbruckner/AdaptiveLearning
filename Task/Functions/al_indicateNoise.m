function al_indicateNoise(taskParam, noiseCondition)
% AL_INDICATENOISE This function indicates the noise
% condition
%
%   Input:
%       taskParam: Task-parameter-object instance
%       noiseCondition: High vs. low noise
%
%
%   Output:
%       ~

% Todo: change comments so that this is about push vs. noPush

if strcmp(noiseCondition, 'lowNoise')
    header = 'Genauere Konfetti-Kanone';
    txt = 'Im folgenden Block wird die Konfetti-Kanone relativ genau sein.';

elseif strcmp(noiseCondition, 'highNoise')
    header = 'Ungenauere Konfetti-Kanone';
    txt = 'Im folgenden Block wird die Konfetti-Kanone relativ ungenau sein.';
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end