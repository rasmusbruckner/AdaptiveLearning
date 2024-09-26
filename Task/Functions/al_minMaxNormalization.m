function normalizedCoordinate = al_minMaxNormalization(currMouseCoord, minCoord, maxCoord)
%AL_MINMAXNORMALIZATION This function performs min-max normalization for the
%joystick at the Donner MEG lab at UKE
%
%   Input
%       currMouseCoord: Un-normalized joystick position
%   
%   Output
%       normalizedCoordinate: Normalized mouse (joystick position)

normalizedCoordinate = (currMouseCoord-(minCoord))/(maxCoord-(minCoord));

end

