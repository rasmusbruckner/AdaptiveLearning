function al_indicateCannonType(taskParam)
% AL_INDICATECANNONTYPE This function indicates the cannon
% condition in the VWM version
%
%   Input
%       taskParam: Task-parameter-object instance
%
%   Output
%       None


if strcmp(taskParam.trialflow.distMean, 'drift') && strcmp(taskParam.trialflow.currentTickmarks, 'show')
    header = 'Langsame Kanone';
    txt = 'Im folgenden Block wird sich die Konfetti-Kanone langsam bewegen.'; 
elseif strcmp(taskParam.trialflow.distMean, 'drift') && strcmp(taskParam.trialflow.currentTickmarks, 'workingMemory')
    header = 'Langsame Kanone und mehr Hinweise';
    txt = ['Im folgenden Block wird sich die Konfetti-Kanone langsam bewegen.\n\n'...
        'Außerdem werden Sie den Ort der letzten 5 Konfetti-Wolken sehen.']; 
elseif strcmp(taskParam.trialflow.distMean, 'fixed') && strcmp(taskParam.trialflow.currentTickmarks, 'show')
    header = 'Wilde Kanone';
    txt = 'Im folgenden Block wird sich die Konfetti-Kanone ab und zu neu ausrichten.';
elseif strcmp(taskParam.trialflow.distMean, 'fixed') && strcmp(taskParam.trialflow.currentTickmarks, 'workingMemory')
    header = 'Wilde Kanone und mehr Hinweise';
    txt = ['Im folgenden Block wird sich die Konfetti-Kanone ab und zu neu ausrichten.\n\n'...
        'Außerdem werden Sie den Ort der letzten 5 Konfetti-Wolken sehen.'];
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end