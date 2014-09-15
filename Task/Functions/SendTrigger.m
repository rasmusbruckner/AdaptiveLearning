function trigger = SendTrigger(taskParam, taskData, condition, vola, trial, Tevent)
% This function sends the EEG triggers.
%
%   See triggerscheme for details

% preallocats everytime NOT GOOD!!!!!!!!!!!!!!!! in script!
digit1 = 0;
digit2 = 0;
digit3 = 0;


if taskParam.gParam.oddball == false
    
    if taskParam.gParam.sendTrigger == true && (isequal(condition, 'main') || isequal(condition, 'control'))
        
        %first digit
        if trial > 1
            if isequal(condition, 'main')
                digit1 = 1;
            elseif isequal(condition, 'control')
                digit1 = 2;
            end
        end
        
        % second digit
        if trial == 1 % only vola
            if isequal(condition, 'main') && vola == .3 % Low vola = 0
                digit2 = 5;
            elseif isequal(condition, 'main') && vola == .7 % High vola = 3
                digit2 = 6;
            elseif isequal(condition, 'control') && vola == .3 % High vola = 3
                digit2 = 7;
            elseif isequal(condition, 'control') && vola == .7 % High vola = 3
                digit2 = 8;
            end
        else % vola + cp
            if vola == .3 && taskData.cp(trial) == 1 % Low vola + cp = 0
                digit2 = 0;
            elseif vola == .2 && taskData.cp(trial) == 0 % Low vola + no cp = 1
                digit2 = 1;
            elseif vola == .7 && taskData.cp(trial) == 1 % High vola + cp = 3
                digit2 = 3;
            elseif vola == .7 && taskData.cp(trial) == 0 % High vola + no cp = 4
                digit2 = 4;
            end
        end
        
        % Third digit.
        if trial == 1 % (actRew +) event (+ hit)
            if Tevent == 1
                digit3 = 1;
            elseif Tevent == 2 && taskData.hit(trial) == 1
                digit3 = 2;
            elseif Tevent == 2 && taskData.hit(trial) == 0
                digit3 = 3;
            elseif taskData.actRew(trial) == 1 && Tevent == 3 && taskData.hit(trial) == 1
                digit3 = 4;
            elseif taskData.actRew(trial) == 1 && Tevent == 3 && taskData.hit(trial) == 0
                digit3 = 5;
            elseif taskData.actRew(trial) == 2 && Tevent == 3 && taskData.hit(trial) == 1
                digit3 = 6;
            elseif taskData.actRew(trial) == 2 && Tevent == 3 && taskData.hit(trial) == 0
                digit3 = 7;
            end
        else % actRew + event (+ hit)
            
            % For all predictions: last actRew (1/2)
            if taskData.actRew(trial-1) == 1 && Tevent == 1
                digit3 = 0;
            elseif taskData.actRew(trial-1) == 2 && Tevent == 1
                digit3 = 1;
                
                % For all prediction errors: last actRew (1/2) and hit(1/0)
            elseif taskData.actRew(trial-1) == 1 && Tevent == 2 && taskData.hit(trial) == 1
                digit3 = 2;
            elseif taskData.actRew(trial-1) == 1 && Tevent == 2 && taskData.hit(trial) == 0
                digit3 = 3;
            elseif taskData.actRew(trial-1) == 2 && Tevent == 2 && taskData.hit(trial) == 1
                digit3 = 4;
            elseif taskData.actRew(trial-1) == 2 && Tevent == 2 && taskData.hit(trial) == 0
                digit3 = 5;
                
                % For all boats: current actRew (1/2) and hit (0/1)
            elseif taskData.actRew(trial) == 1 && Tevent == 3 && taskData.hit(trial) == 1
                digit3 = 6;
            elseif taskData.actRew(trial) == 1 && Tevent == 3 && taskData.hit(trial) == 0
                digit3 = 7;
            elseif taskData.actRew(trial) == 2 && Tevent == 3 && taskData.hit(trial) == 1
                digit3 = 8;
            elseif taskData.actRew(trial) == 2 && Tevent == 3 && taskData.hit(trial) == 0
                digit3 = 9;
            end
        end
        
        trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3));
        trigger = str2double(trigger);
        
    else
        trigger = 0000;
    end
    
elseif taskParam.gParam.oddball == true
     ioObject = io64;
     status = io64(ioObject);
     
    if taskParam.gParam.sendTrigger == true && trial > 1 && (isequal(condition, 'main') || isequal(condition, 'oddball')) 
        
       
        
        %first digit
        if isequal(condition, 'oddball')
            digit1 = 1;
        elseif isequal(condition, 'main')
            digit1 = 2;
        end
        
        
        % second digit
        if isequal(condition, 'main') && taskData.cp(trial) == 1
             digit2 = 1;
        elseif isequal(condition, 'oddball') && taskData.oddBall(trial) == 1
            digit2 = 1;
        elseif isequal(condition, 'main') && taskData.cp(trial) == 0
            digit2 = 0;
        elseif isequal(condition, 'oddball') && taskData.oddBall(trial) == 0
            digit2 = 0;
        end
        
        
        % Third digit.
        
        
        
        % For all predictions: last actRew (1/2)
      
        if taskData.actRew(trial-1) == 1 && Tevent == 1
            digit3 = 0;
        elseif taskData.actRew(trial-1) == 2 && Tevent == 1
            digit3 = 1;
            
            % For all prediction errors: last actRew (1/2) and hit(1/0)
        elseif taskData.actRew(trial-1) == 1 && Tevent == 2 && taskData.hit(trial) == 1
            digit3 = 2;
        elseif taskData.actRew(trial-1) == 1 && Tevent == 2 && taskData.hit(trial) == 0
            digit3 = 3;
        elseif taskData.actRew(trial-1) == 2 && Tevent == 2 && taskData.hit(trial) == 1
            digit3 = 4;
        elseif taskData.actRew(trial-1) == 2 && Tevent == 2 && taskData.hit(trial) == 0
            digit3 = 5;
            
            % For all boats: current actRew (1/2) and hit (0/1)
        elseif taskData.actRew(trial) == 1 && Tevent == 3 && taskData.hit(trial) == 1
            digit3 = 6;
        elseif taskData.actRew(trial) == 1 && Tevent == 3 && taskData.hit(trial) == 0
            digit3 = 7;
        elseif taskData.actRew(trial) == 2 && Tevent == 3 && taskData.hit(trial) == 1
            digit3 = 8;
        elseif taskData.actRew(trial) == 2 && Tevent == 3 && taskData.hit(trial) == 0
            digit3 = 9;
        end
        
        trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3));
        trigger = str2double(trigger);
        
        else
        trigger = 0000;
   
        
    end
    
end

if taskParam.gParam.sendTrigger == true
    %     outp(taskParam.triggers.port, trigger); This is the Dresden version
    %     WaitSecs(1/taskParam.triggers.sampleRate);
    %     outp(taskParam.triggers.port,0) % Set port to 0.
    
    io64(ioObject,taskParam.triggers.port,trigger) % This is for brown.
end
end
