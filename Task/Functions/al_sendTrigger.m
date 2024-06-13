function trigger = al_sendTrigger(taskParam, taskData, condition, trial, Tevent)
%AL_SENDTRIGGER This function sends the M/EEG and pupil triggers
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       condition: Task condition
%       trial: Current trial
%       Tevent: Event type that gets triggered
%
%   Ouptut
%       trigger: Current trigger


%% todo: change to from trigger to triggerID to avoid conflict with MEG triggering
% todo: store catch trial info in trigger
% todo: condition is part of taskParam. use this instead

% % Check if unit test is requested
% if ~exist('printTrigger', 'var') || isempty(printTrigger)
%     printTrigger = false;
% end

digit1 = 0;
digit2 = 0;
digit3 = 0;
digit4 = 0;

if isequal(taskParam.gParam.taskType, 'dresden')

    % ---------------
    % Dresden version
    % ---------------

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

    % ---------------
    % Oddball version
    % ---------------

elseif isequal(taskParam.gParam.taskType, 'oddball')

    if taskParam.gParam.sendTrigger == true
        %ioObject = io64;
        %status = io64(ioObject);
    end

    if (isequal(condition, 'main') || isequal(condition, 'oddball'))
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

    % Shared triggers for all Hamburg versions
    % (below we have version-specific triggers)
elseif isequal(taskParam.gParam.taskType, 'HamburgEEG')

    % Trial onset
    if isequal(Tevent, 'trialOnset')
        trigger = 1;
    elseif isequal(Tevent, 'responseOnset')
        trigger = 2;
    elseif isequal(Tevent, 'responseLogged')
        trigger = 3;
    elseif isequal(Tevent, 'fix')
        trigger = 4;

        % Shield
    elseif isequal(Tevent, 'shield')

        if isequal(condition, 'monetary') && taskData.hit(trial) == 0 && taskData.cp(trial) == 0
            trigger = 50;
        elseif isequal(condition, 'monetary') && taskData.hit(trial) == 1 && taskData.cp(trial) == 0
            trigger = 51;
        elseif isequal(condition, 'monetary') && taskData.hit(trial) == 0 && taskData.cp(trial) == 1
            trigger = 52;
        elseif isequal(condition, 'monetary') && taskData.hit(trial) == 1 && taskData.cp(trial) == 1
            trigger = 53;
        elseif isequal(condition, 'social') && taskData.hit(trial) == 0 && taskData.cp(trial) == 0
            trigger = 60;
        elseif isequal(condition, 'social') && taskData.hit(trial) == 1 && taskData.cp(trial) == 0
            trigger = 61;
        elseif isequal(condition, 'social') && taskData.hit(trial) == 0 && taskData.cp(trial) == 1
            trigger = 62;
        elseif isequal(condition, 'social') && taskData.hit(trial) == 1 && taskData.cp(trial) == 1
            trigger = 63;
        end

        % Reward
    elseif isequal(Tevent, 'reward')

        if isequal(condition, 'monetary') && taskData.hit(trial) == 0
            trigger = 70;
        elseif isequal(condition, 'monetary') && taskData.hit(trial) == 1
            trigger = 71;
        elseif isequal(condition, 'social') && taskData.hit(trial) == 0
            trigger = 80;
        elseif isequal(condition, 'social') && taskData.hit(trial) == 1
            trigger = 81;
        end
    end

    % Common task
elseif isequal(taskParam.gParam.taskType, 'Hamburg')

    if isequal(Tevent, 'trialOnset')
        trigger = 1;
    elseif isequal(Tevent, 'responseOnset')
        trigger = 2;
    elseif isequal(Tevent, 'responseLogged')
        trigger = 3;
    elseif isequal(Tevent, 'fix')
        trigger = 4;
    elseif isequal(Tevent, 'black')
        trigger = 5;
    elseif isequal(Tevent, 'white')
        trigger = 6;
    elseif isequal(Tevent, 'gray')
        trigger = 7;
        
    elseif isequal(Tevent, 'outcome')
        
        if taskData.catchTrial(trial) == 1
            trigger = 49;
        elseif taskData.cp(trial) == 0
            trigger = 50;
        elseif taskData.cp(trial) == 1
            trigger = 51;
        end

    elseif isequal(Tevent, 'shield')

        if taskData.hit(trial) == 0
            trigger = 90;
        elseif taskData.hit(trial) == 1
            trigger = 91;
        end
    end

else
    trigger = 255;
end

% Send the pupil trigger
if taskParam.gParam.eyeTracker && isequal(taskParam.trialflow.exp, 'exp')
    Eyelink('message', num2str(trigger));
end

% Send the EEG trigger
if taskParam.gParam.sendTrigger == true
    %     outp(taskParam.triggers.port, trigger); This is the Dresden version
    %     WaitSecs(1/taskParam.triggers.sampleRate);
    %     outp(taskParam.triggers.port,0) % Set port to 0.

    % io64(ioObject,taskParam.triggers.port, trigger)

    % This is Hamburg
    duration = 0.001;
    IOPort( 'Write', taskParam.triggers.session,uint8(trigger), 0);
    WaitSecs(duration);
    IOPort( 'Write', taskParam.triggers.session, uint8(0), 0);
end

% Print out trigger for checking
if taskParam.gParam.printTrigger
    fprintf('Current trigger: %.1f\n', trigger);
end
end
