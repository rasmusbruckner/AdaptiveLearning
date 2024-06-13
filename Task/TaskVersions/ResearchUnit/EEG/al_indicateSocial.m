function al_indicateSocial(taskParam)
% AL_INDICATESOCIAL This function indicates the feedback
% condition in the social-reward version
%
%   Input:
%       taskParam: Task-parameter-object instance
%
%   Output:
%       None

if strcmp(taskParam.trialflow.reward, 'monetary')
    header = 'Jetzt kannst Du Geld gewinnen!';
    txt = 'Im folgenden Block wirst Du für Deine Leistung Geld gewinnen und verlieren.';
elseif strcmp(taskParam.trialflow.reward, 'social')
    header = 'Deine Freund:innen loben Dich und sehen Deine Fehler!';
    txt = 'Im folgenden Block wirst Du von Deinen Freund:innen für Deine guten und schlechten Leistungen beurteilt.';
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback, true);

end