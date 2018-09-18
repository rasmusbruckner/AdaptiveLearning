function ASS = al_getShieldSize(minASS, maxASS, mu)
% Add comments!

ASS = nan;
    while ~isfinite(ASS) || ASS < minASS || ASS > maxASS
        ASS = exprnd(mu);
    end
end