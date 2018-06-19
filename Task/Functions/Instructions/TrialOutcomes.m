function [screenIndex] = TrialOutcomes(screenIndex)
    if isequal(taskParam.gParam.taskType, 'dresden')
        header = 'Gewinnmöglichkeiten';
        if isequal(subject.group, '1')

            txt = ['Um dir genau zu zeigen, wann du Geld '...
                'verdienst, spielen wir jetzt alle Möglichkeiten '...
                'durch.'];
        else
            txt = ['Um Ihnen genau zu zeigen, wann Sie Geld '...
                'verdienen, spielen wir jetzt alle Möglichkeiten '...
                'durch.'];
        end
    elseif isequal(taskParam.gParam.taskType, 'oddball')...
            || isequal(taskParam.gParam.taskType, 'reversal')...
            || isequal(taskParam.gParam.taskType, 'ARC')
        header = 'Trial Outcomes';
        txt = sprintf(['Now lets see what happens when you hit '...
            'or miss the ball with a %s or %s shield...'],...
            colRew, colNoRew);
    end
    feedback = false;
    fw = al_bigScreen(taskParam,...
        taskParam.strings.txtPressEnter, header, txt, feedback);
    if fw == 1
        screenIndex = screenIndex + 1;
    elseif bw == 1
        screenIndex = screenIndex - 2;
    end
    WaitSecs(0.1);
end