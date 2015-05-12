function diff = Diff(parameter1, parameter2)
%   Depending on the input you calculate prediction error, memory error
%   or update.

diff = abs(rad2deg(circ_dist(deg2rad(parameter1), deg2rad(parameter2))));

end