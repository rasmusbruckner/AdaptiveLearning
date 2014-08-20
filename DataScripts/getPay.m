function totPerf = getPay(ID)
% This function reads out the performance of a subject.

% Has to be adapted to silver.

% Load data.
DataLoad = sprintf('ADL_G_%s.mat', num2str(cell2mat({ID})));
subject = load(DataLoad);
subBlocks = struct2cell(subject);

accPerf = zeros(length(subject),1);
% Loop through data and read out performance.
for i = 1:length(subBlocks)
    accPerf(i) = subBlocks{i}.accPerf(end);
end
totPerf = sprintf('"%s" won: %2.1f $.', ID, sum(accPerf));
end
