function al_indicateCannonNoise(taskParam, noiseCondition)
% AL_INDICATECANNONNOISE This function indicates the noise
% condition in the cannon task
%
%   Input:
%       taskParam: Task-parameter-object instance
%       noiseCondition: High vs. low noise
%
%   Output:
%       None

if strcmp(noiseCondition, 'lowNoise')
    header = 'Genauere Kanone';
    txt = 'Im folgenden Block wird die Kanone relativ genau sein.\n\n';

elseif strcmp(noiseCondition, 'highNoise')
    header = 'Ungenauere Kanone';
    txt = 'Im folgenden Block wird die Kanone relativ ungenau sein.';
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end