function al_indicateRun(taskParam, runNumber)
% AL_INDICATERUN This function indicates the run in the fMRI version
%
%   Input:
%       taskParam: Task-parameter-object instance
%       runNumber: Number of current run
%
%   Output:
%       None

% Todo: Potentially necessary to outsource to text file

if runNumber == 1

    header = 'Bitte anpassen';
    txt = ['Bitte Instruktionen anpassen'];


elseif runNumber == 2

    header = 'Bitte anpassen';
    txt = ['Bitte Instruktionen anpassen'];


elseif runNumber == 3

    header = 'Bitte anpassen';
    txt = ['Bitte Instruktionen anpassen'];

else
    error('Run number undefined')
end

feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end