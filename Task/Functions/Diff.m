function diff = Diff(parameter1, parameter2)
%   Depending on the input you calculate prediction error, memory error
%   or update.
    % this function uses dirc_dist which computes the difference between two
    % value in radians. We therefore convert degrees to radians and recompute
    % degrees after the calculation.


diff = abs(rad2deg(circ_dist(deg2rad(parameter1), deg2rad(parameter2))));

end