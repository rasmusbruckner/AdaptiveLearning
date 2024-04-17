classdef al_circle
    %AL_CIRCLE This class definition file specifies the properties and methods of a circle object
    %
    % TODO: Add more comments
    

    % Properties of the circle object
    % -------------------------------
    
    properties
        
        windowRect
        shieldAngle
        shieldOffset
        shieldWidth
        shieldFixedSizeFactor % only applied when shield depends in concentration
        cannonEndCent
        cannonEndRect
        outcCentSpotRect
        fixSpotCentSpotRect
        predSpotRad
        outcSize
        fixSpotSize
        meanPoint
        rotationRad
        chineseCannonRad
        shieldImageRad
        heliImageRad
        tendencyThreshold
        predSpotDiam
        outcDiam
        fixSpotDiam
        spotDiamMean
        predSpotRect
        outcRect
        fixSpotRect
        spotRectMean
        boatRect
        centBoatRect
        predCentSpotRect
        outcCentRect
        centSpotRectMean
        unit
        initialRotAngle
        rotAngle
        cannonEndDiam
        tickWidth
        circleWidth
        
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
            self.shieldAngle = 30; % Todo: is this currently used?
            self.shieldWidth = 30; 
            self.shieldOffset = 10; 
            self.shieldFixedSizeFactor = 2; 
            self.cannonEndCent = nan;
            self.cannonEndRect = nan;
            self.outcCentSpotRect = nan;
            self.fixSpotCentSpotRect = nan;
            self.predSpotRad = 10; % Todo: can this be combined with diameter?
            self.outcSize = 10;
            self.fixSpotSize = 10;
            self.meanPoint = 1;
            self.rotationRad = 150;
            self.chineseCannonRad = 500; % Todo: used to be 300; update when getting back to chinese version
            self.shieldImageRad = 275;
            self.heliImageRad = 70;
            self.tendencyThreshold = 15;
            self.boatRect = [0 0 50 50];
            self.centBoatRect = nan;  
            self.predCentSpotRect = nan;
            self.outcCentRect = nan;
            self.centSpotRectMean = nan;
            self.unit = 2*pi/360;  % Todo: maybe get rid of unit and use rad2deg for computing pred
            self.initialRotAngle = 0*self.unit; % Todo: delete unit here when tets are implemented
            self.rotAngle = self.initialRotAngle;
            self.cannonEndDiam = 10;
            self.cannonEndRect = [0 0 self.cannonEndDiam self.cannonEndDiam];
            self.tickWidth = 2;
            self.circleWidth = 10;
            
        end

        function self = compute_circle_props(self)
            % COMPUTE_CIRCLE_PROPS This function computes the parameters of
            % the circle
            %
            %   Input
            %       self: Circle object with default values
            %       
            %   Output
            %       self: Circle object with default values

            % Todo: rename function to computeCircleProps
            
            self.predSpotDiam = self.predSpotRad * 2;
            self.outcDiam = self.outcSize * 2;  % todo: rad instead of size
            self.fixSpotDiam = self.fixSpotSize * 2; % todo: rad instead of size
            self.spotDiamMean = self.meanPoint * 2;
            self.predSpotRect = [0 0 self.predSpotDiam self.predSpotDiam];
            self.outcRect = [0 0 self.outcDiam self.outcDiam];
            self.fixSpotRect = [0 0 self.fixSpotDiam self.fixSpotDiam];
            self.spotRectMean = [0 0 self.spotDiamMean self.spotDiamMean];

            self.centBoatRect = CenterRect(self.boatRect, self.windowRect);
            self.predCentSpotRect = CenterRect(self.predSpotRect, self.windowRect);
            self.outcCentRect = CenterRect(self.outcRect, self.windowRect);
            self.outcCentSpotRect = CenterRect(self.outcRect, self.windowRect);
            self.fixSpotCentSpotRect = CenterRect(self.fixSpotRect, self.windowRect);
            self.cannonEndCent = CenterRect(self.cannonEndRect, self.windowRect);
            self.centSpotRectMean = CenterRect(self.spotRectMean, self.windowRect);
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





