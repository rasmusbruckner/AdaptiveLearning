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

        % XX
        doctorTxt

        % XX
        heliTxt

        % Textures drugs etc. 
        pill1Txt
        pill2Txt
        pill3Txt
        pill4Txt
        syringeTxt

        % Todo: comment
        dstRect
        centeredSocialFeedbackRect

        doctorRect

        heliRect

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

        % Todo: comment
        heliImageRect

        % Todo: comment
        pillImageRect
        syringeImageRect

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
            displayobj.doctorTxt = nan;
            displayobj.dstRect = nan;
            displayobj.heliRect = nan;
            displayobj.backgroundTxt = nan;
            displayobj.backgroundCol = [0, 0, 0];
            displayobj.imageRect = [0 0 180 270];
            displayobj.socialFeedbackRect = [0 0 562 762]/4;
            displayobj.doctorRect = [0 0 100 100];
            displayobj.heliImageRect = [0 0 100 100];
            displayobj.pillImageRect = [0 0 30 30];
            displayobj.syringeImageRect = [0 0 50 50];

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

            % Open psychtoolbox window
            if gParam.debug == true
                [displayobj.window.onScreen, displayobj.windowRect] = Screen('OpenWindow', gParam.screenNumber-1, displayobj.backgroundCol, [0 0 1920 1080]);%[1920 0 1920+1920 1080] % 0 0 600 400 %2100 0 3700 1440% 0 0 600 400%420 250 1020 650 [0 0 1920 1080]  labptop mit bildschirm fu[1920 0 1920+1920 1080]
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
            displayobj.doctorRect = CenterRect(displayobj.doctorRect, displayobj.windowRect);
            displayobj.heliImageRect = CenterRect(displayobj.heliImageRect, displayobj.windowRect);            
            displayobj.pillImageRect = CenterRect(displayobj.pillImageRect, displayobj.windowRect);
            displayobj.syringeImageRect = CenterRect(displayobj.syringeImageRect, displayobj.windowRect);
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

            % Todo: these should be methods that are specific to these
            % versions
            
            % Load images
            %[cannonPic, ~, alpha]  = imread('cannon.png');
            if strcmp(cannonType, 'standard')
                [cannonPic, ~, alpha]  = imread('cannon_not_centered.png');
            elseif strcmp(cannonType, 'helicopter')
                [cannonPic, ~, alpha]  = imread('helicopter.png');
                [doctorPic, ~, doctorAlpha]  = imread('doctor.png');
                [heliPic, ~, heliAlpha]  = imread('helicopter.png');
                [pill1Pic, ~, pill1Alpha]  = imread('pill_1.png'); 
                [pill2Pic, ~, pill2Alpha]  = imread('pill_2.png'); 
                [pill3Pic, ~, pill3Alpha]  = imread('pill_3.png'); 
                [pill4Pic, ~, pill4Alpha]  = imread('pill_4.png'); 
                [syringePic, ~, syringeAlpha]  = imread('syringe.png');

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
            cannonPic(:,:,4) = alpha(:,:);
            % backgroundPic(:,:,4) = backgroundPicAlpha(:,:);
            if strcmp(cannonType, 'helicopter')
                doctorPic(:,:,4) = doctorAlpha(:,:);
                heliPic(:,:,4) = heliAlpha(:,:);
                pill1Pic(:,:,4) = pill1Alpha(:,:);
                pill2Pic(:,:,4) = pill2Alpha(:,:);
                pill3Pic(:,:,4) = pill3Alpha(:,:);
                pill4Pic(:,:,4) = pill4Alpha(:,:);
                syringePic(:,:,4) = syringeAlpha(:,:);
            end

            % todo: add description
            Screen('BlendFunction', displayobj.window.onScreen, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
            % Create textures
            displayobj.cannonTxt = Screen('MakeTexture', displayobj.window.onScreen, cannonPic);
            displayobj.backgroundTxt = Screen('MakeTexture', displayobj.window.onScreen, backgroundPic);
          
            if strcmp(cannonType, 'helicopter')
                displayobj.doctorTxt = Screen('MakeTexture', displayobj.window.onScreen, doctorPic);
                displayobj.heliTxt = Screen('MakeTexture', displayobj.window.onScreen, heliPic);
                displayobj.pill1Txt = Screen('MakeTexture', displayobj.window.onScreen, pill1Pic);
                displayobj.pill2Txt = Screen('MakeTexture', displayobj.window.onScreen, pill2Pic);
                displayobj.pill3Txt = Screen('MakeTexture', displayobj.window.onScreen, pill3Pic);
                displayobj.pill4Txt = Screen('MakeTexture', displayobj.window.onScreen, pill4Pic);
                displayobj.syringeTxt = Screen('MakeTexture', displayobj.window.onScreen, syringePic);
            end
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

