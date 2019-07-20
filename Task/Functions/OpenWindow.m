function [window, windowRect, textures] = OpenWindow(debug, screenNumber)
%OPENWINDOW   Opens the psychtoolbox screen
%
%   Input
%       debug: indicates if we're currently debugging
%       screenNumber: used screen number
%   Output
%       window: psychtoolbox window object
%       windowRect: ??
%       textures: structure containing all textures


% Open psychtoolbox window
if debug == true
    [window, windowRect] = Screen('OpenWindow', screenNumber-1, [66 66 66], [420 250 1020 650]);
    %[window, windowRect] = Screen('OpenWindow', screenNumber-1, [66 66 66], [0 0 1 1]);
else
    [window, windowRect] = Screen('OpenWindow', screenNumber-1, [66 66 66], []);
end

% ??
imageRect = [0 0 120 120];
dstRect = CenterRect(imageRect, windowRect);

% Load images
[cannonPic, ~, alpha]  = imread('cannon.png');
[rocketPic, ~, rocketAlpha]  = imread('rocket_empty.png');
[rocketPic_lightning, ~, rocketAlpha_lightning]  = imread('rocket_lightning.png');
[rocketPic_star, ~, rocketAlpha_star]  = imread('rocket_star.png');
[rocketPic_swirl, ~, rocketAlpha_swirl]  = imread('rocket_swirl.png');
[spacebattlePic, ~, ~]  = imread('spacebattle_intro1.jpg');

% Create pictures based on images
cannonPic(:,:,4) = alpha(:,:);
rocketPic(:,:,4) = rocketAlpha(:,:);
rocketPic_lightning(:,:,4) = rocketAlpha_lightning(:,:);
rocketPic_star(:,:,4) = rocketAlpha_star(:,:);
rocketPic_swirl(:,:,4) = rocketAlpha_swirl(:,:);

% ??
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Create textures
cannonTxt = Screen('MakeTexture', window, cannonPic);
rocketTxt = Screen('MakeTexture', window, rocketPic);
rocketTxt_lightning = Screen('MakeTexture', window, rocketPic_lightning);
rocketTxt_star = Screen('MakeTexture', window, rocketPic_star);
rocketTxt_swirl = Screen('MakeTexture', window, rocketPic_swirl);

spacebattleTxt = Screen('MakeTexture', window, spacebattlePic);
[shieldPic, ~, alpha]  = imread('shield.png');
shieldPic(:,:,4) = alpha(:,:);
shieldTxt = Screen('MakeTexture', window, shieldPic);
[basketPic, ~, alpha]  = imread('basket.png');
basketPic(:,:,4) = alpha(:,:);
basketTxt = Screen('MakeTexture', window, basketPic);

% Create structure that contains all textures
textures = struct('cannonTxt', cannonTxt, 'rocketTxt', rocketTxt, 'rocketTxt_lightning', rocketTxt_lightning, 'rocketTxt_star', rocketTxt_star,...
    'rocketTxt_swirl', rocketTxt_swirl, 'spacebattleTxt', spacebattleTxt, 'shieldTxt', shieldTxt, 'basketTxt', basketTxt, 'dstRect', dstRect);
%ListenChar(2);
%HideCursor;

end