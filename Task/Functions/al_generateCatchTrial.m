function catchTrial = al_generateCatchTrial(cp)
% Add comments!

if rand <= .10 && cp == 0
    catchTrial = 1;
else
    catchTrial = 0;
end
end