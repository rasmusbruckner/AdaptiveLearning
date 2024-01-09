function al_indicateSocial(taskParam)
% AL_INDICATESOCIAL This function indicates the feedback
% condition in the social-reward version
%
%   Input:
%       taskParam: Task-parameter-object instance
%
%   Output:
%       ~

if strcmp(taskParam.trialflow.reward, 'monetaryReward')
    header = 'Jetzt kannst Du Geld gewinnen!';
    txt = 'Im folgenden Block wirst Du für Deine Leistung Geld gewinnen!';
elseif strcmp(taskParam.trialflow.reward, 'monetaryPunishment')
    header = 'Jetzt kannst Du Geld verlieren!';
    txt = 'Im folgenden Block wirst Du für Deine Fehler Geld verlieren!';
elseif strcmp(taskParam.trialflow.reward, 'socialReward')
    header = 'Deine Freund:innen loben Dich!';
    txt = 'Im folgenden Block wirst Du von Deinen Freund:innen für Deine guten Leistungen beurteilt!';
elseif strcmp(taskParam.trialflow.reward, 'socialPunishment')
    header = 'Deine Freund:innen sehen Deine Fehler!';
    txt = 'Im folgenden Block wirst Du von Deinen Freund:innen für Deine Fehler beurteilt!';
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end