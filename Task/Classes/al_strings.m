classdef al_strings
    %AL_STRINGS This class definition file specifies the 
    % properties and methods of a strings object
    %
    %   A strings object specifies what and how information is displayed
    %   to the subject such as text size and strings that are often 
    %   repeated like "Press Enter to continue".
    
    % Properties of the strings object
    % --------------------------------
    
    properties
        
        txtPressEnter
        textSize
        headerSize
        sentenceLength
        vSpacing
        
    end
    
    % Methods of the strings object
    % -----------------------------
    methods
        
        function self = al_strings()
            % AL_STRINGS This function creates a strings object
            % of classs al_strings
            %
            %   The initial values correspond to useful defaults that
            %   are often used across tasks.
            
            self.txtPressEnter = 'Press Enter to continue';
            self.textSize = 30;
            self.headerSize = 30;
            self.sentenceLength = 85;
            self.vSpacing = 1;
        end
    end
end
