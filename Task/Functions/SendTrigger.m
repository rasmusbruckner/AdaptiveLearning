function trigger = SendTrigger(taskParam, taskData, condition, vola, trial, Tevent)
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

if taskParam.gParam.oddball == false
   
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


%% old trigger system
%     if  (isequal(condition, 'main') || isequal(condition, 'control'))% taskParam.gParam.sendTrigger == true &&
%
%         %first digit
%         if trial > 1
%             if isequal(condition, 'main')
%                 digit1 = 1;
%             elseif isequal(condition, 'control')
%                 digit1 = 2;
%             end
%         end
%
%         % second digit
%         if trial == 1 % only vola
%             if isequal(condition, 'main') && vola == .3 % Low vola = 0
%                 digit2 = 5;
%             elseif isequal(condition, 'main') && vola == .7 % High vola = 3
%                 digit2 = 6;
%             elseif isequal(condition, 'control') && vola == .3 % High vola = 3
%                 digit2 = 7;
%             elseif isequal(condition, 'control') && vola == .7 % High vola = 3
%                 digit2 = 8;
%             end
%         else % vola + cp
%             if vola == .3 && taskData.cp(trial) == 1 % Low vola + cp = 0
%                 digit2 = 0;
%             elseif vola == .2 && taskData.cp(trial) == 0 % Low vola + no cp = 1
%                 digit2 = 1;
%             elseif vola == .7 && taskData.cp(trial) == 1 % High vola + cp = 3
%                 digit2 = 3;
%             elseif vola == .7 && taskData.cp(trial) == 0 % High vola + no cp = 4
%                 digit2 = 4;
%             end
%         end
%
%         % Third digit.
%         if trial == 1 % (actRew +) event (+ hit)
%             if Tevent == 1
%                 digit3 = 1;
%             elseif Tevent == 2 && taskData.hit(trial) == 1
%                 digit3 = 2;
%             elseif Tevent == 2 && taskData.hit(trial) == 0
%                 digit3 = 3;
%             elseif taskData.actRew(trial) == 1 && Tevent == 3 && taskData.hit(trial) == 1
%                 digit3 = 4;
%             elseif taskData.actRew(trial) == 1 && Tevent == 3 && taskData.hit(trial) == 0
%                 digit3 = 5;
%             elseif taskData.actRew(trial) == 2 && Tevent == 3 && taskData.hit(trial) == 1
%                 digit3 = 6;
%             elseif taskData.actRew(trial) == 2 && Tevent == 3 && taskData.hit(trial) == 0
%                 digit3 = 7;
%             end
%         else % actRew + event (+ hit)
%
%             % For all predictions: last actRew (1/2)
%             if taskData.actRew(trial-1) == 1 && Tevent == 1
%                 digit3 = 0;
%             elseif taskData.actRew(trial-1) == 2 && Tevent == 1
%                 digit3 = 1;
%
%                 % For all prediction errors: last actRew (1/2) and hit(1/0)
%             elseif taskData.actRew(trial-1) == 1 && Tevent == 2 && taskData.hit(trial) == 1
%                 digit3 = 2;
%             elseif taskData.actRew(trial-1) == 1 && Tevent == 2 && taskData.hit(trial) == 0
%                 digit3 = 3;
%             elseif taskData.actRew(trial-1) == 2 && Tevent == 2 && taskData.hit(trial) == 1
%                 digit3 = 4;
%             elseif taskData.actRew(trial-1) == 2 && Tevent == 2 && taskData.hit(trial) == 0
%                 digit3 = 5;
%
%                 % For all boats: current actRew (1/2) and hit (0/1)
%             elseif taskData.actRew(trial) == 1 && Tevent == 3 && taskData.hit(trial) == 1
%                 digit3 = 6;
%             elseif taskData.actRew(trial) == 1 && Tevent == 3 && taskData.hit(trial) == 0
%                 digit3 = 7;
%             elseif taskData.actRew(trial) == 2 && Tevent == 3 && taskData.hit(trial) == 1
%                 digit3 = 8;
%             elseif taskData.actRew(trial) == 2 && Tevent == 3 && taskData.hit(trial) == 0
%                 digit3 = 9;
%             end
%         end
%
%         trigger = strcat(num2str(digit1),num2str(digit2),num2str(digit3));
%         trigger = str2double(trigger);
%
%     else
%         trigger = 0000;
%     end

elseif taskParam.gParam.oddball == true
    
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
    
end

if taskParam.gParam.sendTrigger == true
    %     outp(taskParam.triggers.port, trigger); This is the Dresden version
    %     WaitSecs(1/taskParam.triggers.sampleRate);
    %     outp(taskParam.triggers.port,0) % Set port to 0.
    
    %io64(ioObject,taskParam.triggers.port,trigger) % This is for brown.
end
end
