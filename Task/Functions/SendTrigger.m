function trigger = SendTrigger(taskParam, taskData, condition, ~, trial, Tevent)
% This function sends the EEG triggers.
% 12.05.15: komische triggererfahrung: wenn man mit brown version triggert
% kann man in while schleife triggern und es wird nur einer gesendet
% bei dresden version (32 bit) wird die ganze zeit in der schleife gesendet
% habe trigger jetzt aus der schleife genommen. woran liegt das?
%   See triggerscheme for details
%keyboard
digit1 = 0;
digit2 = 0;
digit3 = 0;
digit4 = 0;

%if taskParam.gParam.oddball == false
if isequal(taskParam.gParam.taskType, 'dresden')
    
% -------------------------------------------------------------------------    
% Dresden version   
% -------------------------------------------------------------------------
    
    %% "Brown" trigger system
    if taskParam.gParam.sendTrigger == true
        if taskParam.gParam.oddball
            ioObject = io64;
            status = io64(ioObject);
        end
    end
    
    if  isequal(condition, 'main') || isequal(condition, 'followOutcome') || isequal(condition, 'followCannon')
        
        if sum(Tevent == 1:7) == 1
            
            digit3 = Tevent;
            trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3));
            trigger = str2double(trigger);
            
        elseif trial > 1 && Tevent == 16
            
            if isequal(condition, 'followCannon') && taskData.cp(trial) == 1
                digit1 = 10;
                digit2 = 1;
            elseif isequal(condition, 'followCannon') && taskData.cp(trial) == 0
                digit1 = 10;
                digit2 = 0;
            elseif isequal(condition, 'followOutcome') && taskData.cp(trial) == 1
                digit1 = 1;
                digit2 = 1;
            elseif isequal(condition, 'followOutcome') && taskData.cp(trial) == 0
                digit1 = 1;
                digit2 = 0;
            elseif isequal(condition, 'main') && taskData.cp(trial) == 1
                digit1 = 0;
                digit2 = 1;
            elseif isequal(condition, 'main') && taskData.cp(trial) == 0
                digit1 = 0;
                digit2 = 0;
            end
            
            if taskData.hit(trial) == 1
                digit3 = 1;
            elseif taskData.hit(trial) == 0
                digit3 = 0;
            end
            
            
            if taskData.actRew(trial) == 1
                digit4 = 1;
            elseif taskData.actRew(trial) == 2
                digit4 = 0;
            end
            
            
            if taskData.catchTrial(trial) || isequal(condition, 'followCannon');
                digit5 = 1;
            else
                digit5 = 0;
            end
            
        else
            trigger = 255;
        end
        
        
        if Tevent == 16 && trial > 1
            
            
            trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5));
            %trigger = str2double(trigger);
            trigger = base2dec(trigger, 2) + 100;
        end
    else
        trigger = 255;
        
        
    end
    
    
    if taskParam.gParam.sendTrigger == true
        
        if taskParam.gParam.oddball
            io64(ioObject,taskParam.triggers.port,trigger) % This is for brown.
        else
            outp(taskParam.triggers.port, trigger); %This is the Dresden version
            WaitSecs(1/taskParam.triggers.sampleRate);
            outp(taskParam.triggers.port,0) % Set port to 0.
        end
        
    end
    
% -------------------------------------------------------------------------    
% Oddball version   
% -------------------------------------------------------------------------   

elseif isequal(taskParam.gParam.taskType, 'oddball')
    if taskParam.gParam.sendTrigger == true
        %ioObject = io64;
        %status = io64(ioObject);
    end
    
    if  (isequal(condition, 'main') || isequal(condition, 'oddball')) %taskParam.gParam.sendTrigger == true &&
        
        if sum(Tevent == 1:7) == 1
            
            digit3 = Tevent;
            trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3));
            trigger = str2double(trigger);
            
        elseif trial > 1 && Tevent == 16
            
            if isequal(condition, 'oddball') && taskData.oddBall(trial) == 1
                digit1 = 1;
                digit2 = 1;
            elseif isequal(condition, 'oddball') && taskData.oddBall(trial) == 0
                digit1 = 1;
                digit2 = 0;
            elseif isequal(condition, 'main') && taskData.cp(trial) == 1
                digit1 = 0;
                digit2 = 1;
            elseif isequal(condition, 'main') && taskData.cp(trial) == 0
                digit1 = 0;
                digit2 = 0;
            end
            
            if taskData.hit(trial) == 1
                digit3 = 1;
            elseif taskData.hit(trial) == 0
                digit3 = 0;
            end
            
            %keyboard
            if taskData.actRew(trial) == 1
                digit4 = 1;
            elseif taskData.actRew(trial) == 2
                digit4 = 0;
            end
            
        else
            trigger = 255;
        end
        
        
        if Tevent == 16 && trial > 1
            
            
            trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4));
            %trigger = str2double(trigger);
            trigger = base2dec(trigger, 2) + 100;
        end
    else
        trigger = 255;
        
        
    end
    
elseif isequal(taskParam.gParam.taskType, 'reversal')
    
    
    
    if taskParam.gParam.sendTrigger == true
        %ioObject = io64;
        %status = io64(ioObject);
    end
    
   % if  (isequal(condition, 'main') || isequal(condition, 'oddball')) %taskParam.gParam.sendTrigger == true &&
        
        if sum(Tevent == 1:7) == 1
            
            digit3 = Tevent;
            trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3));
            trigger = str2double(trigger);
            
        elseif trial > 1 && Tevent == 16
            
            %if isequal(condition, 'oddball') && taskData.oddBall(trial) == 1
             %   digit1 = 1;
              %  digit2 = 1;
            %elseif isequal(condition, 'oddball') && taskData.oddBall(trial) == 0
               % digit1 = 1;
            %    digit2 = 0;
            if taskData.cp(trial) == 0
                digit1 = 0;
                digit2 = 0;
            elseif taskData.cp(trial) == 1 && taskData.reversal(trial) == 0
                digit1 = 1;
                digit2 = 0;
            elseif taskData.cp(trial) == 1 && taskData.reversal(trial) == 1
                digit1 = 1;
                digit2 = 1;
            end
            
            if taskData.hit(trial) == 1
                digit3 = 1;
            elseif taskData.hit(trial) == 0
                digit3 = 0;
            end
            
            %keyboard
            if taskData.actRew(trial) == 1
                digit4 = 1;
            elseif taskData.actRew(trial) == 2
                digit4 = 0;
            end
            
        else
            trigger = 255;
        end
        
        
        if Tevent == 16 && trial > 1
            
            
            trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4));
            %trigger = str2double(trigger);
            trigger = base2dec(trigger, 2) + 100;
        end
    %else
       % trigger = 255;
        
        
    %end
    
elseif isequal(taskParam.gParam.taskType, 'chinese') ||...
    isequal(taskParam.gParam.taskType, 'ARC')
    
    trigger = 255;
    
end

if taskParam.gParam.sendTrigger == true
    %     outp(taskParam.triggers.port, trigger); This is the Dresden version
    %     WaitSecs(1/taskParam.triggers.sampleRate);
    %     outp(taskParam.triggers.port,0) % Set port to 0.
    
    %io64(ioObject,taskParam.triggers.port,trigger) % This is for brown.
end
end
