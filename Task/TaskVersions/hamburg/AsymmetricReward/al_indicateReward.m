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
    header = 'Buntes Konfetti';
    txt = 'Im folgenden Block wird die Konfetti-Kanone buntes Konfetti verschießen.';
elseif strcmp(taskParam.trialflow.reward, 'asymmetric')
    header = 'Rot-Grünes Konfetti';
    txt = 'Im folgenden Block wird die Konfetti-Kanone rot-grünes Konfetti verschießen.';
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end