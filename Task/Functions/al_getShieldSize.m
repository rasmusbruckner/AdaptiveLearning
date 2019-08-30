function ASS = al_getShieldSize(minASS, maxASS, mu)
%AL_GETSHIELDSIZE   This function samples the current size of the shield
% from an exponential distribution given mean and minimum and maximum
% shield size.
%
%   Input
%       minASS: minimum angular shield size
%       maxASS: maximum angular shield size
%       mu: mean of shield size
%   
%   Output
%       ASS: sampled angular shield size

    % Initialize angular shield size
    ASS = nan;
    
    % Sample shield size from exponential distribution
    while ~isfinite(ASS) || ASS < minASS || ASS > maxASS
        ASS = exprnd(mu);
    end
end