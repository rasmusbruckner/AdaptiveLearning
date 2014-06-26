function trigger = SendTrigger(taskParam, taskData, Subject, condition, vola, trial, Tevent)
% This function sends the EEG triggers.
%
%   1. condition (1: practice, 2: main, 3: control)  vola (1: low, 2: high)
%   3. cp (0: no CP, 1: CP)
%   4. which boat is rewarded? (1: gold, 2: silver)
%   5. boat on trial N-1 (1: gold, 2: silver)
%   6. event: (1: prediction, 2: outcome, 3: boat)
%
% Example: 210211 - main, low vola, no CP, silver rewarded,
% in last trial gold boat was shown, event: prediction.

digit1 = zeros(taskParam.gParam.trials,1);
digit2 = zeros(taskParam.gParam.trials,1);
digit3 = zeros(taskParam.gParam.trials,1);

if taskParam.gParam.sendTrigger == true
    
    %first digit
    if isequal(condition, 'main') 
        digit1 = 1;
    elseif isequal(condition, 'control')   
        digit1 = 2;
    end
    
    % second digit
    if vola == .2 && taskData.cp(trial) == 1
        digit2 = 3;
    elseif vola == .2 && taskData.cp(trial) == 0    
        digit2 = 0;
    elseif vola == .7 && taskData.cp(trial) == 1
        digit2 = 4;
    elseif vola == .7 && taskData.cp(trial) == 0
        digit2 = 1;
    end
    
    % Third digit.
    if trial > 1
        if Tevent == 1 && taskData.actRew(trial-1) == 1
            digit3 = 2;
        elseif Tevent == 1 && taskData.actRew(trial-1) == 2
            digit3 = 3;
        elseif Tevent == 2 && taskData.actRew(trial-1) == 1
            digit3 = 4;
        elseif Tevent == 2 && taskData.actRew(trial-1) == 2
            digit3 = 5; 
        elseif Tevent == 3 && taskData.actRew(trial) == 1
            digit3 = 6;
        elseif Tevent == 3 && taskData.actRew(trial) == 2
            digit3 = 7;
        end
    else
        if Tevent == 3 && taskData.actRew(trial) == 1
            digit3 = 6;
        elseif Tevent == 3 && taskData.actRew(trial) == 2
            digit3 = 7;
        end
    end
    
%     if isequal(condition, 'practice') && vola == .2
%         Tcond = 1;
%     elseif isequal(condition, 'practice') && vola == .7
%         Tcond = 2;
%     elseif isequal(condition, 'main') && vola == .2
%         Tcond = 3;
%     elseif isequal(condition, 'main') && vola == .7
%         Tcond = 4;
%     elseif isequal(condition, 'control') && vola == .2
%         Tcond = 5;
%     elseif isequal(condition, 'control') && vola == .7
%         Tcond = 6;
%     end
%     
    
    %     %vola
    %     if vola == .2 % abstrahieren
    %         Tvola = 1;
    %     elseif vola == .7
    %         Tvola = 2;
    %     end
    
    %cp: dieser trial
%     if taskData.cp(trial)== 1
%         Tcp = 1;
%     elseif taskData.cp(trial)== 0
%         Tcp = 0;
%     end
    
    
%     % reward.
%     if trial == 1
%         if isequal(Subject.rew, '1')
%             Tboat = 8;
%         elseif isequal(Subject.rew, '2')
%             Tboat = 9;
%         end
%     end
%     if trial > 1
%         if isequal(Subject.rew, '1') && taskData.boatType(trial -1) == 1
%             Trew = 1;
%         elseif isequal(Subject.rew, '1') && taskData.boatType(trial -1) == 2
%             Trew = 2;
%         elseif isequal(Subject.rew, '2') && taskData.boatType(trial -1) == 1
%             Trew = 3;
%         elseif isequal(Subject.rew, '2') && taskData.boatType(trial -1) == 2
%             Trew = 4;
%         end
%     end
% end



%boat: wichtig welche ladung letztes boot hatte!
% if trial > 1
%
%     if taskData.boatType(trial -1) == 1
%         Tboat = 1;
%     elseif taskData.boatType(trial -1) == 2
%         Tboat = 2;
%     end
% end
% elseif trial == 1
%     Tboat = 9;
% end


trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3));
trigger = str2double(trigger);


else
    trigger = 0000;
end

if taskParam.gParam.sendTrigger == true
    outp(taskParam.triggers.port, trigger);
    WaitSecs(1/taskParam.triggers.sampleRate);
    outp(taskParam.triggers.port,0) % Set port to 0.
end
end
