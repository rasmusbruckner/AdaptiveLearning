function [xymatrix_ring, s_cloud, colvect_cloud] = al_staticConfettiCloud()
    % AL_STATICCONFETTICLOUD This function loads the data for a static
    % confetti cloud that "covers" the confetti cannon
    load('x_cloud.mat', 'x_cloud')
    load('y_cloud.mat', 'y_cloud')
    load('s_cloud.mat', 's_cloud')
    load('colvect_cloud.mat', 'colvect_cloud')
    xymatrix_ring = [x_cloud y_cloud]';
end