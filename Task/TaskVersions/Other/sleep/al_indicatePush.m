function al_indicatePush(taskParam)
% AL_INDICATEPUSH This function indicates the push
% condition
%
%   Input:
%       taskParam: Task-parameter-object instance
%
%   Output:
%       ~

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