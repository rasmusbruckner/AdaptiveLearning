%% ExportData
%
% Use this script to merge all specified data and to export them to
% a CSV file called 'DATA'.

clear all

%% Which subjects and variables do you want to load?
% Use {'all'} for all subjects or give IDs like {'001' '002'}.
subject = {'all'}; %'test' 'test2'
variable = {'ID', 'trial', 'predErr'}';


if isequal(subject,{'all'})
    subjectFile= dir(fullfile('AdaptiveLearning/DataDirectory/*.mat'));
    DataLoad = cell(numel(subjectFile),1);
    for i = 1:length(subjectFile)
        DataLoad{i} = subjectFile(i).name; % Full data files to load.
        subject(i) = DataLoad(i); % Find subject names and...
        subject(i) = {subject{i}(13:end-4)}; %... extract them.
    end
else
    DataLoad = cell(numel(subject),1);
    for j = 1:length(subject)
        DataLoad{j,1} = sprintf('BattleShips_%s.mat',...
            num2str(cell2mat((subject(j))))); % Full data files to load.
    end
end

% Cell that containts structs with all data.
allData = cell(length(DataLoad));
for i = 1:length(DataLoad)
    allData{i,1} = load(DataLoad{i});
end

%% Export selected data.

% filename for csv file.
DATA = fopen('AdaptiveLearning/DataDirectory/DATA.csv', 'w');

% raw names of structs.
name = {'DataLV_', 'DataHV_', 'DataControlLV_', 'DataControlHV_'};

% preallocate variable that contains the structs of the subject.
structure = cell(2,1);

% some tricks that save us space.
print = '%s';
st = '%s\t';
stn = '%s\n';

% headers for csv output.
for z = 1:length(variable)
    if z <= (length(variable)-1)
        fprintf(DATA, st, variable{z});
    else
        fprintf(DATA, stn, variable{z});
    end
end

% find the subject's structures
for i = 1:length(name) % name.
    for k = 1:length(subject) % subject.
        structure{i,k} = sprintf(strcat(name{i}, print),...
            num2str(cell2mat((subject(k)))));  
    end
end

% loop through data and print out variables.
for a = 1:length(allData)
    for i = 1:4 % structure.
        for k = 1:3 % trials per structure.
            for x = 1:3 % variable.
                val = allData{a}.(structure{i,a}).(variable{x})(k);
                type = class(val);
                if isequal(type, 'cell')
                    val = cell2mat(val);
                elseif isequal(type, 'double')
                    val = num2str(val);
                end
                fprintf(DATA, '%s\t', val);
            end
            fprintf(DATA, '\n');
        end
    end
end
fclose(DATA);