
hazardRate = .4
s = 3
safe = 3

for i = 1:100
    if (rand< hazardRate & s==0) | i == 1;
        mean=rand(1).*2*pi;
        cp(i)=1;
        s=safe;
        TAC(i)=0; %TAC(i)=1;
    else
        TAC(i)=TAC(i-1)+1; %TAC(i)=TAC(i-1)+1;
        s=max([s-1, 0]);
    end
    %while ~isfinite(outcome(i))|outcome(i)>2*pi|outcome(i)<0;
        outcome(i)=normrnd(mean, .5);
    %end
    distMean(i)=mean;
end