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

% todo: more pupil instruction to avoid blinks

% Check for variable shield input
if ~exist('variableShield', 'var') || isempty(variableShield)
    variableShield = false;
end

if strcmp(noiseCondition, 'lowNoise') && ~variableShield

    if isequal(taskParam.gParam.language, 'German')
        header = 'Genauere Konfetti-Kanone';
        txt = ['Im folgenden Block wird die Konfetti-Kanone relativ genau sein.\n\n'...
            'Weil Sie das Konfetti hier relativ gut vorhersagen können, '...
            'wird der Eimer, mit dem Sie das Konfetti fangen sollen, relativ klein sein.\n\n'...
            'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. Der schwarze '...
            'Strich zeigt die Position der letzten Konfetti-Wolke.'];
    elseif isequal(taskParam.gParam.language, 'English')
        header = 'More accurate confetti cannon';
        txt = ['In the following block, the confetti cannon will be relatively accurate.\n\n'...
            'Because you can predict the confetti relatively well here, '...
            'the bucket with which you should catch the confetti will be relatively small.'];
    else
        error('language parameter unknown')
    end

elseif strcmp(noiseCondition, 'highNoise') && ~variableShield

    if isequal(taskParam.gParam.language, 'German')
        header = 'Ungenauere Konfetti-Kanone';
        txt = ['Im folgenden Block wird die Konfetti-Kanone relativ ungenau sein.\n\n'...
            'Weil Sie das Konfetti hier schwieriger vorhersagen können, '...
            'wird der Eimer, mit dem Sie das Konfetti fangen sollen, relativ groß sein.\n\n'...
            'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. Der schwarze '...
            'Strich zeigt die Position der letzten Konfetti-Wolke.'];
    elseif isequal(taskParam.gParam.language, 'English')
        header = 'Less accurate confetti cannon';
        txt = ['In the following block, the confetti cannon will be relatively inaccurate.\n\n'...
            'Because it is more difficult to predict the confetti here, '...
            'the bucket with which you should catch the confetti will be relatively large.'];
    else
        error('language parameter unknown')
    end

elseif strcmp(noiseCondition, 'lowNoise') && variableShield

    if taskParam.gParam.customInstructions
        header = taskParam.instructionText.introduceLowNoiseHeader;
        txt = taskParam.instructionText.introduceLowNoise;
    else
        if isequal(taskParam.gParam.language, 'German')
            header = 'Genauere Konfetti-Kanone';
            txt = ['Im folgenden Block wird die Konfetti-Kanone relativ genau sein.\n\n'...
                'Die Größe des Eimers kann sich von Durchgang '...
                'zu Durchgang ändern. Diese Veränderung können Sie nicht beeinflussen '...
                'und auch nicht vorhersagen. Daher ist es immer die beste Strategie, '...
                'den Eimer genau dorthin zu stellen, wo Sie das Ziel der Konfetti-Kanone vermuten.\n\n'...
                'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. Der schwarze '...
                'Strich zeigt die Position der letzten Konfetti-Wolke.'];
        elseif isequal(taskParam.gParam.language, 'English')
            header = 'More accurate confetti cannon';
            txt = ['In the following block, the confetti cannon will be relatively accurate.\n\n'...
                'The size of the bucket can change from trial '...
                'to trial. You cannot influence this change '...
                'nor can you predict it. Therefore, the best strategy is always to '...
                'place the bucket exactly where you think the confetti cannon will be aimed.'];
        else
            error('language parameter unknown')
        end
    end

elseif strcmp(noiseCondition, 'highNoise') && variableShield

    if taskParam.gParam.customInstructions
        header = taskParam.instructionText.introduceHighNoiseHeader;
        txt = taskParam.instructionText.introduceHighNoise;
    else
        if isequal(taskParam.gParam.language, 'German')
            header = 'Ungenauere Konfetti-Kanone';
            txt = ['Im folgenden Block wird die Konfetti-Kanone relativ ungenau sein.\n\n'...
                'Die Größe des Eimers kann sich von Durchgang '...
                'zu Durchgang ändern. Diese Veränderung können Sie nicht beeinflussen '...
                'und auch nicht vorhersagen. Daher ist es immer die beste Strategie, '...
                'den Eimer genau dorthin zu stellen, wo Sie das Ziel der Konfetti-Kanone vermuten.\n\n'...
                'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. Der schwarze '...
                'Strich zeigt die Position der letzten Konfetti-Wolke.'];
        elseif isequal(taskParam.gParam.language, 'English')
            header = 'Less accurate confetti cannon';
            txt = ['In the following block, the confetti cannon will be relatively inaccurate.\n\n'...
                'The size of the bucket can change from trial '...
                'to trial. You cannot influence this change '...
                'nor can you predict it. Therefore, the best strategy is always to '...
                'place the bucket exactly where you think the confetti cannon will be aimed.'];
        else
            error('language parameter unknown')
        end
    end

end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end