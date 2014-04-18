% 
% fid = fopen('Output.txt','wt');
% fprintf(fid, '%s\t %s\t %s\n', 'hallo','hallo','hallo');
% % have a matrix M(N,3) ready to go
% dlmwrite('Output.txt', M,'delimiter', '\t', '-append')
% fclose(fid);

x = 0:.1:1;
A = [x; exp(x)];

fileID = fopen('exp.txt','w');
fprintf(fileID,'%6s %12s\n','x','exp(x)');
fprintf(fileID,'%6.2f %12.8f\n',A);
fclose(fileID);