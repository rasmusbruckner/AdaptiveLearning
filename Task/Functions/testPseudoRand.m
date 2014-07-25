
% 
 
% 
% i = 0;
% %t = getSecs
% tic
% while i < 3
%     
%     cp = shuffle([zeros((trials-cps),1); ones((cps),1)])
%     %cp = shuffle([zeros(trials-round((trials*.1)),1); ones((round(trials*.1)),1)]);
%     aux = findseq(cp);
%     if sum(aux(:,1)) == 0
%         i = min(aux(aux == 0, 4));
%     end
% end
% toc
% %time = getSecs - t

% aux1 = 1;
% aux2 = []
% for i = 2:length(cp)
%     if cp(i) == cp(i-1)
%         aux1 = aux1 + 1;
%     else
%         aux2 = [aux2; [cp(i-1) aux1]];
%         aux1 = 1;
%     end
% end
% 
% 
% trials = 100
% cps = 10
% safe = 3
% 
% 
% %while 1
 %cp = shuffle([zeros((trials-cps),1), ones((cps)),1])
 
 
% 

% 
% 
% 
    
trials = 200;
 cps = 20;
 safe = 3;
l = 2
z = repmat(l, 1, cps)
 
while 1
 
cp = shuffle([ones(1,(trials-cps)), z ]);

% cp: not two cps in a row.
q = diff([0 cp 0] == 2);
v = find(q == -1) - find(q == 1);

% no cp: at least three in a row.
x = diff([0 cp 0] == 1);
y = find(x == -1) - find(x == 1);

if isempty(find(v >=2 )) && isempty(find(y <=4))
   break

end
end

cp = cp'


    

