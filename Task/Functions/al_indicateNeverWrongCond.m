function al_indicateNeverWrongCond(taskParam)
% AL_INDICATENEVERWRONGCOND This function indicates the condition of the
% "neverWrong" task
%
%   Input:
%       taskParam: Task-parameter-object instance
%
%   Output:
%       None

if isequal(taskParam.trialflow.exp, "neverWrong1")
    header = 'Prediction Game!';
    txt = ['In this block of trials, your task is to predict the NEXT '...
        'confetti shot.\n\nAfter indicating your prediction and observing the confetti shot, you are required to rate the likelihood of the last confetti shot.' ];
elseif isequal(taskParam.trialflow.exp, "neverWrong2")
    header = 'Prediction Game!';
    txt = ['In this block of trials, your task is to predict the NEXT '...
        'confetti shot.\n\nAfter indicating your prediction and observing the confetti shot, you are required to rate the likelihood of the last confetti shot.' ];
elseif isequal(taskParam.trialflow.exp, "neverWrong3")
    header = 'Memory Game!';
    txt = ['In this block of trials, your task is to go back to the LAST '...
        'confetti shot.\n\nAfter indicating your choice and observing the confetti shot, you are required to rate the likelihood of the last confetti shot.' ];
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end