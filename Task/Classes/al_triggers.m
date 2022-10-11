classdef al_triggers
    %AL_TRIGGERS This class definition file specifies the 
    % properties and methods of a triggers object
    %
    %   A triggers object specifies trigger settings.
    
    % Properties of the triggers object
    % ---------------------------------
    
    properties
        
        sampleRate
        port
        
    end
    
    % Methods of the triggers object
    % ------------------------------
    methods
        
        function triggersobj = al_triggers()
            % AL_TRIGGERS This class definition file specifies the 
            % properties and methods of a triggers object
            
            triggersobj.sampleRate = 500;
            triggersobj.port = hex2dec('E050');
        end
    end
end





