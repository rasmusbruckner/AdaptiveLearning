function al_indicateHelicopterNoise(taskParam, noiseCondition)
% AL_INDICATENOISE This function indicates the noise
% condition in the Leipzig helicopter version
%
%   Input:
%       taskParam: Task-parameter-object instance
%       noiseCondition: High vs. low noise
%
%   Output:
%       ~


if strcmp(noiseCondition, 'lowNoise')
    header = 'Weniger Windige Umgebung';
    txt = ['Im folgenden Block wird der Wind relativ schwach sein.\n\n'...
        'Weil Sie den Abwurfort der Medikamente hier relativ gut vorhersagen können, '...
        'wird der Eimer, mit dem Sie die Medikamente fangen sollen, relativ klein sein.'];

elseif strcmp(noiseCondition, 'highNoise')
    header = 'Sehr Windige Umgebung';
    txt = ['Im folgenden Block wird der Wind relativ stark sein.\n\n'...
        'Weil Sie den Abwurfort der Medikamente hier schwieriger vorhersagen können, '...
        'wird der Eimer, mit dem Sie die Medikamente fangen sollen, relativ groß sein.'];
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end