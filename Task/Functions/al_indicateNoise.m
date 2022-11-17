function al_indicateNoise(taskParam, noiseCondition)
% AL_INDICATENOISE This function indicates the noise
% condition
%
%   Input:
%       taskParam: Task-parameter-object instance
%       noiseCondition: High vs. low noise
%
%
%   Output:
%       ~

if strcmp(noiseCondition, 'lowNoise')
    header = 'Genauere Konfetti-Kanone';
    txt = ['Im folgenden Block wird die Konfetti-Kanone relativ genau sein.\n\n'...
           'Weil Sie das Konfetti hier relativ gut vorhersagen können, '... 
           'wird der Eimer, mit dem Sie das Konfetti fangen sollen, relativ klein sein.'];

elseif strcmp(noiseCondition, 'highNoise')
    header = 'Ungenauere Konfetti-Kanone';
txt = ['Im folgenden Block wird die Konfetti-Kanone relativ ungenau sein.\n\n'...
           'Weil Sie das Konfetti hier schwieriger vorhersagen können, '... 
           'wird der Eimer, mit dem Sie das Konfetti fangen sollen, relativ groß sein.'];
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end