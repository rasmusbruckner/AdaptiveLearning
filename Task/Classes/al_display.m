classdef al_display
    %AL_DISPLAY This class definition file specifies the 
    %   properties and methods of a display object
    %
    %   A display object has general display methods such as
    %   creating the psychtoolbox window and parameters, e.g.,
    %   screen coordinates
    
    % TODO: This still needs to be commented properly and some variable
    % names have to be updated
    % We should also consider child classes for properties or methods
    % that are unique to a project

    % Properties of the display object
    % --------------------------------
    
    properties
        
        % Texture of cannon picture
        cannonTxt

        % Todo: comment
        dstRect
        centeredSocialFeedbackRect

        % Background texture
        backgroundTxt

        % Background color
        backgroundCol

        % Screen size
        screensize

        % Psychtoolbox window
        window

        % Center of the screen
        zero

        % Todo: comment
        screensizePart

        % Todo: comment
        windowRect

        % Todo: comment
        backgroundCoords

        % Todo: comment
        imageRect
        socialFeedbackRect

        % Textures related to social task (consider child class for this)
        socialHasTxts 
        socialDisTxts 

        % Number of textures in social task (also potentially child class)
        nHas
        nDis

    end
    
    % Methods of the display object
    % -----------------------------
    methods
        
        function displayobj = al_display()
            %AL_DISPLAYOBJ This function creates a displayob object of
            % class al_display
            %
            %   The initial values correspond to useful defaults that
            %   are often used across tasks.
            
            displayobj.cannonTxt = nan;
            displayobj.dstRect = nan;
            displayobj.backgroundTxt = nan;
            displayobj.backgroundCol = [0, 0, 0];
            displayobj.imageRect = [0 0 180 270];
            displayobj.socialFeedbackRect = [0 0 562 762]/4;
            %displayobj.socialTxts = struct;

        end

        function displayobj = openWindow(displayobj, gParam)
            %OPENWINDOW This function creates an opens the psychtoolbox
            %   screen
            %
            %   Input
            %       displayobj: Display object
            %       gParam: General task parameters
            
            % Get screen properties
            % set(0,'units','pixels')
            
            % screensize = screensize(taskParam.gParam.screenNumber, :);
            displayobj.screensizePart = displayobj.screensize(3:4);
            displayobj.zero = displayobj.screensizePart / 2;
            %[window.onScreen, windowRect, textures] = OpenWindow(taskParam.gParam.debug, taskParam.gParam.screenNumber);
            
            % screenNumbers=Screen('Screens', 2);
            % Open psychtoolbox window
            if gParam.debug == true
                [displayobj.window.onScreen, displayobj.windowRect] = Screen('OpenWindow', gParam.screenNumber-1, displayobj.backgroundCol, [1920 0 1920+1920 1080]); % 0 0 600 400 %2100 0 3700 1440% 0 0 600 400%420 250 1020 650 [0 0 1920 1080]  labptop mit bildschirm fu[1920 0 1920+1920 1080]
            else
                [displayobj.window.onScreen, displayobj.windowRect] = Screen('OpenWindow', gParam.screenNumber-1, displayobj.backgroundCol, displayobj.screensize); % []% displayobj.screensize% [] %  1    1    2560    1440  1    1    2560 1440 1707.6    9602560x1440   66 66 66
            end
                       
            [displayobj.window.screenX, displayobj.window.screenY] = Screen('WindowSize', displayobj.window.onScreen);
            displayobj.window.centerX = displayobj.window.screenX * 0.5; % center of screen in X direction
            displayobj.window.centerY = displayobj.window.screenY * 0.5; % center of screen in Y direction
            displayobj.window.centerXL = floor(mean([0 displayobj.window.centerX])); % center of left half of screen in X direction
            displayobj.window.centerXR = floor(mean([displayobj.window.centerX displayobj.window.screenX])); % center of right half of screen in X direction
            
        end

        function displayobj = createRects(displayobj)
            % CREATERECTS This function centers the imageRect ("dstRect")
            % based on "windowRect" by taking into account that imageRect
            % differs for each task version, e.g., standard cannon vs.
            % confetti

            displayobj.dstRect = CenterRect(displayobj.imageRect, displayobj.windowRect);
            displayobj.centeredSocialFeedbackRect = CenterRect(displayobj.socialFeedbackRect, displayobj.windowRect);

        end

        function displayobj = createTextures(displayobj, cannonType)
            % CREATETEXTURES This function creates textures of displayed
            %   images
            % 
            %   Input
            %       displayobj: Display object
            %       cannonType: Which type of cannon should be shown
            %

            % Load images
            %[cannonPic, ~, alpha]  = imread('cannon.png');
            if strcmp(cannonType, "standard")
                [cannonPic, ~, alpha]  = imread('cannon_not_centered.png');
            else            
                [cannonPic, ~, alpha]  = imread('confetti_cannon.png');
            end
            [backgroundPic, ~, backgroundPicAlpha] = imread('Greybanner Coliseum - Day - Large - 44x32.jpg');

            % Todo: make optional when combining with other versions 
            % Load social-fedback images
            
            % Textures social task
            % Consider consider to put this in child class because it is
            % not shared across projects
            parentDirectory = fileparts(cd);
            displayobj.nHas = length(dir([parentDirectory '/Files/socialFeedback/HAS/*.JPG']));
            displayobj.nDis = length(dir([parentDirectory '/Files/socialFeedback/DIS/*.JPG']));

            for n=1:displayobj.nHas
              imagesHas{n} = imread(sprintf('has_%d.JPG',n));
              displayobj.socialHasTxts{n} = Screen('MakeTexture', displayobj.window.onScreen, imagesHas{n});
            end

            for n=1:displayobj.nDis
              imagesDis{n} = imread(sprintf('dis_%d.JPG',n));
              displayobj.socialDisTxts{n} = Screen('MakeTexture', displayobj.window.onScreen, imagesDis{n});
            end

            backgroundPicSize = size(backgroundPic);
            ySize = displayobj.window.screenY; 
            scaleFactor = ySize/backgroundPicSize(1); 
            xSize = backgroundPicSize(2) * scaleFactor;
            displayobj.backgroundCoords = [displayobj.zero(1)-xSize/2, displayobj.zero(2)-ySize/2, displayobj.zero(1)+xSize/2, displayobj.zero(2)+ySize/2];
        
            % Create pictures based on images   
            % todo: add description
            cannonPic(:,:,4) = alpha(:,:);
            % backgroundPic(:,:,4) = backgroundPicAlpha(:,:);
        
            % todo: add description
            Screen('BlendFunction', displayobj.window.onScreen, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
            % Create textures
            displayobj.cannonTxt = Screen('MakeTexture', displayobj.window.onScreen, cannonPic);
            displayobj.backgroundTxt = Screen('MakeTexture', displayobj.window.onScreen, backgroundPic);


        end
    end

    methods (Static)    
        function screen_warnings()
            % SCREENWARNINGS This function handles screen warnings

            Screen('Preference', 'VisualDebugLevel', 3);
            Screen('Preference', 'SuppressAllWarnings', 1);
            Screen('Preference', 'SkipSyncTests', 2);
   
        end
    end
end

