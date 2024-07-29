% Getting eye that's being measured (matters for retrieving online gaze
% data) - only oncs:
eyeused = Eyelink('EyeAvailable');
sacc=[]; % and initializing saccade counter

% this line comes after each phase: pre-trial fixation, estimation period,
% etc. It counts the saccades, which can be presented at the end of a
% block (or whenever you like)
sacc(end+1) = check_saccade(eyeused, X, Y, varopts.ppd); % X, Y: center/fixation position; varopts.ppd = pixels per degrees:

% pixels per degree is calculated like this: 
function ppd = estimate_pixels_per_degree(options)
o = tan(0.5*pi/180)*options.dist; % options.dist = distance from screen (cm)
ppd = 2*o*options.resolution(1)/options.width; % options.resolution(1) = x resolution (in pixels); options.width = width of screen (cm)
end


% this is the main function that checks for saccades: 

function sacc = check_saccade(eye, xc, yc, ppd)
pause(0.002)
sacc = 0;
[samples, ~, ~] = Eyelink('GetQueuedData');
if eye==0
    x = (samples(14,:)-xc)/ppd;
    y = (samples(16,:)-yc)/ppd;
else
    x = (samples(15,:)-xc)/ppd;
    y = (samples(17,:)-yc)/ppd;
end

d = (x.^2 + y.^2).^.5;
a=d(2:length(d));
if any(a>4)
    sacc = 1;
end
end