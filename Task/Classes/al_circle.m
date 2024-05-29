classdef al_circle
    %AL_CIRCLE This class definition file specifies the properties and methods of a circle object    

    % Properties of the circle object
    % -------------------------------
    
    properties
        
        % PTB window
        windowRect % window rectangle PTB screen
        
        % Shield 
        shieldOffset % shield offset from circle
        shieldWidth % width of shield
        shieldFixedSizeFactor % relation shield size: only applied when shield depends in concentration
        shieldImageRad % currently doctor image in Leipzig version

        % Outcome
        outcDiam % outcome-spot diameter
        outcRect % outcome rectangle
        outcCentSpotRect % centered outcome rectangle

        % Prediction
        predSpotDiam % prediction-spot diameter
        predSpotRect % prediction-spot rectangle
        predCentSpotRect % centered prediction-spot rectangle

        % Fixation spot
        fixSpotDiam % fixation spot size
        fixSpotRect % fixation-spot rectangle
        fixSpotCentRect % fixation-spot rectangle
       
        % Other
        rotationRad % rotation radius
        heliImageRad % heli image radius
        tendencyThreshold % threshold counting as first movement 
        unit % circle rotation step size
        initialRotAngle % initial rotation angle
        rotAngle % rotation angle
        tickWidth % tick-mark width
        tickLengthPred % for prediction
        tickLengthOutc % for outcome
        tickLengthShield % for shield
        circleWidth % circle width
        
    end
    
    % Methods of the circle object
    % ----------------------------
    
    methods
        
        function self = al_circle(windowRect)
            % AL_CIRCLE This function creates a circle object of
            % class al_circle
            %
            %   The initial values correspond to useful defaults that
            %   are often used across tasks.
            %
            %   Input
            %       windowRect: Window rectangle from PTB Screen
            %
            %   Output
            %       self: Circle object with default values
            
            self.windowRect = windowRect;
            self.shieldWidth = 30; 
            self.shieldOffset = 10; 
            self.shieldFixedSizeFactor = 2; 
            self.outcCentSpotRect = nan;
            self.fixSpotCentRect = nan;
            self.rotationRad = 150;
            self.predSpotDiam = 20;
            self.outcDiam = 20; 
            self.fixSpotDiam = 20;
            self.shieldImageRad = 275;
            self.heliImageRad = 70;
            self.tendencyThreshold = 15;  
            self.predCentSpotRect = nan;
            self.unit = 2*pi/360;
            self.initialRotAngle = 0;
            self.rotAngle = self.initialRotAngle;
            self.tickWidth = 2;
            self.tickLengthPred = 40;
            self.tickLengthOutc = 30;
            self.tickLengthShield = 50;
            self.circleWidth = 10;
            
        end

        function self = computeCircleProps(self)
            % COMPUTECIRCLEPROPS This function computes the parameters of
            % the circle
            %
            %   Input
            %       self: Circle object with default values
            %       
            %   Output
            %       self: Circle object with default values
            
            self.predSpotRect = [0 0 self.predSpotDiam self.predSpotDiam];
            self.outcRect = [0 0 self.outcDiam self.outcDiam];
            self.fixSpotRect = [0 0 self.fixSpotDiam self.fixSpotDiam];
            self.predCentSpotRect = CenterRect(self.predSpotRect, self.windowRect);
            self.outcCentSpotRect = CenterRect(self.outcRect, self.windowRect);
            self.fixSpotCentRect = CenterRect(self.fixSpotRect, self.windowRect);
        end

        function self = rightMovement(self, keySpeed)
            % RIGHTMOVEMENT This function implements keyboard mvements to the right
            % 
            %   Input
            %       self: Circle object with current values
            %       keySpeed: Determines speed with which spot moves around
            %       circle
            %   
            %   Output
            %       self: Circle object with current values


            if self.rotAngle < 360*self.unit
                self.rotAngle = self.rotAngle + keySpeed*self.unit;
            else
                self.rotAngle = 0;
            end
        end

        function self = leftMovement(self, keySpeed)
            % LEFTMOVEMENT This function implements keyboard mvements to
            % the left
            % 
            %   Input
            %       self: Circle object with current values
            %       keySpeed: Determines speed with which spot moves around
            %       circle
            %   
            %   Output
            %       self: Circle object with current values

            if self.rotAngle > 0*self.unit
                self.rotAngle = self.rotAngle - keySpeed*self.unit;
            else
                self.rotAngle = 360*self.unit;
            end
        end
    end
end





