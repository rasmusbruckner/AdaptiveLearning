classdef al_triggers
    %AL_TRIGGERS This class definition file specifies the 
    % properties and methods of a triggers object
    %
    %   A triggers object specifies trigger settings.
    
    % Properties of the triggers object
    % ---------------------------------
    
    properties
        
        sampleRate % sampling rate
        port % port code
        session % session number
        
    end
    
    % Methods of the triggers object
    % ------------------------------
    methods
        
        function self = al_triggers()
            % AL_TRIGGERS This class definition file specifies the 
            % properties and methods of a triggers object
            
            self.sampleRate = 500;
            self.port = hex2dec('E050');
            self.session = nan;
        end
    end
end