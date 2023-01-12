function al_indicateReward(taskParam)
% AL_INDICATEREWARD This function indicates the reward
% condition in the asymmetric-reward version
%
%   Input:
%       taskParam: Task-parameter-object instance
%
%   Output:
%       ~

if strcmp(taskParam.trialflow.reward, 'standard')
    header = 'Gleich viel Konfetti';
    txt = 'Im folgenden Block wird die Konfetti-Kanone immer die gleiche Menge an Konfetti verschießen.';

elseif strcmp(taskParam.trialflow.reward, 'asymmetric')
    header = 'Unterschiedlich viel Konfetti';
    txt = 'Im folgenden Block wird die Konfetti-Kanone unterschiedliche Mengen an Konfetti verschießen.';

end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end