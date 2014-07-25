
clear all

safe = 3
s = 3
vola = .7 %.4 .6
trials = 160 % 160

for i = 1:trials
    if (rand < vola && s==0) || i == 1;
        mean=round(rand(1).*359); % Outcome expressed in degrees.
        cp(i)=1;
        s=safe;
        TAC(i)=0; %TAC(i)=1;
    else
        TAC(i)=TAC(i-1)+1;
        s=max([s-1, 0])
    end
    %outcome(i) = 90
    outcome(i)=round(normrnd(mean, 10));
    distMean(i)=mean;
end

sum(cp)
(sum(cp)/trials)*100