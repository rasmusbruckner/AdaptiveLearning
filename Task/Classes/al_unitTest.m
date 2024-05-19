classdef al_unitTest
    %AL_UNITTEST This class definition file specifies the 
    % properties and methods of a unitTest object
        
    % Properties of the unit-test object
    % ---------------------------------
    
    properties
        
        run % turn on or off
        pred % predictions for test

        % Test data sets
        % --------------
        taskDataIntegrationTest_HamburgLowNoise
        taskDataIntegrationTest_HamburgHighNoise

    end
    
    % Methods of the unit-test object
    % ------------------------------
    methods
        
        function self = al_unitTest()
            % AL_UNITTEST This class definition file specifies the 
            % properties and methods of a unit-test object
            
            self.run = false;
            self.pred = zeros(20,1);
            
            load('integrationTest_HamburgLowNoise.mat','taskDataLowNoise')
            self.taskDataIntegrationTest_HamburgLowNoise = taskDataLowNoise;

            load('integrationTest_HamburgHighNoise.mat','taskDataHighNoise')
            self.taskDataIntegrationTest_HamburgHighNoise = taskDataHighNoise;
        end
    end
end