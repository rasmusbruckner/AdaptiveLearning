function al_indicateTickMark(taskParam)
% AL_INDICATETICKMARK This function indicates the tick-mark
% condition in the asymmetric-reward version
%
%   Input:
%       taskParam: Task-parameter-object instance
%
%   Output:
%       ~

if strcmp(taskParam.trialflow.currentTickmarks, 'standard')
    header = 'Weniger Hinweise über die Konfetti-Kanone';
    txt = 'Im folgenden Block werden Sie nur den Ort der letzten Konfetti-Wolke sehen.';
else
    header = 'Mehr Hinweise über die Konfetti-Kanone';
    txt = 'Im folgenden Block werden Sie den Ort der letzten 5 Konfetti-Wolken sehen.';
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end