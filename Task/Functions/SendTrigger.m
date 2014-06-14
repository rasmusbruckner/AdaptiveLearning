function SendTrigger(taskParam, trigger)
%This function sends the EEG triggers.

if taskParam.gParam.sendTrigger == true
    lptwrite(taskParam.triggers.port, trigger);
    WaitSecs(1/taskParam.triggers.sampleRate);
    lptwrite(taskParam.triggers.port,0) % Set port to 0.
end
end

