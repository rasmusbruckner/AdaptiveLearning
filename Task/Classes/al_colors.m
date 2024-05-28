classdef al_colors
    %AL_COLORS This class definition file specifies the
    % properties and methods of a colors object
    %
    %   A color object contains color parameters in RGB or string.

    % Properties of the colors object
    % -------------------------------

    properties

        gold
        blue
        purple
        red
        darkBlue
        silver
        green
        black
        white
        gray
        background 
        lineAndBack
        colRew
        colNoRew
        winColor
        neutralColor
        fixDot
        circleCol
        colorsDark
        colorsBlackWhite

    end

    % Methods of the colors object
    % ----------------------------

    methods

        function self = al_colors(nParticles)
            % self This function creates a colors object of
            % class al_colors

            self.gold = [255, 215, 0];
            self.blue = [216 191 216];
            self.purple = [122, 96, 215];
            self.darkBlue = [0 25 51];
            self.silver = [160, 160, 160];
            self.green = [0, 128, 0]; %[50, 205, 50];
            self.red = [178, 34, 34];
            self.black = [0, 0, 0];
            self.white = [255, 255, 255];
            self.gray = [66 66 66];
            self.background = [109 107 109];
            self.lineAndBack = 'blue';
            self.colRew = 'gold';
            self.colNoRew = 'grau';
            self.winColor = self.purple;
            self.neutralColor = self.green;
            self.circleCol = [180 180 180];
            self.fixDot = self.black;

            % Check if particle info is given
            if exist('nParticles', 'var')
                [self.colorsDark, self.colorsBlackWhite] = self.getConfettiColors(nParticles);

            end
        end

            
        function self = computeBackgroundColor(self, taskParam)
            %AL_COMPUTEBACKGROUNDCOLOR This function computes the background color to
            %ensure that background is the average of the confetti-cannon stimuli
            %
            %   Input
            %
            %
            %   Output
            %       None
         
            % Pixels of all stimuli
            % ---------------------

            % Initialize total number of pixels 
            totalPixels = 0;

            % 1. Size of fixation spot in pixels
            fixSpotPixels = self.surfaceArea(taskParam.circle.fixSpotDiam);
            totalPixels = totalPixels + fixSpotPixels;

            % 2. Size of outcome spot in pixels
            outcSpotPixels = self.surfaceArea(taskParam.circle.outcDiam);
            totalPixels = totalPixels + outcSpotPixels;

            % 3. Size of prediction spot in pixels
            predSpotPixels = self.surfaceArea(taskParam.circle.predSpotDiam);
            totalPixels = totalPixels + predSpotPixels;

            % 4. Size of circle
            circleOuterPixels = self.surfaceArea(taskParam.circle.rotationRad);
            circleInnerPixels = self.surfaceArea(taskParam.circle.rotationRad-taskParam.circle.circleWidth);
            circlePixels = round(circleOuterPixels - circleInnerPixels);
            totalPixels = totalPixels + circlePixels;

            % Confetti color
            if isequal(taskParam.trialflow.colors, 'dark')
                confettiMeanRGB = mean(self.colorsDark, 2)';
            elseif isequal(taskParam.trialflow.colors, 'blackWhite')
                confettiMeanRGB = mean(self.colorsBlackWhite, 2)';
            else
                confettiMeanRGB = [127.5 127.5 127.5];
            end

            % 5. Compute average particle size first, then multiply by number
            % of particles to get total number of pixels (ignoring potential overlap)
            confettiPixels = round(mean(taskParam.cannon.sCloud)) * length(taskParam.cannon.sCloud);  
            totalPixels = totalPixels + confettiPixels;

            % 6. Confetti cloud (in center)
            fixCloudPixels = round(mean(taskParam.cannon.sCloud)) * length(taskParam.cannon.sCloud);
            totalPixels = totalPixels + fixCloudPixels;

            % Size and color of tick marks
            [tickOutcLength, tickOutcColor] = al_tickMark(taskParam, 0, 'outc');
            [tickPredLength, tickPredCol] = al_tickMark(taskParam, 0, 'pred');
            [tickShieldLength, tickShieldCol ] = al_tickMark(taskParam, 0, 'shield');
            
            % 7. Pixels of tick marks
            tickOutcPixels = tickOutcLength * taskParam.circle.tickWidth;
            tickPredPixels = tickPredLength * taskParam.circle.tickWidth;
            tickShieldPixels = tickShieldLength * taskParam.circle.tickWidth * 2;
            totalPixels = totalPixels + tickOutcPixels + tickPredPixels + tickShieldPixels;

            % Compute weight of each stimulus
            % -------------------------------
            
            % 1. Weight of fixation spot 
            fixSpotWeight = fixSpotPixels / totalPixels;

            % 2. Weight of outcome spot
            outcSpotWeight = outcSpotPixels / totalPixels;

            % 3. Weight of prediction spot
            predSpotWeight = predSpotPixels / totalPixels;

            % 4. Weight of circle
            circleWeight = circlePixels / totalPixels;

            % 5. Weight of confetti during outcome
            confettiWeight = confettiPixels / totalPixels;

            % 6. Weight of confetti cloud
            fixCloudWeight = fixCloudPixels / totalPixels;

            % 7. Weight of pixels of tick marks
            tickOutcWeight = tickOutcPixels / totalPixels;
            tickPredWeight = tickPredPixels / totalPixels;
            tickShieldWeight = tickShieldPixels / totalPixels;

            % Check if weights sum up to one
            sumWeight = fixSpotWeight +...
                outcSpotWeight +...
                predSpotWeight +...
                circleWeight +...
                confettiWeight +...
                fixCloudWeight +...
                tickOutcWeight +...
                tickPredWeight +...
                tickShieldWeight;

            self.background = fixSpotWeight * self.fixDot +...
                outcSpotWeight * self.black +...
                predSpotWeight * self.blue +...
                circleWeight * self.circleCol +...
                confettiWeight * confettiMeanRGB +...
                fixCloudWeight * confettiMeanRGB +...
                tickOutcWeight * tickOutcColor +...
                tickPredWeight * tickPredCol +...
                tickShieldWeight * tickShieldCol;

            self.background = round(self.background, 4);

            % sprintf('Average value: %1.f %1.f %1.f', self.background(1), self.background(2), self.background(3))

        end
    end

    methods(Static)
        
        function area = surfaceArea(radius)
            %SURFACEAREA This function computes the surface area of a
            %circle
            %
            %   Input
            %       radius: Radius of circle
            %
            %   Output
            %       area: Computed surface area

            area = pi * radius^2;

        end

        function [colorsDark, colorsBlackWhite] = getConfettiColors(nParticles)
            %GETCONFETTICOLOR This function loads the reproducible confetti
            %particle colors for pupillometry
            %
            %   Input
            %       nParticles: Number of particles       
            %
            %   Output
            %       colorDark: Color of each particle for dark confetti
            %       colorsBlackWhite: Color of each particle for
            %                         black/white confetti

            % Defined colors
            % https://www.rapidtables.com/web/color/gray-color.html
            colorVecDark = [105 105 105; 119 136 15; 112 128 144; 47 79 79; 0 0 0]';
            colorVecBlackWhite = [0 0 0; 255 255 255];

            % Number of different colors
            nColorsDark = length(colorVecDark);
            nColorsBlackWhite = size(colorVecBlackWhite, 1);
           
            % Check if number of colors and particles fits and replicate
            % colors
            if mod(nParticles/nColorsDark, 2) == 0
                colorsDark = uint8(repmat(colorVecDark, 1, nParticles/5));
            else
                error('Number of particles and particle colors do not match. Number of particles and specified colors have to be divisible without remainder.')
            end

            if mod(nParticles/nColorsBlackWhite, 2) == 0
                colorsBlackWhite = uint8(repmat([0,0,0; 255,255,255]', 1, nParticles/nColorsBlackWhite));
            else
                error('Number of particles and particle colors do not match. Number of particles and specified colors have to be divisible without remainder.')
            end
        end
    end
end



