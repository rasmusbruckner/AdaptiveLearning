function al_indicateNoise(taskParam, noiseCondition, variableShield)
% AL_INDICATENOISE This function indicates the noise
% condition
%
%   Input:
%       taskParam: Task-parameter-object instance
%       noiseCondition: High vs. low noise
%       variableShield: Indicates if shield is fixed or variable (optional)
%
%   Output:
%       None

% Check for variable shield input
if ~exist('variableShield', 'var') || isempty(variableShield)
    variableShield = false; 
end

if strcmp(noiseCondition, 'lowNoise') && ~variableShield
    header = 'Genauere Konfetti-Kanone';
    txt = ['Im folgenden Block wird die Konfetti-Kanone relativ genau sein.\n\n'...
        'Weil Sie das Konfetti hier relativ gut vorhersagen können, '...
        'wird der Eimer, mit dem Sie das Konfetti fangen sollen, relativ klein sein.'];

elseif strcmp(noiseCondition, 'highNoise') && ~variableShield
    header = 'Ungenauere Konfetti-Kanone';
    txt = ['Im folgenden Block wird die Konfetti-Kanone relativ ungenau sein.\n\n'...
        'Weil Sie das Konfetti hier schwieriger vorhersagen können, '...
        'wird der Eimer, mit dem Sie das Konfetti fangen sollen, relativ groß sein.'];

elseif strcmp(noiseCondition, 'lowNoise') && variableShield
    header = 'Genauere Konfetti-Kanone';
    txt = ['Im folgenden Block wird die Konfetti-Kanone relativ genau sein.\n\n'...
           'Die Größe des Eimers kann sich von Durchgang '...
           'zu Durchgang ändern. Diese Veränderung können Sie nicht beeinflussen '...
           'und auch nicht vorhersagen. Daher ist es immer die beste Strategie, '...
           'den Eimer genau dorthin zu stellen, wo Sie das Ziel der Konfetti-Kanone vermuten.'];

elseif strcmp(noiseCondition, 'highNoise') && variableShield
    header = 'Ungenauere Konfetti-Kanone';
    txt = ['Im folgenden Block wird die Konfetti-Kanone relativ ungenau sein.\n\n'...
           'Die Größe des Eimers kann sich von Durchgang '...
           'zu Durchgang ändern. Diese Veränderung können Sie nicht beeinflussen '...
           'und auch nicht vorhersagen. Daher ist es immer die beste Strategie, '...
           'den Eimer genau dorthin zu stellen, wo Sie das Ziel der Konfetti-Kanone vermuten.'];
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end