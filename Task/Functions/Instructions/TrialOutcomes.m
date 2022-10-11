function screenIndex = TrialOutcomes(taskParam, subject, screenIndex)
%TRIALOUTCOMES   This function introduces the possible outcomes in the task
%
%   Input
%       screenIndex: indicates current screen of instruction phase
%
%   Output
%       screenIndex: updated screenIndex


if isequal(taskParam.gParam.taskType, 'dresden')
    header = 'Gewinnmöglichkeiten';
    if isequal(taskParam.subject.group, '1')
        
        txt = 'Um dir genau zu zeigen, wann du Geld verdienst, spielen wir jetzt alle Möglichkeiten durch.';
    else
        txt = 'Um Ihnen genau zu zeigen, wann Sie Geld verdienen, spielen wir jetzt alle Möglichkeiten durch.';
    end
elseif isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType, 'reversal') || isequal(taskParam.gParam.taskType, 'ARC')

    if subject.rew == 1
        colRew = 'blue';
        colNoRew = 'green';
    elseif subject.rew == 2
        colRew = 'green';
        colNoRew = 'blue';
    end
    header = 'Trial Outcomes';
    txt = sprintf('Now lets see what happens when you hit or miss the ball with a %s or %s shield...', colRew, colNoRew);
end
feedback = false;
fw = al_bigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
if fw == 1
    screenIndex = screenIndex + 1;
elseif bw == 1
    screenIndex = screenIndex - 2;
end
WaitSecs(0.1)
end