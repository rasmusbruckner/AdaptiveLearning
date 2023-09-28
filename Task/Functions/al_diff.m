function diff = al_diff(parameter1, parameter2)
%AL_DIFF This function computes the difference of two variables on a circle
%   al_diff is used to compute prediction error, memory error,
%   or update
%
%   Input
%       parameter1, parameter2: the 2 input parameters
%
%   Output
%        diff: computed difference

    % Difference expressed in degrees
    diff = rad2deg(circ_dist(deg2rad(parameter1), deg2rad(parameter2)));

end