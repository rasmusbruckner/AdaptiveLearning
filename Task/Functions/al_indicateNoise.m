function al_indicateNoise(taskParam)
% AL_INDICATE_NOISE This function indicates the noise
% condition
%
%   Input:
%       condition: High vs. low noise
%       taskParam: Task-parameter-object instance
%
%   Output:
%       ~

% Todo: change comments so that this is about push vs. noPush

if strcmp(taskParam.trialflow.push, 'noPush')
    header = 'Gleicher Ausgangspunkt der Vorhersage';
    txt = 'Im folgenden Block wird der Ausgangspunkt Ihrer Vorhersage nicht verändert.';

elseif strcmp(taskParam.trialflow.push, 'push')
    header = 'Zufälliger Ausgangspunkt der Vorhersage';
    txt = 'Im folgenden Block wird der Ausgangspunkt Ihrer Vorhersage zufällig links oder rechts von Ihrer vorherigen Position erscheinen.';
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end