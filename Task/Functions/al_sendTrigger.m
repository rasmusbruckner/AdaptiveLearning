function trigger = al_sendTrigger(taskParam, taskData, condition, trial, Tevent, printTrigger)
%AL_SENDTRIGGER  This function sends the EEG triggers. See triggerscheme for details.
%
%
%   Input
%       taskParam: structure containing task paramters
%       taskData: structure containing task data
%       condition: noise condition type
%       trial: tial index
%       Tevent: trigger event 
%
%   Ouptut
%       trigger: current trigger


% Check if unit test is requested
if ~exist('printTrigger', 'var') || isempty(printTrigger)
    printTrigger = false;
end

digit1 = 0;
digit2 = 0;
digit3 = 0;
digit4 = 0;

%if taskParam.gParam.oddball == false
if isequal(taskParam.gParam.taskType, 'dresden')
    
% -------------------------------------------------------------------------    
% Dresden version   
% -------------------------------------------------------------------------
    
    % Brown trigger system
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
            
            if taskData.catchTrial(trial) || isequal(condition, 'followCannon')
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
    
elseif isequal(taskParam.gParam.taskType, 'HamburgEEG') 
    
    % Ensure that this is the way Hamburg triggers
    if taskParam.gParam.sendTrigger == true
        ioObject = io64;
        status = io64(ioObject);
    end

    % Trial onset
    if isequal(Tevent, 'onset')
        
        % onset 
        trigger = 99;

    % Response
    elseif isequal(Tevent, 'response')
        
        trigger = 100;

    % Fixation cross
    elseif isequal(Tevent, 'fix')
        
        trigger = 101;
       
    % Prediction error
    elseif isequal(Tevent, 'outcome')
        
        if isequal(condition, 'monetary') && taskData.cp(trial) == 0
            trigger = 10;
        elseif isequal(condition, 'monetary') && taskData.cp(trial) == 1
            trigger = 11;
        elseif isequal(condition, 'social') && taskData.cp(trial) == 0
            trigger = 20;
        elseif isequal(condition, 'social') && taskData.cp(trial) == 1
            trigger = 21;
        end
    
    % Shield
    elseif isequal(Tevent, 'shield')
        
        if isequal(condition, 'monetary') && taskData.hit(trial) == 0

            trigger = 30;

        elseif isequal(condition, 'monetary') && taskData.hit(trial) == 1
            
            trigger = 31;

        elseif isequal(condition, 'social') && taskData.hit(trial) == 0
            
            trigger = 40;
        
        elseif isequal(condition, 'social') && taskData.hit(trial) == 1

            trigger = 41;

        end


    % Reward
    elseif isequal(Tevent, 'reward')
        
        if isequal(condition, 'monetary') && taskData.hit(trial) == 0

            trigger = 50;

        elseif isequal(condition, 'monetary') && taskData.hit(trial) == 1
            
            trigger = 51;

        elseif isequal(condition, 'social') && taskData.hit(trial) == 0
            
            trigger = 60;
        
        elseif isequal(condition, 'social') && taskData.hit(trial) == 1

            trigger = 61;

        end

    end


elseif isequal(taskParam.gParam.taskType, 'chinese') ||...
    isequal(taskParam.gParam.taskType, 'ARC')  || isequal(taskParam.gParam.taskType, 'Hamburg') || isequal(taskParam.gParam.taskType, 'Sleep')
    
    trigger = 255;
    
end

if taskParam.gParam.sendTrigger == true
    %     outp(taskParam.triggers.port, trigger); This is the Dresden version
    %     WaitSecs(1/taskParam.triggers.sampleRate);
    %     outp(taskParam.triggers.port,0) % Set port to 0.
    
    io64(ioObject,taskParam.triggers.port, trigger) % This is for brown and maybe for Hamburg too?
end

if printTrigger 
    fprintf('Current trigger: %.1f\n', trigger);
end

end



% %first digit
%     if isequal(condition, 'main') 
%         digit1 = 1;
%     elseif isequal(condition, 'control')   
%         digit1 = 2;
%     end
%     
%     % second digit
%     if vola == .2 && taskData.cp(trial) == 1
%         digit2 = 3;
%     elseif vola == .2 && taskData.cp(trial) == 0    
%         digit2 = 0;
%     elseif vola == .7 && taskData.cp(trial) == 1
%         digit2 = 4;
%     elseif vola == .7 && taskData.cp(trial) == 0
%         digit2 = 1;
%     end
%     
%     % Third digit.
%     if trial > 1
%         if Tevent == 1 && taskData.actRew(trial-1) == 1
%             digit3 = 2;
%         elseif Tevent == 1 && taskData.actRew(trial-1) == 2
%             digit3 = 3;
%         elseif Tevent == 2 && taskData.actRew(trial-1) == 1
%             digit3 = 4;
%         elseif Tevent == 2 && taskData.actRew(trial-1) == 2
%             digit3 = 5; 
%         elseif Tevent == 3 && taskData.actRew(trial) == 1
%             digit3 = 6;
%         elseif Tevent == 3 && taskData.actRew(trial) == 2
%             digit3 = 7;
%         end
%     else
%         if Tevent == 3 && taskData.actRew(trial) == 1
%             digit3 = 6;
%         elseif Tevent == 3 && taskData.actRew(trial) == 2
%             digit3 = 7;
%         end
%     end


