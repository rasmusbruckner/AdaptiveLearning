% Angular shield size:
mu=10;
minASS=10;
maxASS=360;



for j = 1:20

ASS=nan;
while ~isfinite(ASS)| ASS<minASS|ASS>maxASS
ASS=exprnd(mu);
end
allASS(j)=ASS;

end

hist(allASS)

