function diff = al_diff(parameter1, parameter2)
%AL_DIFF   This function calculates the difference of two variables on a circle
%   DIFF is used to compute prediction error, memory error
%   or update in the cannon task
%
%   Input
%       parameter1, parameter2: values between which difference is computed
%
%   Output
%        diff: computed difference


    diff = rad2deg(circ_dist(deg2rad(parameter1), deg2rad(parameter2)));

end