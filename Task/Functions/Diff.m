function diff = Diff(parameter1, parameter2)
%DIFF   Calculates the difference of two variables on a circle
%   DIFF is used to compute prediction error, memory error
%   or update in the cannon task

diff = rad2deg(circ_dist(deg2rad(parameter1), deg2rad(parameter2)));

end