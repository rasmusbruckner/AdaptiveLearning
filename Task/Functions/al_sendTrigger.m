function trigger = al_sendTrigger(taskParam, taskData, condition, trial, Tevent, printTrigger)
%AL_SENDTRIGGER This function sends the EEG triggers
%
%   Input
%       taskParam: Task-parameter-object instance
%       taskData: Task-data-object instance
%       condition: Task condition
%       trial: Current trial
%       Tevent: Event type that gets triggered
%       printTrigger: Optional input determining if trigger is printed out
%
%   Ouptut
%       trigger: Current trigger


% Check if unit test is requested
if ~exist('printTrigger', 'var') || isempty(printTrigger)
    printTrigger = false;
end

digit1 = 0;
digit2 = 0;
digit3 = 0;
digit4 = 0;

if isequal(taskParam.gParam.taskType, 'dresden')

    % ---------------
    % Dresden version
    % ---------------

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

    % ---------------
    % Oddball version
    % ---------------

elseif isequal(taskParam.gParam.taskType, 'oddball')
    if taskParam.gParam.sendTrigger == true
        %ioObject = io64;
        %status = io64(ioObject);
    end

    if (isequal(condition, 'main') || isequal(condition, 'oddball')) %taskParam.gParam.sendTrigger == true &&

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

elseif isequal(taskParam.gParam.taskType, 'HamburgEEG')

    % Ensure that this is the way Hamburg triggers
    if taskParam.gParam.sendTrigger == true
        ioObject = io64;
        status = io64(ioObject);
    end

    % Trial onset
    if isequal(Tevent, 'onset')
        trigger = 199;
        % Response
    elseif isequal(Tevent, 'response')
        trigger = 200;
        % Fixation cross
    elseif isequal(Tevent, 'fix')
        trigger = 201;

        % Prediction error
    elseif isequal(Tevent, 'outcome')

        if isequal(condition, 'monetaryReward') && taskData.cp(trial) == 0
            trigger = 10;
        elseif isequal(condition, 'monetaryReward') && taskData.cp(trial) == 1
            trigger = 11;
        elseif isequal(condition, 'monetaryPunishment') && taskData.cp(trial) == 0
            trigger = 20;
        elseif isequal(condition, 'monetaryPunishment') && taskData.cp(trial) == 1
            trigger = 21;
        elseif isequal(condition, 'socialReward') && taskData.cp(trial) == 0
            trigger = 30;
        elseif isequal(condition, 'socialReward') && taskData.cp(trial) == 1
            trigger = 31;
        elseif isequal(condition, 'socialPunishment') && taskData.cp(trial) == 0
            trigger = 40;
        elseif isequal(condition, 'socialPunishment') && taskData.cp(trial) == 1
            trigger = 41;
        end

        % Shield
    elseif isequal(Tevent, 'shield')

        if isequal(condition, 'monetaryReward') && taskData.hit(trial) == 0
            trigger = 50;
        elseif isequal(condition, 'monetaryReward') && taskData.hit(trial) == 1
            trigger = 51;
        elseif isequal(condition, 'monetaryPunishment') && taskData.hit(trial) == 0
            trigger = 60;
        elseif isequal(condition, 'monetaryPunishment') && taskData.hit(trial) == 1
            trigger = 61;
        elseif isequal(condition, 'socialReward') && taskData.hit(trial) == 0
            trigger = 70;
        elseif isequal(condition, 'socialReward') && taskData.hit(trial) == 1
            trigger = 71;
        elseif isequal(condition, 'socialPunishment') && taskData.hit(trial) == 0
            trigger = 80;
        elseif isequal(condition, 'socialPunishment') && taskData.hit(trial) == 1
            trigger = 81;
        end

        % Reward
    elseif isequal(Tevent, 'reward')

        if isequal(condition, 'monetaryReward') && taskData.hit(trial) == 0
            trigger = 90;
        elseif isequal(condition, 'monetaryReward') && taskData.hit(trial) == 1
            trigger = 91;
        elseif isequal(condition, 'monetaryPunishment') && taskData.hit(trial) == 0
            trigger = 100;
        elseif isequal(condition, 'monetaryPunishment') && taskData.hit(trial) == 1
            trigger = 101;
        elseif isequal(condition, 'socialReward') && taskData.hit(trial) == 0
            trigger = 110;
        elseif isequal(condition, 'socialReward') && taskData.hit(trial) == 1
            trigger = 111;
        elseif isequal(condition, 'socialPunishment') && taskData.hit(trial) == 0
            trigger = 120;
        elseif isequal(condition, 'socialPunishment') && taskData.hit(trial) == 1
            trigger = 121;
        end
    end
else
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


