function response = al_stressSlider(taskParam, questionTxt, scaleTxt)
% AL_STRESSSLIDER This function creates a slider for the fMRI experiment
%   
%   Participants can indicate their stress level etc. on a likert scale. 
%   The code is based on "Likert Scale" open-source code by Peter Scarfe:
% 
%   https://peterscarfe.com/likertScale.html
%
%   Input
%       taskParam: Task-parameter-object instance
%       questionTxt: Displayed question
%       scaleTxt: Scale name for feedback
%  
%   Output
%       response: Participant choice

% Todo: we have to figure out what button subject should press to continue
% (currently Enter)


% We will use a range of text sizes
smallTextSize = taskParam.strings.headerSize;

% Our scale will span a proportion of the screens x dimension
scaleLengthPix = taskParam.display.screensize(4) / 1.5;
scaleHLengthPix = scaleLengthPix / 2;

% Coordinates of the scale left and right ends
leftEnd = [taskParam.display.zero(1) - scaleHLengthPix taskParam.display.zero(2)];
rightEnd = [taskParam.display.zero(1) + scaleHLengthPix taskParam.display.zero(2)];
scaleLineCoords = [leftEnd' rightEnd'];

% Scale line thickness
scaleLineWidth = 1;

% Here we set the initial position of the mouse to the centre of the screen
SetMouse(taskParam.display.zero(1), taskParam.display.zero(2), taskParam.display.window.onScreen);

% Number of points on our likert scale
numScalePoints = 10;

% The points will be linearly spaced over the scale: here we make the xy
% coordinateas of each point
xPosScalePoints = linspace(taskParam.display.zero(1) - scaleHLengthPix, taskParam.display.zero(1) + scaleHLengthPix, numScalePoints);
yPosScalePoints = repmat(taskParam.display.zero(2), 1, numScalePoints);
xyScalePoints = [xPosScalePoints; yPosScalePoints];

% Do the same for the numbers that we will put on the buttons. Here we
% toggle first to the smaller text size we will be using for the labels for
% the buttons then reinstate the standard text size
Screen('TextSize', taskParam.display.window.onScreen, smallTextSize);
numBoundsAll = nan(numScalePoints, 4);
for i = 1:numScalePoints
    [~, ~, numBoundsAll(i, :)] = DrawFormattedText(taskParam.display.window.onScreen, num2str(i), 0, 0, taskParam.colors.white);
end

% Width and height of the scale number text bounding boxes
numWidths = numBoundsAll(:, 3)';
halfNumWidths = numWidths / 2;
numHeights = [range([numBoundsAll(:, 2) numBoundsAll(:, 4)], 2)]';
halfNumHeights = numHeights / 2;

% Dimensions of the dots on our scale
dim = 40;
hDim = dim / 2;

% The numbers are aligned to be directly under the relevant button (tops of
% their bounding boxes "numShiftDownPix" below the button y coordinate, and
% aligned laterally such that the centre of the text bounding boxes aligned
% with the x coordinate of the button
numShiftDownPix = 80;
xNumText = xPosScalePoints - halfNumWidths;
yNumText = yPosScalePoints + halfNumHeights + numShiftDownPix;

% Sync us and get a time stamp. We blank the window first to remove the
% text that we drew to get the bounding boxes.
Screen('FillRect', taskParam.display.window.onScreen, taskParam.colors.black)
Screen('Flip', taskParam.display.window.onScreen);

% Initialize response variable
response = nan;

% Loop the animation until a key is pressed
while ~KbCheck(-1)

    % Display typical background
    al_lineAndBack(taskParam)

    % Get the current position of the mouse
    [mx, my, buttons] = GetMouse(taskParam.display.window.onScreen);

    % Check if the mouse is within any of the circles: this is done by
    % seeing if the Euclidean distance between the mouse and the buttons in
    % less than their radius. The mouse can only overlap with one, as the
    % buttons do not overlap.
    inCircles = sqrt((xPosScalePoints - mx).^2 + (yPosScalePoints - my).^2) < hDim;

    % Identify the index of the circle if we are in one and get its coordinates
    weInCircle = sum(inCircles) > 0;
    if weInCircle == 1
        
        [~, posCircle] = max(inCircles);
        coordsCircle = xyScalePoints(:, posCircle);

        GetMouse(taskParam.display.window.onScreen);

        % Record response
        if buttons(1)
            response = posCircle;
        end
    end

    % check for click and give feedback
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);
    if isnan(response) == false
        DrawFormattedText(taskParam.display.window.onScreen, [scaleTxt ' ' num2str(response)], 'center', taskParam.display.screensize(4)*0.7);
        DrawFormattedText(taskParam.display.window.onScreen,  taskParam.strings.txtPressEnter, 'center', taskParam.display.screensize(4)*0.9);
    end

    % Draw the scale line
    Screen('DrawLines', taskParam.display.window.onScreen, scaleLineCoords, scaleLineWidth, taskParam.colors.black);

    % Text for the ends of the slider
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);

    % Draw the title for the slider
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.headerSize);
    DrawFormattedText(taskParam.display.window.onScreen, questionTxt, 'center', taskParam.display.screensize(4)*0.1, [255 255 255]);
    Screen('TextSize', taskParam.display.window.onScreen, taskParam.strings.textSize);

    % If we are in a circle identify it with a frame (exploiting drawing
    % order of operations)
    if weInCircle == 1
        Screen('DrawDots', taskParam.display.window.onScreen, coordsCircle, dim * 1.2, taskParam.colors.black, [], 3);
    end

    % Draw the likert scale points
    Screen('DrawDots', taskParam.display.window.onScreen, xyScalePoints, dim, taskParam.colors.lightGray, [], 3);

    % If we are clicking a circle we flag it (exploiting drawing order of operations)
    if weInCircle == 1 && sum(buttons) > 0

        % Highlight the pressed button
        Screen('DrawDots', taskParam.display.window.onScreen, coordsCircle, dim * 1.2, taskParam.colors.black, [], 3);

    end

    Screen('TextSize', taskParam.display.window.onScreen, smallTextSize);
    for thisNum = 1:numScalePoints
        DrawFormattedText(taskParam.display.window.onScreen, num2str(thisNum), xNumText(thisNum), yNumText(thisNum), taskParam.colors.white);
    end

    % Draw a white dot where the mouse cursor is
    Screen('DrawDots', taskParam.display.window.onScreen, [mx my], 10, taskParam.colors.white, [], 3);

    % Flip to the screen
    Screen('Flip', taskParam.display.window.onScreen);

end