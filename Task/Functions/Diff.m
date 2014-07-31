function [diff, diffNorm, diffPlus, diffMin, rawDiff] = Diff(parameter1, parameter2)
%This function calculates some difference parameters.
%
%   Depending on the input you calculate prediction error, memory error
%   or update.
%   We have to calculate different parameters because the normal
%   difference is calculated from the beginning of the line
%   (0 degrees on the circle) to the end of the line (360 degrees).
%   However, on a circle this difference cannot be bigger than 180 degrees.
%   Therefore we also add and subtract 360 degrees to/from the normal parameter
%   and choose the 'right' one which is smaller than 180 degrees.

% diffNorm = sqrt((parameter1 - parameter2)^2);
% diffPlus = sqrt((parameter1 - parameter2 + 360)^2);
% diffMin =  sqrt((parameter1 - parameter2 - 360)^2);


diffNorm = abs(parameter1-parameter2);
diffPlus = abs(parameter1 - parameter2 + 360);
diffMin =  abs(parameter1 - parameter2 - 360);
rawDiff = (parameter1 - parameter2);
if diffNorm <= 180
    diff = diffNorm;
elseif diffPlus <= 180
    diff = diffPlus;
elseif diffMin <= 180
    diff = diffMin;
end
end

