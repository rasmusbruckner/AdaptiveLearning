function al_indicateSocial(taskParam)
% AL_INDICATESOCIAL This function indicates the feedback
% condition in the social-reward version
%
%   Input:
%       taskParam: Task-parameter-object instance
%
%   Output:
%       ~

if strcmp(taskParam.trialflow.reward, 'monetary')
    header = 'Jetzt kannst Du Geld gewinnen!';
    txt = 'Im folgenden Block wirst Du für Deine Leistung Geld gewinnen!';
elseif strcmp(taskParam.trialflow.reward, 'social')
    header = 'Deine Freund:innen haben Dich im Blick!';
    txt = 'Im folgenden Block wirst Du von Deinen Freund:innen für Deine Leistung beurteilt!';
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end