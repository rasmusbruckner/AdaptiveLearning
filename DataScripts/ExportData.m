%% ExportData
%
% Use this script to merge all specified data and to export them to
% a CSV file called 'DATA'.

clear all

%% Which subjects and variables do you want to load?

% Use {'all'} for all subjects or give IDs like {'001' '002'}.
subject = {'rew1'}; %'test' 'test2'
variable = {'ID', 'sex', 'age', 'cBal', 'rew', 'sigma','cond', 'vola',...
    'trial', 'cp', 'TAC', 'catchTrial', 'boatType', 'actRew' 'outcome',...
    'distMean', 'pred', 'predErr', 'memErr', 'hit', 'UP', 'perf',...
    'accPerf', 'predT', 'outT', 'boatT'};

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
        
        DataLoad{j,1} = dir(fullfile(sprintf('AdaptiveLearning/DataDirectory/*%s.mat', num2str(cell2mat((subject(j)))))));
        DataLoad{j,1} = DataLoad{j,1}.name;
        %DataLoad{j,1} = sprintf('BattleShips_%s.mat',...
         %   num2str(cell2mat((subject(j))))); % Full data files to load.
    end
end

% Cell that containts structs with all data.
allData = cell(length(DataLoad));
for i = 1:length(DataLoad)
    allData{i,1} = load(DataLoad{i});
end

%% Export selected data.

% Filename for csv file.
DATA = fopen('AdaptiveLearning/DataDirectory/DATA.csv', 'w');

% Raw names of structs.
name = cell(1,length(subject));%cell(6,length(subject));
for i = 1:length(subject);
    name{:,i} = fields(allData{i}); %name(:,i)
end
% preallocate variable that contains the structs of the subject.
structure = cell(2,1);

% some tricks that save us space.
print = '%s';
st = '%s\t';
stn = '%s\n';

% Headers for csv output.
for z = 1:length(variable)
    if z <= (length(variable)-1)
        fprintf(DATA, st, variable{z});
    else
        fprintf(DATA, stn, variable{z});
    end
end

% Loop through data and print out variables.
for a = 1:length(allData)
    for i = 1:length(name{a}) % name. das ist der springende punkt!
        trials=(length(allData{a}.(name{a}{i}).(variable{1}))); % Read out trial N.  Hier Problem mit der länge der Cell. sollte aber gehen. (length(allData{a}.(name{i,a}).(variable{1})))
        for k = 1:trials
            for x = 1:length(variable) % variable.
                val = allData{a}.(name{a}{i}).(variable{x})(k);  % und hier auch! val = allData{a}.(name{i,a}{1}).(variable{1})(1) %%%allData{a}.(name{i,a}).(variable{x})(k);
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