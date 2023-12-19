function al_indicateCannonType(taskParam)
% AL_INDICATECANNONTYPE This function indicates the cannon
% condition in the asymmetric-reward version
%
%   Input:
%       taskParam: Task-parameter-object instance
%
%   Output:
%       ~


if strcmp(taskParam.trialflow.distMean, 'drift')
    header = 'Langsame Kanone';
    txt = 'Im folgenden Block wird sich die Konfetti-Kanone langsam bewegen.';
else
    header = 'Wilde Kanone';
    txt = 'Im folgenden Block wird sich die Konfetti-Kanone ab und zu neu ausrichten.';
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end