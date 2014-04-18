
fid = fopen('Output.txt','wt');
fprintf(fid, '%s\t %s\t %s\n', 'hallo','hallo','hallo');
% have a matrix M(N,3) ready to go
dlmwrite('Output.txt', M,'delimiter', '\t', '-append')
fclose(fid);