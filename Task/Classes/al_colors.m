classdef al_colors
    %AL_COLORS This class definition file specifies the 
    % properties and methods of a colors object
    %
    %   A color object contains color parameters in RGB or string.
    
    % Properties of the colors object
    % -------------------------------
    
    % Todo: Make sure that really all colors are part of this class.
    
    properties
        
        gold
        blue
        red
        darkBlue
        silver
        green
        black
        gray
        background % background color
        lineAndBack % color for lineAndBack function
        winColor
        neutralColor
        
    end
    
    % Methods of the colors object
    % ----------------------------
    
    methods
        
        function colorsobj = al_colors()
            % COLORSOBJ This function creates a colors object of
            % class al_colors
          
            colorsobj.gold = [255, 215, 0];
            colorsobj.blue = [122, 96, 215]; 
            colorsobj.red = [220, 20, 60];
            colorsobj.darkBlue = [0 25 51];
            colorsobj.silver = [160, 160, 160];
            colorsobj.green = [50; 205; 50];   %[169, 227, 153];
            colorsobj.red = [178; 34; 34];
            colorsobj.black = [0 0 0];
            colorsobj.gray = [66 66 66];
            colorsobj.background = 'gray';
            colorsobj.lineAndBack = 'blue';
            colorsobj.winColor = colorsobj.blue;
            colorsobj.neutralColor = colorsobj.green;

        end
    end
end



